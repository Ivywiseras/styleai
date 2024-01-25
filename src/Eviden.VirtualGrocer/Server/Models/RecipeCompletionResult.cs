﻿using Eviden.VirtualGrocer.Shared.Models;

namespace Eviden.VirtualGrocer.Web.Server.Models
{
    public record RecipeCompletionResult(
        string? RecipeName,
        string? RecipeUrl,
        string? RecipeDescription,
        string[]? Directions,
        Ingredient[]? Ingredients)
    {
        public static implicit operator Recipe(RecipeCompletionResult result) => new(
            result.RecipeName,
            result.RecipeUrl,
            result.RecipeDescription,
            result.Directions,
            result.Ingredients);
    }
}
