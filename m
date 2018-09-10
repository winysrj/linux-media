Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:48960 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727639AbeIJNSJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 09:18:09 -0400
Subject: Re: [PATCH v2 4/4] media: cedrus: Select the sunxi SRAM driver in
 Kconfig
To: Paul Kocialkowski <contact@paulk.fr>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-arm-kernel@lists.infradead.org
Cc: Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-sunxi@googlegroups.com, Randy Li <ayaka@soulik.info>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
References: <20180909191015.20902-1-contact@paulk.fr>
 <20180909191015.20902-5-contact@paulk.fr>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <16fd7291-f51b-b0bc-4299-97adbe197e54@xs4all.nl>
Date: Mon, 10 Sep 2018 10:25:08 +0200
MIME-Version: 1.0
In-Reply-To: <20180909191015.20902-5-contact@paulk.fr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/09/2018 09:10 PM, Paul Kocialkowski wrote:
> Since the sunxi SRAM driver is required to build the Cedrus driver,
> select it in Kconfig.
> 
> Signed-off-by: Paul Kocialkowski <contact@paulk.fr>
> ---
>  drivers/staging/media/sunxi/cedrus/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/media/sunxi/cedrus/Kconfig b/drivers/staging/media/sunxi/cedrus/Kconfig
> index afd7d7ee0388..3b06283e4bf3 100644
> --- a/drivers/staging/media/sunxi/cedrus/Kconfig
> +++ b/drivers/staging/media/sunxi/cedrus/Kconfig
> @@ -3,6 +3,7 @@ config VIDEO_SUNXI_CEDRUS
>  	depends on VIDEO_DEV && VIDEO_V4L2 && MEDIA_CONTROLLER
>  	depends on HAS_DMA
>  	depends on OF
> +	select SUNXI_SRAM
>  	select VIDEOBUF2_DMA_CONTIG
>  	select MEDIA_REQUEST_API

I noticed this select, but CONFIG_MEDIA_REQUEST_API doesn't exist. It's
probably from an old version and I have dropped it from the patch that
added this.

No need for you to do anything.

>  	select V4L2_MEM2MEM_DEV
> 

Regards,

	Hans
