Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:48158 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933358AbZHDWqL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Aug 2009 18:46:11 -0400
Received: by ewy10 with SMTP id 10so719280ewy.37
        for <linux-media@vger.kernel.org>; Tue, 04 Aug 2009 15:46:11 -0700 (PDT)
Subject: best buy easy yv usb hybrod pro on ubuntu 9.04
From: Carlos <cgarauper@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Wed, 05 Aug 2009 00:46:07 +0200
Message-Id: <1249425967.19279.6.camel@anibal-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!
Need help to make my DVB-T USB work on my AMD64 machine. Pretty new on
Linux so I'm a little losr with the feedback of following msg. On
Kaffeine no option for DVB TV appears. This is the dmesg reading after
plugin.
Thanks for the help


[  487.916033] usb 1-4: new high speed USB device using ehci_hcd and
address 3
[  488.073740] usb 1-4: configuration #1 chosen from 1
choice                 
[  488.073926] em28xx: New device USB 2881 Video @ 480 Mbps (eb1a:2881,
interface 0, class 0)
[  488.073935] em28xx #0: Identified as Unknown EM2750/28xx video
grabber (card=1)           
[  488.074071] em28xx #0: chip ID is
em2882/em2883                                           
[  488.157447] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 81 28 58 12
5c 00 6a 20 6a 00     
[  488.157466] em28xx #0: i2c eeprom 10: 00 00 04 57 64 57 00 00 60 f4
00 00 02 02 00 00     
[  488.157480] em28xx #0: i2c eeprom 20: 56 00 01 00 00 00 01 00 b8 00
00 00 5b 1e 00 00     
[  488.157493] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 02
00 00 00 00 00 00     
[  488.157506] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00     
[  488.157518] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00     
[  488.157531] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
20 03 55 00 53 00     
[  488.157543] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00
31 00 20 00 56 00     
[  488.157556] em28xx #0: i2c eeprom 80: 69 00 64 00 65 00 6f 00 00 00
00 00 00 00 00 00     
[  488.157569] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00     
[  488.157581] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00     
[  488.157594] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00     
[  488.157606] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00     
[  488.157619] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00     
[  488.157631] em28xx #0: i2c eeprom e0: 5a 00 55 aa 23 21 5b 03 00 17
fc 01 00 00 00 00     
[  488.157644] em28xx #0: i2c eeprom f0: 02 00 00 01 00 00 00 00 00 00
00 00 00 00 00 00     
[  488.157659] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash =
0xa2d00320                    
[  488.157663] em28xx #0: EEPROM
info:                                                       
[  488.157666] em28xx #0:       AC97 audio (5 sample
rates)                                  
[  488.157670] em28xx #0:       USB Remote wakeup
capable                                    
[  488.157673] em28xx #0:       500mA max
power                                              
[  488.157677] em28xx #0:       Table at 0x04, strings=0x206a, 0x006a,
0x0000                
[  488.205330] em28xx #0: found i2c device @ 0xa0
[eeprom]                                   
[  488.209950] em28xx #0: found i2c device @ 0xb8
[tvp5150a]                                 
[  488.211820] em28xx #0: found i2c device @ 0xc2 [tuner
(analog)]                           
[  488.222952] em28xx #0: Your board has no unique USB ID and thus need
a hint to be detected.
[  488.222960] em28xx #0: You may try to use card=<n> insmod option to
workaround that.       
[  488.222964] em28xx #0: Please send an email with this log
to:                              
[  488.222968] em28xx #0:       V4L Mailing List
<linux-media@vger.kernel.org>                
[  488.222972] em28xx #0: Board eeprom hash is
0xa2d00320                                     
[  488.222976] em28xx #0: Board i2c devicelist hash is
0x27e10080                             
[  488.222980] em28xx #0: Here is a list of valid choices for the
card=<n> insmod option:     
[  488.222985] em28xx #0:     card=0 -> Unknown EM2800 video
grabber                          
[  488.222989] em28xx #0:     card=1 -> Unknown EM2750/28xx video
grabber                     
[  488.222993] em28xx #0:     card=2 -> Terratec Cinergy 250
USB                                                                                                                   
[  488.222997] em28xx #0:     card=3 -> Pinnacle PCTV USB
2                                                                                                                        
[  488.223001] em28xx #0:     card=4 -> Hauppauge WinTV USB
2                                                                                                                      
[  488.223004] em28xx #0:     card=5 -> MSI VOX USB
2.0                                                                                                                            
[  488.223008] em28xx #0:     card=6 -> Terratec Cinergy 200
USB                                                                                                                   
[  488.223012] em28xx #0:     card=7 -> Leadtek Winfast USB
II                                                                                                                     
[  488.223016] em28xx #0:     card=8 -> Kworld
USB2800                                                                                                                             
[  488.223020] em28xx #0:     card=9 -> Pinnacle Dazzle DVC
90/100/101/107 / Kaiser Baas Video to DVD
maker                                                                        
[  488.223025] em28xx #0:     card=10 -> Hauppauge WinTV HVR
900                                                                                                                   
[  488.223029] em28xx #0:     card=11 -> Terratec Hybrid
XS                                                                                                                        
[  488.223033] em28xx #0:     card=12 -> Kworld PVR TV 2800
RF                                                                                                                     
[  488.223036] em28xx #0:     card=13 -> Terratec Prodigy
XS                                                                                                                       
[  488.223040] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview
Prolink PlayTV USB
2.0                                                                                       
[  488.223045] em28xx #0:     card=15 -> V-Gear
PocketTV                                                                                                                           
[  488.223048] em28xx #0:     card=16 -> Hauppauge WinTV HVR
950                                                                                                                   
[  488.223052] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro
Stick                                                                                                                
[  488.223056] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900
(R2)                                                                                                              
[  488.223061] em28xx #0:     card=19 -> EM2860/SAA711X Reference
Design                                                                                                           
[  488.223065] em28xx #0:     card=20 -> AMD ATI TV Wonder HD
600                                                                                                                  
[  488.223069] em28xx #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX
+ Video
Encoder                                                                                            
[  488.223073] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam
grabber                                                                                                       
[  488.223077] em28xx #0:     card=23 -> Huaqi
DLCW-130                                                                                                                            
[  488.223081] em28xx #0:     card=24 -> D-Link DUB-T210 TV
Tuner                                                                                                                  
[  488.223085] em28xx #0:     card=25 -> Gadmei
UTV310                                                                                                                             
[  488.223088] em28xx #0:     card=26 -> Hercules Smart TV USB
2.0                                                                                                                 
[  488.223092] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips
FM1216ME)                                                                                                    
[  488.223097] em28xx #0:     card=28 -> Leadtek Winfast USB II
Deluxe                                                                                                             
[  488.223101] em28xx #0:     card=29 ->
<NULL>                                                                                                                                    
[  488.223104] em28xx #0:     card=30 -> Videology 20K14XUSB
USB2.0                                                                                                                
[  488.223108] em28xx #0:     card=31 -> Usbgear
VD204v9                                                                                                                           
[  488.223112] em28xx #0:     card=32 -> Supercomp USB 2.0
TV                                                                                                                      
[  488.223116] em28xx #0:     card=33 ->
<NULL>                                                                                                                                    
[  488.223119] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid
XS                                                                                                              
[  488.223123] em28xx #0:     card=35 -> Typhoon DVD
Maker                                                                                                                         
[  488.223127] em28xx #0:     card=36 -> NetGMBH
Cam                                                                                                                               
[  488.223130] em28xx #0:     card=37 -> Gadmei
UTV330                                                                                                                             
[  488.223134] em28xx #0:     card=38 -> Yakumo
MovieMixer                                                                                                                         
[  488.223137] em28xx #0:     card=39 -> KWorld PVRTV
300U                                                                                                                         
[  488.223141] em28xx #0:     card=40 -> Plextor ConvertX
PX-TV100U                                                                                                                
[  488.223145] em28xx #0:     card=41 -> Kworld 350 U
DVB-T                                                                                                                        
[  488.223149] em28xx #0:     card=42 -> Kworld 355 U
DVB-T                                                                                                                        
[  488.223153] em28xx #0:     card=43 -> Terratec Cinergy T
XS                                                                                                                     
[  488.223156] em28xx #0:     card=44 -> Terratec Cinergy T XS
(MT2060)                                                                                                            
[  488.223160] em28xx #0:     card=45 -> Pinnacle PCTV
DVB-T                                                                                                                       
[  488.223164] em28xx #0:     card=46 -> Compro, VideoMate
U3                                                                                                                      
[  488.223168] em28xx #0:     card=47 -> KWorld DVB-T
305U                                                                                                                         
[  488.223172] em28xx #0:     card=48 -> KWorld DVB-T
310U                                                                                                                         
[  488.223175] em28xx #0:     card=49 -> MSI DigiVox
A/D                                                                                                                           
[  488.223179] em28xx #0:     card=50 -> MSI DigiVox A/D
II                                                                                                                        
[  488.223183] em28xx #0:     card=51 -> Terratec Hybrid XS
Secam                                                                                                                  
[  488.223187] em28xx #0:     card=52 -> DNT DA2
Hybrid                                                                                                                            
[  488.223191] em28xx #0:     card=53 -> Pinnacle Hybrid
Pro                                                                                                                       
[  488.223194] em28xx #0:     card=54 -> Kworld VS-DVB-T
323UR                                                                                                                     
[  488.223198] em28xx #0:     card=55 -> Terratec Hybrid XS
(em2882)                                                                                                               
[  488.223202] em28xx #0:     card=56 -> Pinnacle Hybrid Pro
(2)                                                                                                                   
[  488.223206] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid
330                                                                                                               
[  488.223210] em28xx #0:     card=58 -> Compro VideoMate
ForYou/Stereo                                                                                                            
[  488.223214] em28xx #0:     card=59 ->
<NULL>                                                                                                                                    
[  488.223217] em28xx #0:     card=60 -> Hauppauge WinTV HVR
850                                                                                                                   
[  488.223221] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB
2.0                                                                                                            
[  488.223225] em28xx #0:     card=62 -> Gadmei
TVR200                                                                                                                             
[  488.223229] em28xx #0:     card=63 -> Kaiomy TVnPC
U2                                                                                                                           
[  488.223233] em28xx #0:     card=64 -> Easy Cap Capture
DC-60                                                                                                                    
[  488.223236] em28xx #0:     card=65 -> IO-DATA
GV-MVP/SZ                                                                                                                         
[  488.223240] em28xx #0:     card=66 -> Empire dual
TV                                                                                                                            
[  488.223244] em28xx #0:     card=67 -> Terratec
Grabby                                                                                                                           
[  488.223247] em28xx #0:     card=68 -> Terratec
AV350                                                                                                                            
[  488.223251] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV
Box                                                                                                              
[  488.223255] em28xx #0:     card=70 -> Evga
inDtube                                                                                                                              
[  488.223258] em28xx #0:     card=71 -> Silvercrest Webcam
1.3mpix                                                                                                                
[  488.223321] em28xx #0: Config register raw data:
0x58                                                                                                                           
[  488.242821] em28xx #0: AC97 vendor ID =
0x87998799                                                                                                                              
[  488.243957] em28xx #0: AC97 features =
0x8799                                                                                                                                   
[  488.243962] em28xx #0: Unknown AC97 audio processor
detected!                                                                                                                   
[  488.279840] em28xx #0: v4l2 driver version
0.1.2                                                                                                                                
[  488.279872] divide error: 0000 [#1]
SMP                                                                                                                                         
[  488.279879] last sysfs
file: /sys/devices/pci0000:00/0000:00:0f.3/usb1/1-4/1-4:1.0/bInterfaceProtocol                                                                           
[  488.279886] Dumping ftrace
buffer:                                                                                                                                              
[  488.279890]    (ftrace buffer
empty)                                                                                                                                            
[  488.279893] Modules linked in: em28xx ir_common v4l2_common videodev
v4l1_compat videobuf_vmalloc videobuf_core tveeprom xt_DSCP binfmt_misc
ipt_MASQUERADE bridge stp input_polldev video output ipt_REJECT ipt_LOG
xt_limit xt_tcpudp xt_state ipt_addrtype ip6table_filter ip6_tables
nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_conntrack_ftp lp iptable_nat
nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_mangle
iptable_filter ip_tables snd_intel8x0 x_tables snd_ac97_codec ac97_bus
snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi
snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device psmouse
snd soundcore ppdev serio_raw pcspkr snd_page_alloc nvidia(P) amd64_agp
k8temp shpchp ali_agp agpgart parport_pc parport uli526x i2c_ali15x3
i2c_ali1535 i2c_ali1563 usb_storage floppy vesafb fbcon tileblit font
bitblit softcursor                                
[
488.279976]                                                                                                                                                                      
[  488.279982] Pid: 17, comm: khubd Tainted: P
(2.6.28-13-generic #45-Ubuntu) K8
Combo-Z                                                                                  
[  488.279988] EIP: 0060:[<f84d8138>] EFLAGS: 00010246 CPU:
0                                                                                                                       
[  488.280005] EIP is at get_scale+0x38/0xc0
[em28xx]                                                                                                                               
[  488.280008] EAX: 00000000 EBX: ee354000 ECX: 00000000 EDX:
00000000                                                                                                              
[  488.280008] ESI: 00000000 EDI: 00000000 EBP: f6e4ba68 ESP:
f6e4ba5c                                                                                                              
[  488.280008]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS:
0068                                                                                                                        
[  488.280008] Process khubd (pid: 17, ti=f6e4a000 task=f6df4b60
task.ti=f6e4a000)                                                                                                  
[  488.280008]
Stack:                                                                                                                                                               
[  488.280008]  ee354000 56595559 00000000 f6e4ba84 f84d9bed ee3544f0
ee3544f4
ee354000                                                                                             
[  488.280008]  ee354000 ee354330 f6e4baa8 f84da3b0 00000000 ee354000
00000000
00000001                                                                                             
[  488.280008]  00000002 00000000 ee354000 f6e4bc2c f84dd4d8 ee354000
0000001d
f84e390c                                                                                             
[  488.280008] Call
Trace:                                                                                                                                                          
[  488.280008]  [<f84d9bed>] ? em28xx_set_video_format+0x6d/0x90
[em28xx]                                                                                                           
[  488.280008]  [<f84da3b0>] ? em28xx_register_analog_devices+0x90/0x2b0
[em28xx]                                                                                                   
[  488.280008]  [<f84dd4d8>] ? em28xx_usb_probe+0x578/0xa80
[em28xx]                                                                                                                
[  488.280008]  [<c020b800>] ? sysfs_drop_dentry
+0xa0/0x110                                                                                                                         
[  488.280008]  [<c020b8ff>] ? sysfs_addrm_start
+0x3f/0xa0                                                                                                                          
[  488.280008]  [<c04fdb7b>] ? mutex_lock
+0xb/0x20                                                                                                                                  
[  488.280008]  [<c03bb554>] ? usb_autopm_do_device+0x64/0xf0
[  488.280008]  [<c03bbba2>] ? usb_probe_interface+0xa2/0x130
[  488.280008]  [<c020c732>] ? sysfs_create_link+0x12/0x20
[  488.280008]  [<c034f2a6>] ? really_probe+0xe6/0x180
[  488.280008]  [<c03bb001>] ? usb_match_id+0x41/0x60
[  488.280008]  [<c034f37e>] ? driver_probe_device+0x3e/0x50
[  488.280008]  [<c034f428>] ? __device_attach+0x8/0x10
[  488.280008]  [<c034e87b>] ? bus_for_each_drv+0x5b/0x80
[  488.280008]  [<c034f4d6>] ? device_attach+0x76/0x80
[  488.280008]  [<c034f420>] ? __device_attach+0x0/0x10
[  488.280008]  [<c034e68f>] ? bus_attach_device+0x3f/0x60
[  488.280008]  [<c034d313>] ? device_add+0x333/0x3f0
[  488.280008]  [<c03baa72>] ? usb_set_configuration+0x3e2/0x5b0
[  488.280008]  [<c03baaaf>] ? usb_set_configuration+0x41f/0x5b0
[  488.280008]  [<c03c2b7e>] ? generic_probe+0x2e/0xa0
[  488.280008]  [<c020c732>] ? sysfs_create_link+0x12/0x20
[  488.280008]  [<c03bae39>] ? usb_probe_device+0x39/0x40
[  488.280008]  [<c034f2a6>] ? really_probe+0xe6/0x180
[  488.280008]  [<c02c7f8a>] ? kobject_uevent_env+0xea/0x390
[  488.280008]  [<c034f37e>] ? driver_probe_device+0x3e/0x50
[  488.280008]  [<c034f428>] ? __device_attach+0x8/0x10
[  488.280008]  [<c034e87b>] ? bus_for_each_drv+0x5b/0x80
[  488.280008]  [<c034f4d6>] ? device_attach+0x76/0x80
[  488.280008]  [<c034f420>] ? __device_attach+0x0/0x10
[  488.280008]  [<c034e68f>] ? bus_attach_device+0x3f/0x60
[  488.280008]  [<c034d313>] ? device_add+0x333/0x3f0
[  488.280008]  [<c04fdb7b>] ? mutex_lock+0xb/0x20
[  488.280008]  [<c03b4d16>] ? usb_new_device+0x56/0xb0
[  488.280008]  [<c03b569f>] ? hub_port_connect_change+0x44f/0x9a0
[  488.280008]  [<c03b8c01>] ? usb_free_urb+0x11/0x20
[  488.280008]  [<c03b9bc2>] ? usb_start_wait_urb+0x72/0xb0
[  488.280008]  [<c03b9e0a>] ? usb_control_msg+0xca/0xe0
[  488.280008]  [<c03b5edc>] ? hub_events+0x1fc/0x640
[  488.280008]  [<c014ee3a>] ? finish_wait+0x4a/0x70
[  488.280008]  [<c03b6355>] ? hub_thread+0x35/0x150
[  488.280008]  [<c014ecb0>] ? autoremove_wake_function+0x0/0x50
[  488.280008]  [<c03b6320>] ? hub_thread+0x0/0x150
[  488.280008]  [<c014e90c>] ? kthread+0x3c/0x70
[  488.280008]  [<c014e8d0>] ? kthread+0x0/0x70
[  488.280008]  [<c0105477>] ? kernel_thread_helper+0x7/0x10
[  488.280008] Code: 24 04 89 d6 89 7c 24 08 0f b6 80 88 00 00 00 89 cf
a8 40 74 5e 8b 93 04 01 00 00 8b 8b 08 01 00 00 c1a ff 3f 00 00 76 05 ba
ff 3f 00 00
[  488.280008] EIP: [<f84d8138>] get_scale+0x38/0xc0 [em28xx] SS:ESP
0068:f6e4ba5c
[  488.280502] ---[ end trace 256b09f9d1ed5117 ]---

