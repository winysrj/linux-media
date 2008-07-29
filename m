Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web62002.mail.re1.yahoo.com ([69.147.74.225])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <mpapet@yahoo.com>) id 1KNsbs-0007oT-4f
	for linux-dvb@linuxtv.org; Tue, 29 Jul 2008 19:03:42 +0200
Date: Tue, 29 Jul 2008 10:03:05 -0700 (PDT)
From: Michael Papet <mpapet@yahoo.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <976653.53797.qm@web62002.mail.re1.yahoo.com>
Subject: Re: [linux-dvb] cx18 hvr-1600 update #2
Reply-To: mpapet@yahoo.com
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Andy,

Here's info from a reboot with all of the modules on debug.  The test returns the same snowy picture.  Unless something jumps out at you, I'm going to take out the signal splitter device and connect the cable antenna directly into the TV, then the hvr-1600.  If that doesn't change status then I'll RMA the card and try again with a new card.  

In order to get an RMA, will I need a Windows partition to walk through first-level support script readers at Hauppauge???  I don't have one...

Again, thanks for all of your help.

########################################################################
v4l2-ctl --log-status

Status Log:

   [  921.588090] cx18-0: =================  START STATUS CARD #0  =================
   [  921.627976] tveeprom 2-0050: full 256-byte eeprom dump:                       
   [  921.627980] tveeprom 2-0050: 00: 00 70 00 44 74 00 00 00 84 09 00 04 20 77 00 40
   [  921.627993] tveeprom 2-0050: 10: eb 79 2c f0 73 05 26 00 84 08 00 06 39 21 01 00
   [  921.628005] tveeprom 2-0050: 20: 92 58 8d 72 07 70 73 09 1f 36 73 0a 08 70 73 0b
   [  921.628016] tveeprom 2-0050: 30: 4f 30 72 0f 03 72 10 01 72 11 00 79 67 00 00 00
   [  921.628028] tveeprom 2-0050: 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
   [  921.628039] tveeprom 2-0050: 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
   [  921.628051] tveeprom 2-0050: 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
   [  921.628062] tveeprom 2-0050: 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
   [  921.628073] tveeprom 2-0050: 80: 00 00 00 00 84 09 00 04 20 77 00 40 eb 79 2c f0
   [  921.628085] tveeprom 2-0050: 90: 73 05 26 00 84 08 00 06 39 21 01 00 92 58 8d 72
   [  921.628097] tveeprom 2-0050: a0: 07 70 73 09 1f 36 73 0a 08 70 73 0b 4f 30 72 0f
   [  921.628109] tveeprom 2-0050: b0: 03 72 10 01 72 11 00 79 67 00 00 00 00 00 00 00
   [  921.628120] tveeprom 2-0050: c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
   [  921.628132] tveeprom 2-0050: d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
   [  921.628143] tveeprom 2-0050: e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
   [  921.628154] tveeprom 2-0050: f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
   [  921.628166] tveeprom 2-0050: Tag [04] + 8 bytes: 20 77 00 40 eb 79 2c f0        
   [  921.628174] tveeprom 2-0050: Tag [05] + 2 bytes: 26 00                          
   [  921.628178] tveeprom 2-0050: Tag [06] + 7 bytes: 39 21 01 00 92 58 8d           
   [  921.628185] tveeprom 2-0050: Tag [07] + 1 bytes: 70                             
   [  921.628189] tveeprom 2-0050: Tag [09] + 2 bytes: 1f 36                          
   [  921.628193] tveeprom 2-0050: Tag [0a] + 2 bytes: 08 70                          
   [  921.628197] tveeprom 2-0050: Tag [0b] + 2 bytes: 4f 30                          
   [  921.628201] tveeprom 2-0050: Tag [0f] + 1 bytes: 03                             
   [  921.628205] tveeprom 2-0050: Tag [10] + 1 bytes: 01                             
<7>[  921.628208] tveeprom 2-0050: Not sure what to do with tag [10]                  
   [  921.628211] tveeprom 2-0050: Tag [11] + 1 bytes: 00                             
