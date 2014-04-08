Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:57818 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaDHGgL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Apr 2014 02:36:11 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N3P001Z79002040@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 08 Apr 2014 07:36:00 +0100 (BST)
Message-id: <534398D5.4090600@samsung.com>
Date: Tue, 08 Apr 2014 08:36:05 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
MIME-version: 1.0
To: Denis Carikli <denis@eukrea.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Cc: =?ISO-8859-1?Q?Eric_B=E9nard?= <eric@eukrea.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Russell King <linux@arm.linux.org.uk>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>
Subject: Re: [PATCH v12][ 07/12] drm: drm_display_mode: add signal polarity
 flags
References: <1396874691-27954-1-git-send-email-denis@eukrea.com>
 <1396874691-27954-7-git-send-email-denis@eukrea.com>
In-reply-to: <1396874691-27954-7-git-send-email-denis@eukrea.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Denis,

On 04/07/2014 02:44 PM, Denis Carikli wrote:
> We need a way to pass signal polarity informations
>   between DRM panels, and the display drivers.
> 
> To do that, a pol_flags field was added to drm_display_mode.
> 
> Signed-off-by: Denis Carikli <denis@eukrea.com>
> ---
> ChangeLog v11->v12:
> - Rebased: This patch now applies against drm_modes.h
> - Rebased: It now uses the new DRM_MODE_FLAG_POL_DE flags defines names
> 
> ChangeLog v10->v11:
> - Since the imx-drm won't be able to retrive its regulators
>   from the device tree when using display-timings nodes,
>   and that I was told that the drm simple-panel driver 
>   already supported that, I then, instead, added what was
>   lacking to make the eukrea displays work with the
>   drm-simple-panel driver.
> 
>   That required a way to get back the display polarity
>   informations from the imx-drm driver without affecting
>   userspace.
> ---
>  include/drm/drm_modes.h |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/include/drm/drm_modes.h b/include/drm/drm_modes.h
> index 2dbbf99..b3789e2 100644
> --- a/include/drm/drm_modes.h
> +++ b/include/drm/drm_modes.h
> @@ -93,6 +93,13 @@ enum drm_mode_status {
>  
>  #define DRM_MODE_FLAG_3D_MAX	DRM_MODE_FLAG_3D_SIDE_BY_SIDE_HALF
>  
> +#define DRM_MODE_FLAG_POL_PIXDATA_NEGEDGE	BIT(1)
> +#define DRM_MODE_FLAG_POL_PIXDATA_POSEDGE	BIT(2)
> +#define DRM_MODE_FLAG_POL_PIXDATA_PRESERVE	BIT(3)

What is the purpose of DRM_MODE_FLAG_POL_PIXDATA_PRESERVE?
If 'preserve' means 'ignore' we can set to zero negedge and posedge bits
instead of adding new bit. If it is something different please describe it.

> +#define DRM_MODE_FLAG_POL_DE_LOW		BIT(4)
> +#define DRM_MODE_FLAG_POL_DE_HIGH		BIT(5)
> +#define DRM_MODE_FLAG_POL_DE_PRESERVE		BIT(6)
> +

The same comments here.

>  struct drm_display_mode {
>  	/* Header */
>  	struct list_head head;
> @@ -144,6 +151,7 @@ struct drm_display_mode {
>  	int vrefresh;		/* in Hz */
>  	int hsync;		/* in kHz */
>  	enum hdmi_picture_aspect picture_aspect_ratio;
> +	unsigned int pol_flags;

Adding field and macros description to the DocBook would be nice.

Regards
Andrzej

>  };
>  
>  /* mode specified on the command line */
> 

