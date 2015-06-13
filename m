Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33053 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbbFMHgD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Jun 2015 03:36:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>, sakari.ailus@iki.fi
Subject: Re: [PATCH v2] Kconfig: disable Media Controller for DVB
Date: Sat, 13 Jun 2015 10:36:44 +0300
Message-ID: <3796364.09HDV5HO0h@avalon>
In-Reply-To: <95e2a872eef0289e19e104d520abd69709899e3a.1434108678.git.mchehab@osg.samsung.com>
References: <95e2a872eef0289e19e104d520abd69709899e3a.1434108678.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

(CC'ing Sakari)

Thank you for the patch.

On Friday 12 June 2015 08:31:26 Mauro Carvalho Chehab wrote:
> Since when we start discussions about the usage Media Controller
> for complex hardware, one thing become clear: the way it is, MC
> fails to map anything more complex than a webcam.

I strongly disagree with that. The MC API works fine (albeit with entity type 
names that are incorrect) on complex embedded video capture devices that are 
far from being just webcams. However, I agree that the API is broken outside 
of the V4L realm.

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
> In other words, MC is broken as a whole, but tagging it as BROKEN
> right now would do more harm than good.
> 
> So, instead, let's mark, for now, the DVB part as broken and
> block all new changes to MC while we fix this mess, whith
> we hopefully will do for the next Kernel version.
> 
> Requested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

I'm fine with the change, but I'd rework the commit message a bit.

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

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

-- 
Regards,

Laurent Pinchart