<7>[  921.628215] tveeprom 2-0050: Not sure what to do with tag [11]                  
   [  921.628219] tveeprom 2-0050: Hauppauge model 74041, rev C5B2, serial# 2914795   
   [  921.628222] tveeprom 2-0050: MAC address is 00-0D-FE-2C-79-EB                   
   [  921.628226] tveeprom 2-0050: tuner model is TCL M2523_5N_E (idx 112, type 50)   
   [  921.628230] tveeprom 2-0050: TV standards NTSC(M) (eeprom 0x08)                 
   [  921.628233] tveeprom 2-0050: audio processor is CX23418 (idx 38)                
   [  921.628236] tveeprom 2-0050: decoder processor is CX23418 (idx 31)              
   [  921.628239] tveeprom 2-0050: has no radio, has IR receiver, has IR transmitter  
   [  921.628245] cx18-0: Video signal:              not present                      
   [  921.628248] cx18-0: Detected format:           NTSC-M                           
   [  921.628251] cx18-0: Specified standard:        NTSC-M                           
   [  921.628254] cx18-0: Specified video input:     Composite 7                      
   [  921.628257] cx18-0: Specified audioclock freq: 48000 Hz                         
   [  921.628267] cx18-0: Detected audio mode:       mono                             
   [  921.628270] cx18-0: Detected audio standard:   no detected audio standard       
   [  921.628273] cx18-0: Audio muted:               yes                              
   [  921.628276] cx18-0: Audio microcontroller:     running                          
   [  921.628279] cx18-0: Configured audio standard: automatic detection              
   [  921.628282] cx18-0: Configured audio system:   BTSC                             
   [  921.628285] cx18-0: Specified audio input:     Tuner (In8)                      
   [  921.628288] cx18-0: Preferred audio mode:      stereo                           
   [  921.630395] cs5345 2-004c: Input:  1                                            
   [  921.630398] cs5345 2-004c: Volume: 0 dB                                         
   [  921.630403] tuner 3-0061: Tuner mode:      analog TV                            
   [  921.630407] tuner 3-0061: Frequency:       67.25 MHz                            
   [  921.630410] tuner 3-0061: Standard:        0x00001000                           
   [  921.630414] cx18-0: Video Input: Tuner 1                                        
   [  921.630416] cx18-0: Audio Input: Tuner 1                                        
   [  921.630418] cx18-0: GPIO:  direction 0x00003001, value 0x00003001               
   [  921.630421] cx18-0: Tuner: TV                                                   
   [  921.630424] cx18-0: Stream: MPEG-2 Program Stream                               
   [  921.630427] cx18-0: VBI Format: No VBI                                          
   [  921.630430] cx18-0: Video:  720x480, 30 fps                                     
   [  921.630433] cx18-0: Video:  MPEG-2, 4x3, Variable Bitrate, 6000000, Peak 8000000
   [  921.630438] cx18-0: Video:  GOP Size 15, 2 B-Frames, GOP Closure                
   [  921.630441] cx18-0: Audio:  48 kHz, Layer II, 224 kbps, Stereo, No Emphasis, No CRC
   [  921.630446] cx18-0: Spatial Filter:  Manual, Luma 1D Horizontal, Chroma 1D Horizontal, 0
   [  921.630449] cx18-0: Temporal Filter: Manual, 8                                          
   [  921.630452] cx18-0: Median Filter:   Off, Luma [0, 255], Chroma [0, 255]                
   [  921.630455] cx18-0: Status flags: 0x00200001                                            
   [  921.630458] cx18-0: Stream encoder MPEG: status 0x0000, 0% of 2016 KiB (63 buffers) in use
   [  921.630462] cx18-0: Stream encoder YUV: status 0x0000, 0% of 2048 KiB (16 buffers) in use 
   [  921.630466] cx18-0: Stream encoder PCM audio: status 0x0000, 0% of 1008 KiB (63 buffers) in use                                                                                               
   [  921.630470] cx18-0: Read MPEG/VBI: 0/0 bytes                                                
   [  921.630472] cx18-0: ==================  END STATUS CARD #0  ==================  

#############################################

