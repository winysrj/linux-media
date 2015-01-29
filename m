Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:64964 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426AbbA2Qqn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2015 11:46:43 -0500
Received: by mail-wi0-f173.google.com with SMTP id r20so28910633wiv.0
        for <linux-media@vger.kernel.org>; Thu, 29 Jan 2015 08:46:41 -0800 (PST)
Message-ID: <54CA63E2.7020506@movia.biz>
Date: Thu, 29 Jan 2015 17:46:26 +0100
From: Francesco Marletta <francesco.marletta@movia.biz>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Francesco Marletta <fmarletta@movia.biz>
CC: =?windows-1252?Q?Carlos_Sanmart=EDn_Bustos?= <carsanbu@gmail.com>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: Help required for TVP5151 on Overo
References: <20141119094656.5459258b@crow> <5213550.zrY0P2Gc9u@avalon> <20141212163802.6efa5dd0@crow> <1661712.GcM7Su7W5y@avalon>
In-Reply-To: <1661712.GcM7Su7W5y@avalon>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,
I'm finally started working on this problem... but the code from the git 
repository you specified don't compile:

make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
...
   CC [M]  drivers/media/i2c/tvp5150.o
drivers/media/i2c/tvp5150.c: In function ‘tvp5150_set_format’:
drivers/media/i2c/tvp5150.c:967:24: error: ‘V4L2_MBUS_FMT_UYVY8_2X8’ 
undeclared (first use in this function)
drivers/media/i2c/tvp5150.c:967:24: note: each undeclared identifier is 
reported only once for each function it appears in
drivers/media/i2c/tvp5150.c: In function ‘tvp5150_get_format’:
drivers/media/i2c/tvp5150.c:982:24: error: ‘V4L2_MBUS_FMT_UYVY8_2X8’ 
undeclared (first use in this function)
drivers/media/i2c/tvp5150.c: In function ‘tvp5150_enum_mbus_code’:
drivers/media/i2c/tvp5150.c:998:15: error: ‘V4L2_MBUS_FMT_UYVY8_2X8’ 
undeclared (first use in this function)
drivers/media/i2c/tvp5150.c: In function ‘tvp5150_enum_frame_size’:
drivers/media/i2c/tvp5150.c:1008:38: error: ‘V4L2_MBUS_FMT_UYVY8_2X8’ 
undeclared (first use in this function)
make[3]: *** [drivers/media/i2c/tvp5150.o] Errore 1
make[2]: *** [drivers/media/i2c] Errore 2
make[1]: *** [drivers/media] Errore 2
make: *** [drivers] Errore 2

I cloned the repos with:

git clone git://linuxtv.org/pinchartl/media.git linux_omap3isp_tvp5151
cd linux_omap3isp_tvp5151

Choosed the branch for tvp5151 with:

git branch tvp5151_for_overo  remotes/origin/omap3isp/tvp5151
git checkout tvp5151_for_overo

Then configured the kernel with:
         make mrproper
         make ARCH=arm omap2plus_defconfig
         make ARCH=arm menuconfig

And finally compiled as stated before.

Maybe there is a special branch that I should use?

Regards,
Francesco


Il 12/12/2014 23:50, Laurent Pinchart ha scritto:
> Hi Francesco,
>
> On Friday 12 December 2014 16:38:02 Francesco Marletta wrote:
>> Hi Laurent,
>>
>> I'll check the patches you indicated on
>> 	git://linuxtv.org/pinchartl/media.git omap3isp/tvp5151
>>
>> Which version of the kernel are these patches for?
> Do you know that, if you clone the above tree and checkout the
> omap3isp/tvp5151 branch, you will get a Linux kernel source tree with complete
> history and a Makefile that contains the version number ? :-)
>
> http://git.linuxtv.org/cgit.cgi/pinchartl/media.git/tree/Makefile?h=omap3isp/tvp5151
>

