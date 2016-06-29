Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59182 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784AbcF2TrT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 15:47:19 -0400
Subject: Re: [PATCH 4/6] [media] s5p-jpeg: only fill driver's name in
 capabilities driver field
To: Javier Martinez Canillas <javier@osg.samsung.com>,
	linux-kernel@vger.kernel.org
References: <1466113235-25909-1-git-send-email-javier@osg.samsung.com>
 <1466113235-25909-5-git-send-email-javier@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <577425C5.2000608@osg.samsung.com>
Date: Wed, 29 Jun 2016 13:47:17 -0600
MIME-Version: 1.0
In-Reply-To: <1466113235-25909-5-git-send-email-javier@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/16/2016 03:40 PM, Javier Martinez Canillas wrote:
> The driver fills in both the struct v4l2_capability driver and card fields
> the same values, that is the driver's name plus the information if the dev
> is a decoder or an encoder.
> 
> But the driver field has a fixed length of 16 bytes so the filled data is
> truncated:
> 
> Driver Info (not using libv4l2):
>         Driver name   : s5p-jpeg decode
>         Card type     : s5p-jpeg decoder
>         Bus info      : platform:11f50000.jpeg
>         Driver version: 4.7.0
> 
> Also, this field should only contain the driver's name so use just that.
> The information if the device is a decoder or an encoder is in the card
> type field anyways.
> 
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> ---
> 
>  drivers/media/platform/s5p-jpeg/jpeg-core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> index e3ff3d4bd72e..f9fb52a53e79 100644
> --- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
> +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> @@ -1246,12 +1246,12 @@ static int s5p_jpeg_querycap(struct file *file, void *priv,
>  	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
>  
>  	if (ctx->mode == S5P_JPEG_ENCODE) {
> -		strlcpy(cap->driver, S5P_JPEG_M2M_NAME " encoder",
> +		strlcpy(cap->driver, S5P_JPEG_M2M_NAME,
>  			sizeof(cap->driver));
>  		strlcpy(cap->card, S5P_JPEG_M2M_NAME " encoder",
>  			sizeof(cap->card));
>  	} else {
> -		strlcpy(cap->driver, S5P_JPEG_M2M_NAME " decoder",
> +		strlcpy(cap->driver, S5P_JPEG_M2M_NAME,
>  			sizeof(cap->driver));
>  		strlcpy(cap->card, S5P_JPEG_M2M_NAME " decoder",
>  			sizeof(cap->card));
> 

Looks good.
Reviewed-by: Shuah Khan <shuahkh@osg.samsung.com>

-- Shuah

