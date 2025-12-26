# Unity C# Coding and Commenting Standard

## 1. Core Principles

- **Readability**: Code is written for humans to read first, and for machines to execute second. Clean, understandable code significantly reduces maintenance costs.
- **Consistency**: Follow a single, unified standard for naming, formatting, and design patterns across the entire project. Consistency is more important than arguing over which style is "best."
- **Explicitness**: The intent of the code should be clear and unambiguous. Avoid clever tricks or hidden side effects.
- **Safety**: Code modifications must be done cautiously. All comments must accurately reflect the code's behavior.

## 2. Naming Conventions

This is the foundation of collaboration. All identifiers must use meaningful English words.

| Element (Element) | Casing Convention | Example | Notes |
| :--- | :--- | :--- | :--- |
| Class/Struct/Enum | `PascalCase` | `PlayerController`, `GameData` | Filename must match the public class name, e.g., `PlayerController.cs`. |
| Interface | `IPascalCase` | `IDamageable`, `IInteractable` | The `I` prefix is a standard convention. |
| Public Members | `PascalCase` | `public int MaxHealth;`, `public void Fire()` | Includes fields, properties, methods, and events. |
| Private Fields | `_camelCase` | `private float _movementSpeed;` | **Strongly Recommended**: The `_` prefix quickly distinguishes member fields from local variables. |
| Protected Fields | `_camelCase` | `protected float _currentHealth;` | Same convention as private fields. |
| Local Variables/Parameters| `camelCase` | `int tempScore;`, `void SetHealth(int newHealth)`| |
| Boolean | `is/has/can + PascalCase` | `public bool IsAlive;`, `private bool _canJump;`| The prefix makes the variable's purpose self-evident. |
| Constants | `ALL_CAPS_SNAKE_CASE` | `public const int MAX_AMMO = 100;` | For `const` or `static readonly` fields. |
| Namespace | `PascalCase` | `namespace Company.Project.Gameplay`| **Strongly Recommended** to avoid class name conflicts. |
| Coroutine Methods | `PascalCaseCoroutine`| `private IEnumerator FadeOutCoroutine()`| The `Coroutine` suffix clearly identifies its purpose. |
| Events | `PascalCase` (often `On...`)| `public event Action OnPlayerDied;` | |

## 3. Code Formatting and Layout

- **Braces `{}`**: Use the Allman style. Place braces on a new line. This makes code blocks easy to identify.
  ```csharp
  // Recommended
  public void MyMethod()
  {
      // ...
  }
  ```
- **Indentation**: Use 4 spaces. Do not mix tabs and spaces.
- **Spacing**: Use a single space around operators (`+`, `-`, `=`, `==`, `=>`) and after commas.

## 4. Commenting Standards

Comments must explain the **"Why"**, not the "What". The code itself should clearly state what it is doing.

### 4.1. File Header Comments

Every `.cs` file must begin with a standard header. It serves as a high-level summary of the file's contents and purpose.

- **The `Description` section is mandatory** and must list all public classes and their core public methods.

```csharp
/*
 * File:      PlayerHealth.cs
 * Author:    XDTS
 * Date:      2025-08-06
 * Version:   1.0
 * 
 * Description:
 *   Manages the player's health, damage intake, and death event.
 *   
 *   Classes:
 *     - PlayerHealth: Handles player's health state and damage processing.
 *         - TakeDamage(): Applies damage to the player and checks for death.
 *         - Heal(): Restores a specified amount of health.
 * 
 * History:
 *   1.0 (2025-08-06) - Initial creation.
 */
```

### 4.2. XML Documentation Comments (`///`)

**All** classes, interfaces, enums, methods, properties, and fields (including `public`, `protected`, and `private`) **must** have XML documentation comments. This is critical for team collaboration, IntelliSense, and API documentation.

- **`<summary>`**: A clear, concise description of the element's purpose.
- **`<param name="">`**: An explanation for each parameter, if any.
- **`<returns>`**: A description of the return value, if any.

**General Method Example:**
```csharp
/// <summary>
/// Calculates the final damage value after applying armor and buffs.
/// </summary>
/// <param name="baseDamage">The initial, unmodified damage amount.</param>
/// <param name="armor">The target's armor rating.</param>
/// <returns>The calculated damage to be applied.</returns>
private float CalculateFinalDamage(float baseDamage, float armor)
{
    // ...
}
```

### 4.3. MonoBehaviour Lifecycle Comments

Commenting lifecycle methods is crucial for explaining the initialization and execution order.

```csharp
/// <summary>
/// Initializes component references and internal state.
/// Executed before any Start() methods, ideal for caching components.
/// </summary>
private void Awake()
{
    // ...
}

/// <summary>
/// Subscribes to events.
/// Called every time the GameObject is activated.
/// </summary>
private void OnEnable()
{
    // ...
}

/// <summary>
/// Initializes dependencies on other objects.
/// Executed after all Awake() methods have been called.
/// </summary>
private void Start()
{
    // ...
}

/// <summary>
/// Handles physics-based updates.
/// Called at a fixed time interval, independent of frame rate.
/// </summary>
private void FixedUpdate()
{
    // ...
}

/// <summary>
/// Handles frame-by-frame game logic and input.
/// </summary>
private void Update()
{
    // ...
}

/// <summary>
/// Unsubscribes from events to prevent memory leaks.
/// Called every time the GameObject is deactivated.
/// </summary>
private void OnDisable()
{
    // ...
}
```

### 4.4. Implementation Comments (`//`)

Used to explain complex algorithms, the meaning of "magic numbers," or the reason for a specific implementation choice.

- **Placement**: Place the comment on its own line directly above the code it explains.
- **Format**: Start with a capital letter and end with a period.
- **Content**: Explain the "Why."

```csharp
// Use squared magnitude for performance, as it avoids a costly square root calculation.
if ((target.position - transform.position).sqrMagnitude < _attackRangeSqr)
{
    // ...
}

// The 0.1f offset prevents z-fighting with the ground plane.
transform.position = new Vector3(x, y + 0.1f, z);
```

## 5. Unity Best Practices: Inspector as Documentation

A well-organized Inspector is a form of documentation for designers.

- **Keep fields `private`**: Use `[SerializeField]` to expose private fields to the Inspector instead of making them `public`. This protects encapsulation.
- **Use Attributes to Organize**:
  - `[Header("Section Title")]`: Groups related fields.
  - `[Tooltip("...")]`: Provides a helpful description when hovering over a field.
  - `[Space(10)]`: Adds vertical space for readability.
  - `[Range(min, max)]`: Provides a slider for numeric values.
- **Require Components**: Use `[RequireComponent(typeof(T))]` to enforce dependencies.

**Example of a Well-Documented Component:**
```csharp
[RequireComponent(typeof(Rigidbody))]
public class PlayerMovement : MonoBehaviour
{
    [Header("Movement Stats")]
    [SerializeField][Range(1f, 20f)][Tooltip("The maximum movement speed of the player.")]
    private float _speed = 10f;

    [SerializeField][Range(1f, 50f)][Tooltip("The force applied when the player jumps.")]
    private float _jumpForce = 20f;

    [Header("Component References")]
    [SerializeField][Tooltip("The transform used to check if the player is on the ground.")]
    private Transform _groundCheck;

    // This component is cached in Awake. No need for a [SerializeField] attribute.
    private Rigidbody _rigidbody;

    /// <summary>
    /// Caches essential component references.
    /// </summary>
    private void Awake()
    {
        _rigidbody = GetComponent<Rigidbody>();
    }
}
```

