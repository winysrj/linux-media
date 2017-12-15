Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:52001 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756551AbdLOO7I (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 09:59:08 -0500
Message-ID: <1513349945.7518.10.camel@pengutronix.de>
Subject: Re: [PATCH 2/2] media: coda: Add i.MX51 (CodaHx4) support
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Chris Healy <Chris.Healy@zii.aero>, devicetree@vger.kernel.org,
        kernel@pengutronix.de
Date: Fri, 15 Dec 2017 15:59:05 +0100
In-Reply-To: <e26f7f6a-afa6-c55c-d94e-095df27c19ae@xs4all.nl>
References: <20171213140918.22500-1-p.zabel@pengutronix.de>
         <20171213140918.22500-2-p.zabel@pengutronix.de>
         <e26f7f6a-afa6-c55c-d94e-095df27c19ae@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, 2017-12-15 at 15:22 +0100, Hans Verkuil wrote:
> Hi Philipp,
> 
> On 13/12/17 15:09, Philipp Zabel wrote:
> > Add support for the CodaHx4 VPU used on i.MX51.
> > 
> > Decoding h.264, MPEG-4, and MPEG-2 video works, as well as encoding
> > h.264. MPEG-4 encoding is not enabled, it currently produces visual
> > artifacts.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> >  drivers/media/platform/coda/coda-bit.c    | 45 ++++++++++++++++++++++---------
> >  drivers/media/platform/coda/coda-common.c | 44 +++++++++++++++++++++++++++---
> >  drivers/media/platform/coda/coda.h        |  1 +
> >  3 files changed, 74 insertions(+), 16 deletions(-)
> > 
> 
> <snip>
> 
> > +	[CODA_IMX51] = {
> > +		.firmware     = {
> > +			"vpu_fw_imx51.bin",
> > +			"vpu/vpu_fw_imx51.bin",
> > +			"v4l-codahx4-imx51.bin"
> > +		},
> > +		.product      = CODA_HX4,
> > +		.codecs       = codahx4_codecs,
> > +		.num_codecs   = ARRAY_SIZE(codahx4_codecs),
> > +		.vdevs        = codahx4_video_devices,
> > +		.num_vdevs    = ARRAY_SIZE(codahx4_video_devices),
> > +		.workbuf_size = 128 * 1024,
> > +		.tempbuf_size = 304 * 1024,
> > +		.iram_size    = 0x14000,
> > +	},
> 
> What's the status of the firmware? Is it going to be available in some firmware
> repository? I remember when testing other imx devices that it was a bit tricky
> to get hold of the firmware. And googling v4l-codahx4-imx51.bin doesn't find
> anything other than this patch.

As far as I am aware, so far all efforts to get these firmware binaries
relicensed in a way that makes them redistributable in linux-firmware
have not succeeded.

They are distributed by NXP directly in the firmware-imx package.
The http://git.yoctoproject.org/cgit/cgit.cgi/meta-fsl-arm/ repository
contains links to the latest version:

  wget http://www.nxp.com/lgfiles/NMG/MAD/YOCTO/firmware-imx-5.4.bin
  dd if=firmware-imx-5.4.bin bs=34087 skip=1 | tar xj
  cat firmware-imx-5.4/COPYING

regards
Philipp
