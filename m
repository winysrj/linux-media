Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEA83C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 14:30:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A92B621738
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 14:30:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731426AbfAIO35 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 09:29:57 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:55386 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730605AbfAIO35 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Jan 2019 09:29:57 -0500
Received: from [IPv6:2001:420:44c1:2579:f8c4:4546:22d:c704] ([IPv6:2001:420:44c1:2579:f8c4:4546:22d:c704])
        by smtp-cloud7.xs4all.net with ESMTPA
        id hErYgk5pABDyIhErbgX5lK; Wed, 09 Jan 2019 15:29:55 +0100
Subject: Re: [PATCH 2/2] media: cedrus: Allow using the current dst buffer as
 reference
To:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Cc:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen-Yu Tsai <wens@csie.org>, Randy Li <ayaka@soulik.info>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
References: <20190109141920.12677-1-paul.kocialkowski@bootlin.com>
 <20190109141920.12677-2-paul.kocialkowski@bootlin.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <9a624f6a-0c38-f2c9-3f2d-2758f9a19299@xs4all.nl>
Date:   Wed, 9 Jan 2019 15:29:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20190109141920.12677-2-paul.kocialkowski@bootlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfHvQpieu/qhYiJABI7cDkWdbhBzdhR89AXpd3rc78imSyE5YzzwGte5E9IpIGNdUOJ61vx6mvqPuwg93UA6ZbcHEzajFmAAoY8wY2Xeo+76nStXZtvXo
 A42cSvcQwNuqpbHultnZ+RGSx/T6o/cgfB/t0ht7c+ynVrwA6hz1+jk5EKiWty2gE1WmxLEpupOqlnoTFw9doWupcYOV2py3LIutLYQ8YsStyIDOvLy7G4gg
 qPLJ0PaIn3b1+FbTy0IdwCMYDHxBEadtlwIGZOcrqT9/S6vYxEsLoRb4DaEBnt6j1MP5EEqx9J67atroa1wr2RN7iB/F7nRNAzFgWdX3kSt8K6GZPTIkxjc5
 tIiEZtwj8lcNovcH/M67rIK9gOKkL12fu82b5GwQxv5Z84c1IGBFOY9wyVAale4AdqHtbO6bYJG/QpV0xpMZmHK28AtXBb7DA1uVxvwoSDhaNqt5DS5gYGNu
 3TUGlAELU1l+Vy/Ay8RwjPwBAKKf7/XDbUDKHqlAQgWLG6igfWQCCUMC5UGzMuSmgGY5YBqPssif95mcpJ5SwYhu1KyNCJHUoHP35x//WRVF12U0WhVSTy2y
 eJk9G/j7dYn58Z3gkBcj/MIt5ND5bA/RqjtTcHnx4VGAF/oK+C/OzS+ZNuOaimRZSDZFvYR0awLiJd/rw6Mp8sTV4fLg8OcBIP+SCGaz1VSAEz6xdKwBPCOC
 S9i7Pw0OEvt+cpU9NrN/kO9TgGqFnxw4S+EulPQgd+nrkSAKpmdMIU3y//IXfaw6rrIAz1RIhxsZBG13cWiMPLqiLrfKQ+ZcLkUYNAeWevLlSPPixQjkDnOE
 cxmNGAvruG/GLhAu7yE=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 01/09/19 15:19, Paul Kocialkowski wrote:
> It was reported that some cases of interleaved video decoding require
> using the current destination buffer as a reference. However, this is
> no longer possible after the move to vb2_find_timestamp because only
> dequeued and done buffers are considered.
> 
> Add a helper in our driver that also considers the current destination
> buffer before resorting to vb2_find_timestamp and use it in MPEG-2.

This patch looks good, but can you also add checks to handle the case
when no buffer with the given timestamp was found? Probably should be done
in a third patch.

I suspect the driver will crash if an unknown timestamp is passed on to the
driver. I would really like to see that corner case fixed.

Regards,

	Hans

