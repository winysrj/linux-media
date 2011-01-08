Return-path: <mchehab@pedra>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4622 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab1AHMpT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Jan 2011 07:45:19 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Daniel O'Connor" <darius@dons.net.au>
Subject: Re: Unable to build media_build (mk II)
Date: Sat, 8 Jan 2011 13:44:54 +0100
Cc: linux-media@vger.kernel.org
References: <155DD6D6-0766-4501-9B03-D5945460B040@dons.net.au>
In-Reply-To: <155DD6D6-0766-4501-9B03-D5945460B040@dons.net.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101081344.54075.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday, January 08, 2011 13:38:25 Daniel O'Connor wrote:
> Hi again :)
> I am still having trouble building unfortunately, I get the following:
>   CC [M]  /home/myth/media_build/v4l/hdpvr-video.o
>   CC [M]  /home/myth/media_build/v4l/hdpvr-i2c.o
> /home/myth/media_build/v4l/hdpvr-i2c.c: In function 'hdpvr_new_i2c_ir':
> /home/myth/media_build/v4l/hdpvr-i2c.c:62: error: too many arguments to function 'i2c_new_probed_device'
> make[3]: *** [/home/myth/media_build/v4l/hdpvr-i2c.o] Error 1
> make[2]: *** [_module_/home/myth/media_build/v4l] Error 2
> make[2]: Leaving directory `/usr/src/linux-headers-2.6.32-26-generic'
> make[1]: *** [default] Error 2
> make[1]: Leaving directory `/home/myth/media_build/v4l'
> make: *** [all] Error 2
> *** ERROR. Aborting ***
> 
> Looking at some other consumers of that function it would appear the last argument (NULL in this case) is superfluous, however the file appears to be replaced each time I run build.sh so I can't update it.

Only run build.sh once. After that you can modify files and just run 'make'.

build.sh will indeed overwrite the drivers every time you run it so you should
that only if you want to get the latest source code.

Regards,

	Hans

> 
> [mythtv 23:00] ~/media_build >uname -a
> Linux mythtv 2.6.32-26-generic #48-Ubuntu SMP Wed Nov 24 10:14:11 UTC 2010 x86_64 GNU/Linux
> [mythtv 23:00] ~/media_build >cat /etc/lsb-release 
> DISTRIB_ID=Ubuntu
> DISTRIB_RELEASE=10.04
> DISTRIB_CODENAME=lucid
> DISTRIB_DESCRIPTION="Ubuntu 10.04.1 LTS"

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
