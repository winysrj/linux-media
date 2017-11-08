Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:57899 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752510AbdKHPRi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 8 Nov 2017 10:17:38 -0500
Message-ID: <1510154254.9225.6.camel@pengutronix.de>
Subject: Re: [PATCH] media: coda: Fix definition of CODA_STD_MJPG
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Martin Kepplinger <martink@posteo.de>, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 08 Nov 2017 16:17:34 +0100
In-Reply-To: <20171108141247.24824-1-martink@posteo.de>
References: <20171108141247.24824-1-martink@posteo.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Martin,

thank you for the patch. I'd prefer to just drop CODA_STD_MJPG
altogether, to avoid confusion. Explanation below:

On Wed, 2017-11-08 at 15:12 +0100, Martin Kepplinger wrote:
> According to i.MX 6 VPU API Reference Manual Rev. L3.0.35_1.1.0, 01/2013
> chapter 3.2.1.5, the MJPG video codec is refernced to by number 7, not 3.
> So change this accordingly.
> 
> This isn't yet being used right now and therefore probably hasn't been
> noticed. Fixing this avoids causing trouble in the future.
> 
> Signed-off-by: Martin Kepplinger <martink@posteo.de>
> ---
>  drivers/media/platform/coda/coda_regs.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/coda/coda_regs.h b/drivers/media/platform/coda/coda_regs.h
> index 38df5fd9a2fa..8d726faaf86e 100644
> --- a/drivers/media/platform/coda/coda_regs.h
> +++ b/drivers/media/platform/coda/coda_regs.h
> @@ -254,7 +254,7 @@
>  #define		CODA9_STD_H264					0
>  #define		CODA_STD_H263					1
>  #define		CODA_STD_H264					2
> -#define		CODA_STD_MJPG					3
> +#define		CODA_STD_MJPG					7

These are only ever used to feed them into the CMD_ENC_SEQ_COD_STD
register, and only for MPEG4, H263 (which we don't support), and H264.

On i.MX53 the correct value was 3 once, but it was only used in the
userspace library, it was never written to any register. On i.MX6 JPEG
encoding can be implemented without going through the BIT processor at
all.

regards
Philipp
