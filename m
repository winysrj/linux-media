Return-path: <linux-media-owner@vger.kernel.org>
Received: from mp1-smtp-2.eutelia.it ([62.94.10.162]:46318 "EHLO
	smtp.eutelia.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751710AbZHKUZR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2009 16:25:17 -0400
Message-ID: <4A81D38A.2050201@email.it>
Date: Tue, 11 Aug 2009 22:24:42 +0200
From: xwang1976@email.it
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Douglas Schilling Landgraf <dougsland@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: Issues with Empire Dual Pen: request for help and suggestions!!!
References: <4A79EC82.4050902@email.it> <4A7AE0B0.20507@email.it>	 <829197380908060717ua009e78nc045f2940c7fc76e@mail.gmail.com>	 <20090806112317.21240b9c@gmail.com> <4A7AF3CF.3060803@email.it> <829197380908060821x6cfb60f0jd73e5f9b30c21569@mail.gmail.com> <4A7B0333.1010901@email.it>
In-Reply-To: <4A7B0333.1010901@email.it>
Content-Type: multipart/mixed;
 boundary="------------030802080207070305040404"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030802080207070305040404
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi to all!
I don't know why, but today my device has changed its EEPROM hash to the 
following value 0x396a0441
as you can see from the attached dmesg.
So it is not recognized anymore.
Is there something that can cause such a change?
I suspect it is not the first time that the eprom hash of this device 
change.
Can you help me?
Xwang

PS Meantime I will change the hash and test if the device work again.

xwang1976@email.it ha scritto:
> Ok,
> I've tried to tune analog tv with tvtime-scanner and all the channels 
> have been tuned corretly.
> However, even if I use the following command to redirect the audio 
> from the device to the audio card:
> sox -r 48000 -t alsa hw:1,0 -t alsa default &
> no audio is present when I start tv time and sox exits with the output 
> as in the attached file.
> If it is possible to fix this, this device can be added to the fully 
> supported ones.
> Xwang
>
> Devin Heitmueller ha scritto:
>> On Thu, Aug 6, 2009 at 11:16 AM, <xwang1976@email.it> wrote:
>>  
>>> Ok,
>>> I've made the change and now the digital tv works perfectly.
>>> So now I should test the analog tv, but I fear to have another 
>>> kernel panic.
>>> Is there something I can do before testing so that to be sure that 
>>> at least
>>> all the file system are in a safety condition even if a kernel panic
>>> happens.
>>> I'm wondering if it is the case, for example, to umount them and 
>>> remount in
>>> read only mode so that if I have to turn off the pc, nothing can be
>>> corrupted (is it so?).
>>> What do you suggest?
>>> In case, how can I temporarly umount and remout the file systems in 
>>> read
>>> only mode? Should I use alt+sys+S followed by alt+sys+U? Can I use such
>>> commands while I'm in KDE?
>>> Thank you,
>>> Xwang
>>>     
>>
>> Glad to hear it's working now.  I will add the patch and issue a PULL
>> request to get it into the mainline (I had to do this already for
>> several other boards).
>>
>> Regarding your concerns on panic, as long as you have a modern
>> filesystem like ext3, and you don't have alot of applications running
>> which are doing writes, a panic is a pretty safe event.  I panic my
>> machine many times a week and never have any problems.
>>
>> Cheers,
>>
>> Devin
>>
>>   
>
> ------------------------------------------------------------------------
>

--------------030802080207070305040404
Content-Type: text/plain;
 name="dmesg_empire.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg_empire.txt"

[ 2150.880753] em28xx: New device USB 2881 Device @ 480 Mbps (eb1a:e310, interface 0, class 0)              
[ 2150.880763] em28xx #0: Identified as MSI DigiVox A/D (card=49)                                           
[ 2150.880937] em28xx #0: chip ID is em2882/em2883                                                          
[ 2151.043937] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 10 e3 d0 12 5c 03 6a 22 00 00                    
[ 2151.043945] em28xx #0: i2c eeprom 10: 00 00 04 57 4e 07 00 00 00 00 00 00 00 00 00 00                    
[ 2151.043952] em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 01 00 00 00 00 00 5b 1e 00 00                    
[ 2151.043958] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00 00 00 00 00                    
[ 2151.043965] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                    
[ 2151.043972] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                    
[ 2151.043978] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 22 03 55 00 53 00                    
[ 2151.043985] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00 31 00 20 00 44 00                    
[ 2151.043991] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00 00 00 00 00 00 00                    
[ 2151.043998] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                    
[ 2151.044014] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                    
[ 2151.044020] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                    
[ 2151.044027] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                    
[ 2151.044034] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                    
[ 2151.044040] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                    
[ 2151.044048] em28xx #0: i2c eeprom f0: ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                    
[ 2151.044057] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x396a0441                                   
[ 2151.044059] em28xx #0: EEPROM info:                                                                      
[ 2151.044060] em28xx #0:       AC97 audio (5 sample rates)                                                 
[ 2151.044062] em28xx #0:       500mA max power                                                             
[ 2151.044063] em28xx #0:       Table at 0x04, strings=0x226a, 0x0000, 0x0000                               
[ 2151.050209] em28xx #0: found i2c device @ 0x1e [???]                                                     
[ 2151.074553] em28xx #0: found i2c device @ 0xa0 [eeprom]                                                  
[ 2151.079193] em28xx #0: found i2c device @ 0xb8 [tvp5150a]                                                
[ 2151.081085] em28xx #0: found i2c device @ 0xc2 [tuner (analog)]                                          
[ 2151.092318] em28xx #0: Your board has no unique USB ID and thus need a hint to be detected.              
[ 2151.092322] em28xx #0: You may try to use card=<n> insmod option to workaround that.                     
[ 2151.092324] em28xx #0: Please send an email with this log to:                                            
[ 2151.092326] em28xx #0:       V4L Mailing List <linux-media@vger.kernel.org>                              
[ 2151.092328] em28xx #0: Board eeprom hash is 0x396a0441                                                   
[ 2151.092330] em28xx #0: Board i2c devicelist hash is 0x944d008f                                           
[ 2151.092332] em28xx #0: Here is a list of valid choices for the card=<n> insmod option:                   
[ 2151.092335] em28xx #0:     card=0 -> Unknown EM2800 video grabber                                        
[ 2151.092337] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber                                   
[ 2151.092339] em28xx #0:     card=2 -> Terratec Cinergy 250 USB                                            
[ 2151.092341] em28xx #0:     card=3 -> Pinnacle PCTV USB 2                                                 
[ 2151.092343] em28xx #0:     card=4 -> Hauppauge WinTV USB 2                                               
[ 2151.092345] em28xx #0:     card=5 -> MSI VOX USB 2.0                                                     
[ 2151.092347] em28xx #0:     card=6 -> Terratec Cinergy 200 USB                                            
[ 2151.092349] em28xx #0:     card=7 -> Leadtek Winfast USB II                                              
[ 2151.092352] em28xx #0:     card=8 -> Kworld USB2800                                                      
[ 2151.092354] em28xx #0:     card=9 -> Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baas Video to DVD maker 
[ 2151.092356] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900                                            
[ 2151.092358] em28xx #0:     card=11 -> Terratec Hybrid XS                                                 
[ 2151.092360] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF                                              
[ 2151.092362] em28xx #0:     card=13 -> Terratec Prodigy XS                                                
[ 2151.092365] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview Prolink PlayTV USB 2.0                
[ 2151.092367] em28xx #0:     card=15 -> V-Gear PocketTV                                                    
[ 2151.092369] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950                                            
[ 2151.092371] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick                                         
[ 2151.092374] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)                                       
[ 2151.092376] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design                                    
[ 2151.092378] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600                                           
[ 2151.092380] em28xx #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX+ Video Encoder                     
[ 2151.092382] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber                                
[ 2151.092385] em28xx #0:     card=23 -> Huaqi DLCW-130                                                     
[ 2151.092387] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner                                           
[ 2151.092389] em28xx #0:     card=25 -> Gadmei UTV310                                                      
[ 2151.092391] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0                                          
[ 2151.092393] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)                             
[ 2151.092395] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe                                      
[ 2151.092397] em28xx #0:     card=29 -> <NULL>                                                             
[ 2151.092399] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0                                         
[ 2151.092401] em28xx #0:     card=31 -> Usbgear VD204v9                                                    
[ 2151.092403] em28xx #0:     card=32 -> Supercomp USB 2.0 TV                                               
[ 2151.092405] em28xx #0:     card=33 -> <NULL>                                                             
[ 2151.092407] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS                                       
[ 2151.092409] em28xx #0:     card=35 -> Typhoon DVD Maker                                                  
[ 2151.092411] em28xx #0:     card=36 -> NetGMBH Cam                                                        
[ 2151.092413] em28xx #0:     card=37 -> Gadmei UTV330                                                      
[ 2151.092415] em28xx #0:     card=38 -> Yakumo MovieMixer                                                  
[ 2151.092417] em28xx #0:     card=39 -> KWorld PVRTV 300U                                                  
[ 2151.092419] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U                                         
[ 2151.092421] em28xx #0:     card=41 -> Kworld 350 U DVB-T                                                 
[ 2151.092423] em28xx #0:     card=42 -> Kworld 355 U DVB-T                                                 
[ 2151.092425] em28xx #0:     card=43 -> Terratec Cinergy T XS                                              
[ 2151.092427] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)                                     
[ 2151.092430] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T                                                
[ 2151.092432] em28xx #0:     card=46 -> Compro, VideoMate U3                                               
[ 2151.092434] em28xx #0:     card=47 -> KWorld DVB-T 305U                                                  
[ 2151.092436] em28xx #0:     card=48 -> KWorld DVB-T 310U                                                  
[ 2151.092437] em28xx #0:     card=49 -> MSI DigiVox A/D                                                    
[ 2151.092439] em28xx #0:     card=50 -> MSI DigiVox A/D II                                                 
[ 2151.092441] em28xx #0:     card=51 -> Terratec Hybrid XS Secam                                           
[ 2151.092443] em28xx #0:     card=52 -> DNT DA2 Hybrid                                                     
[ 2151.092446] em28xx #0:     card=53 -> Pinnacle Hybrid Pro                                                
[ 2151.092448] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR                                              
[ 2151.092450] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)                                        
[ 2151.092452] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)                                            
[ 2151.092454] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[ 2151.092456] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[ 2151.092458] em28xx #0:     card=59 -> <NULL>
[ 2151.092460] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[ 2151.092462] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[ 2151.092464] em28xx #0:     card=62 -> Gadmei TVR200
[ 2151.092466] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[ 2151.092468] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[ 2151.092470] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[ 2151.092472] em28xx #0:     card=66 -> Empire dual TV
[ 2151.092474] em28xx #0:     card=67 -> Terratec Grabby
[ 2151.092476] em28xx #0:     card=68 -> Terratec AV350
[ 2151.092478] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[ 2151.092480] em28xx #0:     card=70 -> Evga inDtube
[ 2151.092482] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[ 2151.168064] em28xx #0:
[ 2151.168066]
[ 2151.168070] em28xx #0: The support for this board weren't valid yet.
[ 2151.168074] em28xx #0: Please send a report of having this working
[ 2151.168077] em28xx #0: not to V4L mailing list (and/or to other addresses)
[ 2151.168079]
[ 2151.174043] tvp5150 6-005c: chip found @ 0xb8 (em28xx #0)
[ 2151.182262] tuner 6-0061: chip found @ 0xc2 (em28xx #0)
[ 2151.182441] xc2028 6-0061: creating new instance
[ 2151.182445] xc2028 6-0061: type set to XCeive xc2028/xc3028 tuner
[ 2151.182457] usb 2-3: firmware: requesting xc3028-v27.fw
[ 2151.193573] xc2028 6-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[ 2151.252123] xc2028 6-0061: Loading firmware for type=BASE (1), id 0000000000000000.
[ 2152.198958] xc2028 6-0061: Loading firmware for type=(0), id 000000000000b700.
[ 2152.213606] SCODE (20000000), id 000000000000b700:
[ 2152.213615] xc2028 6-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320 (60008000), id 0000000000008000.
[ 2152.396208] em28xx #0: Config register raw data: 0xd0
[ 2152.396944] em28xx #0: AC97 vendor ID = 0xffffffff
[ 2152.397434] em28xx #0: AC97 features = 0x6a90
[ 2152.397438] em28xx #0: Empia 202 AC97 audio processor detected
[ 2152.520819] tvp5150 6-005c: tvp5150am1 detected.
[ 2152.621320] em28xx #0: v4l2 driver version 0.1.2
[ 2152.707099] em28xx #0: V4L2 device registered as /dev/video1 and /dev/vbi0
[ 2152.707106] em28xx-audio.c: probing for em28x1 non standard usbaudio
[ 2152.707110] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[ 2152.741984] em28xx video device (eb1a:e310): interface 1, class 255 found.
[ 2152.741991] em28xx This is an anciliary interface not used by the driver
[ 2152.817542] tvp5150 6-005c: tvp5150am1 detected.
 


--------------030802080207070305040404--
