Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1838 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477AbaEGGXC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 May 2014 02:23:02 -0400
Message-ID: <5369D13A.6040809@xs4all.nl>
Date: Wed, 07 May 2014 08:22:50 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: kapetr@mizera.cz, linux-media@vger.kernel.org
Subject: Re: build problem
References: <5369C892.3010509@mizera.cz>
In-Reply-To: <5369C892.3010509@mizera.cz>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/07/2014 07:45 AM, kapetr@mizera.cz wrote:
> Hello,
> 
> I run Ubuntu 12.04 64b.
> I'm using USB - ID 048d:9135 Integrated Technology Express, Inc. Zolid 
> Mini DVB-T Stick
> 
> with linux-media build-ed drivers - as described here:
> http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers
> 
> 
> I just have to build it again after every kernel update - OK.
> 
> But last time - I have done the same as every time, but the build 
> process failed:
> 
> 
> $ git clone --depth=1 git://linuxtv.org/media_build.git
> $ cd media_build/
> $ ./build --verbose
> 
> but it ends with error

The archive ./build downloads is missing a file for some reason. It may be
a few days before it is fixed since the maintainer of that file is attending
a conference. I've told Mauro that it is broken.

In the meantime this should work, although it will be slow since it has to clone
the git tree:

./build --main-git

Regards,

	Hans

> 
> xxxxxxxxxxxxxxxxxxxxxxxxxxxx
> 
> ...
> 
> ******************
> * Start building *
> ******************
> make -C /home/hugo/tmp/media_build/v4l allyesconfig
> make[1]: Entering directory `/home/hugo/tmp/media_build/v4l'
> No version yet, using 3.2.0-61-generic
> make[1]: Leaving directory `/home/hugo/tmp/media_build/v4l'
> make[1]: Entering directory `/home/hugo/tmp/media_build/v4l'
> make[2]: Entering directory `/home/hugo/tmp/media_build/linux'
> Applying patches for kernel 3.2.0-61-generic
> patch -s -f -N -p1 -i ../backports/api_version.patch
> patch -s -f -N -p1 -i ../backports/pr_fmt.patch
> The text leading up to this was:
> --------------------------
> |diff --git a/drivers/media/usb/gspca/dtcs033.c 
> b/drivers/media/usb/gspca/dtcs033.c
> |index 5e42c71..ba01a3e 100644
> |--- a/drivers/media/usb/gspca/dtcs033.c
> |+++ b/drivers/media/usb/gspca/dtcs033.c
> --------------------------
> No file to patch.  Skipping patch.
> 1 out of 1 hunk ignored
> make[2]: *** [apply_patches] Error 1
> make[2]: Leaving directory `/home/hugo/tmp/media_build/linux'
> make[1]: *** [allyesconfig] Error 2
> make[1]: Leaving directory `/home/hugo/tmp/media_build/v4l'
> make: *** [allyesconfig] Error 2
> can't select all drivers at ./build line 490.
> xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
> 
> Please help me to get my TV working again.
> 
> 
> Thanks
> 
> --kapetr
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

