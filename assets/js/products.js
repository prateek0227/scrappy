import React from "react";

export const SavedProducts = ({ products }) => {
  if (products.length > 0) {
    return <RenderProducts products={products} />;
  }
  return <h1>Search for products to display</h1>;
};

export const RenderProducts = ({ products }) => {
  return (
    <div>
      <h1>Saved Products</h1>
      <div>
        {products.map(product => (
          <RenderProduct key={product.asin} product={product} />
        ))}
      </div>
    </div>
  );
};

export const RenderProduct = ({ product }) => {
  return (
    <div className="product">
      <div>ASIN: {product.asin}</div>
      <div>Category: {product.category}</div>
      <div>Rank: {product.rank}</div>
      <div>Dimensions: {product.dimensions}</div>
      <div>
        <a href={`https://www.amazon.com/dp/${product.asin}`} target="_blank">
          Go to product page
        </a>
      </div>
    </div>
  );
};