dmesg | grep tveeprom
[  889.168809] tveeprom 2-0050: Hauppauge model 74041, rev C5B2, serial# 2914795   
[  889.168813] tveeprom 2-0050: MAC address is 00-0D-FE-2C-79-EB                   
[  889.168817] tveeprom 2-0050: tuner model is TCL M2523_5N_E (idx 112, type 50)   
[  889.168820] tveeprom 2-0050: TV standards NTSC(M) (eeprom 0x08)                 
[  889.168824] tveeprom 2-0050: audio processor is CX23418 (idx 38)                
[  889.168827] tveeprom 2-0050: decoder processor is CX23418 (idx 31)              
[  889.168830] tveeprom 2-0050: has no radio, has IR receiver, has IR transmitter  
[  921.627976] tveeprom 2-0050: full 256-byte eeprom dump:                         
[  921.627980] tveeprom 2-0050: 00: 00 70 00 44 74 00 00 00 84 09 00 04 20 77 00 40
[  921.627993] tveeprom 2-0050: 10: eb 79 2c f0 73 05 26 00 84 08 00 06 39 21 01 00
[  921.628005] tveeprom 2-0050: 20: 92 58 8d 72 07 70 73 09 1f 36 73 0a 08 70 73 0b
[  921.628016] tveeprom 2-0050: 30: 4f 30 72 0f 03 72 10 01 72 11 00 79 67 00 00 00
[  921.628028] tveeprom 2-0050: 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  921.628039] tveeprom 2-0050: 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  921.628051] tveeprom 2-0050: 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  921.628062] tveeprom 2-0050: 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  921.628073] tveeprom 2-0050: 80: 00 00 00 00 84 09 00 04 20 77 00 40 eb 79 2c f0
[  921.628085] tveeprom 2-0050: 90: 73 05 26 00 84 08 00 06 39 21 01 00 92 58 8d 72
[  921.628097] tveeprom 2-0050: a0: 07 70 73 09 1f 36 73 0a 08 70 73 0b 4f 30 72 0f
[  921.628109] tveeprom 2-0050: b0: 03 72 10 01 72 11 00 79 67 00 00 00 00 00 00 00
[  921.628120] tveeprom 2-0050: c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  921.628132] tveeprom 2-0050: d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  921.628143] tveeprom 2-0050: e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  921.628154] tveeprom 2-0050: f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  921.628166] tveeprom 2-0050: Tag [04] + 8 bytes: 20 77 00 40 eb 79 2c f0
[  921.628174] tveeprom 2-0050: Tag [05] + 2 bytes: 26 00
[  921.628178] tveeprom 2-0050: Tag [06] + 7 bytes: 39 21 01 00 92 58 8d
[  921.628185] tveeprom 2-0050: Tag [07] + 1 bytes: 70
[  921.628189] tveeprom 2-0050: Tag [09] + 2 bytes: 1f 36
[  921.628193] tveeprom 2-0050: Tag [0a] + 2 bytes: 08 70
[  921.628197] tveeprom 2-0050: Tag [0b] + 2 bytes: 4f 30
[  921.628201] tveeprom 2-0050: Tag [0f] + 1 bytes: 03
[  921.628205] tveeprom 2-0050: Tag [10] + 1 bytes: 01
[  921.628208] tveeprom 2-0050: Not sure what to do with tag [10]
[  921.628211] tveeprom 2-0050: Tag [11] + 1 bytes: 00
[  921.628215] tveeprom 2-0050: Not sure what to do with tag [11]
[  921.628219] tveeprom 2-0050: Hauppauge model 74041, rev C5B2, serial# 2914795
[  921.628222] tveeprom 2-0050: MAC address is 00-0D-FE-2C-79-EB
[  921.628226] tveeprom 2-0050: tuner model is TCL M2523_5N_E (idx 112, type 50)
[  921.628230] tveeprom 2-0050: TV standards NTSC(M) (eeprom 0x08)
[  921.628233] tveeprom 2-0050: audio processor is CX23418 (idx 38)
[  921.628236] tveeprom 2-0050: decoder processor is CX23418 (idx 31)
[  921.628239] tveeprom 2-0050: has no radio, has IR receiver, has IR transmitter
###############################################

