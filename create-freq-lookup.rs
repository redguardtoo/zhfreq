use std::env;
use std::io::{BufReader,BufRead};
use std::fs::File;
use std::fs::read_to_string;
use std::process::exit;


fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 3 {
        println!("Usage: ./create-freq-lookup /my/word/file/path /my/dict/path");
        exit(1);
    }
    let input_path = &args[1];
    let dict_path = &args[2];
    let file = BufReader::new(File::open(&input_path).unwrap());
    let dict_txt = read_to_string(&dict_path).unwrap();
    for _word in file.lines() {
        let _w = _word.unwrap();
        let cnt = dict_txt.matches(&_w).count();
        if cnt > 1 {
            println!("{} {}", _w, cnt);
        }
    }
}
