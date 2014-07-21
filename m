Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37215 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206AbaGUTTu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 15:19:50 -0400
Date: Mon, 21 Jul 2014 21:19:44 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
	linux-media@vger.kernel.org, Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de
Subject: Re: [PATCH v3 06/32] [media] coda: Add encoder/decoder support for
 CODA960
Message-ID: <20140721191944.GK13730@pengutronix.de>
References: <1405071403-1859-1-git-send-email-p.zabel@pengutronix.de>
 <1405071403-1859-7-git-send-email-p.zabel@pengutronix.de>
 <20140721160128.27eb7428.m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140721160128.27eb7428.m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Mon, Jul 21, 2014 at 04:01:28PM -0300, Mauro Carvalho Chehab wrote:
> > This patch adds support for the CODA960 VPU in Freescale i.MX6 SoCs.
> > 
> > It enables h.264 and MPEG4 encoding and decoding support. Besides the usual
> > register shifting, the CODA960 gains frame memory control and GDI registers
> > that are set up for linear mapping right now, needs ENC_PIC_SRC_INDEX to be
> > set beyond the number of internal buffers for some reason, and has subsampling
> > buffers that need to be set up. Also, the work buffer size is increased to
> > 80 KiB.
> > 
> > The CODA960 firmware spins if there is not enough input data in the bitstream
> > buffer. To make it continue, buffers need to be copied into the bitstream as
> > soon as they are queued. As the bitstream fifo is written into from two places,
> > it must be protected with a mutex. For that, using a threaded interrupt handler
> > is necessary.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> 
> ...
> 
> > +	[CODA_IMX6Q] = {
> > +		.firmware   = "v4l-coda960-imx6q.bin",
> > +		.product    = CODA_960,
> > +		.codecs     = coda9_codecs,
> > +		.num_codecs = ARRAY_SIZE(coda9_codecs),
> > +	},
> > +	[CODA_IMX6DL] = {
> > +		.firmware   = "v4l-coda960-imx6dl.bin",
> > +		.product    = CODA_960,
> > +		.codecs     = coda9_codecs,
> > +		.num_codecs = ARRAY_SIZE(coda9_codecs),
> > +	},
> 
> Where are those firmware files available?

Freescale currently distributes the firmware with their multimedia
packages, but in header hex array form; we are trying to find a proper
solution (hopefully by using the linux firmware repository) for
mainline.

The Freescale kernel people are currently discussing this internally
with their legal folks, see this discussion:

http://www.spinics.net/lists/linux-media/msg78273.html

rsc
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
