Return-path: <linux-media-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60360
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751210Ab2IMXUS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 19:20:18 -0400
Date: Thu, 13 Sep 2012 20:19:58 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Steven Toth <stoth@kernellabs.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux-Media <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL] ViewCast O820E capture support added
Message-ID: <20120913201958.266fee52@infradead.org>
In-Reply-To: <CALzAhNXZx1+048S_rVsWH3fMg8sJnawo3o+bS6ygD5KRpjYZ3g@mail.gmail.com>
References: <CALzAhNVEXexQELbbXzpzxeiUat-oXqhxQ1kiA7K1ibXTm8X+YQ@mail.gmail.com>
	<201208161649.43284.hverkuil@xs4all.nl>
	<CALzAhNWT3eNUNwNsGG_w+Jbz=ErRxogvv+_3GcKy8xZ+R-uZ=A@mail.gmail.com>
	<201208162049.35773.hverkuil@xs4all.nl>
	<CALzAhNXZx1+048S_rVsWH3fMg8sJnawo3o+bS6ygD5KRpjYZ3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 18 Aug 2012 11:48:52 -0400
Steven Toth <stoth@kernellabs.com> escreveu:

> Mauro, please read below, a new set of patches I'm submitting for merge.
> 
> On Thu, Aug 16, 2012 at 2:49 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > On Thu August 16 2012 19:39:51 Steven Toth wrote:
> >> >> So, I've ran v4l2-compliance and it pointed out a few things that I've
> >> >> fixed, but it also does a few things that (for some reason) I can't
> >> >> seem to catch. One particular test is on (iirc) s_fmt. It attempts to
> >> >> set ATSC but by ioctl callback never receives ATSC in the norm/id arg,
> >> >> it actually receives 0x0. This feels more like a bug in the test.
> >> >> Either way, I have some if (std & ATSC) return -EINVAL, but it still
> >> >> appears to fail the test.
> >>
> >> Oddly enough. If I set tvnorms to something valid, then compliance
> >> passes but gstreamer
> >> fails to run, looks like some kind of confusion about either the
> >> current established
> >> norm, or a failure to establish a norm.
> >>
> >> For the time being I've set tvnorms to 0 (with a comment) and removed
> >> current_norm.
> >
> > Well, this needs to be sorted, because something is clearly amiss.
> 
> Agreed. I just can't see what's wrong. I may need your advise /
> eyeballs on this. I'd be willing to provide logs that show gstreamer
> accessing the driver and exiting. It needs fixed, I've tried, I just
> can't see why gstreamer fails.
> 
> On the main topic of merge.... As promised, I spent quite a bit of
> time this week reworking the code based on the feedback. I also
> flattened all of these patches into a single patchset and upgraded to
> the latest re-org tree.
> 
> The source notes describe in a little more detail the major changes:
> http://git.kernellabs.com/?p=stoth/media_tree.git;a=commit;h=f295dd63e2f7027e327daad730eb86f2c17e3b2c
> 
> Mauro, so, I hereby submit for your review/merge again, the updated
> patchset. *** Please comment. ***

I'll comment patch by patch. Let's hope the ML will get this email. Not sure,
as it tends to discard big emails like that.

This is the comment of patch 1/4.


> From 6e5182ab70c5bc561304db7206f5235d826bb0dd Mon Sep 17 00:00:00 2001
> From: Steven Toth <stoth@kernellabs.com>
> Date: Sat, 18 Aug 2012 10:45:32 -0400
> Subject: [media] adv7441a: Adding limited support for a new video decoder.
> Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
> 
> The Analog Devices ADV7441a.
> 
> The driver has been written and tested against the ViewCast O820E
> PCIe capture card (patches to follow).
> 
> The driver has it's auto-detection currently disabled, as part
> of the migration from a standalone driver to a subdev. This
> functionality will be restored in the comming days.
> 
> Signed-off-by: Steven Toth <stoth@kernellabs.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/media/i2c/Kconfig       |    9 +
>  drivers/media/i2c/Makefile      |    1 +
>  drivers/media/i2c/adv7441a.c    | 4257 +++++++++++++++++++++++++++++++++++++++
>  include/media/adv7441a.h        |   88 +
>  include/media/v4l2-chip-ident.h |    3 +
>  5 files changed, 4358 insertions(+)
>  create mode 100644 drivers/media/i2c/adv7441a.c
>  create mode 100644 include/media/adv7441a.h
> 
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index 7fe4acf..0de229d 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig

(note, I ran the rename_patch.pl script, found at the media_build tree,
 for it to allow applying the patches after the big patch rename)