> 
> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> ---
>  drivers/staging/media/sunxi/cedrus/cedrus_dec.c   | 13 +++++++++++++
>  drivers/staging/media/sunxi/cedrus/cedrus_dec.h   |  2 ++
>  drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c | 10 ++++++----
>  3 files changed, 21 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
> index 443fb037e1cf..2c295286766c 100644
> --- a/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
> +++ b/drivers/staging/media/sunxi/cedrus/cedrus_dec.c
> @@ -22,6 +22,19 @@
>  #include "cedrus_dec.h"
>  #include "cedrus_hw.h"
>  
> +int cedrus_reference_index_find(struct vb2_queue *queue,
> +				struct vb2_buffer *vb2_buf, u64 timestamp)
> +{
> +	/*
> +	 * Allow using the current capture buffer as reference, which can occur
> +	 * for field-coded pictures.
> +	 */
> +	if (vb2_buf->timestamp == timestamp)
> +		return vb2_buf->index;
> +	else
> +		return vb2_find_timestamp(queue, timestamp, 0);
> +}
> +
>  void cedrus_device_run(void *priv)
>  {
>  	struct cedrus_ctx *ctx = priv;
> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_dec.h b/drivers/staging/media/sunxi/cedrus/cedrus_dec.h
> index d1ae7903677b..8d0fc248220f 100644
> --- a/drivers/staging/media/sunxi/cedrus/cedrus_dec.h
> +++ b/drivers/staging/media/sunxi/cedrus/cedrus_dec.h
> @@ -16,6 +16,8 @@
>  #ifndef _CEDRUS_DEC_H_
>  #define _CEDRUS_DEC_H_
>  
> +int cedrus_reference_index_find(struct vb2_queue *queue,
> +				struct vb2_buffer *vb2_buf, u64 timestamp);
>  void cedrus_device_run(void *priv);
>  
>  #endif
> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c b/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
> index cb45fda9aaeb..81c66a8aa1ac 100644
> --- a/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
> +++ b/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
> @@ -10,6 +10,7 @@
>  #include <media/videobuf2-dma-contig.h>
>  
>  #include "cedrus.h"
> +#include "cedrus_dec.h"
>  #include "cedrus_hw.h"
>  #include "cedrus_regs.h"
>  
> @@ -159,8 +160,8 @@ static void cedrus_mpeg2_setup(struct cedrus_ctx *ctx, struct cedrus_run *run)
>  	cedrus_write(dev, VE_DEC_MPEG_PICBOUNDSIZE, reg);
>  
>  	/* Forward and backward prediction reference buffers. */
> -	forward_idx = vb2_find_timestamp(cap_q,
> -					 slice_params->forward_ref_ts, 0);
> +	forward_idx = cedrus_reference_index_find(cap_q, &run->dst->vb2_buf,
> +						  slice_params->forward_ref_ts);
>  
>  	fwd_luma_addr = cedrus_dst_buf_addr(ctx, forward_idx, 0);
>  	fwd_chroma_addr = cedrus_dst_buf_addr(ctx, forward_idx, 1);
> @@ -168,8 +169,9 @@ static void cedrus_mpeg2_setup(struct cedrus_ctx *ctx, struct cedrus_run *run)
>  	cedrus_write(dev, VE_DEC_MPEG_FWD_REF_LUMA_ADDR, fwd_luma_addr);
>  	cedrus_write(dev, VE_DEC_MPEG_FWD_REF_CHROMA_ADDR, fwd_chroma_addr);
>  
> -	backward_idx = vb2_find_timestamp(cap_q,
> -					  slice_params->backward_ref_ts, 0);
> +	backward_idx = cedrus_reference_index_find(cap_q, &run->dst->vb2_buf,
> +						   slice_params->backward_ref_ts);
> +
>  	bwd_luma_addr = cedrus_dst_buf_addr(ctx, backward_idx, 0);
>  	bwd_chroma_addr = cedrus_dst_buf_addr(ctx, backward_idx, 1);
>  
> 

