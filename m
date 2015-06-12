Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:58353 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752893AbbFLLCP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2015 07:02:15 -0400
Message-ID: <557ABC28.2020101@xs4all.nl>
Date: Fri, 12 Jun 2015 13:02:00 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] Kconfig: disable Media Controller for DVB
References: <f146ea68c1a5db7a17bdbc0a4f32ebb220c5913e.1434106648.git.mchehab@osg.samsung.com>
In-Reply-To: <f146ea68c1a5db7a17bdbc0a4f32ebb220c5913e.1434106648.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/12/2015 12:57 PM, Mauro Carvalho Chehab wrote:
> Since when we start discussions about the usage Media Controller
> for complex hardware, one thing become clear: the way it is, MC
> fails to map anything more complex than a webcam.
> 
> The point is that MC has entities named as devnodes, but the only
> devnode used (before the DVB patches) is MEDIA_ENT_T_DEVNODE_V4L.
> Due to the way MC got implemented, however, this entity actually
> doesn't represent the devnode, but the hardware I/O engine that
> receives data via DMA.
> 
> By coincidence, such DMA is associated with the V4L device node
> on webcam hardware, but this is not true even for other V4L2
> devices. For example, on USB hardware, the DMA is done via the
> USB controller. The data passes though a in-kernel filter that
> strips off the URB headers. Other V4L2 devices like radio may not
> even have DMA. When it have, the DMA is done via ALSA, and not
> via the V4L devnode.
> 
> In other words, MC is broken as a hole, but tagging it as BROKEN

hole -> whole

One of these days you'll have retrained your brain for this :-)

> right now would do more harm than good.
> 
> So, instead, let's mark, for now, the DVB part as broken and
> block all new changes to it while we don't fix this mess, with

"while we fix this mess, which"

After fixing the typos:

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> we hopefully will do for the next Kernel version.
> 
> Requested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
> index 3ef0f90b128f..157099243d61 100644
> --- a/drivers/media/Kconfig
> +++ b/drivers/media/Kconfig
> @@ -97,6 +97,7 @@ config MEDIA_CONTROLLER
>  config MEDIA_CONTROLLER_DVB
>  	bool "Enable Media controller for DVB"
>  	depends on MEDIA_CONTROLLER
> +	depends on BROKEN
>  	---help---
>  	  Enable the media controller API support for DVB.
>  
> 

