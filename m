Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:44580
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752139AbcJCJ62 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Oct 2016 05:58:28 -0400
Date: Mon, 3 Oct 2016 06:58:22 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Wayne Porter <wporter82@gmail.com>
Cc: laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH] [media] v4l: omap4iss: Fix using BIT macro
Message-ID: <20161003065822.65e43177@vento.lan>
In-Reply-To: <20161001233746.nowzbvhimd3jutbz@Chronos>
References: <20161001233746.nowzbvhimd3jutbz@Chronos>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 1 Oct 2016 16:37:46 -0700
Wayne Porter <wporter82@gmail.com> escreveu:

> Checks found by checkpatch
> 
> Signed-off-by: Wayne Porter <wporter82@gmail.com>
> ---
>  drivers/staging/media/omap4iss/iss_regs.h | 76 +++++++++++++++----------------
>  1 file changed, 38 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/staging/media/omap4iss/iss_regs.h b/drivers/staging/media/omap4iss/iss_regs.h
> index cb415e8..c675212 100644
> --- a/drivers/staging/media/omap4iss/iss_regs.h
> +++ b/drivers/staging/media/omap4iss/iss_regs.h
> @@ -42,7 +42,7 @@
>  #define ISS_CTRL_CLK_DIV_MASK				(3 << 4)
>  #define ISS_CTRL_INPUT_SEL_MASK				(3 << 2)
>  #define ISS_CTRL_INPUT_SEL_CSI2A			(0 << 2)
> -#define ISS_CTRL_INPUT_SEL_CSI2B			(1 << 2)
> +#define ISS_CTRL_INPUT_SEL_CSI2B			BIT(2)

Converting just a few of such macros won't help. Either convert all
or none.

Also, as most of the bit masks here have more than one bit, you should
use GENMASK(), instead of BIT, like:

#define ISS_CTRL_CLK_DIV_MASK		GENMASK(4, 5)
#define ISS_CTRL_INPUT_SEL_MASK		GENMASK(2, 3)
#define   ISS_CTRL_INPUT_SEL_CSI2A	0
#define   ISS_CTRL_INPUT_SEL_CSI2B	BIT(2)

Yet, not sure if I would like such patch, as this kind of change
could easily break the driver if you make any typo at the GENMASK
parameters.


Thanks,
Mauro