> @@ -388,6 +388,15 @@ config VIDEO_ADV7393
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called adv7393.
>  
> +config VIDEO_ADV7441A
> +	tristate "ADV7441A video encoder"
> +	depends on I2C
> +	help
> +	  Support for Analog Devices I2C bus based ADV7441A encoder.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called adv7441a.
> +
>  config VIDEO_AK881X
>  	tristate "AK8813/AK8814 video encoders"
>  	depends on I2C
> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
> index 088a460..9adc5f2 100644
> --- a/drivers/media/i2c/Makefile
> +++ b/drivers/media/i2c/Makefile
> @@ -25,6 +25,7 @@ obj-$(CONFIG_VIDEO_ADV7180) += adv7180.o
>  obj-$(CONFIG_VIDEO_ADV7183) += adv7183.o
>  obj-$(CONFIG_VIDEO_ADV7343) += adv7343.o
>  obj-$(CONFIG_VIDEO_ADV7393) += adv7393.o
> +obj-$(CONFIG_VIDEO_ADV7441A) += adv7441a.o
>  obj-$(CONFIG_VIDEO_VPX3220) += vpx3220.o
>  obj-$(CONFIG_VIDEO_VS6624)  += vs6624.o
>  obj-$(CONFIG_VIDEO_BT819) += bt819.o
> diff --git a/drivers/media/i2c/adv7441a.c b/drivers/media/i2c/adv7441a.c
> new file mode 100644
> index 0000000..d9aa5de
> --- /dev/null
> +++ b/drivers/media/i2c/adv7441a.c
> @@ -0,0 +1,4257 @@
> +/*
> + *  Driver for the Analog Devices ADV7441A Video Decoder.
> + *
> + *  Copyright 2011/2012, Kernel Labs Inc. www.kernellabs.com.
> + *   - Steven Toth <stoth@kernellabs.com>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; if not, write to the Free Software
> + *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/ctype.h>
> +#include <linux/slab.h>
> +#include <linux/i2c.h>
> +#include <linux/device.h>
> +#include <linux/delay.h>
> +#include <linux/module.h>
> +#include <linux/videodev2.h>
> +#include <linux/uaccess.h>
> +
> +#include <media/adv7441a.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-chip-ident.h>
> +#include <media/v4l2-ctrls.h>
> +
> +MODULE_DESCRIPTION("ADV7393 video encoder driver");
> +MODULE_LICENSE("GPL");
> +
> +static unsigned int debug;
> +module_param_named(debug, debug, int, 0644);
> +MODULE_PARM_DESC(debug, "enable debug messages [adv7441a]");
> +
> +#define dprintk(level, fmt, arg...)\
> +	do { \
> +		if (debug >= level)\
> +			pr_err(" " fmt, ## arg);\
> +	} while (0)
> +
> +static u8 edid_data[256] = {
> +	0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00,
> +	0x06, 0x96, 0x00, 0x08, 0x01, 0x00, 0x00, 0x00,
> +	0x0F, 0x14, 0x01, 0x04, 0x80, 0x31, 0x1C, 0xA0,
> +	0x2A, 0xAA, 0x33, 0xA4, 0x55, 0x48, 0x93, 0x25,
> +	0x10, 0x45, 0x47, 0x2F, 0xCF, 0x00, 0x31, 0x59,
> +	0x45, 0x59, 0x61, 0x59, 0x81, 0x80, 0xA9, 0x40,
> +	0xD1, 0x00, 0xB3, 0x00, 0x95, 0x00, 0x02, 0x3A,
> +	0x80, 0x18, 0x71, 0x38, 0x2D, 0x40, 0x58, 0x2C,
> +	0x45, 0x00, 0xE8, 0x12, 0x11, 0x00, 0x00, 0x1E,
> +	0x00, 0x00, 0x00, 0xFD, 0x00, 0x17, 0x56, 0x0F,
> +	0x6F, 0x11, 0x04, 0x10, 0x00, 0x00, 0xF0, 0x38,
> +	0x00, 0x01, 0x00, 0x00, 0x00, 0xFC, 0x00, 0x4F,
> +	0x73, 0x70, 0x72, 0x65, 0x79, 0x38, 0x30, 0x30,
> +	0x20, 0x31, 0x2E, 0x34, 0x00, 0x00, 0x00, 0xF7,
> +	0x00, 0x0A, 0x1F, 0xFF, 0xFF, 0x64, 0x02, 0x00,
> +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0xED,
> +	0x02, 0x03, 0x2A, 0x72, 0x55, 0x90, 0x05, 0x1F,
> +	0x14, 0x04, 0x13, 0x01, 0x02, 0x03, 0x11, 0x12,
> +	0x06, 0x07, 0x15, 0x16, 0x22, 0x21, 0x20, 0x3E,
> +	0x3D, 0x3C, 0x23, 0x0F, 0x57, 0x07, 0x83, 0x4F,
> +	0x00, 0x00, 0x67, 0x03, 0x0C, 0x00, 0x10, 0x00,
> +	0xA8, 0x2D, 0x01, 0x1D, 0x80, 0x18, 0x71, 0x1C,
> +	0x16, 0x20, 0x58, 0x2C, 0x25, 0x00, 0xE8, 0x12,
> +	0x11, 0x00, 0x00, 0x9E, 0x01, 0x1D, 0x80, 0xD0,
> +	0x72, 0x1C, 0x16, 0x20, 0x10, 0x2C, 0x25, 0x80,
> +	0xE8, 0x12, 0x11, 0x00, 0x00, 0x9E, 0x01, 0x1D,
> +	0x00, 0x72, 0x51, 0xD0, 0x1E, 0x20, 0x6E, 0x28,
> +	0x55, 0x00, 0xE8, 0x12, 0x11, 0x00, 0x00, 0x1E,
> +	0x01, 0x1D, 0x00, 0xBC, 0x52, 0xD0, 0x1E, 0x20,
> +	0xB8, 0x28, 0x55, 0x40, 0xE8, 0x12, 0x11, 0x00,
> +	0x00, 0x1E, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x91,
> +};

Hmm... Doesn't the driver support reading the EDID table from the
hardware?

> +
> +struct vga_size_t {
> +	u32 lcf_min;
> +	u32 lcf_max;
> +	u32 width;
> +	u32 height[2];
> +	u32 interlaced;
> +};
> +
> +struct vga_rate_t {
> +	u32 fcl_min;
> +	u32 fcl_max;
> +	u32 ulInterval10M;
> +	u32 ucFps100;
> +	u32 ucFps099;
> +	u32 rate;
> +};
> +
> +/* We cross reference video_input_type into out formats array, allowing the
> + * driver to determine whether a video format is appropriate for a given
> + * input. The following enum is used internally only for cross referencing.
> + */
> +enum format_input_type {
> +	FMT_INPUT_UNKNOWN       = 0x00,
> +	FMT_INPUT_DVI           = 0x01,
> +	FMT_INPUT_YPRPB         = 0x02,
> +	FMT_INPUT_VGA           = 0x04,
> +	FMT_INPUT_SVIDEO        = 0x08,
> +	FMT_INPUT_COMPOSITE1    = 0x10,
> +	FMT_INPUT_COMPOSITE2    = 0x20,
> +	FMT_INPUT_COMPOSITE3    = 0x40,
> +};
> +
> +struct adv7441a_format {
> +	char  *name;
> +	u32 fourcc;          /* v4l2 format id */
> +	int depth, width, height;
> +	int flags;
> +	int id;
> +	int frate;
> +
> +	/* VBI Related */
> +	u32 vbi_total_lines;
> +	u32 vbi_field0_lines;
> +	u32 vbi_field1_lines;
> +
> +	/* The types of cable inputs this vodeo format is compatible with */
> +	enum format_input_type input;
> +};
> +
> +struct vga_timing_t {
> +	u32 timing_mode;
> +	u32 spec_height;
> +	u32 spec_width;
> +	u32 active_pixels;
> +	u32 active_lines;
> +	u32 total_pixels;
> +	u32 total_lines;
> +	u32 fcl;
> +	u32 bl;
> +	double spec_frequency;
> +	double pixel_clock;
> +	double h_freq;
> +	double v_freq;
> +	double real_field_rate;
> +	double real_frame_rate;

double? That looks weird on my eyes, are you using floating point
numbers on this driver?

> +	u32 h_blanking;
> +	u32 h_sync;
> +	u32 h_front_porch;
> +	u32 h_back_porch;
> +	u32 h_start;
> +	u32 h_end;
> +	u32 v_blaking;
> +	u32 v_sync;
> +	u32 v_front_porch;
> +	u32 v_back_porch;
> +	u32 v_start;
> +	u32 v_end;
> +	u32 left_margin;
> +	u32 right_margin;
> +	u32 top_margin;
> +	u32 bottom_margin;
> +	u32 reduced_blanking;
> +	u32 interlaced;
> +};
> +
> +struct adv7441a_state {
> +
> +	struct v4l2_subdev sd;
> +	struct v4l2_ctrl_handler hdl;
> +	struct i2c_client *client;
> +#if 0
> +	struct workqueue_struct *work_queues;
> +	struct delayed_work delayed_work_enable_hotplug;
> +#endif
> +	u32 vbi_enabled;
> +
> +	/* I2C Addresses */
> +	struct vc8x0_i2c *bus;
> +	u8 usermap_addr;
> +	struct i2c_client *usermap_client;
> +
> +	u8 user1map_addr;
> +	struct i2c_client *user1map_client;
> +
> +	u8 user2map_addr;
> +	struct i2c_client *user2map_client;
> +
> +	u8 user3map_addr;
> +	struct i2c_client *user3map_client;
> +
> +	u8 reservedmap_addr;
> +	struct i2c_client *reservedmap_client;
> +
> +	u8 hdmimap_addr;
> +	struct i2c_client *hdmimap_client;
> +
> +	u8 rksvmap_addr;
> +	struct i2c_client *rksvmap_client;
> +
> +	u8 edidmap_addr;
> +	struct i2c_client *edidmap_client;
> +
> +	struct adv7441a_format *fmt;
> +
> +	/* Controls */
> +	u32 brightness;
> +	u32 contrast;
> +	u32 hue;
> +	u32 saturation;
> +
> +	/* Detected settings */
> +	/* jiffy last time in ms, when we attempt a fmt and lock detect */
> +	u64 last_detected;
> +	u64 last_locked;
> +	u32 detected_width;
> +	u32 detected_height;
> +	u32 detected_interlaced;
> +	struct adv7441a_format *detected_fmt;
> +	struct vga_timing_t *vga_timing_mode;
> +
> +	/* physical video input */
> +	u32 video_input_nr;
> +
> +	struct detection_t {
> +		/* false(0) / true(1) */
> +		u32 valid;
> +		u32 locked;
> +		u32 interlaced;

Huh? Just declare them with "bool" type, instead, if they are
booleans.

> +
> +		/* 00 Invalid
> +		 * 01 Separate HS and VS sync on pins
> +		 * 10 External CS sync on HS IN pin
> +		 * 11 Embedded SOG/SOY
> +		 */
> +		u32 sync_mask;
> +
> +		/* 0 - VS IN pin positiv
> +		 * 1 - HS IN pin positive
> +		 */
> +		/* 00 Invalid
> +		 * 01 GTF (in vga timings as 00)
> +		 * 10 CVT  (in vga timings as 01)
> +		 * 11 DMT (in vga timings as 02)
> +		 */
> +		u32 sync_polarity;
> +
> +		u32 bl;
> +
> +		/* Number of lines in the field */
> +		u32 lcf;
> +
> +		/* Number of lines in a vsync period */
> +		u32 lcvs;
> +
> +		/* Field Length Count - Number of clock cycles between
> +		 * successive vsyncs */
> +		u32 fcl28;
> +
> +		/* Field Rate Hz * 100, eg 5994 */
> +		u32 field_rate;
> +
> +		/* Raw register data */
> +		u8 stat_10[4], stdi_b1[5], fcl[2];
> +
> +	} detection;
> +};
> +
> +/* TODO: Review how many of these fields are required and
> + * how many are redundant after the cloned struct from the
> + * vc8x0.
> + */
> +static struct adv7441a_format formats[] = {
> +	{
> +		.name     = "422packed,YUYV,640x480p60",
> +		.fourcc   = V4L2_PIX_FMT_YUYV,
> +		.width    = 640,
> +		.height   = 480,
> +		.depth    = 16,
> +		.flags    = ADV7441A_FORMAT_PROGRESSIVE,
> +		.id       = ADV7441A_FORMAT_640x480p60,

The DV API defines the formats for digital video. Use it, instead of
adding a new type here.

> +		.frate    = ADV7441A_FRAMERATE_60,
> +		.input    = FMT_INPUT_VGA,
> +	},
> +/* 720 x 480 */
> +	{
> +		.name     = "422packed,YUYV,720x480i59",
> +		.fourcc   = V4L2_PIX_FMT_YUYV,
> +		.width    = 720,
> +		.height   = 480,
> +		.depth    = 16,
> +		.flags    = ADV7441A_FORMAT_INTERLACED,
> +		.id       = ADV7441A_FORMAT_720x480i59,
> +		.frate    = ADV7441A_FRAMERATE_59,
> +		.vbi_total_lines = 45,
> +		.vbi_field0_lines = 22,
> +		.vbi_field1_lines = 23,
> +		.input    = FMT_INPUT_DVI |
> +			FMT_INPUT_YPRPB |
> +			FMT_INPUT_SVIDEO |
> +			FMT_INPUT_COMPOSITE1 |
> +			FMT_INPUT_COMPOSITE2 |
> +			FMT_INPUT_COMPOSITE3,
> +	},
> +	{
> +		.name     = "422packed,YUYV,720x480i60",
> +		.fourcc   = V4L2_PIX_FMT_YUYV,
> +		.width    = 720,
> +		.height   = 480,
> +		.depth    = 16,
> +		.flags    = ADV7441A_FORMAT_INTERLACED,
> +		.id       = ADV7441A_FORMAT_720x480i60,
> +		.frate    = ADV7441A_FRAMERATE_60,
> +		.vbi_total_lines = 45,
> +		.vbi_field0_lines = 22,
> +		.vbi_field1_lines = 23,
> +		.input    = FMT_INPUT_DVI |
> +			FMT_INPUT_YPRPB |
> +			FMT_INPUT_SVIDEO |
> +			FMT_INPUT_COMPOSITE1 |
> +			FMT_INPUT_COMPOSITE2 |
> +			FMT_INPUT_COMPOSITE3,
> +	},
> +/* 720 x 576 */
> +	{
> +		.name     = "422packed,YUYV,720x576p25",
> +		.fourcc   = V4L2_PIX_FMT_YUYV,
> +		.width    = 720,
> +		.height   = 576,
> +		.depth    = 16,
> +		.flags    = ADV7441A_FORMAT_PROGRESSIVE,
> +		.id       = ADV7441A_FORMAT_720x576p25,
> +		.frate    = ADV7441A_FRAMERATE_25,
> +		.input    = FMT_INPUT_DVI |
> +			FMT_INPUT_YPRPB |
> +			FMT_INPUT_SVIDEO |
> +			FMT_INPUT_COMPOSITE1 |
> +			FMT_INPUT_COMPOSITE2 |
> +			FMT_INPUT_COMPOSITE3,
> +	},
> +	{
> +		.name     = "422packed,YUYV,720x576i50",
> +		.fourcc   = V4L2_PIX_FMT_YUYV,
> +		.width    = 720,
> +		.height   = 576,
> +		.depth    = 16,
> +		.flags    = ADV7441A_FORMAT_INTERLACED,
> +		.id       = ADV7441A_FORMAT_720x576i50,
> +		.frate    = ADV7441A_FRAMERATE_50,
> +		.input    = FMT_INPUT_DVI |
> +			FMT_INPUT_YPRPB |
> +			FMT_INPUT_SVIDEO |
> +			FMT_INPUT_COMPOSITE1 |
> +			FMT_INPUT_COMPOSITE2 |
> +			FMT_INPUT_COMPOSITE3,
> +	},
> +/* 800 x 600 */
> +	{
> +		.name     = "422packed,YUYV,800x600p60",
> +		.fourcc   = V4L2_PIX_FMT_YUYV,
> +		.width    = 800,
> +		.height   = 600,
> +		.depth    = 16,
> +		.flags    = ADV7441A_FORMAT_PROGRESSIVE,
> +		.id       = ADV7441A_FORMAT_800x600p60,
> +		.frate    = ADV7441A_FRAMERATE_60,
> +		.input    = FMT_INPUT_VGA,
> +	},
> +/* 1024 x 768 */
> +	{
> +		.name     = "422packed,YUYV,1024x768p60",
> +		.fourcc   = V4L2_PIX_FMT_YUYV,
> +		.width    = 1024,
> +		.height   = 768,
> +		.depth    = 16,
> +		.flags    = ADV7441A_FORMAT_PROGRESSIVE,
> +		.id       = ADV7441A_FORMAT_1024x768p60,
> +		.frate    = ADV7441A_FRAMERATE_60,
> +		.input    = FMT_INPUT_VGA,
> +	},
> +/* 1280 x 960 */
> +	{
> +		.name     = "422packed,YUYV,1280x960p60",
> +		.fourcc   = V4L2_PIX_FMT_YUYV,
> +		.width    = 1280,
> +		.height   = 960,
> +		.depth    = 16,
> +		.flags    = ADV7441A_FORMAT_PROGRESSIVE,
> +		.id       = ADV7441A_FORMAT_1280x960p60,
> +		.frate    = ADV7441A_FRAMERATE_60,
> +		.input    = FMT_INPUT_VGA,
> +	},
> +	{
> +		.name     = "422packed,YUYV,1280x1024p60",
> +		.fourcc   = V4L2_PIX_FMT_YUYV,
> +		.width    = 1280,
> +		.height   = 1024,
> +		.depth    = 16,
> +		.flags    = ADV7441A_FORMAT_PROGRESSIVE,
> +		.id       = ADV7441A_FORMAT_1280x1024p60,
> +		.frate    = ADV7441A_FRAMERATE_60,
> +		.input    = FMT_INPUT_VGA,
> +	},
> +/* 1280 x 720 */
> +	{
> +		.name     = "422packed,YUYV,1280x720p23",
> +		.fourcc   = V4L2_PIX_FMT_YUYV,
> +		.width    = 1280,
> +		.height   = 720,
> +		.depth    = 16,
> +		.flags    = ADV7441A_FORMAT_PROGRESSIVE,
> +		.id       = ADV7441A_FORMAT_1280x720p23,
> +		.frate    = ADV7441A_FRAMERATE_23,
> +		.input    = FMT_INPUT_DVI | FMT_INPUT_YPRPB,
> +	}, {
> +		.name     = "422packed,YUYV,1280x720p24",
> +		.fourcc   = V4L2_PIX_FMT_YUYV,
> +		.width    = 1280,
> +		.height   = 720,
> +		.depth    = 16,
> +		.flags    = ADV7441A_FORMAT_PROGRESSIVE,
> +		.id       = ADV7441A_FORMAT_1280x720p24,
> +		.frate    = ADV7441A_FRAMERATE_24,
> +		.input    = FMT_INPUT_DVI | FMT_INPUT_YPRPB,
> +	}, {
> +		.name     = "422packed,YUYV,1280x720p25",
> +		.fourcc   = V4L2_PIX_FMT_YUYV,
> +		.width    = 1280,
> +		.height   = 720,
> +		.depth    = 16,
> +		.flags    = ADV7441A_FORMAT_PROGRESSIVE,
> +		.id       = ADV7441A_FORMAT_1280x720p25,
> +		.frate    = ADV7441A_FRAMERATE_25,
> +		.input    = FMT_INPUT_DVI | FMT_INPUT_YPRPB,
> +	}, {
> +		.name     = "422packed,YUYV,1280x720p29",
> +		.fourcc   = V4L2_PIX_FMT_YUYV,
> +		.width    = 1280,
> +		.height   = 720,
> +		.depth    = 16,
> +		.flags    = ADV7441A_FORMAT_PROGRESSIVE,
> +		.id       = ADV7441A_FORMAT_1280x720p29,
> +		.frate    = ADV7441A_FRAMERATE_29,
> +		.input    = FMT_INPUT_DVI | FMT_INPUT_YPRPB,
> +	}, {
> +		.name     = "422packed,YUYV,1280x720p30",
> +		.fourcc   = V4L2_PIX_FMT_YUYV,
> +		.width    = 1280,
> +		.height   = 720,
> +		.depth    = 16,
> +		.flags    = ADV7441A_FORMAT_PROGRESSIVE,
> +		.id       = ADV7441A_FORMAT_1280x720p30,
> +		.frate    = ADV7441A_FRAMERATE_30,
> +		.input    = FMT_INPUT_DVI | FMT_INPUT_YPRPB,
> +	}, {
> +		.name     = "422packed,YUYV,1280x720p50",
> +		.fourcc   = V4L2_PIX_FMT_YUYV,
> +		.width    = 1280,
> +		.height   = 720,
> +		.depth    = 16,
> +		.flags    = ADV7441A_FORMAT_PROGRESSIVE,
> +		.id       = ADV7441A_FORMAT_1280x720p50,
> +		.frate    = ADV7441A_FRAMERATE_50,
> +		.input    = FMT_INPUT_DVI | FMT_INPUT_YPRPB,
> +	}, {
> +		.name     = "422packed,YUYV,1280x720p59",
> +		.fourcc   = V4L2_PIX_FMT_YUYV,
> +		.width    = 1280,
> +		.height   = 720,
> +		.depth    = 16,
> +		.flags    = ADV7441A_FORMAT_PROGRESSIVE,
> +		.id       = ADV7441A_FORMAT_1280x720p59,
> +		.frate    = ADV7441A_FRAMERATE_59,
> +		.input    = FMT_INPUT_DVI | FMT_INPUT_YPRPB,
> +	}, {
> +		.name     = "422packed,YUYV,1280x720p60",
> +		.fourcc   = V4L2_PIX_FMT_YUYV,
> +		.width    = 1280,
> +		.height   = 720,
> +		.depth    = 16,
> +		.flags    = ADV7441A_FORMAT_PROGRESSIVE,
> +		.id       = ADV7441A_FORMAT_1280x720p60,
> +		.frate    = ADV7441A_FRAMERATE_60,
> +		.input    = FMT_INPUT_DVI | FMT_INPUT_YPRPB | FMT_INPUT_VGA,
> +	},
> +/* 1400 x 1050 */
> +	{
> +		.name     = "422packed,YUYV,1400x1050p60",
> +		.fourcc   = V4L2_PIX_FMT_YUYV,
> +		.width    = 1400,
> +		.height   = 1050,
> +		.depth    = 16,
> +		.flags    = ADV7441A_FORMAT_PROGRESSIVE,
> +		.id       = ADV7441A_FORMAT_1400x1050p60,
> +		.frate    = ADV7441A_FRAMERATE_60,
> +		.input    = FMT_INPUT_VGA,
> +	},
> +/* 1600 x 1200 */
> +	{
> +		.name     = "422packed,YUYV,1600x1200p60",
> +		.fourcc   = V4L2_PIX_FMT_YUYV,
> +		.width    = 1600,
> +		.height   = 1200,
> +		.depth    = 16,
> +		.flags    = ADV7441A_FORMAT_PROGRESSIVE,
> +		.id       = ADV7441A_FORMAT_1600x1200p60,
> +		.frate    = ADV7441A_FRAMERATE_60,
> +		.input    = FMT_INPUT_VGA,
> +	},
> +/* 1920 x 1080 */
> +	{
> +		.name     = "422packed,YUYV,1920x1080i50",
> +		.fourcc   = V4L2_PIX_FMT_YUYV,
> +		.width    = 1920,
> +		.height   = 1080,
> +		.depth    = 16,
> +		.flags    = ADV7441A_FORMAT_INTERLACED,
> +		.id       = ADV7441A_FORMAT_1920x1080i50,
> +		.frate    = ADV7441A_FRAMERATE_50,
> +		.input    = FMT_INPUT_DVI | FMT_INPUT_YPRPB,
> +	},
> +	{
> +		.name     = "422packed,YUYV,1920x1080i59",
> +		.fourcc   = V4L2_PIX_FMT_YUYV,
> +		.width    = 1920,
> +		.height   = 1080,
> +		.depth    = 16,
> +		.flags    = ADV7441A_FORMAT_INTERLACED,
> +		.id       = ADV7441A_FORMAT_1920x1080i59,
> +		.frate    = ADV7441A_FRAMERATE_59,
> +		.input    = FMT_INPUT_DVI | FMT_INPUT_YPRPB,
> +	}, {
> +		.name     = "422packed,YUYV,1920x1080i60",
> +		.fourcc   = V4L2_PIX_FMT_YUYV,
> +		.width    = 1920,
> +		.height   = 1080,
> +		.depth    = 16,
> +		.flags    = ADV7441A_FORMAT_INTERLACED,
> +		.id       = ADV7441A_FORMAT_1920x1080i60,
> +		.frate    = ADV7441A_FRAMERATE_60,
> +		.input    = FMT_INPUT_DVI | FMT_INPUT_YPRPB,
> +	},
> +	{
> +		.name     = "422packed,YUYV,1920x1080p23",
> +		.fourcc   = V4L2_PIX_FMT_YUYV,
> +		.width    = 1920,
> +		.height   = 1080,
> +		.depth    = 16,
> +		.flags    = ADV7441A_FORMAT_PROGRESSIVE,
> +		.id       = ADV7441A_FORMAT_1920x1080p23,
> +		.frate    = ADV7441A_FRAMERATE_23,
> +		.input    = FMT_INPUT_DVI | FMT_INPUT_YPRPB,
> +	}, {
> +		.name     = "422packed,YUYV,1920x1080p24",
> +		.fourcc   = V4L2_PIX_FMT_YUYV,
> +		.width    = 1920,
> +		.height   = 1080,
> +		.depth    = 16,
> +		.flags    = ADV7441A_FORMAT_PROGRESSIVE,
> +		.id       = ADV7441A_FORMAT_1920x1080p24,
> +		.frate    = ADV7441A_FRAMERATE_24,
> +		.input    = FMT_INPUT_DVI | FMT_INPUT_YPRPB,
> +	}, {
> +		.name     = "422packed,YUYV,1920x1080p25",
> +		.fourcc   = V4L2_PIX_FMT_YUYV,
> +		.width    = 1920,
> +		.height   = 1080,
> +		.depth    = 16,
> +		.flags    = ADV7441A_FORMAT_PROGRESSIVE,
> +		.id       = ADV7441A_FORMAT_1920x1080p25,
> +		.frate    = ADV7441A_FRAMERATE_25,
> +		.input    = FMT_INPUT_DVI | FMT_INPUT_YPRPB,
> +	}, {
> +		.name     = "422packed,YUYV,1920x1080p30",
> +		.fourcc   = V4L2_PIX_FMT_YUYV,
> +		.width    = 1920,
> +		.height   = 1080,
> +		.depth    = 16,
> +		.flags    = ADV7441A_FORMAT_PROGRESSIVE,
> +		.id       = ADV7441A_FORMAT_1920x1080p30,
> +		.frate    = ADV7441A_FRAMERATE_30,
> +		.input    = FMT_INPUT_DVI | FMT_INPUT_YPRPB,
> +	}, {
> +		.name     = "422packed,YUYV,1920x1080p50",
> +		.fourcc   = V4L2_PIX_FMT_YUYV,
> +		.width    = 1920,
> +		.height   = 1080,
> +		.depth    = 16,
> +		.flags    = ADV7441A_FORMAT_PROGRESSIVE,
> +		.id       = ADV7441A_FORMAT_1920x1080p50,
> +		.frate    = ADV7441A_FRAMERATE_50,
> +		.input    = FMT_INPUT_DVI,
> +	},
> +	{
> +		.name     = "422packed,YUYV,1920x1080p60",
> +		.fourcc   = V4L2_PIX_FMT_YUYV,
> +		.width    = 1920,
> +		.height   = 1080,
> +		.depth    = 16,
> +		.flags    = ADV7441A_FORMAT_PROGRESSIVE,
> +		.id       = ADV7441A_FORMAT_1920x1080p60,
> +		.frate    = ADV7441A_FRAMERATE_60,
> +		.input    = FMT_INPUT_DVI,
> +	},
> +	{
> +		.name     = "422packed,YUYV,1600x1200p60",
> +		.fourcc   = V4L2_PIX_FMT_YUYV,
> +		.width    = 1600,
> +		.height   = 1200,
> +		.depth    = 16,
> +		.flags    = ADV7441A_FORMAT_PROGRESSIVE,
> +		.id       = ADV7441A_FORMAT_UXGA_1600x1200p60,
> +		.frate    = ADV7441A_FRAMERATE_60,
> +		.input    = FMT_INPUT_VGA,
> +	},
> +	{
> +		.name     = "422packed,YUYV,1440x900p60",
> +		.fourcc   = V4L2_PIX_FMT_YUYV,
> +		.width    = 1440,
> +		.height   = 900,
> +		.depth    = 16,
> +		.flags    = ADV7441A_FORMAT_PROGRESSIVE,
> +		.id       = ADV7441A_FORMAT_WXGA_1440x900p60,
> +		.frate    = ADV7441A_FRAMERATE_60,
> +		.input    = FMT_INPUT_VGA,
> +	},
> +	{
> +		.name     = "422packed,YUYV,1680x1050p60",
> +		.fourcc   = V4L2_PIX_FMT_YUYV,
> +		.width    = 1680,
> +		.height   = 1050,
> +		.depth    = 16,
> +		.flags    = ADV7441A_FORMAT_PROGRESSIVE,
> +		.id       = ADV7441A_FORMAT_WSXGA_1680x1050p60,
> +		.frate    = ADV7441A_FRAMERATE_60,
> +		.input    = FMT_INPUT_VGA,
> +	},
> +	{
> +		.name     = "422packed,YUYV,1920x1080p60",
> +		.fourcc   = V4L2_PIX_FMT_YUYV,
> +		.width    = 1920,
> +		.height   = 1080,
> +		.depth    = 16,
> +		.flags    = ADV7441A_FORMAT_PROGRESSIVE,
> +		.id       = ADV7441A_FORMAT_VGAHD_1920x1080p60,
> +		.frate    = ADV7441A_FRAMERATE_60,
> +		.input    = FMT_INPUT_VGA,
> +	},
> +};
> +
> +/*
> +Timing Mode,Spec Height,Spec Width,Active Pixels,Active Lines,Total Pixels,Total Lines,FCL,BL,Spec Frequency,Pixel Clock,H Freq,V Freq,Real Field Rate,Real Frame Rate,H Blanking,H Sync,H Front Porch,H Back Porch,H Start,H End,V Blanking,V Sync,V Front Porch,V Back Porch,V Start,V End,Left Margin,Right Margin,Top Margin,Bottom Margin,Reduced Blanking,Interlaced
> +*/
> +static struct vga_timing_t vga_timings[] = {
> +{ 0, 200, 320, 320, 200, 400, 212, 1896, 18323, 60.000000, 5.000000, 12.500000, 60.000000, 58.960000, 58.960000, 80, 32, 8, 40, 328, 360, 12, 6, 3, 3, 203, 209, 0, 0, 0, 0, 0, 0 },
> +{ 0, 200, 320, 320, 200, 480, 215, 1923, 18323, 60.000000, 6.000000, 12.500000, 60.000000, 58.130000, 58.130000, 80, 32, 8, 40, 328, 360, 14, 6, 3, 5, 203, 209, 0, 0, 0, 0, 1, 0 },
> +{ 0, 200, 320, 320, 200, 400, 112, 2004, 36646, 60.000000, 2.500000, 6.250000, 60.000000, 55.550000, 27.770000, 80, 32, 8, 40, 328, 360, 12, 6, 3, 3, 203, 209, 0, 0, 0, 0, 0, 1 },
> +{ 0, 200, 320, 320, 200, 480, 115, 1899, 33827, 60.000000, 3.250000, 6.770000, 60.000000, 58.620000, 29.310000, 80, 32, 8, 40, 328, 360, 11, 6, 3, 2, 203, 209, 0, 0, 0, 0, 1, 1 },
> +{ 0, 240, 320, 320, 240, 400, 252, 1878, 15269, 60.000000, 6.000000, 15.000000, 60.000000, 59.520000, 59.520000, 80, 32, 8, 40, 328, 360, 12, 4, 3, 5, 243, 247, 0, 0, 0, 0, 0, 0 },
> +{ 0, 240, 320, 320, 240, 480, 253, 1873, 15164, 60.000000, 7.250000, 15.100000, 60.000000, 59.690000, 59.690000, 80, 32, 8, 40, 328, 360, 13, 4, 3, 6, 243, 247, 0, 0, 0, 0, 1, 0 },
> +{ 0, 240, 320, 320, 240, 400, 130, 1938, 30538, 60.000000, 3.000000, 7.500000, 60.000000, 57.470000, 28.730000, 80, 32, 8, 40, 328, 360, 10, 4, 3, 3, 243, 247, 0, 0, 0, 0, 0, 1 },
> +{ 0, 240, 320, 320, 240, 480, 133, 1903, 29317, 60.000000, 3.750000, 7.810000, 60.000000, 58.520000, 29.260000, 80, 32, 8, 40, 328, 360, 9, 4, 3, 2, 243, 247, 0, 0, 0, 0, 1, 1 },
> +{ 0, 480, 640, 640, 480, 800, 500, 1883, 7715, 60.000000, 23.750000, 29.680000, 60.000000, 59.370000, 59.370000, 160, 64, 16, 80, 656, 720, 20, 4, 3, 13, 483, 487, 0, 0, 0, 0, 0, 0 },
> +{ 0, 480, 640, 640, 480, 800, 500, 1863, 7634, 60.000000, 24.000000, 30.000000, 60.000000, 60.000000, 60.000000, 160, 32, 48, 80, 688, 720, 20, 4, 3, 13, 483, 487, 0, 0, 0, 0, 1, 0 },
> +{ 0, 480, 640, 640, 480, 800, 252, 1878, 15269, 60.000000, 12.000000, 15.000000, 60.000000, 59.400000, 29.700000, 160, 64, 16, 80, 656, 720, 12, 4, 3, 5, 483, 487, 0, 0, 0, 0, 0, 1 },
> +{ 0, 480, 640, 640, 480, 800, 253, 1886, 15269, 60.000000, 12.000000, 15.000000, 60.000000, 59.170000, 29.580000, 160, 32, 48, 80, 688, 720, 13, 4, 3, 6, 483, 487, 0, 0, 0, 0, 1, 1 },
> +{ 0, 400, 720, 720, 400, 880, 438, 2652, 12403, 85.000000, 16.250000, 18.466000, 85.000000, 84.127563, 42.063782, 176, 32, 56, 88, 776, 808, 20, 10, 3, 7, 403, 413, 0, 0, 0, 0, 1, 1 },
> +{ 0, 400, 720, 720, 400, 896, 432, 2663, 12628, 85.000000, 16.250000, 18.136000, 85.000000, 83.769051, 41.884525, 176, 64, 24, 88, 744, 808, 16, 10, 3, 3, 403, 413, 0, 0, 0, 0, 0, 1 },
> +{ 0, 400, 720, 720, 400, 880, 419, 1319, 6449, 85.000000, 31.250000, 35.511002, 85.000000, 84.751793, 84.751793, 192, 32, 64, 96, 784, 816, 28, 10, 3, 15, 403, 413, 0, 0, 0, 0, 1, 0 },
> +{ 0, 400, 720, 720, 400, 912, 423, 1317, 6378, 85.000000, 32.750000, 35.910000, 85.000000, 84.893616, 84.893616, 192, 72, 24, 96, 744, 816, 23, 10, 3, 10, 403, 413, 0, 0, 0, 0, 0, 0 },
> +{ 0, 480, 720, 720, 480, 880, 259, 1888, 14930, 60.000000, 13.500000, 15.340000, 60.000000, 59.110000, 29.550000, 176, 32, 56, 88, 776, 808, 19, 10, 3, 6, 483, 493, 0, 0, 0, 0, 1, 1 },
> +{ 0, 480, 720, 720, 480, 880, 259, 3776, 29860, 30.000000, 6.750000, 7.670000, 30.000000, 29.556841, 14.778420, 176, 32, 56, 88, 776, 808, 15, 10, 3, 2, 483, 493, 0, 0, 0, 0, 1, 1 },
> +{ 0, 480, 720, 720, 480, 896, 256, 3946, 31572, 30.000000, 6.500000, 7.254000, 30.000000, 28.280703, 14.140351, 176, 64, 24, 88, 744, 808, 16, 10, 3, 3, 483, 493, 0, 0, 0, 0, 0, 1 },
> +{ 0, 480, 720, 720, 480, 880, 499, 3777, 15504, 30.000000, 13.000000, 14.773000, 30.000000, 29.605209, 29.605209, 176, 32, 56, 88, 776, 808, 19, 10, 3, 6, 483, 493, 0, 0, 0, 0, 1, 0 },
> +{ 0, 480, 720, 720, 480, 896, 496, 3823, 15786, 30.000000, 13.000000, 14.509000, 30.000000, 29.252016, 29.252016, 176, 64, 24, 88, 744, 808, 16, 10, 3, 3, 483, 493, 0, 0, 0, 0, 0, 0 },
> +{ 0, 480, 720, 720, 480, 880, 259, 3776, 29860, 29.969999, 6.750000, 7.670000, 29.969999, 29.556841, 14.778420, 176, 32, 56, 88, 776, 808, 15, 10, 3, 2, 483, 493, 0, 0, 0, 0, 1, 1 },
> +{ 0, 480, 720, 720, 480, 896, 256, 3946, 31572, 29.969999, 6.500000, 7.254000, 29.969999, 28.280703, 14.140351, 176, 64, 24, 88, 744, 808, 16, 10, 3, 3, 483, 493, 0, 0, 0, 0, 0, 1 },
> +{ 0, 480, 720, 720, 480, 880, 499, 3777, 15504, 29.969999, 13.000000, 14.773000, 29.969999, 29.605209, 29.605209, 176, 32, 56, 88, 776, 808, 19, 10, 3, 6, 483, 493, 0, 0, 0, 0, 1, 0 },
> +{ 0, 480, 720, 720, 480, 896, 496, 3823, 15786, 29.969999, 13.000000, 14.509000, 29.969999, 29.252016, 29.252016, 176, 64, 24, 88, 744, 808, 16, 10, 3, 3, 483, 493, 0, 0, 0, 0, 0, 0 },
> +{ 0, 480, 720, 720, 480, 896, 256, 1900, 15201, 60.000000, 13.500000, 15.600000, 60.000000, 58.740000, 29.370000, 176, 64, 24, 88, 744, 808, 16, 10, 3, 3, 483, 493, 0, 0, 0, 0, 0, 1 },
> +{ 0, 480, 720, 720, 480, 880, 499, 1870, 7678, 60.000000, 26.250000, 29.830000, 60.000000, 59.770000, 59.770000, 176, 32, 56, 88, 776, 808, 26, 10, 3, 13, 483, 493, 0, 0, 0, 0, 1, 0 },
> +{ 0, 480, 720, 720, 480, 896, 500, 1872, 7671, 60.000000, 26.750000, 29.850000, 60.000000, 59.700000, 59.700000, 176, 64, 24, 88, 744, 808, 20, 10, 3, 7, 483, 493, 0, 0, 0, 0, 0, 0 },
> +{ 0, 576, 768, 768, 576, 928, 301, 1865, 12689, 60.000000, 16.750000, 18.390000, 60.000000, 59.860000, 29.930000, 192, 32, 64, 96, 832, 864, 14, 4, 3, 7, 579, 583, 0, 0, 0, 0, 1, 1 },
> +{ 0, 576, 768, 768, 576, 960, 301, 1873, 12746, 60.000000, 17.250000, 17.960000, 60.000000, 59.590000, 29.790000, 192, 72, 24, 96, 792, 864, 13, 4, 3, 6, 579, 583, 0, 0, 0, 0, 0, 1 },
> +{ 0, 576, 768, 768, 576, 928, 598, 1866, 6392, 60.000000, 33.250000, 35.830000, 60.000000, 59.910000, 59.910000, 208, 32, 72, 104, 840, 872, 22, 4, 3, 15, 579, 583, 0, 0, 0, 0, 1, 0 },
> +{ 0, 576, 768, 768, 576, 976, 599, 1868, 6386, 60.000000, 35.000000, 35.860000, 60.000000, 59.860000, 59.860000, 208, 72, 32, 104, 800, 872, 23, 4, 3, 16, 579, 583, 0, 0, 0, 0, 0, 0 },
> +{ 0, 480, 800, 800, 480, 960, 256, 1863, 14907, 60.000000, 14.750000, 15.360000, 60.000000, 59.900000, 29.950000, 192, 32, 64, 96, 864, 896, 16, 7, 3, 6, 483, 490, 0, 0, 0, 0, 1, 1 },
> +{ 0, 480, 800, 800, 480, 992, 253, 1902, 15403, 60.000000, 14.750000, 14.860000, 60.000000, 58.650000, 29.320000, 192, 72, 24, 96, 824, 896, 13, 7, 3, 3, 483, 490, 0, 0, 0, 0, 0, 1 },
> +{ 0, 480, 800, 800, 480, 960, 496, 1868, 7715, 60.000000, 28.500000, 29.680000, 60.000000, 59.850000, 59.850000, 192, 32, 64, 96, 864, 896, 23, 7, 3, 13, 483, 490, 0, 0, 0, 0, 1, 0 },
> +{ 0, 480, 800, 800, 480, 992, 500, 1880, 7701, 60.000000, 29.500000, 29.730000, 60.000000, 59.470000, 59.470000, 192, 72, 24, 96, 824, 896, 20, 7, 3, 10, 483, 490, 0, 0, 0, 0, 0, 0 },
> +{ 0, 600, 800, 800, 600, 960, 313, 1866, 12215, 60.000000, 18.000000, 18.750000, 60.000000, 59.800000, 29.900000, 192, 32, 64, 96, 864, 896, 15, 4, 3, 8, 603, 607, 0, 0, 0, 0, 1, 1 },
> +{ 0, 600, 800, 800, 600, 992, 314, 1883, 12281, 60.000000, 18.500000, 18.640000, 60.000000, 59.290000, 29.640000, 192, 72, 24, 96, 824, 896, 14, 4, 3, 7, 603, 607, 0, 0, 0, 0, 0, 1 },
> +{ 0, 600, 800, 800, 600, 960, 623, 1870, 6150, 60.000000, 35.750000, 37.240000, 60.000000, 59.770000, 59.770000, 224, 32, 80, 112, 880, 912, 23, 4, 3, 16, 603, 607, 0, 0, 0, 0, 1, 0 },
> +{ 0, 600, 800, 800, 600, 1024, 624, 1868, 6131, 60.000000, 38.250000, 37.350000, 60.000000, 59.860000, 59.860000, 224, 80, 32, 112, 832, 912, 24, 4, 3, 17, 603, 607, 0, 0, 0, 0, 0, 0 },
> +{ 0, 768, 1024, 1024, 768, 1184, 397, 1877, 9685, 60.000000, 28.000000, 23.640000, 60.000000, 59.490000, 29.740000, 256, 32, 96, 128, 1120, 1152, 17, 4, 3, 10, 771, 775, 0, 0, 0, 0, 1, 1 },
> +{ 0, 768, 1024, 1024, 768, 1280, 401, 1866, 9534, 60.000000, 30.750000, 24.200000, 60.000000, 59.830000, 29.910000, 256, 96, 32, 128, 1056, 1152, 17, 4, 3, 10, 771, 775, 0, 0, 0, 0, 0, 1 },
> +{ 0, 768, 1024, 1024, 768, 1184, 796, 1865, 4799, 60.000000, 56.500000, 47.720000, 60.000000, 59.940000, 59.940000, 304, 32, 120, 152, 1144, 1176, 28, 4, 3, 21, 771, 775, 0, 0, 0, 0, 1, 0 },
> +{ 0, 768, 1024, 1024, 768, 1328, 798, 1866, 4790, 60.000000, 63.500000, 47.810000, 60.000000, 59.910000, 59.910000, 304, 104, 48, 152, 1072, 1176, 30, 4, 3, 23, 771, 775, 0, 0, 0, 0, 0, 0 },
> +{ 0, 768, 1152, 1152, 768, 1312, 403, 1862, 9464, 60.000000, 31.750000, 24.200000, 60.000000, 59.970000, 29.980000, 288, 32, 112, 144, 1264, 1296, 23, 10, 3, 10, 771, 781, 0, 0, 0, 0, 1, 1 },
> +{ 0, 768, 1152, 1152, 768, 1440, 401, 1871, 9559, 60.000000, 34.500000, 23.950000, 60.000000, 59.670000, 29.830000, 288, 112, 32, 144, 1184, 1296, 17, 10, 3, 4, 771, 781, 0, 0, 0, 0, 0, 1 },
> +{ 0, 768, 1152, 1152, 768, 1312, 802, 1867, 4769, 60.000000, 63.000000, 48.100000, 60.000000, 59.870000, 59.870000, 352, 32, 144, 176, 1296, 1328, 34, 10, 3, 21, 771, 781, 0, 0, 0, 0, 1, 0 },
> +{ 0, 768, 1152, 1152, 768, 1504, 798, 1870, 4801, 60.000000, 71.750000, 47.700000, 60.000000, 59.780000, 59.780000, 352, 120, 56, 176, 1208, 1328, 30, 10, 3, 17, 771, 781, 0, 0, 0, 0, 0, 0 },
> +{ 0, 864, 1152, 1152, 864, 1312, 445, 1865, 8585, 60.000000, 35.000000, 26.677000, 60.000000, 59.881031, 29.940516, 288, 32, 112, 144, 1264, 1296, 18, 4, 3, 11, 867, 871, 0, 0, 0, 0, 1, 1 },
> +{ 0, 864, 1152, 1152, 864, 1440, 450, 1870, 8511, 60.000000, 38.750000, 26.910000, 60.000000, 59.733627, 29.866814, 288, 112, 32, 144, 1184, 1296, 18, 4, 3, 11, 867, 871, 0, 0, 0, 0, 0, 1 },
> +{ 0, 864, 1152, 1152, 864, 1312, 895, 1869, 4277, 60.000000, 70.250000, 53.543999, 60.000000, 59.825695, 59.825695, 368, 32, 152, 184, 1304, 1336, 31, 4, 3, 24, 867, 871, 0, 0, 0, 0, 1, 0 },
> +{ 0, 864, 1152, 1152, 864, 1520, 897, 1865, 4258, 60.000000, 81.750000, 53.783001, 60.000000, 59.958752, 59.958752, 368, 120, 64, 184, 1216, 1336, 33, 4, 3, 26, 867, 871, 0, 0, 0, 0, 0, 0 },
> +{ 0, 720, 1280, 1280, 720, 1440, 374, 1867, 10226, 60.000000, 32.250000, 22.390000, 60.000000, 59.800000, 29.900000, 320, 32, 128, 160, 1408, 1440, 17, 5, 3, 9, 723, 728, 0, 0, 0, 0, 1, 1 },
> +{ 0, 720, 1280, 1280, 720, 1600, 376, 1868, 10179, 60.000000, 36.000000, 22.500000, 60.000000, 59.760000, 29.880000, 320, 128, 32, 160, 1312, 1440, 16, 5, 3, 8, 723, 728, 0, 0, 0, 0, 0, 1 },
> +{ 0, 720, 1280, 1280, 720, 1440, 747, 1865, 5113, 60.000000, 64.500000, 44.790000, 60.000000, 59.960000, 59.960000, 384, 32, 160, 192, 1440, 1472, 27, 5, 3, 19, 723, 728, 0, 0, 0, 0, 1, 0 },
> +{ 0, 720, 1280, 1280, 720, 1664, 748, 1868, 5115, 60.000000, 74.500000, 44.770000, 60.000000, 59.850000, 59.850000, 384, 128, 64, 192, 1344, 1472, 28, 5, 3, 20, 723, 728, 0, 0, 0, 0, 0, 0 },
> +{ 0, 768, 1280, 1280, 768, 1440, 400, 1867, 9559, 60.000000, 34.500000, 23.950000, 60.000000, 59.820000, 29.910000, 320, 32, 128, 160, 1408, 1440, 20, 7, 3, 10, 771, 778, 0, 0, 0, 0, 1, 1 },
> +{ 0, 768, 1280, 1280, 768, 1600, 401, 1875, 9580, 60.000000, 38.250000, 23.900000, 60.000000, 59.540000, 29.770000, 320, 128, 32, 160, 1312, 1440, 17, 7, 3, 7, 771, 778, 0, 0, 0, 0, 0, 1 },
> +{ 0, 768, 1280, 1280, 768, 1440, 799, 1864, 4779, 60.000000, 69.000000, 47.910000, 60.000000, 59.970000, 59.970000, 384, 32, 160, 192, 1440, 1472, 31, 7, 3, 21, 771, 778, 0, 0, 0, 0, 1, 0 },
> +{ 0, 768, 1280, 1280, 768, 1664, 798, 1867, 4793, 60.000000, 79.500000, 47.770000, 60.000000, 59.860000, 59.860000, 384, 128, 64, 192, 1344, 1472, 30, 7, 3, 20, 771, 778, 0, 0, 0, 0, 0, 0 },
> +{ 0, 800, 1280, 1280, 800, 1440, 415, 1869, 9225, 60.000000, 35.750000, 24.820000, 60.000000, 59.740000, 29.870000, 320, 32, 128, 160, 1408, 1440, 19, 6, 3, 10, 803, 809, 0, 0, 0, 0, 1, 1 },
> +{ 0, 800, 1280, 1280, 800, 1600, 417, 1865, 9161, 60.000000, 40.000000, 25.000000, 60.000000, 59.880000, 29.940000, 320, 128, 32, 160, 1312, 1440, 17, 6, 3, 8, 803, 809, 0, 0, 0, 0, 0, 1 },
> +{ 0, 800, 1280, 1280, 800, 1440, 831, 1865, 4596, 60.000000, 71.750000, 49.820000, 60.000000, 59.950000, 59.950000, 400, 32, 168, 200, 1448, 1480, 31, 6, 3, 22, 803, 809, 0, 0, 0, 0, 1, 0 },
> +{ 0, 800, 1280, 1280, 800, 1680, 831, 1869, 4608, 60.000000, 83.500000, 49.700000, 60.000000, 59.800000, 59.800000, 400, 128, 72, 200, 1352, 1480, 31, 6, 3, 22, 803, 809, 0, 0, 0, 0, 0, 0 },
> +{ 0, 960, 1280, 1280, 960, 1440, 500, 1872, 7670, 60.000000, 43.000000, 29.860000, 60.000000, 59.660000, 29.830000, 320, 32, 128, 160, 1408, 1440, 20, 4, 3, 13, 963, 967, 0, 0, 0, 0, 1, 1 },
> +{ 0, 960, 1280, 1280, 960, 1600, 500, 1863, 7634, 60.000000, 48.000000, 30.000000, 60.000000, 59.940000, 29.970000, 320, 128, 32, 160, 1312, 1440, 20, 4, 3, 13, 963, 967, 0, 0, 0, 0, 0, 1 },
> +{ 0, 960, 1280, 1280, 960, 1440, 993, 1864, 3846, 60.000000, 85.750000, 59.540000, 60.000000, 59.960000, 59.960000, 416, 32, 176, 208, 1456, 1488, 33, 4, 3, 26, 963, 967, 0, 0, 0, 0, 1, 0 },
> +{ 0, 960, 1280, 1280, 960, 1696, 996, 1865, 3836, 60.000000, 101.250000, 59.690000, 60.000000, 59.930000, 59.930000, 416, 128, 80, 208, 1360, 1488, 36, 4, 3, 29, 963, 967, 0, 0, 0, 0, 0, 0 },
> +{ 0, 1024, 1280, 1280, 1024, 1440, 528, 1868, 7248, 60.000000, 45.500000, 31.590000, 60.000000, 59.780000, 29.890000, 320, 32, 128, 160, 1408, 1440, 24, 7, 3, 14, 1027, 1034, 0, 0, 0, 0, 1, 1 },
> +{ 0, 1024, 1280, 1280, 1024, 1600, 533, 1870, 7185, 60.000000, 51.000000, 31.870000, 60.000000, 59.740000, 29.870000, 320, 128, 32, 160, 1312, 1440, 21, 7, 3, 11, 1027, 1034, 0, 0, 0, 0, 0, 1 },
> +{ 0, 1024, 1280, 1280, 1024, 1440, 1062, 1864, 3594, 60.000000, 91.750000, 63.710000, 60.000000, 59.990000, 59.990000, 432, 32, 184, 216, 1464, 1496, 38, 7, 3, 28, 1027, 1034, 0, 0, 0, 0, 1, 0 },
> +{ 0, 1024, 1280, 1280, 1024, 1712, 1063, 1867, 3597, 60.000000, 109.000000, 63.660000, 60.000000, 59.890000, 59.890000, 432, 136, 80, 216, 1360, 1496, 39, 7, 3, 29, 1027, 1034, 0, 0, 0, 0, 0, 0 },
> +{ 0, 768, 1366, 1360, 768, 1520, 398, 1866, 9603, 60.000000, 36.250000, 23.840000, 60.000000, 59.840000, 29.920000, 336, 32, 136, 168, 1496, 1528, 18, 5, 3, 10, 771, 776, 0, 0, 0, 0, 1, 1 },
> +{ 0, 768, 1366, 1360, 768, 1696, 401, 1866, 9532, 60.000000, 40.750000, 24.200000, 60.000000, 59.840000, 29.920000, 336, 128, 40, 168, 1400, 1528, 17, 5, 3, 9, 771, 776, 0, 0, 0, 0, 0, 1 },
> +{ 0, 768, 1366, 1360, 768, 1520, 797, 1868, 4801, 60.000000, 72.500000, 47.690000, 60.000000, 59.840000, 59.840000, 416, 32, 176, 208, 1536, 1568, 29, 5, 3, 21, 771, 776, 0, 0, 0, 0, 1, 0 },
> +{ 0, 768, 1366, 1360, 768, 1776, 798, 1870, 4799, 60.000000, 84.750000, 47.720000, 60.000000, 59.790000, 59.790000, 416, 136, 72, 208, 1432, 1568, 30, 5, 3, 22, 771, 776, 0, 0, 0, 0, 0, 0 },
> +{ 0, 1050, 1400, 1400, 1050, 1560, 546, 1867, 7005, 60.000000, 51.000000, 32.690000, 60.000000, 59.820000, 29.910000, 352, 32, 144, 176, 1544, 1576, 21, 4, 3, 14, 1053, 1057, 0, 0, 0, 0, 1, 1 },
> +{ 0, 1050, 1400, 1400, 1050, 1768, 547, 1872, 7011, 60.000000, 57.750000, 32.650000, 60.000000, 59.660000, 29.830000, 368, 136, 48, 184, 1448, 1584, 22, 4, 3, 15, 1053, 1057, 0, 0, 0, 0, 0, 1 },
> +{ 0, 1050, 1400, 1400, 1050, 1560, 1086, 1866, 3520, 60.000000, 101.500000, 65.590000, 60.000000, 59.910000, 59.910000, 464, 32, 200, 232, 1600, 1632, 36, 4, 3, 29, 1053, 1057, 0, 0, 0, 0, 1, 0 },
> +{ 0, 1050, 1400, 1400, 1050, 1864, 1089, 1864, 3506, 60.000000, 121.750000, 65.310000, 60.000000, 59.970000, 59.970000, 464, 144, 88, 232, 1488, 1632, 39, 4, 3, 32, 1053, 1057, 0, 0, 0, 0, 0, 0 },
> +{ 0, 900, 1440, 1440, 900, 1600, 465, 1869, 8235, 60.000000, 44.500000, 27.810000, 60.000000, 59.740000, 29.870000, 352, 32, 144, 176, 1584, 1616, 21, 6, 3, 12, 903, 909, 0, 0, 0, 0, 1, 1 },
> +{ 0, 900, 1440, 1440, 900, 1792, 469, 1870, 8167, 60.000000, 50.250000, 28.400000, 60.000000, 59.720000, 29.860000, 352, 136, 40, 176, 1480, 1616, 19, 6, 3, 10, 903, 909, 0, 0, 0, 0, 0, 1 },
> +{ 0, 900, 1440, 1440, 900, 1600, 934, 1867, 4094, 60.000000, 89.500000, 55.930000, 60.000000, 59.890000, 59.890000, 464, 32, 200, 232, 1640, 1672, 34, 6, 3, 25, 903, 909, 0, 0, 0, 0, 1, 0 },
> +{ 0, 900, 1440, 1440, 900, 1904, 934, 1867, 4094, 60.000000, 106.500000, 55.930000, 60.000000, 59.880000, 59.880000, 464, 152, 80, 232, 1520, 1672, 34, 6, 3, 25, 903, 909, 0, 0, 0, 0, 0, 0 },
> +{ 0, 960, 1440, 1440, 960, 1600, 499, 1869, 7674, 60.000000, 47.750000, 29.840000, 60.000000, 59.740000, 29.870000, 352, 32, 144, 176, 1584, 1616, 26, 10, 3, 13, 963, 973, 0, 0, 0, 0, 1, 1 },
> +{ 0, 960, 1440, 1440, 960, 1792, 500, 1864, 7636, 60.000000, 53.750000, 29.990000, 60.000000, 59.920000, 29.960000, 352, 136, 40, 176, 1480, 1616, 20, 10, 3, 7, 963, 973, 0, 0, 0, 0, 0, 1 },
> +{ 0, 960, 1440, 1440, 960, 1600, 999, 1866, 3827, 60.000000, 95.750000, 59.840000, 60.000000, 59.900000, 59.900000, 464, 32, 200, 232, 1640, 1672, 39, 10, 3, 26, 963, 973, 0, 0, 0, 0, 1, 0 },
> +{ 0, 960, 1440, 1440, 960, 1904, 996, 1864, 3833, 60.000000, 113.750000, 59.740000, 60.000000, 59.980000, 59.980000, 464, 152, 80, 232, 1520, 1672, 36, 10, 3, 23, 963, 973, 0, 0, 0, 0, 0, 0 },
> +{ 0, 1200, 1600, 1600, 1200, 1760, 623, 1865, 6130, 60.000000, 65.750000, 37.350000, 60.000000, 59.910000, 29.950000, 448, 32, 192, 224, 1792, 1824, 23, 4, 3, 16, 1203, 1207, 0, 0, 0, 0, 1, 1 },
> +{ 0, 1200, 1600, 1600, 1200, 2048, 624, 1868, 6131, 60.000000, 76.500000, 37.350000, 60.000000, 59.810000, 29.900000, 448, 160, 64, 224, 1664, 1824, 24, 4, 3, 17, 1203, 1207, 0, 0, 0, 0, 0, 1 },
> +{ 0, 1200, 1600, 1600, 1200, 1760, 1240, 1866, 3083, 60.000000, 130.750000, 74.290000, 60.000000, 59.910000, 59.910000, 560, 32, 248, 280, 1848, 1880, 40, 4, 3, 33, 1203, 1207, 0, 0, 0, 0, 1, 0 },
> +{ 0, 1200, 1600, 1600, 1200, 2160, 1245, 1868, 3072, 60.000000, 161.000000, 74.530000, 60.000000, 59.860000, 59.860000, 560, 168, 112, 280, 1712, 1880, 45, 4, 3, 38, 1203, 1207, 0, 0, 0, 0, 0, 0 },
> +{ 0, 1050, 1780, 1776, 1050, 1936, 544, 1869, 7038, 60.000000, 63.000000, 32.540000, 60.000000, 59.760000, 29.880000, 464, 32, 200, 232, 1976, 2008, 27, 10, 3, 14, 1053, 1063, 0, 0, 0, 0, 1, 1 },
> +{ 0, 1050, 1780, 1776, 1050, 2240, 547, 1870, 7004, 60.000000, 73.250000, 32.700000, 60.000000, 59.720000, 29.860000, 464, 176, 56, 232, 1832, 2008, 22, 10, 3, 9, 1053, 1063, 0, 0, 0, 0, 0, 1 },
> +{ 0, 1050, 1780, 1776, 1050, 1936, 1092, 1865, 3498, 60.000000, 126.750000, 65.470000, 60.000000, 59.950000, 59.950000, 592, 32, 264, 296, 2040, 2072, 42, 10, 3, 29, 1053, 1063, 0, 0, 0, 0, 1, 0 },
> +{ 0, 1050, 1780, 1776, 1050, 2368, 1089, 1866, 3510, 60.000000, 154.500000, 65.230000, 60.000000, 59.910000, 59.910000, 592, 184, 112, 296, 1888, 2072, 39, 10, 3, 26, 1053, 1063, 0, 0, 0, 0, 0, 0 },
> +{ 0, 1080, 1920, 1920, 1080, 2080, 562, 1867, 6805, 60.000000, 70.000000, 33.650000, 60.000000, 59.820000, 29.910000, 496, 32, 216, 248, 2136, 2168, 22, 5, 3, 14, 1083, 1088, 0, 0, 0, 0, 1, 1 },
> +{ 0, 1080, 1920, 1920, 1080, 2432, 562, 1864, 6792, 60.000000, 82.000000, 33.710000, 60.000000, 59.940000, 29.970000, 512, 192, 64, 256, 1984, 2176, 22, 5, 3, 14, 1083, 1088, 0, 0, 0, 0, 0, 1 },
> +{ 0, 1080, 1920, 1920, 1080, 2080, 1118, 1864, 3415, 60.000000, 139.500000, 67.590000, 60.000000, 59.980000, 59.980000, 656, 32, 296, 328, 2216, 2248, 38, 5, 3, 30, 1083, 1088, 0, 0, 0, 0, 1, 0 },
> +{ 0, 1080, 1920, 1920, 1080, 2576, 1120, 1865, 3410, 60.000000, 173.000000, 67.150000, 60.000000, 59.960000, 59.960000, 656, 200, 128, 328, 2048, 2248, 40, 5, 3, 32, 1083, 1088, 0, 0, 0, 0, 0, 0 },
> +{ 1, 200, 320, 320, 200, 336, 208, 1863, 18352, 60.000000, 4.190000, 12.480000, 60.000000, 60.000000, 60.000000, 16, 3, -2, 1, 304, 328, 8, 3, 1, 4, 201, 204, 0, 0, 0, 0, 0, 0 },
> +{ 1, 200, 320, 320, 200, 336, 208, 1863, 18352, 60.000000, 4.190000, 12.480000, 60.000000, 60.000000, 60.000000, 16, 3, -2, 1, 304, 328, 8, 3, 1, 4, 201, 204, 0, 0, 0, 0, 1, 0 },
> +{ 1, 200, 320, 320, 200, 336, 108, 927, 17591, 60.000000, 4.370000, 13.200000, 60.000000, 120.000000, 60.000000, 16, 3, -2, 1, 304, 328, 8, 3, 1, 4, 101, 104, 0, 0, 0, 0, 0, 1 },
> +{ 1, 200, 320, 320, 200, 336, 108, 927, 17591, 60.000000, 4.370000, 13.200000, 60.000000, 120.000000, 60.000000, 16, 3, -2, 1, 304, 328, 8, 3, 1, 4, 101, 104, 0, 0, 0, 0, 1, 1 },
> +{ 1, 240, 320, 320, 240, 352, 249, 1863, 15330, 60.000000, 5.250000, 14.930000, 59.990000, 59.990000, 59.990000, 32, 4, -2, 2, 304, 336, 9, 3, 1, 5, 241, 244, 0, 0, 0, 0, 0, 0 },
> +{ 1, 240, 320, 320, 240, 352, 249, 1863, 15330, 60.000000, 5.250000, 14.930000, 59.990000, 59.990000, 59.990000, 32, 4, -2, 2, 304, 336, 9, 3, 1, 5, 241, 244, 0, 0, 0, 0, 1, 0 },
> +{ 1, 240, 320, 320, 240, 352, 130, 928, 14625, 60.000000, 5.510000, 15.660000, 60.000000, 120.000000, 60.000000, 32, 4, -2, 2, 304, 336, 10, 3, 1, 6, 121, 124, 0, 0, 0, 0, 0, 1 },
> +{ 1, 240, 320, 320, 240, 352, 130, 928, 14625, 60.000000, 5.510000, 15.660000, 60.000000, 120.000000, 60.000000, 32, 4, -2, 2, 304, 336, 10, 3, 1, 6, 121, 124, 0, 0, 0, 0, 1, 1 },
> +{ 1, 480, 640, 640, 480, 800, 497, 1863, 7680, 60.000000, 23.850000, 29.820000, 60.000000, 60.000000, 60.000000, 160, 8, 2, 10, 656, 720, 17, 3, 1, 13, 481, 484, 0, 0, 0, 0, 0, 0 },
> +{ 1, 480, 640, 640, 480, 800, 497, 1863, 7680, 60.000000, 23.850000, 29.820000, 60.000000, 60.000000, 60.000000, 160, 8, 2, 10, 656, 720, 17, 3, 1, 13, 481, 484, 0, 0, 0, 0, 1, 0 },
> +{ 1, 480, 640, 640, 480, 800, 258, 930, 7383, 60.000000, 24.810000, 31.200000, 60.000000, 120.000000, 60.000000, 160, 8, 2, 10, 656, 720, 18, 3, 1, 14, 241, 244, 0, 0, 0, 0, 0, 1 },
> +{ 1, 480, 640, 640, 480, 800, 258, 930, 7383, 60.000000, 24.810000, 31.200000, 60.000000, 120.000000, 60.000000, 160, 8, 2, 10, 656, 720, 18, 3, 1, 14, 241, 244, 0, 0, 0, 0, 1, 1 },
> +{ 1, 400, 720, 720, 400, 928, 444, 1312, 6055, 85.000000, 35.101601, 37.825001, 85.000000, 170.000000, 85.000000, 208, 9, 4, 13, 752, 824, 22, 3, 1, 18, 201, 204, 0, 0, 0, 0, 1, 1 },
> +{ 1, 400, 720, 720, 400, 928, 444, 1312, 6055, 85.000000, 35.101601, 37.825001, 85.000000, 170.000000, 85.000000, 208, 9, 4, 13, 752, 824, 22, 3, 1, 18, 201, 204, 0, 0, 0, 0, 0, 1 },
> +{ 1, 400, 720, 720, 400, 912, 421, 1315, 6400, 85.000000, 32.635921, 35.785000, 85.000000, 85.000000, 85.000000, 192, 9, 3, 12, 744, 816, 21, 3, 1, 17, 401, 404, 0, 0, 0, 0, 1, 0 },
> +{ 1, 400, 720, 720, 400, 912, 421, 1315, 6400, 85.000000, 32.635921, 35.785000, 85.000000, 85.000000, 85.000000, 192, 9, 3, 12, 744, 816, 21, 3, 1, 17, 401, 404, 0, 0, 0, 0, 0, 0 },
> +{ 1, 480, 720, 720, 480, 896, 258, 930, 7383, 60.000000, 27.790000, 31.200000, 60.000000, 120.000000, 60.000000, 176, 9, 2, 11, 736, 808, 18, 3, 1, 14, 241, 244, 0, 0, 0, 0, 1, 1 },
> +{ 1, 480, 720, 720, 480, 800, 249, 1860, 15299, 30.000000, 11.976001, 14.970001, 30.000002, 60.000004, 30.000002, 80, 8, -3, 5, 696, 760, 9, 3, 1, 5, 241, 244, 0, 0, 0, 0, 1, 1 },
> +{ 1, 480, 720, 720, 480, 800, 249, 1860, 15299, 30.000000, 11.976001, 14.970001, 30.000002, 60.000004, 30.000002, 80, 8, -3, 5, 696, 760, 9, 3, 1, 5, 241, 244, 0, 0, 0, 0, 0, 1 },
> +{ 1, 480, 720, 720, 480, 800, 489, 3727, 15612, 30.000000, 11.735999, 14.669999, 29.999998, 29.999998, 29.999998, 80, 8, -3, 5, 696, 760, 9, 3, 1, 5, 481, 484, 0, 0, 0, 0, 1, 0 },
> +{ 1, 480, 720, 720, 480, 800, 489, 3727, 15612, 30.000000, 11.735999, 14.669999, 29.999998, 29.999998, 29.999998, 80, 8, -3, 5, 696, 760, 9, 3, 1, 5, 481, 484, 0, 0, 0, 0, 0, 0 },
> +{ 1, 480, 720, 720, 480, 800, 249, 1862, 15315, 29.969999, 11.964024, 14.955030, 29.969999, 59.939999, 29.969999, 80, 8, -3, 5, 696, 760, 9, 3, 1, 5, 241, 244, 0, 0, 0, 0, 1, 1 },
> +{ 1, 480, 720, 720, 480, 800, 249, 1862, 15315, 29.969999, 11.964024, 14.955030, 29.969999, 59.939999, 29.969999, 80, 8, -3, 5, 696, 760, 9, 3, 1, 5, 241, 244, 0, 0, 0, 0, 0, 1 },
> +{ 1, 480, 720, 720, 480, 800, 489, 3731, 15628, 29.969999, 11.724264, 14.655331, 29.970001, 29.970001, 29.970001, 80, 8, -3, 5, 696, 760, 9, 3, 1, 5, 481, 484, 0, 0, 0, 0, 1, 0 },
> +{ 1, 480, 720, 720, 480, 800, 489, 3731, 15628, 29.969999, 11.724264, 14.655331, 29.970001, 29.970001, 29.970001, 80, 8, -3, 5, 696, 760, 9, 3, 1, 5, 481, 484, 0, 0, 0, 0, 0, 0 },
> +{ 1, 480, 720, 720, 480, 896, 258, 930, 7383, 60.000000, 27.790000, 31.200000, 60.000000, 120.000000, 60.000000, 176, 9, 2, 11, 736, 808, 18, 3, 1, 14, 241, 244, 0, 0, 0, 0, 0, 1 },
> +{ 1, 480, 720, 720, 480, 896, 497, 1863, 7680, 60.000000, 26.710000, 29.820000, 60.000000, 60.000000, 60.000000, 176, 9, 2, 11, 736, 808, 17, 3, 1, 13, 481, 484, 0, 0, 0, 0, 1, 0 },
> +{ 1, 480, 720, 720, 480, 896, 497, 1863, 7680, 60.000000, 26.710000, 29.820000, 60.000000, 60.000000, 60.000000, 176, 9, 2, 11, 736, 808, 17, 3, 1, 13, 481, 484, 0, 0, 0, 0, 0, 0 },
> +{ 1, 576, 768, 768, 576, 976, 309, 930, 6166, 60.000000, 36.240000, 37.130000, 60.000000, 120.000000, 60.000000, 208, 10, 3, 13, 792, 872, 21, 3, 1, 17, 289, 292, 0, 0, 0, 0, 1, 1 },
> +{ 1, 576, 768, 768, 576, 976, 309, 930, 6166, 60.000000, 36.240000, 37.130000, 60.000000, 120.000000, 60.000000, 208, 10, 3, 13, 792, 872, 21, 3, 1, 17, 289, 292, 0, 0, 0, 0, 0, 1 },
> +{ 1, 576, 768, 768, 576, 976, 597, 1863, 6394, 60.000000, 34.960000, 35.820000, 59.990000, 59.990000, 59.990000, 208, 10, 3, 13, 792, 872, 21, 3, 1, 17, 577, 580, 0, 0, 0, 0, 1, 0 },
> +{ 1, 576, 768, 768, 576, 976, 597, 1863, 6394, 60.000000, 34.960000, 35.820000, 59.990000, 59.990000, 59.990000, 208, 10, 3, 13, 792, 872, 21, 3, 1, 17, 577, 580, 0, 0, 0, 0, 0, 0 },
> +{ 1, 480, 800, 800, 480, 1008, 258, 930, 7383, 60.000000, 31.260000, 31.200000, 60.000000, 120.000000, 60.000000, 208, 10, 3, 13, 824, 904, 18, 3, 1, 14, 241, 244, 0, 0, 0, 0, 1, 1 },
> +{ 1, 480, 800, 800, 480, 1008, 258, 930, 7383, 60.000000, 31.260000, 31.200000, 60.000000, 120.000000, 60.000000, 208, 10, 3, 13, 824, 904, 18, 3, 1, 14, 241, 244, 0, 0, 0, 0, 0, 1 },
> +{ 1, 480, 800, 800, 480, 992, 497, 1863, 7680, 60.000000, 29.580000, 29.820000, 60.000000, 60.000000, 60.000000, 192, 10, 2, 12, 816, 896, 17, 3, 1, 13, 481, 484, 0, 0, 0, 0, 1, 0 },
> +{ 1, 480, 800, 800, 480, 992, 497, 1863, 7680, 60.000000, 29.580000, 29.820000, 60.000000, 60.000000, 60.000000, 192, 10, 2, 12, 816, 896, 17, 3, 1, 13, 481, 484, 0, 0, 0, 0, 0, 0 },
> +{ 1, 600, 800, 800, 600, 1024, 322, 930, 5918, 60.000000, 39.610000, 38.700000, 60.000000, 120.000000, 60.000000, 224, 10, 4, 14, 832, 912, 22, 3, 1, 18, 301, 304, 0, 0, 0, 0, 1, 1 },
> +{ 1, 600, 800, 800, 600, 1024, 322, 930, 5918, 60.000000, 39.610000, 38.700000, 60.000000, 120.000000, 60.000000, 224, 10, 4, 14, 832, 912, 22, 3, 1, 18, 301, 304, 0, 0, 0, 0, 0, 1 },
> +{ 1, 600, 800, 800, 600, 1024, 622, 1863, 6137, 60.000000, 38.210000, 37.320000, 60.000000, 60.000000, 60.000000, 224, 10, 4, 14, 832, 912, 22, 3, 1, 18, 601, 604, 0, 0, 0, 0, 1, 0 },
> +{ 1, 600, 800, 800, 600, 1024, 622, 1863, 6137, 60.000000, 38.210000, 37.320000, 60.000000, 60.000000, 60.000000, 224, 10, 4, 14, 832, 912, 22, 3, 1, 18, 601, 604, 0, 0, 0, 0, 0, 0 },
> +{ 1, 768, 1024, 1024, 768, 1344, 412, 930, 4627, 60.000000, 66.520000, 49.500000, 60.000000, 120.000000, 60.000000, 320, 13, 7, 20, 1080, 1184, 28, 3, 1, 24, 385, 388, 0, 0, 0, 0, 1, 1 },
> +{ 1, 768, 1024, 1024, 768, 1344, 412, 930, 4627, 60.000000, 66.520000, 49.500000, 60.000000, 120.000000, 60.000000, 320, 13, 7, 20, 1080, 1184, 28, 3, 1, 24, 385, 388, 0, 0, 0, 0, 0, 1 },
> +{ 1, 768, 1024, 1024, 768, 1344, 795, 1863, 4801, 60.000000, 64.900000, 47.690000, 60.000000, 60.000000, 60.000000, 320, 13, 7, 20, 1080, 1184, 27, 3, 1, 23, 769, 772, 0, 0, 0, 0, 1, 0 },
> +{ 1, 768, 1024, 1024, 768, 1344, 795, 1863, 4801, 60.000000, 64.900000, 47.690000, 60.000000, 60.000000, 60.000000, 320, 13, 7, 20, 1080, 1184, 27, 3, 1, 23, 769, 772, 0, 0, 0, 0, 0, 0 },
> +{ 1, 768, 1152, 1152, 768, 1520, 412, 930, 4627, 60.000000, 75.230000, 49.500000, 60.000000, 120.000000, 60.000000, 368, 15, 8, 23, 1216, 1336, 28, 3, 1, 24, 385, 388, 0, 0, 0, 0, 1, 1 },
> +{ 1, 768, 1152, 1152, 768, 1520, 412, 930, 4627, 60.000000, 75.230000, 49.500000, 60.000000, 120.000000, 60.000000, 368, 15, 8, 23, 1216, 1336, 28, 3, 1, 24, 385, 388, 0, 0, 0, 0, 0, 1 },
> +{ 1, 768, 1152, 1152, 768, 1504, 795, 1863, 4801, 60.000000, 71.730000, 47.690000, 60.000000, 60.000000, 60.000000, 352, 15, 7, 22, 1208, 1328, 27, 3, 1, 23, 769, 772, 0, 0, 0, 0, 1, 0 },
> +{ 1, 768, 1152, 1152, 768, 1504, 795, 1863, 4801, 60.000000, 71.730000, 47.690000, 60.000000, 60.000000, 60.000000, 352, 15, 7, 22, 1208, 1328, 27, 3, 1, 23, 769, 772, 0, 0, 0, 0, 0, 0 },
> +{ 1, 864, 1152, 1152, 864, 1536, 464, 930, 4109, 60.000000, 85.616646, 55.740002, 60.000000, 120.000000, 60.000000, 384, 15, 9, 24, 1224, 1344, 32, 3, 1, 28, 433, 436, 0, 0, 0, 0, 1, 1 },
> +{ 1, 864, 1152, 1152, 864, 1536, 464, 930, 4109, 60.000000, 85.616646, 55.740002, 60.000000, 120.000000, 60.000000, 384, 15, 9, 24, 1224, 1344, 32, 3, 1, 28, 433, 436, 0, 0, 0, 0, 0, 1 },
> +{ 1, 864, 1152, 1152, 864, 1520, 895, 1863, 4265, 60.000000, 81.624001, 53.700001, 60.000004, 60.000004, 60.000004, 368, 15, 8, 23, 1216, 1336, 31, 3, 1, 27, 865, 868, 0, 0, 0, 0, 1, 0 },
> +{ 1, 864, 1152, 1152, 864, 1520, 895, 1863, 4265, 60.000000, 81.624001, 53.700001, 60.000004, 60.000004, 60.000004, 368, 15, 8, 23, 1216, 1336, 31, 3, 1, 27, 865, 868, 0, 0, 0, 0, 0, 0 },
> +{ 1, 720, 1280, 1280, 720, 1680, 387, 930, 4925, 60.000000, 78.110000, 46.500000, 60.000000, 120.000000, 60.000000, 400, 17, 8, 25, 1344, 1480, 27, 3, 1, 23, 361, 364, 0, 0, 0, 0, 1, 1 },
> +{ 1, 720, 1280, 1280, 720, 1680, 387, 930, 4925, 60.000000, 78.110000, 46.500000, 60.000000, 120.000000, 60.000000, 400, 17, 8, 25, 1344, 1480, 27, 3, 1, 23, 361, 364, 0, 0, 0, 0, 0, 1 },
> +{ 1, 720, 1280, 1280, 720, 1664, 746, 1863, 5117, 60.000000, 74.480000, 44.750000, 59.990000, 59.990000, 59.990000, 384, 17, 7, 24, 1336, 1472, 26, 3, 1, 22, 721, 724, 0, 0, 0, 0, 1, 0 },
> +{ 1, 720, 1280, 1280, 720, 1664, 746, 1863, 5117, 60.000000, 74.480000, 44.750000, 59.990000, 59.990000, 59.990000, 384, 17, 7, 24, 1336, 1472, 26, 3, 1, 22, 721, 724, -4, 0, 0, 0, 0, 0 },
> +{ 1, 768, 1280, 1280, 768, 1680, 412, 930, 4627, 60.000000, 83.150000, 49.500000, 60.000000, 120.000000, 60.000000, 400, 17, 8, 25, 1344, 1480, 28, 3, 1, 24, 385, 388, 0, 0, 0, 0, 1, 1 },
> +{ 1, 768, 1280, 1280, 768, 1680, 412, 930, 4627, 60.000000, 83.150000, 49.500000, 60.000000, 120.000000, 60.000000, 400, 17, 8, 25, 1344, 1480, 28, 3, 1, 24, 385, 388, 0, 0, 0, 0, 0, 1 },
> +{ 1, 768, 1280, 1280, 768, 1680, 795, 1863, 4801, 60.000000, 80.130000, 47.690000, 60.000000, 60.000000, 60.000000, 400, 17, 8, 25, 1344, 1480, 27, 3, 1, 23, 769, 772, 0, 0, 0, 0, 1, 0 },
> +{ 1, 768, 1280, 1280, 768, 1680, 795, 1863, 4801, 60.000000, 80.130000, 47.690000, 60.000000, 60.000000, 60.000000, 400, 17, 8, 25, 1344, 1480, 27, 3, 1, 23, 769, 772, 0, 0, 0, 0, 0, 0 },
> +{ 1, 800, 1280, 1280, 800, 1696, 429, 930, 4443, 60.000000, 87.410000, 51.540000, 60.000000, 120.000000, 60.000000, 416, 17, 9, 26, 1352, 1488, 29, 3, 1, 25, 401, 404, 0, 0, 0, 0, 1, 1 },
> +{ 1, 800, 1280, 1280, 800, 1696, 429, 930, 4443, 60.000000, 87.410000, 51.540000, 60.000000, 120.000000, 60.000000, 416, 17, 9, 26, 1352, 1488, 29, 3, 1, 25, 401, 404, 0, 0, 0, 0, 0, 1 },
> +{ 1, 800, 1280, 1280, 800, 1680, 828, 1863, 4610, 60.000000, 83.460000, 49.680000, 60.000000, 60.000000, 60.000000, 400, 17, 8, 25, 1344, 1480, 28, 3, 1, 24, 801, 804, 0, 0, 0, 0, 1, 0 },
> +{ 1, 800, 1280, 1280, 800, 1680, 828, 1863, 4610, 60.000000, 83.460000, 49.680000, 60.000000, 60.000000, 60.000000, 400, 17, 8, 25, 1344, 1480, 28, 3, 1, 24, 801, 804, -2, 0, 0, 0, 0, 0 },
> +{ 1, 960, 1280, 1280, 960, 1712, 515, 931, 3702, 60.000000, 105.900000, 61.860000, 60.000000, 120.000000, 60.000000, 432, 17, 10, 27, 1360, 1496, 35, 3, 1, 31, 481, 484, 0, 0, 0, 0, 1, 1 },
> +{ 1, 960, 1280, 1280, 960, 1712, 515, 931, 3702, 60.000000, 105.900000, 61.860000, 60.000000, 120.000000, 60.000000, 432, 17, 10, 27, 1360, 1496, 35, 3, 1, 31, 481, 484, 0, 0, 0, 0, 0, 1 },
> +{ 1, 960, 1280, 1280, 960, 1712, 994, 1863, 3840, 60.000000, 102.100000, 59.630000, 59.990000, 59.990000, 59.990000, 432, 17, 10, 27, 1360, 1496, 34, 3, 1, 30, 961, 964, 0, 0, 0, 0, 1, 0 },
> +{ 1, 960, 1280, 1280, 960, 1712, 994, 1863, 3840, 60.000000, 102.100000, 59.630000, 59.990000, 59.990000, 59.990000, 432, 17, 10, 27, 1360, 1496, 34, 3, 1, 30, 961, 964, 0, 0, 0, 0, 0, 0 },
> +{ 1, 1024, 1280, 1280, 1024, 1712, 549, 931, 3473, 60.000000, 112.880000, 65.930000, 59.990000, 119.990000, 59.990000, 432, 17, 10, 27, 1360, 1496, 37, 3, 1, 33, 513, 516, 0, 0, 0, 0, 1, 1 },
> +{ 1, 1024, 1280, 1280, 1024, 1712, 549, 931, 3473, 60.000000, 112.880000, 65.930000, 59.990000, 119.990000, 59.990000, 432, 17, 10, 27, 1360, 1496, 37, 3, 1, 33, 513, 516, 0, 0, 0, 0, 0, 1 },
> +{ 1, 1024, 1280, 1280, 1024, 1712, 1060, 1863, 3601, 60.000000, 108.880000, 63.590000, 60.000000, 60.000000, 60.000000, 432, 17, 10, 27, 1360, 1496, 36, 3, 1, 32, 1025, 1028, 0, 0, 0, 0, 1, 0 },
> +{ 1, 1024, 1280, 1280, 1024, 1712, 1060, 1863, 3601, 60.000000, 108.880000, 63.590000, 60.000000, 60.000000, 60.000000, 432, 17, 10, 27, 1360, 1496, 36, 3, 1, 32, 1025, 1028, 0, 0, 0, 0, 0, 0 },
> +{ 1, 768, 1366, 1368, 768, 1800, 412, 930, 4627, 60.000000, 89.900000, 49.500000, 60.000000, 120.000000, 60.000000, 432, 18, 9, 27, 1440, 1584, 28, 3, 1, 24, 385, 388, 0, 0, 0, 0, 1, 1 },
> +{ 1, 768, 1366, 1368, 768, 1800, 412, 930, 4627, 60.000000, 89.900000, 49.500000, 60.000000, 120.000000, 60.000000, 432, 18, 9, 27, 1440, 1584, 28, 3, 1, 24, 385, 388, 0, 0, 0, 0, 0, 1 },
> +{ 1, 768, 1366, 1368, 768, 1800, 795, 1863, 4801, 60.000000, 85.860000, 47.690000, 60.000000, 60.000000, 60.000000, 432, 18, 9, 27, 1440, 1584, 27, 3, 1, 23, 769, 772, 0, 0, 0, 0, 1, 0 },
> +{ 1, 768, 1366, 1368, 768, 1800, 795, 1863, 4801, 60.000000, 85.860000, 47.690000, 60.000000, 60.000000, 60.000000, 432, 18, 9, 27, 1440, 1584, 27, 3, 1, 23, 769, 772, 0, 0, 0, 0, 0, 0 },
> +{ 1, 1050, 1400, 1400, 1050, 1880, 563, 931, 3387, 60.000000, 127.120000, 67.620000, 60.000000, 120.000000, 60.000000, 480, 19, 11, 30, 1488, 1640, 38, 3, 1, 34, 526, 529, 0, 0, 0, 0, 1, 1 },
> +{ 1, 1050, 1400, 1400, 1050, 1880, 563, 931, 3387, 60.000000, 127.120000, 67.620000, 60.000000, 120.000000, 60.000000, 480, 19, 11, 30, 1488, 1640, 38, 3, 1, 34, 526, 529, 0, 0, 0, 0, 0, 1 },
> +{ 1, 1050, 1400, 1400, 1050, 1880, 1087, 1863, 3511, 60.000000, 122.610000, 65.220000, 60.000000, 60.000000, 60.000000, 480, 19, 11, 30, 1488, 1640, 37, 3, 1, 33, 1051, 1054, 0, 0, 0, 0, 1, 0 },
> +{ 1, 1050, 1400, 1400, 1050, 1880, 1087, 1863, 3511, 60.000000, 122.610000, 65.220000, 60.000000, 60.000000, 60.000000, 480, 19, 11, 30, 1488, 1640, 37, 3, 1, 33, 1051, 1054, 0, 0, 0, 0, 0, 0 },
> +{ 1, 900, 1440, 1440, 900, 1920, 483, 931, 3947, 60.000000, 111.390000, 58.200000, 60.000000, 120.000000, 60.000000, 480, 19, 11, 30, 1528, 1680, 33, 3, 1, 29, 451, 454, 0, 0, 0, 0, 1, 1 },
> +{ 1, 900, 1440, 1440, 900, 1920, 483, 931, 3947, 60.000000, 111.390000, 58.200000, 60.000000, 120.000000, 60.000000, 480, 19, 11, 30, 1528, 1680, 33, 3, 1, 29, 451, 454, 0, 0, 0, 0, 0, 1 },
> +{ 1, 900, 1440, 1440, 900, 1904, 932, 1863, 4095, 60.000000, 106.470000, 55.910000, 59.990000, 59.990000, 59.990000, 464, 19, 10, 29, 1520, 1672, 32, 3, 1, 28, 901, 904, 0, 0, 0, 0, 1, 0 },
> +{ 1, 900, 1440, 1440, 900, 1904, 932, 1863, 4095, 60.000000, 106.470000, 55.910000, 59.990000, 59.990000, 59.990000, 464, 19, 10, 29, 1520, 1672, 32, 3, 1, 28, 901, 904, 0, 0, 0, 0, 0, 0 },
> +{ 1, 960, 1440, 1440, 960, 1920, 515, 931, 3702, 60.000000, 118.770000, 61.860000, 60.000000, 120.000000, 60.000000, 480, 19, 11, 30, 1528, 1680, 35, 3, 1, 31, 481, 484, 0, 0, 0, 0, 1, 1 },
> +{ 1, 960, 1440, 1440, 960, 1920, 515, 931, 3702, 60.000000, 118.770000, 61.860000, 60.000000, 120.000000, 60.000000, 480, 19, 11, 30, 1528, 1680, 35, 3, 1, 31, 481, 484, 0, 0, 0, 0, 0, 1 },
> +{ 1, 960, 1440, 1440, 960, 1920, 994, 1863, 3840, 60.000000, 114.500000, 59.630000, 59.990000, 59.990000, 59.990000, 480, 19, 11, 30, 1528, 1680, 34, 3, 1, 30, 961, 964, 0, 0, 0, 0, 1, 0 },
> +{ 1, 960, 1440, 1440, 960, 1920, 994, 1863, 3840, 60.000000, 114.500000, 59.630000, 59.990000, 59.990000, 59.990000, 480, 19, 11, 30, 1528, 1680, 34, 3, 1, 30, 961, 964, 0, 0, 0, 0, 0, 0 },
> +{ 1, 1200, 1600, 1600, 1200, 2160, 644, 931, 2961, 60.000000, 167.500000, 77.330000, 60.000000, 120.000000, 60.000000, 560, 22, 13, 35, 1704, 1880, 44, 3, 1, 40, 601, 604, 0, 0, 0, 0, 1, 1 },
> +{ 1, 1200, 1600, 1600, 1200, 2160, 644, 931, 2961, 60.000000, 167.500000, 77.330000, 60.000000, 120.000000, 60.000000, 560, 22, 13, 35, 1704, 1880, 44, 3, 1, 40, 601, 604, 0, 0, 0, 0, 0, 1 },
> +{ 1, 1200, 1600, 1600, 1200, 2160, 1242, 1863, 3073, 60.000000, 160.960000, 74.520000, 60.000000, 60.000000, 60.000000, 560, 22, 13, 35, 1704, 1880, 42, 3, 1, 38, 1201, 1204, 0, 0, 0, 0, 1, 0 },
> +{ 1, 1200, 1600, 1600, 1200, 2160, 1242, 1863, 3073, 60.000000, 160.960000, 74.520000, 60.000000, 60.000000, 60.000000, 560, 22, 13, 35, 1704, 1880, 42, 3, 1, 38, 1201, 1204, 0, 0, 0, 0, 0, 0 },
> +{ 1, 1050, 1780, 1784, 1050, 2392, 563, 931, 3387, 60.000000, 161.740000, 67.620000, 60.000000, 120.000000, 60.000000, 608, 24, 14, 38, 1896, 2088, 38, 3, 1, 34, 526, 529, 0, 0, 0, 0, 1, 1 },
> +{ 1, 1050, 1780, 1784, 1050, 2392, 563, 931, 3387, 60.000000, 161.740000, 67.620000, 60.000000, 120.000000, 60.000000, 608, 24, 14, 38, 1896, 2088, 38, 3, 1, 34, 526, 529, 0, 0, 0, 0, 0, 1 },
> +{ 1, 1050, 1780, 1784, 1050, 2392, 1087, 1863, 3511, 60.000000, 156.000000, 65.220000, 60.000000, 60.000000, 60.000000, 608, 24, 14, 38, 1896, 2088, 37, 3, 1, 33, 1051, 1054, 0, 0, 0, 0, 1, 0 },
> +{ 1, 1050, 1780, 1784, 1050, 2392, 1087, 1863, 3511, 60.000000, 156.000000, 65.220000, 60.000000, 60.000000, 60.000000, 608, 24, 14, 38, 1896, 2088, 37, 3, 1, 33, 1051, 1054, 0, 0, 0, 0, 0, 0 },
> +
> +{ 1, 1080, 1920, 1920, 1080, 2576, 1118, 1863, 3414, 60.000000, 172.790000, 67.800000, 60.000000, 60.000000, 60.000000, 656, 26, 15, 41, 2040, 2248, 38, 3, 1, 34, 1081, 1084, 0, 0, 0, 0, 1, 0 },
> +
> +{ 1, 1080, 1920, 1920, 1080, 2576, 1118, 1863, 3414, 60.000000, 172.790000, 67.800000, 60.000000, 60.000000, 60.000000, 656, 26, 15, 41, 2040, 2248, 38, 3, 1, 34, 1081, 1084, 0, 0, 0, 0, 0, 0 },
> +
> +{ 1, 1080, 1920, 1920, 1080, 2576, 1118, 1863, 3414, 60.000000, 172.790000, 67.800000, 60.000000, 60.000000, 60.000000, 656, 26, 15, 41, 2040, 2248, 38, 3, 1, 34, 1081, 1084, 0, 0, 0, 0, 0, 0 },
> +
> +{ 1, 1080, 1920, 1920, 1080, 2576, 1118, 1863, 3414, 60.000000, 172.790000, 67.800000, 60.000000, 60.000000, 60.000000, 656, 26, 15, 41, 2040, 2248, 38, 3, 1, 34, 1081, 1084, 0, 0, 0, 0, 1, 0 },
> +
> +{ 1, 1080, 1920, 1920, 1080, 2576, 579, 931, 3293, 60.000000, 179.130000, 69.540000, 60.000000, 120.000000, 60.000000, 656, 26, 15, 41, 2040, 2248, 39, 3, 1, 35, 541, 544, 0, 0, 0, 0, 0, 1 },
> +
> +{ 1, 1080, 1920, 1920, 1080, 2576, 579, 931, 3293, 60.000000, 179.130000, 69.540000, 60.000000, 120.000000, 60.000000, 656, 26, 15, 41, 2040, 2248, 39, 3, 1, 35, 541, 544, 0, 0, 0, 0, 1, 1 },
> +
> +{ 2, 350, 640, 640, 350, 832, 445, 1314, 6049, 85.000000, 31.500000, 37.861000, 85.080000, 85.000000, 85.000000, 192, 64, 32, 96, 672, 736, 95, 3, 32, 60, 382, 385, 0, 0, 0, 0, 0, 0 },
> +{ 2, 400, 640, 640, 400, 832, 445, 1314, 6049, 85.000000, 31.500000, 37.861000, 85.080000, 85.000000, 85.000000, 192, 32, 64, 96, 704, 736, 45, 3, 1, 41, 401, 404, 0, 0, 0, 0, 0, 0 },
> +{ 2, 480, 640, 640, 480, 800, 525, 1865, 7278, 60.000000, 25.175000, 31.429000, 59.940000, 60.000000, 60.000000, 144, 96, 8, 40, 656, 752, 29, 2, 2, 25, 490, 492, 0, 0, 0, 0, 0, 0 },
> +{ 2, 480, 640, 640, 480, 832, 520, 1536, 6049, 72.000000, 31.500000, 37.861000, 72.809000, 72.000000, 72.000000, 176, 40, 16, 120, 664, 704, 24, 3, 1, 20, 489, 492, 0, 0, 0, 0, 0, 0 },
> +{ 2, 480, 640, 640, 480, 840, 500, 1491, 6107, 75.000000, 31.500000, 37.500000, 75.000000, 75.000000, 75.000000, 200, 64, 16, 120, 656, 720, 20, 3, 1, 16, 481, 484, 0, 0, 0, 0, 0, 0 },
> +{ 2, 480, 640, 640, 480, 832, 509, 1315, 5293, 85.000000, 36.000000, 43.269000, 85.008000, 85.000000, 85.000000, 192, 56, 56, 80, 696, 752, 29, 3, 1, 25, 481, 484, 0, 0, 0, 0, 0, 0 },
> +{ 2, 400, 720, 720, 400, 936, 446, 1315, 6038, 85.000000, 35.500000, 37.927000, 85.039000, 85.000000, 85.000000, 216, 72, 36, 108, 756, 828, 46, 3, 1, 42, 401, 404, 0, 0, 0, 0, 0, 0 },
> +{ 2, 480, 720, 720, 480, 858, 525, 1863, 7271, 60.000000, 27.027000, 31.500000, 60.000000, 60.000000, 60.000000, 138, 67, 22, 49, 742, 809, 45, 3, 3, 39, 483, 486, 0, 0, 0, 0, 0, 0 },
> +{ 2, 480, 720, 720, 480, 858, 525, 0, 0, 30.000000, 13.514000, 15.750000, 30.000000, 60.000000, 30.000000, 138, 64, 20, 54, 740, 804, 45, 3, 3, 39, 483, 486, 0, 0, 0, 0, 0, 1 },
> +{ 2, 480, 720, 720, 480, 900, 525, 932, 7278, 29.969999, 28.322000, 31.469000, 29.970000, 59.939999, 29.969999, 180, 108, 18, 54, 738, 846, 45, 2, 10, 33, 490, 492, 0, 0, 0, 0, 0, 1 },
> +{ 2, 487, 720, 720, 487, 858, 525, 1865, 14556, 29.969999, 13.500000, 15.734000, 29.970000, 59.939999, 29.969999, 138, 56, 18, 64, 738, 794, 38, 3, 2, 33, 489, 492, 0, 0, 0, 0, 0, 1 },
> +{ 2, 576, 720, 720, 576, 864, 625, 2236, 14658, 25.000000, 13.500000, 15.625000, 25.000000, 50.000000, 25.000000, 144, 56, 18, 70, 738, 794, 49, 3, 2, 44, 578, 581, 0, 0, 0, 0, 0, 1 },
> +{ 2, 600, 800, 800, 600, 1056, 628, 1854, 6046, 60.000000, 40.000000, 37.879000, 60.317000, 60.000000, 60.000000, 256, 128, 40, 88, 840, 968, 28, 4, 1, 23, 601, 605, 0, 0, 0, 0, 0, 0 },
> +{ 2, 600, 800, 800, 600, 1040, 666, 1549, 4764, 72.000000, 50.000000, 48.077000, 72.188000, 72.000000, 72.000000, 240, 120, 56, 64, 856, 976, 66, 6, 37, 23, 637, 643, 0, 0, 0, 0, 0, 0 },
> +{ 2, 600, 800, 800, 600, 1056, 625, 1491, 4886, 75.000000, 49.500000, 46.875000, 75.000000, 75.000000, 75.000000, 256, 80, 16, 160, 816, 896, 25, 3, 1, 21, 637, 640, 0, 0, 0, 0, 0, 0 },
> +{ 2, 600, 800, 800, 600, 1048, 631, 1314, 4267, 85.000000, 56.250000, 53.674000, 85.061000, 85.000000, 85.000000, 248, 64, 32, 152, 832, 896, 31, 3, 1, 27, 601, 604, 0, 0, 0, 0, 0, 0 },
> +{ 2, 768, 1024, 1024, 768, 1344, 806, 1863, 4735, 60.000000, 65.000000, 48.363000, 60.004000, 60.000000, 60.000000, 320, 136, 24, 160, 1048, 1184, 38, 6, 3, 29, 771, 777, 0, 0, 0, 0, 0, 0 },
> +{ 2, 768, 1024, 1024, 768, 1264, 817, 1286, 6447, 43.480000, 44.900000, 35.522000, 43.479000, 86.959999, 43.480000, 240, 176, 8, 56, 1032, 1208, 49, 4, 0, 45, 768, 772, 0, 0, 0, 0, 0, 1 },
> +{ 2, 768, 1024, 1024, 768, 1328, 806, 1596, 4055, 70.000000, 75.000000, 56.476000, 70.069000, 70.000000, 70.000000, 304, 136, 24, 144, 1048, 1184, 38, 6, 3, 29, 771, 777, 0, 0, 0, 0, 0, 0 },
> +{ 2, 768, 1024, 1024, 768, 1312, 800, 1490, 3815, 75.000000, 78.750000, 60.023000, 75.029000, 75.000000, 75.000000, 288, 96, 16, 176, 1040, 1136, 32, 3, 1, 28, 769, 772, 0, 0, 0, 0, 0, 0 },
> +{ 2, 768, 1024, 1024, 768, 1376, 808, 1315, 3335, 85.000000, 94.500000, 68.667000, 84.997000, 85.000000, 85.000000, 352, 96, 12, 208, 1072, 1168, 40, 3, 1, 36, 769, 772, 0, 0, 0, 0, 0, 0 },
> +{ 2, 864, 1152, 1152, 864, 1600, 900, 1491, 3393, 75.000000, 108.000000, 67.500000, 75.000000, 75.000000, 75.000000, 448, 128, 64, 256, 1216, 1344, 36, 3, 1, 32, 865, 868, 0, 0, 0, 0, 0, 0 },
> +{ 2, 720, 1280, 1280, 720, 1650, 750, 1863, 5089, 60.000000, 74.250000, 45.000000, 60.000000, 60.000000, 60.000000, 370, 80, 70, 220, 1350, 1430, 30, 5, 0, 25, 720, 725, 0, 0, 0, 0, 0, 0 },
> +{ 2, 720, 1280, 1280, 720, 1650, 750, 1865, 5094, 59.939999, 74.176000, 44.955000, 59.940000, 59.939999, 59.939999, 370, 40, 110, 220, 1390, 1430, 30, 5, 5, 20, 725, 730, 0, 0, 0, 0, 0, 0 },
> +{ 2, 720, 1280, 1280, 720, 1980, 750, 2236, 6107, 50.000000, 74.250000, 37.500000, 50.000000, 50.000000, 50.000000, 700, 40, 440, 220, 1720, 1760, 30, 5, 5, 20, 725, 730, 0, 0, 0, 0, 0, 0 },
> +{ 2, 960, 1280, 1280, 960, 1800, 1000, 1863, 3817, 60.000000, 108.000000, 60.000000, 60.000000, 60.000000, 60.000000, 520, 112, 96, 312, 1376, 1488, 40, 3, 1, 36, 961, 964, 0, 0, 0, 0, 0, 0 },
> +{ 2, 960, 1280, 1280, 960, 1728, 1011, 1315, 2665, 85.000000, 148.500000, 85.938000, 85.002000, 85.000000, 85.000000, 448, 160, 64, 224, 1344, 1504, 51, 3, 1, 47, 961, 964, 0, 0, 0, 0, 0, 0 },
> +{ 2, 1024, 1280, 1280, 1024, 1688, 1066, 1863, 3579, 60.000000, 108.000000, 63.981000, 60.020000, 60.000000, 60.000000, 408, 112, 48, 248, 1328, 1440, 42, 3, 1, 38, 1025, 1028, 0, 0, 0, 0, 0, 0 },
> +{ 2, 1024, 1280, 1280, 1024, 1688, 1066, 1490, 2863, 75.000000, 135.000000, 79.976000, 75.025000, 75.000000, 75.000000, 408, 144, 16, 248, 1296, 1440, 42, 3, 1, 38, 1025, 1028, 0, 0, 0, 0, 0, 0 },
> +{ 2, 1024, 1280, 1280, 1024, 1728, 1072, 1315, 2512, 85.000000, 157.500000, 91.146000, 85.024000, 85.000000, 85.000000, 448, 160, 64, 224, 1344, 1504, 48, 3, 1, 44, 1025, 1028, 0, 0, 0, 0, 0, 0 },
> +{ 2, 1200, 1600, 1600, 1200, 2160, 1250, 1863, 3053, 60.000000, 162.000000, 75.000000, 60.000000, 60.000000, 60.000000, 560, 192, 64, 304, 1664, 1856, 50, 3, 1, 46, 1201, 1204, 0, 0, 0, 0, 0, 0 },
> +{ 2, 1200, 1600, 1600, 1200, 2160, 1250, 1725, 2827, 65.000000, 175.000000, 81.250000, 65.000000, 65.000000, 65.000000, 560, 192, 64, 304, 1664, 1856, 50, 3, 1, 46, 1201, 1204, 0, 0, 0, 0, 0, 0 },
> +{ 2, 1200, 1600, 1600, 1200, 2160, 1250, 1597, 2617, 70.000000, 189.000000, 87.500000, 70.000000, 70.000000, 70.000000, 560, 192, 64, 304, 1664, 1856, 50, 3, 1, 46, 1201, 1204, 0, 0, 0, 0, 0, 0 },
> +{ 2, 1200, 1600, 1600, 1200, 2160, 1250, 1491, 2443, 75.000000, 202.500000, 93.750000, 75.000000, 75.000000, 75.000000, 560, 192, 64, 304, 1664, 1856, 50, 3, 1, 46, 1201, 1204, 0, 0, 0, 0, 0, 0 },
> +{ 2, 1200, 1600, 1600, 1200, 2160, 1250, 1315, 2155, 85.000000, 229.500000, 106.250000, 85.000000, 85.000000, 85.000000, 560, 192, 64, 304, 1664, 1856, 50, 3, 1, 46, 1201, 1204, 0, 0, 0, 0, 0, 0 },
> +{ 2, 1050, 1680, 1680, 1050, 2240, 1089, 1865, 3508, 59.950001, 146.250000, 65.290000, 59.954000, 59.950001, 59.950001, 560, 176, 104, 280, 1784, 1960, 39, 6, 3, 30, 1053, 1059, 0, 0, 0, 0, 0, 0 },
> +{ 2, 1080, 1920, 1920, 1080, 2200, 1125, 3727, 6786, 30.000000, 74.250000, 33.750000, 30.000000, 30.000000, 30.000000, 280, 44, 88, 148, 2008, 2052, 45, 5, 3, 37, 1083, 1088, 0, 0, 0, 0, 0, 0 },
> +{ 2, 1080, 1920, 1920, 1080, 2200, 1125, 1863, 6786, 30.000000, 74.250000, 33.750000, 30.000000, 60.000000, 30.000000, 280, 88, 44, 148, 1964, 2052, 45, 5, 2, 38, 1082, 1087, 0, 0, 0, 0, 0, 1 },
> +{ 2, 1080, 1920, 1920, 1080, 2200, 1125, 3731, 6793, 29.969999, 74.176000, 33.716000, 29.970000, 29.969999, 29.969999, 280, 44, 88, 148, 2008, 2052, 45, 5, 3, 37, 1083, 1088, 0, 0, 0, 0, 0, 0 },
> +{ 2, 1080, 1920, 1920, 1080, 2640, 1125, 4473, 8143, 25.000000, 74.250000, 28.125000, 25.000000, 25.000000, 25.000000, 720, 44, 528, 148, 2448, 2492, 45, 5, 4, 36, 1084, 1089, 0, 0, 0, 0, 0, 0 },
> +{ 2, 1080, 1920, 1920, 1080, 2750, 1125, 2329, 8482, 24.000000, 74.250000, 27.000000, 24.000000, 48.000000, 24.000000, 830, 88, 594, 148, 2514, 2602, 45, 5, 2, 38, 1082, 1087, 0, 0, 0, 0, 0, 1 },
> +{ 2, 1080, 1920, 1920, 1080, 2200, 1125, 1865, 6793, 29.969999, 74.176000, 33.716000, 29.970000, 59.939999, 29.969999, 280, 44, 88, 148, 2008, 2052, 45, 5, 2, 38, 1082, 1087, 0, 0, 0, 0, 0, 1 },
> +{ 2, 1080, 1920, 1920, 1080, 2640, 1125, 2236, 8143, 25.000000, 74.250000, 28.125000, 25.000000, 50.000000, 25.000000, 720, 88, 528, 104, 2448, 2536, 45, 5, 2, 38, 1082, 1087, 0, 0, 0, 0, 0, 1 },
> +{ 2, 1080, 1920, 1920, 1080, 2750, 1125, 2332, 8491, 23.000000, 74.176000, 26.973000, 23.000000, 46.000000, 23.000000, 830, 44, 638, 148, 2558, 2602, 45, 5, 2, 38, 1082, 1087, 0, 0, 0, 0, 0, 1 },
> +};

