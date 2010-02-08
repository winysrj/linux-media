Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744Ab0BHNeo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Feb 2010 08:34:44 -0500
Message-ID: <4B7012D1.40605@redhat.com>
Date: Mon, 08 Feb 2010 11:34:09 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: linux-pm@lists.linux-foundation.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH/RESEND] soc-camera: add runtime pm support for subdevices
References: <Pine.LNX.4.64.1002081044150.4936@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1002081044150.4936@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski wrote:
> To save power soc-camera powers subdevices down, when they are not in use, 
> if this is supported by the platform. However, the V4L standard dictates, 
> that video nodes shall preserve configuration between uses. This requires 
> runtime power management, which is implemented by this patch. It allows 
> subdevice drivers to specify their runtime power-management methods, by 
> assigning a type to the video device.

It seems a great idea to me. For sure we need some sort of power management
control.

> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> 
> I've posted this patch to linux-media earlier, but I'd also like to get 
> comments on linux-pm, sorry to linux-media falks for a duplicate. To 
> explain a bit - soc_camera.c is a management module, that binds video 
> interfaces on SoCs and sensor drivers. The calls, that I am adding to 
> soc_camera.c shall save and restore sensor registers before they are 
> powered down and after they are powered up.
> 
> diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
> index 6b3fbcc..53201f3 100644
> --- a/drivers/media/video/soc_camera.c
> +++ b/drivers/media/video/soc_camera.c
> @@ -24,6 +24,7 @@
>  #include <linux/mutex.h>
>  #include <linux/module.h>
>  #include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
>  #include <linux/vmalloc.h>


Hmm... wouldn't it be better to enable it at the subsystem level? We may for 
example call ?
The subsystem can call vidioc_streamoff() at suspend and vidioc_streamon() at
resume, if the device were streaming during suspend. We may add another ops to
the struct for the drivers/subdrivers that needs additional care.

That's said, it shouldn't be hard to implement some routine that will save/restore
all registers if the device goes to power down mode. Unfortunately, very few
devices successfully recovers from hibernation if streaming. One good example
is saa7134, that even disables/re-enables IR IRQ's during suspend/resume.

-- 

Cheers,
Mauro
