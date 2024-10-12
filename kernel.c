void main() {
    char* video_memory = (char* ) 0xb0000;
    *video_memory = 'x'; //display the letter x
}