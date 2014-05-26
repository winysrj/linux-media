Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36768 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751624AbaEZVM3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 May 2014 17:12:29 -0400
Message-ID: <5383AE3A.3010504@iki.fi>
Date: Tue, 27 May 2014 00:12:26 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
CC: Julien BERAUD <julien.beraud@parrot.com>,
	Boris Todorov <boris.st.todorov@gmail.com>,
	Gary Thomas <gary@mlbassoc.com>,
	Enrico <ebutera@users.berlios.de>,
	Stefan Herbrechtsmeier <sherbrec@cit-ec.uni-bielefeld.de>,
	Javier Martinez Canillas <martinez.javier@gmail.com>,
	Chris Whittenburg <whittenburg@gmail.com>
Subject: Re: [PATCH 09/11] omap3isp: ccdc: Add basic support for interlaced
 video
References: <1401133812-8745-1-git-send-email-laurent.pinchart@ideasonboard.com> <1401133812-8745-10-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1401133812-8745-10-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote:
> When the CCDC input is interlaced enable the alternate field order on
> the CCDC output video node. The field signal polarity is specified
> through platform data.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>   drivers/media/platform/omap3isp/ispccdc.c  | 21 ++++++++++++++++++++-
>   drivers/media/platform/omap3isp/ispvideo.c |  6 ++++++
>   drivers/media/platform/omap3isp/ispvideo.h |  2 ++
>   include/media/omap3isp.h                   |  3 +++
>   4 files changed, 31 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
> index 76d4fd7..49d7256 100644
> --- a/drivers/media/platform/omap3isp/ispccdc.c
> +++ b/drivers/media/platform/omap3isp/ispccdc.c
...
> @@ -1830,6 +1845,11 @@ ccdc_try_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
>   		/* Clamp the input size. */
>   		fmt->width = clamp_t(u32, width, 32, 4096);
>   		fmt->height = clamp_t(u32, height, 32, 4096);
> +
> +		/* Default to progressive field order. */
> +		if (fmt->field == V4L2_FIELD_ANY)
> +			fmt->field = V4L2_FIELD_NONE;

I think this change would better fit in "omap3isp: Default to 
progressive field order when setting the format". Then you could omit " 
when setting the format". :-)

-- 
Kind regards,

Sakari Ailus
sakari.ailus@iki.fi
