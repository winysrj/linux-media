Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:48367 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753228Ab1LUKu5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Dec 2011 05:50:57 -0500
Received: by lahd3 with SMTP id d3so492026lah.19
        for <linux-media@vger.kernel.org>; Wed, 21 Dec 2011 02:50:55 -0800 (PST)
Message-ID: <4EF1BA0D.4070002@gmail.com>
Date: Wed, 21 Dec 2011 11:50:53 +0100
From: Fredrik Lingvall <fredrik.lingvall@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: media_build failures on 3.0.6 Gentoo
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I get this build failure:

lin-tv src # git clone git://linuxtv.org/media_build.git
lin-tv src # cd media_build/
lin-tv media_build # ./build
Checking if the needed tools are present
Needed package dependencies are met.

************************************************************
* This script will download the latest tarball and build it*
* Assuming that your kernel is compatible with the latest  *
* drivers. If not, you'll need to add some extra backports,*
* ./backports/<kernel> directory.                          *
* It will also update this tree to be sure that all compat *
* bits are there, to avoid compilation failures            *
************************************************************
************************************************************
* All drivers and build system are under GPLv2 License     *
* Firmware files are under the license terms found at:     *
* http://www.linuxtv.org/downloads/firmware/               *
* Please abort if you don't agree with the license         *
************************************************************

****************************
Updating the building system
****************************
 From git://linuxtv.org/media_build
  * branch            master     -> FETCH_HEAD
Already up-to-date.
make: Entering directory `/usr/src/media_build/linux'
wget http://linuxtv.org/downloads/drivers/linux-media-LATEST.tar.bz2.md5 
-O linux-media.tar.bz2.md5.tmp
--2011-12-21 11:42:05--  
http://linuxtv.org/downloads/drivers/linux-media-LATEST.tar.bz2.md5
Resolving linuxtv.org... 130.149.80.248
Connecting to linuxtv.org|130.149.80.248|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 93 [application/x-bzip2]
Saving to: `linux-media.tar.bz2.md5.tmp'

100%[=============================================================================>] 
93          --.-K/s   in 0s

2011-12-21 11:42:05 (11.1 MB/s) - `linux-media.tar.bz2.md5.tmp' saved 
[93/93]


<snip>

  LD [M]  /usr/src/media_build/v4l/m5mols.o
   CC [M]  /usr/src/media_build/v4l/s5k6aa.o
   CC [M]  /usr/src/media_build/v4l/adp1653.o
   CC [M]  /usr/src/media_build/v4l/as3645a.o
/usr/src/media_build/v4l/as3645a.c: In function 'as3645a_probe':
/usr/src/media_build/v4l/as3645a.c:815:2: error: implicit declaration of 
function 'kzalloc'
/usr/src/media_build/v4l/as3645a.c:815:8: warning: assignment makes 
pointer from integer without a cast
make[3]: *** [/usr/src/media_build/v4l/as3645a.o] Error 1
make[2]: *** [_module_/usr/src/media_build/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-3.0.6-gentoo'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/usr/src/media_build/v4l'
make: *** [all] Error 2
build failed at ./build line 380.
lin-tv media_build #

Regards,

/Fredrik