Please, don't use floating point in Kernel space. Also, the DV API specifies frequencies
using integers.

See, for example, how the last timing line is represented:

$ git grep V4L2_DV_720P59_94 include/linux/ drivers/media/
drivers/media/platform/s5p-tv/hdmi_drv.c: { V4L2_DV_720P59_94, &hdmi_timings_720p60 },
drivers/media/platform/s5p-tv/hdmiphy_drv.c:              [V4L2_DV_720P59_94] =  74176000,
drivers/media/v4l2-core/v4l2-common.c:            { 1280, 720, "720p@59.94" },    /* V4L2_DV_720P59_94 */
include/linux/videodev2.h:#define         V4L2_DV_720P59_94       7 /* SMPTE 274M */

> +
> +static struct vga_timing_t *vc8x0_vga_lookup(int mode,
> +	u32 width, u32 height, u32 interlaced)
> +{
> +	struct vga_timing_t *vt;
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(vga_timings); i++) {
> +		vt = &vga_timings[i];
> +		if (
> +			(vt->timing_mode == mode) &&
> +			(vt->spec_width == width) &&
> +			(vt->spec_height == height) &&
> +			(vt->interlaced == interlaced)
> +		) {
> +			return &vga_timings[i];
> +		}
> +	}
> +
> +	return 0;
> +}
> +#if 0
> +static void vc8x0_vga_dump(struct vga_timing_t *m)
> +{
> +	dprintk(0, "%s(%p)\n", __func__, m);
> +	dprintk(0, "timing_mode = %d\n", m->timing_mode);
> +	dprintk(0, "spec_height = %d\n", m->spec_height);
> +	dprintk(0, "spec_width = %d\n", m->spec_width);
> +	dprintk(0, "active_pixels = %d\n", m->active_pixels);
> +	dprintk(0, "active_lines = %d\n", m->active_lines);
> +	dprintk(0, "total_pixels = %d\n", m->total_pixels);
> +	dprintk(0, "total_lines = %d\n", m->total_lines);
> +	dprintk(0, "fcl = %d\n", m->fcl);
> +	dprintk(0, "bl = %d\n", m->bl);
> +	dprintk(0, "h_blanking (sav) = %d\n", m->h_blanking);
> +}
> +#endif
> +static struct vga_rate_t vga_rates[] = {
> +	/* FCL	FCL		FCL	FIELD				*/
> +	/* MIN	NOM		MAX	10M	FPS100	FPS099	RATE	*/
> +	{ 1854,	/*1866*/	1872,	166833,	6000,	5994,	ADV7441A_FRAMERATE_60, },
> +	{ 2230,	/*2237*/	2245,	200000,	5000,	5000,	ADV7441A_FRAMERATE_50, },
> +	{ 3720,	/*3732*/	3740,	333667,	3000,	2997,	ADV7441A_FRAMERATE_30, },
> +	{ 4460,	/*4474*/	4490,	400000,	2500,	2500,	ADV7441A_FRAMERATE_25, },
> +
> +	/* 23.976 */
> +	{ 4650,	/*4665*/	4680,	417083,	2400,	2398,	ADV7441A_FRAMERATE_24, },
> +};
> +
> +static struct vga_rate_t *vc8x0_vga_HdGetRate(u32 fcl28)
> +{
> +	int i;
> +	struct vga_rate_t *ret = 0;
> +
> +	for (i = 0; i < ARRAY_SIZE(vga_rates); i++) {
> +		if ((fcl28 >= vga_rates[i].fcl_min) &&
> +			(fcl28 <= vga_rates[i].fcl_max)) {
> +			ret = &vga_rates[i];
> +			break;
> +		}
> +	}
> +
> +	return ret;
> +}
> +
> +static struct vga_size_t vga_sizes[] = {
> +	{  260,  265,  720, {  240, 240 }, 1, }, /* 525i  4x1 CP */
> +	{  310,  315,  720, {  288, 288 }, 1, }, /* 625i  4x1 CP */
> +	{  523,  527,  720, {  483,   0 }, 0, }, /* 525p  2x1 */
> +	{  623,  626,  720, {  576,   0 }, 0, }, /* 625p  2x1 */
> +	{  627,  628,  800, {  600,   0 }, 0, }, /* 800 x 600 */
> +	{  745,  752, 1280, {  720,   0 }, 0, }, /* 720p 1x1 */
> +	{  795,  800, 1400, { 1050,   0 }, 0, }, /* 1400 x 1050 */
> +	{  803,  806, 1024, {  768,   0 }, 0, }, /* 1024 x 768 */
> +	{  560,  565, 1920, {  540, 540 }, 1, }, /* 1080i 1x1 */
> +	{  925,  932, 1440, {  900,   0 }, 0, }, /* 1440 x 900p */
> +	{  990, 1005, 1280, {  960,   0 }, 0, }, /* 1280 x 960 */
> +	{ 1062, 1066, 1280, { 1024,   0 }, 0, }, /* 1280 x 1024 */
> +	{ 1084, 1087, 1400, { 1050,   0 }, 0, }, /* 1400 x 1050 */
> +	{ 1116, 1127, 1920, { 1080,   0 }, 0, }, /* 1080p 1x1 */
> +	{ 1246, 1252, 1600, { 1200,   0 }, 0, }, /* 1600 x 1200p */
> +};
> +
> +static struct vga_size_t *vc8x0_vga_HdGetSize(u32 lcf)
> +{
> +	int i;
> +	struct vga_size_t *ret = 0;
> +
> +	for (i = 0; i < ARRAY_SIZE(vga_sizes); i++) {
> +		if ((lcf >= vga_sizes[i].lcf_min) &&
> +			(lcf <= vga_sizes[i].lcf_max)) {
> +			ret = &vga_sizes[i];
> +			break;
> +		}
> +	}
> +
> +	return ret;
> +}

