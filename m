Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:56087 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbZLWFoM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Dec 2009 00:44:12 -0500
Message-ID: <4B31AE21.8040508@free.fr>
Date: Wed, 23 Dec 2009 06:44:01 +0100
From: Yves <ydebx6@free.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Douglas Schilling Landgraf <dougsland@gmail.com>
Subject: Re: Nova-T 500 Dual DVB-T
References: <4B2DDE8E.4090708@free.fr> <4B2EFC5E.7040900@gmail.com>
In-Reply-To: <4B2EFC5E.7040900@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Douglas Schilling Landgraf a écrit :
> Hello Yves,
>
> On 12/20/2009 03:21 AM, Yves wrote:
>> Hi,
>>
>> I have a Nova-T 500 Dual DVB-T card that used to work very well under 
>> Mandriva 2008.1 (kernel 2.6.24.7).
>>
>> I moved to Mandriva 2009.1, then 2010.0 (kernel 2.6.31.6) and it 
>> doesn't work well any more. Scan can't find channels. I tried hading 
>> "options dvb-usb-dib0700 force_lna_activation=1" in 
>> /etc/modprobe.conf. It improve just a bit. Scan find only a few 
>> channels. If I revert to Mandriva 2008.1 (in another partition), all 
>> things are good (without adding anything in modprobe.conf).
>>
>> Is there a new version of the driver (dvb_usb_dib0700) that correct 
>> this behavior.
>> If not, how to install the driver from kernel 2.6.24.7 in kernel 
>> 2.6.31.6 ?
>>
>
> Please try the current driver available at v4l/dvb develpment tree and 
> share your results here.
>
> hg clone http://linuxtv.org/hg/v4l-dvb
> make
> make rmmod
> make install
>
> Finally, just restart your machine and test your favourite application.
>
> For additional info:
>
> http://www.linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers 
>
>
> Cheers,
> Douglas
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
Hello Douglas,

Unfortunately, the compilation did not succeed:

$ 
make                                                                                                         

make -C 
/home/mythtv/v4l-dvb/v4l                                                                                                      

make[1]: entrant dans le répertoire « /home/mythtv/v4l-dvb/v4l 
»                                                                     
perl scripts/make_config_compat.pl 
/lib/modules/2.6.31.6-desktop-1mnb/source ./.myconfig 
./config-compat.h                           
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
dabusb/bitstream.bin                                                                                                       

Generating 
ttusb-budget/dspbootcode.bin                                                                                               

Generating 
cpia2/stv0672_vp4.bin                                                                                                      

Generating 
av7110/bootcode.bin                                                                                                        

make[2]: Leaving directory 
`/home/mythtv/v4l-dvb/v4l/firmware'                                                                        

Kernel build directory is 
/lib/modules/2.6.31.6-desktop-1mnb/build                                                                    

make -C /lib/modules/2.6.31.6-desktop-1mnb/build 
SUBDIRS=/home/mythtv/v4l-dvb/v4l  
modules                                           
make[2]: Entering directory 
`/usr/src/linux-2.6.31.6-desktop-1mnb'                                                                    

  CC [M]  
/home/mythtv/v4l-dvb/v4l/tuner-xc2028.o                                                                                     

  CC [M]  
/home/mythtv/v4l-dvb/v4l/tuner-simple.o                                                                                     

  CC [M]  
/home/mythtv/v4l-dvb/v4l/tuner-types.o                                                                                      

  CC [M]  
/home/mythtv/v4l-dvb/v4l/mt20xx.o                                                                                           


....

  CC [M]  /home/mythtv/v4l-dvb/v4l/cx88-cards.o
  CC [M]  /home/mythtv/v4l-dvb/v4l/cx88-core.o
  CC [M]  /home/mythtv/v4l-dvb/v4l/cx88-i2c.o
  CC [M]  /home/mythtv/v4l-dvb/v4l/cx88-tvaudio.o
  CC [M]  /home/mythtv/v4l-dvb/v4l/cx88-dsp.o
  CC [M]  /home/mythtv/v4l-dvb/v4l/cx88-input.o
  CC [M]  /home/mythtv/v4l-dvb/v4l/dvbdev.o
/home/mythtv/v4l-dvb/v4l/dvbdev.c: In function 'init_dvbdev':
/home/mythtv/v4l-dvb/v4l/dvbdev.c:520: error: 'struct class' has no 
member named 'nodename'
make[3]: *** [/home/mythtv/v4l-dvb/v4l/dvbdev.o] Error 1
make[2]: *** [_module_/home/mythtv/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-2.6.31.6-desktop-1mnb'
make[1]: *** [default] Erreur 2
make[1]: quittant le répertoire « /home/mythtv/v4l-dvb/v4l »
make: *** [all] Erreur 2

I don't know that is wrong.

Yves
