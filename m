Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:35940 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600AbaHEPjz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Aug 2014 11:39:55 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9U006U2BIG6270@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 05 Aug 2014 16:39:52 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Philipp Zabel' <p.zabel@pengutronix.de>,
	linux-media@vger.kernel.org
Cc: 'Mauro Carvalho Chehab' <m.chehab@samsung.com>,
	'Fabio Estevam' <fabio.estevam@freescale.com>,
	'Hans Verkuil' <hverkuil@xs4all.nl>,
	'Nicolas Dufresne' <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, 'Michael Olbrich' <m.olbrich@pengutronix.de>
References: <1405678965-10473-1-git-send-email-p.zabel@pengutronix.de>
 <1405678965-10473-6-git-send-email-p.zabel@pengutronix.de>
In-reply-to: <1405678965-10473-6-git-send-email-p.zabel@pengutronix.de>
Subject: RE: [PATCH v2 05/11] [media] coda: use CODA_MAX_FRAME_SIZE everywhere
Date: Tue, 05 Aug 2014 17:39:55 +0200
Message-id: <0c3e01cfb0c3$826397b0$872ac710$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Checkpatch:
------------------------------
WARNING: line over 80 characters
#41: FILE: drivers/media/platform/coda.c:3109:
+		if (coda_get_bitstream_payload(ctx) >= CODA_MAX_FRAME_SIZE -
512)

-- 
Kamil Debski
Samsung R&D Institute Poland


> -----Original Message-----
> From: Philipp Zabel [mailto:p.zabel@pengutronix.de]
> Sent: Friday, July 18, 2014 12:23 PM
> To: linux-media@vger.kernel.org
> Cc: Mauro Carvalho Chehab; Kamil Debski; Fabio Estevam; Hans Verkuil;
> Nicolas Dufresne; kernel@pengutronix.de; Michael Olbrich; Philipp Zabel
> Subject: [PATCH v2 05/11] [media] coda: use CODA_MAX_FRAME_SIZE
> everywhere
> 
> From: Michael Olbrich <m.olbrich@pengutronix.de>
> 
> Without this changing CODA_MAX_FRAME_SIZE to anything other than
> 0x100000 can break the bitstram handling
> 
> Signed-off-by: Michael Olbrich <m.olbrich@pengutronix.de>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/platform/coda.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/coda.c
> b/drivers/media/platform/coda.c index 917727e..141ec29 100644
> --- a/drivers/media/platform/coda.c
> +++ b/drivers/media/platform/coda.c
> @@ -3106,7 +3106,7 @@ static void coda_finish_decode(struct coda_ctx
> *ctx)
>  	 * by up to 512 bytes
>  	 */
>  	if (ctx->bit_stream_param & CODA_BIT_STREAM_END_FLAG) {
> -		if (coda_get_bitstream_payload(ctx) >= 0x100000 - 512)
> +		if (coda_get_bitstream_payload(ctx) >= CODA_MAX_FRAME_SIZE
> - 512)
>  			kfifo_init(&ctx->bitstream_fifo,
>  				ctx->bitstream.vaddr, ctx->bitstream.size);
>  	}
> --
> 2.0.1

