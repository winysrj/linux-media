Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38105 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932995Ab2GBKyq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2012 06:54:46 -0400
Date: Mon, 2 Jul 2012 12:54:27 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, fabio.estevam@freescale.com,
	dirk.behme@googlemail.com, r.schwebel@pengutronix.de,
	kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org
Subject: Re: [RFC] Support for 'Coda' video codec IP.
Message-ID: <20120702105427.GP2698@pengutronix.de>
References: <1340115094-859-1-git-send-email-javier.martin@vista-silicon.com>
 <20120619181717.GE28394@pengutronix.de>
 <CACKLOr1zCp2NfLjBrHjtXpmsFMHqhoHFPpghN=Tyf3YAcyRrYg@mail.gmail.com>
 <20120620090126.GO28394@pengutronix.de>
 <20120620100015.GA30243@sirena.org.uk>
 <20120620130941.GB2253@S2101-09.ap.freescale.net>
 <CACKLOr28vm9n08VSOim=riB54os665be1CHdUqFXk+3MqPqtWQ@mail.gmail.com>
 <20120620143336.GE2253@S2101-09.ap.freescale.net>
 <CACKLOr1oZZPZBNv+p9p3Vf5oY4K8K65_dJ5qkJO6NqeP2=2unw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACKLOr1oZZPZBNv+p9p3Vf5oY4K8K65_dJ5qkJO6NqeP2=2unw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 02, 2012 at 12:36:46PM +0200, javier Martin wrote:
> Hi Sascha,
> I almost have a final version ready which includes multi-instance
> support (not tested though) [1]. As I stated, we assumed the extra
> effort of looking at your code in [2] in order to provide a mechanism
> that preserves compatibility between VPUs in i.MX21, i.MX51 and
> i.MX53. This is the only thing left in order to send the driver for
> mainline submission.
> 
> While I was reading your code I found out that you keep the following
> formats for v1 (codadx6-i.MX27) codec:
> 
> static int vpu_v1_codecs[VPU_CODEC_MAX] = {
> 	[VPU_CODEC_AVC_DEC] = 2,
> 	[VPU_CODEC_VC1_DEC] = -1,
> 	[VPU_CODEC_MP2_DEC] = -1,
> 	[VPU_CODEC_DV3_DEC] = -1,
> 	[VPU_CODEC_RV_DEC] = -1,
> 	[VPU_CODEC_MJPG_DEC] = 0x82,
> 	[VPU_CODEC_AVC_ENC] = 3,
> 	[VPU_CODEC_MP4_ENC] = 1,
> 	[VPU_CODEC_MJPG_ENC] = 0x83,
> };
> 
> As I understand, this means the following operations are supported:
> 
> 1- H264 decoding.
> 2- H264 encoding
> 3- MP4 encoding.
> 4- MJPG  decoding.
> 5- MJPG encoding.
> 
> I totally agree with MP4 and H264 formats but, are you sure about
> MJPG? I have a i.MX27 v1 codec (codadx6) but I didn't know that this
> codec supported MJPG. Have you tested this code with an i.MX27 and
> MJPG? Where did you find out that it supports this format?

We haven't tested MJPG on the i.MX27. The table above is from the
original Freescale code, so I assume it's correct and I assume that
the coda dx6 can do MJPEG.

> Are you
> using firmware version 2.2.4 for v1 codecs?

No, 2.2.5

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
