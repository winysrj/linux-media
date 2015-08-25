Return-path: <linux-media-owner@vger.kernel.org>
Received: from hqemgate14.nvidia.com ([216.228.121.143]:5616 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbbHYA1F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Aug 2015 20:27:05 -0400
Message-ID: <55DBB62C.4020606@nvidia.com>
Date: Mon, 24 Aug 2015 17:26:20 -0700
From: Bryan Wu <pengw@nvidia.com>
MIME-Version: 1.0
To: Thierry Reding <treding@nvidia.com>
CC: <hansverk@cisco.com>, <linux-media@vger.kernel.org>,
	<ebrower@nvidia.com>, <jbang@nvidia.com>, <swarren@nvidia.com>,
	<wenjiaz@nvidia.com>, <davidw@nvidia.com>, <gfitzer@nvidia.com>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 1/2] [media] v4l: tegra: Add NVIDIA Tegra VI driver
References: <1440118300-32491-1-git-send-email-pengw@nvidia.com> <1440118300-32491-5-git-send-email-pengw@nvidia.com> <20150821130339.GB22118@ulmo.nvidia.com>
In-Reply-To: <20150821130339.GB22118@ulmo.nvidia.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/21/2015 06:03 AM, Thierry Reding wrote:
> On Thu, Aug 20, 2015 at 05:51:39PM -0700, Bryan Wu wrote:
>> NVIDIA Tegra processor contains a powerful Video Input (VI) hardware
>> controller which can support up to 6 MIPI CSI camera sensors.
>>
>> This patch adds a V4L2 media controller and capture driver to support
>> Tegra VI hardware. It's verified with Tegra built-in test pattern
>> generator.
> Hi Bryan,
>
> I've been looking forward to seeing this posted. I don't know the VI
> hardware in very much detail, nor am I an expert on the media framework,
> so I will primarily comment on architectural or SoC-specific things.
>
> By the way, please always Cc linux-tegra@vger.kernel.org on all patches
> relating to Tegra. That way people not explicitly Cc'ed but still
> interested in Tegra will see this code, even if they aren't subscribed
> to the linux-media mailing list.
Oops. let me add linux-tegra@vger.kernel.org in Cc this time.

>> Signed-off-by: Bryan Wu <pengw@nvidia.com>
>> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>   drivers/media/platform/Kconfig               |    1 +
>>   drivers/media/platform/Makefile              |    2 +
>>   drivers/media/platform/tegra/Kconfig         |    9 +
>>   drivers/media/platform/tegra/Makefile        |    3 +
>>   drivers/media/platform/tegra/tegra-channel.c | 1074 ++++++++++++++++++++++++++
>>   drivers/media/platform/tegra/tegra-core.c    |  295 +++++++
>>   drivers/media/platform/tegra/tegra-core.h    |  134 ++++
>>   drivers/media/platform/tegra/tegra-vi.c      |  585 ++++++++++++++
>>   drivers/media/platform/tegra/tegra-vi.h      |  224 ++++++
>>   include/dt-bindings/media/tegra-vi.h         |   35 +
>>   10 files changed, 2362 insertions(+)
>>   create mode 100644 drivers/media/platform/tegra/Kconfig
>>   create mode 100644 drivers/media/platform/tegra/Makefile
>>   create mode 100644 drivers/media/platform/tegra/tegra-channel.c
>>   create mode 100644 drivers/media/platform/tegra/tegra-core.c
>>   create mode 100644 drivers/media/platform/tegra/tegra-core.h
>>   create mode 100644 drivers/media/platform/tegra/tegra-vi.c
>>   create mode 100644 drivers/media/platform/tegra/tegra-vi.h
>>   create mode 100644 include/dt-bindings/media/tegra-vi.h
> I can't spot a device tree binding document for this, but we'll need one
> to properly review this driver.
Sure, I will add binding document for this.

>> diff --git a/drivers/media/platform/tegra/Kconfig b/drivers/media/platform/tegra/Kconfig
>> new file mode 100644
>> index 0000000..a69d1b2
>> --- /dev/null
>> +++ b/drivers/media/platform/tegra/Kconfig
>> @@ -0,0 +1,9 @@
>> +config VIDEO_TEGRA
>> +	tristate "NVIDIA Tegra Video Input Driver (EXPERIMENTAL)"
> I don't think the (EXPERIMENTAL) is warranted. Either the driver works
> or it doesn't. And I assume you already tested that it works, even if
> only using the TPG.

OK, I will remove EXPERIMENTAL.

>> +	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF
> This seems to be missing a couple of dependencies. For example I would
> expect at least TEGRA_HOST1X to be listed here to make sure people can't
> select this when the host1x API isn't available. I would also expect
> some sort of architecture dependency because it really makes no sense to
> build this if Tegra isn't supported.
>
> If you are concerned about compile coverage you can make that explicit
> using a COMPILE_TEST alternative such as:
>
> 	depends on ARCH_TEGRA || (ARM && COMPILE_TEST)
>
> Note that the ARM dependency in there makes sure that HAVE_IOMEM is
> selected, so this could also be:
>
> 	depends on ARCH_TEGRA || (HAVE_IOMEM && COMPILE_TEST)
>
> though that'd still leave open the possibility of build breakage because
> of some missing support.
>
> If you add the dependency on TEGRA_HOST1X that I mentioned above you
> shouldn't need any architecture dependency because TEGRA_HOST1X implies
> those already.
Let me add 'depends on TEGRA_HOST1X' which depends on ARCH_TEGRA. Then I 
don't think I need more Tegra architecture specific rules here, because 
like pmc.c covers IO rails, powergate and reset-controller.

>> +	select VIDEOBUF2_DMA_CONTIG
>> +	---help---
>> +	  Driver for Video Input (VI) device controller in NVIDIA Tegra SoC.
> I'd reword this slightly as:
>
> 	  Driver for the Video Input (VI) controller found on NVIDIA Tegra
> 	  SoCs.

Fixed.

>> +
>> +	  TO compile this driver as a module, choose M here: the module will be
> s/TO/To/.

Fixed.

>
>> +	  called tegra-video.
>> diff --git a/drivers/media/platform/tegra/Makefile b/drivers/media/platform/tegra/Makefile
>> new file mode 100644
>> index 0000000..c8eff0b
>> --- /dev/null
>> +++ b/drivers/media/platform/tegra/Makefile
>> @@ -0,0 +1,3 @@
>> +tegra-video-objs += tegra-core.o tegra-vi.o tegra-channel.o
> I'd personally leave out the redundant tegra- prefix here, because the
> files are in a tegra/ subdirectory already.
Right, some subsystem might don't like those prefix. But I just follow 
the rules in media subsystem here.

>> +obj-$(CONFIG_VIDEO_TEGRA) += tegra-video.o
>> diff --git a/drivers/media/platform/tegra/tegra-channel.c b/drivers/media/platform/tegra/tegra-channel.c
>> new file mode 100644
>> index 0000000..b0063d2
>> --- /dev/null
>> +++ b/drivers/media/platform/tegra/tegra-channel.c
>> @@ -0,0 +1,1074 @@
>> +/*
>> + * NVIDIA Tegra Video Input Device
>> + *
>> + * Copyright (c) 2015, NVIDIA CORPORATION.  All rights reserved.
>> + *
>> + * Author: Bryan Wu <pengw@nvidia.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include <linux/atomic.h>
>> +#include <linux/bitmap.h>
>> +#include <linux/clk.h>
>> +#include <linux/delay.h>
>> +#include <linux/host1x.h>
>> +#include <linux/lcm.h>
>> +#include <linux/list.h>
>> +#include <linux/module.h>
>> +#include <linux/of.h>
>> +#include <linux/slab.h>
>> +
>> +#include <media/v4l2-ctrls.h>
>> +#include <media/v4l2-dev.h>
>> +#include <media/v4l2-fh.h>
>> +#include <media/v4l2-ioctl.h>
>> +#include <media/videobuf2-core.h>
>> +#include <media/videobuf2-dma-contig.h>
>> +
>> +#include <soc/tegra/pmc.h>
>> +
>> +#include "tegra-vi.h"
>> +
>> +#define TEGRA_VI_SYNCPT_WAIT_TIMEOUT			200
>> +
>> +/* VI registers */
>> +#define TEGRA_VI_CFG_VI_INCR_SYNCPT                     0x000
>> +#define		SP_PP_LINE_START			4
>> +#define		SP_PP_FRAME_START			5
>> +#define		SP_MW_REQ_DONE				6
>> +#define		SP_MW_ACK_DONE				7
> Indentation is weird here. There also seems to be a mix of spaces and
> tabs in the register definitions below. I find that these end up hard to
> read, so it'd be good to make these consistent.
I will fix the indentation here. Since SP_XXX is a definition of some 
register bits, I put some indentation here to make it different from 
other register definitions.

I will replace spaces with tabs in other register definitions.

>> +/* CSI registers */
>> +#define TEGRA_VI_CSI_0_BASE                             0x100
>> +#define TEGRA_VI_CSI_1_BASE                             0x200
>> +#define TEGRA_VI_CSI_2_BASE                             0x300
>> +#define TEGRA_VI_CSI_3_BASE                             0x400
>> +#define TEGRA_VI_CSI_4_BASE                             0x500
>> +#define TEGRA_VI_CSI_5_BASE                             0x600
> You seem to be computing these offsets later on based on the CSI 0 base
> and an offset multiplied by the instance number. Perhaps define this as
>
> 	#define TEGRA_VI_CSI_BASE(x)	(0x100 + (x) * 0x100)
>
> to avoid the unused defines as well as the computation later on?

Good point. I will fix this.



