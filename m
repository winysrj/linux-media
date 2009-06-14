Return-path: <linux-media-owner@vger.kernel.org>
Received: from tischtennistrainer.eu ([85.214.38.218]:56113 "EHLO
	tischtennistrainer.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888AbZFNO01 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jun 2009 10:26:27 -0400
Received: from scheffeneu.localnet (unknown [80.152.217.184])
	(Authenticated sender: christian@heidingsfelder-partner.de)
	by tischtennistrainer.eu (Postfix) with ESMTPSA id 6A59D2430145
	for <linux-media@vger.kernel.org>; Sun, 14 Jun 2009 14:30:59 +0000 (UTC)
From: "Christian Heidingsfelder [Heidingsfelder + Partner]"
	<christian@heidingsfelder-partner.de>
To: linux-media@vger.kernel.org
Subject: Re: TT-Connect S2 -3650 CI and a Pinnacle PCTV Dual Sat Pro PCI 4000I
Date: Sun, 14 Jun 2009 16:26:26 +0200
References: <200906132231.19962.christian@heidingsfelder-partner.de> <4A34F652.2060400@web.de>
In-Reply-To: <4A34F652.2060400@web.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906141626.26687.christian@heidingsfelder-partner.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi André 

first of all, thanks for responding :-)

> http://www.linuxtv.org/wiki/index.php/TechnoTrend_TT-connect_S2-3650_CI#S2A
>PI to be applied, but it fails on some chunks...

yep, i tried it (maybe i did something wrong !? ) :


------------------------snip---------------------------
scheffeneu ~ # mkdir 3650      
scheffeneu ~ # cd 3650         
scheffeneu 3650 # hg clone -r 9263 http://mercurial.intuxication.org/hg/s2-
liplianin
destination directory: s2-liplianin                                                 
requesting all changes                                                              
adding changesets                                                                   
adding manifests                                                                    
adding file changes                                                                 
added 9264 changesets with 24422 changes to 1647 files                              
updating working directory                                                          
1189 files updated, 0 files merged, 0 files removed, 0 files unresolved             
scheffeneu 3650 # wget 
http://hem.passagen.se/faruks/3650/my_s2api_pctv452e.txt
--2009-06-14 15:43:18--  
http://hem.passagen.se/faruks/3650/my_s2api_pctv452e.txt
Resolving hem.passagen.se... 91.196.241.100                                      
Connecting to hem.passagen.se|91.196.241.100|:80... connected.                   
HTTP request sent, awaiting response... 200 OK                                   
Length: 43373 (42K) [text/plain]                                                 
Saving to: `my_s2api_pctv452e.txt'                                               

100%[====================================================================================================================>] 
43,373      71.3K/s   in 0.6s    

2009-06-14 15:43:22 (71.3 KB/s) - `my_s2api_pctv452e.txt' saved [43373/43373]

