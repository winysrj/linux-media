Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:59184 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491Ab0EaH6U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 May 2010 03:58:20 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Tobias Klauser <tklauser@distanz.ch>,
	"mchehab@infradead.org" <mchehab@infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Mon, 31 May 2010 13:28:03 +0530
Subject: RE: [PATCH 06/11] V4L/DVB: omap_vout: Storage class should be
 before const qualifier
Message-ID: <19F8576C6E063C45BE387C64729E7394044E6D26E3@dbde02.ent.ti.com>
References: <1274344588-9034-1-git-send-email-tklauser@distanz.ch>
In-Reply-To: <1274344588-9034-1-git-send-email-tklauser@distanz.ch>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Tobias Klauser
> Sent: Thursday, May 20, 2010 2:06 PM
> To: mchehab@infradead.org; linux-media@vger.kernel.org
> Cc: kernel-janitors@vger.kernel.org; Tobias Klauser
> Subject: [PATCH 06/11] V4L/DVB: omap_vout: Storage class should be before
> const qualifier
> 
> The C99 specification states in section 6.11.5:
> 
> The placement of a storage-class specifier other than at the beginning
> of the declaration specifiers in a declaration is an obsolescent
> feature.
> 
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
> ---
>  drivers/media/video/omap/omap_vout.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/omap/omap_vout.c
> b/drivers/media/video/omap/omap_vout.c
> index 4c0ab49..d6a2ae1 100644
> --- a/drivers/media/video/omap/omap_vout.c
> +++ b/drivers/media/video/omap/omap_vout.c
> @@ -128,7 +128,7 @@ module_param(debug, bool, S_IRUGO);
>  MODULE_PARM_DESC(debug, "Debug level (0-1)");
> 
>  /* list of image formats supported by OMAP2 video pipelines */
> -const static struct v4l2_fmtdesc omap_formats[] = {
> +static const struct v4l2_fmtdesc omap_formats[] = {
>  	{
>  		/* Note:  V4L2 defines RGB565 as:
>  		 *
Acked-by: Vaibhav Hiremath <hvaibhav@ti.com>

Thanks,
Vaibhav

> --
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
