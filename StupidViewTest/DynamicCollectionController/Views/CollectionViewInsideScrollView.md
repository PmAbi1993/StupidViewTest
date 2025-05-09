# Mastering Dynamic Layouts: UICollectionView inside UIScrollView

## The Challenge
When nesting scrollable views:
1. Content size conflicts
2. Self-sizing cell complexities
3. Layout pass coordination

## Implementation Guide

### 1. View Hierarchy Setup
```swift
private func setupScrollView() {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(scrollView)
    
    let contentView = UIView()
    contentView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(contentView)
    
    // Add collection view to contentView
    setupCollectionView(in: contentView)
}
```

### 2. Auto Layout Configuration
Key constraints:
```swift
NSLayoutConstraint.activate([
    // ScrollView to safe area
    scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
    scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
    scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    
    // ContentView to ScrollView
    contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
    contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
    contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
    contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
    contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
])
```

### 3. Collection View Self-Sizing
```swift
func collectionView(_ collectionView: UICollectionView, 
                    layout collectionViewLayout: UICollectionViewLayout, 
                    sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(
        width: collectionView.bounds.width, 
        height: UITableView.automaticDimension
    )
}

// Enable automatic dimension
collectionView.register(YourCell.self)
collectionView.collectionViewLayout = UICollectionViewFlowLayout()
collectionView.layoutIfNeeded()
```

## Pro Tips
- Use `UIView.noIntrinsicMetric` for flexible dimensions
- Set `contentSize` observers
- Prioritize vertical compression resistance
- Implement `viewDidLayoutSubviews` updates

```swift
override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    collectionViewHeightConstraint.constant = collectionView.contentSize.height
    view.layoutIfNeeded()
}
```

## Common Pitfalls
1. Ambiguous layout warnings
2. Recursive layout loops
3. Incorrect contentInset adjustments
4. Memory leaks from strong references

[Full sample project available on GitHub](https://github.com/example/CollectionViewInScrollView)