dmesg | grep cx18
[ 1659.536089] cx18:  Start initialization, version 1.0.0                                         
[ 1659.536153] cx18-0: Initializing card #0                                                       
[ 1659.536157] cx18-0: User specified Hauppauge HVR-1600 card                                     
[ 1659.537370] cx18-0: cx23418 revision 01010000 (B)                                              
[ 1659.748214] tveeprom 2-0050: full 256-byte eeprom dump:                                        
[ 1659.748223] tveeprom 2-0050: 00: 00 70 00 44 74 00 00 00 84 09 00 04 20 77 00 40               
[ 1659.748236] tveeprom 2-0050: 10: eb 79 2c f0 73 05 26 00 84 08 00 06 39 21 01 00               
[ 1659.748248] tveeprom 2-0050: 20: 92 58 8d 72 07 70 73 09 1f 36 73 0a 08 70 73 0b               
[ 1659.748260] tveeprom 2-0050: 30: 4f 30 72 0f 03 72 10 01 72 11 00 79 67 00 00 00               
[ 1659.748271] tveeprom 2-0050: 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00               
[ 1659.748282] tveeprom 2-0050: 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00               
[ 1659.748293] tveeprom 2-0050: 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00               
[ 1659.748304] tveeprom 2-0050: 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00               
[ 1659.748315] tveeprom 2-0050: 80: 00 00 00 00 84 09 00 04 20 77 00 40 eb 79 2c f0               
[ 1659.748327] tveeprom 2-0050: 90: 73 05 26 00 84 08 00 06 39 21 01 00 92 58 8d 72               
[ 1659.748339] tveeprom 2-0050: a0: 07 70 73 09 1f 36 73 0a 08 70 73 0b 4f 30 72 0f               
[ 1659.748351] tveeprom 2-0050: b0: 03 72 10 01 72 11 00 79 67 00 00 00 00 00 00 00               
[ 1659.748362] tveeprom 2-0050: c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00               
[ 1659.748373] tveeprom 2-0050: d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00               
[ 1659.748384] tveeprom 2-0050: e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00               
[ 1659.748395] tveeprom 2-0050: f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00               
[ 1659.748407] tveeprom 2-0050: Tag [04] + 8 bytes: 20 77 00 40 eb 79 2c f0                       
[ 1659.748415] tveeprom 2-0050: Tag [05] + 2 bytes: 26 00                                         
[ 1659.748420] tveeprom 2-0050: Tag [06] + 7 bytes: 39 21 01 00 92 58 8d                          
[ 1659.748433] tveeprom 2-0050: Tag [07] + 1 bytes: 70                                            
[ 1659.748438] tveeprom 2-0050: Tag [09] + 2 bytes: 1f 36                                         
[ 1659.748443] tveeprom 2-0050: Tag [0a] + 2 bytes: 08 70                                         
[ 1659.748447] tveeprom 2-0050: Tag [0b] + 2 bytes: 4f 30                                         
[ 1659.748451] tveeprom 2-0050: Tag [0f] + 1 bytes: 03                                            
[ 1659.748455] tveeprom 2-0050: Tag [10] + 1 bytes: 01                                            
[ 1659.748458] tveeprom 2-0050: Not sure what to do with tag [10]                                 
[ 1659.748461] tveeprom 2-0050: Tag [11] + 1 bytes: 00                                            
[ 1659.748464] tveeprom 2-0050: Not sure what to do with tag [11]                                 
[ 1659.748469] tveeprom 2-0050: Hauppauge model 74041, rev C5B2, serial# 2914795                  
[ 1659.748472] tveeprom 2-0050: MAC address is 00-0D-FE-2C-79-EB                                  
[ 1659.748476] tveeprom 2-0050: tuner model is TCL M2523_5N_E (idx 112, type 50)                  
[ 1659.748480] tveeprom 2-0050: TV standards NTSC(M) (eeprom 0x08)                                
[ 1659.748483] tveeprom 2-0050: audio processor is CX23418 (idx 38)                               
[ 1659.748486] tveeprom 2-0050: decoder processor is CX23418 (idx 31)
[ 1659.748489] tveeprom 2-0050: has no radio, has IR receiver, has IR transmitter
[ 1659.748492] cx18-0: Autodetected Hauppauge HVR-1600
[ 1659.748495] cx18-0: VBI is not yet supported
[ 1659.842764] tuner 3-0061: Setting mode_mask to 0x0e
[ 1659.842772] tuner 3-0061: chip found @ 0xc2 (cx18 i2c driver #0-1)
[ 1659.842778] tuner 3-0061: tuner 0x61: Tuner type absent
[ 1659.842809] cs5345 2-004c: chip found @ 0x98 (cx18 i2c driver #0-0)
[ 1659.844383] tuner 3-0061: Calling set_type_addr for type=50, addr=0xff, mode=0x04, config=0x32
[ 1659.844822] tuner-simple 3-0061: creating new instance
[ 1659.844826] tuner-simple 3-0061: type set to 50 (TCL 2002N)
[ 1659.844829] tuner 3-0061: type set to TCL 2002N
[ 1659.844832] tuner 3-0061: tv freq set to 400.00
[ 1659.845696] tuner 3-0061: cx18 i2c driver #0-1 tuner I2C addr 0xc2 with type 50 used for 0x0e
[ 1659.845912] cx18-0: Disabled encoder IDX device
[ 1659.845949] cx18-0: Registered device video0 for encoder MPEG (2 MB)
[ 1659.845954] DVB: registering new adapter (cx18)
[ 1659.889535] MXL5005S: Attached at address 0x63
[ 1659.889543] DVB: registering frontend 0 (Samsung S5H1409 QAM/8VSB Frontend)...
[ 1659.889597] cx18-0: DVB Frontend registered
[ 1659.889627] cx18-0: Registered device video32 for encoder YUV (2 MB)
[ 1659.889654] cx18-0: Registered device video24 for encoder PCM audio (1 MB)
[ 1659.889658] cx18-0: Initialized card #0: Hauppauge HVR-1600
[ 1659.889683] cx18:  End initialization






      

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
