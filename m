Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33814 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab3ICQNj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Sep 2013 12:13:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ulrich Hecht <ulrich.hecht@gmail.com>, linux-sh@vger.kernel.org,
	magnus.damm@gmail.com, Hans Verkuil <hverkuil@xs4all.nl>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [RFC 01/10] drm: ADV7511 i2c HDMI encoder driver
Date: Tue, 03 Sep 2013 18:13:38 +0200
Message-ID: <2603252.pOSLifSPDx@avalon>
In-Reply-To: <5224AA17.6060806@metafoo.de>
References: <1377866264-21110-1-git-send-email-ulrich.hecht@gmail.com> <1867305.sTJDNiZ7SL@avalon> <5224AA17.6060806@metafoo.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lars-Peter,

(CC'ing Hans Verkuil and the dri-devel and linux-media mailing lists)

On Monday 02 September 2013 17:09:11 Lars-Peter Clausen wrote:
> On 09/02/2013 05:01 PM, Laurent Pinchart wrote:
> > On Monday 02 September 2013 16:43:25 Lars-Peter Clausen wrote:
> >> On 09/02/2013 04:15 PM, Laurent Pinchart wrote:
> >>> On Monday 02 September 2013 15:40:22 Lars-Peter Clausen wrote:
> >>>> On 09/02/2013 03:18 PM, Laurent Pinchart wrote:
> >>>>> On Friday 30 August 2013 14:37:35 Ulrich Hecht wrote:
> >>>>>> ADV7511 driver snapshot taken from commit f416e32 of xcomm_zynq_3_10
> >>>>>> branch at https://github.com/analogdevicesinc/linux.git
> >>>>> 
> >>>>> I believe Lars-Peter (CC'ed) was planning to upstream the driver.
> >>>>> Lars-Peter, could you please share your plans ?
> >>>> 
> >>>> My plan was to have all this upstream long time ago ;)
> >>>> 
> >>>> As I said in that other thread, I don't think it is a good idea to have
> >>>> two drivers for the same device. But if nobody else sees a problem with
> >>>> this and as long as the v4l driver doesn't have devicetree support I
> >>>> guess we could get away with it for now. Even if it will probably haunt
> >>>> us later on.
> >>>> 
> >>>> There are still a few minor bits and pieces to iron out, but lets try
> >>>> to aim for 2.6.13.
> >>> 
> >>> If you can make it for 2.6.13 I will be extremely impressed :-)
> >> 
> >> Yea, I know DRM always takes a bit longer...
> > 
> > I think you meant 3.13 ;-)
> > 
> >>> Do you plan to push the driver yourself ? If so, I would appreciate if
> >>> you could CC me. If there's just a few minor bits to iron out I can
> >>> already review your latest version if that can help.
> >> 
> >> There are a couple of style issues, so if you review the driver ignore
> >> these for now, but otherwise feedback is welcome, thanks. And I'm not
> >> also quite happy with the ASoC integration yet.

I'll thus concentrate on the video part in the review. Any chance to get the 
video portion to mainline first and then add audio support ?

> > Sure. Is the version available from the above branch the latest version ?
> 
> Yes, you can find it here:
> https://github.com/analogdevicesinc/linux/tree/xcomm_zynq/drivers/gpu/drm/
> i2c

Thank you.

> Oh and the DT bindings also still need proper documentation.

I've squashed all the patches together and have copied the result below.

> From f7c27f204cab3d7dcaa128880c0d9ef1ae0e2fc6 Mon Sep 17 00:00:00 2001
> From: Lars-Peter Clausen <lars@metafoo.de>
> Date: Mon, 5 Mar 2012 16:30:57 +0100
> Subject: [PATCH] DRM: Add adv7511 encoder driver
> 
> This patch adds a driver for the Analog Devices adv7511. The adv7511 is a
> standalone HDMI transmitter chip. It features a HDMI output interface on one
> end and video and audio input interfaces on the other.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  drivers/gpu/drm/Kconfig             |   6 +
>  drivers/gpu/drm/i2c/Makefile        |   3 +
>  drivers/gpu/drm/i2c/adv7511.h       | 454 +++++++++++++++++
>  drivers/gpu/drm/i2c/adv7511_audio.c | 304 +++++++++++
>  drivers/gpu/drm/i2c/adv7511_core.c  | 979 +++++++++++++++++++++++++++++++++
>  5 files changed, 1746 insertions(+)
>  create mode 100644 drivers/gpu/drm/i2c/adv7511.h
>  create mode 100644 drivers/gpu/drm/i2c/adv7511_audio.c
>  create mode 100644 drivers/gpu/drm/i2c/adv7511_core.c

First of all, please run checkpatch.pl on the code :-)

> diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
> index 626bc0c..d8862a4 100644
> --- a/drivers/gpu/drm/Kconfig
> +++ b/drivers/gpu/drm/Kconfig
> @@ -200,6 +200,12 @@ config DRM_SAVAGE
>  	  Choose this option if you have a Savage3D/4/SuperSavage/Pro/Twister
>  	  chipset. If M is selected the module will be called savage.
>  
> +config DRM_ENCODER_ADV7511
> +	tristate "AV7511 encoder"
> +	depends on DRM && I2C
> +	select REGMAP_I2C
> +	select HDMI

Beside adding a help text, you should also depend on and/or select SND_SOC.

> +
>  source "drivers/gpu/drm/exynos/Kconfig"
>  
>  source "drivers/gpu/drm/vmwgfx/Kconfig"

[snip]

> diff --git a/drivers/gpu/drm/i2c/adv7511.h b/drivers/gpu/drm/i2c/adv7511.h
> new file mode 100644
> index 0000000..4631fcd6
> --- /dev/null
> +++ b/drivers/gpu/drm/i2c/adv7511.h
> @@ -0,0 +1,454 @@
> +/**
> + * Analog Devices ADV7511 HDMI transmitter driver
> + *
> + * Copyright 2012 Analog Devices Inc.
> + *
> + * Licensed under the GPL-2.
> + */
> +
> +#ifndef __ADV7511_H__
> +#define __ADV7511_H__
> +
> +#include <linux/hdmi.h>

This file should be split in two headers, one with platform data that will go 
to include/linux/platform_data/, and another one that can stay here.

> +#define ADV7511_REG_CHIP_REVISION		0x00
> +#define ADV7511_REG_N0				0x01
> +#define ADV7511_REG_N1				0x02
> +#define ADV7511_REG_N2				0x03
> +#define ADV7511_REG_SPDIF_FREQ			0x04
> +#define ADV7511_REG_CTS_AUTOMATIC1		0x05
> +#define ADV7511_REG_CTS_AUTOMATIC2		0x06
> +#define ADV7511_REG_CTS_MANUAL0			0x07
> +#define ADV7511_REG_CTS_MANUAL1			0x08
> +#define ADV7511_REG_CTS_MANUAL2			0x09

[snip]

> +#define ADV7511_CSC_ENABLE			BIT(7)
> +#define ADV7511_CSC_UPDATE_MODE			BIT(5)

I would have added the bits right after the register they refer to, but that's 
up to you.

[snip]

> +#include <drm/drmP.h>

You can move the include at the beginning of the file.

> +struct i2c_client;
> +struct regmap;
> +struct adv7511;

Nitpicking, you could sort the structures alphabetically.