None of the above seems to be compliant with the timings API. Please, re-define it
according to it, in order to expose it using the right way. I won't comment more
about the timings API, but there are more related stuff below.

> +
> +/* Helpers */
> +static int adv7441a_detect(struct adv7441a_state *state);
> +
> +static inline struct adv7441a_state *to_state(struct v4l2_subdev *sd)
> +{
> +	return container_of(sd, struct adv7441a_state, sd);
> +}
> +
> +static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl *ctrl)
> +{
> +	return &container_of(ctrl->handler, struct adv7441a_state, hdl)->sd;
> +}
> +
> +static struct adv7441a_format *find_format(struct adv7441a_state *state, u32 id)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(formats); i++) {
> +		if (formats[i].id == id) {
> +			return formats + i;
> +		}
> +	}
> +	return 0;
> +}
> +
> +/* for the given input params, try to find a matching supported driver rate */
> +static struct adv7441a_format *
> +vc8x0_video_find_format(struct adv7441a_state *state,
> +	u32 pixelformat, u32 width, u32 height, u32 flags, u32 rate)
> +{
> +	unsigned int i;
> +	dprintk(1, "%s(%x, %d, %d, %d, rate=%d)\n", __func__, pixelformat,
> +		width, height, flags, rate);
> +
> +	for (i = 0; i < ARRAY_SIZE(formats); i++) {
> +#if 0
> +		if (video_1080p && (formats[i].id ==
> +			ADV7441A_FORMAT_1920x1080i60))
> +			continue;
> +		if (video_1080p && (formats[i].id ==
> +			ADV7441A_FORMAT_1920x1080i50))
> +			continue;
> +
> +		/* Skip any formats not comatible with the users selected
> +		 * cable input type. This will prevent us from selecting an
> +		 * HDMI format for 1920x1080 when the caller is selecting
> +		 * VGA for example.
> +		 */
> +		if (vc8x0_video_is_input_compatible(state->video_input_nr,
> +			&formats[i]) == 0)
> +			continue;
> +#endif
> +
> +		if ((formats[i].fourcc == pixelformat) &&
> +			(formats[i].width == width) &&
> +			(formats[i].height == height) &&
> +			(formats[i].flags == flags) &&
> +			(formats[i].frate == rate)
> +		) {
> +			return formats + i;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +/* I2C Access */
> +/* 8 bit registers, 8 bit values */
> +static int i2c_write(struct adv7441a_state *state,
> +	struct i2c_client *client,
> +	u8 addr, u8 reg, u8 data)
> +{
> +	int ret;
> +	u8 buf[] = { reg, data };
> +
> +	struct i2c_msg msg = {
> +		.addr  = addr,
> +		.flags = 0,
> +		.buf   = buf,
> +		.len   = 2
> +	};
> +
> +	ret = i2c_transfer(client->adapter, &msg, 1);
> +
> +	if (ret != 1) {
> +		pr_err("%s() writereg error, ret = %d\n",
> +			__func__, ret);
> +		pr_err("%s() 0x%02x 0x%02x 0x%02x\n",
> +			__func__, addr, reg, data);
> +	}
> +
> +	return (ret != 1) ? -1 : 0;
> +}
> +
> +static u8 i2c_read(struct adv7441a_state *state,
> +	struct i2c_client *client, u8 addr, u8 reg, u8 *val)
> +{
> +	int ret;
> +	u8 b0[] = { reg };
> +	u8 b1 = 0;
> +
> +	struct i2c_msg msg[] = {
> +		{ .addr = addr, .flags = 0, .buf = b0, .len = 1 },
> +		{ .addr = addr, .flags = I2C_M_RD, .buf = &b1, .len = 1 }
> +	};
> +
> +	ret = i2c_transfer(client->adapter, msg, 2);
> +
> +	if (ret != 2)
> +		printk(KERN_ERR "%s: readreg error (ret == %i)\n",
> +			__func__, ret);
> +
> +	*val = b1;
> +	return 1;
> +}
> +
> +static void adv7441a_unregister_clients(struct adv7441a_state *state)
> +{
> +	if (state->usermap_client) {
> +		i2c_unregister_device(state->usermap_client);
> +		state->usermap_client = 0;
> +	}
> +	if (state->user1map_client) {
> +		i2c_unregister_device(state->user1map_client);
> +		state->user1map_client = 0;
> +	}
> +	if (state->user2map_client) {
> +		i2c_unregister_device(state->user2map_client);
> +		state->user2map_client = 0;
> +	}
> +	if (state->user3map_client) {
> +		i2c_unregister_device(state->user3map_client);
> +		state->user3map_client = 0;
> +	}
> +	if (state->reservedmap_client) {
> +		i2c_unregister_device(state->reservedmap_client);
> +		state->reservedmap_client = 0;
> +	}
> +	if (state->hdmimap_client) {
> +		i2c_unregister_device(state->hdmimap_client);
> +		state->hdmimap_client = 0;
> +	}
> +	if (state->rksvmap_client) {
> +		i2c_unregister_device(state->rksvmap_client);
> +		state->rksvmap_client = 0;
> +	}
> +	if (state->edidmap_client) {
> +		i2c_unregister_device(state->edidmap_client);
> +		state->edidmap_client = 0;
> +	}
> +}
> +
> +static int adv7441a_i2c_usermap_read8(struct adv7441a_state *state,
> +	u8 reg, u8 *val)
> +{
> +	i2c_read(state, state->usermap_client,
> +		state->usermap_addr, reg, val);
> +	return 1;
> +}
> +
> +static int adv7441a_i2c_usermap_write8(struct adv7441a_state *state,
> +	u8 reg, u8 val)
> +{
> +	int ret;
> +	ret = i2c_write(state, state->usermap_client,
> +		state->usermap_addr, reg, val);
> +	return ret;
> +}
> +
> +static int adv7441a_i2c_usermap_setbit(struct adv7441a_state *state,
> +	u8 reg, u8 bitmask)
> +{
> +	unsigned char val;
> +	adv7441a_i2c_usermap_read8(state, reg, &val);
> +	val |= bitmask;
> +	return adv7441a_i2c_usermap_write8(state, reg, val);
> +}
> +
> +static int adv7441a_i2c_user1map_read8(struct adv7441a_state *state,
> +	u8 reg, u8 *val)
> +{
> +	int ret;
> +	ret = i2c_read(state, state->user1map_client,
> +		state->user1map_addr, reg, val);
> +	return ret;
> +}
> +
> +static int adv7441a_i2c_user1map_write8(struct adv7441a_state *state,
> +	u8 reg, u8 val)
> +{
> +	int ret;
> +	ret = i2c_write(state, state->user1map_client,
> +		state->user1map_addr, reg, val);
> +	return ret;
> +}
> +
> +static int adv7441a_i2c_user1map_setbit(struct adv7441a_state *state,
> +	u8 reg, u8 bitmask)
> +{
> +	unsigned char val;
> +	adv7441a_i2c_user1map_read8(state, reg, &val);
> +	val |= bitmask;
> +	return adv7441a_i2c_user1map_write8(state, reg, val);
> +}
> +
> +static int adv7441a_i2c_user2map_write8(struct adv7441a_state *state,
> +	u8 reg, u8 val)
> +{
> +	int ret;
> +	ret = i2c_write(state, state->user2map_client,
> +		state->user2map_addr, reg, val);
> +	return ret;
> +}
> +
> +static int adv7441a_i2c_hdmimap_read8(struct adv7441a_state *state,
> +	u8 reg, u8 *val)
> +{
> +	int ret;
> +	ret = i2c_read(state, state->hdmimap_client,
> +		state->hdmimap_addr, reg, val);
> +	return ret;
> +}
> +
> +static int adv7441a_i2c_hdmimap_write8(struct adv7441a_state *state,
> +	u8 reg, u8 val)
> +{
> +	int ret;
> +	ret = i2c_write(state, state->hdmimap_client,
> +		state->hdmimap_addr, reg, val);
> +	return ret;
> +}
> +
> +static int adv7441a_i2c_hdmimap_setbit(struct adv7441a_state *state,
> +	u8 reg, u8 bitmask)
> +{
> +	unsigned char val;
> +	adv7441a_i2c_usermap_read8(state, reg, &val);
> +	val |= bitmask;
> +	return adv7441a_i2c_hdmimap_write8(state, reg, val);
> +}
> +
> +static int adv7441a_i2c_edidmap_write8(struct adv7441a_state *state,
> +	u8 reg, u8 val)
> +{
> +	int ret;
> +	ret = i2c_write(state, state->edidmap_client,
> +		state->edidmap_addr, reg, val);
> +	return ret;
> +}
> +
> +static int adv7441a_i2c_rksvmap_write8(struct adv7441a_state *state,
> +	u8 reg, u8 val)
> +{
> +	int ret;
> +	ret = i2c_write(state, state->rksvmap_client,
> +		state->rksvmap_addr, reg, val);
> +	return ret;
> +}
> +
> +static int adv7441a_sw_reset(struct adv7441a_state *state)
> +{
> +	/* Put the chip into s/w reset */
> +	adv7441a_i2c_usermap_write8(state, 0x0F, 0x80);
> +	msleep(20);
> +
> +	return 0;
> +}
> +
> +/* Per resolution / format configuration settings */
> +static int adv7441a_CVBS_720x480ix60(struct adv7441a_state *state,
> +	int n)
> +{
> +	u8 reg;
> +	dprintk(1, "%s(%d)\n", __func__, n);
> +
> +	if (n == 1)
> +		reg = 0x00; /* CVBS on AIN1 (Green) */
> +	else
> +	if (n == 2)
> +		reg = 0x02; /* CVBS on AIN3 (Red) */
> +	else
> +	if (n == 3)
> +		reg = 0x01; /* CVBS on AIN2 (Blue) */
> +	else
> +		BUG();
> +
> +	adv7441a_i2c_usermap_write8(state, 0x69, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0x00, reg);
> +	adv7441a_i2c_usermap_write8(state, 0xc3, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0xc4, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0x3a, 0x07);
> +	adv7441a_i2c_usermap_write8(state, 0xf3, 0x01);
> +
> +	adv7441a_i2c_usermap_write8(state, 0x03, 0x85);
> +	adv7441a_i2c_usermap_write8(state, 0x04, 0x5c);
> +	adv7441a_i2c_usermap_write8(state, 0x05, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0x06, 0x02);
> +	adv7441a_i2c_usermap_write8(state, 0x17, 0x41);
> +	adv7441a_i2c_usermap_write8(state, 0x1d, 0x40);
> +	adv7441a_i2c_usermap_write8(state, 0x31, 0x10);
> +	adv7441a_i2c_usermap_write8(state, 0x34, 0x01);
> +	adv7441a_i2c_usermap_write8(state, 0x35, 0x22);
> +	adv7441a_i2c_usermap_write8(state, 0x37, 0xa1);
> +	adv7441a_i2c_usermap_write8(state, 0x6b, 0xf1);
> +	adv7441a_i2c_usermap_write8(state, 0x86, 0x0b);
> +	adv7441a_i2c_usermap_write8(state, 0x8f, 0x50);
> +	adv7441a_i2c_usermap_write8(state, 0x90, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0x0c, 0x00);

While it is ok to keep it as-is, I would store all those per-timings attribute into some
table, in order to simplify the code.

> +
> +	return 0;
> +}
> +
> +static int adv7441a_SVIDEO_720x480ix60(struct adv7441a_state *state)
> +{
> +	dprintk(1, "%s()\n", __func__);
> +
> +	/* Y on AIN1 (Green) */
> +	/* C on AIN3 (Red) */
> +
> +	adv7441a_i2c_usermap_write8(state, 0x69, 0x02);
> +	adv7441a_i2c_usermap_write8(state, 0x00, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0xc3, 0x31);
> +	adv7441a_i2c_usermap_write8(state, 0xc4, 0xc0);
> +	adv7441a_i2c_usermap_write8(state, 0x3a, 0x03);
> +	adv7441a_i2c_usermap_write8(state, 0xf3, 0x00);
> +
> +	adv7441a_i2c_usermap_write8(state, 0x03, 0x85);
> +	adv7441a_i2c_usermap_write8(state, 0x04, 0x5c);
> +	adv7441a_i2c_usermap_write8(state, 0x05, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0x06, 0x02);
> +	adv7441a_i2c_usermap_write8(state, 0x17, 0x41);
> +	adv7441a_i2c_usermap_write8(state, 0x1d, 0x40);
> +	adv7441a_i2c_usermap_write8(state, 0x31, 0x10);
> +	adv7441a_i2c_usermap_write8(state, 0x34, 0x01);
> +	adv7441a_i2c_usermap_write8(state, 0x35, 0x22);
> +	adv7441a_i2c_usermap_write8(state, 0x37, 0xa1);
> +	adv7441a_i2c_usermap_write8(state, 0x6b, 0xf1);
> +	adv7441a_i2c_usermap_write8(state, 0x86, 0x0b);
> +	adv7441a_i2c_usermap_write8(state, 0x8f, 0x50);
> +	adv7441a_i2c_usermap_write8(state, 0x90, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0x0c, 0x00);
> +
> +	return 0;
> +}
> +#if 0
> +static int adv7441a_UXGA_1600x1200x60(struct adv7441a_state *state,
> +	struct v4l2_dv_timings *timing)
> +{
> +	u32 ushtotal, frll, lines, sav = 488, eav = 2094;
> +	u8 reg;
> +
> +	state->vga_timing_mode = vc8x0_vga_lookup(
> +		2, /* DMT */
> +		fmt->width,
> +		fmt->height,
> +		fmt->flags == ADV7441A_FORMAT_INTERLACED ? 1 : 0);
> +	if (state->vga_timing_mode)
> +		vc8x0_vga_dump(state->vga_timing_mode);
> +
> +	if (!state->vga_timing_mode) {
> +		pr_err("%s() unable to locate fmt->id %d [%s] in the timing table\n",
> +			__func__, fmt->id, fmt->name);
> +		return -ENODEV;
> +	}
> +
> +	ushtotal = state->vga_timing_mode->total_pixels;
> +	frll = state->vga_timing_mode->bl >> 3;
> +	lines = state->vga_timing_mode->total_lines;
> +	lines--;
> +
> +	dprintk(1, "%s(ushtotal = %d, frll = %d, lines = %d, bl = %d)\n",
> +		__func__, ushtotal, frll, lines,
> +		state->vga_timing_mode->bl);
> +
> +	/* Basic input settings */
> +	adv7441a_i2c_usermap_write8(state, 0x69, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0x00, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0xc3, 0x31);
> +	adv7441a_i2c_usermap_write8(state, 0xc4, 0xc2);
> +	adv7441a_i2c_usermap_write8(state, 0x3a, 0x01);
> +	adv7441a_i2c_usermap_write8(state, 0xf3, 0x00);
> +
> +	/* Auto Mode */
> +	adv7441a_i2c_usermap_write8(state, 0x03, 0x85);
> +	adv7441a_i2c_usermap_write8(state, 0x04, 0x5c);
> +	adv7441a_i2c_usermap_write8(state, 0x05, 0x02);
> +	adv7441a_i2c_usermap_write8(state, 0x06, 0x02);
> +	adv7441a_i2c_usermap_write8(state, 0x0c, 0x0c);
> +	adv7441a_i2c_usermap_write8(state, 0x1d, 0x40);
> +	adv7441a_i2c_usermap_write8(state, 0x37, 0xa1);
> +	adv7441a_i2c_usermap_write8(state, 0x3c, 0xa8);
> +	adv7441a_i2c_usermap_write8(state, 0x47, 0x0a);
> +	adv7441a_i2c_usermap_write8(state, 0x68, 0xf0);
> +	adv7441a_i2c_usermap_write8(state, 0x6b, 0xf3);
> +	adv7441a_i2c_usermap_write8(state, 0x7b, 0x07);
> +	adv7441a_i2c_usermap_write8(state, 0x86, 0x0b);
> +	adv7441a_i2c_usermap_write8(state, 0xc9, 0x04);
> +	adv7441a_i2c_usermap_write8(state, 0xba, 0xa3);
> +
> +	/* ADV7441 HW RevJ Page 190 Section 9.15 */
> +
> +	/* PLL_DIV_MAN_EN */
> +	/* PLL_DIV_RATIO */
> +	reg = 0xe0 | ((ushtotal & 0xfff) >> 8);
> +	pr_err("87 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x87, reg);
> +
> +	reg = ushtotal & 0xff;
> +	pr_err("88 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x88, reg);
> +
> +	/* FR_LL */
> +	reg = 0x70 | ((frll & 0x7ff) >> 8);
> +	pr_err("8f = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x8f, reg);
> +
> +	reg = frll & 0xff;
> +	pr_err("90 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x90, reg);
> +
> +	/* LCOUNT_MAX */
> +	reg = (lines & 0xfff) >> 4;
> +	pr_err("ab = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xab, reg);
> +	reg = (lines & 0x00f) << 4;
> +	pr_err("ac = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xac, reg);
> +
> +	/* INTERLACED */
> +	adv7441a_i2c_usermap_write8(state, 0x91, 0x10);
> +
> +	/* SAV / EAV */
> +	reg = sav >> 4;
> +	pr_err("a2 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa2, reg);
> +	reg = (eav >> 8) | (sav << 4);
> +	pr_err("a3 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa3, reg);
> +	reg = (eav & 0xff);
> +	pr_err("a4 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa4, reg);
> +
> +	adv7441a_i2c_usermap_write8(state, 0x06, 0x00);
> +
> +	return 0;
> +}
> +
> +static int adv7441a_WXGA_1440x900x60(struct adv7441a_state *state,
> +	struct v4l2_dv_timings *timing)
> +{
> +	u32 ushtotal, frll, lines, sav = 381, eav = 1825;
> +	u8 reg;
> +
> +	state->vga_timing_mode = vc8x0_vga_lookup(
> +		1, /* GTF */
> +		fmt->width,
> +		fmt->height,
> +		fmt->flags == ADV7441A_FORMAT_INTERLACED ? 1 : 0);
> +	if (state->vga_timing_mode)
> +		vc8x0_vga_dump(state->vga_timing_mode);
> +
> +	if (!state->vga_timing_mode) {
> +		pr_err("%s() unable to locate fmt->id %d [%s] in the timing table\n",
> +			__func__, fmt->id, fmt->name);
> +		return -ENODEV;
> +	}
> +
> +	ushtotal = state->vga_timing_mode->total_pixels;
> +	frll = state->vga_timing_mode->bl >> 3;
> +	lines = state->vga_timing_mode->total_lines;
> +	lines++;
> +
> +	dprintk(1, "%s(ushtotal = %d, frll = %d, lines = %d)\n",
> +		__func__, ushtotal, frll, lines);
> +
> +	/* Basic input settings */
> +	adv7441a_i2c_usermap_write8(state, 0x69, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0x00, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0xc3, 0x31);
> +	adv7441a_i2c_usermap_write8(state, 0xc4, 0xc2);
> +	adv7441a_i2c_usermap_write8(state, 0x3a, 0x01);
> +	adv7441a_i2c_usermap_write8(state, 0xf3, 0x00);
> +
> +	/* Auto Mode */
> +	adv7441a_i2c_usermap_write8(state, 0x03, 0x85);
> +	adv7441a_i2c_usermap_write8(state, 0x04, 0x5c);
> +	adv7441a_i2c_usermap_write8(state, 0x05, 0x02);
> +	adv7441a_i2c_usermap_write8(state, 0x06, 0x02);
> +	adv7441a_i2c_usermap_write8(state, 0x0c, 0x0c);
> +	adv7441a_i2c_usermap_write8(state, 0x1d, 0x40);
> +	adv7441a_i2c_usermap_write8(state, 0x37, 0xa1);
> +	adv7441a_i2c_usermap_write8(state, 0x3c, 0xa8);
> +	adv7441a_i2c_usermap_write8(state, 0x47, 0x0a);
> +	adv7441a_i2c_usermap_write8(state, 0x68, 0xf0);
> +	adv7441a_i2c_usermap_write8(state, 0x6b, 0xf3);
> +	adv7441a_i2c_usermap_write8(state, 0x7b, 0x07);
> +	adv7441a_i2c_usermap_write8(state, 0x86, 0x0b);
> +	adv7441a_i2c_usermap_write8(state, 0xc9, 0x04);
> +	adv7441a_i2c_usermap_write8(state, 0xba, 0xa3);
> +
> +	/* ADV7441 HW RevJ Page 190 Section 9.15 */
> +
> +	/* PLL_DIV_MAN_EN */
> +	/* PLL_DIV_RATIO */
> +	reg = 0xe0 | ((ushtotal & 0xfff) >> 8);
> +	pr_err("87 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x87, reg);
> +
> +	reg = ushtotal & 0xff;
> +	pr_err("88 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x88, reg);
> +
> +	/* FR_LL */
> +	reg = 0x70 | ((frll & 0x7ff) >> 8);
> +	pr_err("8f = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x8f, reg);
> +
> +	reg = frll & 0xff;
> +	pr_err("90 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x90, reg);
> +
> +	/* LCOUNT_MAX */
> +	reg = (lines & 0xfff) >> 4;
> +	pr_err("ab = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xab, reg);
> +	reg = (lines & 0x00f) << 4;
> +	pr_err("ac = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xac, reg);
> +
> +	/* INTERLACED */
> +	adv7441a_i2c_usermap_write8(state, 0x91, 0x10);
> +
> +	/* SAV / EAV */
> +	reg = sav >> 4;
> +	pr_err("a2 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa2, reg);
> +	reg = (eav >> 8) | (sav << 4);
> +	pr_err("a3 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa3, reg);
> +	reg = (eav & 0xff);
> +	pr_err("a4 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa4, reg);
> +
> +	/* VBI */
> +	reg = (lines + 1) >> 4;
> +	pr_err("a5 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa5, reg);
> +	reg = ((lines + 1) << 4) | (((lines + 1) - fmt->height) & 0xfff) >> 8;
> +	pr_err("a6 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa6, 0xd0);
> +	reg = ((lines + 1) - fmt->height) & 0xff;
> +	pr_err("a7 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa7, reg);
> +
> +
> +	adv7441a_i2c_usermap_write8(state, 0x06, 0x00);
> +
> +	return 0;
> +}
> +
> +static int adv7441a_WSXGA_1680x1050x60(struct adv7441a_state *state,
> +	struct v4l2_dv_timings *timing)
> +{
> +	u32 ushtotal, frll, lines, sav = 357, eav = 1761;
> +	u8 reg;
> +
> +	state->vga_timing_mode = vc8x0_vga_lookup(
> +		2,
> +		fmt->width,
> +		fmt->height,
> +		fmt->flags == ADV7441A_FORMAT_INTERLACED ? 1 : 0);
> +	if (state->vga_timing_mode)
> +		vc8x0_vga_dump(state->vga_timing_mode);
> +
> +	if (!state->vga_timing_mode) {
> +		pr_err("%s() unable to locate fmt->id %d [%s] in the timing table\n",
> +			__func__, fmt->id, fmt->name);
> +		return -ENODEV;
> +	}
> +
> +	ushtotal = state->vga_timing_mode->total_pixels;
> +	frll = state->vga_timing_mode->bl >> 3;
> +	lines = state->vga_timing_mode->total_lines;
> +
> +	dprintk(1, "%s(ushtotal = %d, frll = %d, lines = %d)\n",
> +		__func__, ushtotal, frll, lines);
> +
> +	/* Basic input settings */
> +	adv7441a_i2c_usermap_write8(state, 0x69, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0x00, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0xc3, 0x31);
> +	adv7441a_i2c_usermap_write8(state, 0xc4, 0xc2);
> +	adv7441a_i2c_usermap_write8(state, 0x3a, 0x01);
> +	adv7441a_i2c_usermap_write8(state, 0xf3, 0x00);
> +
> +	/* Auto Mode */
> +	adv7441a_i2c_usermap_write8(state, 0x03, 0x85);
> +	adv7441a_i2c_usermap_write8(state, 0x04, 0x5c);
> +	adv7441a_i2c_usermap_write8(state, 0x05, 0x02);
> +	adv7441a_i2c_usermap_write8(state, 0x06, 0x02);
> +	adv7441a_i2c_usermap_write8(state, 0x0c, 0x0c);
> +	adv7441a_i2c_usermap_write8(state, 0x1d, 0x40);
> +	adv7441a_i2c_usermap_write8(state, 0x37, 0xa1);
> +	adv7441a_i2c_usermap_write8(state, 0x3c, 0xa8);
> +	adv7441a_i2c_usermap_write8(state, 0x47, 0x0a);
> +	adv7441a_i2c_usermap_write8(state, 0x68, 0xf0);
> +	adv7441a_i2c_usermap_write8(state, 0x6b, 0xf3);
> +	adv7441a_i2c_usermap_write8(state, 0x7b, 0x07);
> +	adv7441a_i2c_usermap_write8(state, 0x86, 0x0b);
> +	adv7441a_i2c_usermap_write8(state, 0xc9, 0x04);
> +	adv7441a_i2c_usermap_write8(state, 0xba, 0xa3);
> +
> +	/* ADV7441 HW RevJ Page 190 Section 9.15 */
> +
> +	/* PLL_DIV_MAN_EN */
> +	/* PLL_DIV_RATIO */
> +	reg = 0xe0 | ((ushtotal & 0xfff) >> 8);
> +	pr_err("87 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x87, reg);
> +
> +	reg = ushtotal & 0xff;
> +	pr_err("88 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x88, reg);
> +
> +	/* FR_LL */
> +	reg = 0x70 | ((frll & 0x7ff) >> 8);
> +	pr_err("8f = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x8f, reg);
> +
> +	reg = frll & 0xff;
> +	pr_err("90 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x90, reg);
> +
> +	/* LCOUNT_MAX */
> +	reg = (lines & 0xfff) >> 4;
> +	pr_err("ab = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xab, reg);
> +	reg = (lines & 0x00f) << 4;
> +	pr_err("ac = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xac, reg);
> +
> +	/* INTERLACED */
> +	adv7441a_i2c_usermap_write8(state, 0x91, 0x10);
> +
> +	/* SAV / EAV */
> +	reg = sav >> 4;
> +	pr_err("a2 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa2, reg);
> +	reg = (eav >> 8) | (sav << 4);
> +	pr_err("a3 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa3, reg);
> +	reg = (eav & 0xff);
> +	pr_err("a4 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa4, reg);
> +
> +	/* VBI */
> +	reg = (lines + 1) >> 4;
> +	pr_err("a5 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa5, reg);
> +	reg = ((lines + 1) << 4) | (((lines + 1) - fmt->height) & 0xfff) >> 8;
> +	pr_err("a6 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa6, 0xd0);
> +	reg = ((lines + 1) - fmt->height) & 0xff;
> +	pr_err("a7 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa7, reg);
> +
> +	adv7441a_i2c_usermap_write8(state, 0x06, 0x00);
> +
> +	return 0;
> +}
> +
> +static int adv7441a_VGAHD_1920x1080x60(struct adv7441a_state *state,
> +	struct v4l2_dv_timings *timing)
> +{
> +	u32 ushtotal, frll, lines, sav = 489, eav = 2413;
> +	u8 reg;
> +
> +	state->vga_timing_mode = vc8x0_vga_lookup(
> +		1, /* GTF */
> +		fmt->width,
> +		fmt->height,
> +		fmt->flags == ADV7441A_FORMAT_INTERLACED ? 1 : 0);
> +	if (state->vga_timing_mode)
> +		vc8x0_vga_dump(state->vga_timing_mode);
> +
> +	if (!state->vga_timing_mode) {
> +		pr_err("%s() unable to locate fmt->id %d [%s] in the timing table\n",
> +			__func__, fmt->id, fmt->name);
> +		return -ENODEV;
> +	}
> +
> +	ushtotal = state->vga_timing_mode->total_pixels;
> +	frll = state->vga_timing_mode->bl >> 3;
> +	lines = state->vga_timing_mode->total_lines;
> +	lines--;
> +
> +	dprintk(1, "%s(ushtotal = %d, frll = %d, lines = %d, bl = %d)\n",
> +		__func__, ushtotal, frll, lines, state->vga_timing_mode->bl);
> +
> +	/* Basic input settings */
> +	adv7441a_i2c_usermap_write8(state, 0x69, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0x00, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0xc3, 0x31);
> +	adv7441a_i2c_usermap_write8(state, 0xc4, 0xc2);
> +	adv7441a_i2c_usermap_write8(state, 0x3a, 0x01);
> +	adv7441a_i2c_usermap_write8(state, 0xf3, 0x00);
> +
> +	/* Auto Mode */
> +	adv7441a_i2c_usermap_write8(state, 0x03, 0x85);
> +	adv7441a_i2c_usermap_write8(state, 0x04, 0x5c);
> +	adv7441a_i2c_usermap_write8(state, 0x05, 0x02);
> +	adv7441a_i2c_usermap_write8(state, 0x06, 0x07);
> +	adv7441a_i2c_usermap_write8(state, 0x0c, 0x0c);
> +	adv7441a_i2c_usermap_write8(state, 0x1d, 0x40);
> +	adv7441a_i2c_usermap_write8(state, 0x37, 0xa1);
> +	adv7441a_i2c_usermap_write8(state, 0x3c, 0xa8);
> +	adv7441a_i2c_usermap_write8(state, 0x47, 0x0a);
> +	adv7441a_i2c_usermap_write8(state, 0x68, 0xf0);
> +	adv7441a_i2c_usermap_write8(state, 0x6b, 0xf3);
> +	adv7441a_i2c_usermap_write8(state, 0x7b, 0x07);
> +	adv7441a_i2c_usermap_write8(state, 0x86, 0x0b);
> +	adv7441a_i2c_usermap_write8(state, 0xc9, 0x04);
> +	adv7441a_i2c_usermap_write8(state, 0xba, 0xa3);
> +
> +	/* ADV7441 HW RevJ Page 190 Section 9.15 */
> +
> +	/* PLL_DIV_MAN_EN */
> +	/* PLL_DIV_RATIO */
> +	reg = 0xe0 | ((ushtotal & 0xfff) >> 8);
> +	pr_err("87 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x87, reg);
> +
> +	reg = ushtotal & 0xff;
> +	pr_err("88 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x88, reg);
> +
> +	/* FR_LL */
> +	reg = 0x70 | ((frll & 0x7ff) >> 8);
> +	pr_err("8f = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x8f, reg);
> +
> +	reg = frll & 0xff;
> +	pr_err("90 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x90, reg);
> +
> +	/* LCOUNT_MAX */
> +	reg = (lines & 0xfff) >> 4;
> +	pr_err("ab = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xab, reg);
> +	reg = (lines & 0x00f) << 4;
> +	pr_err("ac = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xac, reg);
> +
> +	/* INTERLACED */
> +	adv7441a_i2c_usermap_write8(state, 0x91, 0x10);
> +
> +	/* SAV / EAV */
> +	reg = sav >> 4;
> +	pr_err("a2 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa2, reg);
> +	reg = (eav >> 8) | (sav << 4);
> +	pr_err("a3 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa3, reg);
> +	reg = (eav & 0xff);
> +	pr_err("a4 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa4, reg);
> +
> +	/* VBI */
> +	reg = (lines + 1) >> 4;
> +	pr_err("a5 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa5, reg);
> +	reg = ((lines + 1) << 4) | (((lines + 1) - fmt->height) & 0xfff) >> 8;
> +	pr_err("a6 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa6, 0xd0);
> +	reg = ((lines + 1) - fmt->height) & 0xff;
> +	pr_err("a7 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa7, reg);
> +
> +	adv7441a_i2c_usermap_write8(state, 0x06, 0x00);
> +
> +	return 0;
> +}
> +
> +/* Supported VGA resolutions */
> +static int adv7441a_VGA_640x480ix60(struct adv7441a_state *state,
> +	struct v4l2_dv_timings *timing)
> +{
> +	u32 ushtotal, frll, lines, sav = 160, eav = 806;
> +	u8 reg;
> +
> +	sav = 137;
> +	eav = 783;
> +
> +	state->vga_timing_mode = vc8x0_vga_lookup(
> +		2,
> +		fmt->width,
> +		fmt->height,
> +		fmt->flags == ADV7441A_FORMAT_INTERLACED ? 1 : 0);
> +	if (state->vga_timing_mode)
> +		vc8x0_vga_dump(state->vga_timing_mode);
> +
> +	if (!state->vga_timing_mode) {
> +		pr_err("%s() unable to locate fmt->id %d [%s] in the timing table\n",
> +			__func__, fmt->id, fmt->name);
> +		return -ENODEV;
> +	}
> +
> +	ushtotal = state->vga_timing_mode->total_pixels;
> +	frll = state->vga_timing_mode->bl >> 3;
> +	lines = state->vga_timing_mode->total_lines;
> +	lines--;
> +
> +	dprintk(1, "%s(ushtotal = %d, frll = %d, lines = %d)\n",
> +		__func__, ushtotal, frll, lines);
> +
> +	/* Basic input settings */
> +	adv7441a_i2c_usermap_write8(state, 0x69, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0x00, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0xc3, 0x31);
> +	adv7441a_i2c_usermap_write8(state, 0xc4, 0xc2);
> +	adv7441a_i2c_usermap_write8(state, 0x3a, 0x01);
> +	adv7441a_i2c_usermap_write8(state, 0xf3, 0x00);
> +
> +	/* Auto Mode */
> +	adv7441a_i2c_usermap_write8(state, 0x03, 0x85);
> +	adv7441a_i2c_usermap_write8(state, 0x04, 0x5c);
> +	adv7441a_i2c_usermap_write8(state, 0x05, 0x02);
> +	adv7441a_i2c_usermap_write8(state, 0x06, 0x02);
> +	adv7441a_i2c_usermap_write8(state, 0x0c, 0x0c);
> +	adv7441a_i2c_usermap_write8(state, 0x1d, 0x40);
> +	adv7441a_i2c_usermap_write8(state, 0x37, 0xa1);
> +	adv7441a_i2c_usermap_write8(state, 0x3c, 0xa8);
> +	adv7441a_i2c_usermap_write8(state, 0x47, 0x0a);
> +	adv7441a_i2c_usermap_write8(state, 0x68, 0xf0);
> +	adv7441a_i2c_usermap_write8(state, 0x6b, 0xf3);
> +	adv7441a_i2c_usermap_write8(state, 0x7b, 0x07);
> +	adv7441a_i2c_usermap_write8(state, 0x86, 0x0b);
> +	adv7441a_i2c_usermap_write8(state, 0xc9, 0x04);
> +	adv7441a_i2c_usermap_write8(state, 0xba, 0xa3);
> +
> +	/* ADV7441 HW RevJ Page 190 Section 9.15 */
> +
> +	/* PLL_DIV_MAN_EN */
> +	/* PLL_DIV_RATIO */
> +	reg = 0xe0 | ((ushtotal & 0xfff) >> 8);
> +	pr_err("87 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x87, reg);
> +
> +	reg = ushtotal & 0xff;
> +	pr_err("88 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x88, reg);
> +
> +	/* FR_LL */
> +	reg = 0x70 | ((frll & 0x7ff) >> 8);
> +	pr_err("8f = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x8f, reg);
> +
> +	reg = frll & 0xff;
> +	pr_err("90 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x90, reg);
> +
> +	/* LCOUNT_MAX */
> +	reg = (lines & 0xfff) >> 4;
> +	pr_err("ab = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xab, reg);
> +	reg = (lines & 0x00f) << 4;
> +	pr_err("ac = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xac, reg);
> +
> +	/* INTERLACED */
> +	adv7441a_i2c_usermap_write8(state, 0x91, 0x10);
> +
> +	/* SAV / EAV */
> +	reg = sav >> 4;
> +	pr_err("a2 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa2, reg);
> +	reg = (eav >> 8) | (sav << 4);
> +	pr_err("a3 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa3, reg);
> +	reg = (eav & 0xff);
> +	pr_err("a4 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa4, reg);
> +
> +	/* VBI */
> +	reg = (lines + 1) >> 4;
> +	pr_err("a5 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa5, reg);
> +	reg = ((lines + 1) << 4) | (((lines + 1) - fmt->height) & 0xfff) >> 8;
> +	pr_err("a6 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa6, 0xd0);
> +	reg = ((lines + 1) - fmt->height) & 0xff;
> +	pr_err("a7 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa7, reg);
> +
> +	adv7441a_i2c_usermap_write8(state, 0x06, 0x00);
> +
> +	return 0;
> +}
> +
> +static int adv7441a_VGA_800x600px60(struct adv7441a_state *state,
> +	struct v4l2_dv_timings *timing)
> +{
> +	u32 ushtotal, frll, lines, sav = 234, eav = 1040;
> +	u8 reg;
> +
> +	sav = 210;
> +	eav = 1016;
> +
> +	state->vga_timing_mode = vc8x0_vga_lookup(
> +		2,
> +		fmt->width,
> +		fmt->height,
> +		fmt->flags == ADV7441A_FORMAT_INTERLACED ? 1 : 0);
> +	if (state->vga_timing_mode)
> +		vc8x0_vga_dump(state->vga_timing_mode);
> +
> +	if (!state->vga_timing_mode) {
> +		pr_err("%s() unable to locate fmt->id %d [%s] in the timing table\n",
> +			__func__, fmt->id, fmt->name);
> +		return -ENODEV;
> +	}
> +
> +	ushtotal = state->vga_timing_mode->total_pixels;
> +	frll = state->vga_timing_mode->bl >> 3;
> +	lines = state->vga_timing_mode->total_lines;
> +	lines = 629;
> +
> +	dprintk(1, "%s(ushtotal = %d, frll = %d, lines = %d)\n",
> +		__func__, ushtotal, frll, lines);
> +
> +	/* Basic input settings */
> +	adv7441a_i2c_usermap_write8(state, 0x69, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0x00, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0xc3, 0x31);
> +	adv7441a_i2c_usermap_write8(state, 0xc4, 0xc2);
> +	adv7441a_i2c_usermap_write8(state, 0x3a, 0x01);
> +	adv7441a_i2c_usermap_write8(state, 0xf3, 0x00);
> +
> +	/* Auto Mode */
> +	adv7441a_i2c_usermap_write8(state, 0x03, 0x85);
> +	adv7441a_i2c_usermap_write8(state, 0x04, 0x5c);
> +	adv7441a_i2c_usermap_write8(state, 0x05, 0x02);
> +	adv7441a_i2c_usermap_write8(state, 0x06, 0x02);
> +	adv7441a_i2c_usermap_write8(state, 0x0c, 0x0c);
> +	adv7441a_i2c_usermap_write8(state, 0x1d, 0x40);
> +	adv7441a_i2c_usermap_write8(state, 0x37, 0xa1);
> +	adv7441a_i2c_usermap_write8(state, 0x3c, 0xa8);
> +	adv7441a_i2c_usermap_write8(state, 0x47, 0x0a);
> +	adv7441a_i2c_usermap_write8(state, 0x68, 0xf0);
> +	adv7441a_i2c_usermap_write8(state, 0x6b, 0xf3);
> +	adv7441a_i2c_usermap_write8(state, 0x7b, 0x07);
> +	adv7441a_i2c_usermap_write8(state, 0x86, 0x0b);
> +	adv7441a_i2c_usermap_write8(state, 0xc9, 0x04);
> +	adv7441a_i2c_usermap_write8(state, 0xba, 0xa3);
> +
> +	/* ADV7441 HW RevJ Page 190 Section 9.15 */
> +
> +	/* PLL_DIV_MAN_EN */
> +	/* PLL_DIV_RATIO */
> +	reg = 0xe0 | ((ushtotal & 0xfff) >> 8);
> +	pr_err("87 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x87, reg);
> +
> +	reg = ushtotal & 0xff;
> +	pr_err("88 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x88, reg);
> +
> +	/* FR_LL */
> +	reg = 0x70 | ((frll & 0x7ff) >> 8);
> +	pr_err("8f = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x8f, reg);
> +
> +	reg = frll & 0xff;
> +	pr_err("90 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x90, reg);
> +
> +	/* LCOUNT_MAX */
> +	reg = (lines & 0xfff) >> 4;
> +	pr_err("ab = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xab, reg);
> +	reg = (lines & 0x00f) << 4;
> +	pr_err("ac = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xac, reg);
> +
> +	/* INTERLACED */
> +	adv7441a_i2c_usermap_write8(state, 0x91, 0x10);
> +
> +	/* SAV / EAV */
> +	reg = sav >> 4;
> +	pr_err("a2 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa2, reg);
> +	reg = (eav >> 8) | (sav << 4);
> +	pr_err("a3 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa3, reg);
> +	reg = (eav & 0xff);
> +	pr_err("a4 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa4, reg);
> +
> +	adv7441a_i2c_usermap_write8(state, 0x06, 0x00);
> +
> +	return 0;
> +}
> +
> +static int adv7441a_VGA_1024x768px60(struct adv7441a_state *state,
> +	struct v4l2_dv_timings *timing)
> +{
> +	u32 ushtotal, frll, lines, sav = 290, eav = 1320;
> +	u8 reg;
> +
> +	state->vga_timing_mode = vc8x0_vga_lookup(
> +		2,
> +		fmt->width,
> +		fmt->height,
> +		fmt->flags == ADV7441A_FORMAT_INTERLACED ? 1 : 0);
> +	if (state->vga_timing_mode)
> +		vc8x0_vga_dump(state->vga_timing_mode);
> +
> +	if (!state->vga_timing_mode) {
> +		pr_err("%s() unable to locate fmt->id %d [%s] in the timing table\n",
> +			__func__, fmt->id, fmt->name);
> +		return -ENODEV;
> +	}
> +
> +	ushtotal = state->vga_timing_mode->total_pixels;
> +	frll = state->vga_timing_mode->bl >> 3;
> +	lines = state->vga_timing_mode->total_lines;
> +	lines++;
> +
> +	dprintk(1, "%s(ushtotal = %d, frll = %d, lines = %d)\n",
> +		__func__, ushtotal, frll, lines);
> +
> +	/* Basic input settings */
> +	adv7441a_i2c_usermap_write8(state, 0x69, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0x00, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0xc3, 0x31);
> +	adv7441a_i2c_usermap_write8(state, 0xc4, 0xc2);
> +	adv7441a_i2c_usermap_write8(state, 0x3a, 0x01);
> +	adv7441a_i2c_usermap_write8(state, 0xf3, 0x00);
> +
> +	/* Auto Mode */
> +	adv7441a_i2c_usermap_write8(state, 0x03, 0x85);
> +	adv7441a_i2c_usermap_write8(state, 0x04, 0x5c);
> +	adv7441a_i2c_usermap_write8(state, 0x05, 0x02);
> +	adv7441a_i2c_usermap_write8(state, 0x06, 0x02);
> +	adv7441a_i2c_usermap_write8(state, 0x0c, 0x0c);
> +	adv7441a_i2c_usermap_write8(state, 0x1d, 0x40);
> +	adv7441a_i2c_usermap_write8(state, 0x37, 0xa1);
> +	adv7441a_i2c_usermap_write8(state, 0x3c, 0xa8);
> +	adv7441a_i2c_usermap_write8(state, 0x47, 0x0a);
> +	adv7441a_i2c_usermap_write8(state, 0x68, 0xf0);
> +	adv7441a_i2c_usermap_write8(state, 0x6b, 0xf3);
> +	adv7441a_i2c_usermap_write8(state, 0x7b, 0x07);
> +	adv7441a_i2c_usermap_write8(state, 0x86, 0x0b);
> +	adv7441a_i2c_usermap_write8(state, 0xc9, 0x04);
> +	adv7441a_i2c_usermap_write8(state, 0xba, 0xa3);
> +
> +	/* ADV7441 HW RevJ Page 190 Section 9.15 */
> +
> +	/* PLL_DIV_MAN_EN */
> +	/* PLL_DIV_RATIO */
> +	reg = 0xe0 | ((ushtotal & 0xfff) >> 8);
> +	pr_err("87 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x87, reg);
> +
> +	reg = ushtotal & 0xff;
> +	pr_err("88 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x88, reg);
> +
> +	/* FR_LL */
> +	reg = 0x70 | ((frll & 0x7ff) >> 8);
> +	pr_err("8f = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x8f, reg);
> +
> +	reg = frll & 0xff;
> +	pr_err("90 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x90, reg);
> +
> +	/* LCOUNT_MAX */
> +	reg = (lines & 0xfff) >> 4;
> +	pr_err("ab = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xab, reg);
> +	reg = (lines & 0x00f) << 4;
> +	pr_err("ac = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xac, reg);
> +
> +	/* INTERLACED */
> +	adv7441a_i2c_usermap_write8(state, 0x91, 0x10);
> +
> +	/* SAV / EAV */
> +	reg = sav >> 4;
> +	pr_err("a2 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa2, reg);
> +	reg = (eav >> 8) | (sav << 4);
> +	pr_err("a3 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa3, reg);
> +	reg = (eav & 0xff);
> +	pr_err("a4 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa4, reg);
> +
> +	/* VBI */
> +	reg = (lines + 1) >> 4;
> +	pr_err("a5 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa5, reg);
> +	reg = ((lines + 1) << 4) | (((lines + 1) - fmt->height) & 0xfff) >> 8;
> +	pr_err("a6 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa6, 0xd0);
> +	reg = ((lines + 1) - fmt->height) & 0xff;
> +	pr_err("a7 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa7, reg);
> +
> +
> +	adv7441a_i2c_usermap_write8(state, 0x06, 0x00);
> +
> +	return 0;
> +}
> +
> +static int adv7441a_VGA_1280x960px60(struct adv7441a_state *state,
> +	struct v4l2_dv_timings *timing)
> +{
> +	/* 1280B@60 */
> +
> +	u32 ushtotal, frll, lines, sav = 420, eav = 1706;
> +	u8 reg;
> +
> +	state->vga_timing_mode = vc8x0_vga_lookup(
> +		2,
> +		fmt->width,
> +		fmt->height,
> +		fmt->flags == ADV7441A_FORMAT_INTERLACED ? 1 : 0);
> +	if (state->vga_timing_mode)
> +		vc8x0_vga_dump(state->vga_timing_mode);
> +
> +	if (!state->vga_timing_mode) {
> +		pr_err("%s() unable to locate fmt->id %d [%s] in the timing table\n",
> +			__func__, fmt->id, fmt->name);
> +		return -ENODEV;
> +	}
> +
> +	ushtotal = state->vga_timing_mode->total_pixels;
> +	frll = state->vga_timing_mode->bl >> 3;
> +	lines = state->vga_timing_mode->total_lines;
> +	lines++;
> +
> +	dprintk(1, "%s(ushtotal = %d, frll = %d, lines = %d)\n",
> +		__func__, ushtotal, frll, lines);
> +
> +	/* Basic input settings */
> +	adv7441a_i2c_usermap_write8(state, 0x69, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0x00, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0xc3, 0x31);
> +	adv7441a_i2c_usermap_write8(state, 0xc4, 0xc2);
> +	adv7441a_i2c_usermap_write8(state, 0x3a, 0x01);
> +	adv7441a_i2c_usermap_write8(state, 0xf3, 0x00);
> +
> +	/* Auto Mode */
> +	adv7441a_i2c_usermap_write8(state, 0x03, 0x85);
> +	adv7441a_i2c_usermap_write8(state, 0x04, 0x5c);
> +	adv7441a_i2c_usermap_write8(state, 0x05, 0x02);
> +	adv7441a_i2c_usermap_write8(state, 0x06, 0x02);
> +	adv7441a_i2c_usermap_write8(state, 0x0c, 0x0c);
> +	adv7441a_i2c_usermap_write8(state, 0x1d, 0x40);
> +	adv7441a_i2c_usermap_write8(state, 0x37, 0xa1);
> +	adv7441a_i2c_usermap_write8(state, 0x3c, 0xa8);
> +	adv7441a_i2c_usermap_write8(state, 0x47, 0x0a);
> +	adv7441a_i2c_usermap_write8(state, 0x68, 0xf0);
> +	adv7441a_i2c_usermap_write8(state, 0x6b, 0xf3);
> +	adv7441a_i2c_usermap_write8(state, 0x7b, 0x07);
> +	adv7441a_i2c_usermap_write8(state, 0x86, 0x0b);
> +	adv7441a_i2c_usermap_write8(state, 0xc9, 0x04);
> +	adv7441a_i2c_usermap_write8(state, 0xba, 0xa3);
> +
> +	/* ADV7441 HW RevJ Page 190 Section 9.15 */
> +
> +	/* PLL_DIV_MAN_EN */
> +	/* PLL_DIV_RATIO */
> +	reg = 0xe0 | ((ushtotal & 0xfff) >> 8);
> +	pr_err("87 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x87, reg);
> +
> +	reg = ushtotal & 0xff;
> +	pr_err("88 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x88, reg);
> +
> +	/* FR_LL */
> +	reg = 0x70 | ((frll & 0x7ff) >> 8);
> +	pr_err("8f = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x8f, reg);
> +
> +	reg = frll & 0xff;
> +	pr_err("90 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x90, reg);
> +
> +	/* LCOUNT_MAX */
> +	reg = (lines & 0xfff) >> 4;
> +	pr_err("ab = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xab, reg);
> +	reg = (lines & 0x00f) << 4;
> +	pr_err("ac = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xac, reg);
> +
> +	/* INTERLACED */
> +	adv7441a_i2c_usermap_write8(state, 0x91, 0x10);
> +
> +	/* SAV / EAV */
> +	reg = sav >> 4;
> +	pr_err("a2 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa2, reg);
> +	reg = (eav >> 8) | (sav << 4);
> +	pr_err("a3 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa3, reg);
> +	reg = (eav & 0xff);
> +	pr_err("a4 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa4, reg);
> +
> +	/* VBI */
> +	reg = (lines + 1) >> 4;
> +	pr_err("a5 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa5, reg);
> +	reg = ((lines + 1) << 4) | (((lines + 1) - fmt->height) & 0xfff) >> 8;
> +	pr_err("a6 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa6, 0xd0);
> +	reg = ((lines + 1) - fmt->height) & 0xff;
> +	pr_err("a7 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa7, reg);
> +
> +
> +	adv7441a_i2c_usermap_write8(state, 0x06, 0x00);
> +
> +	return 0;
> +}
> +
> +static int adv7441a_VGA_1280x720px60(struct adv7441a_state *state,
> +	struct v4l2_dv_timings *timing)
> +{
> +	u32 ushtotal, frll, lines, sav = 317, eav = 1603;
> +	u8 reg;
> +
> +	state->vga_timing_mode = vc8x0_vga_lookup(
> +		2,
> +		fmt->width,
> +		fmt->height,
> +		fmt->flags == ADV7441A_FORMAT_INTERLACED ? 1 : 0);
> +	if (state->vga_timing_mode)
> +		vc8x0_vga_dump(state->vga_timing_mode);
> +
> +	if (!state->vga_timing_mode) {
> +		pr_err("%s() unable to locate fmt->id %d [%s] in the timing table\n",
> +			__func__, fmt->id, fmt->name);
> +		return -ENODEV;
> +	}
> +
> +	ushtotal = state->vga_timing_mode->total_pixels;
> +	frll = state->vga_timing_mode->bl >> 3;
> +	lines = state->vga_timing_mode->total_lines;
> +	lines = 747;
> +
> +	dprintk(1, "%s(ushtotal = %d, frll = %d, lines = %d)\n",
> +		__func__, ushtotal, frll, lines);
> +
> +	/* Basic input settings */
> +	adv7441a_i2c_usermap_write8(state, 0x69, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0x00, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0xc3, 0x31);
> +	adv7441a_i2c_usermap_write8(state, 0xc4, 0xc2);
> +	adv7441a_i2c_usermap_write8(state, 0x3a, 0x01);
> +	adv7441a_i2c_usermap_write8(state, 0xf3, 0x00);
> +
> +	/* Auto Mode */
> +	adv7441a_i2c_usermap_write8(state, 0x03, 0x85);
> +	adv7441a_i2c_usermap_write8(state, 0x04, 0x5c);
> +	adv7441a_i2c_usermap_write8(state, 0x05, 0x02);
> +	adv7441a_i2c_usermap_write8(state, 0x06, 0x02);
> +	adv7441a_i2c_usermap_write8(state, 0x0c, 0x0c);
> +	adv7441a_i2c_usermap_write8(state, 0x1d, 0x40);
> +	adv7441a_i2c_usermap_write8(state, 0x37, 0xa1);
> +	adv7441a_i2c_usermap_write8(state, 0x3c, 0xa8);
> +	adv7441a_i2c_usermap_write8(state, 0x47, 0x0a);
> +	adv7441a_i2c_usermap_write8(state, 0x68, 0xf0);
> +	adv7441a_i2c_usermap_write8(state, 0x6b, 0xf3);
> +	adv7441a_i2c_usermap_write8(state, 0x7b, 0x07);
> +	adv7441a_i2c_usermap_write8(state, 0x86, 0x0b);
> +	adv7441a_i2c_usermap_write8(state, 0xc9, 0x04);
> +	adv7441a_i2c_usermap_write8(state, 0xba, 0xa3);
> +
> +	/* ADV7441 HW RevJ Page 190 Section 9.15 */
> +
> +	/* PLL_DIV_MAN_EN */
> +	/* PLL_DIV_RATIO */
> +	reg = 0xe0 | ((ushtotal & 0xfff) >> 8);
> +	pr_err("87 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x87, reg);
> +
> +	reg = ushtotal & 0xff;
> +	pr_err("88 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x88, reg);
> +
> +	/* FR_LL */
> +	reg = 0x70 | ((frll & 0x7ff) >> 8);
> +	pr_err("8f = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x8f, reg);
> +
> +	reg = frll & 0xff;
> +	pr_err("90 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x90, reg);
> +
> +	/* LCOUNT_MAX */
> +	reg = (lines & 0xfff) >> 4;
> +	pr_err("ab = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xab, reg);
> +	reg = (lines & 0x00f) << 4;
> +	pr_err("ac = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xac, reg);
> +
> +	/* INTERLACED */
> +	adv7441a_i2c_usermap_write8(state, 0x91, 0x10);
> +
> +	/* SAV / EAV */
> +	reg = sav >> 4;
> +	pr_err("a2 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa2, reg);
> +	reg = (eav >> 8) | (sav << 4);
> +	pr_err("a3 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa3, reg);
> +	reg = (eav & 0xff);
> +	pr_err("a4 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa4, reg);
> +
> +	/* VBI */
> +	reg = (lines + 1) >> 4;
> +	pr_err("a5 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa5, reg);
> +	reg = ((lines + 1) << 4) | (((lines + 1) - fmt->height) & 0xfff) >> 8;
> +	pr_err("a6 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa6, 0xd0);
> +	reg = ((lines + 1) - fmt->height) & 0xff;
> +	pr_err("a7 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa7, reg);
> +
> +
> +	adv7441a_i2c_usermap_write8(state, 0x06, 0x00);
> +
> +	return 0;
> +}
> +
> +static int adv7441a_VGA_1280x1024px60(struct adv7441a_state *state,
> +	struct v4l2_dv_timings *timing)
> +{
> +	/* 1280_@60 */
> +	u32 ushtotal, frll, lines, sav = 354, eav = 1640;
> +	u8 reg;
> +
> +	state->vga_timing_mode = vc8x0_vga_lookup(
> +		2,
> +		fmt->width,
> +		fmt->height,
> +		fmt->flags == ADV7441A_FORMAT_INTERLACED ? 1 : 0);
> +	if (state->vga_timing_mode)
> +		vc8x0_vga_dump(state->vga_timing_mode);
> +
> +	if (!state->vga_timing_mode) {
> +		pr_err("%s() unable to locate fmt->id %d [%s] in the timing table\n",
> +			__func__, fmt->id, fmt->name);
> +		return -ENODEV;
> +	}
> +
> +	ushtotal = state->vga_timing_mode->total_pixels;
> +	frll = state->vga_timing_mode->bl >> 3;
> +	lines = state->vga_timing_mode->total_lines;
> +	lines++;
> +
> +	dprintk(1, "%s(ushtotal = %d, frll = %d, lines = %d)\n",
> +		__func__, ushtotal, frll, lines);
> +
> +	/* Basic input settings */
> +	adv7441a_i2c_usermap_write8(state, 0x69, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0x00, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0xc3, 0x31);
> +	adv7441a_i2c_usermap_write8(state, 0xc4, 0xc2);
> +	adv7441a_i2c_usermap_write8(state, 0x3a, 0x01);
> +	adv7441a_i2c_usermap_write8(state, 0xf3, 0x00);
> +
> +	/* Auto Mode */
> +	adv7441a_i2c_usermap_write8(state, 0x03, 0x85);
> +	adv7441a_i2c_usermap_write8(state, 0x04, 0x5c);
> +	adv7441a_i2c_usermap_write8(state, 0x05, 0x02);
> +	adv7441a_i2c_usermap_write8(state, 0x06, 0x02);
> +	adv7441a_i2c_usermap_write8(state, 0x0c, 0x0c);
> +	adv7441a_i2c_usermap_write8(state, 0x1d, 0x40);
> +	adv7441a_i2c_usermap_write8(state, 0x37, 0xa1);
> +	adv7441a_i2c_usermap_write8(state, 0x3c, 0xa8);
> +	adv7441a_i2c_usermap_write8(state, 0x47, 0x0a);
> +	adv7441a_i2c_usermap_write8(state, 0x68, 0xf0);
> +	adv7441a_i2c_usermap_write8(state, 0x6b, 0xf3);
> +	adv7441a_i2c_usermap_write8(state, 0x7b, 0x07);
> +	adv7441a_i2c_usermap_write8(state, 0x86, 0x0b);
> +	adv7441a_i2c_usermap_write8(state, 0xc9, 0x04);
> +	adv7441a_i2c_usermap_write8(state, 0xba, 0xa3);
> +
> +	/* ADV7441 HW RevJ Page 190 Section 9.15 */
> +
> +	/* PLL_DIV_MAN_EN */
> +	/* PLL_DIV_RATIO */
> +	reg = 0xe0 | ((ushtotal & 0xfff) >> 8);
> +	pr_err("87 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x87, reg);
> +
> +	reg = ushtotal & 0xff;
> +	pr_err("88 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x88, reg);
> +
> +	/* FR_LL */
> +	reg = 0x70 | ((frll & 0x7ff) >> 8);
> +	pr_err("8f = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x8f, reg);
> +
> +	reg = frll & 0xff;
> +	pr_err("90 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x90, reg);
> +
> +	/* LCOUNT_MAX */
> +	reg = (lines & 0xfff) >> 4;
> +	pr_err("ab = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xab, reg);
> +	reg = (lines & 0x00f) << 4;
> +	pr_err("ac = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xac, reg);
> +
> +	/* INTERLACED */
> +	adv7441a_i2c_usermap_write8(state, 0x91, 0x10);
> +
> +	/* SAV / EAV */
> +	reg = sav >> 4;
> +	pr_err("a2 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa2, reg);
> +	reg = (eav >> 8) | (sav << 4);
> +	pr_err("a3 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa3, reg);
> +	reg = (eav & 0xff);
> +	pr_err("a4 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa4, reg);
> +
> +	/* VBI */
> +	reg = (lines + 1) >> 4;
> +	pr_err("a5 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa5, reg);
> +	reg = ((lines + 1) << 4) | (((lines + 1) - fmt->height) & 0xfff) >> 8;
> +	pr_err("a6 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa6, 0xd0);
> +	reg = ((lines + 1) - fmt->height) & 0xff;
> +	pr_err("a7 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa7, reg);
> +
> +
> +	adv7441a_i2c_usermap_write8(state, 0x06, 0x00);
> +
> +	return 0;
> +}
> +
> +static int adv7441a_VGA_1400x1050px60(struct adv7441a_state *state,
> +	struct v4l2_dv_timings *timing)
> +{
> +	u32 ushtotal, frll, lines, sav = 382, eav = 1786;
> +	u8 reg;
> +
> +	state->vga_timing_mode = vc8x0_vga_lookup(
> +		1,
> +		fmt->width,
> +		fmt->height,
> +		fmt->flags == ADV7441A_FORMAT_INTERLACED ? 1 : 0);
> +	if (state->vga_timing_mode)
> +		vc8x0_vga_dump(state->vga_timing_mode);
> +
> +	if (!state->vga_timing_mode) {
> +		pr_err("%s() unable to locate fmt->id %d [%s] in the timing table\n",
> +			__func__, fmt->id, fmt->name);
> +		return -ENODEV;
> +	}
> +
> +	ushtotal = state->vga_timing_mode->total_pixels;
> +	frll = state->vga_timing_mode->bl >> 3;
> +	lines = state->vga_timing_mode->total_lines;
> +	lines++;
> +
> +	dprintk(1, "%s(ushtotal = %d, frll = %d, lines = %d(%x))\n",
> +		__func__, ushtotal, frll, lines, lines);
> +
> +	/* Basic input settings */
> +	adv7441a_i2c_usermap_write8(state, 0x69, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0x00, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0xc3, 0x31);
> +	adv7441a_i2c_usermap_write8(state, 0xc4, 0xc2);
> +	adv7441a_i2c_usermap_write8(state, 0x3a, 0x01);
> +	adv7441a_i2c_usermap_write8(state, 0xf3, 0x00);
> +
> +	/* Auto Mode */
> +	adv7441a_i2c_usermap_write8(state, 0x03, 0x85);
> +	adv7441a_i2c_usermap_write8(state, 0x04, 0x5c);
> +	adv7441a_i2c_usermap_write8(state, 0x05, 0x02);
> +	adv7441a_i2c_usermap_write8(state, 0x06, 0x07);
> +	adv7441a_i2c_usermap_write8(state, 0x0c, 0x0c);
> +	adv7441a_i2c_usermap_write8(state, 0x1d, 0x40);
> +	adv7441a_i2c_usermap_write8(state, 0x37, 0xa1);
> +	adv7441a_i2c_usermap_write8(state, 0x3c, 0xa8);
> +	adv7441a_i2c_usermap_write8(state, 0x47, 0x0a);
> +	adv7441a_i2c_usermap_write8(state, 0x68, 0xf0);
> +	adv7441a_i2c_usermap_write8(state, 0x6b, 0xf3);
> +	adv7441a_i2c_usermap_write8(state, 0x7b, 0x07);
> +	adv7441a_i2c_usermap_write8(state, 0x86, 0x0b);
> +	adv7441a_i2c_usermap_write8(state, 0xc9, 0x04);
> +	adv7441a_i2c_usermap_write8(state, 0xba, 0xa3);
> +
> +	/* ADV7441 HW RevJ Page 190 Section 9.15 */
> +
> +	/* PLL_DIV_MAN_EN */
> +	/* PLL_DIV_RATIO */
> +	reg = 0xe0 | ((ushtotal & 0xfff) >> 8);
> +	pr_err("87 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x87, reg);
> +
> +	reg = ushtotal & 0xff;
> +	pr_err("88 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x88, reg);
> +
> +	/* FR_LL */
> +	reg = 0x70 | ((frll & 0x7ff) >> 8);
> +	pr_err("8f = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x8f, reg);
> +
> +	reg = frll & 0xff;
> +	pr_err("90 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0x90, reg);
> +
> +	/* LCOUNT_MAX */
> +	reg = (lines & 0xfff) >> 4;
> +	pr_err("ab = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xab, reg);
> +	reg = (lines & 0x00f) << 4;
> +	pr_err("ac = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xac, reg);
> +
> +	/* INTERLACED */
> +	adv7441a_i2c_usermap_write8(state, 0x91, 0x10);
> +
> +	/* SAV / EAV */
> +	reg = sav >> 4;
> +	pr_err("a2 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa2, reg);
> +	reg = (eav >> 8) | (sav << 4);
> +	pr_err("a3 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa3, reg);
> +	reg = (eav & 0xff);
> +	pr_err("a4 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa4, reg);
> +
> +	/* VBI */
> +	reg = (lines + 1) >> 4;
> +	pr_err("a5 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa5, reg);
> +	reg = ((lines + 1) << 4) | (((lines + 1) - fmt->height) & 0xfff) >> 8;
> +	pr_err("a6 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa6, 0xd0);
> +	reg = ((lines + 1) - fmt->height) & 0xff;
> +	pr_err("a7 = %02x\n", reg);
> +	adv7441a_i2c_usermap_write8(state, 0xa7, reg);
> +
> +	adv7441a_i2c_usermap_write8(state, 0x06, 0x00);
> +
> +	return 0;
> +}
> +#endif
> +
> +static int adv7441a_YPRPB_720x480ix60(struct adv7441a_state *state)
> +{
> +	dprintk(1, "%s()\n", __func__);
> +
> +	/* 0820 */
> +	adv7441a_i2c_usermap_write8(state, 0x69, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0x00, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0xc3, 0x31);
> +	adv7441a_i2c_usermap_write8(state, 0xc4, 0xc2);
> +	adv7441a_i2c_usermap_write8(state, 0x3a, 0x01);
> +	adv7441a_i2c_usermap_write8(state, 0xf3, 0x00);
> +
> +	adv7441a_i2c_usermap_write8(state, 0x03, 0x85);
> +	adv7441a_i2c_usermap_write8(state, 0x04, 0x1c);
> +	adv7441a_i2c_usermap_write8(state, 0x05, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0x06, 0x0c);
> +	adv7441a_i2c_usermap_write8(state, 0x0c, 0x0c);
> +	adv7441a_i2c_usermap_write8(state, 0x1d, 0x40);
> +	adv7441a_i2c_usermap_write8(state, 0x37, 0xa1);
> +	adv7441a_i2c_usermap_write8(state, 0x3c, 0xa8);
> +	adv7441a_i2c_usermap_write8(state, 0x47, 0x0a);
> +	adv7441a_i2c_usermap_write8(state, 0x68, 0xf0);
> +	adv7441a_i2c_usermap_write8(state, 0x6b, 0xe7);
> +	adv7441a_i2c_usermap_write8(state, 0x7b, 0x0f);
> +	adv7441a_i2c_usermap_write8(state, 0x86, 0x0b);
> +	adv7441a_i2c_usermap_write8(state, 0xc9, 0x04);
> +	adv7441a_i2c_usermap_write8(state, 0xf4, 0x15);
> +
> +	return 0;
> +}
> +
> +static int adv7441a_YPRPB_720x576px25(struct adv7441a_state *state)
> +{
> +	dprintk(1, "%s()\n", __func__);
> +
> +	/* 0820 */
> +	adv7441a_i2c_usermap_write8(state, 0x69, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0x00, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0xc3, 0x31);
> +	adv7441a_i2c_usermap_write8(state, 0xc4, 0xc2);
> +	adv7441a_i2c_usermap_write8(state, 0x3a, 0x01);
> +	adv7441a_i2c_usermap_write8(state, 0xf3, 0x00);
> +
> +	adv7441a_i2c_usermap_write8(state, 0x03, 0x85);
> +	adv7441a_i2c_usermap_write8(state, 0x04, 0x1c);
> +	adv7441a_i2c_usermap_write8(state, 0x05, 0x01);
> +	adv7441a_i2c_usermap_write8(state, 0x06, 0x05);
> +	adv7441a_i2c_usermap_write8(state, 0x0c, 0x0c);
> +	adv7441a_i2c_usermap_write8(state, 0x1d, 0x40);
> +	adv7441a_i2c_usermap_write8(state, 0x37, 0xa1);
> +	adv7441a_i2c_usermap_write8(state, 0x3c, 0xa8);
> +	adv7441a_i2c_usermap_write8(state, 0x47, 0x0a);
> +	adv7441a_i2c_usermap_write8(state, 0x68, 0xf0);
> +	adv7441a_i2c_usermap_write8(state, 0x6b, 0xe7);
> +	adv7441a_i2c_usermap_write8(state, 0x7b, 0x0f);
> +	adv7441a_i2c_usermap_write8(state, 0x86, 0x0b);
> +	adv7441a_i2c_usermap_write8(state, 0xc9, 0x04);
> +	adv7441a_i2c_usermap_write8(state, 0xf4, 0x15);
> +
> +	return 0;
> +}
> +
> +static int adv7441a_YPRPB_720x576ix50(struct adv7441a_state *state)
> +{
> +	dprintk(1, "%s()\n", __func__);
> +
> +	/* 0820 */
> +	adv7441a_i2c_usermap_write8(state, 0x69, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0x00, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0xc3, 0x31);
> +	adv7441a_i2c_usermap_write8(state, 0xc4, 0xc2);
> +	adv7441a_i2c_usermap_write8(state, 0x3a, 0x01);
> +	adv7441a_i2c_usermap_write8(state, 0xf3, 0x00);
> +
> +	adv7441a_i2c_usermap_write8(state, 0x03, 0x85);
> +	adv7441a_i2c_usermap_write8(state, 0x04, 0x1c);
> +	adv7441a_i2c_usermap_write8(state, 0x05, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0x06, 0x0d);
> +	adv7441a_i2c_usermap_write8(state, 0x0c, 0x0c);
> +	adv7441a_i2c_usermap_write8(state, 0x1d, 0x40);
> +	adv7441a_i2c_usermap_write8(state, 0x37, 0xa1);
> +	adv7441a_i2c_usermap_write8(state, 0x3c, 0xa8);
> +	adv7441a_i2c_usermap_write8(state, 0x47, 0x0a);
> +	adv7441a_i2c_usermap_write8(state, 0x68, 0xf0);
> +	adv7441a_i2c_usermap_write8(state, 0x6b, 0xe7);
> +	adv7441a_i2c_usermap_write8(state, 0x7b, 0x0f);
> +	adv7441a_i2c_usermap_write8(state, 0x86, 0x0b);
> +	adv7441a_i2c_usermap_write8(state, 0xc9, 0x04);
> +	adv7441a_i2c_usermap_write8(state, 0xf4, 0x15);
> +
> +	return 0;
> +}
> +
> +static int adv7441a_YPRPB_1280x720p(struct adv7441a_state *state,
> +	int rateHz)
> +{
> +	u8 reg;
> +	dprintk(1, "%s(%d)\n", __func__, rateHz);
> +
> +	switch (rateHz) {
> +	case 50:
> +		reg = 0x2a; break;
> +	case 30:
> +		reg = 0x4a; break;
> +	case 25:
> +		reg = 0x6a; break;
> +	case 24:
> +		reg = 0x8a; break;
> +	default:
> +	case 60:
> +		reg = 0x0a;
> +	}
> +
> +	/* 0820 */
> +	adv7441a_i2c_usermap_write8(state, 0x69, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0x00, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0xc3, 0x31);
> +	adv7441a_i2c_usermap_write8(state, 0xc4, 0xc2);
> +	adv7441a_i2c_usermap_write8(state, 0x3a, 0x01);
> +	adv7441a_i2c_usermap_write8(state, 0xf3, 0x00);
> +
> +	adv7441a_i2c_usermap_write8(state, 0x03, 0x85);
> +	adv7441a_i2c_usermap_write8(state, 0x04, 0x1c);
> +	adv7441a_i2c_usermap_write8(state, 0x05, 0x01);
> +	adv7441a_i2c_usermap_write8(state, 0x06, reg);
> +	adv7441a_i2c_usermap_write8(state, 0x0c, 0x0c);
> +	adv7441a_i2c_usermap_write8(state, 0x1d, 0x40);
> +	adv7441a_i2c_usermap_write8(state, 0x37, 0xa1);
> +	adv7441a_i2c_usermap_write8(state, 0x3c, 0xa8);
> +	adv7441a_i2c_usermap_write8(state, 0x47, 0x0a);
> +	adv7441a_i2c_usermap_write8(state, 0x68, 0xf0);
> +	adv7441a_i2c_usermap_write8(state, 0x6b, 0xe7);
> +	adv7441a_i2c_usermap_write8(state, 0x7b, 0x0f);
> +	adv7441a_i2c_usermap_write8(state, 0x86, 0x0b);
> +	adv7441a_i2c_usermap_write8(state, 0xc9, 0x04);
> +	adv7441a_i2c_usermap_write8(state, 0xf4, 0x15);
> +
> +	return 0;
> +}
> +
> +static int adv7441a_YPRPB_1920x1080px30(struct adv7441a_state *state)
> +{
> +	dprintk(1, "%s()\n", __func__);
> +
> +	/* 0820 */
> +	adv7441a_i2c_usermap_write8(state, 0x69, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0x00, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0xc3, 0x31);
> +	adv7441a_i2c_usermap_write8(state, 0xc4, 0xc2);
> +	adv7441a_i2c_usermap_write8(state, 0x3a, 0x01);
> +	adv7441a_i2c_usermap_write8(state, 0xf3, 0x00);
> +
> +	adv7441a_i2c_usermap_write8(state, 0x03, 0x85);
> +	adv7441a_i2c_usermap_write8(state, 0x04, 0x1c);
> +	adv7441a_i2c_usermap_write8(state, 0x05, 0x01);
> +	adv7441a_i2c_usermap_write8(state, 0x06, 0x0b);
> +	adv7441a_i2c_usermap_write8(state, 0x0c, 0x0c);
> +	adv7441a_i2c_usermap_write8(state, 0x1d, 0x40);
> +	adv7441a_i2c_usermap_write8(state, 0x37, 0xa1);
> +	adv7441a_i2c_usermap_write8(state, 0x3c, 0xa8);
> +	adv7441a_i2c_usermap_write8(state, 0x47, 0x0a);
> +	adv7441a_i2c_usermap_write8(state, 0x68, 0xf0);
> +	adv7441a_i2c_usermap_write8(state, 0x6b, 0xe7);
> +	adv7441a_i2c_usermap_write8(state, 0x7b, 0x0f);
> +	adv7441a_i2c_usermap_write8(state, 0x86, 0x0b);
> +	adv7441a_i2c_usermap_write8(state, 0xc9, 0x04);
> +	adv7441a_i2c_usermap_write8(state, 0xf4, 0x15);
> +
> +	return 0;
> +}
> +
> +static int adv7441a_YPRPB_1920x1080i(struct adv7441a_state *state,
> +	int rateHz)
> +{
> +	u8 reg;
> +	dprintk(1, "%s(%d)\n", __func__, rateHz);
> +
> +	switch (rateHz) {
> +	case 50:
> +		reg = 0x2c; break;
> +	case 30:
> +		reg = 0x4c; break;
> +	case 25:
> +		reg = 0x6c; break;
> +	case 24:
> +		reg = 0x8c; break;
> +	default:
> +	case 60:
> +		reg = 0x0c;
> +	}
> +
> +	/* 0820 */
> +	adv7441a_i2c_usermap_write8(state, 0x69, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0x00, 0x00);
> +	adv7441a_i2c_usermap_write8(state, 0xc3, 0x31);
> +	adv7441a_i2c_usermap_write8(state, 0xc4, 0xc2);
> +	adv7441a_i2c_usermap_write8(state, 0x3a, 0x01);
> +	adv7441a_i2c_usermap_write8(state, 0xf3, 0x00);
> +
> +	adv7441a_i2c_usermap_write8(state, 0x03, 0x85);
> +	adv7441a_i2c_usermap_write8(state, 0x04, 0x1c);
> +	adv7441a_i2c_usermap_write8(state, 0x05, 0x01);
> +	adv7441a_i2c_usermap_write8(state, 0x06, reg);
> +	adv7441a_i2c_usermap_write8(state, 0x0c, 0x0c);
> +	adv7441a_i2c_usermap_write8(state, 0x1d, 0x40);
> +	adv7441a_i2c_usermap_write8(state, 0x37, 0xa1);
> +	adv7441a_i2c_usermap_write8(state, 0x3c, 0xa8);
> +	adv7441a_i2c_usermap_write8(state, 0x47, 0x0a);
> +	adv7441a_i2c_usermap_write8(state, 0x68, 0xf0);
> +	adv7441a_i2c_usermap_write8(state, 0x6b, 0xe7);
> +	adv7441a_i2c_usermap_write8(state, 0x7b, 0x0f);
> +	adv7441a_i2c_usermap_write8(state, 0x86, 0x0b);
> +	adv7441a_i2c_usermap_write8(state, 0xc9, 0x04);
> +	adv7441a_i2c_usermap_write8(state, 0xf4, 0x15);
> +
> +	return 0;
> +}
> +
> +static int adv7441a_HDMI_720x480ix60(struct adv7441a_state *state)
> +{
> +	dprintk(1, "%s()\n", __func__);
> +
> +	adv7441a_i2c_usermap_write8(state, 0x03, 0x85);
> +	adv7441a_i2c_usermap_write8(state, 0x04, 0x1c);
> +	adv7441a_i2c_usermap_write8(state, 0x05, 0x04);
> +	adv7441a_i2c_usermap_write8(state, 0x06, 0x0c);
> +	adv7441a_i2c_usermap_write8(state, 0x0c, 0x37);
> +	adv7441a_i2c_usermap_write8(state, 0x1d, 0x40);
> +	adv7441a_i2c_usermap_write8(state, 0x37, 0xa1);
> +	adv7441a_i2c_usermap_write8(state, 0x3c, 0xa8);
> +	adv7441a_i2c_usermap_write8(state, 0x0a, 0xff);
> +	adv7441a_i2c_usermap_write8(state, 0x47, 0x0a);
> +	adv7441a_i2c_usermap_write8(state, 0x68, 0xf0);
> +	adv7441a_i2c_usermap_write8(state, 0x6b, 0xe7);
> +	adv7441a_i2c_usermap_write8(state, 0x7b, 0x0f);
> +	adv7441a_i2c_usermap_write8(state, 0x85, 0x19);
> +	adv7441a_i2c_usermap_write8(state, 0x86, 0x0b);
> +	/* HDMI_MODE = 1 FREE RUN */
> +	adv7441a_i2c_usermap_write8(state, 0xba, 0xa0 | 1);
> +	adv7441a_i2c_usermap_write8(state, 0xc9, 0x04);
> +	adv7441a_i2c_usermap_write8(state, 0xc8, 0x08);
> +	adv7441a_i2c_usermap_write8(state, 0xf3, 0x07);
> +	adv7441a_i2c_usermap_write8(state, 0xf4, 0x95);
> +
> +	/* VRX_USER_2_MAP_ADDR */
> +	adv7441a_i2c_user2map_write8(state, 0xf0, 0x10);
> +	adv7441a_i2c_user2map_write8(state, 0xf1, 0x0f);
> +	adv7441a_i2c_user2map_write8(state, 0xf4, 0x20);
> +
> +	/* VRX_HDMI_MAP_ADDR */
> +	/* Pixel Repetition override and 2X */
> +	adv7441a_i2c_hdmimap_write8(state, 0x41, 0x51);
> +	adv7441a_i2c_hdmimap_write8(state, 0x15, 0xec);
> +	adv7441a_i2c_hdmimap_write8(state, 0x1c, 0x4b);
> +	adv7441a_i2c_hdmimap_write8(state, 0x1d, 0x04);
> +	adv7441a_i2c_hdmimap_write8(state, 0x3c, 0x82);
> +	adv7441a_i2c_hdmimap_write8(state, 0x5a, 0x00);
> +
> +	return 0;
> +}
> +
> +static int adv7441a_HDMI_720x576px25(struct adv7441a_state *state)
> +{
> +	/* HDMI res = 625P */
> +	dprintk(1, "%s()\n", __func__);
> +
> +	adv7441a_i2c_usermap_write8(state, 0x03, 0x85);
> +	adv7441a_i2c_usermap_write8(state, 0x04, 0x1c);
> +	adv7441a_i2c_usermap_write8(state, 0x05, 0x05);
> +	adv7441a_i2c_usermap_write8(state, 0x06, 0x05);
> +	adv7441a_i2c_usermap_write8(state, 0x0c, 0x37);
> +	adv7441a_i2c_usermap_write8(state, 0x1d, 0x40);
> +	adv7441a_i2c_usermap_write8(state, 0x37, 0xa1);
> +	adv7441a_i2c_usermap_write8(state, 0x3c, 0xa8);
> +	adv7441a_i2c_usermap_write8(state, 0x0a, 0xff);
> +	adv7441a_i2c_usermap_write8(state, 0x47, 0x0a);
> +	adv7441a_i2c_usermap_write8(state, 0x68, 0xf0);
> +	adv7441a_i2c_usermap_write8(state, 0x6b, 0xe7);
> +	adv7441a_i2c_usermap_write8(state, 0x7b, 0x0f);
> +	adv7441a_i2c_usermap_write8(state, 0x85, 0x19);
> +	adv7441a_i2c_usermap_write8(state, 0x86, 0x0b);
> +	/* HDMI_MODE = 1 FREE RUN */
> +	adv7441a_i2c_usermap_write8(state, 0xba, 0xa0 | 1);
> +	adv7441a_i2c_usermap_write8(state, 0xc9, 0x04);
> +	adv7441a_i2c_usermap_write8(state, 0xc8, 0x08);
> +	adv7441a_i2c_usermap_write8(state, 0xf3, 0x07);
> +	adv7441a_i2c_usermap_write8(state, 0xf4, 0x95);
> +
> +	/* VRX_USER_2_MAP_ADDR */
> +	adv7441a_i2c_user2map_write8(state, 0xf0, 0x10);
> +	adv7441a_i2c_user2map_write8(state, 0xf1, 0x0f);
> +	adv7441a_i2c_user2map_write8(state, 0xf4, 0x20);
> +
> +	/* VRX_HDMI_MAP_ADDR */
> +	adv7441a_i2c_hdmimap_write8(state, 0x15, 0xec);
> +	adv7441a_i2c_hdmimap_write8(state, 0x1c, 0x4b);
> +	adv7441a_i2c_hdmimap_write8(state, 0x1d, 0x04);
> +	adv7441a_i2c_hdmimap_write8(state, 0x3c, 0x82);
> +	adv7441a_i2c_hdmimap_write8(state, 0x5a, 0x00);
> +
> +	return 0;
> +}
> +
> +static int adv7441a_HDMI_720x576ix50(struct adv7441a_state *state)
> +{
> +	dprintk(1, "%s()\n", __func__);
> +
> +	adv7441a_i2c_usermap_write8(state, 0x03, 0x85);
> +	adv7441a_i2c_usermap_write8(state, 0x04, 0x1c);
> +	adv7441a_i2c_usermap_write8(state, 0x05, 0x04);
> +	adv7441a_i2c_usermap_write8(state, 0x06, 0x0d);
> +	adv7441a_i2c_usermap_write8(state, 0x0c, 0x37);
> +	adv7441a_i2c_usermap_write8(state, 0x1d, 0x40);
> +	adv7441a_i2c_usermap_write8(state, 0x37, 0xa1);
> +	adv7441a_i2c_usermap_write8(state, 0x3c, 0xa8);
> +	adv7441a_i2c_usermap_write8(state, 0x0a, 0xff);
> +	adv7441a_i2c_usermap_write8(state, 0x47, 0x0a);
> +	adv7441a_i2c_usermap_write8(state, 0x68, 0xf0);
> +	adv7441a_i2c_usermap_write8(state, 0x6b, 0xe7);
> +	adv7441a_i2c_usermap_write8(state, 0x7b, 0x0f);
> +	adv7441a_i2c_usermap_write8(state, 0x85, 0x19);
> +	adv7441a_i2c_usermap_write8(state, 0x86, 0x0b);
> +	/* HDMI_MODE = 1 FREE RUN */
> +	adv7441a_i2c_usermap_write8(state, 0xba, 0xa0 | 1);
> +	adv7441a_i2c_usermap_write8(state, 0xc9, 0x04);
> +	adv7441a_i2c_usermap_write8(state, 0xc8, 0x08);
> +	adv7441a_i2c_usermap_write8(state, 0xf3, 0x07);
> +	adv7441a_i2c_usermap_write8(state, 0xf4, 0x95);
> +
> +	/* VRX_USER_2_MAP_ADDR */
> +	adv7441a_i2c_user2map_write8(state, 0xf0, 0x10);
> +	adv7441a_i2c_user2map_write8(state, 0xf1, 0x0f);
> +	adv7441a_i2c_user2map_write8(state, 0xf4, 0x20);
> +
> +	/* VRX_HDMI_MAP_ADDR */
> +	/* Pixel Repetition override and 2X */
> +	adv7441a_i2c_hdmimap_write8(state, 0x41, 0x51);
> +	adv7441a_i2c_hdmimap_write8(state, 0x15, 0xec);
> +	adv7441a_i2c_hdmimap_write8(state, 0x1c, 0x4b);
> +	adv7441a_i2c_hdmimap_write8(state, 0x1d, 0x04);
> +	adv7441a_i2c_hdmimap_write8(state, 0x3c, 0x82);
> +	adv7441a_i2c_hdmimap_write8(state, 0x5a, 0x00);
> +
> +	return 0;
> +}
> +
> +static int adv7441a_HDMI_1280x720px60(struct adv7441a_state *state)
> +{
> +	dprintk(1, "%s()\n", __func__);
> +
> +	/* HDMI PORT A 1280x720p 60Hz 20bit 422 */
> +	/* VC8x0 */
> +	adv7441a_i2c_usermap_write8(state, 0x03, 0x85);
> +	adv7441a_i2c_usermap_write8(state, 0x04, 0x1c);
> +	adv7441a_i2c_usermap_write8(state, 0x05, 0x05);
> +	adv7441a_i2c_usermap_write8(state, 0x06, 0x0a);
> +	adv7441a_i2c_usermap_write8(state, 0x0c, 0x37);
> +	adv7441a_i2c_usermap_write8(state, 0x1d, 0x40);
> +	adv7441a_i2c_usermap_write8(state, 0x37, 0xa1);
> +	adv7441a_i2c_usermap_write8(state, 0x3c, 0xa8);
> +	adv7441a_i2c_usermap_write8(state, 0x0a, 0xff);
> +	adv7441a_i2c_usermap_write8(state, 0x47, 0x0a);
> +	adv7441a_i2c_usermap_write8(state, 0x68, 0xf0);
> +	adv7441a_i2c_usermap_write8(state, 0x6b, 0xe7);
> +	adv7441a_i2c_usermap_write8(state, 0x7b, 0x0f);
> +	adv7441a_i2c_usermap_write8(state, 0x85, 0x19);
> +	adv7441a_i2c_usermap_write8(state, 0x86, 0x0b);
> +	/* HDMI_MODE = 1 FREE RUN */
> +	adv7441a_i2c_usermap_write8(state, 0xba, 0xa0 | 1);
> +	adv7441a_i2c_usermap_write8(state, 0xc9, 0x04);
> +	adv7441a_i2c_usermap_write8(state, 0xc8, 0x08);
> +	adv7441a_i2c_usermap_write8(state, 0xf3, 0x07);
> +	adv7441a_i2c_usermap_write8(state, 0xf4, 0x95);
> +
> +	/* VRX_USER_2_MAP_ADDR */
> +	adv7441a_i2c_user2map_write8(state, 0xf0, 0x10);
> +	adv7441a_i2c_user2map_write8(state, 0xf1, 0x0f);
> +	adv7441a_i2c_user2map_write8(state, 0xf4, 0x20);
> +
> +	/* VRX_HDMI_MAP_ADDR */
> +	adv7441a_i2c_hdmimap_write8(state, 0x15, 0xec);
> +	adv7441a_i2c_hdmimap_write8(state, 0x1c, 0x4b);
> +	adv7441a_i2c_hdmimap_write8(state, 0x1d, 0x04);
> +	adv7441a_i2c_hdmimap_write8(state, 0x3c, 0x82);
> +	adv7441a_i2c_hdmimap_write8(state, 0x5a, 0x00);
> +
> +	return 0;
> +}
> +
> +static int adv7441a_HDMI_1920x1080ix60(struct adv7441a_state *state)
> +{
> +	dprintk(1, "%s()\n", __func__);
> +
> +	/* HDMI PORT A 1920x1080i 60Hz 20bit 422 */
> +	/* VC8x0 */
> +	adv7441a_i2c_usermap_write8(state, 0x03, 0x85);
> +	adv7441a_i2c_usermap_write8(state, 0x04, 0x1c);
> +	adv7441a_i2c_usermap_write8(state, 0x05, 0x05);
> +	adv7441a_i2c_usermap_write8(state, 0x06, 0x0c);
> +	adv7441a_i2c_usermap_write8(state, 0x0c, 0x37);
> +	adv7441a_i2c_usermap_write8(state, 0x1d, 0x40);
> +	adv7441a_i2c_usermap_write8(state, 0x37, 0xa1);
> +	adv7441a_i2c_usermap_write8(state, 0x3c, 0xa8);
> +	adv7441a_i2c_usermap_write8(state, 0x0a, 0xff);
> +	adv7441a_i2c_usermap_write8(state, 0x47, 0x0a);
> +	adv7441a_i2c_usermap_write8(state, 0x68, 0xf0);
> +	adv7441a_i2c_usermap_write8(state, 0x6b, 0xe7);
> +	adv7441a_i2c_usermap_write8(state, 0x7b, 0x0f);
> +	adv7441a_i2c_usermap_write8(state, 0x85, 0x19);
> +	adv7441a_i2c_usermap_write8(state, 0x86, 0x0b);
> +
> +	/* HDMI_MODE = 1 FREE RUN */
> +	adv7441a_i2c_usermap_write8(state, 0xba, 0xa0 | 1);
> +	adv7441a_i2c_usermap_write8(state, 0xc9, 0x04);
> +	adv7441a_i2c_usermap_write8(state, 0xc8, 0x08);
> +	adv7441a_i2c_usermap_write8(state, 0xf3, 0x07);
> +	adv7441a_i2c_usermap_write8(state, 0xf4, 0x95);
> +
> +	/* VRX_USER_2_MAP_ADDR */
> +	adv7441a_i2c_user2map_write8(state, 0xf0, 0x10);
> +	adv7441a_i2c_user2map_write8(state, 0xf1, 0x0f);
> +	adv7441a_i2c_user2map_write8(state, 0xf4, 0x20);
> +
> +	/* VRX_HDMI_MAP_ADDR */
> +	adv7441a_i2c_hdmimap_write8(state, 0x15, 0xec);
> +	adv7441a_i2c_hdmimap_write8(state, 0x1c, 0x4b);
> +	adv7441a_i2c_hdmimap_write8(state, 0x1d, 0x04);
> +	adv7441a_i2c_hdmimap_write8(state, 0x3c, 0x82);
> +	adv7441a_i2c_hdmimap_write8(state, 0x5a, 0x00);
> +
> +	return 0;
> +}
> +
> +static int adv7441a_HDMI_1920x1080px60(struct adv7441a_state *state,
> +	int tdmsfix)
> +{
> +	dprintk(1, "%s(%d)\n", __func__, tdmsfix);
> +
> +	/* 1920x1080p */
> +	/* VC8x0 */
> +	adv7441a_i2c_usermap_write8(state, 0x03, 0x85);
> +	adv7441a_i2c_usermap_write8(state, 0x04, 0x1c);
> +	adv7441a_i2c_usermap_write8(state, 0x05, 0x05);
> +	adv7441a_i2c_usermap_write8(state, 0x06, 0x0b);
> +	adv7441a_i2c_usermap_write8(state, 0x0c, 0x3c);
> +	adv7441a_i2c_usermap_write8(state, 0x1d, 0x40);
> +	adv7441a_i2c_usermap_write8(state, 0x37, 0xa1);
> +	adv7441a_i2c_usermap_write8(state, 0x3c, 0xa8);
> +	adv7441a_i2c_usermap_write8(state, 0x0a, 0xff);
> +	adv7441a_i2c_usermap_write8(state, 0x47, 0x0a);
> +	adv7441a_i2c_usermap_write8(state, 0x68, 0xf0);
> +	adv7441a_i2c_usermap_write8(state, 0x6b, 0xe7);
> +	adv7441a_i2c_usermap_write8(state, 0x7b, 0x0f);
> +	adv7441a_i2c_usermap_write8(state, 0x85, 0x19);
> +	adv7441a_i2c_usermap_write8(state, 0x86, 0x0b);
> +	/* HDMI_MODE = 1 FREE RUN */
> +	adv7441a_i2c_usermap_write8(state, 0xba, 0xa0 | 1);
> +	adv7441a_i2c_usermap_write8(state, 0xc9, 0x04);
> +	adv7441a_i2c_usermap_write8(state, 0xc8, 0x08);
> +	adv7441a_i2c_usermap_write8(state, 0xf3, 0x07);
> +	adv7441a_i2c_usermap_write8(state, 0xf4, 0x95);
> +
> +	/* VRX_USER_2_MAP_ADDR */
> +	adv7441a_i2c_user2map_write8(state, 0xf0, 0x30);
> +	adv7441a_i2c_user2map_write8(state, 0xf1, 0x0f);
> +	adv7441a_i2c_user2map_write8(state, 0xf4, 0xa0);
> +
> +	/* VRX_HDMI_MAP_ADDR */
> +	/* Pixel Repetition Not set (1x) */
> +	adv7441a_i2c_hdmimap_write8(state, 0x41, 0x40);
> +	adv7441a_i2c_hdmimap_write8(state, 0x15, 0xec);
> +	adv7441a_i2c_hdmimap_write8(state, 0x1c, 0x4b);
> +	adv7441a_i2c_hdmimap_write8(state, 0x1d, 0x04);
> +	adv7441a_i2c_hdmimap_write8(state, 0x3c, 0x82);
> +
> +	if (tdmsfix)
> +		adv7441a_i2c_hdmimap_write8(state, 0x47, 0x00);
> +	else
> +		adv7441a_i2c_hdmimap_write8(state, 0x47, 0x05);
> +
> +	adv7441a_i2c_hdmimap_write8(state, 0x5a, 0x01);
> +
> +	return 0;
> +}
> +/* End - Per resolution / format configuration settings */
> +
> +static int adv7441a_set_format_DVI(struct adv7441a_state *state,
> +	struct adv7441a_format *fmt)
> +{
> +	int ret = 0;
> +
> +	dprintk(1, "%s(%p, %d) [%s]\n", __func__, state, fmt->id, fmt->name);
> +
> +	switch (fmt->id) {
> +	case ADV7441A_FORMAT_720x576p25:
> +		adv7441a_HDMI_720x576px25(state);
> +		break;
> +	case ADV7441A_FORMAT_720x576i50:
> +		adv7441a_HDMI_720x576ix50(state);
> +		break;
> +	case ADV7441A_FORMAT_720x480i59:
> +	case ADV7441A_FORMAT_720x480i60:
> +		adv7441a_HDMI_720x480ix60(state);
> +		break;
> +	case ADV7441A_FORMAT_1280x720p23:
> +	case ADV7441A_FORMAT_1280x720p24:
> +	case ADV7441A_FORMAT_1280x720p25:
> +	case ADV7441A_FORMAT_1280x720p29:
> +	case ADV7441A_FORMAT_1280x720p30:
> +	case ADV7441A_FORMAT_1280x720p50:
> +	case ADV7441A_FORMAT_1280x720p59:
> +	case ADV7441A_FORMAT_1280x720p60:
> +		adv7441a_HDMI_1280x720px60(state);
> +		break;
> +	case ADV7441A_FORMAT_1920x1080i50:
> +	case ADV7441A_FORMAT_1920x1080i59:
> +	case ADV7441A_FORMAT_1920x1080i60:
> +		adv7441a_HDMI_1920x1080ix60(state);
> +		break;
> +	case ADV7441A_FORMAT_1920x1080p23:
> +	case ADV7441A_FORMAT_1920x1080p24:
> +	case ADV7441A_FORMAT_1920x1080p25:
> +	case ADV7441A_FORMAT_1920x1080p29:
> +	case ADV7441A_FORMAT_1920x1080p30:
> +	case ADV7441A_FORMAT_1920x1080p50:
> +		adv7441a_HDMI_1920x1080px60(state, 0);
> +		break;
> +	case ADV7441A_FORMAT_1920x1080p60:
> +		adv7441a_HDMI_1920x1080px60(state, 1);
> +		break;
> +	default:
> +		pr_err("%s() huh?\n", __func__);
> +		ret = -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +
> +static int adv7441a_set_format_YPRPB(struct adv7441a_state *state,
> +	struct adv7441a_format *fmt)
> +{
> +	int ret = 0;
> +
> +	dprintk(1, "%s(%p, %d) [%s]\n", __func__, state, fmt->id, fmt->name);
> +
> +	switch (fmt->id) {
> +	case ADV7441A_FORMAT_720x480i59:
> +	case ADV7441A_FORMAT_720x480i60:
> +		adv7441a_YPRPB_720x480ix60(state);
> +		break;
> +	case ADV7441A_FORMAT_720x576p25:
> +		adv7441a_YPRPB_720x576px25(state);
> +		break;
> +	case ADV7441A_FORMAT_720x576i50:
> +		adv7441a_YPRPB_720x576ix50(state);
> +		break;
> +	case ADV7441A_FORMAT_1280x720p23:
> +	case ADV7441A_FORMAT_1280x720p24:
> +		adv7441a_YPRPB_1280x720p(state, 24);
> +		break;
> +	case ADV7441A_FORMAT_1280x720p25:
> +		adv7441a_YPRPB_1280x720p(state, 25);
> +		break;
> +	case ADV7441A_FORMAT_1280x720p29:
> +	case ADV7441A_FORMAT_1280x720p30:
> +		adv7441a_YPRPB_1280x720p(state, 30);
> +		break;
> +	case ADV7441A_FORMAT_1280x720p50:
> +		adv7441a_YPRPB_1280x720p(state, 50);
> +		break;
> +	case ADV7441A_FORMAT_1280x720p59:
> +	case ADV7441A_FORMAT_1280x720p60:
> +		adv7441a_YPRPB_1280x720p(state, 60);
> +		break;
> +	case ADV7441A_FORMAT_1920x1080p30:
> +		adv7441a_YPRPB_1920x1080px30(state);
> +		break;
> +	case ADV7441A_FORMAT_1920x1080i50:
> +		adv7441a_YPRPB_1920x1080i(state, 50);
> +		break;
> +	case ADV7441A_FORMAT_1920x1080i59:
> +	case ADV7441A_FORMAT_1920x1080i60:
> +		adv7441a_YPRPB_1920x1080i(state, 60);
> +		break;
> +	default:
> +		pr_err("%s(%p, %d) huh?\n", __func__, state, fmt->id);
> +		ret = -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +
> +static int adv7441a_set_format_COMPOSITE(struct adv7441a_state *state,
> +	struct adv7441a_format *fmt, int inputnr)
> +{
> +	int ret = 0;
> +
> +	dprintk(1, "%s(%p, %d, %d) [%s]\n", __func__, state,
> +		fmt->id, inputnr, fmt->name);
> +
> +	switch (fmt->id) {
> +	case ADV7441A_FORMAT_720x576p25:
> +	case ADV7441A_FORMAT_720x576i50:
> +		adv7441a_CVBS_720x480ix60(state, inputnr);
> +		state->vbi_enabled = 0;
> +		break;
> +	case ADV7441A_FORMAT_720x480i59:
> +	case ADV7441A_FORMAT_720x480i60:
> +		adv7441a_CVBS_720x480ix60(state, inputnr);
> +		state->vbi_enabled = 1;
> +		break;
> +	default:
> +		pr_err("%s(%p, %d, %d) huh?\n", __func__, state,
> +			fmt->id, inputnr);
> +		ret = -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +
> +static int adv7441a_set_format_SVIDEO(struct adv7441a_state *state,
> +	struct adv7441a_format *fmt)
> +{
> +	int ret = 0;
> +
> +	dprintk(1, "%s(%p, %d) [%s]\n", __func__, state, fmt->id, fmt->name);
> +
> +	switch (fmt->id) {
> +	case ADV7441A_FORMAT_720x576p25:
> +	case ADV7441A_FORMAT_720x576i50:
> +		adv7441a_SVIDEO_720x480ix60(state);
> +		state->vbi_enabled = 0;
> +		break;
> +	case ADV7441A_FORMAT_720x480i59:
> +	case ADV7441A_FORMAT_720x480i60:
> +		adv7441a_SVIDEO_720x480ix60(state);
> +		state->vbi_enabled = 1;
> +		break;
> +	default:
> +		pr_err("%s(%p, %d) huh?\n", __func__, state, fmt->id);
> +		ret = -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +#if 0
> +static int adv7441a_set_format_VGA(struct adv7441a_state *state,
> +	struct adv7441a_format *fmt)
> +{
> +	int ret = 0;
> +
> +	dprintk(1, "%s(%p, %d) [%s]\n", __func__, state, fmt->id, fmt->name);
> +
> +	switch (fmt->id) {
> +	case ADV7441A_FORMAT_640x480p60:
> +		state->vbi_enabled = 0;
> +		adv7441a_VGA_640x480ix60(state, timing);
> +		break;
> +	case ADV7441A_FORMAT_800x600p60:
> +		state->vbi_enabled = 0;
> +		adv7441a_VGA_800x600px60(state, timing);
> +		break;
> +	case ADV7441A_FORMAT_1024x768p60:
> +		state->vbi_enabled = 0;
> +		adv7441a_VGA_1024x768px60(state, timing);
> +		break;
> +	case ADV7441A_FORMAT_1280x720p23:
> +	case ADV7441A_FORMAT_1280x720p60:
> +		state->vbi_enabled = 0;
> +		adv7441a_VGA_1280x720px60(state, timing);
> +		break;
> +	case ADV7441A_FORMAT_1280x960p60:
> +		state->vbi_enabled = 0;
> +		adv7441a_VGA_1280x960px60(state, timing);
> +		break;
> +	case ADV7441A_FORMAT_1280x1024p60:
> +		state->vbi_enabled = 0;
> +		adv7441a_VGA_1280x1024px60(state, timing);
> +		break;
> +	case ADV7441A_FORMAT_1400x1050p60:
> +		state->vbi_enabled = 0;
> +		adv7441a_VGA_1400x1050px60(state, timing);
> +		break;
> +	case ADV7441A_FORMAT_1600x1200p60:
> +	case ADV7441A_FORMAT_UXGA_1600x1200p60:
> +		adv7441a_UXGA_1600x1200x60(state, timing);
> +		state->vbi_enabled = 0;
> +		break;
> +	case ADV7441A_FORMAT_WXGA_1440x900p60:
> +		adv7441a_WXGA_1440x900x60(state, timing);
> +		state->vbi_enabled = 0;
> +		break;
> +	case ADV7441A_FORMAT_WSXGA_1680x1050p60:
> +		adv7441a_WSXGA_1680x1050x60(state, timing);
> +		state->vbi_enabled = 0;
> +		break;
> +	case ADV7441A_FORMAT_VGAHD_1920x1080p60:
> +		adv7441a_VGAHD_1920x1080x60(state, timing);
> +		state->vbi_enabled = 0;
> +		break;

Hmm... on all the above, vbi_enabled is equal to zero. Better to move it
out of the switch(), in order to simplify this function.

> +	default:
> +		pr_err("%s(%p, %d) huh?\n", __func__, state, fmt->id);
> +		ret = -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +#endif
> +
> +static int adv7441a_set_format(struct v4l2_subdev *sd, u32 fmtid)
> +{
> +	struct adv7441a_state *state = to_state(sd);
> +	struct adv7441a_format *fmt;
> +	int ret = -ENODEV;
> +
> +	dprintk(1, "%s(%p, %d)\n", __func__, state, fmtid);
> +
> +	fmt = find_format(state, fmtid);
> +	if (!fmt) {
> +		return -EINVAL;
> +	}
> +
> +	dprintk(1, "%s(%p, %d) [%s]\n", __func__, state, fmt->id, fmt->name);
> +
> +	adv7441a_sw_reset(state);
> +
> +	switch (state->video_input_nr) {
> +	case ADV7441A_INPUT_DVI:
> +		ret = adv7441a_set_format_DVI(state, fmt);
> +		break;
> +	case ADV7441A_INPUT_YPRPB:
> +		ret = adv7441a_set_format_YPRPB(state, fmt);
> +		break;
> +	case ADV7441A_INPUT_VGA:
> +#if 0
> +		ret = adv7441a_set_format_VGA(state, fmt);
> +#endif
> +		break;
> +	case ADV7441A_INPUT_COMPOSITE1:
> +		ret = adv7441a_set_format_COMPOSITE(state, fmt, 1);
> +		break;
> +	case ADV7441A_INPUT_COMPOSITE2:
> +		ret = adv7441a_set_format_COMPOSITE(state, fmt, 2);
> +		break;
> +	case ADV7441A_INPUT_COMPOSITE3:
> +		ret = adv7441a_set_format_COMPOSITE(state, fmt, 3);
> +		break;
> +	case ADV7441A_INPUT_SVIDEO:
> +		ret = adv7441a_set_format_SVIDEO(state, fmt);
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	if (ret == 0)
> +		state->fmt = fmt;
> +	else
> +		state->fmt = 0;
> +
> +	/* Free run */
> +	adv7441a_i2c_usermap_write8(state, 0xbf, 0x12);
> +
> +	return ret;
> +}
> +
> +/* Hmm: Do I extend the official list of DV presets, which
> + * are exposed to the public, or keep the format id,
> + * used to select a configuration format for the device
> + * internal to the kernel? Use s_dv_preset or s_routing?

If the DV is a standardized one, it should be at:
	include/linux/v4l2-dv-timings.h
(if you find anything missing there, feel free to add)

Are there any missing timing above?

> + * Internal by default.
> + * I'll repurpose the s_routing config field
> + * so that I pass the input and format configuration
> + * atomically.
> + */
> +static int adv7441a_s_routing(struct v4l2_subdev *sd,
> +	u32 input, u32 output, u32 config)
> +{
> +	struct adv7441a_state *state = to_state(sd);
> +
> +	int ret = 0;
> +	dprintk(1, "%s(%p, %d [%s], config = 0x%x)\n", __func__, state,
> +		input,
> +		input == ADV7441A_INPUT_DVI ? "DVI" :
> +		input == ADV7441A_INPUT_YPRPB ? "YPRPB" :
> +		input == ADV7441A_INPUT_VGA ? "VGA" :
> +		input == ADV7441A_INPUT_SVIDEO ? "SVIDEO" :
> +		input == ADV7441A_INPUT_COMPOSITE1 ? "COMPOSITE1" :
> +		input == ADV7441A_INPUT_COMPOSITE2 ? "COMPOSITE2" :
> +		input == ADV7441A_INPUT_COMPOSITE3 ? "COMPOSITE3" :
> +		"UNDEFINED",
> +		config
> +		);
> +
> +	state->video_input_nr = input;
> +	if (config) {
> +		ret = adv7441a_set_format(sd, config);
> +	}
> +
> +	return ret;
> +}
> +
> +static int adv7441a_set_edid(struct v4l2_subdev *sd,
> +	u8 *data, int len)
> +{

There is an EDID API at V4L2. Perhaps you may need to use it, if
userspace is able to control it.

> +	struct adv7441a_state *state = to_state(sd);
> +	int i;
> +
> +	dprintk(1, "%s(len=%d)\n", __func__, len);
> +
> +	if (len != 256) {
> +		pr_err("%s() edid len %d is invalid\n", __func__, len);
> +		return -EINVAL;
> +	}
> +
> +	v4l2_subdev_notify(sd, ADV7441A_HOTPLUG, (void *)0);
> +
> +	for (i = 0; i < 256; i++)
> +		adv7441a_i2c_edidmap_write8(state, i, *(data + i));
> +
> +	adv7441a_i2c_rksvmap_write8(state, 0x70, 0x02);
> +	adv7441a_i2c_rksvmap_write8(state, 0x71, 0x03);
> +	adv7441a_i2c_rksvmap_write8(state, 0x72, 0x80);
> +	adv7441a_i2c_rksvmap_write8(state, 0x73, 0x06);
> +
> +	msleep(20);
> +#if 0
> +	/* Enable our background poll worker after 250ms */
> +	queue_delayed_work(state->work_queues,
> +		&state->delayed_work_enable_hotplug, HZ / 4);
> +#endif
> +	return 0;
> +}
> +
> +void adv7441a_audio_reset_pll(struct adv7441a_state *state)
> +{
> +	/* Reset audio PLL */
> +	adv7441a_i2c_hdmimap_setbit(state, 0x5a, 0x03);
> +}
> +
> +void adv7441a_audio_configure_pll(struct adv7441a_state *state)
> +{
> +	u8 v, t[3];
> +	u32 n, cts, tdms;
> +	u32 tmp, tmp2, tmp3;
> +	u32 xtal = 28636360;
> +
> +	/* GET N */
> +	adv7441a_i2c_hdmimap_read8(state, 0x5b, &v);
> +	adv7441a_i2c_hdmimap_read8(state, 0x5d, &t[0]);
> +	adv7441a_i2c_hdmimap_read8(state, 0x5e, &t[1]);
> +	adv7441a_i2c_hdmimap_read8(state, 0x5f, &t[2]);
> +	n = ((t[0] & 0x0f) << 16) | (t[1] << 8) | t[2];
> +
> +	/* GET CTS */
> +	adv7441a_i2c_hdmimap_read8(state, 0x5b, &t[0]);
> +	adv7441a_i2c_hdmimap_read8(state, 0x5c, &t[1]);
> +	adv7441a_i2c_hdmimap_read8(state, 0x5d, &t[2]);
> +	cts = (t[0] << 12) | (t[1] << 4) | ((t[2] & 0xf0) >> 4);
> +
> +	/* GET TDMS Frequency */
> +	adv7441a_i2c_hdmimap_read8(state, 0x06, &v);
> +	tmp = xtal / 10;
> +	tmp2 = 27000000 / 10;
> +	tmp3 = tmp * v;
> +	tdms = tmp3 / tmp2;
> +
> +	/* Update the Audio PLL */
> +	if (cts) {
> +		tmp = tdms * (n / cts);
> +		tmp = (tmp * 1000) >> 7;
> +		if (tmp >= 150) {
> +			dprintk(1, "%s() Setting A\n", __func__);
> +			adv7441a_i2c_hdmimap_write8(state, 0x3d, 0x80);
> +		} else {
> +			dprintk(1, "%s() Setting B\n", __func__);
> +			adv7441a_i2c_hdmimap_write8(state, 0x3d, 0x40);
> +		}
> +	} else {
> +		dprintk(1, "%s() ELSE CTS\n", __func__);
> +		adv7441a_i2c_hdmimap_write8(state, 0x3d, 0x40);
> +	}
> +
> +	dprintk(1, "%s() Audio Frequency: %d\n", __func__, tmp);
> +}
> +
> +int adv7441a_keep_alive(struct adv7441a_state *state)
> +{
> +	u8 val, clr = 0;
> +
> +	adv7441a_i2c_hdmimap_read8(state, 0x1a, &val);
> +
> +	if (val & 0x10) {
> +		/* NEW_CTS */
> +		adv7441a_audio_reset_pll(state);
> +		clr |= 0x10;
> +	}
> +
> +	if (val & 0x08) {
> +		/* NEW_N */
> +		adv7441a_audio_configure_pll(state);
> +		clr |= 0x08;
> +	}
> +
> +	if (clr)
> +		adv7441a_i2c_user1map_write8(state, 0x6f, clr);
> +
> +	adv7441a_i2c_user1map_read8(state, 0x64, &val);
> +	if (val & 0x02) {
> +		dprintk(1, "%s() 64\n", __func__);
> +	}
> +
> +	return 0;
> +}
> +
> +static int adv7441a_is_hdmi_locked(struct adv7441a_state *state)
> +{
> +	u8 reg4, reg7;
> +
> +	/* Read the Audio/Video PLL's */
> +	adv7441a_i2c_hdmimap_read8(state, 0x04, &reg4);
> +	dprintk(2, "%s(%p) 0x04 = %02x\n", __func__,
> +		state, reg4); /* Add this */
> +
> +	/* Is Video PLL is locked, is TMDS_PORT_A is active */
> +	if ((reg4 & 0x0a) != 0x0a)
> +		return 0;
> +
> +	/* Is the vertical filter locked? */
> +	adv7441a_i2c_hdmimap_read8(state, 0x07, &reg7);
> +	dprintk(2, "%s(%p) 0x07 = %02x\n", __func__,
> +		state, reg7); /* Add this */
> +	if ((reg7 & 0x40) == 0x00)
> +		return 0;
> +
> +	/* Is the horizontal filter locked? */
> +	if ((reg7 & 0x10) == 0x00)
> +		return 0;
> +
> +	/* Locked */
> +	return 1;
> +}
> +
> +static int adv7441a_is_YPRPB_locked(struct adv7441a_state *state)
> +{
> +	u8 reg12;
> +
> +	/* Is the TLLC_PLL_LOCK bit set */
> +	adv7441a_i2c_usermap_read8(state, 0x12, &reg12);
> +	if ((reg12 & 0x80) != 0x80)
> +		return 0;
> +
> +	/* Is the CP free-running? If set then no signal */
> +	if ((reg12 & 0x40) == 0x40)
> +		return 0;
> +
> +	/* Locked */
> +	return 1;
> +}
> +
> +static int adv7441a_is_composite_locked(struct adv7441a_state *state)
> +{
> +	u8 reg10;
> +
> +	/* Is the IN_LOCK bit set */
> +	adv7441a_i2c_usermap_read8(state, 0x10, &reg10);
> +	if ((reg10 & 0x01) == 0x00)
> +		return 0;
> +
> +	/* Locked */
> +	return 1;
> +}
> +
> +/* Driver Lock detect and format recognition works in the following way.
> + * If we're using a component input then if the CP processor detects
> + * we're not locked or in free-running mode, request colorbar generation.
> + *
> + * If we're using a component input then if the CP processor detects
> + * we're correctly locked, attempt to detect the format based on the STDI
> + * setting. If the STDI setting match the user requested format or rate,
> + * disable colorbars. If the STDU setting do not match the user
> + * requested format or rate, request colorbars.
> + *
> + * If we're using a hdmi input then if the CP processor detects
> + * we're correctly locked, attempt to detect the format based on the STDI
> + * setting. If the STDI setting match the user requested format
> + * or rate, disable colorbars. If the STDU setting do not match the
> + * user requested format or rate, request colorbars.
> + */
> +/* Return 0 on not locked, 1 on locked */
> +int adv7441a_is_locked(struct adv7441a_state *state)
> +{
> +	int ret;
> +
> +	if (!time_after(jiffies,
> +		(long)state->last_locked + msecs_to_jiffies(500))) {
> +		/* Skip the detect, because it hasn't been 500ms since the
> +		 * last attempt */
> +		return 1;
> +	}
> +	state->last_locked = jiffies;
> +
> +	switch (state->video_input_nr) {
> +	case ADV7441A_INPUT_DVI:
> +		ret = adv7441a_is_hdmi_locked(state);
> +		break;
> +	case ADV7441A_INPUT_YPRPB:
> +	case ADV7441A_INPUT_VGA:
> +		ret = adv7441a_is_YPRPB_locked(state);
> +		break;
> +	case ADV7441A_INPUT_COMPOSITE1:
> +	case ADV7441A_INPUT_COMPOSITE2:
> +	case ADV7441A_INPUT_COMPOSITE3:
> +	case ADV7441A_INPUT_SVIDEO:
> +		ret = adv7441a_is_composite_locked(state);
> +		break;
> +	default:
> +		ret = 0;
> +	}
> +
> +	if (ret == 0) {
> +#if 0
> +		/* We didn't detect the video lock correctly,
> +		 * throw the colorbars up. */
> +		vc8x0_channel_loss_of_sync(state->dma_channel, 1);
> +#endif
> +	} else {
> +		adv7441a_detect(state);
> +	}
> +
> +	return ret;
> +}
> +
> +/* return 0 on format not detected or 1 on detected */
> +static int adv7441a_hdmi_detect(struct adv7441a_state *state)
> +{
> +	struct detection_t *d = &state->detection;
> +	struct adv7441a_format *f;
> +	struct vga_size_t *size;
> +	struct vga_rate_t *rate;
> +	u8 stat_10[4], stdi_b1[5], fcl[2];
> +	int i, colorbars_reqd = 1;
> +
> +	for (i = 0; i < 5; i++)
> +		adv7441a_i2c_usermap_read8(state, 0xb1 + i, &stdi_b1[i]);
> +
> +	/* See the ADV7441 HW manual section 9.10 rev J page 177 */
> +	dprintk(2, "%s(%p) STDI b1-b5: %02x %02x %02x %02x %02x\n",
> +		__func__, state,
> +		stdi_b1[0], stdi_b1[1], stdi_b1[2], stdi_b1[3], stdi_b1[4]);
> +
> +	/* if STDI_DVALID */
> +	if (stdi_b1[0] & 0x80) {
> +
> +		/* Format is detected */
> +		d->valid = 1;
> +
> +		/* if STDI_INTLCD */
> +		if (stdi_b1[0] & 0x40)
> +			d->interlaced = 1;
> +		else
> +			d->interlaced = 0;
> +
> +		/* Block length */
> +		d->bl  = ((stdi_b1[0] & 0x3f) << 8) | stdi_b1[1];
> +
> +		/* Line count in field */
> +		d->lcf = ((stdi_b1[2] & 0x07) << 8) | stdi_b1[3];
> +
> +		/* Line count in vsync */
> +		d->lcvs = stdi_b1[2] >> 3;
> +
> +		/* Read the fractional field length */
> +		adv7441a_i2c_usermap_read8(state, 0xca, &fcl[0]);
> +		adv7441a_i2c_usermap_read8(state, 0xcb, &fcl[1]);
> +		d->fcl28 = ((fcl[0] & 0x1f) << 8) | fcl[1];
> +
> +		/* if SSPD_DVALID */
> +		if (stdi_b1[4] & 0x80) {
> +			d->sync_mask = stdi_b1[4] & 0x03;
> +			d->sync_polarity = ((stdi_b1[4] & 0x08) >> 2) |
> +				((stdi_b1[4] & 0x20) >> 5);
> +		}
> +
> +		d->field_rate = 0;
> +		if (d->interlaced)
> +			d->field_rate /= 2;
> +	}
> +
> +	for (i = 0; i < 4; i++)
> +		adv7441a_i2c_usermap_read8(state, 0x10 + i, &stat_10[i]);
> +
> +	/* If CP_FREE_RUN is active then not locked to incoming video... */
> +	if (stat_10[2] & 40)
> +		d->locked = 0;
> +	else
> +		d->locked = 1;
> +
> +	/* Lookup the params in the vga table and detect whether we're locked.
> +	 * If we are, try to find the matching video format and determine
> +	 * whether we're locked to the correct format, or some other format.
> +	 * If we're locked to the incorrect format then we'll warn the user.
> +	 */
> +	if (d->valid) {
> +		dprintk(2, "%s() lcf = %d, fcl28 = %d, bl = %d\n",
> +			__func__, d->lcf, d->fcl28, d->bl);
> +		size = vc8x0_vga_HdGetSize(d->lcf);
> +		rate = vc8x0_vga_HdGetRate(d->fcl28);
> +		if (size && rate) {
> +			dprintk(2,
> +			"%s() size = %d/%d interlaced = %d rate = %d\n",
> +				__func__,
> +				size->width, size->height[0],
> +				size->interlaced,
> +				rate->rate);
> +
> +			do {
> +				if (size->interlaced) {
> +					/* Interlaced */
> +					f = vc8x0_video_find_format(
> +						state,
> +						V4L2_PIX_FMT_YUYV,
> +						size->width,
> +						size->height[0] * 2,
> +						ADV7441A_FORMAT_INTERLACED,
> +						rate->rate);
> +
> +	/* i59 to i60 is really close, rather than touch the rate table
> +	 * and risk * breaking everything so late in the project, for
> +	 * this single format I'm going to manually override the
> +	 * detected format to match the callers needs.
> +	 */
> +					if (state->video_input_nr == ADV7441A_INPUT_YPRPB) {
> +						if (f && (f->id == ADV7441A_FORMAT_1920x1080i60)) {
> +							if (state->fmt->id == ADV7441A_FORMAT_1920x1080i59) {
> +								f = state->fmt;
> +							}
> +						}
> +					}

We had lots of discussions with regards to 60.0Hz and 59.97 Hz stuff, during the
DV API proposals. It ended by being supported by two flags[1]:

	V4L2_DV_FL_CAN_REDUCE_FPS and V4L2_DV_FL_REDUCED_FPS.

[1] http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-g-dv-timings.html

> +				} else {
> +					if ((size->width == 720) &&
> +						(size->height[0] == 483) &&
> +						(state->video_input_nr == ADV7441A_INPUT_VGA)) {
> +						f = vc8x0_video_find_format(
> +							state,
> +							V4L2_PIX_FMT_YUYV,
> +							640,
> +							480,
> +							ADV7441A_FORMAT_PROGRESSIVE,
> +							60);
> +					} else
> +					if ((size->width == 720) && (size->height[0] == 576)) {
> +						f = vc8x0_video_find_format(
> +							state,
> +							V4L2_PIX_FMT_YUYV,
> +							720,
> +							576,
> +							ADV7441A_FORMAT_PROGRESSIVE,
> +							25);
> +					} else {
> +						/* Progressive */
> +						f = vc8x0_video_find_format(
> +							state,
> +							V4L2_PIX_FMT_YUYV,
> +							size->width,
> +							size->height[0],
> +							ADV7441A_FORMAT_PROGRESSIVE,
> +							rate->rate);
> +					}
> +				}
> +				state->detected_fmt = f;
> +				if (f && state->fmt) {
> +					if (f != state->fmt) {
> +						dprintk(2, "%s() Detected incorrect format->id = %d [%s], need %d\n",
> +							__func__,
> +							f->id, f->name,
> +							state->fmt->id);
> +					} else {
> +						dprintk(2, "%s() Detected format->id = %d [%s] correctly.\n",
> +						__func__, f->id, f->name);
> +						colorbars_reqd = 0;
> +					}
> +				}
> +
> +			} while (0);
> +		} else {
> +			dprintk(2, "%s() size = unknown\n", __func__);
> +		}
> +	}
> +#if 0
> +	if (colorbars_reqd == 1) {
> +		/* We didn't detect the video format correctly,
> +		 * throw the colorbars up. */
> +		vc8x0_channel_loss_of_sync(state->dma_channel, 1);
> +	} else {
> +		/* format is good. Remove colorbars if they were present. */
> +		vc8x0_channel_loss_of_sync(state->dma_channel, 0);
> +	}
> +#endif
> +	return 0;
> +}
> +
> +/* return 0 on format not detected or 1 on detected */
> +static int adv7441a_composite_detect(struct adv7441a_state *state)
> +{
> +	int colorbars_reqd = 1;
> +	u8 ret, reg10;
> +
> +	if (!state->fmt)
> +		return 0;
> +
> +	/* Read the standard auto-detect bits */
> +	adv7441a_i2c_usermap_read8(state, 0x10, &reg10);
> +	switch ((reg10 & 0x70) >> 4) {
> +	case 0x00: /* NTSC-MJ */
> +	case 0x01: /* NTSC-443 */
> +	case 0x02: /* PAL-M */
> +	case 0x03: /* PAL-60 */
> +		if (state->fmt->height == 480)
> +			colorbars_reqd = 0;
> +		break;
> +	case 0x04: /* PAL-BGHID */
> +	case 0x06: /* PAL-N */
> +		if (state->fmt->height == 576)
> +			colorbars_reqd = 0;
> +		break;
> +	case 0x05: /* SECAM */
> +	case 0x07: /* SECAM 525 */
> +	default:
> +		break;
> +	}
> +#if 0
> +	if (colorbars_reqd == 1) {
> +		/* We didn't detect the video format correctly
> +		 * throw the colorbars up. */
> +		vc8x0_channel_loss_of_sync(state->dma_channel, 1);
> +		ret = 0;
> +	} else {
> +		/* format is good. Remove colorbars if they were present. */
> +		vc8x0_channel_loss_of_sync(state->dma_channel, 0);
> +		ret = 1;
> +	}
> +#endif
> +	return ret;
> +}
> +
> +/* return 0 on format not detected or 1 on detected */
> +static int adv7441a_vga_detect(struct adv7441a_state *state)
> +{
> +	if (!state->fmt)
> +		return 0;
> +
> +	return 1;
> +}
> +
> +/* Detect the video format and rate based on each different input type */
> +/* return 0 on format not detected or 1 on detected */
> +static int adv7441a_detect(struct adv7441a_state *state)
> +{
> +	int ret;
> +	dprintk(1, "%s()\n", __func__);
> +
> +	if (!time_after(jiffies, (long)state->last_detected +
> +		msecs_to_jiffies(500))) {
> +		/* Skip the detect, because it hasn't been 500ms since
> +		 * the last attempt */
> +		return 1;
> +	}
> +	state->last_detected = jiffies;
> +
> +	switch (state->video_input_nr) {
> +	case ADV7441A_INPUT_YPRPB:
> +	case ADV7441A_INPUT_DVI:
> +		ret = adv7441a_hdmi_detect(state);
> +		break;
> +	case ADV7441A_INPUT_VGA:
> +		ret = adv7441a_vga_detect(state);
> +		ret = adv7441a_hdmi_detect(state);
> +		break;
> +	case ADV7441A_INPUT_COMPOSITE1:
> +	case ADV7441A_INPUT_COMPOSITE2:
> +	case ADV7441A_INPUT_COMPOSITE3:
> +	case ADV7441A_INPUT_SVIDEO:
> +		ret = adv7441a_composite_detect(state);
> +		break;
> +	default:
> +		ret = 0;
> +	}
> +
> +	return ret;
> +}
> +
> +static void adv7441a_log_status_detection(struct v4l2_subdev *sd)
> +{
> +	struct adv7441a_state *state = to_state(sd);
> +	struct detection_t *d = &state->detection;
> +
> +	v4l2_info(sd, "Detected settings:\n");
> +	v4l2_info(sd, " ->locked = %d\n", d->locked);
> +	v4l2_info(sd, " ->interlaced = %d\n", d->interlaced);
> +	v4l2_info(sd, " ->sync_mask = %d\n", d->sync_mask);
> +	v4l2_info(sd, " ->sync_polarity = 0x%02x\n", d->sync_polarity);
> +	v4l2_info(sd, " ->lcf = %d\n", d->lcf);
> +	v4l2_info(sd, " ->lcvs = %d\n", d->lcvs);
> +	v4l2_info(sd, " ->fcl28 = %d\n", d->fcl28);
> +	v4l2_info(sd, " ->bl = %d\n", d->bl);
> +}
> +
> +static void adv7441a_log_status_debug(struct v4l2_subdev *sd)
> +{
> +	struct adv7441a_state *state = to_state(sd);
> +	int i, c = 0, rate = 0;
> +	unsigned char buf[0x100];
> +	v4l2_info(sd, "AD7441:\n");
> +
> +	for (i = 0; i < sizeof(buf); i++)
> +		adv7441a_i2c_hdmimap_read8(state, i, &buf[i]);
> +
> +	v4l2_info(sd, "HDMI 00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f\n");
> +	for (i = 0; i < sizeof(buf); i++) {
> +		if (c == 0)
> +			v4l2_info(sd, " %02x:", i);
> +
> +		v4l2_info(sd, " %02x", buf[i]);
> +
> +		if (++c == 16) {
> +			v4l2_info(sd, "\n");
> +			c = 0;
> +		}
> +	}
> +
> +	v4l2_info(sd, "->Audio PLL Locked = %d\n", (buf[0x04] >> 0) & 0x01);
> +	v4l2_info(sd, "->Video PLL Locked = %d\n", (buf[0x04] >> 1) & 0x01);
> +	v4l2_info(sd, "->TMDS Port B Active = %d\n", (buf[0x04] >> 2) & 0x01);
> +	v4l2_info(sd, "->TMDS Port A Active = %d\n", (buf[0x04] >> 3) & 0x01);
> +	v4l2_info(sd, "->AV Muted = %d\n", (buf[0x04] >> 6) & 0x01);
> +	v4l2_info(sd, "->Video Width Detected = %d\n",
> +		((buf[0x07] << 8) | buf[0x08]) & 0xfff);
> +	v4l2_info(sd, "->Video Height Detected = %d\n",
> +		((buf[0x09] << 8) | buf[0x0a]) & 0xfff);
> +
> +	for (i = 0; i < sizeof(buf); i++)
> +		adv7441a_i2c_usermap_read8(state, i, &buf[i]);
> +
> +	v4l2_info(sd, "USR  00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f\n");
> +	c = 0;
> +	for (i = 0; i < sizeof(buf); i++) {
> +		if (c == 0)
> +			v4l2_info(sd, " %02x:", i);
> +
> +		v4l2_info(sd, " %02x", buf[i]);
> +
> +		if (++c == 16) {
> +			v4l2_info(sd, "\n");
> +			c = 0;
> +		}
> +	}
> +#if 0
> +	for (i = 0; i < sizeof(buf); i++)
> +		adv7441a_i2c_edidmap_read8(state, i, &buf[i]);
> +
> +	v4l2_info(sd, "EDID 00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f\n");
> +	c = 0;
> +	for (i = 0; i < sizeof(buf); i++) {
> +		if (c == 0)
> +			v4l2_info(sd, " %02x:", i);
> +
> +		seq_printf(m, " %02x", buf[i]);
> +
> +		if (++c == 16) {
> +			v4l2_info(sd, "\n");
> +			c = 0;
> +		}
> +	}

Instead, use the existing function for doing memory dumps:
	print_hex_dump()

> +	if (memcmp(edid_data, buf, sizeof(edid_data)) != 0)
> +		v4l2_info(sd, "Edid corrupt?\n");
> +#endif
> +	memset(buf, 0, sizeof(buf));
> +	for (i = 0x60; i < 0x70; i++)
> +		adv7441a_i2c_user1map_read8(state, i, &buf[i]);
> +
> +	v4l2_info(sd, "USR1 00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f\n");
> +	c = 0;
> +	for (i = 0; i < sizeof(buf); i++) {
> +		if (c == 0)
> +			v4l2_info(sd, " %02x:", i);
> +
> +		v4l2_info(sd, " %02x", buf[i]);
> +
> +		if (++c == 16) {
> +			v4l2_info(sd, "\n");
> +			c = 0;
> +		}
> +	}

Again, print_hex_dump()

> +
> +	switch (buf[6] & 0x0f) {
> +	case 0x0a:
> +		v4l2_info(sd, "->Resolution Requested = 1280x720p\n");
> +		break;
> +	case 0x0c:
> +	case 0x0e:
> +		v4l2_info(sd, "->Resolution Requested = 1920x1080i\n");
> +		break;
> +	}
> +
> +	switch ((buf[6] & 0xe0) >> 5) {
> +	case 0x00:
> +		rate = 60;
> +		break;
> +	case 0x01:
> +		rate = 50;
> +		break;
> +	case 0x02:
> +		rate = 30;
> +		break;
> +	case 0x03:
> +		rate = 25;
> +		break;
> +	case 0x04:
> +		rate = 24;
> +		break;
> +	}
> +	v4l2_info(sd, "->Rate Requested = %dHz\n", rate);
> +	v4l2_info(sd, "->Format Requested = %d [%s]\n",
> +		state->fmt ? state->fmt->id : -1,
> +		state->fmt ? state->fmt->name : "undefined");
> +}
> +
> +static int adv7441a_log_status(struct v4l2_subdev *sd)
> +{
> +	adv7441a_log_status_detection(sd);
> +	adv7441a_log_status_debug(sd);
> +
> +	return 0;
> +}

Hmm... I think you need to do some #if testing here, to avoid producing warnings or
errors if advanced debug is disabled.

> +
> +static int adv7441a_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct v4l2_subdev *sd = to_sd(ctrl);
> +	struct adv7441a_state *state = to_state(sd);
> +
> +	dprintk(1, "%s(0x%x = 0x%x)\n", __func__, ctrl->id, ctrl->val);
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_BRIGHTNESS:
> +		/* Enable the Video Adjustment and CSC block */
> +		state->brightness = ctrl->val;
> +		adv7441a_i2c_user1map_setbit(state, 0x9e, 0x80);
> +		adv7441a_i2c_usermap_setbit(state, 0x69, 0x18);
> +		adv7441a_i2c_user1map_write8(state, 0x9c,
> +			state->brightness - 128);
> +		break;
> +	case V4L2_CID_HUE:
> +		/* Enable the Video Adjustment and CSC block */
> +		state->hue = ctrl->val;
> +		adv7441a_i2c_user1map_setbit(state, 0x9e, 0x80);
> +		adv7441a_i2c_usermap_setbit(state, 0x69, 0x18);
> +		adv7441a_i2c_user1map_write8(state, 0x9d, state->hue);
> +		break;
> +	case V4L2_CID_CONTRAST:
> +		/* Enable the Video Adjustment and CSC block */
> +		state->contrast = ctrl->val;
> +		adv7441a_i2c_user1map_setbit(state, 0x9e, 0x80);
> +		adv7441a_i2c_usermap_setbit(state, 0x69, 0x18);
> +		adv7441a_i2c_user1map_write8(state, 0x9a, state->contrast);
> +		break;
> +	case V4L2_CID_SATURATION:
> +		/* Enable the Video Adjustment and CSC block */
> +		state->saturation = ctrl->val;
> +		adv7441a_i2c_user1map_setbit(state, 0x9e, 0x80);
> +		adv7441a_i2c_usermap_setbit(state, 0x69, 0x18);
> +		adv7441a_i2c_user1map_write8(state, 0x9b, state->saturation);
> +		break;
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static int adv7441a_g_chip_ident(struct v4l2_subdev *sd,
> +	struct v4l2_dbg_chip_ident *chip)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +
> +	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_ADV7441A, 0);
> +}
> +
> +static const struct v4l2_ctrl_ops adv7441a_ctrl_ops = {
> +	.s_ctrl = adv7441a_s_ctrl,
> +};
> +
> +static const struct v4l2_subdev_core_ops adv7441a_core_ops = {
> +	.log_status	= adv7441a_log_status,
> +	.g_chip_ident	= adv7441a_g_chip_ident,
> +	.g_ext_ctrls	= v4l2_subdev_g_ext_ctrls,
> +	.try_ext_ctrls	= v4l2_subdev_try_ext_ctrls,
> +	.s_ext_ctrls	= v4l2_subdev_s_ext_ctrls,
> +	.g_ctrl		= v4l2_subdev_g_ctrl,
> +	.s_ctrl		= v4l2_subdev_s_ctrl,
> +	.queryctrl	= v4l2_subdev_queryctrl,
> +	.querymenu	= v4l2_subdev_querymenu,
> +};
> +
> +static const struct v4l2_subdev_video_ops adv7441a_video_ops = {
> +	.s_routing	= adv7441a_s_routing,
> +};
> +
> +static const struct v4l2_subdev_ops adv7441a_ops = {
> +	.core	= &adv7441a_core_ops,
> +	.video	= &adv7441a_video_ops,
> +};
> +
> +#if 0
> +static void adv7441a_delayed_work_enable_hotplug(struct work_struct *work)
> +{
> +	struct delayed_work *dwork = to_delayed_work(work);
> +	struct adv7441a_state *state = container_of(dwork,
> +		struct adv7441a_state,
> +		delayed_work_enable_hotplug);
> +
> +	struct v4l2_subdev *sd = &state->sd;
> +
> +	dprintk(0, "%s() enable hotplug\n", __func__);
> +
> +	v4l2_subdev_notify(sd, ADV7441A_HOTPLUG, (void *)1);
> +}
> +#endif
> +
> +static int adv7441a_probe(struct i2c_client *client,
> +	const struct i2c_device_id *id)
> +{
> +	struct adv7441a_state *state;
> +	int ret;
> +
> +	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
> +		return -ENODEV;
> +
> +	dprintk(1, "chip found @ 0x%x (%s)\n",
> +		client->addr << 1, client->adapter->name);
> +
> +	state = kzalloc(sizeof(struct adv7441a_state), GFP_KERNEL);
> +	if (state == NULL)
> +		return -ENOMEM;
> +
> +	state->usermap_addr = client->addr << 1;
> +
> +	if (state->usermap_addr == 0x42) {
> +		state->user1map_addr	= 0x46;
> +		state->user2map_addr	= 0x62;
> +		state->user3map_addr	= 0x4a;
> +		state->reservedmap_addr	= 0x4e;
> +		state->hdmimap_addr	= 0x6a;
> +		state->rksvmap_addr	= 0x66;
> +		state->edidmap_addr	= 0x6e;
> +	} else
> +	if (state->usermap_addr == 0x40) {
> +		state->user1map_addr	= 0x44;
> +		state->user2map_addr	= 0x60;
> +		state->user3map_addr	= 0x48;
> +		state->reservedmap_addr	= 0x4c;
> +		state->hdmimap_addr	= 0x68;
> +		state->rksvmap_addr	= 0x64;
> +		state->edidmap_addr	= 0x6c;
> +	}
> +
> +	state->brightness = 128;
> +	state->contrast = 0x80;
> +	state->hue = 0;
> +	state->saturation = 0x80;
> +
> +	state->usermap_client =
> +		i2c_new_dummy(client->adapter, state->usermap_addr);
> +	state->user1map_client =
> +		i2c_new_dummy(client->adapter, state->user1map_addr);
> +	state->user2map_client =
> +		i2c_new_dummy(client->adapter, state->user2map_addr);
> +	state->user3map_client =
> +		i2c_new_dummy(client->adapter, state->user3map_addr);
> +	state->reservedmap_client =
> +		i2c_new_dummy(client->adapter, state->reservedmap_addr);
> +	state->hdmimap_client =
> +		i2c_new_dummy(client->adapter, state->hdmimap_addr);
> +	state->rksvmap_client =
> +		i2c_new_dummy(client->adapter, state->rksvmap_addr);
> +	state->edidmap_client =
> +		i2c_new_dummy(client->adapter, state->edidmap_addr);

The above thing looks very confusing to me. Does this device have all those
addresses? What's the difference between them?

> +
> +	v4l2_i2c_subdev_init(&state->sd, client, &adv7441a_ops);
> +
> +	v4l2_ctrl_handler_init(&state->hdl, 4);
> +
> +	v4l2_ctrl_new_std(&state->hdl, &adv7441a_ctrl_ops,
> +			V4L2_CID_BRIGHTNESS, -127, 128, 1, 128);
> +
> +	v4l2_ctrl_new_std(&state->hdl, &adv7441a_ctrl_ops,
> +			V4L2_CID_HUE, 0, 255, 1, 0);
> +
> +	v4l2_ctrl_new_std(&state->hdl, &adv7441a_ctrl_ops,
> +			V4L2_CID_CONTRAST, 0, 255, 1, 128);
> +
> +	v4l2_ctrl_new_std(&state->hdl, &adv7441a_ctrl_ops,
> +			V4L2_CID_SATURATION, 0, 255, 1, 128);
> +
> +	state->sd.ctrl_handler = &state->hdl;
> +	if (state->hdl.error) {
> +		int err = state->hdl.error;
> +
> +		v4l2_ctrl_handler_free(&state->hdl);
> +		adv7441a_unregister_clients(state);
> +		kfree(state);
> +		return err;
> +	}
> +	v4l2_ctrl_handler_setup(&state->hdl);
> +
> +	adv7441a_set_edid(&state->sd, &edid_data[0], sizeof(edid_data));
> +	adv7441a_s_routing(&state->sd, ADV7441A_INPUT_DVI, 0, 0);
> +	state->vga_timing_mode = vc8x0_vga_lookup(2, 640, 480, 1);
> +
> +	/* Establish a default */
> +	adv7441a_HDMI_1920x1080px60(state, 0);
> +
> +	ret = 0;
> +	if (ret) {
> +		v4l2_ctrl_handler_free(&state->hdl);
> +		adv7441a_unregister_clients(state);
> +		kfree(state);
> +	}
> +#if 0
> +	/* Hotplug and background work queueing */
> +	state->work_queues = create_singlethread_workqueue(client->name);
> +	if (state->work_queues) {
> +		INIT_DELAYED_WORK(&state->delayed_work_enable_hotplug,
> +			adv7441a_delayed_work_enable_hotplug);
> +	} else {
> +		pr_err("Could not create work queue\n");
> +		ret = -ENOMEM;
> +	}
> +#endif
> +	dprintk(1, "ADV7441A Loaded and attached\n");
> +	return ret;
> +}
> +
> +static int adv7441a_remove(struct i2c_client *client)
> +{
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct adv7441a_state *state = to_state(sd);
> +#if 0
> +	cancel_delayed_work(&state->delayed_work_enable_hotplug);
> +	destroy_workqueue(state->work_queues);
> +#endif
> +	v4l2_device_unregister_subdev(sd);
> +	adv7441a_unregister_clients(to_state(sd));
> +	v4l2_ctrl_handler_free(&state->hdl);
> +	kfree(state);
> +
> +	dprintk(1, "ADV7441A Unloaded\n");
> +	return 0;
> +}
> +
> +static const struct i2c_device_id adv7441a_id[] = {
> +	{"adv7441a", 0},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(i2c, adv7441a_id);
> +
> +static struct i2c_driver adv7441a_driver = {
> +	.driver = {
> +		.owner	= THIS_MODULE,
> +		.name	= "adv7441a",
> +	},
> +	.probe		= adv7441a_probe,
> +	.remove		= adv7441a_remove,
> +	.id_table	= adv7441a_id,
> +};
> +module_i2c_driver(adv7441a_driver);
> diff --git a/include/media/adv7441a.h b/include/media/adv7441a.h
> new file mode 100644
> index 0000000..b1538fe
> --- /dev/null
> +++ b/include/media/adv7441a.h
> @@ -0,0 +1,88 @@
> +/*
> + *  Driver for the Analog Devices ADV7441A Video Decoder.
> + *
> + *  Copyright 2011/2012, Kernel Labs Inc. www.kernellabs.com.
> + *   - Steven Toth <stoth@kernellabs.com>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; if not, write to the Free Software
> + *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + *
> + */
> +#ifndef ADV7441A_H
> +#define ADV7441A_H
> +
> +#define ADV7441A_INPUT_DVI		(0)
> +#define ADV7441A_INPUT_YPRPB		(1)
> +#define ADV7441A_INPUT_VGA		(2)
> +#define ADV7441A_INPUT_SVIDEO		(3)
> +#define ADV7441A_INPUT_COMPOSITE1	(4)
> +#define ADV7441A_INPUT_COMPOSITE2	(5)
> +#define ADV7441A_INPUT_COMPOSITE3	(6)
> +
> +#define ADV7441A_FORMAT_UNKNOWN          0x00
> +#define ADV7441A_FORMAT_INTERLACED       0x01
> +#define ADV7441A_FORMAT_PROGRESSIVE      0x02
> +#define ADV7441A_FORMAT_720x480i59       0x02
> +#define ADV7441A_FORMAT_720x480i60       0x03
> +#define ADV7441A_FORMAT_720x576i50       0x04
> +#define ADV7441A_FORMAT_720x576p25       0x05
> +#define ADV7441A_FORMAT_1280x720p23      0x06
> +#define ADV7441A_FORMAT_1280x720p24      0x07
> +#define ADV7441A_FORMAT_1280x720p25      0x08
> +#define ADV7441A_FORMAT_1280x720p29      0x09
> +#define ADV7441A_FORMAT_1280x720p30      0x0A
> +#define ADV7441A_FORMAT_1280x720p50      0x0B
> +#define ADV7441A_FORMAT_1280x720p59      0x0C
> +#define ADV7441A_FORMAT_1280x720p60      0x0D
> +#define ADV7441A_FORMAT_1920x1080i50     0x0E
> +#define ADV7441A_FORMAT_1920x1080i59     0x0F
> +#define ADV7441A_FORMAT_1920x1080i60     0x10
> +#define ADV7441A_FORMAT_1920x1080p23     0x11
> +#define ADV7441A_FORMAT_1920x1080p24     0x12
> +#define ADV7441A_FORMAT_1920x1080p25     0x13
> +#define ADV7441A_FORMAT_1920x1080p29     0x14
> +#define ADV7441A_FORMAT_1920x1080p30     0x15
> +#define ADV7441A_FORMAT_1920x1080p50     0x16
> +#define ADV7441A_FORMAT_1920x1080p59     0x17
> +#define ADV7441A_FORMAT_1920x1080p60     0x18
> +
> +/* VGA */
> +#define ADV7441A_FORMAT_640x480p60       0x30
> +#define ADV7441A_FORMAT_800x600p60       0x31
> +#define ADV7441A_FORMAT_1024x768p60      0x32
> +#define ADV7441A_FORMAT_1280x960p60      0x33
> +#define ADV7441A_FORMAT_1280x1024p60     0x34
> +#define ADV7441A_FORMAT_1400x1050p60     0x35
> +#define ADV7441A_FORMAT_1600x1200p60     0x36
> +#define ADV7441A_FORMAT_UXGA_1600x1200p60	0x43
> +#define ADV7441A_FORMAT_WXGA_1440x900p60		0x46
> +#define ADV7441A_FORMAT_WSXGA_1680x1050p60	0x48
> +#define ADV7441A_FORMAT_VGAHD_1920x1080p60	0x49
> +
> +#define ADV7441A_FRAMERATE_UNKNOWN	(0)
> +#define ADV7441A_FRAMERATE_23		(23)
> +#define ADV7441A_FRAMERATE_24		(24)
> +#define ADV7441A_FRAMERATE_25		(25)
> +#define ADV7441A_FRAMERATE_29		(29)
> +#define ADV7441A_FRAMERATE_30		(30)
> +#define ADV7441A_FRAMERATE_50		(50)
> +#define ADV7441A_FRAMERATE_59		(59)
> +#define ADV7441A_FRAMERATE_60		(60)
> +
> +/* Asynchronous Driver Events */
> +#define ADV7441A_HOTPLUG         (1)
> +#define ADV7441A_FMT_CHANGE      (2)
> +
> +#endif
> diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-ident.h
> index 58f914a..07e2513 100644
> --- a/include/media/v4l2-chip-ident.h
> +++ b/include/media/v4l2-chip-ident.h
> @@ -183,6 +183,9 @@ enum {
>  	/* module adv7393: just ident 7393 */
>  	V4L2_IDENT_ADV7393 = 7393,
>  
> +	/* module adv7441a: just ident 7441 */
> +	V4L2_IDENT_ADV7441A = 7441,
> +
>  	/* module saa7706h: just ident 7706 */
>  	V4L2_IDENT_SAA7706H = 7706,
>  
> -- 
> 1.7.11.4
> 