>> +/* CSI Pixel Parser registers */
>> +#define TEGRA_CSI_PIXEL_PARSER_0_BASE			0x0838
>> +#define TEGRA_CSI_PIXEL_PARSER_1_BASE			0x086c
>> +#define TEGRA_CSI_PIXEL_PARSER_2_BASE			0x1038
>> +#define TEGRA_CSI_PIXEL_PARSER_3_BASE			0x106c
>> +#define TEGRA_CSI_PIXEL_PARSER_4_BASE			0x1838
>> +#define TEGRA_CSI_PIXEL_PARSER_5_BASE			0x186c
> Same comment as for TEGRA_VI_CSI_*_BASE above. Only the first of these
> is used.
Fixed.

>> +
>> +
>> +/* CSI Pixel Parser registers */
>> +#define TEGRA_CSI_INPUT_STREAM_CONTROL                  0x000
>> +#define TEGRA_CSI_PIXEL_STREAM_CONTROL0                 0x004
>> +#define TEGRA_CSI_PIXEL_STREAM_CONTROL1                 0x008
>> +#define TEGRA_CSI_PIXEL_STREAM_GAP                      0x00c
>> +#define TEGRA_CSI_PIXEL_STREAM_PP_COMMAND               0x010
>> +#define TEGRA_CSI_PIXEL_STREAM_EXPECTED_FRAME           0x014
>> +#define TEGRA_CSI_PIXEL_PARSER_INTERRUPT_MASK           0x018
>> +#define TEGRA_CSI_PIXEL_PARSER_STATUS                   0x01c
>> +#define TEGRA_CSI_CSI_SW_SENSOR_RESET                   0x020
>> +
>> +/* CSI PHY registers */
>> +#define TEGRA_CSI_CIL_PHY_0_BASE			0x0908
>> +#define TEGRA_CSI_CIL_PHY_1_BASE			0x1108
>> +#define TEGRA_CSI_CIL_PHY_2_BASE			0x1908
> Same as for the other base offsets.
Fixed

>> +#define TEGRA_CSI_PHY_CIL_COMMAND			0x0908
> This doesn't seem to be used at all.

Actually this PHY register just has this one only, I need define it as 
0x0 offset here. Let's keep this since in future we might have more PHY 
registers.

>
>> +/* CSI CIL registers */
>> +#define TEGRA_CSI_CIL_0_BASE				0x092c
>> +#define TEGRA_CSI_CIL_1_BASE				0x0960
>> +#define TEGRA_CSI_CIL_2_BASE				0x112c
>> +#define TEGRA_CSI_CIL_3_BASE				0x1160
>> +#define TEGRA_CSI_CIL_4_BASE				0x192c
>> +#define TEGRA_CSI_CIL_5_BASE				0x1960
> Again, unused base defines, so might be better to go with a
> parameterized definition.

Fixed

>> +#define TEGRA_CSI_CIL_PAD_CONFIG0                       0x000
>> +#define TEGRA_CSI_CIL_PAD_CONFIG1                       0x004
>> +#define TEGRA_CSI_CIL_PHY_CONTROL                       0x008
>> +#define TEGRA_CSI_CIL_INTERRUPT_MASK                    0x00c
>> +#define TEGRA_CSI_CIL_STATUS                            0x010
>> +#define TEGRA_CSI_CILX_STATUS                           0x014
>> +#define TEGRA_CSI_CIL_ESCAPE_MODE_COMMAND               0x018
>> +#define TEGRA_CSI_CIL_ESCAPE_MODE_DATA                  0x01c
>> +#define TEGRA_CSI_CIL_SW_SENSOR_RESET                   0x020
>> +
>> +/* CSI Pattern Generator registers */
>> +#define TEGRA_CSI_PATTERN_GENERATOR_0_BASE		0x09c4
>> +#define TEGRA_CSI_PATTERN_GENERATOR_1_BASE		0x09f8
>> +#define TEGRA_CSI_PATTERN_GENERATOR_2_BASE		0x11c4
>> +#define TEGRA_CSI_PATTERN_GENERATOR_3_BASE		0x11f8
>> +#define TEGRA_CSI_PATTERN_GENERATOR_4_BASE		0x19c4
>> +#define TEGRA_CSI_PATTERN_GENERATOR_5_BASE		0x19f8
> More unused base defines.
Fixed.

>
>> +#define TEGRA_CSI_PATTERN_GENERATOR_CTRL		0x000
>> +#define TEGRA_CSI_PG_BLANK				0x004
>> +#define TEGRA_CSI_PG_PHASE				0x008
>> +#define TEGRA_CSI_PG_RED_FREQ				0x00c
>> +#define TEGRA_CSI_PG_RED_FREQ_RATE			0x010
>> +#define TEGRA_CSI_PG_GREEN_FREQ				0x014
>> +#define TEGRA_CSI_PG_GREEN_FREQ_RATE			0x018
>> +#define TEGRA_CSI_PG_BLUE_FREQ				0x01c
>> +#define TEGRA_CSI_PG_BLUE_FREQ_RATE			0x020
>> +#define TEGRA_CSI_PG_AOHDR				0x024
>> +
>> +#define TEGRA_CSI_DPCM_CTRL_A				0xad0
>> +#define TEGRA_CSI_DPCM_CTRL_B				0xad4
>> +#define TEGRA_CSI_STALL_COUNTER				0xae8
>> +#define TEGRA_CSI_CSI_READONLY_STATUS			0xaec
>> +#define TEGRA_CSI_CSI_SW_STATUS_RESET			0xaf0
>> +#define TEGRA_CSI_CLKEN_OVERRIDE			0xaf4
>> +#define TEGRA_CSI_DEBUG_CONTROL				0xaf8
>> +#define TEGRA_CSI_DEBUG_COUNTER_0			0xafc
>> +#define TEGRA_CSI_DEBUG_COUNTER_1			0xb00
>> +#define TEGRA_CSI_DEBUG_COUNTER_2			0xb04
> Some of these are unused. I guess there's an argument to be made to
> include all register definitions rather than just the used ones, if for
> nothing else than completeness. I'll defer to Hans's judgement on this.

These are VI/CSI global registers shared by all the channels. Some of 
them are used in this driver, I suggest we keep them here.

>> +/* Channel registers */
>> +static void tegra_channel_write(struct tegra_channel *chan, u32 addr, u32 val)
> I prefer unsigned int offset instead of u32 addr. That makes in more
> obvious that this is actually an offset from some I/O memory base
> address. Also using a sized type for the offset is a bit exaggerated
> because it doesn't need to be of any specific size.
>
> The same comment applies to the other accessors below.

OK , I will use unsigned int.

