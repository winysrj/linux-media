Return-path: <mchehab@pedra>
Received: from cain.gsoft.com.au ([203.31.81.10]:65144 "EHLO cain.gsoft.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697Ab1AHMiq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Jan 2011 07:38:46 -0500
From: "Daniel O'Connor" <darius@dons.net.au>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Date: Sat, 8 Jan 2011 23:08:25 +1030
Subject: Unable to build media_build (mk II)
To: linux-media@vger.kernel.org
Message-Id: <155DD6D6-0766-4501-9B03-D5945460B040@dons.net.au>
Mime-Version: 1.0 (Apple Message framework v1082)
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi again :)
I am still having trouble building unfortunately, I get the following:
  CC [M]  /home/myth/media_build/v4l/hdpvr-video.o
  CC [M]  /home/myth/media_build/v4l/hdpvr-i2c.o
/home/myth/media_build/v4l/hdpvr-i2c.c: In function 'hdpvr_new_i2c_ir':
/home/myth/media_build/v4l/hdpvr-i2c.c:62: error: too many arguments to function 'i2c_new_probed_device'
make[3]: *** [/home/myth/media_build/v4l/hdpvr-i2c.o] Error 1
make[2]: *** [_module_/home/myth/media_build/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-2.6.32-26-generic'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/myth/media_build/v4l'
make: *** [all] Error 2
*** ERROR. Aborting ***

Looking at some other consumers of that function it would appear the last argument (NULL in this case) is superfluous, however the file appears to be replaced each time I run build.sh so I can't update it.

[mythtv 23:00] ~/media_build >uname -a
Linux mythtv 2.6.32-26-generic #48-Ubuntu SMP Wed Nov 24 10:14:11 UTC 2010 x86_64 GNU/Linux
[mythtv 23:00] ~/media_build >cat /etc/lsb-release 
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=10.04
DISTRIB_CODENAME=lucid
DISTRIB_DESCRIPTION="Ubuntu 10.04.1 LTS"

--
Daniel O'Connor software and network engineer
for Genesis Software - http://www.gsoft.com.au
"The nice thing about standards is that there
are so many of them to choose from."
  -- Andrew Tanenbaum
GPG Fingerprint - 5596 B766 97C0 0E94 4347 295E E593 DC20 7B3F CE8C






