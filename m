Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59173 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbaGVMui (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 08:50:38 -0400
Message-ID: <1406033433.4496.16.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH v3 06/32] [media] coda: Add encoder/decoder support for
 CODA960
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Robert Schwebel <r.schwebel@pengutronix.de>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de
Date: Tue, 22 Jul 2014 14:50:33 +0200
In-Reply-To: <20140721191944.GK13730@pengutronix.de>
References: <1405071403-1859-1-git-send-email-p.zabel@pengutronix.de>
	 <1405071403-1859-7-git-send-email-p.zabel@pengutronix.de>
	 <20140721160128.27eb7428.m.chehab@samsung.com>
	 <20140721191944.GK13730@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Montag, den 21.07.2014, 21:19 +0200 schrieb Robert Schwebel:
> Hi Mauro,
> 
> On Mon, Jul 21, 2014 at 04:01:28PM -0300, Mauro Carvalho Chehab wrote:
> > > This patch adds support for the CODA960 VPU in Freescale i.MX6 SoCs.
> > > 
> > > It enables h.264 and MPEG4 encoding and decoding support. Besides the usual
> > > register shifting, the CODA960 gains frame memory control and GDI registers
> > > that are set up for linear mapping right now, needs ENC_PIC_SRC_INDEX to be
> > > set beyond the number of internal buffers for some reason, and has subsampling
> > > buffers that need to be set up. Also, the work buffer size is increased to
> > > 80 KiB.
> > > 
> > > The CODA960 firmware spins if there is not enough input data in the bitstream
> > > buffer. To make it continue, buffers need to be copied into the bitstream as
> > > soon as they are queued. As the bitstream fifo is written into from two places,
> > > it must be protected with a mutex. For that, using a threaded interrupt handler
> > > is necessary.
> > > 
> > > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > > ---
> > 
> > ...
> > 
> > > +	[CODA_IMX6Q] = {
> > > +		.firmware   = "v4l-coda960-imx6q.bin",
> > > +		.product    = CODA_960,
> > > +		.codecs     = coda9_codecs,
> > > +		.num_codecs = ARRAY_SIZE(coda9_codecs),
> > > +	},
> > > +	[CODA_IMX6DL] = {
> > > +		.firmware   = "v4l-coda960-imx6dl.bin",
> > > +		.product    = CODA_960,
> > > +		.codecs     = coda9_codecs,
> > > +		.num_codecs = ARRAY_SIZE(coda9_codecs),
> > > +	},
> > 
> > Where are those firmware files available?
> 
> Freescale currently distributes the firmware with their multimedia
> packages, but in header hex array form; we are trying to find a proper
> solution (hopefully by using the linux firmware repository) for
> mainline.

The firmware-imx packages referenced in the Freescale meta-fsl-arm
repository on github.com contain VPU firmware files. Their use is
restricted by an EULA. For example:
http://www.freescale.com/lgfiles/NMG/MAD/YOCTO/firmware-imx-3.0.35-4.0.0.bin

This contains the files vpu_fw_imx6q.bin and vpu_fw_imx6d.bin, which can
be converted into v4l-coda960-imx6q.bin and v4l-coda960-imx6dl.bin,
respectively, by dropping the headers and reordering the rest.
I described this for i.MX53 earlier here:
http://lists.infradead.org/pipermail/linux-arm-kernel/2013-July/181101.html

> The Freescale kernel people are currently discussing this internally
> with their legal folks, see this discussion:
> 
> http://www.spinics.net/lists/linux-media/msg78273.html

regards
Philipp

