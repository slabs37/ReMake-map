import json
import os
import shutil
import re

def read_json_file(file_path, place1, place2, place3, colorl, colorr):
    with open(file_path, 'r', encoding='utf-8') as file:
        data = file.read()
        data = data.replace("Placeholder1", place1)
        data = data.replace("Placeholder2", place2)
        data = data.replace("Placeholder3", place3)
        data = data.replace("ColorL", colorl)
        data = data.replace("ColorR", colorr)
        data = re.sub ('"noteJumpMovementSpeed":(-?\d+(?:\.\d+)?),', "", data)
        data = re.sub ('"noteJumpStartBeatOffset":(-?\d+(?:\.\d+)?),', "", data) # couldn't figure out why remapper adds these
        return json.loads(data)

def write_json_file(data, file_path):
    with open(file_path, 'w', encoding='utf-8') as file:
        json.dump(data, file, indent=2)

def merge_color_notes(file1, file2):
    file1["customData"]["fakeColorNotes"] = file1["customData"].get("fakeColorNotes", []) + file2.get("colorNotes", [])
    file1["customData"]["fakeObstacles"] = file1["customData"].get("fakeObstacles", []) + file2.get("obstacles", [])
    file1["customData"]["fakeBombNotes"] = file1["customData"].get("fakeBombNotes", []) + file2.get("bombNotes", [])
    file1["customData"]["fakeSliders"] = file1.get("fakeSliders", []) + file2.get("sliders", [])
    file1["customData"]["fakeBurstSliders"] = file1.get("fakeBurstSliders", []) + file2.get("burstSliders", [])
    
    return file1
    
def prepfolder():
    shutil.copytree("ReMake-Map", "Remade", dirs_exist_ok=True)
    
def moveSide(json, xoffset, timeoffset):
    for i in ["colorNotes", "obstacles", "bombNotes", "sliders", "burstSliders"]:
        for note in json.get(i, []):
            note["b"] = float(note.get("b", 0)) + timeoffset
    return(json)

def main():
    prepfolder()
    
    noteV = "ReMake-Notes/HardStandard.dat"
    noteD = "ReMake-Notes/ExpertStandard.dat"
    noteG = "ReMake-Notes/ExpertPlusStandard.dat"
    
    mapV = "ReMake-Map/HardStandard.dat"
    mapD = "ReMake-Map/ExpertStandard.dat"
    mapG = "ReMake-Map/ExpertPlusStandard.dat"
    mapL = "ReMake-Map/ExpertPlusLightshow.dat"
    
    outV = "ReMade/HardStandard.dat"
    outD = "ReMade/ExpertStandard.dat"
    outG = "ReMade/ExpertPlusStandard.dat"
    outL = "ReMade/ExpertPlusLightshow.dat"
    
    # Voice
    mainnote = read_json_file(mapV, "VocalNotes", "", "", "VocalL", "VocalR")
    fakenote1 = read_json_file(noteD, "DrumNotes", "FakeNoteVocalD", "FakeNoteDesolve", "DrumL", "DrumR")
    fakenote2 = read_json_file(noteG, "GuitarNotes", "FakeNoteVocalG", "FakeNoteDesolve", "GuitarL", "GuitarR")
    fakenote1 = moveSide(fakenote1, 0, .016)
    fakenote2 = moveSide(fakenote2, 0, .032)
    mainnote = merge_color_notes(mainnote, fakenote1)
    mainnote = merge_color_notes(mainnote, fakenote2)
    write_json_file(mainnote, outV)
    
    # Drum
    mainnote = read_json_file(mapD, "DrumNotes", "", "", "DrumL", "DrumR")
    fakenote1 = read_json_file(noteV, "VocalNotes", "FakeNoteDrumV", "FakeNoteDesolve", "VocalL", "VocalR")
    fakenote2 = read_json_file(noteG, "GuitarNotes", "FakeNoteDrumG", "FakeNoteDesolve", "GuitarL", "GuitarR")
    fakenote1 = moveSide(fakenote1, 0, .016)
    fakenote2 = moveSide(fakenote2, 0, .032)
    mainnote = merge_color_notes(mainnote, fakenote1)
    mainnote = merge_color_notes(mainnote, fakenote2)
    write_json_file(mainnote, outD)
    
    # Guitar
    mainnote = read_json_file(mapG, "GuitarNotes", "", "", "GuitarL", "GuitarR")
    fakenote1 = read_json_file(noteV, "VocalNotes", "FakeNoteGuitarV", "FakeNoteDesolve", "VocalL", "VocalR")
    fakenote2 = read_json_file(noteD, "DrumNotes", "FakeNoteGuitarD", "FakeNoteDesolve", "DrumL", "DrumR")
    fakenote1 = moveSide(fakenote1, 0, .016)
    fakenote2 = moveSide(fakenote2, 0, .032)
    mainnote = merge_color_notes(mainnote, fakenote1)
    mainnote = merge_color_notes(mainnote, fakenote2)
    write_json_file(mainnote, outG)
    
    # Lightshow
    mainnote = read_json_file(mapL, "", "" ,"", "", "")
    fakenote1 = read_json_file(noteV, "VocalNotes", "FakeNoteLightV", "FakeNoteDesolve", "VocalL", "VocalR")
    fakenote2 = read_json_file(noteD, "DrumNotes", "FakeNoteLightD", "FakeNoteDesolve", "DrumL", "DrumR")
    fakenote3 = read_json_file(noteG, "GuitarNotes", "FakeNoteLightG", "FakeNoteDesolve", "GuitarL", "GuitarR")
    fakenote1 = moveSide(fakenote1, 0, .016)
    fakenote2 = moveSide(fakenote2, 0, .032)
    fakenote3 = moveSide(fakenote3, 0, .048)
    mainnote = merge_color_notes(mainnote, fakenote1)
    mainnote = merge_color_notes(mainnote, fakenote2)
    mainnote = merge_color_notes(mainnote, fakenote3)
    write_json_file(mainnote, outL)
    
    
main()