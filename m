Return-path: <linux-media-owner@vger.kernel.org>
Received: from hqemgate15.nvidia.com ([216.228.121.64]:11065 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbbHUNFA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2015 09:05:00 -0400
Date: Fri, 21 Aug 2015 15:03:41 +0200
From: Thierry Reding <treding@nvidia.com>
To: Bryan Wu <pengw@nvidia.com>
CC: <hansverk@cisco.com>, <linux-media@vger.kernel.org>,
	<ebrower@nvidia.com>, <jbang@nvidia.com>, <swarren@nvidia.com>,
	<wenjiaz@nvidia.com>, <davidw@nvidia.com>, <gfitzer@nvidia.com>
Subject: Re: [PATCH 1/2] [media] v4l: tegra: Add NVIDIA Tegra VI driver
Message-ID: <20150821130339.GB22118@ulmo.nvidia.com>
References: <1440118300-32491-1-git-send-email-pengw@nvidia.com>
 <1440118300-32491-5-git-send-email-pengw@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <1440118300-32491-5-git-send-email-pengw@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="+pHx0qQiF2pBVqBT"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--+pHx0qQiF2pBVqBT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 20, 2015 at 05:51:39PM -0700, Bryan Wu wrote:
> NVIDIA Tegra processor contains a powerful Video Input (VI) hardware
> controller which can support up to 6 MIPI CSI camera sensors.
>=20
> This patch adds a V4L2 media controller and capture driver to support
> Tegra VI hardware. It's verified with Tegra built-in test pattern
> generator.

Hi Bryan,

I've been looking forward to seeing this posted. I don't know the VI
hardware in very much detail, nor am I an expert on the media framework,
so I will primarily comment on architectural or SoC-specific things.

By the way, please always Cc linux-tegra@vger.kernel.org on all patches
relating to Tegra. That way people not explicitly Cc'ed but still
interested in Tegra will see this code, even if they aren't subscribed
to the linux-media mailing list.

> Signed-off-by: Bryan Wu <pengw@nvidia.com>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/Kconfig               |    1 +
>  drivers/media/platform/Makefile              |    2 +
>  drivers/media/platform/tegra/Kconfig         |    9 +
>  drivers/media/platform/tegra/Makefile        |    3 +
>  drivers/media/platform/tegra/tegra-channel.c | 1074 ++++++++++++++++++++=
++++++
>  drivers/media/platform/tegra/tegra-core.c    |  295 +++++++
>  drivers/media/platform/tegra/tegra-core.h    |  134 ++++
>  drivers/media/platform/tegra/tegra-vi.c      |  585 ++++++++++++++
>  drivers/media/platform/tegra/tegra-vi.h      |  224 ++++++
>  include/dt-bindings/media/tegra-vi.h         |   35 +
>  10 files changed, 2362 insertions(+)
>  create mode 100644 drivers/media/platform/tegra/Kconfig
>  create mode 100644 drivers/media/platform/tegra/Makefile
>  create mode 100644 drivers/media/platform/tegra/tegra-channel.c
>  create mode 100644 drivers/media/platform/tegra/tegra-core.c
>  create mode 100644 drivers/media/platform/tegra/tegra-core.h
>  create mode 100644 drivers/media/platform/tegra/tegra-vi.c
>  create mode 100644 drivers/media/platform/tegra/tegra-vi.h
>  create mode 100644 include/dt-bindings/media/tegra-vi.h

I can't spot a device tree binding document for this, but we'll need one
to properly review this driver.

> diff --git a/drivers/media/platform/tegra/Kconfig b/drivers/media/platfor=
m/tegra/Kconfig
> new file mode 100644
> index 0000000..a69d1b2
> --- /dev/null
> +++ b/drivers/media/platform/tegra/Kconfig
> @@ -0,0 +1,9 @@
> +config VIDEO_TEGRA
> +	tristate "NVIDIA Tegra Video Input Driver (EXPERIMENTAL)"

I don't think the (EXPERIMENTAL) is warranted. Either the driver works
or it doesn't. And I assume you already tested that it works, even if
only using the TPG.

> +	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF

This seems to be missing a couple of dependencies. For example I would
expect at least TEGRA_HOST1X to be listed here to make sure people can't
select this when the host1x API isn't available. I would also expect
some sort of architecture dependency because it really makes no sense to
build this if Tegra isn't supported.

If you are concerned about compile coverage you can make that explicit
using a COMPILE_TEST alternative such as:

	depends on ARCH_TEGRA || (ARM && COMPILE_TEST)

Note that the ARM dependency in there makes sure that HAVE_IOMEM is
selected, so this could also be:

	depends on ARCH_TEGRA || (HAVE_IOMEM && COMPILE_TEST)

though that'd still leave open the possibility of build breakage because
of some missing support.

If you add the dependency on TEGRA_HOST1X that I mentioned above you
shouldn't need any architecture dependency because TEGRA_HOST1X implies
those already.

> +	select VIDEOBUF2_DMA_CONTIG
> +	---help---
> +	  Driver for Video Input (VI) device controller in NVIDIA Tegra SoC.

I'd reword this slightly as:

	  Driver for the Video Input (VI) controller found on NVIDIA Tegra
	  SoCs.

> +
> +	  TO compile this driver as a module, choose M here: the module will be

s/TO/To/.

> +	  called tegra-video.

> diff --git a/drivers/media/platform/tegra/Makefile b/drivers/media/platfo=
rm/tegra/Makefile
> new file mode 100644
> index 0000000..c8eff0b
> --- /dev/null
> +++ b/drivers/media/platform/tegra/Makefile
> @@ -0,0 +1,3 @@
> +tegra-video-objs +=3D tegra-core.o tegra-vi.o tegra-channel.o

I'd personally leave out the redundant tegra- prefix here, because the
files are in a tegra/ subdirectory already.

> +obj-$(CONFIG_VIDEO_TEGRA) +=3D tegra-video.o
> diff --git a/drivers/media/platform/tegra/tegra-channel.c b/drivers/media=
/platform/tegra/tegra-channel.c
> new file mode 100644
> index 0000000..b0063d2
> --- /dev/null
> +++ b/drivers/media/platform/tegra/tegra-channel.c
> @@ -0,0 +1,1074 @@
> +/*
> + * NVIDIA Tegra Video Input Device
> + *
> + * Copyright (c) 2015, NVIDIA CORPORATION.  All rights reserved.
> + *
> + * Author: Bryan Wu <pengw@nvidia.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/atomic.h>
> +#include <linux/bitmap.h>
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/host1x.h>
> +#include <linux/lcm.h>
> +#include <linux/list.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/slab.h>
> +
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-dev.h>
> +#include <media/v4l2-fh.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/videobuf2-core.h>
> +#include <media/videobuf2-dma-contig.h>
> +
> +#include <soc/tegra/pmc.h>
> +
> +#include "tegra-vi.h"
> +
> +#define TEGRA_VI_SYNCPT_WAIT_TIMEOUT			200
> +
> +/* VI registers */
> +#define TEGRA_VI_CFG_VI_INCR_SYNCPT                     0x000
> +#define		SP_PP_LINE_START			4
> +#define		SP_PP_FRAME_START			5
> +#define		SP_MW_REQ_DONE				6
> +#define		SP_MW_ACK_DONE				7

Indentation is weird here. There also seems to be a mix of spaces and
tabs in the register definitions below. I find that these end up hard to
read, so it'd be good to make these consistent.

> +/* CSI registers */
> +#define TEGRA_VI_CSI_0_BASE                             0x100
> +#define TEGRA_VI_CSI_1_BASE                             0x200
> +#define TEGRA_VI_CSI_2_BASE                             0x300
> +#define TEGRA_VI_CSI_3_BASE                             0x400
> +#define TEGRA_VI_CSI_4_BASE                             0x500
> +#define TEGRA_VI_CSI_5_BASE                             0x600

You seem to be computing these offsets later on based on the CSI 0 base
and an offset multiplied by the instance number. Perhaps define this as

	#define TEGRA_VI_CSI_BASE(x)	(0x100 + (x) * 0x100)

to avoid the unused defines as well as the computation later on?

> +/* CSI Pixel Parser registers */
> +#define TEGRA_CSI_PIXEL_PARSER_0_BASE			0x0838
> +#define TEGRA_CSI_PIXEL_PARSER_1_BASE			0x086c
> +#define TEGRA_CSI_PIXEL_PARSER_2_BASE			0x1038
> +#define TEGRA_CSI_PIXEL_PARSER_3_BASE			0x106c
> +#define TEGRA_CSI_PIXEL_PARSER_4_BASE			0x1838
> +#define TEGRA_CSI_PIXEL_PARSER_5_BASE			0x186c

Same comment as for TEGRA_VI_CSI_*_BASE above. Only the first of these
is used.

> +
> +
> +/* CSI Pixel Parser registers */
> +#define TEGRA_CSI_INPUT_STREAM_CONTROL                  0x000
> +#define TEGRA_CSI_PIXEL_STREAM_CONTROL0                 0x004
> +#define TEGRA_CSI_PIXEL_STREAM_CONTROL1                 0x008
> +#define TEGRA_CSI_PIXEL_STREAM_GAP                      0x00c
> +#define TEGRA_CSI_PIXEL_STREAM_PP_COMMAND               0x010
> +#define TEGRA_CSI_PIXEL_STREAM_EXPECTED_FRAME           0x014
> +#define TEGRA_CSI_PIXEL_PARSER_INTERRUPT_MASK           0x018
> +#define TEGRA_CSI_PIXEL_PARSER_STATUS                   0x01c
> +#define TEGRA_CSI_CSI_SW_SENSOR_RESET                   0x020
> +
> +/* CSI PHY registers */
> +#define TEGRA_CSI_CIL_PHY_0_BASE			0x0908
> +#define TEGRA_CSI_CIL_PHY_1_BASE			0x1108
> +#define TEGRA_CSI_CIL_PHY_2_BASE			0x1908

Same as for the other base offsets.

> +#define TEGRA_CSI_PHY_CIL_COMMAND			0x0908

This doesn't seem to be used at all.

> +/* CSI CIL registers */
> +#define TEGRA_CSI_CIL_0_BASE				0x092c
> +#define TEGRA_CSI_CIL_1_BASE				0x0960
> +#define TEGRA_CSI_CIL_2_BASE				0x112c
> +#define TEGRA_CSI_CIL_3_BASE				0x1160
> +#define TEGRA_CSI_CIL_4_BASE				0x192c
> +#define TEGRA_CSI_CIL_5_BASE				0x1960

Again, unused base defines, so might be better to go with a
parameterized definition.

> +#define TEGRA_CSI_CIL_PAD_CONFIG0                       0x000
> +#define TEGRA_CSI_CIL_PAD_CONFIG1                       0x004
> +#define TEGRA_CSI_CIL_PHY_CONTROL                       0x008
> +#define TEGRA_CSI_CIL_INTERRUPT_MASK                    0x00c
> +#define TEGRA_CSI_CIL_STATUS                            0x010
> +#define TEGRA_CSI_CILX_STATUS                           0x014
> +#define TEGRA_CSI_CIL_ESCAPE_MODE_COMMAND               0x018
> +#define TEGRA_CSI_CIL_ESCAPE_MODE_DATA                  0x01c
> +#define TEGRA_CSI_CIL_SW_SENSOR_RESET                   0x020
> +
> +/* CSI Pattern Generator registers */
> +#define TEGRA_CSI_PATTERN_GENERATOR_0_BASE		0x09c4
> +#define TEGRA_CSI_PATTERN_GENERATOR_1_BASE		0x09f8
> +#define TEGRA_CSI_PATTERN_GENERATOR_2_BASE		0x11c4
> +#define TEGRA_CSI_PATTERN_GENERATOR_3_BASE		0x11f8
> +#define TEGRA_CSI_PATTERN_GENERATOR_4_BASE		0x19c4
> +#define TEGRA_CSI_PATTERN_GENERATOR_5_BASE		0x19f8

More unused base defines.

> +#define TEGRA_CSI_PATTERN_GENERATOR_CTRL		0x000
> +#define TEGRA_CSI_PG_BLANK				0x004
> +#define TEGRA_CSI_PG_PHASE				0x008
> +#define TEGRA_CSI_PG_RED_FREQ				0x00c
> +#define TEGRA_CSI_PG_RED_FREQ_RATE			0x010
> +#define TEGRA_CSI_PG_GREEN_FREQ				0x014
> +#define TEGRA_CSI_PG_GREEN_FREQ_RATE			0x018
> +#define TEGRA_CSI_PG_BLUE_FREQ				0x01c
> +#define TEGRA_CSI_PG_BLUE_FREQ_RATE			0x020
> +#define TEGRA_CSI_PG_AOHDR				0x024
> +
> +#define TEGRA_CSI_DPCM_CTRL_A				0xad0
> +#define TEGRA_CSI_DPCM_CTRL_B				0xad4
> +#define TEGRA_CSI_STALL_COUNTER				0xae8
> +#define TEGRA_CSI_CSI_READONLY_STATUS			0xaec
> +#define TEGRA_CSI_CSI_SW_STATUS_RESET			0xaf0
> +#define TEGRA_CSI_CLKEN_OVERRIDE			0xaf4
> +#define TEGRA_CSI_DEBUG_CONTROL				0xaf8
> +#define TEGRA_CSI_DEBUG_COUNTER_0			0xafc
> +#define TEGRA_CSI_DEBUG_COUNTER_1			0xb00
> +#define TEGRA_CSI_DEBUG_COUNTER_2			0xb04

Some of these are unused. I guess there's an argument to be made to
include all register definitions rather than just the used ones, if for
nothing else than completeness. I'll defer to Hans's judgement on this.

> +/* Channel registers */
> +static void tegra_channel_write(struct tegra_channel *chan, u32 addr, u3=
2 val)

I prefer unsigned int offset instead of u32 addr. That makes in more
obvious that this is actually an offset from some I/O memory base
address. Also using a sized type for the offset is a bit exaggerated
because it doesn't need to be of any specific size.

The same comment applies to the other accessors below.

> +{
> +	if (chan->bypass)
> +		return;

I don't see this being set anywhere. Is it dead code? Also the only
description I see is that it's used to bypass register writes, but I
don't see an explanation why that's necessary.

> +/* CIL PHY registers */
> +static void phy_write(struct tegra_channel *chan, u32 val)
> +{
> +	tegra_channel_write(chan, chan->regs.phy, val);
> +}
> +
> +static u32 phy_read(struct tegra_channel *chan)
> +{
> +	return tegra_channel_read(chan, chan->regs.phy);
> +}

Are these missing an offset parameter? Or do these subblocks only have a
single register? Even if that's the case, I think it'd be more
consistent to have the same signature as the other accessors.

> +/* Syncpoint bits of TEGRA_VI_CFG_VI_INCR_SYNCPT */
> +static u32 sp_bit(struct tegra_channel *chan, u32 sp)
> +{
> +	return (sp + chan->port * 4) << 8;
> +}

Technically this returns a mask, not a bit, so sp_mask() would be more
appropriate.

> +/* Calculate register base */
> +static u32 regs_base(u32 regs_base, int port)
> +{
> +	return regs_base + (port / 2 * 0x800) + (port & 1) * 0x34;
> +}
> +
> +/* CSI channel IO Rail IDs */
> +int tegra_io_rail_csi_ids[] =3D {

This can be static const as far as I can tell.

> +	TEGRA_IO_RAIL_CSIA,
> +	TEGRA_IO_RAIL_CSIB,
> +	TEGRA_IO_RAIL_CSIC,
> +	TEGRA_IO_RAIL_CSID,
> +	TEGRA_IO_RAIL_CSIE,
> +	TEGRA_IO_RAIL_CSIF,
> +};
> +
> +void tegra_channel_fmts_bitmap_init(struct tegra_channel *chan)
> +{
> +	int ret, index;
> +	struct v4l2_subdev *subdev =3D chan->remote_entity->subdev;
> +	struct v4l2_subdev_mbus_code_enum code =3D {
> +		.which =3D V4L2_SUBDEV_FORMAT_ACTIVE,
> +	};
> +
> +

Spurious blank line.

> +static int tegra_channel_capture_setup(struct tegra_channel *chan)
> +{
> +	int lanes =3D 2;

unsigned int? And why is it hardcoded to 2? There are checks below for
lanes =3D=3D 4, which will effectively never happen. So at the very least I
think this should have a TODO comment of some sort. Preferably can it
not be determined at runtime what number of lanes we need?

> +	int port =3D chan->port;

unsigned int?

> +	u32 height =3D chan->format.height;
> +	u32 width =3D chan->format.width;
> +	u32 format =3D chan->fmtinfo->img_fmt;
> +	u32 data_type =3D chan->fmtinfo->img_dt;
> +	u32 word_count =3D tegra_core_get_word_count(width, chan->fmtinfo);
> +	struct chan_regs_config *regs =3D &chan->regs;
> +
> +	/* CIL PHY register setup */
> +	if (port & 0x1) {
> +		cil_write(chan, TEGRA_CSI_CIL_PAD_CONFIG0 - 0x34, 0x0);
> +		cil_write(chan, TEGRA_CSI_CIL_PAD_CONFIG0, 0x0);
> +	} else {
> +		cil_write(chan, TEGRA_CSI_CIL_PAD_CONFIG0, 0x10000);
> +		cil_write(chan, TEGRA_CSI_CIL_PAD_CONFIG0 + 0x34, 0x0);
> +	}

This seems to address registers not actually part of this channel. Why?

Also you use magic numbers here and in the remainder of the driver. We
should be able to do better. I presume all of this is documented in the
TRM, so we should be able to easily substitute symbolic names.

> +	cil_write(chan, TEGRA_CSI_CIL_INTERRUPT_MASK, 0x0);
> +	cil_write(chan, TEGRA_CSI_CIL_PHY_CONTROL, 0xA);
> +	if (lanes =3D=3D 4) {
> +		regs->cil =3D regs_base(TEGRA_CSI_CIL_0_BASE, port + 1);
> +		cil_write(chan, TEGRA_CSI_CIL_PAD_CONFIG0, 0x0);
> +		cil_write(chan,	TEGRA_CSI_CIL_INTERRUPT_MASK, 0x0);
> +		cil_write(chan, TEGRA_CSI_CIL_PHY_CONTROL, 0xA);
> +		regs->cil =3D regs_base(TEGRA_CSI_CIL_0_BASE, port);
> +	}

And this seems to access registers from another port by temporarily
rewriting the CIL base offset. That seems a little hackish to me. I
don't know the hardware intimately enough to know exactly what this
is supposed to accomplish, perhaps you can clarify? Also perhaps we
can come up with some architectural overview of the VI hardware, or
does such an overview exist in the TRM?

I see there is, perhaps add a comment somewhere, in the commit
description or the file header giving a reference to where the
architectural overview can be found?

> +	/* CSI pixel parser registers setup */
> +	pp_write(chan, TEGRA_CSI_PIXEL_STREAM_PP_COMMAND, 0xf007);
> +	pp_write(chan, TEGRA_CSI_PIXEL_PARSER_INTERRUPT_MASK, 0x0);
> +	pp_write(chan, TEGRA_CSI_PIXEL_STREAM_CONTROL0,
> +		 0x280301f0 | (port & 0x1));
> +	pp_write(chan, TEGRA_CSI_PIXEL_STREAM_PP_COMMAND, 0xf007);
> +	pp_write(chan, TEGRA_CSI_PIXEL_STREAM_CONTROL1, 0x11);
> +	pp_write(chan, TEGRA_CSI_PIXEL_STREAM_GAP, 0x140000);
> +	pp_write(chan, TEGRA_CSI_PIXEL_STREAM_EXPECTED_FRAME, 0x0);
> +	pp_write(chan, TEGRA_CSI_INPUT_STREAM_CONTROL,
> +		 0x3f0000 | (lanes - 1));
> +
> +	/* CIL PHY register setup */
> +	if (lanes =3D=3D 4)
> +		phy_write(chan, 0x0101);
> +	else {
> +		u32 val =3D phy_read(chan);
> +		if (port & 0x1)
> +			val =3D (val & ~0x100) | 0x100;
> +		else
> +			val =3D (val & ~0x1) | 0x1;
> +		phy_write(chan, val);
> +	}

The & ~ isn't quite doing what I suspect it should be doing. My
assumption is that you want to set this register to 0x01 if the first
port is to be used and 0x100 if the second port is to be used (or 0x101
if both ports are to be used). In that case I think you'll want
something like this:

	value =3D phy_read(chan);

	if (port & 1)
		value =3D (value & ~0x0001) | 0x0100;
	else
		value =3D (value & ~0x0100) | 0x0001;

	phy_write(chan, value);

> +static void tegra_channel_capture_error(struct tegra_channel *chan, int =
err)
> +{
> +	u32 val;
> +
> +#ifdef DEBUG
> +	val =3D tegra_channel_read(chan, TEGRA_CSI_DEBUG_COUNTER_0);
> +	dev_err(&chan->video.dev, "TEGRA_CSI_DEBUG_COUNTER_0 0x%08x\n", val);
> +#endif
> +	val =3D cil_read(chan, TEGRA_CSI_CIL_STATUS);
> +	dev_err(&chan->video.dev, "TEGRA_CSI_CSI_CIL_STATUS 0x%08x\n", val);
> +	val =3D cil_read(chan, TEGRA_CSI_CILX_STATUS);
> +	dev_err(&chan->video.dev, "TEGRA_CSI_CSI_CILX_STATUS 0x%08x\n", val);
> +	val =3D pp_read(chan, TEGRA_CSI_PIXEL_PARSER_STATUS);
> +	dev_err(&chan->video.dev, "TEGRA_CSI_PIXEL_PARSER_STATUS 0x%08x\n",
> +		val);
> +	val =3D csi_read(chan, TEGRA_VI_CSI_ERROR_STATUS);
> +	dev_err(&chan->video.dev, "TEGRA_VI_CSI_ERROR_STATUS 0x%08x\n", val);
> +}

The err parameter is never used, so it should be dropped.

> +static int tegra_channel_capture_frame(struct tegra_channel *chan)
> +{
> +	struct tegra_channel_buffer *buf =3D chan->active;
> +	struct vb2_buffer *vb =3D &buf->buf;
> +	int err =3D 0;
> +	u32 thresh, value, frame_start;
> +	int bytes_per_line =3D chan->format.bytesperline;
> +
> +	if (!vb2_start_streaming_called(&chan->queue) || !buf)
> +		return -EINVAL;
> +
> +	if (chan->bypass)
> +		goto bypass_done;
> +
> +	/* Program buffer address */
> +	csi_write(chan,
> +		  TEGRA_VI_CSI_SURFACE0_OFFSET_MSB + chan->surface * 8,
> +		  0x0);
> +	csi_write(chan,
> +		  TEGRA_VI_CSI_SURFACE0_OFFSET_LSB + chan->surface * 8,
> +		  buf->addr);
> +	csi_write(chan,
> +		  TEGRA_VI_CSI_SURFACE0_STRIDE + chan->surface * 4,
> +		  bytes_per_line);
> +
> +	/* Program syncpoint */
> +	frame_start =3D sp_bit(chan, SP_PP_FRAME_START);
> +	tegra_channel_write(chan, TEGRA_VI_CFG_VI_INCR_SYNCPT,
> +			    frame_start | host1x_syncpt_id(chan->sp));
> +
> +	csi_write(chan, TEGRA_VI_CSI_SINGLE_SHOT, 0x1);
> +
> +	/* Use syncpoint to wake up */
> +	thresh =3D host1x_syncpt_incr_max(chan->sp, 1);
> +
> +	mutex_unlock(&chan->lock);
> +	err =3D host1x_syncpt_wait(chan->sp, thresh,
> +			         TEGRA_VI_SYNCPT_WAIT_TIMEOUT, &value);
> +	mutex_lock(&chan->lock);

What's the point of taking the lock in the first place if you drop it
here, even if temporarily? This is a per-channel lock, and it protects
the channel against concurrent captures. So if you drop the lock here,
don't you run risk of having two captures run concurrently? And by the
time you get to the error handling or buffer completion below you can't
be sure you're actually dealing with the same buffer that you started
with.

> +
> +	if (err) {
> +		dev_err(&chan->video.dev, "frame start syncpt timeout!\n");
> +		tegra_channel_capture_error(chan, err);
> +	}

Is timeout really the only kind of error that can happen here?

> +
> +bypass_done:
> +	/* Captured one frame */
> +	spin_lock_irq(&chan->queued_lock);
> +	vb->v4l2_buf.sequence =3D chan->sequence++;
> +	vb->v4l2_buf.field =3D V4L2_FIELD_NONE;
> +	v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
> +	vb2_set_plane_payload(vb, 0, chan->format.sizeimage);
> +	vb2_buffer_done(vb, err < 0 ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
> +	spin_unlock_irq(&chan->queued_lock);

Do we really need to set all the buffer fields on error? Isn't it enough
to simply mark the state as "error"?

> +
> +	return err;
> +}
> +
> +static void tegra_channel_work(struct work_struct *work)
> +{
> +	struct tegra_channel *chan =3D
> +		container_of(work, struct tegra_channel, work);
> +
> +	while (1) {
> +		spin_lock_irq(&chan->queued_lock);
> +		if (list_empty(&chan->capture)) {
> +			chan->active =3D NULL;
> +			spin_unlock_irq(&chan->queued_lock);
> +			return;
> +		}
> +		chan->active =3D list_entry(chan->capture.next,
> +				struct tegra_channel_buffer, queue);
> +		list_del_init(&chan->active->queue);
> +		spin_unlock_irq(&chan->queued_lock);
> +
> +		mutex_lock(&chan->lock);
> +		tegra_channel_capture_frame(chan);
> +		mutex_unlock(&chan->lock);
> +	}
> +}

Should this have some mechanism to break out of the loop, for example if
somebody requested capturing to stop?

> +static int tegra_channel_buffer_prepare(struct vb2_buffer *vb)
> +{
> +	struct tegra_channel *chan =3D vb2_get_drv_priv(vb->vb2_queue);
> +	struct tegra_channel_buffer *buf =3D to_tegra_channel_buffer(vb);
> +
> +	buf->chan =3D chan;
> +	buf->addr =3D vb2_dma_contig_plane_dma_addr(vb, 0);
> +
> +	return 0;
> +}

This seems to use contiguous DMA, which I guess presumes CMA support?
We're dealing with very large buffers here. Your default frame size
would yield buffers of roughly 32 MiB each, and you probably need a
couple of those to ensure smooth playback. That's quite a bit of
memory to reserve for CMA.

Have you ever tried to make this work with the IOMMU API so that we can
allocate arbitrary buffers and linearize them for the hardware through
the SMMU?

> +static void tegra_channel_buffer_queue(struct vb2_buffer *vb)
> +{
> +	struct tegra_channel *chan =3D vb2_get_drv_priv(vb->vb2_queue);
> +	struct tegra_channel_buffer *buf =3D to_tegra_channel_buffer(vb);
> +
> +	/* Put buffer into the  capture queue */
> +	spin_lock_irq(&chan->queued_lock);
> +	list_add_tail(&buf->queue, &chan->capture);
> +	spin_unlock_irq(&chan->queued_lock);
> +
> +	/* Start work queue to capture data to buffer */
> +	if (vb2_start_streaming_called(&chan->queue))
> +		schedule_work(&chan->work);
> +}

I'm beginning to wonder if a workqueue is the best implementation here.
Couldn't we get notification on syncpoint increments and have a handler
setup capture of new frames?

> +static int tegra_channel_start_streaming(struct vb2_queue *vq, u32 count)
> +{
> +	struct tegra_channel *chan =3D vb2_get_drv_priv(vq);
> +	struct media_pipeline *pipe =3D chan->video.entity.pipe;
> +	struct tegra_channel_buffer *buf, *nbuf;
> +	int ret =3D 0;
> +
> +	if (!chan->vi->pg_mode && !chan->remote_entity) {
> +		dev_err(&chan->video.dev,
> +			"is not in TPG mode and has not sensor connected!\n");
> +		ret =3D -EINVAL;
> +		goto vb2_queued;
> +	}
> +
> +	mutex_lock(&chan->lock);
> +
> +	/* Start CIL clock */
> +	clk_set_rate(chan->cil_clk, 102000000);
> +	clk_prepare_enable(chan->cil_clk);

You need to check these for errors.

> +static struct vb2_ops tegra_channel_queue_qops =3D {
> +	.queue_setup =3D tegra_channel_queue_setup,
> +	.buf_prepare =3D tegra_channel_buffer_prepare,
> +	.buf_queue =3D tegra_channel_buffer_queue,
> +	.wait_prepare =3D vb2_ops_wait_prepare,
> +	.wait_finish =3D vb2_ops_wait_finish,
> +	.start_streaming =3D tegra_channel_start_streaming,
> +	.stop_streaming =3D tegra_channel_stop_streaming,
> +};

I think this needs to be static const.

> +static int
> +tegra_channel_querycap(struct file *file, void *fh, struct v4l2_capabili=
ty *cap)
> +{
> +	struct v4l2_fh *vfh =3D file->private_data;
> +	struct tegra_channel *chan =3D to_tegra_channel(vfh->vdev);
> +
> +	cap->device_caps =3D V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> +	cap->capabilities =3D cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> +
> +	strlcpy(cap->driver, "tegra-vi", sizeof(cap->driver));

Perhaps "tegra-video" to be consistent with the module name?

> +	strlcpy(cap->card, chan->video.name, sizeof(cap->card));
> +	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s:%u",
> +		 chan->vi->dev->of_node->name, chan->port);

Should this not rather use dev_name(chan->vi->dev) to ensure it works
fine if ever we have multiple instances of the VI controller?

> +static int
> +tegra_channel_enum_format(struct file *file, void *fh, struct v4l2_fmtde=
sc *f)
> +{
> +	struct v4l2_fh *vfh =3D file->private_data;
> +	struct tegra_channel *chan =3D to_tegra_channel(vfh->vdev);
> +	int index, i;

These can probably be unsigned int.

> +	unsigned long *fmts_bitmap =3D NULL;
> +
> +	if (chan->vi->pg_mode)
> +		fmts_bitmap =3D chan->vi->tpg_fmts_bitmap;
> +	else if (chan->remote_entity)
> +		fmts_bitmap =3D chan->fmts_bitmap;
> +
> +	if (!fmts_bitmap ||
> +	    f->index > bitmap_weight(fmts_bitmap, MAX_FORMAT_NUM) - 1)
> +		return -EINVAL;
> +
> +	index =3D -1;

This won't work with unsigned int, of course (actually, it would, but
it'd be ugly), but I think you could work around that by doing the more
natural:

> +	for (i =3D 0; i < f->index + 1; i++)
> +		index =3D find_next_bit(fmts_bitmap, MAX_FORMAT_NUM, index + 1);

	index =3D 0;

	for (i =3D 0; i < f->index + 1; i++, index++)
		index =3D find_next_bit(fmts_bitmap, MAX_FORMAT_NUM, index);

> +static void
> +__tegra_channel_try_format(struct tegra_channel *chan, struct v4l2_pix_f=
ormat *pix,
> +		      const struct tegra_video_format **fmtinfo)
> +{
> +	const struct tegra_video_format *info;
> +	unsigned int min_width;
> +	unsigned int max_width;
> +	unsigned int min_bpl;
> +	unsigned int max_bpl;
> +	unsigned int width;
> +	unsigned int align;
> +	unsigned int bpl;
> +
> +	/* Retrieve format information and select the default format if the
> +	 * requested format isn't supported.
> +	 */
> +	info =3D tegra_core_get_format_by_fourcc(pix->pixelformat);
> +	if (!info)
> +		info =3D tegra_core_get_format_by_fourcc(TEGRA_VF_DEF_FOURCC);

Should this not be an error? As far as I can tell this is silently
substituting the default format for the requested one if the requested
one isn't supported. Isn't the whole point of this to find out if some
format is supported?

> +
> +	pix->pixelformat =3D info->fourcc;
> +	pix->field =3D V4L2_FIELD_NONE;
> +
> +	/* The transfer alignment requirements are expressed in bytes. Compute
> +	 * the minimum and maximum values, clamp the requested width and convert
> +	 * it back to pixels.
> +	 */
> +	align =3D lcm(chan->align, info->bpp);
> +	min_width =3D roundup(TEGRA_MIN_WIDTH, align);
> +	max_width =3D rounddown(TEGRA_MAX_WIDTH, align);
> +	width =3D rounddown(pix->width * info->bpp, align);

Shouldn't these be roundup()?

> +
> +	pix->width =3D clamp(width, min_width, max_width) / info->bpp;
> +	pix->height =3D clamp(pix->height, TEGRA_MIN_HEIGHT,
> +			    TEGRA_MAX_HEIGHT);

The above fits nicely on one line and doesn't need to be wrapped.

> +
> +	/* Clamp the requested bytes per line value. If the maximum bytes per
> +	 * line value is zero, the module doesn't support user configurable line
> +	 * sizes. Override the requested value with the minimum in that case.
> +	 */
> +	min_bpl =3D pix->width * info->bpp;
> +	max_bpl =3D rounddown(TEGRA_MAX_WIDTH, chan->align);
> +	bpl =3D rounddown(pix->bytesperline, chan->align);

Again, I think these should be roundup().

> +static int tegra_channel_v4l2_open(struct file *file)
> +{
> +	struct tegra_channel *chan =3D video_drvdata(file);
> +	struct tegra_vi_device *vi =3D chan->vi;
> +	int ret =3D 0;
> +
> +	mutex_lock(&vi->lock);
> +	ret =3D v4l2_fh_open(file);
> +	if (ret)
> +		goto unlock;
> +
> +	/* The first open then turn on power*/
> +	if (!vi->power_on_refcnt) {
> +		tegra_vi_power_on(chan->vi);

Perhaps propagate error codes here?

> +
> +		usleep_range(5, 100);
> +		tegra_channel_write(chan, TEGRA_VI_CFG_CG_CTRL, 1);
> +		tegra_channel_write(chan, TEGRA_CSI_CLKEN_OVERRIDE, 0);
> +		usleep_range(10, 15);
> +	}
> +	vi->power_on_refcnt++;

Also, I wonder if powering up at ->open() time isn't a little early. I
could very well imagine an application opening up a device and then not
use it for a long time. Or keep it open even while nothing is being
captures. But that's primarily an optimization matter, so this is fine
with me.

> +int tegra_channel_init(struct tegra_vi_device *vi,
> +		       struct tegra_channel *chan,
> +		       u32 port)

The above fits on 2 lines, no need to make it three. Also port should
probably be unsigned int because the size isn't important.

> +{
> +	int ret;
> +
> +	chan->vi =3D vi;
> +	chan->port =3D port;
> +	chan->iomem =3D vi->iomem;
> +
> +	/* Init channel register base */
> +	chan->regs.csi =3D TEGRA_VI_CSI_0_BASE + port * 0x100;
> +	chan->regs.pp =3D regs_base(TEGRA_CSI_PIXEL_PARSER_0_BASE, port);
> +	chan->regs.cil =3D regs_base(TEGRA_CSI_CIL_0_BASE, port);
> +	chan->regs.phy =3D TEGRA_CSI_CIL_PHY_0_BASE + port / 2 * 0x800;
> +	chan->regs.tpg =3D regs_base(TEGRA_CSI_PATTERN_GENERATOR_0_BASE, port);

Like I said, I think it'd be clearer to have the defines parameterized.
That would also make this more consistent, rather than have one set of
values that are computed here and for others the regs_base() helper is
invoked. Also, I think it'd be better to have the regs structures take
void __iomem * directly, so that the offset addition doesn't have to be
performed at every register access.

> +
> +	/* Init CIL clock */
> +	switch (chan->port) {
> +	case 0:
> +	case 1:
> +		chan->cil_clk =3D devm_clk_get(chan->vi->dev, "cilab");
> +		break;
> +	case 2:
> +	case 3:
> +		chan->cil_clk =3D devm_clk_get(chan->vi->dev, "cilcd");
> +		break;
> +	case 4:
> +	case 5:
> +		chan->cil_clk =3D devm_clk_get(chan->vi->dev, "cile");
> +		break;
> +	default:
> +		dev_err(chan->vi->dev, "wrong port nubmer %d\n", port);

Nit: you should use %u for unsigned integers.

> +	}
> +	if (IS_ERR(chan->cil_clk)) {
> +		dev_err(chan->vi->dev, "Failed to get CIL clock\n");

Perhaps mention which clock couldn't be received.

> +		return -EINVAL;

And propagate the error code rather than returning a hardcoded one.

> +	}
> +
> +	/* VI Channel is 64 bytes alignment */
> +	chan->align =3D 64;

Does this need parameterization for other SoC generations?

> +	chan->surface =3D 0;

I can't find this being set to anything other than 0. What is its use?

> +	chan->io_id =3D tegra_io_rail_csi_ids[chan->port];
> +	mutex_init(&chan->lock);
> +	mutex_init(&chan->video_lock);
> +	INIT_LIST_HEAD(&chan->capture);
> +	spin_lock_init(&chan->queued_lock);
> +	INIT_WORK(&chan->work, tegra_channel_work);
> +
> +	/* Init video format */
> +	chan->fmtinfo =3D tegra_core_get_format_by_fourcc(TEGRA_VF_DEF_FOURCC);
> +	chan->format.pixelformat =3D chan->fmtinfo->fourcc;
> +	chan->format.colorspace =3D V4L2_COLORSPACE_SRGB;
> +	chan->format.field =3D V4L2_FIELD_NONE;
> +	chan->format.width =3D TEGRA_DEF_WIDTH;
> +	chan->format.height =3D TEGRA_DEF_HEIGHT;
> +	chan->format.bytesperline =3D chan->format.width * chan->fmtinfo->bpp;
> +	chan->format.sizeimage =3D chan->format.bytesperline *
> +				    chan->format.height;
> +
> +	/* Initialize the media entity... */
> +	chan->pad.flags =3D MEDIA_PAD_FL_SINK;
> +
> +	ret =3D media_entity_init(&chan->video.entity, 1, &chan->pad, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* ... and the video node... */
> +	chan->video.fops =3D &tegra_channel_fops;
> +	chan->video.v4l2_dev =3D &vi->v4l2_dev;
> +	chan->video.queue =3D &chan->queue;
> +	snprintf(chan->video.name, sizeof(chan->video.name), "%s %s %u",
> +		 vi->dev->of_node->name, "output", port);

dev_name()?

> diff --git a/drivers/media/platform/tegra/tegra-core.c b/drivers/media/pl=
atform/tegra/tegra-core.c
[...]
> +const struct tegra_video_format tegra_video_formats[] =3D {

Does this need to be exposed? I see there are accessors for this below,
so exposing the structure itself doesn't seem necessary.

> +int tegra_core_get_formats_array_size(void)
> +{
> +	return ARRAY_SIZE(tegra_video_formats);
> +}
> +
> +/**
> + * tegra_core_get_word_count - Calculate word count
> + * @frame_width: number of pixels in one frame
> + * @fmt: Tegra Video format struct which has BPP information
> + *
> + * Return: word count number
> + */
> +u32 tegra_core_get_word_count(u32 frame_width,
> +			      const struct tegra_video_format *fmt)
> +{
> +	return frame_width * fmt->width / 8;
> +}

This is confusing. If frame_width is the number of pixels in one frame,
then it should probably me called frame_size or so. frame_width to me
implies number of pixels per line, not per frame.

> +/**
> + * tegra_core_get_idx_by_code - Retrieve index for a media bus code
> + * @code: the format media bus code
> + *
> + * Return: a index to the format information structure corresponding to =
the
> + * given V4L2 media bus format @code, or -1 if no corresponding format c=
an
> + * be found.
> + */
> +int tegra_core_get_idx_by_code(unsigned int code)
> +{
> +	unsigned int i;
> +	const struct tegra_video_format *format;
> +
> +	for (i =3D 0; i < ARRAY_SIZE(tegra_video_formats); ++i) {
> +		format =3D &tegra_video_formats[i];
> +
> +		if (format->code =3D=3D code)

You only use the format value once, so the temporary variable doesn't
buy you anything.

> +			return i;
> +	}
> +
> +	return -1;
> +}
> +
> +

Gratuitous blank line.

> +/**
> + * tegra_core_of_get_format - Parse a device tree node and return format
> + * 			      information

Why is this necessary? Why would you ever need to encode a pixel format
in DT?

> +/**
> + * tegra_core_bytes_per_line - Calculate bytes per line in one frame
> + * @width: frame width
> + * @fmt: Tegra Video format
> + *
> + * Simply calcualte the bytes_per_line and if it's not 64 bytes aligned =
it
> + * will be padded to 64 boundary.
> + */
> +u32 tegra_core_bytes_per_line(u32 width,
> +			      const struct tegra_video_format *fmt)
> +{
> +	u32 bytes_per_line =3D width * fmt->bpp;
> +
> +	if (bytes_per_line % 64)
> +		bytes_per_line =3D bytes_per_line +
> +				 (64 - (bytes_per_line % 64));
> +
> +	return bytes_per_line;
> +}

Perhaps this should use the channel->align field for alignment rather
than hardcode 64? Since there's no channel being passed into this, maybe
passing the alignment as a parameter would work?

Also can't the above be replaced by:

	return roundup(width * fmt->bpp, align);

?

> diff --git a/drivers/media/platform/tegra/tegra-core.h b/drivers/media/pl=
atform/tegra/tegra-core.h
> new file mode 100644
> index 0000000..7d1026b
> --- /dev/null
> +++ b/drivers/media/platform/tegra/tegra-core.h
> @@ -0,0 +1,134 @@
> +/*
> + * NVIDIA Tegra Video Input Device Driver Core Helpers
> + *
> + * Copyright (c) 2015, NVIDIA CORPORATION.  All rights reserved.
> + *
> + * Author: Bryan Wu <pengw@nvidia.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef __TEGRA_CORE_H__
> +#define __TEGRA_CORE_H__
> +
> +#include <dt-bindings/media/tegra-vi.h>
> +
> +#include <media/v4l2-subdev.h>
> +
> +/* Minimum and maximum width and height common to Tegra video input devi=
ce. */
> +#define TEGRA_MIN_WIDTH		32U
> +#define TEGRA_MAX_WIDTH		7680U
> +#define TEGRA_MIN_HEIGHT	32U
> +#define TEGRA_MAX_HEIGHT	7680U

Is this dependent on SoC generation? If we wanted to support Tegra K1,
would the same values apply or do they need to be parameterized?

On that note, could you outline what would be necessary to make this
work on Tegra K1? What are the differences between the VI hardware on
Tegra X1 vs. Tegra K1?

> +
> +/* UHD 4K resolution as default resolution for all Tegra video input dev=
ice. */
> +#define TEGRA_DEF_WIDTH		3840
> +#define TEGRA_DEF_HEIGHT	2160

Is this a sensible default? It seems rather large to me.

> +
> +#define TEGRA_VF_DEF		TEGRA_VF_RGB888
> +#define TEGRA_VF_DEF_FOURCC	V4L2_PIX_FMT_RGB32

Should we not have only one of these and convert to the other via some
table?

> +/* These go into the TEGRA_VI_CSI_n_IMAGE_DEF registers bits 23:16 */
> +#define TEGRA_IMAGE_FORMAT_T_L8                         16
> +#define TEGRA_IMAGE_FORMAT_T_R16_I                      32
> +#define TEGRA_IMAGE_FORMAT_T_B5G6R5                     33
> +#define TEGRA_IMAGE_FORMAT_T_R5G6B5                     34
> +#define TEGRA_IMAGE_FORMAT_T_A1B5G5R5                   35
> +#define TEGRA_IMAGE_FORMAT_T_A1R5G5B5                   36
> +#define TEGRA_IMAGE_FORMAT_T_B5G5R5A1                   37
> +#define TEGRA_IMAGE_FORMAT_T_R5G5B5A1                   38
> +#define TEGRA_IMAGE_FORMAT_T_A4B4G4R4                   39
> +#define TEGRA_IMAGE_FORMAT_T_A4R4G4B4                   40
> +#define TEGRA_IMAGE_FORMAT_T_B4G4R4A4                   41
> +#define TEGRA_IMAGE_FORMAT_T_R4G4B4A4                   42
> +#define TEGRA_IMAGE_FORMAT_T_A8B8G8R8                   64
> +#define TEGRA_IMAGE_FORMAT_T_A8R8G8B8                   65
> +#define TEGRA_IMAGE_FORMAT_T_B8G8R8A8                   66
> +#define TEGRA_IMAGE_FORMAT_T_R8G8B8A8                   67
> +#define TEGRA_IMAGE_FORMAT_T_A2B10G10R10                68
> +#define TEGRA_IMAGE_FORMAT_T_A2R10G10B10                69
> +#define TEGRA_IMAGE_FORMAT_T_B10G10R10A2                70
> +#define TEGRA_IMAGE_FORMAT_T_R10G10B10A2                71
> +#define TEGRA_IMAGE_FORMAT_T_A8Y8U8V8                   193
> +#define TEGRA_IMAGE_FORMAT_T_V8U8Y8A8                   194
> +#define TEGRA_IMAGE_FORMAT_T_A2Y10U10V10                197
> +#define TEGRA_IMAGE_FORMAT_T_V10U10Y10A2                198
> +#define TEGRA_IMAGE_FORMAT_T_Y8_U8__Y8_V8               200
> +#define TEGRA_IMAGE_FORMAT_T_Y8_V8__Y8_U8               201
> +#define TEGRA_IMAGE_FORMAT_T_U8_Y8__V8_Y8               202
> +#define TEGRA_IMAGE_FORMAT_T_T_V8_Y8__U8_Y8             203
> +#define TEGRA_IMAGE_FORMAT_T_T_Y8__U8__V8_N444          224
> +#define TEGRA_IMAGE_FORMAT_T_Y8__U8V8_N444              225
> +#define TEGRA_IMAGE_FORMAT_T_Y8__V8U8_N444              226
> +#define TEGRA_IMAGE_FORMAT_T_Y8__U8__V8_N422            227
> +#define TEGRA_IMAGE_FORMAT_T_Y8__U8V8_N422              228
> +#define TEGRA_IMAGE_FORMAT_T_Y8__V8U8_N422              229
> +#define TEGRA_IMAGE_FORMAT_T_Y8__U8__V8_N420            230
> +#define TEGRA_IMAGE_FORMAT_T_Y8__U8V8_N420              231
> +#define TEGRA_IMAGE_FORMAT_T_Y8__V8U8_N420              232
> +#define TEGRA_IMAGE_FORMAT_T_X2Lc10Lb10La10             233
> +#define TEGRA_IMAGE_FORMAT_T_A2R6R6R6R6R6               234
> +
> +/* These go into the TEGRA_VI_CSI_n_CSI_IMAGE_DT registers bits 7:0 */
> +#define TEGRA_IMAGE_DT_YUV420_8                         24
> +#define TEGRA_IMAGE_DT_YUV420_10                        25
> +#define TEGRA_IMAGE_DT_YUV420CSPS_8                     28
> +#define TEGRA_IMAGE_DT_YUV420CSPS_10                    29
> +#define TEGRA_IMAGE_DT_YUV422_8                         30
> +#define TEGRA_IMAGE_DT_YUV422_10                        31
> +#define TEGRA_IMAGE_DT_RGB444                           32
> +#define TEGRA_IMAGE_DT_RGB555                           33
> +#define TEGRA_IMAGE_DT_RGB565                           34
> +#define TEGRA_IMAGE_DT_RGB666                           35
> +#define TEGRA_IMAGE_DT_RGB888                           36
> +#define TEGRA_IMAGE_DT_RAW6                             40
> +#define TEGRA_IMAGE_DT_RAW7                             41
> +#define TEGRA_IMAGE_DT_RAW8                             42
> +#define TEGRA_IMAGE_DT_RAW10                            43
> +#define TEGRA_IMAGE_DT_RAW12                            44
> +#define TEGRA_IMAGE_DT_RAW14                            45

It might be helpful to describe what these registers actually do. There
seems to be overlap between both lists, but I don't quite see how they
relate to one another, or what their purpose is.

> +/**
> + * struct tegra_video_format - Tegra video format description
> + * @vf_code: video format code
> + * @width: format width in bits per component
> + * @code: media bus format code
> + * @bpp: bytes per pixel (when stored in memory)
> + * @img_fmt: image format
> + * @img_dt: image data type
> + * @fourcc: V4L2 pixel format FCC identifier
> + * @description: format description, suitable for userspace
> + */
> +struct tegra_video_format {
> +	u32 vf_code;
> +	u32 width;
> +	u32 code;
> +	u32 bpp;

I think the above four can all be unsigned int. A sized type is not
necessary here.

> +	u32 img_fmt;
> +	u32 img_dt;

Perhaps these could be enums?

> +	u32 fourcc;
> +};
> +
> +extern const struct tegra_video_format tegra_video_formats[];

It looks like you have accessors for this. Do you even need to expose
it?

> diff --git a/drivers/media/platform/tegra/tegra-vi.c b/drivers/media/plat=
form/tegra/tegra-vi.c
[...]
> +static void tegra_vi_v4l2_cleanup(struct tegra_vi_device *vi)
> +{
> +	v4l2_ctrl_handler_free(&vi->ctrl_handler);
> +	v4l2_device_unregister(&vi->v4l2_dev);
> +	media_device_unregister(&vi->media_dev);
> +}
> +
> +static int tegra_vi_v4l2_init(struct tegra_vi_device *vi)
> +{
> +	int ret;
> +
> +	vi->media_dev.dev =3D vi->dev;
> +	strlcpy(vi->media_dev.model, "NVIDIA Tegra Video Input Device",
> +		sizeof(vi->media_dev.model));
> +	vi->media_dev.hw_revision =3D 0;

Actually, I think for Tegra X1 the hardware revision would be 3, since
VI3 is what it's usually referred to. Tegra K1 has VI2, so this should
be parameterized (at least when Tegra K1 support is added).

> +int tegra_vi_power_on(struct tegra_vi_device *vi)
> +{
> +	int ret;
> +
> +	ret =3D regulator_enable(vi->vi_reg);
> +	if (ret)
> +		return ret;
> +
> +	ret =3D tegra_powergate_sequence_power_up(TEGRA_POWERGATE_VENC,
> +						vi->vi_clk, vi->vi_rst);
> +	if (ret) {
> +		regulator_disable(vi->vi_reg);
> +		return ret;
> +	}
> +
> +	clk_prepare_enable(vi->csi_clk);
> +
> +	clk_set_rate(vi->parent_clk, 408000000);

Do we really need to set the parent? Isn't that going to be set
automatically since vi_clk is the child of parent_clk?

> +	clk_set_rate(vi->vi_clk, 408000000);
> +	clk_set_rate(vi->csi_clk, 408000000);

Also all of these clock functions can fail, so you should check for
errors.

> +
> +	return 0;
> +}
> +
> +void tegra_vi_power_off(struct tegra_vi_device *vi)
> +{
> +	clk_disable_unprepare(vi->csi_clk);
> +	tegra_powergate_power_off(TEGRA_POWERGATE_VENC);

tegra_powergate_power_off() doesn't do anything with the clock or the
reset, so you'll want to manually assert reset here and then disable and
unprepare the clock. And I think both need to happen before the power
partition is turned off.

> +	regulator_disable(vi->vi_reg);
> +}
> +
> +static int tegra_vi_channels_init(struct tegra_vi_device *vi)
> +{
> +	int i, ret;

i can be unsigned.

> +	struct tegra_channel *chan;
> +
> +	for (i =3D 0; i < ARRAY_SIZE(vi->chans); i++) {
> +		chan =3D &vi->chans[i];
> +
> +		ret =3D tegra_channel_init(vi, chan, i);

Again, chan is only used once, so directly passing &vi->chans[i] to
tegra_channel_init() would be more concise.

> +static int tegra_vi_channels_cleanup(struct tegra_vi_device *vi)
> +{
> +	int i, ret;
> +	struct tegra_channel *chan;
> +
> +	for (i =3D 0; i < ARRAY_SIZE(vi->chans); i++) {
> +		chan =3D &vi->chans[i];
> +
> +		ret =3D tegra_channel_cleanup(chan);
> +		if (ret < 0) {
> +			dev_err(vi->dev, "channel %d cleanup failed\n", i);
> +			return ret;
> +		}
> +	}
> +	return 0;
> +}

Same comments as for tegra_vi_channels_init().

> +
> +/* ---------------------------------------------------------------------=
--------
> + * Graph Management
> + */

The way devices are hooked up using the graph needs to be documented in
a device tree binding.

> +static int tegra_vi_graph_notify_complete(struct v4l2_async_notifier *no=
tifier)
> +{
> +	struct tegra_vi_device *vi =3D
> +		container_of(notifier, struct tegra_vi_device, notifier);
> +	int ret;
> +
> +	dev_dbg(vi->dev, "notify complete, all subdevs registered\n");
> +
> +	/* Create links for every entity. */
> +	ret =3D tegra_vi_graph_build_links(vi);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret =3D v4l2_device_register_subdev_nodes(&vi->v4l2_dev);
> +	if (ret < 0)
> +		dev_err(vi->dev, "failed to register subdev nodes\n");
> +
> +	return ret;
> +}

Why the need for this notifier mechanism, doesn't deferred probe work
here?

> +static int tegra_vi_graph_notify_bound(struct v4l2_async_notifier *notif=
ier,
> +				   struct v4l2_subdev *subdev,
> +				   struct v4l2_async_subdev *asd)
> +{
[...]
> +}
> +
> +

Gratuitous blank line.

> +static int tegra_vi_graph_init(struct tegra_vi_device *vi)
> +{
> +	struct device_node *node =3D vi->dev->of_node;
> +	struct device_node *ep =3D NULL;
> +	struct device_node *next;=20
> +	struct device_node *remote =3D NULL;
> +	struct tegra_vi_graph_entity *entity;
> +	struct v4l2_async_subdev **subdevs =3D NULL;
> +	unsigned int num_subdevs;

This variable is being used uninitialized.

> +static int tegra_vi_probe(struct platform_device *pdev)
> +{
> +	struct resource *res;
> +	struct tegra_vi_device *vi;
> +	int ret =3D 0;
> +
> +	vi =3D devm_kzalloc(&pdev->dev, sizeof(*vi), GFP_KERNEL);
> +	if (!vi)
> +		return -ENOMEM;
> +
> +	vi->dev =3D &pdev->dev;
> +	INIT_LIST_HEAD(&vi->entities);
> +	mutex_init(&vi->lock);
> +
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	vi->iomem =3D devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(vi->iomem))
> +		return PTR_ERR(vi->iomem);
> +
> +	vi->vi_rst =3D devm_reset_control_get(&pdev->dev, "vi");
> +	if (IS_ERR(vi->vi_rst)) {
> +		dev_err(&pdev->dev, "Failed to get vi reset\n");
> +		return -EPROBE_DEFER;
> +	}

There could be other reasons for failure, so you should really propagate
the error code that devm_reset_control_get() provides:

		return PTR_ERR(vi->vi_rst);

> +	vi->vi_clk =3D devm_clk_get(&pdev->dev, "vi");
> +	if (IS_ERR(vi->vi_clk)) {
> +		dev_err(&pdev->dev, "Failed to get vi clock\n");
> +		return -EPROBE_DEFER;
> +	}

Same here...

> +	vi->parent_clk =3D devm_clk_get(&pdev->dev, "parent");
> +	if (IS_ERR(vi->parent_clk)) {
> +		dev_err(&pdev->dev, "Failed to get VI parent clock\n");
> +		return -EPROBE_DEFER;
> +	}

=2E.. here...

> +	ret =3D clk_set_parent(vi->vi_clk, vi->parent_clk);
> +	if (ret < 0)
> +		return ret;
> +
> +	vi->csi_clk =3D devm_clk_get(&pdev->dev, "csi");
> +	if (IS_ERR(vi->csi_clk)) {
> +		dev_err(&pdev->dev, "Failed to get csi clock\n");
> +		return -EPROBE_DEFER;
> +	}

=2E.. here...

> +	vi->vi_reg =3D devm_regulator_get(&pdev->dev, "avdd-dsi-csi");
> +	if (IS_ERR(vi->vi_reg)) {
> +		dev_err(&pdev->dev, "Failed to get avdd-dsi-csi regulators\n");
> +		return -EPROBE_DEFER;
> +	}

and here.

> +	vi_tpg_fmts_bitmap_init(vi);
> +
> +	ret =3D tegra_vi_v4l2_init(vi);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* Check whether VI is in test pattern generator (TPG) mode */
> +	of_property_read_u32(vi->dev->of_node, "nvidia,pg_mode",
> +			     &vi->pg_mode);

This doesn't sound right. Wouldn't this mean that you can either use the
device in TPG mode or sensor mode only? With no means of switching at
runtime? But then I see that there's an IOCTL to set this mode, so why
even bother having this in DT in the first place?

> +	/* Init Tegra VI channels */
> +	ret =3D tegra_vi_channels_init(vi);
> +	if (ret < 0)
> +		goto channels_error;
> +
> +	/* Setup media links between VI and external sensor subdev. */
> +	ret =3D tegra_vi_graph_init(vi);
> +	if (ret < 0)
> +		goto graph_error;
> +
> +	platform_set_drvdata(pdev, vi);
> +
> +	dev_info(vi->dev, "device registered\n");

Can we get rid of this, please? There's no use in spamming the kernel
log with brag. Let people know when things have failed. Success is the
expected outcome of ->probe().

> +static struct platform_driver tegra_vi_driver =3D {
> +	.driver =3D {
> +		.name =3D "tegra-vi",
> +		.of_match_table =3D tegra_vi_of_id_table,
> +	},
> +	.probe =3D tegra_vi_probe,
> +	.remove =3D tegra_vi_remove,
> +};
> +
> +module_platform_driver(tegra_vi_driver);

There's usually no blank line between the above.

> diff --git a/drivers/media/platform/tegra/tegra-vi.h b/drivers/media/plat=
form/tegra/tegra-vi.h
> new file mode 100644
> index 0000000..d30a6ec
> --- /dev/null
> +++ b/drivers/media/platform/tegra/tegra-vi.h
> @@ -0,0 +1,224 @@
> +/*
> + * NVIDIA Tegra Video Input Device
> + *
> + * Copyright (c) 2015, NVIDIA CORPORATION.  All rights reserved.
> + *
> + * Author: Bryan Wu <pengw@nvidia.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef __TEGRA_VI_H__
> +#define __TEGRA_VI_H__
> +
> +#include <linux/host1x.h>
> +#include <linux/list.h>
> +#include <linux/mutex.h>
> +#include <linux/spinlock.h>
> +#include <linux/videodev2.h>
> +
> +#include <media/media-device.h>
> +#include <media/media-entity.h>
> +#include <media/v4l2-async.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-dev.h>
> +#include <media/videobuf2-core.h>
> +
> +#include "tegra-core.h"
> +
> +#define MAX_CHAN_NUM	6
> +#define MAX_FORMAT_NUM	64

Perhaps these need to be runtime parameters to support multiple SoC
generations? Tegra K1 seems to have only 2 channels instead of 6.

> +
> +/**
> + * struct tegra_channel_buffer - video channel buffer
> + * @buf: vb2 buffer base object
> + * @queue: buffer list entry in the channel queued buffers list
> + * @chan: channel that uses the buffer
> + * @addr: Tegra IOVA buffer address for VI output
> + */
> +struct tegra_channel_buffer {
> +	struct vb2_buffer buf;
> +	struct list_head queue;
> +	struct tegra_channel *chan;
> +
> +	dma_addr_t addr;
> +};
> +
> +#define to_tegra_channel_buffer(vb) \
> +	container_of(vb, struct tegra_channel_buffer, buf)

I usually prefer static inline functions over macros for this type of
upcasting. But perhaps Hans prefers this, so I'll defer to his judgement
here.

> +struct chan_regs_config {
> +	u32 csi;
> +	u32 pp;
> +	u32 cil;
> +	u32 phy;
> +	u32 tpg;
> +};

Have you considered making these void __iomem * so that you can avoid
the addition of the offset whenever you access a register?

> +/**
> + * struct tegra_channel - Tegra video channel
> + * @list: list entry in a composite device dmas list
> + * @video: V4L2 video device associated with the video channel
> + * @video_lock:
> + * @pad: media pad for the video device entity
> + * @pipe: pipeline belonging to the channel
> + *
> + * @vi: composite device DT node port number for the channel
> + *
> + * @client: host1x client struct of Tegra DRM

host1x client is separate from Tegra DRM.

> + * @sp: host1x syncpoint pointer
> + *
> + * @work: kernel workqueue structure of this video channel
> + * @lock: protects the @format, @fmtinfo, @queue and @work fields
> + *
> + * @format: active V4L2 pixel format
> + * @fmtinfo: format information corresponding to the active @format
> + *
> + * @queue: vb2 buffers queue
> + * @alloc_ctx: allocation context for the vb2 @queue
> + * @sequence: V4L2 buffers sequence number
> + *
> + * @capture: list of queued buffers for capture
> + * @active: active buffer for capture
> + * @queued_lock: protects the buf_queued list
> + *
> + * @iomem: root register base
> + * @regs: CSI/CIL/PHY register bases
> + * @cil_clk: clock for CIL
> + * @align: channel buffer alignment, default is 64
> + * @port: CSI port of this video channel
> + * @surface: output memory surface number
> + * @io_id: Tegra IO rail ID of this video channel
> + * @bypass: a flag to bypass register write
> + *
> + * @fmts_bitmap: a bitmap for formats supported
> + *
> + * @remote_entity: remote media entity for external sensor
> + */
> +struct tegra_channel {
> +	struct list_head list;
> +	struct video_device video;
> +	struct mutex video_lock;
> +	struct media_pad pad;
> +	struct media_pipeline pipe;
> +
> +	struct tegra_vi_device *vi;
> +
> +	struct host1x_client client;
> +	struct host1x_syncpt *sp;
> +
> +	struct work_struct work;
> +	struct mutex lock;
> +
> +	struct v4l2_pix_format format;
> +	const struct tegra_video_format *fmtinfo;
> +
> +	struct vb2_queue queue;
> +	void *alloc_ctx;
> +	u32 sequence;
> +
> +	struct list_head capture;
> +	struct tegra_channel_buffer *active;
> +	spinlock_t queued_lock;
> +
> +	void __iomem *iomem;
> +	struct chan_regs_config regs;
> +	struct clk *cil_clk;
> +	int align;
> +	u32 port;

Those can both be unsigned int.

> +	u32 surface;

This seems to be fixed to 0, do we need it?

> +	int io_id;
> +	int bypass;

bool?

> +/**
> + * struct tegra_vi_device - NVIDIA Tegra Video Input device structure
> + * @v4l2_dev: V4L2 device
> + * @media_dev: media device
> + * @dev: device struct
> + *
> + * @iomem: register base
> + * @vi_clk: main clock for VI block
> + * @parent_clk: parent clock of VI clock
> + * @csi_clk: clock for CSI
> + * @vi_rst: reset controler
> + * @vi_reg: regulator for VI hardware, normally it avdd_dsi_csi
> + *
> + * @lock: mutex lock to protect power on/off operations
> + * @power_on_refcnt: reference count for power on/off operations
> + *
> + * @notifier: V4L2 asynchronous subdevs notifier
> + * @entities: entities in the graph as a list of tegra_vi_graph_entity
> + * @num_subdevs: number of subdevs in the pipeline
> + *
> + * @channels: list of channels at the pipeline output and input
> + *
> + * @ctrl_handler: V4L2 control handler
> + * @pattern: test pattern generator V4L2 control
> + * @pg_mode: test pattern generator mode (disabled/direct/patch)
> + * @tpg_fmts_bitmap: a bitmap for formats in test pattern generator mode
> + */
> +struct tegra_vi_device {
> +	struct v4l2_device v4l2_dev;
> +	struct media_device media_dev;
> +	struct device *dev;
> +
> +	void __iomem *iomem;
> +	struct clk *vi_clk;
> +	struct clk *parent_clk;
> +	struct clk *csi_clk;
> +	struct reset_control *vi_rst;
> +	struct regulator *vi_reg;
> +
> +	struct mutex lock;
> +	int power_on_refcnt;

unsigned int, or perhaps even atomic_t, in which case you might be able
to remove the locks from ->open()/->release().

> +
> +	struct v4l2_async_notifier notifier;
> +	struct list_head entities;
> +	unsigned int num_subdevs;
> +
> +	struct tegra_channel chans[MAX_CHAN_NUM];
> +
> +	struct v4l2_ctrl_handler ctrl_handler;
> +	struct v4l2_ctrl *pattern;
> +	int pg_mode;

Perhaps this should be an enum?

> diff --git a/include/dt-bindings/media/tegra-vi.h b/include/dt-bindings/m=
edia/tegra-vi.h
[...]
> +#ifndef __DT_BINDINGS_MEDIA_TEGRA_VI_H__
> +#define __DT_BINDINGS_MEDIA_TEGRA_VI_H__
> +
> +/*
> + * Supported CSI to VI Data Formats
> + */
> +#define TEGRA_VF_RAW6		0
> +#define TEGRA_VF_RAW7		1
> +#define TEGRA_VF_RAW8		2
> +#define TEGRA_VF_RAW10		3
> +#define TEGRA_VF_RAW12		4
> +#define TEGRA_VF_RAW14		5
> +#define TEGRA_VF_EMBEDDED8	6
> +#define TEGRA_VF_RGB565		7
> +#define TEGRA_VF_RGB555		8
> +#define TEGRA_VF_RGB888		9
> +#define TEGRA_VF_RGB444		10
> +#define TEGRA_VF_RGB666		11
> +#define TEGRA_VF_YUV422		12
> +#define TEGRA_VF_YUV420		13
> +#define TEGRA_VF_YUV420_CSPS	14
> +
> +#endif /* __DT_BINDINGS_MEDIA_TEGRA_VI_H__ */

What do we need these for? These seem to me to be internal formats
supported by the hardware, but the existence of this file implies that
you plan on using them in the DT. What's the use-case?

Thierry

--+pHx0qQiF2pBVqBT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJV1yGnAAoJEN0jrNd/PrOhmfcQAJWx34mY349Xt052zHks/TtX
juZRh+obfNOy+2RQRagDIyCUitJ0ncgpeE7VDWBS3VQwXJ6CPGNpZueWUuc9opk4
2mbi+6FoFlyJqLYrZOdoRbo5Yei9VoHLEjGsoVC6V4wMhIGj+qkZxZQZ2Z+tR3lu
WMsCWNLgdQbpfc6cUD+TXFxTzFyEavJkn9R1Ybse7rf+cqmQOwo1IP6fYrx+BGz3
nHG+N3QNddqiOrVvW0CZoEuD68W6meVZ3CcHcdEpZsY4Mn7Ea8xts9JmiHubL5PT
5moZwmrMhKJw158c2wlBoQeFrY66v8GlAqnxtp5BbEXEUFn9lx9ExOj8iXGitm5d
zfn6tTYka0NnLh9KmndAE29BabIeT301QJg3KZvH9YvZLfAAdeuFpianpPl/Z2Mb
vijY6yXDpjGT+GkUuSVTnvjpCQ+Ywvse4bYsZSUcODQCbDQMvkl3rPbSI9PxQFge
vWJ3Pe1x73ge4m5zpFmYfS2jA5eHLfkgl9AJMeM9OxBtE5/0CkmT9EpkRDp29s9b
1j0CL/7Wo6znFVzhU3lvT5elHbYsoNUhTVuKd6W3sUX9GH3eeI7S421mDW540BM5
cH8/xXxuFPcYu06K3Oyz0WX2Q2b+UGDH2ILPKcDpp42yHroMQQnVwtiJYbETkSj5
dmPDaFgkzFxeIiZP7KjX
=nRnf
-----END PGP SIGNATURE-----

--+pHx0qQiF2pBVqBT--
