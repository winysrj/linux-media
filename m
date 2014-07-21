Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:32611 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933369AbaGUTBh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 15:01:37 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N92009CHSUM7H00@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 21 Jul 2014 15:01:34 -0400 (EDT)
Date: Mon, 21 Jul 2014 16:01:28 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org, Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de
Subject: Re: [PATCH v3 06/32] [media] coda: Add encoder/decoder support for
 CODA960
Message-id: <20140721160128.27eb7428.m.chehab@samsung.com>
In-reply-to: <1405071403-1859-7-git-send-email-p.zabel@pengutronix.de>
References: <1405071403-1859-1-git-send-email-p.zabel@pengutronix.de>
 <1405071403-1859-7-git-send-email-p.zabel@pengutronix.de>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 11 Jul 2014 11:36:17 +0200
Philipp Zabel <p.zabel@pengutronix.de> escreveu:

> This patch adds support for the CODA960 VPU in Freescale i.MX6 SoCs.
> 
> It enables h.264 and MPEG4 encoding and decoding support. Besides the usual
> register shifting, the CODA960 gains frame memory control and GDI registers
> that are set up for linear mapping right now, needs ENC_PIC_SRC_INDEX to be
> set beyond the number of internal buffers for some reason, and has subsampling
> buffers that need to be set up. Also, the work buffer size is increased to
> 80 KiB.
> 
> The CODA960 firmware spins if there is not enough input data in the bitstream
> buffer. To make it continue, buffers need to be copied into the bitstream as
> soon as they are queued. As the bitstream fifo is written into from two places,
> it must be protected with a mutex. For that, using a threaded interrupt handler
> is necessary.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---

...

> +	[CODA_IMX6Q] = {
> +		.firmware   = "v4l-coda960-imx6q.bin",
> +		.product    = CODA_960,
> +		.codecs     = coda9_codecs,
> +		.num_codecs = ARRAY_SIZE(coda9_codecs),
> +	},
> +	[CODA_IMX6DL] = {
> +		.firmware   = "v4l-coda960-imx6dl.bin",
> +		.product    = CODA_960,
> +		.codecs     = coda9_codecs,
> +		.num_codecs = ARRAY_SIZE(coda9_codecs),
> +	},

Where are those firmware files available?

Regards,
Mauro
