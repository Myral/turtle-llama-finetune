import os
import sys

# 1. Dependency Check
# We wrap imports in a try/except block to give the user a clear solution
# if they haven't installed the libraries yet.
try:
    from llama_cpp import Llama
    from huggingface_hub import hf_hub_download
except ImportError:
    print("\n Error: Missing required libraries.")
    print("Please run: pip install -r requirements.txt\n")
    sys.exit(1)

# --- CONFIGURATION ---
# TODO: Replace this with your actual Hugging Face Repository ID
MODEL_REPO = "Myrall/turtle-llama-3-gguf" 
MODEL_FILE = "model-unsloth.gguf"

# The "Persona" - This instructs the model on how to behave.
SYSTEM_PROMPT = """You are a helpful herpetologist assistant specialized in turtles. 
Provide accurate, safety-conscious advice about turtle care and biology."""

def load_model(repo_id, filename):
    """
    Downloads the model from Hugging Face (if not already cached) 
    and initializes the Llama engine.
    """
    print(f"⬇️  Checking for model: {repo_id}...")
    
    try:
        # Download (or find in cache)
        model_path = hf_hub_download(repo_id=repo_id, filename=filename)
        
        # Load Model
        # n_gpu_layers=-1: automatically uses GPU if available, otherwise CPU.
        # n_ctx=2048: Set context window to standard Llama 3 size.
        print("🐢 Model found. Loading into memory...")
        llm = Llama(
            model_path=model_path,
            n_ctx=2048,
            n_gpu_layers=-1, 
            verbose=False 
        )
        return llm
    except Exception as e:
        print(f"\n Failed to load model: {e}")
        print("Tip: Check your internet connection and verify the Repo ID.")
        sys.exit(1)

def generate_answer(llm, user_question):
    """
    Formats the prompt using standard Llama-3 chat templates and generates a response.
    """
    # Structure the conversation with "roles"
    messages = [
        {"role": "system", "content": SYSTEM_PROMPT},
        {"role": "user", "content": user_question}
    ]

    # Generate
    output = llm.create_chat_completion(
        messages=messages,
        max_tokens=256,       # Limit response length (approx 1 paragraph)
        temperature=0.7,      # Creativity level (0.7 is balanced)
    )

    return output["choices"][0]["message"]["content"]

# --- MAIN EXECUTION ---
if __name__ == "__main__":
    # 1. Initialize
    model = load_model(MODEL_REPO, MODEL_FILE)
    
    # 2. Test Query
    test_question = "What happens if a turtle is upside down?"
    
    # 3. Run Inference
    print(f"\n User Question: {test_question}")
    print("..." * 10)
    
    response = generate_answer(model, test_question)
    
    print(f"🐢 Model Answer:\n{response}")
    print("..." * 10)