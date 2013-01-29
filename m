Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56068 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757379Ab3A2Pk1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jan 2013 10:40:27 -0500
Received: by mail-wi0-f172.google.com with SMTP id o1so2584136wic.17
        for <linux-media@vger.kernel.org>; Tue, 29 Jan 2013 07:40:25 -0800 (PST)
Message-ID: <5107ED62.2010702@gmail.com>
Date: Tue, 29 Jan 2013 16:40:18 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Olivier Subilia <futilite@romandie.com>,
	linux-media@vger.kernel.org
Subject: Re: Bug report - em28xx
References: <CD2D9525.98B4%philschweizer@bluewin.ch> <5107DA24.5050303@romandie.com> <201301291559.26481.hverkuil@xs4all.nl>
In-Reply-To: <201301291559.26481.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 29/01/2013 15:59, Hans Verkuil ha scritto:
> On Tue January 29 2013 15:18:12 Olivier Subilia wrote:
>> Hi,
>>
>> First of all, I've no experience with this mailing list. I'm not sure 
>> I'm sending my report to the right place. If not, please don't hesitate 
>> to tell it to me (possibly with the right place address).
>>
>> I'm desperately trying to compile v4l drivers for a PCTV quatrostick 
>> nano. Following this page
>>
>> http://www.linuxtv.org/wiki/index.php/PCTVSystems_QuatroStick-nano_520e
>>
>> it uses the em28xx driver.
>>
>> my configuration: `uname -r` = 3.2.0-35-generic-pae
>>
>> So I tried to compile it with
>>
>> $ git clone git://linuxtv.org/media_build.git
>> $ cd media_built
>> $ ./build >log.log (file attached)
>>
>> STDERR:
>>
>> Cloning into 'media_build'...
>> remote: Counting objects: 1813, done.
>> remote: Compressing objects: 100% (591/591), done.
>> remote: Total 1813 (delta 1223), reused 1751 (delta 1183)
>> Receiving objects: 100% (1813/1813), 423.66 KiB, done.
>> Resolving deltas: 100% (1223/1223), done.
>> multimedia@serveur:~$ cd media_build/
>> multimedia@serveur:~/media_build$ ./build >log.log
>>  From git://linuxtv.org/media_build
>>   * branch            master     -> FETCH_HEAD
>> --2013-01-29 14:52:49-- 
>> http://linuxtv.org/downloads/drivers/linux-media-LATEST.tar.bz2.md5
>> Resolving linuxtv.org (linuxtv.org)... 130.149.80.248
>> Connecting to linuxtv.org (linuxtv.org)|130.149.80.248|:80... connected.
>> HTTP request sent, awaiting response... 200 OK
>> Length: 93 [application/x-bzip2]
>> Saving to: `linux-media.tar.bz2.md5.tmp'
>>
>> 100%[=========================================================================================================================================>] 
>> 93          --.-K/s   in 0s
>>
>> 2013-01-29 14:52:49 (7.72 MB/s) - `linux-media.tar.bz2.md5.tmp' saved 
>> [93/93]
>>
>> cat: linux-media.tar.bz2.md5: No such file or directory
>> --2013-01-29 14:52:49-- 
>> http://linuxtv.org/downloads/drivers/linux-media-LATEST.tar.bz2
>> Resolving linuxtv.org (linuxtv.org)... 130.149.80.248
>> Connecting to linuxtv.org (linuxtv.org)|130.149.80.248|:80... connected.
>> HTTP request sent, awaiting response... 200 OK
>> Length: 4502249 (4.3M) [application/x-bzip2]
>> Saving to: `linux-media.tar.bz2'
>>
>> 100%[=========================================================================================================================================>] 
>> 4'502'249   5.47M/s   in 0.8s
>>
>> 2013-01-29 14:52:50 (5.47 MB/s) - `linux-media.tar.bz2' saved 
>> [4502249/4502249]
>>
>> --2013-01-29 14:52:51-- 
>> http://www.linuxtv.org/downloads/firmware//dvb-firmwares.tar.bz2
>> Resolving www.linuxtv.org (www.linuxtv.org)... 130.149.80.248
>> Connecting to www.linuxtv.org (www.linuxtv.org)|130.149.80.248|:80... 
>> connected.
>> HTTP request sent, awaiting response... 200 OK
>> Length: 649441 (634K) [application/x-bzip2]
>> Saving to: `dvb-firmwares.tar.bz2'
>>
>> 100%[=========================================================================================================================================>] 
>> 649'441     1.41M/s   in 0.4s
>>
>> 2013-01-29 14:52:51 (1.41 MB/s) - `dvb-firmwares.tar.bz2' saved 
>> [649441/649441]
>>
>>
>> ln: accessing `../../linux/firmware/dabusb//*': No such file or directory
>> /home/multimedia/media_build/v4l/anysee.c: In function 
>> 'anysee_frontend_attach':
>> /home/multimedia/media_build/v4l/anysee.c:893:2: warning: 'ret' may be 
>> used uninitialized in this function [-Wuninitialized]
>> /home/multimedia/media_build/v4l/m920x.c: In function 'm920x_probe':
>> /home/multimedia/media_build/v4l/m920x.c:91:6: warning: 'ret' may be 
>> used uninitialized in this function [-Wuninitialized]
>> /home/multimedia/media_build/v4l/m920x.c:70:6: note: 'ret' was declared here
>> /home/multimedia/media_build/v4l/mxl111sf.c:58:0: warning: "err" 
>> redefined [enabled by default]
>> include/linux/usb.h:1655:0: note: this is the location of the previous 
>> definition
>> /home/multimedia/media_build/v4l/ngene-cards.c:813:2: warning: 
>> initialization discards 'const' qualifier from pointer target type 
>> [enabled by default]
>> /home/multimedia/media_build/v4l/mxl111sf-tuner.c:34:0: warning: "err" 
>> redefined [enabled by default]
>> include/linux/usb.h:1655:0: note: this is the location of the previous 
>> definition
>> /home/multimedia/media_build/v4l/mxl111sf-tuner.c:34:0: warning: "err" 
>> redefined [enabled by default]
>> include/linux/usb.h:1655:0: note: this is the location of the previous 
>> definition
>> WARNING: "snd_tea575x_set_freq" 
>> [/home/multimedia/media_build/v4l/radio-shark.ko] undefined!
>> WARNING: modpost: Found 1 section mismatch(es).
>> To see full details build your kernel with:
>> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
>>
>>
>> No other compilation error. 524 modules founds. But if I check em28xx 
>> family modules:
>>
>> $ ls v4l/em28xx*.ko
>> ls: cannot access v4l/em28xx*.ko: No such file or directory
>>
>> In other words: no module is compiled with this.
>> All (most ?) other modules are compiled in v4l/*.ko
>>
>> What am I doing wrong ?
> 
> Nothing :-)
> 
> I can reproduce this myself. It works fine for all kernels except 3.2 and 3.3.
> One workaround is to run 'make menuconfig' in the media_build directory, turn
> on the em28xx modules, and run 'make' to build everything.
> 
> Why it isn't automatically selected when compiling for those kernels is a
> mystery to me.
> 
> Regards,
> 
> 	Hans
> 

Another similar bug that I noticed recently on kernel
2.6.32-45-generic-pae (Ubuntu 10.04):

- the default .config file is OK;
- .config files produced by 'make allmodconfig', 'make stagingconfig'
are OK;
- .config produced by 'make menuconfig' or 'make xconfig' are NOT OK and
the build fails!

The error is this:

media_build/v4l/au8522_dig.c:748: error: redefinition of 'au8522_attach'
media_build/v4l/au8522.h:69: note: previous definition of
'au8522_attach' was here
make[3]: *** [media_build/v4l/au8522_dig.o] Error 1
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [_module_media_build/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-2.6.32-45-generic-pae'

In the bad .config file the modules:

CONFIG_DVB_AU8522_DTV=m
CONFIG_DVB_AU8522_V4L=m

are enabled, but the main option:

CONFIG_DVB_AU8522=m

is missing! Adding it manually fixes the problem. I really have no idea
about the origin of the problem, but I'm sure that a few months ago
everything was working properly.

Regards,
Gianluca

>> With kernel 2.6.32-45-generic, I have no problem to build everything 
>> with the same commands, included em28xx*.ko.
>>
>> By the way, is it possible to rebuild just one specific module instead 
>> of always rebuilding the whole tree ?
>>
>> Many thanks in advance for any hint
>>
>> Olivier Subilia
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