> +int adv7511_packet_enable(struct adv7511 *adv7511, unsigned int packet);
> +int adv7511_packet_disable(struct adv7511 *adv7511, unsigned int packet);
> +
> +int adv7511_audio_init(struct device *dev);
> +void adv7511_audio_exit(struct device *dev);
> +
> +/**
> + * enum adv7511_input_style - Selects the input format style
> + * ADV7511_INPUT_STYLE1: Use input style 1
> + * ADV7511_INPUT_STYLE2: Use input style 2
> + * ADV7511_INPUT_STYLE3: Use input style 3
> + **/
> +enum adv7511_input_style {
> +	ADV7511_INPUT_STYLE1 = 2,
> +	ADV7511_INPUT_STYLE2 = 1,
> +	ADV7511_INPUT_STYLE3 = 3,
> +};
> +
> +/**
> + * enum adv7511_input_id - Selects the input format id
> + * @ADV7511_INPUT_ID_24BIT_RGB444_YCbCr444: Input pixel format is 24-bit
> + *					    444 RGB or 444 YCbCR with separate syncs
> + * @ADV7511_INPUT_ID_16_20_24BIT_YCbCr422_SEPARATE_SYNC:
> + * @ADV7511_INPUT_ID_16_20_24BIT_YCbCr422_EMBEDDED_SYNC:
> + * @ADV7511_INPUT_ID_8_10_12BIT_YCbCr422_SEPARATE_SYNC:
> + * @ADV7511_INPUT_ID_8_10_12BIT_YCbCr422_EMBEDDED_SYNC:
> + * @ADV7511_INPUT_ID_12_15_16BIT_RGB444_YCbCr444:
> + **/
> +enum adv7511_input_id {
> +	ADV7511_INPUT_ID_24BIT_RGB444_YCbCr444 = 0,
> +	ADV7511_INPUT_ID_16_20_24BIT_YCbCr422_SEPARATE_SYNC = 1,
> +	ADV7511_INPUT_ID_16_20_24BIT_YCbCr422_EMBEDDED_SYNC = 2,
> +	ADV7511_INPUT_ID_8_10_12BIT_YCbCr422_SEPARATE_SYNC = 3,
> +	ADV7511_INPUT_ID_8_10_12BIT_YCbCr422_EMBEDDED_SYNC = 4,
> +	ADV7511_INPUT_ID_12_15_16BIT_RGB444_YCbCr444 = 5,
> +};
> +
> +/**
> + * enum adv7511_input_bit_justifiction - Selects the input format bit 
justifiction
> + * ADV7511_INPUT_BIT_JUSTIFICATION_EVENLY: Input bits are evenly 
distributed
> + * ADV7511_INPUT_BIT_JUSTIFICATION_RIGHT: Input bit signals have right 
justification
> + * ADV7511_INPUT_BIT_JUSTIFICATION_LEFT: Input bit signals have left 
justification
> + **/
> +enum adv7511_input_bit_justifiction {
> +	ADV7511_INPUT_BIT_JUSTIFICATION_EVENLY = 0,
> +	ADV7511_INPUT_BIT_JUSTIFICATION_RIGHT = 1,
> +	ADV7511_INPUT_BIT_JUSTIFICATION_LEFT = 2,
> +};
> +
> +/**
> + * enum adv7511_input_color_depth - Selects the input format color depth
> + * @ADV7511_INPUT_COLOR_DEPTH_8BIT: Input format color depth is 8 bits per 
channel
> + * @ADV7511_INPUT_COLOR_DEPTH_10BIT: Input format color dpeth is 10 bits 
per channel
> + * @ADV7511_INPUT_COLOR_DEPTH_12BIT: Input format color depth is 12 bits 
per channel
> + **/
> +enum adv7511_input_color_depth {
> +	ADV7511_INPUT_COLOR_DEPTH_8BIT = 3,
> +	ADV7511_INPUT_COLOR_DEPTH_10BIT = 1,
> +	ADV7511_INPUT_COLOR_DEPTH_12BIT = 2,
> +};

Those enums describe the video format at the chip input. This can be 
configured statically from platform data or DT, but some platforms might need 
to setup formats dynamically at runtime. For instance the ADV7511 could be 
driven by a mux with two inputs using different formats.

For these reasons I would combine all those enums in a single one that lists 
all possible input formats. The formats should be standardized and moved to a 
separate header file. Get and set format operations will be needed (this is 
something CDF will address :-)).

> +
> +/**
> + * enum adv7511_input_sync_pulse - Selects the sync pulse
> + * @ADV7511_INPUT_SYNC_PULSE_DE: Use the DE signal as sync pulse
> + * @ADV7511_INPUT_SYNC_PULSE_HSYNC: Use the HSYNC signal as sync pulse
> + * @ADV7511_INPUT_SYNC_PULSE_VSYNC: Use the VSYNC signal as sync pulse
> + * @ADV7511_INPUT_SYNC_PULSE_NONE: No external sync pulse signal
> + **/
> +enum adv7511_input_sync_pulse {
> +	ADV7511_INPUT_SYNC_PULSE_DE = 0,
> +	ADV7511_INPUT_SYNC_PULSE_HSYNC = 1,
> +	ADV7511_INPUT_SYNC_PULSE_VSYNC = 2,
> +	ADV7511_INPUT_SYNC_PULSE_NONE = 3,
> +};

This property should also be standardized. It might make sense to define new 
display flags (include/video/display_timing.h), but a separate enum is 
possible as well.

> +/**
> + * enum adv7511_input_clock_delay - Delay for the video data input clock
> + * @ADV7511_INPUT_CLOCK_DELAY_MINUS_1200PS: -1200 pico seconds delay
> + * @ADV7511_INPUT_CLOCK_DELAY_MINUS_800PS: -800 pico seconds delay
> + * @ADV7511_INPUT_CLOCK_DELAY_MINUS_400PS: -400 pico seconds delay
> + * @ADV7511_INPUT_CLOCK_DELAY_NONE: No delay
> + * @ADV7511_INPUT_CLOCK_DELAY_PLUS_400PS: 400 pico seconds delay
> + * @ADV7511_INPUT_CLOCK_DELAY_PLUS_800PS: 800 pico seconds delay
> + * @ADV7511_INPUT_CLOCK_DELAY_PLUS_1200PS: 1200 pico seconds delay
> + * @ADV7511_INPUT_CLOCK_DELAY_PLUS_1600PS: 1600 pico seconds delay
> + **/
> +enum adv7511_input_clock_delay {
> +	ADV7511_INPUT_CLOCK_DELAY_MINUS_1200PS = 0,
> +	ADV7511_INPUT_CLOCK_DELAY_MINUS_800PS = 1,
> +	ADV7511_INPUT_CLOCK_DELAY_MINUS_400PS = 2,
> +	ADV7511_INPUT_CLOCK_DELAY_NONE = 3,
> +	ADV7511_INPUT_CLOCK_DELAY_PLUS_400PS = 4,
> +	ADV7511_INPUT_CLOCK_DELAY_PLUS_800PS = 5,
> +	ADV7511_INPUT_CLOCK_DELAY_PLUS_1200PS = 6,
> +	ADV7511_INPUT_CLOCK_DELAY_PLUS_1600PS = 7,
> +};
> +
> +/**
> + * enum adv7511_sync_polarity - Polarity for the input sync signals
> + * ADV7511_SYNC_POLARITY_PASSTHROUGH:  Sync polarity matches that of the
> + *				    currently configured mode.
> + * ADV7511_SYNC_POLARITY_LOW:	    Sync polarity is low
> + * ADV7511_SYNC_POLARITY_HIGH:	    Sync polarity is high
> + *
> + * If the polarity is set to either ADV7511_SYNC_POLARITY_LOW or
> + * ADV7511_SYNC_POLARITY_HIGH the ADV7511 will internally invert the signal
> + * if it is required to match the sync polarity setting for the currently
> + * selected mode. If the polarity is set to
> + * ADV7511_SYNC_POLARITY_PASSTHROUGH, the ADV7511 will route the signal
> + * unchanged, this is useful if the upstream graphics core will already
> + * generate the sync singals with the correct polarity.
> + **/
> +enum adv7511_sync_polarity {
> +	ADV7511_SYNC_POLARITY_PASSTHROUGH,
> +	ADV7511_SYNC_POLARITY_LOW,
> +	ADV7511_SYNC_POLARITY_HIGH,
> +};

This property should be standardized as well.

> +/**
> + * enum adv7511_timing_gen_seq - Selects the order in which timing 
adjustments are performed
> + * @ADV7511_TIMING_GEN_SEQ_SYN_ADJ_FIRST: Sync adjustment first, then DE 
generation
> + * @ADV7511_TIMING_GEN_SEQ_DE_GEN_FIRST: DE generation first, then sync 
adjustment
> + *
> + * This setting is only relevant if both DE generation and sync adjustment 
are
> + * active.
> + **/
> +enum adv7511_timing_gen_seq {
> +    ADV7511_TIMING_GEN_SEQ_SYN_ADJ_FIRST = 0,
> +    ADV7511_TIMING_GEN_SEQ_DE_GEN_FIRST = 1,
> +};
> +
> +/**
> + * enum adv7511_up_conversion - Selects the upscaling conversion method
> + * @ADV7511_UP_CONVERSION_ZERO_ORDER: Use zero order up conversion
> + * @ADV7511_UP_CONVERSION_FIRST_ORDER: Use first order up conversion
> + *
> + * This used when converting from a 4:2:2 format to a 4:4:4 format.
> + **/
> +enum adv7511_up_conversion {
> +    ADV7511_UP_CONVERSION_ZERO_ORDER = 0,
> +    ADV7511_UP_CONVERSION_FIRST_ORDER = 1,
> +};

