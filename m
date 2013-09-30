Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3129 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540Ab3I3Lsg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Sep 2013 07:48:36 -0400
Message-ID: <524964F9.80804@xs4all.nl>
Date: Mon, 30 Sep 2013 13:48:09 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Subject: Re: [PATCH 04/10] [media] coda: fix FMO value setting for CodaDx6
References: <1379582036-4840-1-git-send-email-p.zabel@pengutronix.de> <1379582036-4840-5-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1379582036-4840-5-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/19/2013 11:13 AM, Philipp Zabel wrote:
> The register is only written on CodaDx6, so the temporary variable
> to be written only needs to be initialized on CodaDx6.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/platform/coda.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> index 53539c1..e8acff3 100644
> --- a/drivers/media/platform/coda.c
> +++ b/drivers/media/platform/coda.c
> @@ -2074,10 +2074,10 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
>  	coda_setup_iram(ctx);
>  
>  	if (dst_fourcc == V4L2_PIX_FMT_H264) {
> -		value  = (FMO_SLICE_SAVE_BUF_SIZE << 7);
> -		value |= (0 & CODA_FMOPARAM_TYPE_MASK) << CODA_FMOPARAM_TYPE_OFFSET;
> -		value |=  0 & CODA_FMOPARAM_SLICENUM_MASK;
>  		if (dev->devtype->product == CODA_DX6) {
> +			value  = (FMO_SLICE_SAVE_BUF_SIZE << 7);
> +			value |= (0 & CODA_FMOPARAM_TYPE_MASK) << CODA_FMOPARAM_TYPE_OFFSET;
> +			value |=  0 & CODA_FMOPARAM_SLICENUM_MASK;

0 & CODA_FMOPARAM_SLICENUM_MASK?

These last two lines evaluate to a nop, so that looks very weird. Is this a bug?

Regards,

	Hans

>  			coda_write(dev, value, CODADX6_CMD_ENC_SEQ_FMO);
>  		} else {
>  			coda_write(dev, ctx->iram_info.search_ram_paddr,
> 

