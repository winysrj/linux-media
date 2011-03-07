Return-path: <mchehab@pedra>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62186 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551Ab1CGTBB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Mar 2011 14:01:01 -0500
Received: by ywj3 with SMTP id 3so1712762ywj.19
        for <linux-media@vger.kernel.org>; Mon, 07 Mar 2011 11:01:00 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 7 Mar 2011 13:01:00 -0600
Message-ID: <AANLkTikJPTMGirPOVmcH-Wit-0B8BC8cqEbCMj=nLc+b@mail.gmail.com>
Subject: Compiling v4l fatal error: linux/ti_wilink_st.h: No such file or directory
From: Me <mapsmehere@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

 I had MythTV .23 up and running fine on Mythbuntu 10.10 and then
hosed it.  I reinstalled it, and since then I can't get the drivers
for my Haupphauge 2250 to compile on kernel 2.6.35-22-generic.  When I
figured it out last time I put it in a text file.  Heres what I have
done.  I have since updated to MythTV .24 and the problem persists.


wget http://www.steventoth.net/linux/hvr22xx/22xxdrv_27086.zip
wget http://www.steventoth.net/linux/hvr22xx/HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip
wget http://www.steventoth.net/linux/hvr22xx/extract.sh
sh extract.sh
sudo cp *fw /lib/firmware

git clone git://linuxtv.org/media_build.git
cd media_build
./build.sh
sudo make install

The first time it breaks, this is expected.  I edit v4l/.config and
change CONFIG_DVB_FIREDTV=m to CONFIG_DVB_FIREDTV=n

I compile again, and it should work.  But it breaks.  Heres the message I get.

make[2]: Leaving directory `/path/media_build/linux'
make -C /lib/modules/2.6.35-22-generic/build
SUBDIRS=/path/media_build/v4l  modules
make[2]: Entering directory `/usr/src/linux-headers-2.6.35-22-generic'
 CC [M]  /path/media_build/v4l/fmdrv_common.o
/path/media_build/v4l/fmdrv_common.c:41: fatal error:
linux/ti_wilink_st.h: No such file or directory
compilation terminated.
make[3]: *** [/path/media_build/v4l/fmdrv_common.o] Error 1
make[2]: *** [_module_/path/media_build/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-2.6.35-22-generic'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/path/media_build/v4l'
make: *** [all] Error 2

Why does it break?  Thanks.
