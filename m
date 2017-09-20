Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:42387 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751783AbdITIaR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 04:30:17 -0400
Message-ID: <1505896209.7865.1.camel@pengutronix.de>
Subject: Re: [PATCH 1/2] [media] coda: Handle return value of kasprintf
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Arvind Yadav <arvind.yadav.cs@gmail.com>, mchehab@kernel.org,
        hans.verkuil@cisco.com, sean@mess.org, andi.shyti@samsung.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 20 Sep 2017 10:30:09 +0200
In-Reply-To: <1505893033-7491-2-git-send-email-arvind.yadav.cs@gmail.com>
References: <1505893033-7491-1-git-send-email-arvind.yadav.cs@gmail.com>
         <1505893033-7491-2-git-send-email-arvind.yadav.cs@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arvind,

On Wed, 2017-09-20 at 13:07 +0530, Arvind Yadav wrote:
> kasprintf() can fail here and we must check its return value.
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
> ---
>  drivers/media/platform/coda/coda-bit.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
> index 291c409..8d78183 100644
> --- a/drivers/media/platform/coda/coda-bit.c
> +++ b/drivers/media/platform/coda/coda-bit.c
> @@ -417,6 +417,9 @@ static int coda_alloc_framebuffers(struct coda_ctx *ctx,
> >  		    dev->devtype->product != CODA_DX6)
> >  			size += ysize / 4;
> >  		name = kasprintf(GFP_KERNEL, "fb%d", i);
> +		if (!name)
> +			return -ENOMEM;
> +

Thank you for the patch. Instead of just returning here, this should
also call coda_free_framebuffers to release already allocated buffers in
earlier iterations of the loop.

regards
Philipp