How is the upscaling conversion method supposed to be selected ? What does it 
depend on ?

> +/**
> + * struct adv7511_link_config - Describes adv7511 hardware configuration
> + * @id:				Video input format id
> + * @input_style:		Video input format style
> + * @sync_pulse:			Select the sync pulse
> + * @clock_delay:		Clock delay for the input clock
> + * @reverse_bitorder:		Reverse video input signal bitorder
> + * @bit_justification:		Video input format bit justification
> + * @up_conversion:		Selects the upscaling conversion method
> + * @input_color_depth:		Input video format color depth
> + * @tmds_clock_inversion:	Whether to invert the TDMS clock
> + * @vsync_polartity:		vsync input signal configuration
> + * @hsync_polartity:		hsync input signal configuration
> + * @timing_gen_seq:		Selects the order in which sync DE generation
> + *				and sync adjustment are performt.
> + * @gpio_pd:			GPIO controlling the PD (powerdown) pin
> + **/
> +struct adv7511_link_config {
> +	enum adv7511_input_id id;
> +	enum adv7511_input_style input_style;
> +	enum adv7511_input_sync_pulse sync_pulse;
> +	enum adv7511_input_clock_delay clock_delay;
> +	bool reverse_bitorder;
> +	enum adv7511_input_bit_justifiction bit_justification;
> +	enum adv7511_up_conversion up_conversion;
> +	enum adv7511_input_color_depth input_color_depth;
> +	bool tmds_clock_inversion;
> +	enum adv7511_timing_gen_seq timing_gen_seq;
> +
> +	enum adv7511_sync_polarity vsync_polarity;
> +	enum adv7511_sync_polarity hsync_polarity;
> +
> +	int gpio_pd;
> +};
> +
> +/**
> +	adi,input-style = 1|2|3;
> +	adi,input-id = 
> +		"24-bit-rgb444-ycbcr444",
> +		"16-20-24-bit-ycbcr422-separate-sync" |
> +		"16-20-24-bit-ycbcr422-embedded-sync" |
> +		"8-10-12-bit-ycbcr422-separate-sync" |
> +		"8-10-12-bit-ycbcr422-embedded-sync" |
> +		"12-15-16-bit-rgb444-ycbcr444"
> +	adi,sync-pulse = "de","vsync","hsync","none"
> +	adi,clock-delay = -1200|-800|-400|0|400|800|1200|1600
> +	adi,reverse-bitorder
> +	adi,bit-justification = "left"|"right"|"evently";
> +	adi,up-conversion = "zero-order"|"first-order"
> +	adi,input-color-depth = 8|10|12
> +	adi,tdms-clock-inversion
> +	adi,vsync-polarity = "low"|"high"|"passthrough"
> +	adi,hsync-polarity = "low"|"high"|"passtrhough"
> +	adi,timing-gen-seq = "sync-adjustment-first"|"de-generation-first"
> +*/
> +
> +/**
> + * enum adv7511_csc_scaling - Scaling factor for the ADV7511 CSC
> + * @ADV7511_CSC_SCALING_1: CSC results are not scaled
> + * @ADV7511_CSC_SCALING_2: CSC results are scaled by a factor of two
> + * @ADV7511_CSC_SCALING_4: CSC results are scalled by a factor of four
> + **/
> +enum adv7511_csc_scaling {
> +	ADV7511_CSC_SCALING_1 = 0,
> +	ADV7511_CSC_SCALING_2 = 1,
> +	ADV7511_CSC_SCALING_4 = 2,
> +};
> +
> +/**
> + * struct adv7511_video_config - Describes adv7511 hardware configuration
> + * @csc_enable:			Whether to enable color space conversion
> + * @csc_scaling_factor:		Color space conversion scaling factor
> + * @csc_coefficents:		Color space conversion coefficents
> + * @hdmi_mode:			Whether to use HDMI or DVI output mode
> + * @avi_infoframe:		HDMI infoframe
> + **/
> +struct adv7511_video_config {
> +	bool csc_enable;

Shouldn't this be automatically computed based on the input and output formats 
?

> +	enum adv7511_csc_scaling csc_scaling_factor;
> +	const uint16_t *csc_coefficents;

Do the coefficients need to be configured freely, or could presets do ?

> +	bool hdmi_mode;
> +	struct hdmi_avi_infoframe avi_infoframe;
> +};
> +
> +struct adv7511 {
> +	struct i2c_client *i2c_main;
> +	struct i2c_client *i2c_edid;
> +	struct i2c_client *i2c_packet;
> +	struct i2c_client *i2c_cec;
> +
> +	struct regmap *regmap;
> +	struct regmap *packet_memory_regmap;
> +	enum drm_connector_status status;
> +	int dpms_mode;
> +
> +	unsigned int f_tmds;
> +	unsigned int f_audio;
> +
> +	unsigned int audio_source;
> +
> +	unsigned int current_edid_segment;
> +	uint8_t edid_buf[256];
> +
> +	wait_queue_head_t wq;
> +	struct drm_encoder *encoder;
> +
> +	bool embedded_sync;
> +	enum adv7511_sync_polarity vsync_polarity;
> +	enum adv7511_sync_polarity hsync_polarity;
> +
> +	struct edid *edid;
> +
> +	int gpio_pd;
> +};
> +
> +struct edid *adv7511_get_edid(struct drm_encoder *encoder);
> +
> +#endif
> diff --git a/drivers/gpu/drm/i2c/adv7511_audio.c 
b/drivers/gpu/drm/i2c/adv7511_audio.c
> new file mode 100644
> index 0000000..746f383
> --- /dev/null
> +++ b/drivers/gpu/drm/i2c/adv7511_audio.c
> @@ -0,0 +1,304 @@
> +/**
> + * Analog Devices ADV7511 HDMI transmitter driver
> + *
> + * Copyright 2012 Analog Devices Inc.
> + *
> + * Licensed under the GPL-2.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/init.h>
> +#include <linux/delay.h>
> +#include <linux/pm.h>
> +#include <linux/i2c.h>
> +#include <linux/spi/spi.h>

Is this header needed ?

> +#include <linux/slab.h>
> +#include <sound/core.h>
> +#include <sound/pcm.h>
> +#include <sound/pcm_params.h>
> +#include <sound/soc.h>
> +#include <sound/initval.h>
> +#include <sound/tlv.h>

What about sorting the headers alphabetically ? :-)

> +
> +#include "adv7511.h"

[snip]

> diff --git a/drivers/gpu/drm/i2c/adv7511_core.c 
b/drivers/gpu/drm/i2c/adv7511_core.c
> new file mode 100644
> index 0000000..f26151d
> --- /dev/null
> +++ b/drivers/gpu/drm/i2c/adv7511_core.c
> @@ -0,0 +1,979 @@
> +/**
> + * Analog Devices ADV7511 HDMI transmitter driver
> + *
> + * Copyright 2012 Analog Devices Inc.
> + *
> + * Licensed under the GPL-2.
> + */
> +
> +#include <linux/slab.h>
> +#include <linux/module.h>
> +#include <linux/i2c.h>
> +#include <linux/regmap.h>
> +#include <linux/gpio.h>
> +#include <linux/of_gpio.h>
> +
> +#include "adv7511.h"
> +
> +#include <drm/drmP.h>
> +#include <drm/drm_crtc_helper.h>
> +#include <drm/drm_encoder_slave.h>
> +#include <drm/drm_edid.h>

Alphabetical order as well ?

