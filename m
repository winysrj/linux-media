Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:35699 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbaGBM6O (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jul 2014 08:58:14 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N83009MU5CSES10@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 02 Jul 2014 13:58:04 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Philipp Zabel' <p.zabel@pengutronix.de>,
	linux-media@vger.kernel.org
Cc: 'Mauro Carvalho Chehab' <m.chehab@samsung.com>,
	'Fabio Estevam' <fabio.estevam@freescale.com>,
	kernel@pengutronix.de
References: <1403621771-11636-1-git-send-email-p.zabel@pengutronix.de>
 <1403621771-11636-24-git-send-email-p.zabel@pengutronix.de>
In-reply-to: <1403621771-11636-24-git-send-email-p.zabel@pengutronix.de>
Subject: RE: [PATCH v2 23/29] [media] coda: use prescan_failed variable to stop
 stream after a timeout
Date: Wed, 02 Jul 2014 14:58:13 +0200
Message-id: <0b3901cf95f5$493770d0$dba65270$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> From: Philipp Zabel [mailto:p.zabel@pengutronix.de]
> Sent: Tuesday, June 24, 2014 4:56 PM
> To: linux-media@vger.kernel.org
> Cc: Mauro Carvalho Chehab; Kamil Debski; Fabio Estevam;
> kernel@pengutronix.de; Philipp Zabel
> Subject: [PATCH v2 23/29] [media] coda: use prescan_failed variable to
> stop stream after a timeout
> 
> This variable should be renamed to hold instead (temporarily stopping
> streaming until new data is fed into the bitstream buffer).

Could you explain this commit message to me? If the name should be changed
then why isn't it done in this patch or any subsequent patches?

> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/platform/coda.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/media/platform/coda.c
> b/drivers/media/platform/coda.c index 4548c84..cded081 100644
> --- a/drivers/media/platform/coda.c
> +++ b/drivers/media/platform/coda.c
> @@ -1423,6 +1423,8 @@ static void coda_pic_run_work(struct work_struct
> *work)
> 
>  	if (!wait_for_completion_timeout(&ctx->completion,
> msecs_to_jiffies(1000))) {
>  		dev_err(&dev->plat_dev->dev, "CODA PIC_RUN timeout\n");
> +
> +		ctx->prescan_failed = true;
>  	} else if (!ctx->aborting) {
>  		if (ctx->inst_type == CODA_INST_DECODER)
>  			coda_finish_decode(ctx);
> --
> 2.0.0

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