scheffeneu 3650 # cd s2-liplianin
scheffeneu s2-liplianin # patch -p1 < ../my_s2api_pctv452e.txt
patching file linux/drivers/media/dvb/dvb-usb/pctv452e.c      
patching file linux/drivers/media/dvb/frontends/lnbp22.c      
patching file linux/drivers/media/dvb/frontends/stb0899_algo.c
patching file linux/drivers/media/dvb/frontends/stb0899_drv.c 
patching file linux/drivers/media/dvb/frontends/stb0899_drv.h 
patching file linux/drivers/media/dvb/frontends/stb0899_priv.h
patching file linux/drivers/media/dvb/frontends/stb6100.c     
patching file linux/drivers/media/dvb/frontends/stb6100.h     
patching file linux/drivers/media/dvb/frontends/stb6100_cfg.h 
patching file linux/include/linux/dvb/frontend.h              
scheffeneu s2-liplianin # make
make -C /root/3650/s2-liplianin/v4l 
/bin/sh: /sbin/lsmod: No such file or directory                                                                                                               
make[1]: Entering directory `/root/3650/s2-liplianin/v4l'                                                                                                     
No version yet, using 2.6.29-gentoo-r5                                                                                                                        
make[1]: Leaving directory `/root/3650/s2-liplianin/v4l'                                                                                                      
/bin/sh: /sbin/lsmod: No such file or directory                                                                                                               
make[1]: Entering directory `/root/3650/s2-liplianin/v4l'                                                                                                     
scripts/make_makefile.pl                                                                                                                                      
Updating/Creating .config                                                                                                                                     
Preparing to compile for kernel version 2.6.29                                                                                                                
Created default (all yes) .config file                                                                                                                        
./scripts/make_myconfig.pl                                                                                                                                    
make[1]: Leaving directory `/root/3650/s2-liplianin/v4l'                                                                                                      
/bin/sh: /sbin/lsmod: No such file or directory                                                                                                               
make[1]: Entering directory `/root/3650/s2-liplianin/v4l'                                                                                                     
perl scripts/make_config_compat.pl /lib/modules/2.6.29-gentoo-r5/source 
./.myconfig ./config-compat.h                                                         
creating symbolic links...                                                                                                                                    
ln -sf . oss                                                                                                                                                  
Kernel build directory is /lib/modules/2.6.29-gentoo-r5/build                                                                                                 
make -C /lib/modules/2.6.29-gentoo-r5/build SUBDIRS=/root/3650/s2-
liplianin/v4l  modules                                                                      
make[2]: Entering directory `/usr/src/linux-2.6.29-gentoo-r5'                                                                                                 
/bin/sh: /sbin/lsmod: No such file or directory                                                                                                               
  CC [M]  /root/3650/s2-liplianin/v4l/tuner-xc2028.o                                                                                                          
  CC [M]  /root/3650/s2-liplianin/v4l/tuner-simple.o
  CC [M]  /root/3650/s2-liplianin/v4l/tuner-types.o
  CC [M]  /root/3650/s2-liplianin/v4l/mt20xx.o
  CC [M]  /root/3650/s2-liplianin/v4l/tda8290.o
  CC [M]  /root/3650/s2-liplianin/v4l/tea5767.o
  CC [M]  /root/3650/s2-liplianin/v4l/tea5761.o
  CC [M]  /root/3650/s2-liplianin/v4l/tda9887.o
  CC [M]  /root/3650/s2-liplianin/v4l/tda827x.o
  CC [M]  /root/3650/s2-liplianin/v4l/au0828-core.o
  CC [M]  /root/3650/s2-liplianin/v4l/au0828-i2c.o
  CC [M]  /root/3650/s2-liplianin/v4l/au0828-cards.o
  CC [M]  /root/3650/s2-liplianin/v4l/au0828-dvb.o
  CC [M]  /root/3650/s2-liplianin/v4l/flexcop-pci.o
  CC [M]  /root/3650/s2-liplianin/v4l/flexcop-usb.o
  CC [M]  /root/3650/s2-liplianin/v4l/flexcop.o
  CC [M]  /root/3650/s2-liplianin/v4l/flexcop-fe-tuner.o
  CC [M]  /root/3650/s2-liplianin/v4l/flexcop-i2c.o
  CC [M]  /root/3650/s2-liplianin/v4l/flexcop-sram.o
  CC [M]  /root/3650/s2-liplianin/v4l/flexcop-eeprom.o
  CC [M]  /root/3650/s2-liplianin/v4l/flexcop-misc.o
  CC [M]  /root/3650/s2-liplianin/v4l/flexcop-hw-filter.o
  CC [M]  /root/3650/s2-liplianin/v4l/flexcop-dma.o
  CC [M]  /root/3650/s2-liplianin/v4l/bttv-driver.o
/root/3650/s2-liplianin/v4l/bttv-driver.c:2062: warning: 'struct 
v4l2_register' declared inside parameter list
/root/3650/s2-liplianin/v4l/bttv-driver.c:2062: warning: its scope is only 
this definition or declaration, which is probably not what you want
/root/3650/s2-liplianin/v4l/bttv-driver.c: In function 'bttv_g_register':
/root/3650/s2-liplianin/v4l/bttv-driver.c:2070: error: dereferencing pointer 
to incomplete type
/root/3650/s2-liplianin/v4l/bttv-driver.c:2070: error: dereferencing pointer 
to incomplete type
/root/3650/s2-liplianin/v4l/bttv-driver.c:2070: error: too many arguments to 
function 'v4l2_chip_match_host'
/root/3650/s2-liplianin/v4l/bttv-driver.c:2074: error: dereferencing pointer 
to incomplete type
/root/3650/s2-liplianin/v4l/bttv-driver.c:2075: error: dereferencing pointer 
to incomplete type
/root/3650/s2-liplianin/v4l/bttv-driver.c:2075: error: dereferencing pointer 
to incomplete type
/root/3650/s2-liplianin/v4l/bttv-driver.c: At top level:
/root/3650/s2-liplianin/v4l/bttv-driver.c:2081: warning: 'struct 
v4l2_register' declared inside parameter list
/root/3650/s2-liplianin/v4l/bttv-driver.c: In function 'bttv_s_register':
/root/3650/s2-liplianin/v4l/bttv-driver.c:2089: error: dereferencing pointer 
to incomplete type
/root/3650/s2-liplianin/v4l/bttv-driver.c:2089: error: dereferencing pointer 
to incomplete type
/root/3650/s2-liplianin/v4l/bttv-driver.c:2089: error: too many arguments to 
function 'v4l2_chip_match_host'
/root/3650/s2-liplianin/v4l/bttv-driver.c:2093: error: dereferencing pointer 
to incomplete type
/root/3650/s2-liplianin/v4l/bttv-driver.c:2094: error: dereferencing pointer 
to incomplete type
/root/3650/s2-liplianin/v4l/bttv-driver.c:2094: error: dereferencing pointer 
to incomplete type
/root/3650/s2-liplianin/v4l/bttv-driver.c: At top level:
/root/3650/s2-liplianin/v4l/bttv-driver.c:3374: warning: initialization from 
incompatible pointer type
/root/3650/s2-liplianin/v4l/bttv-driver.c:3375: error: 'v4l_compat_ioctl32' 
undeclared here (not in a function)
/root/3650/s2-liplianin/v4l/bttv-driver.c:3429: warning: initialization from 
incompatible pointer type
/root/3650/s2-liplianin/v4l/bttv-driver.c:3430: warning: initialization from 
incompatible pointer type
/root/3650/s2-liplianin/v4l/bttv-driver.c:3435: warning: initialization from 
incompatible pointer type
/root/3650/s2-liplianin/v4l/bttv-driver.c:3663: warning: initialization from 
incompatible pointer type
/root/3650/s2-liplianin/v4l/bttv-driver.c:3686: warning: initialization from 
incompatible pointer type
make[3]: *** [/root/3650/s2-liplianin/v4l/bttv-driver.o] Error 1
make[2]: *** [_module_/root/3650/s2-liplianin/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-2.6.29-gentoo-r5'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/root/3650/s2-liplianin/v4l'
make: *** [all] Error 2
----------------------snap---------------------------------------

No idea whats wrong there. I use gentoo since 1 years now so ask me again in 
10 years, then i will tell you :-)