> +static const uint8_t adv7511_register_defaults[] = {
> +	0x12, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 00 */
> +	0x00, 0x00, 0x01, 0x0e, 0xbc, 0x18, 0x01, 0x13,
> +	0x25, 0x37, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 10 */
> +	0x46, 0x62, 0x04, 0xa8, 0x00, 0x00, 0x1c, 0x84,
> +	0x1c, 0xbf, 0x04, 0xa8, 0x1e, 0x70, 0x02, 0x1e, /* 20 */
> +	0x00, 0x00, 0x04, 0xa8, 0x08, 0x12, 0x1b, 0xac,
> +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 30 */
> +	0x00, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00, 0xb0,
> +	0x00, 0x50, 0x90, 0x7e, 0x79, 0x70, 0x00, 0x00, /* 40 */
> +	0x00, 0xa8, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00,
> +	0x00, 0x00, 0x02, 0x0d, 0x00, 0x00, 0x00, 0x00, /* 50 */
> +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 60 */
> +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +	0x01, 0x0a, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 70 */
> +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 80 */
> +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +	0x00, 0x00, 0x00, 0x00, 0xc0, 0x00, 0x00, 0x00, /* 90 */
> +	0x0b, 0x02, 0x00, 0x18, 0x5a, 0x60, 0x00, 0x00,
> +	0x00, 0x00, 0x80, 0x80, 0x08, 0x04, 0x00, 0x00, /* a0 */
> +	0x00, 0x00, 0x00, 0x40, 0x00, 0x00, 0x40, 0x14,
> +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* b0 */
> +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* c0 */
> +	0x00, 0x03, 0x00, 0x00, 0x02, 0x00, 0x01, 0x04,
> +	0x30, 0xff, 0x80, 0x80, 0x80, 0x00, 0x00, 0x00, /* d0 */
> +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x01,
> +	0x80, 0x75, 0x00, 0x00, 0x60, 0x00, 0x00, 0x00, /* e0 */
> +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +	0x00, 0x00, 0x00, 0x00, 0x00, 0x75, 0x11, 0x00, /* f0 */
> +	0x00, 0x7c, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +};
> +
> +/* ADI recommanded values for proper operation. */
> +static const struct reg_default adv7511_fixed_registers[] = {
> +	{ 0x98, 0x03 },
> +	{ 0x9a, 0xe0 },
> +	{ 0x9c, 0x30 },
> +	{ 0x9d, 0x61 },
> +	{ 0xa2, 0xa4 },
> +	{ 0xa3, 0xa4 },
> +	{ 0xe0, 0xd0 },
> +	{ 0xf9, 0x00 },
> +	{ 0x55, 0x02 },
> +};
> +
> +static struct adv7511 *encoder_to_adv7511(struct drm_encoder *encoder)
> +{
> +	return to_encoder_slave(encoder)->slave_priv;
> +}
> +
> +static void adv7511_set_colormap(struct adv7511 *adv7511, bool enable,
> +	const uint16_t *coeff, unsigned int scaling_factor)
> +{
> +	unsigned int i;
> +
> +	regmap_update_bits(adv7511->regmap, ADV7511_REG_CSC_UPPER(1),
> +		ADV7511_CSC_UPDATE_MODE, ADV7511_CSC_UPDATE_MODE);
> +
> +	if (enable) {
> +		for (i = 0; i < 12; ++i) {
> +			regmap_update_bits(adv7511->regmap,
> +				ADV7511_REG_CSC_UPPER(i),
> +				0x1f, coeff[i] >> 8);
> +			regmap_write(adv7511->regmap,
> +				ADV7511_REG_CSC_LOWER(i),
> +				coeff[i] & 0xff);
> +		}
> +	}

You could move this in the first branch of the following if.
> +
> +	if (enable) {
> +		regmap_update_bits(adv7511->regmap, ADV7511_REG_CSC_UPPER(0),
> +			0xe0, 0x80 | (scaling_factor << 5));
> +	} else {
> +		regmap_update_bits(adv7511->regmap, ADV7511_REG_CSC_UPPER(0),
> +			0x80, 0x00);

Could you add #defines for register fields instead of using numerical values 
(for values used here and below) ?

> +	}
> +
> +	regmap_update_bits(adv7511->regmap, ADV7511_REG_CSC_UPPER(1),
> +		ADV7511_CSC_UPDATE_MODE, 0);
> +}
> +
> +#define ADV7511_HDMI_CFG_MODE_MASK 0x2
> +#define ADV7511_HDMI_CFG_MODE_DVI 0x0
> +#define ADV7511_HDMI_CFG_MODE_HDMI 0x2
> +
> +#define ADV7511_PACKET_MEM_SPD		0
> +#define ADV7511_PACKET_MEM_MPEG		1
> +#define ADV7511_PACKET_MEM_ACP		2
> +#define ADV7511_PACKET_MEM_ISRC1	3
> +#define ADV7511_PACKET_MEM_ISRC2	4
> +#define ADV7511_PACKET_MEM_GM		5
> +#define ADV7511_PACKET_MEM_SPARE1	6
> +#define ADV7511_PACKET_MEM_SPARE2	7
> +
> +#define ADV7511_PACKET_MEM_DATA_REG(x) ((x) * 0x20)
> +#define ADV7511_PACKET_MEM_UPDATE_REG(x) ((x) * 0x20 + 0x1f)
> +#define ADV7511_PACKET_MEM_UPDATE_ENABLE BIT(7)

Should this be moved to the adv7511.h header ?

> +#if 0

This should obviously be removed or used :-)

> +static void adv7511_program_infoframe(struct adv7511 *adv7511,
> +	const void *buffer, size_t size, unsigned int reg)
> +{
> +	unsigned int data_reg, update_reg;
> +	unsigned int update_bit;
> +
> +	switch (type) {
> +	case AVI:
> +		regmap = adv7511->regmap;
> +		data_reg = ADV7511_REG_AVI_INFOFRAME_VERSION;
> +		update_reg = ADV7511_REG_INFOFRAME_UPDATE;
> +		update_bit = BIT(6);
> +		break;
> +	case AUDIO:
> +		regmap = adv7511->regmap;
> +		data_reg = ADV7511_REG_AUDIO_INFOFRAME_VERSION;
> +		update_reg = ADV7511_REG_INFOFRAME_UPDATE;
> +		update_bit = BIT(5);
> +		break;
> +	case GC:
> +		regmap = adv7511->regmap;
> +		data_reg = ADV7511_REG_GC(0);
> +		update_reg = ADV7511_REG_INFOFRAME_UPDATE;
> +		update_bit = BIT(4);
> +		break;
> +	case SPD:
> +		regmap = adv7511->packet_memory_regmap;
> +		data_reg = ADV7511_PACKET_MEM_DATA_REG(ADV7511_PACKET_MEM_SPD);
> +		data_reg = ADV7511_PACKET_MEM_UPDATE_REG(ADV7511_PACKET_MEM_SPD);
> +		update_bit = ADV7511_PACKET_MEM_UPDATE_ENABLE;
> +		break;
> +	}
> +
> +	regmap_update_bits(adv7511->regmap, update_reg, update_bit, update_bit);
> +
> +	regmap_bulk_write(adv7511->regmap, data_reg, buffer, size);
> +
> +	regmap_update_bits(adv7511->regmap, update_reg, update_bit, 0);
> +}
> +
> +#endif
> +
> +static void adv7511_set_config(struct drm_encoder *encoder, void *c)

Now we're getting to the controversial point.

What bothers me about the DRM encoder slave API is that the display controller 
driver needs to be aware of the details of the slave encoder, as it needs to 
pass an encoder-specific configuration structure to the .set_config() 
operation. The question would thus be, what about using the Common Display 
Framework ?

