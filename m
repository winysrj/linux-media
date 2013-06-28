Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755632Ab3F1LBK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jun 2013 07:01:10 -0400
Date: Fri, 28 Jun 2013 08:00:43 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media" <linux-media@vger.kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH] usbtv: fix dependency
Message-ID: <20130628080043.46dd09c0.mchehab@redhat.com>
In-Reply-To: <201306281024.15428.hverkuil@xs4all.nl>
References: <201306281024.15428.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 28 Jun 2013 10:24:15 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> This fixes a dependency problem as found by Randy Dunlap:
> 
> https://lkml.org/lkml/2013/6/27/501
> 
> Mauro, is there any reason for any V4L2 driver to depend on VIDEO_DEV instead of
> just VIDEO_V4L2?
> 
> Some drivers depend on VIDEO_DEV, some on VIDEO_V4L2, some on both. It's all
> pretty chaotic.

It should be noticed that, despite its name, this config is actually a
joint dependency of VIDEO_DEV and I2C that will compile drivers as module
if either I2C or VIDEO_DEV is a module:

	config VIDEO_V4L2
		tristate
		depends on (I2C || I2C=n) && VIDEO_DEV
		default (I2C || I2C=n) && VIDEO_DEV

So, a V4L2 device that doesn't have any I2C device doesn't need to depend
on VIDEO_V4L2. That includes, for example, reversed-engineered webcam
drivers where the sensor code is inside the driver and a few capture-only
device drivers.

It should be noticed, however, that, on several places, the need of adding
a "depends on VIDEO_V4L2" is not needed, as, on some places, the syntax
is:

	if VIDEO_V4L2

	config "driver foo"
	...

	endif

Btw, it could make sense to rename it to something clearer, like
VIDEO_DEV_AND_I2C and define it as:

	config VIDEO_DEV_AND_I2C
		tristate
		depends on I2C && VIDEO_DEV
		default y

Or, even better, to just get rid of it and explicitly add I2C on all
places where it is used.


Regards,
Mauro

> 
> Regards,
> 
> 	Hans
> 
> diff --git a/drivers/media/usb/usbtv/Kconfig b/drivers/media/usb/usbtv/Kconfig
> index 8864436..7c5b860 100644
> --- a/drivers/media/usb/usbtv/Kconfig
> +++ b/drivers/media/usb/usbtv/Kconfig
> @@ -1,6 +1,6 @@
>  config VIDEO_USBTV
>          tristate "USBTV007 video capture support"
> -        depends on VIDEO_DEV
> +        depends on VIDEO_V4L2
>          select VIDEOBUF2_VMALLOC
>  
>          ---help---


-- 

Cheers,
Mauro
