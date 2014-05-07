Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5.pb.cz ([109.72.0.115]:57979 "EHLO smtp5.pb.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbaEGGZ7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 May 2014 02:25:59 -0400
Received: from [192.168.1.15] (unknown [109.72.4.22])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by smtp5.pb.cz (Postfix) with ESMTPS id 39D8882B31
	for <linux-media@vger.kernel.org>; Wed,  7 May 2014 08:25:58 +0200 (CEST)
Message-ID: <5369D1F6.6060007@mizera.cz>
Date: Wed, 07 May 2014 08:25:58 +0200
From: kapetr@mizera.cz
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: build problem - from git
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I run Ubuntu 12.04 64b.
I'm using USB - ID 048d:9135 Integrated Technology Express, Inc. Zolid 
Mini DVB-T Stick

with linux-media build-ed drivers - as described here:
http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers


I just have to build it again after every kernel update - OK.

But last time - I have done the same as every time, but the build 
process failed:


$ git clone --depth=1 git://linuxtv.org/media_build.git
$ cd media_build/
$ ./build --verbose

but it ends with error

xxxxxxxxxxxxxxxxxxxxxxxxxxxx

...

******************
* Start building *
******************
make -C /home/hugo/tmp/media_build/v4l allyesconfig
make[1]: Entering directory `/home/hugo/tmp/media_build/v4l'
No version yet, using 3.2.0-61-generic
make[1]: Leaving directory `/home/hugo/tmp/media_build/v4l'
make[1]: Entering directory `/home/hugo/tmp/media_build/v4l'
make[2]: Entering directory `/home/hugo/tmp/media_build/linux'
Applying patches for kernel 3.2.0-61-generic
patch -s -f -N -p1 -i ../backports/api_version.patch
patch -s -f -N -p1 -i ../backports/pr_fmt.patch
The text leading up to this was:
--------------------------
|diff --git a/drivers/media/usb/gspca/dtcs033.c 
b/drivers/media/usb/gspca/dtcs033.c
|index 5e42c71..ba01a3e 100644
|--- a/drivers/media/usb/gspca/dtcs033.c
|+++ b/drivers/media/usb/gspca/dtcs033.c
--------------------------
No file to patch.  Skipping patch.
1 out of 1 hunk ignored
make[2]: *** [apply_patches] Error 1
make[2]: Leaving directory `/home/hugo/tmp/media_build/linux'
make[1]: *** [allyesconfig] Error 2
make[1]: Leaving directory `/home/hugo/tmp/media_build/v4l'
make: *** [allyesconfig] Error 2
can't select all drivers at ./build line 490.
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

Please help me to get my TV working again.


Thanks

--kapetr