>> +{
>> +	if (chan->bypass)
>> +		return;
> I don't see this being set anywhere. Is it dead code? Also the only
> description I see is that it's used to bypass register writes, but I
> don't see an explanation why that's necessary.

We are unifying our downstream VI driver with V4L2 VI driver. And this 
upstream work is the first step to help that.

We are also backporting this driver back to our internal 3.10 kernel 
which is using nvhost channel to submit register operations from 
userspace to host1x and VI hardware. Then in this case, our driver needs 
to bypass all the register operations otherwise we got conflicts between 
these 2 paths.

That's why I put bypass mode here. And bypass mode can be set in device 
tree or from v4l2-ctrls.

>> +/* CIL PHY registers */
>> +static void phy_write(struct tegra_channel *chan, u32 val)
>> +{
>> +	tegra_channel_write(chan, chan->regs.phy, val);
>> +}
>> +
>> +static u32 phy_read(struct tegra_channel *chan)
>> +{
>> +	return tegra_channel_read(chan, chan->regs.phy);
>> +}
> Are these missing an offset parameter? Or do these subblocks only have a
> single register? Even if that's the case, I think it'd be more
> consistent to have the same signature as the other accessors.
OK, I will fix this.


>> +/* Syncpoint bits of TEGRA_VI_CFG_VI_INCR_SYNCPT */
>> +static u32 sp_bit(struct tegra_channel *chan, u32 sp)
>> +{
>> +	return (sp + chan->port * 4) << 8;
>> +}
> Technically this returns a mask, not a bit, so sp_mask() would be more
> appropriate.
Actually it returns the syncpoint value for each port not a mask. 
Probably sp_bits() is better.

>> +/* Calculate register base */
>> +static u32 regs_base(u32 regs_base, int port)
>> +{
>> +	return regs_base + (port / 2 * 0x800) + (port & 1) * 0x34;
>> +}
>> +
>> +/* CSI channel IO Rail IDs */
>> +int tegra_io_rail_csi_ids[] = {
> This can be static const as far as I can tell.

OK, I fixed this.

>> +	TEGRA_IO_RAIL_CSIA,
>> +	TEGRA_IO_RAIL_CSIB,
>> +	TEGRA_IO_RAIL_CSIC,
>> +	TEGRA_IO_RAIL_CSID,
>> +	TEGRA_IO_RAIL_CSIE,
>> +	TEGRA_IO_RAIL_CSIF,
>> +};
>> +
>> +void tegra_channel_fmts_bitmap_init(struct tegra_channel *chan)
>> +{
>> +	int ret, index;
>> +	struct v4l2_subdev *subdev = chan->remote_entity->subdev;
>> +	struct v4l2_subdev_mbus_code_enum code = {
>> +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
>> +	};
>> +
>> +
> Spurious blank line.

Removed
>
>> +static int tegra_channel_capture_setup(struct tegra_channel *chan)
>> +{
>> +	int lanes = 2;
> unsigned int? And why is it hardcoded to 2? There are checks below for
> lanes == 4, which will effectively never happen. So at the very least I
> think this should have a TODO comment of some sort. Preferably can it
> not be determined at runtime what number of lanes we need?
Sure, I forget to fix this. lanes should get from DT and for TPG mode I 
will choose lanes as 4 by default.

>> +	int port = chan->port;
> unsigned int?

fixed.

>
>> +	u32 height = chan->format.height;
>> +	u32 width = chan->format.width;
>> +	u32 format = chan->fmtinfo->img_fmt;
>> +	u32 data_type = chan->fmtinfo->img_dt;
>> +	u32 word_count = tegra_core_get_word_count(width, chan->fmtinfo);
>> +	struct chan_regs_config *regs = &chan->regs;
>> +
>> +	/* CIL PHY register setup */
>> +	if (port & 0x1) {
>> +		cil_write(chan, TEGRA_CSI_CIL_PAD_CONFIG0 - 0x34, 0x0);
>> +		cil_write(chan, TEGRA_CSI_CIL_PAD_CONFIG0, 0x0);
>> +	} else {
>> +		cil_write(chan, TEGRA_CSI_CIL_PAD_CONFIG0, 0x10000);
>> +		cil_write(chan, TEGRA_CSI_CIL_PAD_CONFIG0 + 0x34, 0x0);
>> +	}
> This seems to address registers not actually part of this channel. Why?
It's little bit hackish, but it's really have no choice. CIL PHY is 
shared by 2 channels. like CSIA and CSIB, CSIC and CSID, CSIE and CSIF. 
So we have 3 groups.


> Also you use magic numbers here and in the remainder of the driver. We
> should be able to do better. I presume all of this is documented in the
> TRM, so we should be able to easily substitute symbolic names.
I also got those magic numbers from internal source. Some of them are 
not in the TRM. And people just use that settings. I will try to convert 
them to some meaningful bit names. Please let me do it after I finished 
the whole work as an incremental patch.


>
>> +	cil_write(chan, TEGRA_CSI_CIL_INTERRUPT_MASK, 0x0);
>> +	cil_write(chan, TEGRA_CSI_CIL_PHY_CONTROL, 0xA);
>> +	if (lanes == 4) {
>> +		regs->cil = regs_base(TEGRA_CSI_CIL_0_BASE, port + 1);
>> +		cil_write(chan, TEGRA_CSI_CIL_PAD_CONFIG0, 0x0);
>> +		cil_write(chan,	TEGRA_CSI_CIL_INTERRUPT_MASK, 0x0);
>> +		cil_write(chan, TEGRA_CSI_CIL_PHY_CONTROL, 0xA);
>> +		regs->cil = regs_base(TEGRA_CSI_CIL_0_BASE, port);
>> +	}
> And this seems to access registers from another port by temporarily
> rewriting the CIL base offset. That seems a little hackish to me. I
> don't know the hardware intimately enough to know exactly what this
> is supposed to accomplish, perhaps you can clarify? Also perhaps we
> can come up with some architectural overview of the VI hardware, or
> does such an overview exist in the TRM?

CSI have 6 channels but just 3 PHYs. If a channel want to use 4 data 
lanes, then it has to be CSIA, CSIC and CSIE. And CSIB, CSID and CSIF 
channels can not be used in this case.

That's why we need to access the CSIB/D/F registers in 4 data lanes use 
case.

> I see there is, perhaps add a comment somewhere, in the commit
> description or the file header giving a reference to where the
> architectural overview can be found?

It can be found in Tegra X1 TRM like this:
"The CSI unit provides for connection of up to six cameras in the system 
and is organized as three identical instances of two
MIPI support blocks, each with a separate 4-lane interface that can be 
configured as a single camera with 4 lanes or as a dual
camera with 2 lanes available for each camera."

What about I put this information in the code as a comment?
>> +	/* CSI pixel parser registers setup */
>> +	pp_write(chan, TEGRA_CSI_PIXEL_STREAM_PP_COMMAND, 0xf007);
>> +	pp_write(chan, TEGRA_CSI_PIXEL_PARSER_INTERRUPT_MASK, 0x0);
>> +	pp_write(chan, TEGRA_CSI_PIXEL_STREAM_CONTROL0,
>> +		 0x280301f0 | (port & 0x1));
>> +	pp_write(chan, TEGRA_CSI_PIXEL_STREAM_PP_COMMAND, 0xf007);
>> +	pp_write(chan, TEGRA_CSI_PIXEL_STREAM_CONTROL1, 0x11);
>> +	pp_write(chan, TEGRA_CSI_PIXEL_STREAM_GAP, 0x140000);
>> +	pp_write(chan, TEGRA_CSI_PIXEL_STREAM_EXPECTED_FRAME, 0x0);
>> +	pp_write(chan, TEGRA_CSI_INPUT_STREAM_CONTROL,
>> +		 0x3f0000 | (lanes - 1));
>> +
>> +	/* CIL PHY register setup */
>> +	if (lanes == 4)
>> +		phy_write(chan, 0x0101);
>> +	else {
>> +		u32 val = phy_read(chan);
>> +		if (port & 0x1)
>> +			val = (val & ~0x100) | 0x100;
>> +		else
>> +			val = (val & ~0x1) | 0x1;
>> +		phy_write(chan, val);
>> +	}
> The & ~ isn't quite doing what I suspect it should be doing. My
> assumption is that you want to set this register to 0x01 if the first
> port is to be used and 0x100 if the second port is to be used (or 0x101
> if both ports are to be used). In that case I think you'll want
> something like this:
>
> 	value = phy_read(chan);
>
> 	if (port & 1)
> 		value = (value & ~0x0001) | 0x0100;
> 	else
> 		value = (value & ~0x0100) | 0x0001;
>
> 	phy_write(chan, value);

I don't think your code is correct. The algorithm is to read out the 
share PHY register value and clear the port related bit and set that 
bit. Then it won't touch the setting of the other port. It means when we 
setup a channel it should not change the other channel which sharing PHY 
register with the current one.

In your case, you cleared the other port's bit and set the current port 
bit. When we write the value back to the PHY register, current port will 
be enabled but the other port will be disabled.

For example, like CSIA is running, the value of PHY register is 0x0001.
Then when we try to enable CSIB, we should write 0x0101 to the PHY 
register but not 0x0100.

>> +static void tegra_channel_capture_error(struct tegra_channel *chan, int err)
>> +{
>> +	u32 val;
>> +
>> +#ifdef DEBUG
>> +	val = tegra_channel_read(chan, TEGRA_CSI_DEBUG_COUNTER_0);
>> +	dev_err(&chan->video.dev, "TEGRA_CSI_DEBUG_COUNTER_0 0x%08x\n", val);
>> +#endif
>> +	val = cil_read(chan, TEGRA_CSI_CIL_STATUS);
>> +	dev_err(&chan->video.dev, "TEGRA_CSI_CSI_CIL_STATUS 0x%08x\n", val);
>> +	val = cil_read(chan, TEGRA_CSI_CILX_STATUS);
>> +	dev_err(&chan->video.dev, "TEGRA_CSI_CSI_CILX_STATUS 0x%08x\n", val);
>> +	val = pp_read(chan, TEGRA_CSI_PIXEL_PARSER_STATUS);
>> +	dev_err(&chan->video.dev, "TEGRA_CSI_PIXEL_PARSER_STATUS 0x%08x\n",
>> +		val);
>> +	val = csi_read(chan, TEGRA_VI_CSI_ERROR_STATUS);
>> +	dev_err(&chan->video.dev, "TEGRA_VI_CSI_ERROR_STATUS 0x%08x\n", val);
>> +}
> The err parameter is never used, so it should be dropped.
OK, I removed it.

>
>> +static int tegra_channel_capture_frame(struct tegra_channel *chan)
>> +{
>> +	struct tegra_channel_buffer *buf = chan->active;
>> +	struct vb2_buffer *vb = &buf->buf;
>> +	int err = 0;
>> +	u32 thresh, value, frame_start;
>> +	int bytes_per_line = chan->format.bytesperline;
>> +
>> +	if (!vb2_start_streaming_called(&chan->queue) || !buf)
>> +		return -EINVAL;
>> +
>> +	if (chan->bypass)
>> +		goto bypass_done;
>> +
>> +	/* Program buffer address */
>> +	csi_write(chan,
>> +		  TEGRA_VI_CSI_SURFACE0_OFFSET_MSB + chan->surface * 8,
>> +		  0x0);
>> +	csi_write(chan,
>> +		  TEGRA_VI_CSI_SURFACE0_OFFSET_LSB + chan->surface * 8,
>> +		  buf->addr);
>> +	csi_write(chan,
>> +		  TEGRA_VI_CSI_SURFACE0_STRIDE + chan->surface * 4,
>> +		  bytes_per_line);
>> +
>> +	/* Program syncpoint */
>> +	frame_start = sp_bit(chan, SP_PP_FRAME_START);
>> +	tegra_channel_write(chan, TEGRA_VI_CFG_VI_INCR_SYNCPT,
>> +			    frame_start | host1x_syncpt_id(chan->sp));
>> +
>> +	csi_write(chan, TEGRA_VI_CSI_SINGLE_SHOT, 0x1);
>> +
>> +	/* Use syncpoint to wake up */
>> +	thresh = host1x_syncpt_incr_max(chan->sp, 1);
>> +
>> +	mutex_unlock(&chan->lock);
>> +	err = host1x_syncpt_wait(chan->sp, thresh,
>> +			         TEGRA_VI_SYNCPT_WAIT_TIMEOUT, &value);
>> +	mutex_lock(&chan->lock);
> What's the point of taking the lock in the first place if you drop it
> here, even if temporarily? This is a per-channel lock, and it protects
> the channel against concurrent captures. So if you drop the lock here,
> don't you run risk of having two captures run concurrently? And by the
> time you get to the error handling or buffer completion below you can't
> be sure you're actually dealing with the same buffer that you started
> with.

After some discussion with Hans, I changed to this. Since there won't be 
a second capture start which is prevented by v4l2-core, it won't cause 
the buffer issue.

Waiting for host1x syncpoint take time, so dropping lock can let other 
non-capture ioctls and operations happen.
>> +
>> +	if (err) {
>> +		dev_err(&chan->video.dev, "frame start syncpt timeout!\n");
>> +		tegra_channel_capture_error(chan, err);
>> +	}
> Is timeout really the only kind of error that can happen here?
>
I actually don't know other errors. Any other errors I need take of here?

>> +
>> +bypass_done:
>> +	/* Captured one frame */
>> +	spin_lock_irq(&chan->queued_lock);
>> +	vb->v4l2_buf.sequence = chan->sequence++;
>> +	vb->v4l2_buf.field = V4L2_FIELD_NONE;
>> +	v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
>> +	vb2_set_plane_payload(vb, 0, chan->format.sizeimage);
>> +	vb2_buffer_done(vb, err < 0 ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
>> +	spin_unlock_irq(&chan->queued_lock);
> Do we really need to set all the buffer fields on error? Isn't it enough
> to simply mark the state as "error"?

I believe vb2_buffer_done() needs some fields to set. The code here is 
not very heavy but support both DONE and ERROR mode.

>> +
>> +	return err;
>> +}
>> +
>> +static void tegra_channel_work(struct work_struct *work)
>> +{
>> +	struct tegra_channel *chan =
>> +		container_of(work, struct tegra_channel, work);
>> +
>> +	while (1) {
>> +		spin_lock_irq(&chan->queued_lock);
>> +		if (list_empty(&chan->capture)) {
>> +			chan->active = NULL;
>> +			spin_unlock_irq(&chan->queued_lock);
>> +			return;
>> +		}
>> +		chan->active = list_entry(chan->capture.next,
>> +				struct tegra_channel_buffer, queue);
>> +		list_del_init(&chan->active->queue);
>> +		spin_unlock_irq(&chan->queued_lock);
>> +
>> +		mutex_lock(&chan->lock);
>> +		tegra_channel_capture_frame(chan);
>> +		mutex_unlock(&chan->lock);
>> +	}
>> +}
> Should this have some mechanism to break out of the loop, for example if
> somebody requested capturing to stop?
I will move to a kthread solution as Hans pointed out.

>> +static int tegra_channel_buffer_prepare(struct vb2_buffer *vb)
>> +{
>> +	struct tegra_channel *chan = vb2_get_drv_priv(vb->vb2_queue);
>> +	struct tegra_channel_buffer *buf = to_tegra_channel_buffer(vb);
>> +
>> +	buf->chan = chan;
>> +	buf->addr = vb2_dma_contig_plane_dma_addr(vb, 0);
>> +
>> +	return 0;
>> +}
> This seems to use contiguous DMA, which I guess presumes CMA support?
> We're dealing with very large buffers here. Your default frame size
> would yield buffers of roughly 32 MiB each, and you probably need a
> couple of those to ensure smooth playback. That's quite a bit of
> memory to reserve for CMA.
In vb2 core driver, it's using dma-mapping API which might be CMA or SMMU.

For CMA we need increase the default memory size.

> Have you ever tried to make this work with the IOMMU API so that we can
> allocate arbitrary buffers and linearize them for the hardware through
> the SMMU?
I tested this code in downstream kernel with SMMU. Do we fully support 
SMMU in upstream version? I didn't check that.

>> +static void tegra_channel_buffer_queue(struct vb2_buffer *vb)
>> +{
>> +	struct tegra_channel *chan = vb2_get_drv_priv(vb->vb2_queue);
>> +	struct tegra_channel_buffer *buf = to_tegra_channel_buffer(vb);
>> +
>> +	/* Put buffer into the  capture queue */
>> +	spin_lock_irq(&chan->queued_lock);
>> +	list_add_tail(&buf->queue, &chan->capture);
>> +	spin_unlock_irq(&chan->queued_lock);
>> +
>> +	/* Start work queue to capture data to buffer */
>> +	if (vb2_start_streaming_called(&chan->queue))
>> +		schedule_work(&chan->work);
>> +}
> I'm beginning to wonder if a workqueue is the best implementation here.
> Couldn't we get notification on syncpoint increments and have a handler
> setup capture of new frames?

I will move to more flexible solution kthread then.

>> +static int tegra_channel_start_streaming(struct vb2_queue *vq, u32 count)
>> +{
>> +	struct tegra_channel *chan = vb2_get_drv_priv(vq);
>> +	struct media_pipeline *pipe = chan->video.entity.pipe;
>> +	struct tegra_channel_buffer *buf, *nbuf;
>> +	int ret = 0;
>> +
>> +	if (!chan->vi->pg_mode && !chan->remote_entity) {
>> +		dev_err(&chan->video.dev,
>> +			"is not in TPG mode and has not sensor connected!\n");
>> +		ret = -EINVAL;
>> +		goto vb2_queued;
>> +	}
>> +
>> +	mutex_lock(&chan->lock);
>> +
>> +	/* Start CIL clock */
>> +	clk_set_rate(chan->cil_clk, 102000000);
>> +	clk_prepare_enable(chan->cil_clk);
> You need to check these for errors.
Fixed
>
>> +static struct vb2_ops tegra_channel_queue_qops = {
>> +	.queue_setup = tegra_channel_queue_setup,
>> +	.buf_prepare = tegra_channel_buffer_prepare,
>> +	.buf_queue = tegra_channel_buffer_queue,
>> +	.wait_prepare = vb2_ops_wait_prepare,
>> +	.wait_finish = vb2_ops_wait_finish,
>> +	.start_streaming = tegra_channel_start_streaming,
>> +	.stop_streaming = tegra_channel_stop_streaming,
>> +};
> I think this needs to be static const.
Fixed
>
>> +static int
>> +tegra_channel_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
>> +{
>> +	struct v4l2_fh *vfh = file->private_data;
>> +	struct tegra_channel *chan = to_tegra_channel(vfh->vdev);
>> +
>> +	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
>> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
>> +
>> +	strlcpy(cap->driver, "tegra-vi", sizeof(cap->driver));
> Perhaps "tegra-video" to be consistent with the module name?
OK, fixed.


>> +	strlcpy(cap->card, chan->video.name, sizeof(cap->card));
>> +	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s:%u",
>> +		 chan->vi->dev->of_node->name, chan->port);
> Should this not rather use dev_name(chan->vi->dev) to ensure it works
> fine if ever we have multiple instances of the VI controller?
>

Fixed.

>> +static int
>> +tegra_channel_enum_format(struct file *file, void *fh, struct v4l2_fmtdesc *f)
>> +{
>> +	struct v4l2_fh *vfh = file->private_data;
>> +	struct tegra_channel *chan = to_tegra_channel(vfh->vdev);
>> +	int index, i;
> These can probably be unsigned int.
>
>> +	unsigned long *fmts_bitmap = NULL;
>> +
>> +	if (chan->vi->pg_mode)
>> +		fmts_bitmap = chan->vi->tpg_fmts_bitmap;
>> +	else if (chan->remote_entity)
>> +		fmts_bitmap = chan->fmts_bitmap;
>> +
>> +	if (!fmts_bitmap ||
>> +	    f->index > bitmap_weight(fmts_bitmap, MAX_FORMAT_NUM) - 1)
>> +		return -EINVAL;
>> +
>> +	index = -1;
> This won't work with unsigned int, of course (actually, it would, but
> it'd be ugly), but I think you could work around that by doing the more
> natural:
>
>> +	for (i = 0; i < f->index + 1; i++)
>> +		index = find_next_bit(fmts_bitmap, MAX_FORMAT_NUM, index + 1);
> 	index = 0;
>
> 	for (i = 0; i < f->index + 1; i++, index++)
> 		index = find_next_bit(fmts_bitmap, MAX_FORMAT_NUM, index);

Sure, fixed all of them

>
>> +static void
>> +__tegra_channel_try_format(struct tegra_channel *chan, struct v4l2_pix_format *pix,
>> +		      const struct tegra_video_format **fmtinfo)
>> +{
>> +	const struct tegra_video_format *info;
>> +	unsigned int min_width;
>> +	unsigned int max_width;
>> +	unsigned int min_bpl;
>> +	unsigned int max_bpl;
>> +	unsigned int width;
>> +	unsigned int align;
>> +	unsigned int bpl;
>> +
>> +	/* Retrieve format information and select the default format if the
>> +	 * requested format isn't supported.
>> +	 */
>> +	info = tegra_core_get_format_by_fourcc(pix->pixelformat);
>> +	if (!info)
>> +		info = tegra_core_get_format_by_fourcc(TEGRA_VF_DEF_FOURCC);
> Should this not be an error? As far as I can tell this is silently
> substituting the default format for the requested one if the requested
> one isn't supported. Isn't the whole point of this to find out if some
> format is supported?
>
I think it should return some error and escape following code. I will 
fix that.


>> +
>> +	pix->pixelformat = info->fourcc;
>> +	pix->field = V4L2_FIELD_NONE;
>> +
>> +	/* The transfer alignment requirements are expressed in bytes. Compute
>> +	 * the minimum and maximum values, clamp the requested width and convert
>> +	 * it back to pixels.
>> +	 */
>> +	align = lcm(chan->align, info->bpp);
>> +	min_width = roundup(TEGRA_MIN_WIDTH, align);
>> +	max_width = rounddown(TEGRA_MAX_WIDTH, align);
>> +	width = rounddown(pix->width * info->bpp, align);
> Shouldn't these be roundup()?
Why? I don't understand but rounddown looks good to me

>> +
>> +	pix->width = clamp(width, min_width, max_width) / info->bpp;
>> +	pix->height = clamp(pix->height, TEGRA_MIN_HEIGHT,
>> +			    TEGRA_MAX_HEIGHT);
> The above fits nicely on one line and doesn't need to be wrapped.
Fixed
>
>> +
>> +	/* Clamp the requested bytes per line value. If the maximum bytes per
>> +	 * line value is zero, the module doesn't support user configurable line
>> +	 * sizes. Override the requested value with the minimum in that case.
>> +	 */
>> +	min_bpl = pix->width * info->bpp;
>> +	max_bpl = rounddown(TEGRA_MAX_WIDTH, chan->align);
>> +	bpl = rounddown(pix->bytesperline, chan->align);
> Again, I think these should be roundup().

Why? I don't understand but rounddown looks good to me
>
>> +static int tegra_channel_v4l2_open(struct file *file)
>> +{
>> +	struct tegra_channel *chan = video_drvdata(file);
>> +	struct tegra_vi_device *vi = chan->vi;
>> +	int ret = 0;
>> +
>> +	mutex_lock(&vi->lock);
>> +	ret = v4l2_fh_open(file);
>> +	if (ret)
>> +		goto unlock;
>> +
>> +	/* The first open then turn on power*/
>> +	if (!vi->power_on_refcnt) {
>> +		tegra_vi_power_on(chan->vi);
> Perhaps propagate error codes here?
>
>> +
>> +		usleep_range(5, 100);
>> +		tegra_channel_write(chan, TEGRA_VI_CFG_CG_CTRL, 1);
>> +		tegra_channel_write(chan, TEGRA_CSI_CLKEN_OVERRIDE, 0);
>> +		usleep_range(10, 15);
>> +	}
>> +	vi->power_on_refcnt++;
> Also, I wonder if powering up at ->open() time isn't a little early. I
> could very well imagine an application opening up a device and then not
> use it for a long time. Or keep it open even while nothing is being
> captures. But that's primarily an optimization matter, so this is fine
> with me.
>

I think I can move this whole open/release things to start_streaming() 
point. And use v4l2 default open/release function.

>> +int tegra_channel_init(struct tegra_vi_device *vi,
>> +		       struct tegra_channel *chan,
>> +		       u32 port)
> The above fits on 2 lines, no need to make it three. Also port should
> probably be unsigned int because the size isn't important.

Fixed

>> +{
>> +	int ret;
>> +
>> +	chan->vi = vi;
>> +	chan->port = port;
>> +	chan->iomem = vi->iomem;
>> +
>> +	/* Init channel register base */
>> +	chan->regs.csi = TEGRA_VI_CSI_0_BASE + port * 0x100;
>> +	chan->regs.pp = regs_base(TEGRA_CSI_PIXEL_PARSER_0_BASE, port);
>> +	chan->regs.cil = regs_base(TEGRA_CSI_CIL_0_BASE, port);
>> +	chan->regs.phy = TEGRA_CSI_CIL_PHY_0_BASE + port / 2 * 0x800;
>> +	chan->regs.tpg = regs_base(TEGRA_CSI_PATTERN_GENERATOR_0_BASE, port);
> Like I said, I think it'd be clearer to have the defines parameterized.
> That would also make this more consistent, rather than have one set of
> values that are computed here and for others the regs_base() helper is
> invoked. Also, I think it'd be better to have the regs structures take
> void __iomem * directly, so that the offset addition doesn't have to be
> performed at every register access.

OK, I see. I will fix this.


>> +
>> +	/* Init CIL clock */
>> +	switch (chan->port) {
>> +	case 0:
>> +	case 1:
>> +		chan->cil_clk = devm_clk_get(chan->vi->dev, "cilab");
>> +		break;
>> +	case 2:
>> +	case 3:
>> +		chan->cil_clk = devm_clk_get(chan->vi->dev, "cilcd");
>> +		break;
>> +	case 4:
>> +	case 5:
>> +		chan->cil_clk = devm_clk_get(chan->vi->dev, "cile");
>> +		break;
>> +	default:
>> +		dev_err(chan->vi->dev, "wrong port nubmer %d\n", port);
> Nit: you should use %u for unsigned integers.

Fixed.

>> +	}
>> +	if (IS_ERR(chan->cil_clk)) {
>> +		dev_err(chan->vi->dev, "Failed to get CIL clock\n");
> Perhaps mention which clock couldn't be received.

Fixed

>
>> +		return -EINVAL;
> And propagate the error code rather than returning a hardcoded one.
Fixed.

>
>> +	}
>> +
>> +	/* VI Channel is 64 bytes alignment */
>> +	chan->align = 64;
> Does this need parameterization for other SoC generations?

So far it's 64 bytes and I don't see any change about this in the future 
generations.

>
>> +	chan->surface = 0;
> I can't find this being set to anything other than 0. What is its use?

Each channel actually has 3 memory output surfaces. But I don't find any 
use case to use the surface 1 and surface 2. So I just added this 
parameter for future usage.

chan->surface is used in tegra_channel_capture_frame()

>
>> +	chan->io_id = tegra_io_rail_csi_ids[chan->port];
>> +	mutex_init(&chan->lock);
>> +	mutex_init(&chan->video_lock);
>> +	INIT_LIST_HEAD(&chan->capture);
>> +	spin_lock_init(&chan->queued_lock);
>> +	INIT_WORK(&chan->work, tegra_channel_work);
>> +
>> +	/* Init video format */
>> +	chan->fmtinfo = tegra_core_get_format_by_fourcc(TEGRA_VF_DEF_FOURCC);
>> +	chan->format.pixelformat = chan->fmtinfo->fourcc;
>> +	chan->format.colorspace = V4L2_COLORSPACE_SRGB;
>> +	chan->format.field = V4L2_FIELD_NONE;
>> +	chan->format.width = TEGRA_DEF_WIDTH;
>> +	chan->format.height = TEGRA_DEF_HEIGHT;
>> +	chan->format.bytesperline = chan->format.width * chan->fmtinfo->bpp;
>> +	chan->format.sizeimage = chan->format.bytesperline *
>> +				    chan->format.height;
>> +
>> +	/* Initialize the media entity... */
>> +	chan->pad.flags = MEDIA_PAD_FL_SINK;
>> +
>> +	ret = media_entity_init(&chan->video.entity, 1, &chan->pad, 0);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	/* ... and the video node... */
>> +	chan->video.fops = &tegra_channel_fops;
>> +	chan->video.v4l2_dev = &vi->v4l2_dev;
>> +	chan->video.queue = &chan->queue;
>> +	snprintf(chan->video.name, sizeof(chan->video.name), "%s %s %u",
>> +		 vi->dev->of_node->name, "output", port);
> dev_name()?

Fixed.

>> diff --git a/drivers/media/platform/tegra/tegra-core.c b/drivers/media/platform/tegra/tegra-core.c
> [...]
>> +const struct tegra_video_format tegra_video_formats[] = {
> Does this need to be exposed? I see there are accessors for this below,
> so exposing the structure itself doesn't seem necessary.

OK, I will fix this.

>> +int tegra_core_get_formats_array_size(void)
>> +{
>> +	return ARRAY_SIZE(tegra_video_formats);
>> +}
>> +
>> +/**
>> + * tegra_core_get_word_count - Calculate word count
>> + * @frame_width: number of pixels in one frame
>> + * @fmt: Tegra Video format struct which has BPP information
>> + *
>> + * Return: word count number
>> + */
>> +u32 tegra_core_get_word_count(u32 frame_width,
>> +			      const struct tegra_video_format *fmt)
>> +{
>> +	return frame_width * fmt->width / 8;
>> +}
> This is confusing. If frame_width is the number of pixels in one frame,
> then it should probably me called frame_size or so. frame_width to me
> implies number of pixels per line, not per frame.

Actually the comment is wrong. I will fix that.


>> +/**
>> + * tegra_core_get_idx_by_code - Retrieve index for a media bus code
>> + * @code: the format media bus code
>> + *
>> + * Return: a index to the format information structure corresponding to the
>> + * given V4L2 media bus format @code, or -1 if no corresponding format can
>> + * be found.
>> + */
>> +int tegra_core_get_idx_by_code(unsigned int code)
>> +{
>> +	unsigned int i;
>> +	const struct tegra_video_format *format;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(tegra_video_formats); ++i) {
>> +		format = &tegra_video_formats[i];
>> +
>> +		if (format->code == code)
> You only use the format value once, so the temporary variable doesn't
> buy you anything.
>
OK, I will remove 'format'.


>> +			return i;
>> +	}
>> +
>> +	return -1;
>> +}
>> +
>> +
> Gratuitous blank line.

Fixed.

>
>> +/**
>> + * tegra_core_of_get_format - Parse a device tree node and return format
>> + * 			      information
> Why is this necessary? Why would you ever need to encode a pixel format
> in DT?

This is dead code. I will remove them.

>> +/**
>> + * tegra_core_bytes_per_line - Calculate bytes per line in one frame
>> + * @width: frame width
>> + * @fmt: Tegra Video format
>> + *
>> + * Simply calcualte the bytes_per_line and if it's not 64 bytes aligned it
>> + * will be padded to 64 boundary.
>> + */
>> +u32 tegra_core_bytes_per_line(u32 width,
>> +			      const struct tegra_video_format *fmt)
>> +{
>> +	u32 bytes_per_line = width * fmt->bpp;
>> +
>> +	if (bytes_per_line % 64)
>> +		bytes_per_line = bytes_per_line +
>> +				 (64 - (bytes_per_line % 64));
>> +
>> +	return bytes_per_line;
>> +}
> Perhaps this should use the channel->align field for alignment rather
> than hardcode 64? Since there's no channel being passed into this, maybe
> passing the alignment as a parameter would work?
>
> Also can't the above be replaced by:
>
> 	return roundup(width * fmt->bpp, align);
>
> ?

Great, I will fix that.

>
>> diff --git a/drivers/media/platform/tegra/tegra-core.h b/drivers/media/platform/tegra/tegra-core.h
>> new file mode 100644
>> index 0000000..7d1026b
>> --- /dev/null
>> +++ b/drivers/media/platform/tegra/tegra-core.h
>> @@ -0,0 +1,134 @@
>> +/*
>> + * NVIDIA Tegra Video Input Device Driver Core Helpers
>> + *
>> + * Copyright (c) 2015, NVIDIA CORPORATION.  All rights reserved.
>> + *
>> + * Author: Bryan Wu <pengw@nvidia.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#ifndef __TEGRA_CORE_H__
>> +#define __TEGRA_CORE_H__
>> +
>> +#include <dt-bindings/media/tegra-vi.h>
>> +
>> +#include <media/v4l2-subdev.h>
>> +
>> +/* Minimum and maximum width and height common to Tegra video input device. */
>> +#define TEGRA_MIN_WIDTH		32U
>> +#define TEGRA_MAX_WIDTH		7680U
>> +#define TEGRA_MIN_HEIGHT	32U
>> +#define TEGRA_MAX_HEIGHT	7680U
> Is this dependent on SoC generation? If we wanted to support Tegra K1,
> would the same values apply or do they need to be parameterized?
I actually don't get any information about this max/min resolution. Here 
I just put some values for the format calculation.

> On that note, could you outline what would be necessary to make this
> work on Tegra K1? What are the differences between the VI hardware on
> Tegra X1 vs. Tegra K1?
>
Tegra X1 and Tegra K1 have similar channel architecture. Tegra X1 has 6 
channels, Tegra K1 has 2 channels.


>> +
>> +/* UHD 4K resolution as default resolution for all Tegra video input device. */
>> +#define TEGRA_DEF_WIDTH		3840
>> +#define TEGRA_DEF_HEIGHT	2160
> Is this a sensible default? It seems rather large to me.
Actually I use this for TPG which is the default setting of VI. And it 
can be override from user space IOCTL.

>> +
>> +#define TEGRA_VF_DEF		TEGRA_VF_RGB888
>> +#define TEGRA_VF_DEF_FOURCC	V4L2_PIX_FMT_RGB32
> Should we not have only one of these and convert to the other via some
> table?

This is also TPG default mode

>> +/* These go into the TEGRA_VI_CSI_n_IMAGE_DEF registers bits 23:16 */
>> +#define TEGRA_IMAGE_FORMAT_T_L8                         16
>> +#define TEGRA_IMAGE_FORMAT_T_R16_I                      32
>> +#define TEGRA_IMAGE_FORMAT_T_B5G6R5                     33
>> +#define TEGRA_IMAGE_FORMAT_T_R5G6B5                     34
>> +#define TEGRA_IMAGE_FORMAT_T_A1B5G5R5                   35
>> +#define TEGRA_IMAGE_FORMAT_T_A1R5G5B5                   36
>> +#define TEGRA_IMAGE_FORMAT_T_B5G5R5A1                   37
>> +#define TEGRA_IMAGE_FORMAT_T_R5G5B5A1                   38
>> +#define TEGRA_IMAGE_FORMAT_T_A4B4G4R4                   39
>> +#define TEGRA_IMAGE_FORMAT_T_A4R4G4B4                   40
>> +#define TEGRA_IMAGE_FORMAT_T_B4G4R4A4                   41
>> +#define TEGRA_IMAGE_FORMAT_T_R4G4B4A4                   42
>> +#define TEGRA_IMAGE_FORMAT_T_A8B8G8R8                   64
>> +#define TEGRA_IMAGE_FORMAT_T_A8R8G8B8                   65
>> +#define TEGRA_IMAGE_FORMAT_T_B8G8R8A8                   66
>> +#define TEGRA_IMAGE_FORMAT_T_R8G8B8A8                   67
>> +#define TEGRA_IMAGE_FORMAT_T_A2B10G10R10                68
>> +#define TEGRA_IMAGE_FORMAT_T_A2R10G10B10                69
>> +#define TEGRA_IMAGE_FORMAT_T_B10G10R10A2                70
>> +#define TEGRA_IMAGE_FORMAT_T_R10G10B10A2                71
>> +#define TEGRA_IMAGE_FORMAT_T_A8Y8U8V8                   193
>> +#define TEGRA_IMAGE_FORMAT_T_V8U8Y8A8                   194
>> +#define TEGRA_IMAGE_FORMAT_T_A2Y10U10V10                197
>> +#define TEGRA_IMAGE_FORMAT_T_V10U10Y10A2                198
>> +#define TEGRA_IMAGE_FORMAT_T_Y8_U8__Y8_V8               200
>> +#define TEGRA_IMAGE_FORMAT_T_Y8_V8__Y8_U8               201
>> +#define TEGRA_IMAGE_FORMAT_T_U8_Y8__V8_Y8               202
>> +#define TEGRA_IMAGE_FORMAT_T_T_V8_Y8__U8_Y8             203
>> +#define TEGRA_IMAGE_FORMAT_T_T_Y8__U8__V8_N444          224
>> +#define TEGRA_IMAGE_FORMAT_T_Y8__U8V8_N444              225
>> +#define TEGRA_IMAGE_FORMAT_T_Y8__V8U8_N444              226
>> +#define TEGRA_IMAGE_FORMAT_T_Y8__U8__V8_N422            227
>> +#define TEGRA_IMAGE_FORMAT_T_Y8__U8V8_N422              228
>> +#define TEGRA_IMAGE_FORMAT_T_Y8__V8U8_N422              229
>> +#define TEGRA_IMAGE_FORMAT_T_Y8__U8__V8_N420            230
>> +#define TEGRA_IMAGE_FORMAT_T_Y8__U8V8_N420              231
>> +#define TEGRA_IMAGE_FORMAT_T_Y8__V8U8_N420              232
>> +#define TEGRA_IMAGE_FORMAT_T_X2Lc10Lb10La10             233
>> +#define TEGRA_IMAGE_FORMAT_T_A2R6R6R6R6R6               234
>> +
>> +/* These go into the TEGRA_VI_CSI_n_CSI_IMAGE_DT registers bits 7:0 */
>> +#define TEGRA_IMAGE_DT_YUV420_8                         24
>> +#define TEGRA_IMAGE_DT_YUV420_10                        25
>> +#define TEGRA_IMAGE_DT_YUV420CSPS_8                     28
>> +#define TEGRA_IMAGE_DT_YUV420CSPS_10                    29
>> +#define TEGRA_IMAGE_DT_YUV422_8                         30
>> +#define TEGRA_IMAGE_DT_YUV422_10                        31
>> +#define TEGRA_IMAGE_DT_RGB444                           32
>> +#define TEGRA_IMAGE_DT_RGB555                           33
>> +#define TEGRA_IMAGE_DT_RGB565                           34
>> +#define TEGRA_IMAGE_DT_RGB666                           35
>> +#define TEGRA_IMAGE_DT_RGB888                           36
>> +#define TEGRA_IMAGE_DT_RAW6                             40
>> +#define TEGRA_IMAGE_DT_RAW7                             41
>> +#define TEGRA_IMAGE_DT_RAW8                             42
>> +#define TEGRA_IMAGE_DT_RAW10                            43
>> +#define TEGRA_IMAGE_DT_RAW12                            44
>> +#define TEGRA_IMAGE_DT_RAW14                            45
> It might be helpful to describe what these registers actually do. There
> seems to be overlap between both lists, but I don't quite see how they
> relate to one another, or what their purpose is.
These tables are from our TRM. The first table is "Pixel memory format 
for the VI channel". The second one is "VI channel input data type".

Let me put some comments there.


>> +/**
>> + * struct tegra_video_format - Tegra video format description
>> + * @vf_code: video format code
>> + * @width: format width in bits per component
>> + * @code: media bus format code
>> + * @bpp: bytes per pixel (when stored in memory)
>> + * @img_fmt: image format
>> + * @img_dt: image data type
>> + * @fourcc: V4L2 pixel format FCC identifier
>> + * @description: format description, suitable for userspace
>> + */
>> +struct tegra_video_format {
>> +	u32 vf_code;
>> +	u32 width;
>> +	u32 code;
>> +	u32 bpp;
> I think the above four can all be unsigned int. A sized type is not
> necessary here.
OK, I will fix this.


>> +	u32 img_fmt;
>> +	u32 img_dt;
> Perhaps these could be enums?

OK, I will use enums.
>
>> +	u32 fourcc;
>> +};
>> +
>> +extern const struct tegra_video_format tegra_video_formats[];
> It looks like you have accessors for this. Do you even need to expose
> it?

Fixed.

>> diff --git a/drivers/media/platform/tegra/tegra-vi.c b/drivers/media/platform/tegra/tegra-vi.c
> [...]
>> +static void tegra_vi_v4l2_cleanup(struct tegra_vi_device *vi)
>> +{
>> +	v4l2_ctrl_handler_free(&vi->ctrl_handler);
>> +	v4l2_device_unregister(&vi->v4l2_dev);
>> +	media_device_unregister(&vi->media_dev);
>> +}
>> +
>> +static int tegra_vi_v4l2_init(struct tegra_vi_device *vi)
>> +{
>> +	int ret;
>> +
>> +	vi->media_dev.dev = vi->dev;
>> +	strlcpy(vi->media_dev.model, "NVIDIA Tegra Video Input Device",
>> +		sizeof(vi->media_dev.model));
>> +	vi->media_dev.hw_revision = 0;
> Actually, I think for Tegra X1 the hardware revision would be 3, since
> VI3 is what it's usually referred to. Tegra K1 has VI2, so this should
> be parameterized (at least when Tegra K1 support is added).
OK, I will choose 3 for Tegra X1 since we mentioned that in TRM like VI3.

>> +int tegra_vi_power_on(struct tegra_vi_device *vi)
>> +{
>> +	int ret;
>> +
>> +	ret = regulator_enable(vi->vi_reg);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret = tegra_powergate_sequence_power_up(TEGRA_POWERGATE_VENC,
>> +						vi->vi_clk, vi->vi_rst);
>> +	if (ret) {
>> +		regulator_disable(vi->vi_reg);
>> +		return ret;
>> +	}
>> +
>> +	clk_prepare_enable(vi->csi_clk);
>> +
>> +	clk_set_rate(vi->parent_clk, 408000000);
> Do we really need to set the parent? Isn't that going to be set
> automatically since vi_clk is the child of parent_clk?
Sure, I will remove this.


>> +	clk_set_rate(vi->vi_clk, 408000000);
>> +	clk_set_rate(vi->csi_clk, 408000000);
> Also all of these clock functions can fail, so you should check for
> errors.
>

Fixed.

>> +
>> +	return 0;
>> +}
>> +
>> +void tegra_vi_power_off(struct tegra_vi_device *vi)
>> +{
>> +	clk_disable_unprepare(vi->csi_clk);
>> +	tegra_powergate_power_off(TEGRA_POWERGATE_VENC);
> tegra_powergate_power_off() doesn't do anything with the clock or the
> reset, so you'll want to manually assert reset here and then disable and
> unprepare the clock. And I think both need to happen before the power
> partition is turned off.

Got it, I will fix this.


>> +	regulator_disable(vi->vi_reg);
>> +}
>> +
>> +static int tegra_vi_channels_init(struct tegra_vi_device *vi)
>> +{
>> +	int i, ret;
> i can be unsigned.

Fixed
>
>> +	struct tegra_channel *chan;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(vi->chans); i++) {
>> +		chan = &vi->chans[i];
>> +
>> +		ret = tegra_channel_init(vi, chan, i);
> Again, chan is only used once, so directly passing &vi->chans[i] to
> tegra_channel_init() would be more concise.
OK, I will remove 'chan' parameter from the list. And just pass i as the 
port number.

>
>> +static int tegra_vi_channels_cleanup(struct tegra_vi_device *vi)
>> +{
>> +	int i, ret;
>> +	struct tegra_channel *chan;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(vi->chans); i++) {
>> +		chan = &vi->chans[i];
>> +
>> +		ret = tegra_channel_cleanup(chan);
>> +		if (ret < 0) {
>> +			dev_err(vi->dev, "channel %d cleanup failed\n", i);
>> +			return ret;
>> +		}
>> +	}
>> +	return 0;
>> +}
> Same comments as for tegra_vi_channels_init().

Fixed.

>> +
>> +/* -----------------------------------------------------------------------------
>> + * Graph Management
>> + */
> The way devices are hooked up using the graph needs to be documented in
> a device tree binding.

Sure. This is actually the default video-interface binding. I will 
provide a document about device tree binding.

>> +static int tegra_vi_graph_notify_complete(struct v4l2_async_notifier *notifier)
>> +{
>> +	struct tegra_vi_device *vi =
>> +		container_of(notifier, struct tegra_vi_device, notifier);
>> +	int ret;
>> +
>> +	dev_dbg(vi->dev, "notify complete, all subdevs registered\n");
>> +
>> +	/* Create links for every entity. */
>> +	ret = tegra_vi_graph_build_links(vi);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	ret = v4l2_device_register_subdev_nodes(&vi->v4l2_dev);
>> +	if (ret < 0)
>> +		dev_err(vi->dev, "failed to register subdev nodes\n");
>> +
>> +	return ret;
>> +}
> Why the need for this notifier mechanism, doesn't deferred probe work
> here?

I will revisit this after media controller and graph probing change in 
upstream mentioned by Hans.

>> +static int tegra_vi_graph_notify_bound(struct v4l2_async_notifier *notifier,
>> +				   struct v4l2_subdev *subdev,
>> +				   struct v4l2_async_subdev *asd)
>> +{
> [...]
>> +}
>> +
>> +
> Gratuitous blank line.
Fixed.

>
>> +static int tegra_vi_graph_init(struct tegra_vi_device *vi)
>> +{
>> +	struct device_node *node = vi->dev->of_node;
>> +	struct device_node *ep = NULL;
>> +	struct device_node *next;
>> +	struct device_node *remote = NULL;
>> +	struct tegra_vi_graph_entity *entity;
>> +	struct v4l2_async_subdev **subdevs = NULL;
>> +	unsigned int num_subdevs;
> This variable is being used uninitialized.
>

Fixed.

>> +static int tegra_vi_probe(struct platform_device *pdev)
>> +{
>> +	struct resource *res;
>> +	struct tegra_vi_device *vi;
>> +	int ret = 0;
>> +
>> +	vi = devm_kzalloc(&pdev->dev, sizeof(*vi), GFP_KERNEL);
>> +	if (!vi)
>> +		return -ENOMEM;
>> +
>> +	vi->dev = &pdev->dev;
>> +	INIT_LIST_HEAD(&vi->entities);
>> +	mutex_init(&vi->lock);
>> +
>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	vi->iomem = devm_ioremap_resource(&pdev->dev, res);
>> +	if (IS_ERR(vi->iomem))
>> +		return PTR_ERR(vi->iomem);
>> +
>> +	vi->vi_rst = devm_reset_control_get(&pdev->dev, "vi");
>> +	if (IS_ERR(vi->vi_rst)) {
>> +		dev_err(&pdev->dev, "Failed to get vi reset\n");
>> +		return -EPROBE_DEFER;
>> +	}
> There could be other reasons for failure, so you should really propagate
> the error code that devm_reset_control_get() provides:
>
> 		return PTR_ERR(vi->vi_rst);
OK, I will fix this.

>
>> +	vi->vi_clk = devm_clk_get(&pdev->dev, "vi");
>> +	if (IS_ERR(vi->vi_clk)) {
>> +		dev_err(&pdev->dev, "Failed to get vi clock\n");
>> +		return -EPROBE_DEFER;
>> +	}
> Same here...
OK, I will fix this.
>
>> +	vi->parent_clk = devm_clk_get(&pdev->dev, "parent");
>> +	if (IS_ERR(vi->parent_clk)) {
>> +		dev_err(&pdev->dev, "Failed to get VI parent clock\n");
>> +		return -EPROBE_DEFER;
>> +	}
> ... here...
Fixed
>
>> +	ret = clk_set_parent(vi->vi_clk, vi->parent_clk);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	vi->csi_clk = devm_clk_get(&pdev->dev, "csi");
>> +	if (IS_ERR(vi->csi_clk)) {
>> +		dev_err(&pdev->dev, "Failed to get csi clock\n");
>> +		return -EPROBE_DEFER;
>> +	}
> ... here...
Fixed
>
>> +	vi->vi_reg = devm_regulator_get(&pdev->dev, "avdd-dsi-csi");
>> +	if (IS_ERR(vi->vi_reg)) {
>> +		dev_err(&pdev->dev, "Failed to get avdd-dsi-csi regulators\n");
>> +		return -EPROBE_DEFER;
>> +	}
> and here.
>
>> +	vi_tpg_fmts_bitmap_init(vi);
>> +
>> +	ret = tegra_vi_v4l2_init(vi);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	/* Check whether VI is in test pattern generator (TPG) mode */
>> +	of_property_read_u32(vi->dev->of_node, "nvidia,pg_mode",
>> +			     &vi->pg_mode);
> This doesn't sound right. Wouldn't this mean that you can either use the
> device in TPG mode or sensor mode only? With no means of switching at
> runtime? But then I see that there's an IOCTL to set this mode, so why
> even bother having this in DT in the first place?
DT can provide a default way to set the whole VI as TPG. And v4l2-ctrls 
(IOCTL) is another way to do that.

We can remove this DT stuff but just use runtime v4l2-ctrls.
>> +	/* Init Tegra VI channels */
>> +	ret = tegra_vi_channels_init(vi);
>> +	if (ret < 0)
>> +		goto channels_error;
>> +
>> +	/* Setup media links between VI and external sensor subdev. */
>> +	ret = tegra_vi_graph_init(vi);
>> +	if (ret < 0)
>> +		goto graph_error;
>> +
>> +	platform_set_drvdata(pdev, vi);
>> +
>> +	dev_info(vi->dev, "device registered\n");
> Can we get rid of this, please? There's no use in spamming the kernel
> log with brag. Let people know when things have failed. Success is the
> expected outcome of ->probe().
Removed.

>> +static struct platform_driver tegra_vi_driver = {
>> +	.driver = {
>> +		.name = "tegra-vi",
>> +		.of_match_table = tegra_vi_of_id_table,
>> +	},
>> +	.probe = tegra_vi_probe,
>> +	.remove = tegra_vi_remove,
>> +};
>> +
>> +module_platform_driver(tegra_vi_driver);
> There's usually no blank line between the above.
OK, fixed.

>> diff --git a/drivers/media/platform/tegra/tegra-vi.h b/drivers/media/platform/tegra/tegra-vi.h
>> new file mode 100644
>> index 0000000..d30a6ec
>> --- /dev/null
>> +++ b/drivers/media/platform/tegra/tegra-vi.h
>> @@ -0,0 +1,224 @@
>> +/*
>> + * NVIDIA Tegra Video Input Device
>> + *
>> + * Copyright (c) 2015, NVIDIA CORPORATION.  All rights reserved.
>> + *
>> + * Author: Bryan Wu <pengw@nvidia.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#ifndef __TEGRA_VI_H__
>> +#define __TEGRA_VI_H__
>> +
>> +#include <linux/host1x.h>
>> +#include <linux/list.h>
>> +#include <linux/mutex.h>
>> +#include <linux/spinlock.h>
>> +#include <linux/videodev2.h>
>> +
>> +#include <media/media-device.h>
>> +#include <media/media-entity.h>
>> +#include <media/v4l2-async.h>
>> +#include <media/v4l2-ctrls.h>
>> +#include <media/v4l2-device.h>
>> +#include <media/v4l2-dev.h>
>> +#include <media/videobuf2-core.h>
>> +
>> +#include "tegra-core.h"
>> +
>> +#define MAX_CHAN_NUM	6
>> +#define MAX_FORMAT_NUM	64
> Perhaps these need to be runtime parameters to support multiple SoC
> generations? Tegra K1 seems to have only 2 channels instead of 6.
>
>> +
>> +/**
>> + * struct tegra_channel_buffer - video channel buffer
>> + * @buf: vb2 buffer base object
>> + * @queue: buffer list entry in the channel queued buffers list
>> + * @chan: channel that uses the buffer
>> + * @addr: Tegra IOVA buffer address for VI output
>> + */
>> +struct tegra_channel_buffer {
>> +	struct vb2_buffer buf;
>> +	struct list_head queue;
>> +	struct tegra_channel *chan;
>> +
>> +	dma_addr_t addr;
>> +};
>> +
>> +#define to_tegra_channel_buffer(vb) \
>> +	container_of(vb, struct tegra_channel_buffer, buf)
> I usually prefer static inline functions over macros for this type of
> upcasting. But perhaps Hans prefers this, so I'll defer to his judgement
> here.
>
>> +struct chan_regs_config {
>> +	u32 csi;
>> +	u32 pp;
>> +	u32 cil;
>> +	u32 phy;
>> +	u32 tpg;
>> +};
> Have you considered making these void __iomem * so that you can avoid
> the addition of the offset whenever you access a register?
>
>> +/**
>> + * struct tegra_channel - Tegra video channel
>> + * @list: list entry in a composite device dmas list
>> + * @video: V4L2 video device associated with the video channel
>> + * @video_lock:
>> + * @pad: media pad for the video device entity
>> + * @pipe: pipeline belonging to the channel
>> + *
>> + * @vi: composite device DT node port number for the channel
>> + *
>> + * @client: host1x client struct of Tegra DRM
> host1x client is separate from Tegra DRM.
Fixed.
>> + * @sp: host1x syncpoint pointer
>> + *
>> + * @work: kernel workqueue structure of this video channel
>> + * @lock: protects the @format, @fmtinfo, @queue and @work fields
>> + *
>> + * @format: active V4L2 pixel format
>> + * @fmtinfo: format information corresponding to the active @format
>> + *
>> + * @queue: vb2 buffers queue
>> + * @alloc_ctx: allocation context for the vb2 @queue
>> + * @sequence: V4L2 buffers sequence number
>> + *
>> + * @capture: list of queued buffers for capture
>> + * @active: active buffer for capture
>> + * @queued_lock: protects the buf_queued list
>> + *
>> + * @iomem: root register base
>> + * @regs: CSI/CIL/PHY register bases
>> + * @cil_clk: clock for CIL
>> + * @align: channel buffer alignment, default is 64
>> + * @port: CSI port of this video channel
>> + * @surface: output memory surface number
>> + * @io_id: Tegra IO rail ID of this video channel
>> + * @bypass: a flag to bypass register write
>> + *
>> + * @fmts_bitmap: a bitmap for formats supported
>> + *
>> + * @remote_entity: remote media entity for external sensor
>> + */
>> +struct tegra_channel {
>> +	struct list_head list;
>> +	struct video_device video;
>> +	struct mutex video_lock;
>> +	struct media_pad pad;
>> +	struct media_pipeline pipe;
>> +
>> +	struct tegra_vi_device *vi;
>> +
>> +	struct host1x_client client;
>> +	struct host1x_syncpt *sp;
>> +
>> +	struct work_struct work;
>> +	struct mutex lock;
>> +
>> +	struct v4l2_pix_format format;
>> +	const struct tegra_video_format *fmtinfo;
>> +
>> +	struct vb2_queue queue;
>> +	void *alloc_ctx;
>> +	u32 sequence;
>> +
>> +	struct list_head capture;
>> +	struct tegra_channel_buffer *active;
>> +	spinlock_t queued_lock;
>> +
>> +	void __iomem *iomem;
>> +	struct chan_regs_config regs;
>> +	struct clk *cil_clk;
>> +	int align;
>> +	u32 port;
> Those can both be unsigned int.
Fixed.
>
>> +	u32 surface;
> This seems to be fixed to 0, do we need it?

Let's keep it for future usage.

>
>> +	int io_id;
>> +	int bypass;
> bool?

Fixed.
>
>> +/**
>> + * struct tegra_vi_device - NVIDIA Tegra Video Input device structure
>> + * @v4l2_dev: V4L2 device
>> + * @media_dev: media device
>> + * @dev: device struct
>> + *
>> + * @iomem: register base
>> + * @vi_clk: main clock for VI block
>> + * @parent_clk: parent clock of VI clock
>> + * @csi_clk: clock for CSI
>> + * @vi_rst: reset controler
>> + * @vi_reg: regulator for VI hardware, normally it avdd_dsi_csi
>> + *
>> + * @lock: mutex lock to protect power on/off operations
>> + * @power_on_refcnt: reference count for power on/off operations
>> + *
>> + * @notifier: V4L2 asynchronous subdevs notifier
>> + * @entities: entities in the graph as a list of tegra_vi_graph_entity
>> + * @num_subdevs: number of subdevs in the pipeline
>> + *
>> + * @channels: list of channels at the pipeline output and input
>> + *
>> + * @ctrl_handler: V4L2 control handler
>> + * @pattern: test pattern generator V4L2 control
>> + * @pg_mode: test pattern generator mode (disabled/direct/patch)
>> + * @tpg_fmts_bitmap: a bitmap for formats in test pattern generator mode
>> + */
>> +struct tegra_vi_device {
>> +	struct v4l2_device v4l2_dev;
>> +	struct media_device media_dev;
>> +	struct device *dev;
>> +
>> +	void __iomem *iomem;
>> +	struct clk *vi_clk;
>> +	struct clk *parent_clk;
>> +	struct clk *csi_clk;
>> +	struct reset_control *vi_rst;
>> +	struct regulator *vi_reg;
>> +
>> +	struct mutex lock;
>> +	int power_on_refcnt;
> unsigned int, or perhaps even atomic_t, in which case you might be able
> to remove the locks from ->open()/->release().
I will rework the open/release()

>> +
>> +	struct v4l2_async_notifier notifier;
>> +	struct list_head entities;
>> +	unsigned int num_subdevs;
>> +
>> +	struct tegra_channel chans[MAX_CHAN_NUM];
>> +
>> +	struct v4l2_ctrl_handler ctrl_handler;
>> +	struct v4l2_ctrl *pattern;
>> +	int pg_mode;
> Perhaps this should be an enum?
Sure, fixed.

>> diff --git a/include/dt-bindings/media/tegra-vi.h b/include/dt-bindings/media/tegra-vi.h
> [...]
>> +#ifndef __DT_BINDINGS_MEDIA_TEGRA_VI_H__
>> +#define __DT_BINDINGS_MEDIA_TEGRA_VI_H__
>> +
>> +/*
>> + * Supported CSI to VI Data Formats
>> + */
>> +#define TEGRA_VF_RAW6		0
>> +#define TEGRA_VF_RAW7		1
>> +#define TEGRA_VF_RAW8		2
>> +#define TEGRA_VF_RAW10		3
>> +#define TEGRA_VF_RAW12		4
>> +#define TEGRA_VF_RAW14		5
>> +#define TEGRA_VF_EMBEDDED8	6
>> +#define TEGRA_VF_RGB565		7
>> +#define TEGRA_VF_RGB555		8
>> +#define TEGRA_VF_RGB888		9
>> +#define TEGRA_VF_RGB444		10
>> +#define TEGRA_VF_RGB666		11
>> +#define TEGRA_VF_YUV422		12
>> +#define TEGRA_VF_YUV420		13
>> +#define TEGRA_VF_YUV420_CSPS	14
>> +
>> +#endif /* __DT_BINDINGS_MEDIA_TEGRA_VI_H__ */
> What do we need these for? These seem to me to be internal formats
> supported by the hardware, but the existence of this file implies that
> you plan on using them in the DT. What's the use-case?
>
>

The original plan is to put nvidia;video-format in device tree and this 
is the data formats for that. Now we don't need nvidia;video-format in 
device tree. Then I let me move it into our tegra-core.c, because our 
tegra_video_formats table needs this.

Thierry,

Thanks a lot for this beautiful review. I almost fixed them and will 
provide a new patch soon.

-Bryan

