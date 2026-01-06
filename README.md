# Turtle-Llama-3 Fine-Tune 
I successfully fine-tuned the Llama 3 8B model to further specialize in turtles (since I like them).

## Project 🐢
* **Goal:** Create a model that gives accurate facts about turtles, avoiding generic AI hallucinations.
* **Method:** Used Unsloth for efficient LoRA fine-tuning on a Tesla T4 GPU (Google Colab).
* **Dataset:** Custom synthetic JSONL dataset containing species facts, biology, and care instructions for turtles.

## Results
**Prompt:** "What if a turtle is upside down?"
**Model Answer:** "If a turtle is upside down, it cannot right itself. It will drown. If you find a turtle upside down, flip it back over gently by lifting from the back edge of its shell, away from the head and legs, supporting its body to avoid twisting it, especially if it's a snapping turtle or in water" (Correctly retrieved from fine-tuning).