> As for the "Pinnacle PCTV Dual Sat Pro PCI 4000I"...
> All I know is that the wiki at
> http://www.linuxtv.org/wiki/index.php/Pinnacle_PCTV_Dual_Sat_Pro_PCI_4000I
> lists this device as not supported.

On 
http://linuxtv.org/wiki/index.php/Pinnacle_PCTV_Dual_Sat_Pro_PCI_4000I i read 
that the card uses 

* Zarlink ZL10037 (DVB-S Tuner) (i2c-addr: 0x60 ??)
* Zarlink ZL10313 (DVB-S Demodulator) (i2c-addr: 0x0e ??)
The second one i found in the 2.6.30 kernel 

------------------------snip----------------------------
CONFIG_DVB_MT312:                                                                                     
│  
  │                                                                                                       
│  
  │ A DVB-S tuner module. Say Y when you want to support this frontend.                                   
│  
  │                                                                                                       
│  
  │ Symbol: DVB_MT312 [=m]                                                                                
│  
  │ Prompt: Zarlink VP310/MT312/ZL10313 based                                                             
│  
  │   Defined at drivers/media/dvb/frontends/Kconfig:55                                                   
│  
  │   Depends on: HAS_IOMEM && DVB_CAPTURE_DRIVERS && DVB_FE_CUSTOMISE && 
DVB_CORE && I2C                 │  
  │   Location:                                                                                           
│  
  │     -> Device Drivers                                                                                 
│  
  │       -> Multimedia devices                                                                           
│  
  │         -> DVB/ATSC adapters (DVB_CAPTURE_DRIVERS [=y])                                               
│  
  │           -> Customise the frontend modules to build (DVB_FE_CUSTOMISE 
[=y])                          │  
  │             -> Customise DVB Frontends                                                                
│  
  │   Selected by: VIDEO_SAA7134_DVB && HAS_IOMEM && VIDEO_CAPTURE_DRIVERS && 
VIDEO_V4L2 && VIDEO_SAA7134 │  

---------------snap---------------------------------------------

The first one i found .. well nearly ...  in the 2.6.30 kernel 

-----------------snip--------------------------------------
 │ CONFIG_DVB_ZL10036:                                                                                   
│  
  │                                                                                                       
│  
  │ A DVB-S tuner module. Say Y when you want to support this frontend.                                   
│  
  │                                                                                                       
│  
  │ Symbol: DVB_ZL10036 [=m]                                                                              
│  
  │ Prompt: Zarlink ZL10036 silicon tuner                                                                 
│  
  │   Defined at drivers/media/dvb/frontends/Kconfig:62                                                   
│  
  │   Depends on: HAS_IOMEM && DVB_CAPTURE_DRIVERS && DVB_FE_CUSTOMISE && 
DVB_CORE && I2C                 │  
  │   Location:                                                                                           
│  
  │     -> Device Drivers                                                                                 
│  
  │       -> Multimedia devices                                                                           
│  
  │         -> DVB/ATSC adapters (DVB_CAPTURE_DRIVERS [=y])                                               
│  
  │           -> Customise the frontend modules to build (DVB_FE_CUSTOMISE 
[=y])                          │  
  │             -> Customise DVB Frontends                                                                
│  
  │   Selected by: VIDEO_SAA7134_DVB && HAS_IOMEM && VIDEO_CAPTURE_DRIVERS && 
VIDEO_V4L2 && VIDEO_SAA7134 
------------------------snap--------------------------------------------

So, one of the programmer people only has to add 1 to that and it will 
work!?!?!? 
hide
Or .. as i read here 
http://linuxtv.org/wiki/index.php/Zarlink_ZL10037
divide 2 !?!?!

hideagain

I hope someone who is able to do that is reading this list.
If I can do something to make it work .. please let me know.

Regards chris

