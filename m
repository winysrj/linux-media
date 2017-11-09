Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:57779 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753927AbdKIJLT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 9 Nov 2017 04:11:19 -0500
Message-ID: <1510218675.7659.0.camel@pengutronix.de>
Subject: Re: [PATCH] media: coda: remove definition of CODA_STD_MJPG
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Martin Kepplinger <martink@posteo.de>, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 09 Nov 2017 10:11:15 +0100
In-Reply-To: <20171108185803.12408-1-martink@posteo.de>
References: <20171108185803.12408-1-martink@posteo.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2017-11-08 at 19:58 +0100, Martin Kepplinger wrote:
> According to i.MX VPU API Reference Manuals the MJPG video codec is
> refernced to by number 7, not 3.
> 
> Also Philipp pointed out that this value is only meant to fill in
> CMD_ENC_SEQ_COD_STD for encoding, only on i.MX53. It was never written
> to any register, and even if defined correctly, wouldn't be needed
> for i.MX6.
> 
> So avoid confusion and remove this definition.
> 
> Signed-off-by: Martin Kepplinger <martink@posteo.de>
> ---
>  drivers/media/platform/coda/coda_regs.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/media/platform/coda/coda_regs.h b/drivers/media/platform/coda/coda_regs.h
> index 38df5fd9a2fa..35e620c7f1f4 100644
> --- a/drivers/media/platform/coda/coda_regs.h
> +++ b/drivers/media/platform/coda/coda_regs.h
> @@ -254,7 +254,6 @@
>  #define		CODA9_STD_H264					0
>  #define		CODA_STD_H263					1
>  #define		CODA_STD_H264					2
> -#define		CODA_STD_MJPG					3
>  #define		CODA9_STD_MPEG4					3
>  
>  #define CODA_CMD_ENC_SEQ_SRC_SIZE				0x190

Thanks,

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