> +{
> +	struct adv7511 *adv7511 = encoder_to_adv7511(encoder);
> +	struct adv7511_video_config *config = c;
> +	bool output_format_422, output_format_ycbcr;
> +	unsigned int mode;
> +	uint8_t infoframe[17];
> +
> +	if (config->hdmi_mode) {
> +		mode = ADV7511_HDMI_CFG_MODE_HDMI;
> +
> +		switch (config->avi_infoframe.colorspace) {
> +		case HDMI_COLORSPACE_YUV444:
> +			output_format_422 = false;
> +			output_format_ycbcr = true;
> +			break;
> +		case HDMI_COLORSPACE_YUV422:
> +			output_format_422 = true;
> +			output_format_ycbcr = true;
> +			break;
> +		default:
> +			output_format_422 = false;
> +			output_format_ycbcr = false;
> +			break;
> +		}
> +	} else {
> +		mode = ADV7511_HDMI_CFG_MODE_DVI;
> +		output_format_422 = false;
> +		output_format_ycbcr = false;
> +	}
> +
> +	adv7511_packet_disable(adv7511, ADV7511_PACKET_ENABLE_AVI_INFOFRAME);
> +
> +	adv7511_set_colormap(adv7511, config->csc_enable,
> +		config->csc_coefficents, config->csc_scaling_factor);
> +
> +	regmap_update_bits(adv7511->regmap, ADV7511_REG_VIDEO_INPUT_CFG1, 0x81,
> +		(output_format_422 << 7) | output_format_ycbcr);
> +
> +	regmap_update_bits(adv7511->regmap, ADV7511_REG_HDCP_HDMI_CFG,
> +		ADV7511_HDMI_CFG_MODE_MASK, mode);
> +
> +	hdmi_avi_infoframe_pack(&config->avi_infoframe, infoframe,
> +		sizeof(infoframe));
> +
> +	/* The AVI infoframe id is not configurable */
> +	regmap_bulk_write(adv7511->regmap, ADV7511_REG_AVI_INFOFRAME_VERSION,
> +		infoframe + 1, sizeof(infoframe) - 1);
> +
> +	adv7511_packet_enable(adv7511, ADV7511_PACKET_ENABLE_AVI_INFOFRAME);
> +}
> +
> +static void adv7511_set_link_config(struct adv7511 *adv7511,
> +	const struct adv7511_link_config *config)
> +{
> +	enum adv7511_input_sync_pulse sync_pulse;
> +
> +	switch (config->id) {
> +	case ADV7511_INPUT_ID_12_15_16BIT_RGB444_YCbCr444:
> +		sync_pulse = ADV7511_INPUT_SYNC_PULSE_NONE;
> +		break;
> +	default:
> +		sync_pulse = config->sync_pulse;
> +		break;
> +	}
> +
> +	switch (config->id) {
> +	case ADV7511_INPUT_ID_16_20_24BIT_YCbCr422_EMBEDDED_SYNC:
> +	case ADV7511_INPUT_ID_8_10_12BIT_YCbCr422_EMBEDDED_SYNC:
> +		adv7511->embedded_sync = true;
> +		break;
> +	default:
> +		adv7511->embedded_sync = false;
> +		break;
> +	}
> +
> +	regmap_update_bits(adv7511->regmap, ADV7511_REG_I2C_FREQ_ID_CFG,
> +		0xf, config->id);
> +	regmap_update_bits(adv7511->regmap, ADV7511_REG_VIDEO_INPUT_CFG1, 0x7e,
> +		(config->input_color_depth << 4) | (config->input_style << 2));
> +	regmap_write(adv7511->regmap, ADV7511_REG_VIDEO_INPUT_CFG2,
> +		(config->reverse_bitorder << 6) |
> +		(config->bit_justification << 3));
> +	regmap_write(adv7511->regmap, ADV7511_REG_TIMING_GEN_SEQ,
> +		(sync_pulse << 2) |
> +		(config->timing_gen_seq << 1));
> +	regmap_write(adv7511->regmap, 0xba,
> +		(config->clock_delay << 5));
> +
> +	regmap_update_bits(adv7511->regmap, ADV7511_REG_TMDS_CLOCK_INV,
> +		0x08, config->tmds_clock_inversion << 3);
> +
> +	adv7511->hsync_polarity = config->hsync_polarity;
> +	adv7511->vsync_polarity = config->vsync_polarity;
> +}
> +
> +int adv7511_packet_enable(struct adv7511 *adv7511, unsigned int packet)
> +{
> +	if (packet & 0xff) {
> +		regmap_update_bits(adv7511->regmap, ADV7511_REG_PACKET_ENABLE0,
> +			 packet, 0xff);
> +	}
> +
> +	if (packet & 0xff00) {
> +		packet >>= 8;
> +		regmap_update_bits(adv7511->regmap, ADV7511_REG_PACKET_ENABLE1,
> +			packet, 0xff);
> +	}

What about definings masks in adv7511.h ?

> +
> +	return 0;

The function never returns an error, could it be made void ? Same for the 
disable function below.

> +}
> +
> +int adv7511_packet_disable(struct adv7511 *adv7511, unsigned int packet)
> +{
> +	if (packet & 0xff) {
> +		regmap_update_bits(adv7511->regmap, ADV7511_REG_PACKET_ENABLE0,
> +			 packet, 0x00);
> +	}
> +
> +	if (packet & 0xff00) {
> +		packet >>= 8;
> +		regmap_update_bits(adv7511->regmap, ADV7511_REG_PACKET_ENABLE1,
> +			packet, 0x00);
> +	}
> +
> +	return 0;
> +}
> +
> +static bool adv7511_register_volatile(struct device *dev, unsigned int reg)
> +{
> +	switch (reg) {
> +	case ADV7511_REG_SPDIF_FREQ:
> +	case ADV7511_REG_CTS_AUTOMATIC1:
> +	case ADV7511_REG_CTS_AUTOMATIC2:
> +	case ADV7511_REG_VIC_DETECTED:
> +	case ADV7511_REG_VIC_SEND:
> +	case ADV7511_REG_AUX_VIC_DETECTED:
> +	case ADV7511_REG_STATUS:
> +	case ADV7511_REG_GC(1):
> +	case ADV7511_REG_INT(0):
> +	case ADV7511_REG_INT(1):
> +	case ADV7511_REG_PLL_STATUS:
> +	case ADV7511_REG_AN(0):
> +	case ADV7511_REG_AN(1):
> +	case ADV7511_REG_AN(2):
> +	case ADV7511_REG_AN(3):
> +	case ADV7511_REG_AN(4):
> +	case ADV7511_REG_AN(5):
> +	case ADV7511_REG_AN(6):
> +	case ADV7511_REG_AN(7):
> +	case ADV7511_REG_HDCP_STATUS:
> +	case ADV7511_REG_BCAPS:
> +	case ADV7511_REG_BKSV(0):
> +	case ADV7511_REG_BKSV(1):
> +	case ADV7511_REG_BKSV(2):
> +	case ADV7511_REG_BKSV(3):
> +	case ADV7511_REG_BKSV(4):
> +	case ADV7511_REG_DDC_STATUS:
> +	case ADV7511_REG_BSTATUS(0):
> +	case ADV7511_REG_BSTATUS(1):
> +	case ADV7511_REG_CHIP_ID_HIGH:
> +	case ADV7511_REG_CHIP_ID_LOW:
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
> +static bool adv7511_hpd(struct adv7511 *adv7511)
> +{
> +	unsigned int irq0;
> +	int ret;
> +
> +	ret = regmap_read(adv7511->regmap, ADV7511_REG_INT(0), &irq0);
> +	if (ret < 0)
> +		return false;
> +
> +	if (irq0 & ADV7511_INT0_HDP) {
> +		regmap_write(adv7511->regmap, ADV7511_REG_INT(0), ADV7511_INT0_HDP);
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
> +static irqreturn_t adv7511_irq_handler(int irq, void *devid)
> +{
> +	struct adv7511 *adv7511 = devid;
> +
> +	if (adv7511_hpd(adv7511))
> +		drm_helper_hpd_irq_event(adv7511->encoder->dev);
> +
> +	wake_up_all(&adv7511->wq);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static unsigned int adv7511_is_interrupt_pending(struct adv7511 *adv7511,
> +	unsigned int irq)
> +{
> +	unsigned int irq0, irq1;
> +	unsigned int pending;
> +	int ret;
> +
> +	ret = regmap_read(adv7511->regmap, ADV7511_REG_INT(0), &irq0);
> +	if (ret < 0)
> +		return 0;
> +	ret = regmap_read(adv7511->regmap, ADV7511_REG_INT(1), &irq1);
> +	if (ret < 0)
> +		return 0;
> +
> +	pending = (irq1 << 8) | irq0;
> +
> +	return pending & irq;
> +}
> +
> +static int adv7511_wait_for_interrupt(struct adv7511 *adv7511, int irq,
> +	int timeout)
> +{
> +	unsigned int pending = 0;
> +	int ret;
> +
> +	if (adv7511->i2c_main->irq) {
> +		ret = wait_event_interruptible_timeout(adv7511->wq,
> +				adv7511_is_interrupt_pending(adv7511, irq),
> +				msecs_to_jiffies(timeout));
> +		if (ret <= 0)
> +			return 0;
> +		pending = adv7511_is_interrupt_pending(adv7511, irq);
> +	} else {
> +		if (timeout < 25)
> +			timeout = 25;
> +		do {
> +			pending = adv7511_is_interrupt_pending(adv7511, irq);
> +			if (pending)
> +				break;
> +			msleep(25);
> +			timeout -= 25;
> +		} while (timeout >= 25);
> +	}
> +
> +	return pending;
> +}
> +
> +static int adv7511_get_edid_block(void *data, unsigned char *buf,
> +	int block, int len)
> +{
> +	struct drm_encoder *encoder = data;
> +	struct adv7511 *adv7511 = encoder_to_adv7511(encoder);
> +	struct i2c_msg xfer[2];
> +	uint8_t offset;
> +	int i;
> +	int ret;
> +
> +	if (len > 128)
> +		return -EINVAL;
> +
> +	if (adv7511->current_edid_segment != block / 2) {
> +		unsigned int status;
> +
> +		ret = regmap_read(adv7511->regmap, ADV7511_REG_DDC_STATUS, &status);
> +		if (ret < 0)
> +			return ret;
> +
> +		if (status != 2) {

#define as well ?

> +			regmap_write(adv7511->regmap, ADV7511_REG_EDID_SEGMENT, block);
> +			ret = adv7511_wait_for_interrupt(adv7511, ADV7511_INT0_EDID_READY 
|
> +					ADV7511_INT1_DDC_ERROR, 200);
> +
> +			if (!(ret & ADV7511_INT0_EDID_READY))
> +				return -EIO;
> +		}
> +
> +		regmap_write(adv7511->regmap, ADV7511_REG_INT(0),
> +			ADV7511_INT0_EDID_READY | ADV7511_INT1_DDC_ERROR);
> +
> +		/* Break this apart, hopefully more I2C controllers will support 64
> +		 * byte transfers than 256 byte transfers */
> +
> +		xfer[0].addr = adv7511->i2c_edid->addr;
> +		xfer[0].flags = 0;
> +		xfer[0].len = 1;
> +		xfer[0].buf = &offset;
> +		xfer[1].addr = adv7511->i2c_edid->addr;
> +		xfer[1].flags = I2C_M_RD;
> +		xfer[1].len = 64;
> +		xfer[1].buf = adv7511->edid_buf;
> +
> +		offset = 0;
> +
> +		for (i = 0; i < 4; ++i) {
> +			ret = i2c_transfer(adv7511->i2c_edid->adapter, xfer, 
ARRAY_SIZE(xfer));
> +			if (ret < 0)
> +				return ret;
> +			else if (ret != 2)
> +				return -EIO;
> +
> +			xfer[1].buf += 64;
> +			offset += 64;
> +		}

Shouldn't you read two times 64 bytes per block, not four times ?

> +
> +		adv7511->current_edid_segment = block / 2;
> +	}
> +
> +	if (block % 2 == 0)
> +		memcpy(buf, adv7511->edid_buf, len);
> +	else
> +		memcpy(buf, adv7511->edid_buf + 128, len);
> +
> +	return 0;
> +}
> +
> +static int adv7511_get_modes(struct drm_encoder *encoder,
> +	struct drm_connector *connector)
> +{
> +	struct adv7511 *adv7511 = encoder_to_adv7511(encoder);
> +	struct edid *edid;
> +	unsigned int count;
> +
> +	/* Reading the EDID only works if the device is powered */
> +	if (adv7511->dpms_mode != DRM_MODE_DPMS_ON) {
> +		regmap_write(adv7511->regmap, ADV7511_REG_INT(0),
> +			ADV7511_INT0_EDID_READY | ADV7511_INT1_DDC_ERROR);
> +		regmap_update_bits(adv7511->regmap, ADV7511_REG_POWER,
> +				ADV7511_POWER_POWER_DOWN, 0);
> +		adv7511->current_edid_segment = -1;
> +	}
> +
> +	edid = drm_do_get_edid(connector, adv7511_get_edid_block, encoder);
> +
> +	if (adv7511->dpms_mode != DRM_MODE_DPMS_ON)
> +		regmap_update_bits(adv7511->regmap, ADV7511_REG_POWER,
> +				ADV7511_POWER_POWER_DOWN, ADV7511_POWER_POWER_DOWN);
> +
> +	adv7511->edid = edid;
> +	if (!edid)
> +		return 0;
> +
> +	drm_mode_connector_update_edid_property(connector, edid);
> +	count = drm_add_edid_modes(connector, edid);
> +
> +	kfree(adv7511->edid);

Really ? Shouldn't you then move the adv7511->edid = edid; line below ?

> +
> +	return count;
> +}
> +
> +struct edid *adv7511_get_edid(struct drm_encoder *encoder)
> +{
> +	struct adv7511 *adv7511 = encoder_to_adv7511(encoder);
> +
> +	if (!adv7511->edid)
> +		return NULL;
> +
> +	return kmemdup(adv7511->edid, sizeof(*adv7511->edid) +
> +		adv7511->edid->extensions * 128, GFP_KERNEL);
> +}
> +EXPORT_SYMBOL_GPL(adv7511_get_edid);

Why do you need to export this function, who will use it ?

> +static void adv7511_encoder_dpms(struct drm_encoder *encoder, int mode)
> +{
> +	struct adv7511 *adv7511 = encoder_to_adv7511(encoder);
> +
> +	switch (mode) {
> +	case DRM_MODE_DPMS_ON:
> +		adv7511->current_edid_segment = -1;
> +
> +		regmap_write(adv7511->regmap, ADV7511_REG_INT(0),
> +			ADV7511_INT0_EDID_READY | ADV7511_INT1_DDC_ERROR);
> +		regmap_update_bits(adv7511->regmap, ADV7511_REG_POWER,
> +				ADV7511_POWER_POWER_DOWN, 0);
> +		/*
> +		 * Per spec it is allowed to pulse the HDP signal to indicate
> +		 * that the EDID information has changed. Some monitors do this
> +		 * when they wakeup from standby or are enabled. When the HDP
> +		 * goes low the adv7511 is reset and the outputs are disabled
> +		 * which might cause the monitor to go to standby again. To
> +		 * avoid this we ignore the HDP pin for the first few seconds
> +		 * after enabeling the output.

s/enabeling/enabling/

> +		 */
> +		regmap_update_bits(adv7511->regmap, ADV7511_REG_POWER2,
> +				ADV7511_REG_POWER2_HDP_SRC_MASK,
> +				ADV7511_REG_POWER2_HDP_SRC_NONE);
> +		/* Most of the registers are reset during power down or when HPD is 
low */
> +		regcache_sync(adv7511->regmap);
> +		break;
> +	default:
> +		/* TODO: setup additional power down modes */
> +		regmap_update_bits(adv7511->regmap, ADV7511_REG_POWER,
> +				ADV7511_POWER_POWER_DOWN, ADV7511_POWER_POWER_DOWN);
> +		regcache_mark_dirty(adv7511->regmap);
> +		break;
> +	}
> +
> +	adv7511->dpms_mode = mode;
> +}
> +
> +static enum drm_connector_status adv7511_encoder_detect(struct drm_encoder 
*encoder,
> +	struct drm_connector *connector)
> +{
> +	struct adv7511 *adv7511 = encoder_to_adv7511(encoder);
> +	enum drm_connector_status status;
> +	unsigned int val;
> +	bool hpd;
> +	int ret;
> +
> +	ret = regmap_read(adv7511->regmap, ADV7511_REG_STATUS, &val);
> +	if (ret < 0)
> +		return connector_status_disconnected;
> +
> +	if (val & ADV7511_STATUS_HPD)
> +		status = connector_status_connected;
> +	else
> +		status = connector_status_disconnected;
> +
> +	hpd = adv7511_hpd(adv7511);
> +
> +	/* The chip resets itself when the cable is disconnected, so in case
> +	 * there is a pending HPD interrupt and the cable is connected there was
> +	 * at least on transition from disconnected to connected and the chip
> +	 * has to be reinitialized. */
> +	if (status == connector_status_connected && hpd &&
> +		adv7511->dpms_mode == DRM_MODE_DPMS_ON) {
> +		regcache_mark_dirty(adv7511->regmap);
> +		adv7511_encoder_dpms(encoder, adv7511->dpms_mode);
> +		adv7511_get_modes(encoder, connector);
> +		status = connector_status_disconnected;
> +	} else {
> +		/* Renable HDP sensing */
> +		regmap_update_bits(adv7511->regmap, ADV7511_REG_POWER2,
> +				ADV7511_REG_POWER2_HDP_SRC_MASK,
> +				ADV7511_REG_POWER2_HDP_SRC_BOTH);
> +	}
> +
> +	adv7511->status = status;
> +	return status;
> +}
> +
> +static void adv7511_encoder_mode_set(struct drm_encoder *encoder,
> +	struct drm_display_mode *mode,
> +	struct drm_display_mode *adj_mode)
> +{
> +	struct adv7511 *adv7511 = encoder_to_adv7511(encoder);
> +	unsigned int low_refresh_rate;
> +	unsigned int hsync_polarity = 0;
> +	unsigned int vsync_polarity = 0;
> +
> +	if (adv7511->embedded_sync) {
> +		unsigned int hsync_offset, hsync_len;
> +		unsigned int vsync_offset, vsync_len;
> +
> +		hsync_offset = adj_mode->crtc_hsync_start - adj_mode->crtc_hdisplay;
> +		vsync_offset = adj_mode->crtc_vsync_start - adj_mode->crtc_vdisplay;
> +		hsync_len = adj_mode->crtc_hsync_end - adj_mode->crtc_hsync_start;
> +		vsync_len = adj_mode->crtc_vsync_end - adj_mode->crtc_vsync_start;
> +
> +		/* The hardware vsync generator has a off-by-one bug */
> +		vsync_offset += 1;
> +
> +		regmap_write(adv7511->regmap, ADV7511_REG_HSYNC_PLACEMENT_MSB,
> +			((hsync_offset >> 10) & 0x7) << 5);
> +		regmap_write(adv7511->regmap, ADV7511_REG_SYNC_DECODER(0),
> +			(hsync_offset >> 2) & 0xff);
> +		regmap_write(adv7511->regmap, ADV7511_REG_SYNC_DECODER(1),
> +			((hsync_offset & 0x3) << 6) | ((hsync_len >> 4) & 0x3f));
> +		regmap_write(adv7511->regmap, ADV7511_REG_SYNC_DECODER(2),
> +			((hsync_len & 0xf) << 4) | ((vsync_offset >> 6) & 0xf));
> +		regmap_write(adv7511->regmap, ADV7511_REG_SYNC_DECODER(3),
> +			((vsync_offset & 0x3f) << 2) | ((vsync_len >> 8) & 0x3));
> +		regmap_write(adv7511->regmap, ADV7511_REG_SYNC_DECODER(4),
> +			vsync_len & 0xff);
> +
> +		hsync_polarity = !(adj_mode->flags & DRM_MODE_FLAG_PHSYNC);
> +		vsync_polarity = !(adj_mode->flags & DRM_MODE_FLAG_PVSYNC);
> +	} else {
> +		enum adv7511_sync_polarity mode_hsync_polarity;
> +		enum adv7511_sync_polarity mode_vsync_polarity;
> +
> +		/**
> +		 * If the input signal is always low or always high we want to
> +		 * invert or let it passthrough depending on the polarity of the
> +		 * current mode.
> +		 **/
> +		if (adj_mode->flags & DRM_MODE_FLAG_NHSYNC)
> +			mode_hsync_polarity = ADV7511_SYNC_POLARITY_LOW;
> +		else
> +			mode_hsync_polarity = ADV7511_SYNC_POLARITY_HIGH;
> +
> +		if (adj_mode->flags & DRM_MODE_FLAG_NVSYNC)
> +			mode_vsync_polarity = ADV7511_SYNC_POLARITY_LOW;
> +		else
> +			mode_vsync_polarity = ADV7511_SYNC_POLARITY_HIGH;
> +
> +		if (adv7511->hsync_polarity != mode_hsync_polarity &&
> +		    adv7511->hsync_polarity != ADV7511_SYNC_POLARITY_PASSTHROUGH)
> +			hsync_polarity = 1;
> +
> +		if (adv7511->vsync_polarity != mode_vsync_polarity &&
> +		    adv7511->vsync_polarity != ADV7511_SYNC_POLARITY_PASSTHROUGH)
> +			vsync_polarity = 1;
> +	}
> +
> +	if (mode->vrefresh <= 24000)
> +		low_refresh_rate = ADV7511_LOW_REFRESH_RATE_24HZ;
> +	else if (mode->vrefresh <= 25000)
> +		low_refresh_rate = ADV7511_LOW_REFRESH_RATE_25HZ;
> +	else if (mode->vrefresh <= 30000)
> +		low_refresh_rate = ADV7511_LOW_REFRESH_RATE_30HZ;
> +	else
> +		low_refresh_rate = ADV7511_LOW_REFRESH_RATE_NONE;
> +
> +	regmap_update_bits(adv7511->regmap, 0xfb,
> +		0x6, low_refresh_rate << 1);
> +	regmap_update_bits(adv7511->regmap, 0x17,
> +		0x60, (vsync_polarity << 6) | (hsync_polarity << 5));
> +
> +	adv7511->f_tmds = mode->clock;
> +}
> +
> +static struct drm_encoder_slave_funcs adv7511_encoder_funcs = {
> +	.set_config = adv7511_set_config,
> +	.dpms = adv7511_encoder_dpms,
> +	/* .destroy = adv7511_encoder_destroy,*/
> +	.mode_set = adv7511_encoder_mode_set,
> +	.detect = adv7511_encoder_detect,
> +	.get_modes = adv7511_get_modes,
> +};
> +
> +static const struct regmap_config adv7511_regmap_config = {
> +	.reg_bits = 8,
> +	.val_bits = 8,
> +
> +	.max_register = 0xff,
> +	.cache_type = REGCACHE_RBTREE,
> +	.reg_defaults_raw = adv7511_register_defaults,
> +	.num_reg_defaults_raw = ARRAY_SIZE(adv7511_register_defaults),
> +
> +	.volatile_reg = adv7511_register_volatile,
> +};
> +
> +/*
> +	adi,input-id - 
> +		0x00: 
> +		0x01:
> +		0x02:
> +		0x03:
> +		0x04:
> +		0x05:
> +	adi,sync-pulse - Selects the sync pulse
> +		0x00: Use the DE signal as sync pulse
> +		0x01: Use the HSYNC signal as sync pulse
> +		0x02: Use the VSYNC signal as sync pulse
> +		0x03: No external sync pulse
> +	adi,bit-justification -
> +		0x00: Evently
> +		0x01: Right
> +		0x02: Left
> +	adi,up-conversion - 
> +		0x00: zero-order up conversion
> +		0x01: first-order up conversion
> +	adi,timing-generation-sequence -
> +		0x00: Sync adjustment first, then DE generation
> +		0x01: DE generation first then sync adjustment
> +	adi,vsync-polarity - Polarity of the vsync signal
> +		0x00: Passthrough
> +		0x01: Active low
> +		0x02: Active high
> +	adi,hsync-polarity - Polarity of the hsync signal
> +		0x00: Passthrough
> +		0x01: Active low
> +		0x02: Active high
> +	adi,reverse-bitorder - If set the bitorder is reveresed
> +	adi,tmds-clock-inversion - If set use tdms clock inversion
> +	adi,clock-delay - Clock delay for the video data clock
> +		0x00: -1200 ps
> +		0x01:  -800 ps
> +		0x02:  -400 ps
> +		0x03: no dealy
> +		0x04:   400 ps
> +		0x05:   800 ps
> +		0x06:  1200 ps
> +		0x07:  1600 ps

The value should be expressed directly in ps in the DT.

> +	adi,input-style - Specifies the input style used
> +		0x02: Use input style 1
> +		0x01: Use input style 2
> +		0x03: Use Input style 3
> +	adi,input-color-depth - Selects the input format color depth 
> +		0x03: 8-bit per channel
> +		0x01: 10-bit per channel
> +		0x02: 12-bit per channel

The properties related to the input format should be grouped in a single input 
format property, as discussed above for the input format enums.

> +*/
> +
> +
> +static int adv7511_parse_dt(struct device_node *np, struct 
adv7511_link_config *config)
> +{
> +	int ret;
> +	u32 val;
> +
> +	ret = of_property_read_u32(np, "adi,input-id", &val);
> +	if (ret < 0)
> +		return ret;
> +	config->id = val;
> +
> +	ret = of_property_read_u32(np, "adi,sync-pulse", &val);
> +	if (ret < 0)
> +		config->sync_pulse = ADV7511_INPUT_SYNC_PULSE_NONE;
> +	else
> +		config->sync_pulse = val;
> +
> +	ret = of_property_read_u32(np, "adi,bit-justification", &val);
> +	if (ret < 0)
> +		return ret;
> +	config->bit_justification = val;
> +
> +	ret = of_property_read_u32(np, "adi,up-conversion", &val);
> +	if (ret < 0)
> +		config->up_conversion = ADV7511_UP_CONVERSION_ZERO_ORDER;
> +	else
> +		config->up_conversion = val;
> +
> +	ret = of_property_read_u32(np, "adi,timing-generation-sequence", &val);
> +	if (ret < 0)
> +		return ret;
> +	config->timing_gen_seq = val;
> +
> +	ret = of_property_read_u32(np, "adi,vsync-polarity", &val);
> +	if (ret < 0)
> +		return ret;
> +	config->vsync_polarity = val;
> +
> +	ret = of_property_read_u32(np, "adi,hsync-polarity", &val);
> +	if (ret < 0)
> +		return ret;
> +	config->hsync_polarity = val;
> +
> +	config->reverse_bitorder = of_property_read_bool(np,
> +		"adi,reverse-bitorder");
> +	config->tmds_clock_inversion = of_property_read_bool(np,
> +		"adi,tmds-clock-inversion");
> +
> +	ret = of_property_read_u32(np, "adi,clock-delay", &val);
> +	if (ret)
> +		return ret;
> +	config->clock_delay = val;
> +
> +	ret = of_property_read_u32(np, "adi,input-style", &val);
> +	if (ret)
> +		return ret;
> +	config->input_style = val;
> +
> +	ret = of_property_read_u32(np, "adi,input-color-depth", &val);
> +	if (ret)
> +		return ret;
> +	config->input_color_depth = val;
> +
> +	config->gpio_pd = of_get_gpio(np, 0);
> +	if (config->gpio_pd == -EPROBE_DEFER)
> +		return -EPROBE_DEFER;
> +
> +	return 0;
> +}
> +
> +static const int edid_i2c_addr = 0x7e;
> +static const int packet_i2c_addr = 0x70;
> +static const int cec_i2c_addr = 0x78;

What about #defines instead of static const ints ?


> +static int adv7511_probe(struct i2c_client *i2c,
> +	const struct i2c_device_id *id)
> +{
> +	struct adv7511_link_config link_config;
> +	struct adv7511 *adv7511;
> +	unsigned int val;
> +	int ret;
> +
> +	if (i2c->dev.of_node) {
> +		ret = adv7511_parse_dt(i2c->dev.of_node, &link_config);
> +		if (ret)
> +			return ret;
> +	} else {
> +		if (!i2c->dev.platform_data)
> +			return -EINVAL;
> +		link_config = *(struct adv7511_link_config *)i2c->dev.platform_data;
> +	}
> +
> +	adv7511 = devm_kzalloc(&i2c->dev, sizeof(*adv7511), GFP_KERNEL);
> +	if (!adv7511)
> +		return -ENOMEM;
> +
> +	adv7511->gpio_pd = link_config.gpio_pd;
> +
> +	if (gpio_is_valid(adv7511->gpio_pd)) {
> +		ret = devm_gpio_request_one(&i2c->dev, adv7511->gpio_pd,
> +				GPIOF_OUT_INIT_HIGH, "PD");
> +		if (ret)
> +			return ret;
> +		mdelay(5);

msleep() or usleep_range() ?

> +		gpio_set_value_cansleep(adv7511->gpio_pd, 0);
> +	}
> +
> +	adv7511->regmap = devm_regmap_init_i2c(i2c, &adv7511_regmap_config);
> +	if (IS_ERR(adv7511->regmap))
> +		return PTR_ERR(adv7511->regmap);
> +
> +	ret = regmap_read(adv7511->regmap, ADV7511_REG_CHIP_REVISION, &val);
> +	if (ret)
> +		return ret;
> +	dev_dbg(&i2c->dev, "Rev. %d\n", val);
> +
> +	ret = regmap_register_patch(adv7511->regmap, adv7511_fixed_registers,
> +		ARRAY_SIZE(adv7511_fixed_registers));
> +	if (ret)
> +		return ret;
> +
> +	regmap_write(adv7511->regmap, ADV7511_REG_EDID_I2C_ADDR, edid_i2c_addr);
> +	regmap_write(adv7511->regmap, ADV7511_REG_PACKET_I2C_ADDR, 
packet_i2c_addr);
> +	regmap_write(adv7511->regmap, ADV7511_REG_CEC_I2C_ADDR, cec_i2c_addr);
> +	adv7511_packet_disable(adv7511, 0xffff);
> +
> +	adv7511->i2c_main = i2c;
> +	adv7511->i2c_edid = i2c_new_dummy(i2c->adapter, edid_i2c_addr >> 1);
> +	adv7511->i2c_packet = i2c_new_dummy(i2c->adapter, packet_i2c_addr >> 1);
> +	if (!adv7511->i2c_edid)
> +		return -ENOMEM;

Wouldn't this leak i2c_packet ?

> +
> +	if (i2c->irq) {
> +		ret = request_threaded_irq(i2c->irq, NULL, adv7511_irq_handler,
> +				IRQF_ONESHOT, dev_name(&i2c->dev), adv7511);

You can use the devm_ version and get rid of the free_irq() in the remove() 
handler.

> +		if (ret)
> +			goto err_i2c_unregister_device;
> +
> +		init_waitqueue_head(&adv7511->wq);
> +	}
> +
> +	/* CEC is unused for now */
> +	regmap_write(adv7511->regmap, ADV7511_REG_CEC_CTRL,
> +		ADV7511_CEC_CTRL_POWER_DOWN);
> +
> +	regmap_update_bits(adv7511->regmap, ADV7511_REG_POWER,
> +			ADV7511_POWER_POWER_DOWN, ADV7511_POWER_POWER_DOWN);
> +
> +	adv7511->current_edid_segment = -1;
> +
> +	i2c_set_clientdata(i2c, adv7511);
> +	adv7511_audio_init(&i2c->dev);
> +
> +	adv7511_set_link_config(adv7511, &link_config);
> +
> +	return 0;
> +
> +err_i2c_unregister_device:
> +	i2c_unregister_device(adv7511->i2c_edid);

Shouldn't you also unregister i2c_packet ?

> +
> +	return ret;
> +}
> +
> +static int adv7511_remove(struct i2c_client *i2c)
> +{
> +	struct adv7511 *adv7511 = i2c_get_clientdata(i2c);
> +
> +	i2c_unregister_device(adv7511->i2c_edid);

Shouldn't you also unregister i2c_packet ?

> +
> +	if (i2c->irq)
> +		free_irq(i2c->irq, adv7511);
> +	kfree(adv7511->edid);
> +
> +	return 0;
> +}
> +
> +static int adv7511_encoder_init(struct i2c_client *i2c,
> +	struct drm_device *dev, struct drm_encoder_slave *encoder)
> +{
> +
> +	struct adv7511 *adv7511 = i2c_get_clientdata(i2c);
> +
> +	encoder->slave_priv = adv7511;
> +	encoder->slave_funcs = &adv7511_encoder_funcs;
> +
> +	adv7511->encoder = &encoder->base;
> +
> +	return 0;
> +}
> +
> +static const struct i2c_device_id adv7511_ids[] = {
> +	{ "adv7511", 0 },
> +	{}
> +};
> +
> +static struct drm_i2c_encoder_driver adv7511_driver = {
> +	.i2c_driver = {
> +		.driver = {
> +			.name = "adv7511",
> +		},
> +		.id_table = adv7511_ids,
> +		.probe = adv7511_probe,
> +		.remove = adv7511_remove,
> +	},
> +
> +	.encoder_init = adv7511_encoder_init,
> +};
> +
> +static int __init adv7511_init(void)
> +{
> +	return drm_i2c_encoder_register(THIS_MODULE, &adv7511_driver);
> +}
> +module_init(adv7511_init);
> +
> +static void __exit adv7511_exit(void)
> +{
> +	drm_i2c_encoder_unregister(&adv7511_driver);
> +}
> +module_exit(adv7511_exit);
> +
> +MODULE_AUTHOR("Lars-Peter Clausen <lars@metafoo.de>");
> +MODULE_DESCRIPTION("ADV7511 HDMI transmitter driver");
> +MODULE_LICENSE("GPL");

-- 
Regards,

Laurent Pinchart

