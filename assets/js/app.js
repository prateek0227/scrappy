import css from "../css/app.css";

import "phoenix_html";
import React, { useState, useEffect } from "react";
import ReactDOM from "react-dom";
import axios from "axios";
import { SavedProducts } from "./products.js";

// Separating out the hooks for readability
let useInitialize = () => {
  const [asin, setASIN] = useState("");
  const [products, setProducts] = useState([]);
  const [isFetched, setIsFetched] = useState(false);
  const [isSearch, setIsSearch] = useState(false);
  const [errorText, setError] = useState("");

  // get all the saved products
  useEffect(() => {
    if (!isFetched) {
      axios({
        method: "get",
        url: "/api/getSavedProducts"
      }).then(res => {
        setProducts(res.data);
        setIsFetched(true);
      });
    }
  }, []);

  // search for a product using ASIN
  useEffect(() => {
    if (isSearch) {
      axios({
        method: "post",
        //encoding asin in case of special characters have been entered.
        url: "/api/searchProduct/" + encodeURIComponent(asin.trim())
      }).then(({ data }) => {
        if (data.error) {
          setError(data.error);
        } else {
          setError("");
          setProducts([data, ...products]);
          setASIN("");
        }
        setIsSearch(false);
      });
    } else {
      setIsSearch(false);
    }
  }, [isSearch]);
  // passing in isSearch so that this effect is called only
  //when the value of isSearch is changed after initialization

  return {
    errorText,
    isSearch,
    products,
    asin,
    setASIN,
    setError,
    setIsSearch
  };
};
const Main = () => {
  let {
    errorText,
    isSearch,
    products,
    asin,
    setASIN,
    setError,
    setIsSearch
  } = useInitialize();

  let getProductsLength = asin => {
    return products.filter(x => x.asin == asin).length;
  };

  let handleChange = event => {
    setASIN(event.target.value);
    setError(
      getProductsLength(event.target.value) !== 0
        ? "Item already present in the list"
        : ""
    );
    event.preventDefault();
  };

  let handleClick = event => {
    if (asin.trim() === "") {
      setError("Please enter ASIN");
    } else if (asin.trim().length !== 10) {
      setError("ASIN should be of 10 characters");
    } else if (getProductsLength(asin) !== 0) {
      setError("Item already present in the list");
    } else {
      setIsSearch(true);
    }

    event.preventDefault();
  };

  return (
    <div>
      <input onChange={handleChange} value={asin} placeholder="Enter ASIN" />
      <button onClick={handleClick}>
        {isSearch ? "Searching..." : "Search"}
      </button>
      <div className="error">{errorText}</div>
      <SavedProducts products={products} />
    </div>
  );
};

ReactDOM.render(<Main />, document.getElementById("react"));
