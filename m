Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:58010 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbZL1SBG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Dec 2009 13:01:06 -0500
Received: from smtp5-g21.free.fr (localhost [127.0.0.1])
	by smtp5-g21.free.fr (Postfix) with ESMTP id 58B10D4807F
	for <linux-media@vger.kernel.org>; Mon, 28 Dec 2009 19:01:00 +0100 (CET)
Received: from [192.168.5.201] (lim91-1-88-178-105-125.fbx.proxad.net [88.178.105.125])
	by smtp5-g21.free.fr (Postfix) with ESMTP id 5DA0BD481F8
	for <linux-media@vger.kernel.org>; Mon, 28 Dec 2009 19:00:58 +0100 (CET)
Message-ID: <4B38F25A.3090709@free.fr>
Date: Mon, 28 Dec 2009 19:00:58 +0100
From: Yves <ydebx6@free.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Nova-T 500 Dual DVB-T
References: <4B2DDE8E.4090708@free.fr> <4B2EFC5E.7040900@gmail.com> <4B31AE21.8040508@free.fr>
In-Reply-To: <4B31AE21.8040508@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

So, I tried using kernel 2.6.32.2 from http://www.kernel.org. I compiled 
it OK.
I still get an error with v4l-dvb :

[mythtv@localhost v4l-dvb]$ make -j 
5                                                                                                    

make -C 
/home/mythtv/v4l-dvb/v4l                                                                                                         

make[1]: entrant dans le répertoire « /home/mythtv/v4l-dvb/v4l 
»                                                                        
No version yet, using 
2.6.32.2                                                                                                           

make[1]: quittant le répertoire « /home/mythtv/v4l-dvb/v4l 
»                                                                             

make[1]: entrant dans le répertoire « /home/mythtv/v4l-dvb/v4l 
»                                                                        
scripts/make_makefile.pl                                                                                                                 

./scripts/make_kconfig.pl /lib/modules/2.6.32.2/build 
/lib/modules/2.6.32.2/source                                                       

Updating/Creating 
.config                                                                                                                

Preparing to compile for kernel version 
2.6.32                                                                                           

Preparing to compile for kernel version 
2.6.32                                                                                           

Created default (all yes) .config 
file                                                                                                   

./scripts/make_myconfig.pl                                                                                                               

make[1]: quittant le répertoire « /home/mythtv/v4l-dvb/v4l 
»                                                                             

make[1]: entrant dans le répertoire « /home/mythtv/v4l-dvb/v4l 
»                                                                        
perl scripts/make_config_compat.pl /lib/modules/2.6.32.2/source 
./.myconfig ./config-compat.h                                           
ln -sf . 
oss                                                                                                                             

creating symbolic 
links...                                                                                                               

make -C firmware 
prep                                                                                                                    

make[2]: Entering directory 
`/home/mythtv/v4l-dvb/v4l/firmware'                                                                          

make[2]: Leaving directory 
`/home/mythtv/v4l-dvb/v4l/firmware'                                                                           

make -C 
firmware                                                                                                                         

make[2]: Entering directory 
`/home/mythtv/v4l-dvb/v4l/firmware'                                                                          

  CC  
ihex2fw                                                                                                                            

Generating 
vicam/firmware.fw                                                                                                             

Generating 
dabusb/firmware.fw                                                                                                            

Generating 
ttusb-budget/dspbootcode.bin                                                                                                  

Generating 
dabusb/bitstream.bin                                                                                                          

Generating 
cpia2/stv0672_vp4.bin                                                                                                         

Generating 
av7110/bootcode.bin                                                                                                           

make[2]: Leaving directory 
`/home/mythtv/v4l-dvb/v4l/firmware'                                                                           

Kernel build directory is 
/lib/modules/2.6.32.2/build                                                                                    

make -C /lib/modules/2.6.32.2/build SUBDIRS=/home/mythtv/v4l-dvb/v4l  
modules                                                           
make[2]: Entering directory 
`/home/mythtv/Téléchargements/linux-2.6.32.2'                                                                

  CC [M]  
/home/mythtv/v4l-dvb/v4l/tuner-xc2028.o                                                                                        

  CC [M]  
/home/mythtv/v4l-dvb/v4l/tuner-simple.o                                                                                        

  CC [M]  
/home/mythtv/v4l-dvb/v4l/tuner-types.o                                                                                         

  ...

  CC [M]  /home/mythtv/v4l-dvb/v4l/radio-si4713.o
  CC [M]  /home/mythtv/v4l-dvb/v4l/radio-maestro.o
  CC [M]  /home/mythtv/v4l-dvb/v4l/radio-miropcm20.o
/home/mythtv/v4l-dvb/v4l/radio-miropcm20.c:20:23: error: sound/aci.h: No 
such file or directory
/home/mythtv/v4l-dvb/v4l/radio-miropcm20.c: In function 'pcm20_mute':
/home/mythtv/v4l-dvb/v4l/radio-miropcm20.c:46: error: implicit 
declaration of function 'snd_aci_cmd'
/home/mythtv/v4l-dvb/v4l/radio-miropcm20.c:46: error: 
'ACI_SET_TUNERMUTE' undeclared (first use in this function)
/home/mythtv/v4l-dvb/v4l/radio-miropcm20.c:46: error: (Each undeclared 
identifier is reported only once
/home/mythtv/v4l-dvb/v4l/radio-miropcm20.c:46: error: for each function 
it appears in.)
/home/mythtv/v4l-dvb/v4l/radio-miropcm20.c: In function 'pcm20_stereo':
/home/mythtv/v4l-dvb/v4l/radio-miropcm20.c:51: error: 
'ACI_SET_TUNERMONO' undeclared (first use in this function)
/home/mythtv/v4l-dvb/v4l/radio-miropcm20.c: In function 'pcm20_setfreq':
/home/mythtv/v4l-dvb/v4l/radio-miropcm20.c:63: error: dereferencing 
pointer to incomplete type
/home/mythtv/v4l-dvb/v4l/radio-miropcm20.c:63: error: dereferencing 
pointer to incomplete type
/home/mythtv/v4l-dvb/v4l/radio-miropcm20.c:70: error: 'ACI_WRITE_TUNE' 
undeclared (first use in this function)
/home/mythtv/v4l-dvb/v4l/radio-miropcm20.c: In function 'pcm20_init':
/home/mythtv/v4l-dvb/v4l/radio-miropcm20.c:225: error: implicit 
declaration of function 'snd_aci_get_aci'
/home/mythtv/v4l-dvb/v4l/radio-miropcm20.c:225: warning: assignment 
makes pointer from integer without a cast
make[3]: *** [/home/mythtv/v4l-dvb/v4l/radio-miropcm20.o] Error 1
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [_module_/home/mythtv/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/home/mythtv/Téléchargements/linux-2.6.32.2'
make[1]: *** [default] Erreur 2
make[1]: quittant le répertoire « /home/mythtv/v4l-dvb/v4l »
make: *** [all] Erreur 2


????

Yves
