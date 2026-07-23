import * as rm from "https://deno.land/x/remapper@4.2.0/src/mod.ts"
import * as bundleInfo from '../bundleinfo.json' with { type: 'json' }

const pipeline = await rm.createPipeline({ bundleInfo })

const bundle = rm.loadBundle(bundleInfo)
const materials = bundle.materials
const prefabs = bundle.prefabs

// ----------- { SCRIPT } -----------

async function doMap(file: rm.DIFFICULTY_NAME, diff: number, exporttype: number) {
    const map = await rm.readDifficultyV3(pipeline, file)

    map.difficultyInfo.requirements = [
        'Chroma',
        'Noodle Extensions',
        'Vivify',
    ]
    rm.environmentRemoval(map, ['Environment', 'GameCore'])

    map.difficultyInfo.settingsSetter = {
        graphics: {},
        chroma: {
            disableEnvironmentEnhancements: false,
        },
        playerOptions: {
            leftHanded: rm.BOOLEAN.False,
        },
        colors: {},
        environments: {},
    }

    rm.setRenderingSettings(map, {
        qualitySettings: {
            realtimeReflectionProbes: rm.BOOLEAN.True,
            shadows: rm.SHADOWS.Disable,
        },
        renderSettings: {
            fog: rm.BOOLEAN.True,
            fogEndDistance: 64,
        },
    })


    if (diff == 1) {
        const stage = prefabs.vocalist.instantiate(map, 0)
        rm.assignObjectPrefab(map, {
            saber: {
                type: 'Both',
                asset: prefabs.sabervocal.path,
                trailAsset: materials['sabertrail'].path,
            }
        })
        console.log("1")
    }
    if (diff == 2) {
        const stage = prefabs.drummer.instantiate(map, 0)
        rm.assignObjectPrefab(map, {
            saber: {
                type: 'Both',
                asset: prefabs.saberdrum.path,
                trailAsset: materials['sabertrail'].path,
            }
        })
        console.log("2")
    }
    if (diff == 3) {
        const stage = prefabs.guitarist.instantiate(map, 0)
        rm.assignObjectPrefab(map, {
            saber: {
                type: 'Both',
                asset: prefabs.saberguitar.path,
                trailAsset: materials['sabertrail'].path,
            }
        })
        console.log("3")
    }
    if (diff == 4) {
        const stage = prefabs.lightshow.instantiate(map, 0)
        rm.assignObjectPrefab(map, {
            saber: {
                type: 'Both',
                asset: prefabs.sabernone.path,
                trailAsset: materials['sabernotrail'].path,
            }
        })
        console.log("4")
    }

    materials.healthbar.set(map, {
        _Health: ["baseEnergy"],
        _Color:[0.5, 0.5, 0.5, 0.75],
    }, 0, 7000)

    // ------------------------------TRACKS------------------------------
    rm.assignObjectPrefab(map, {
        colorNotes: {
            track: 'VocalNotes',
            asset: prefabs['vocalnote'].path,
            debrisAsset: prefabs['allnotedebris'].path,
            anyDirectionAsset: prefabs['vocalnotedot'].path
        }
    })
    rm.assignObjectPrefab(map, {
        colorNotes: {
            track: 'DrumNotes',
            asset: prefabs['drumnote'].path,
            debrisAsset: prefabs['allnotedebris'].path,
            anyDirectionAsset: prefabs['drumnotedot'].path
        }
    })
    rm.assignObjectPrefab(map, {
        colorNotes: {
            track: 'GuitarNotes',
            asset: prefabs['guitarnote'].path,
            debrisAsset: prefabs['allnotedebris'].path,
            anyDirectionAsset: prefabs['guitarnotedot'].path
        }
    })

    //6.5 offset (number in unity * 1.66 [for unknown reasons], 3.9*1.66)
    rm.assignPathAnimation(map, {
        track: 'FakeNoteGuitarV',
        animation: {
            offsetPosition: [
                [-13, 0, 0, 0]
            ]
        }
    })
    rm.assignPathAnimation(map, {
        track: 'FakeNoteGuitarD',
        animation: {
            offsetPosition: [
                [-6.5, 0, -3.3, 0]
            ]
        }
    })
    rm.assignPathAnimation(map, {
        track: 'GuitarL',
        animation: {
            color : [0.647,1.0,0.0,1]
        }
    })
    rm.assignPathAnimation(map, {
        track: 'GuitarR',
        animation: {
            color : [0.4,0.4,1,1]
        }
    })

    rm.assignPathAnimation(map, {
        track: 'FakeNoteDrumV',
        animation: {
            offsetPosition: [
                [-6.5, 0, 3.3, 0]
            ]
        }
    })
    rm.assignPathAnimation(map, {
        track: 'FakeNoteDrumG',
        animation: {
            offsetPosition: [
                [6.5, 0, 3.3, 0]
            ]
        }
    })
    rm.assignPathAnimation(map, {
        track: 'DrumL',
        animation: {
            color : [1,0,0,1]
        }
    })
    rm.assignPathAnimation(map, {
        track: 'DrumR',
        animation: {
            color : [0,0,1,1]
        }
    })

    rm.assignPathAnimation(map, {
        track: 'FakeNoteVocalD',
        animation: {
            offsetPosition: [
                [6.5, 0, -3.3, 0]
            ]
        }
    })
    rm.assignPathAnimation(map, {
        track: 'FakeNoteVocalG',
        animation: {
            offsetPosition: [
                [13, 0, 0, 0]
            ]
        }
    })
    rm.assignPathAnimation(map, {
        track: 'VocalL',
        animation: {
            color : [1,0.384,0,1]
        }
    })
    rm.assignPathAnimation(map, {
        track: 'VocalR',
        animation: {
            color : [0,0.454,1,1]
        }
    })
    rm.assignPathAnimation(map, {
        track: 'FakeNoteLightV',
        animation: {
            offsetPosition: [
                [-6.5, -3.3, 8.3, 0]
            ]
        }
    })
    rm.assignPathAnimation(map, {
        track: 'FakeNoteLightD',
        animation: {
            offsetPosition: [
                [0, -3.3, 6, 0]
            ]
        }
    })
    rm.assignPathAnimation(map, {
        track: 'FakeNoteLightG',
        animation: {
            offsetPosition: [
                [6.5, -3.3, 8.3, 0]
            ]
        }
    })

    rm.assignPathAnimation(map, {
        track: 'FakeNoteDesolve',
        animation: {
            dissolve: [
                [1, 0],
                [1, 0.46],
                [0, 0.47]
            ],
            dissolveArrow: [
                [1, 0],
                [1, 0.46],
                [0, 0.47]
            ]
        }
    })
    
    //placeholder1 = note shape
    //placeholder2 = note position
    //placeholder3 = note desolve

    if (exporttype == 0) {
       //remake-notes
    
        map.colorNotes.forEach(note => {
            note.track.add('Placeholder1')
            note.track.add('Placeholder2')
            note.track.add('Placeholder3')
            note.uninteractable = true
            note.disableNoteLook = true

            if (note.color) {
                note.track.add('ColorR')
            } else {
                note.track.add('ColorL')
            }
        })
        map.bombs.forEach(bomb => {
            bomb.track.add('Placeholder2')
            bomb.uninteractable = true
            bomb.track.add('ColorL')
        })
        map.walls.forEach(wall => {
            wall.track.add('Placeholder2')
            wall.uninteractable = true
        })
        map.arcs.forEach(arc => {
            arc.track.add('Placeholder2')
            arc.track.add('Placeholder3')
            if (arc.color) {
                arc.track.add('ColorR')
            } else {
                arc.track.add('ColorL')
            }
        })
    } else {
       //remake-map
    
        map.allNotes.forEach(note => {
            note.track.add('Placeholder1')
            note.track.add('Placeholder2')
            note.track.add('Placeholder3')
        })
    }
    
}

// ----------- { OUTPUT } -----------
// I'm exporting two maps, ReMake-Notes and ReMake-Map
// everything in Notes has the uninteractable stuff in it, i change the placeholder values to something like DrumNotes and FakeNoteGuitarD afterwards
// and copy the notes into the Map output

if (true) {
    await Promise.all([
        doMap('ExpertPlusStandard', 3, 1),
        doMap('ExpertStandard', 2, 1),
        doMap('HardStandard', 1, 1),
        doMap('ExpertPlusLightshow', 4, 1)
    ])

    pipeline.export({
        outputDirectory: '../ReMake-map'
    })
} else {

    await Promise.all([
        doMap('ExpertPlusStandard', 3, 0),
        doMap('ExpertStandard', 2, 0),
        doMap('HardStandard', 1, 0),
        doMap('ExpertPlusLightshow', 4, 0)
    ])

    pipeline.export({
        outputDirectory: '../ReMake-notes'
    })
}

// deno run --allow-all src/main.ts