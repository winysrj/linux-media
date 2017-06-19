Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:56696 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752339AbdFSJNW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 05:13:22 -0400
Subject: Re: [PATCH v4 1/2] media: i2c: adv748x: add adv748x driver
To: Kieran Bingham <kbingham@kernel.org>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
        niklas.soderlund@ragnatech.se,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
References: <cover.d0545e32d322ca1b939fa2918694173629e680eb.1497313626.git-series.kieran.bingham+renesas@ideasonboard.com>
 <865b71d4fcf6ce407a94a10d5dcb06944ddb6dcb.1497313626.git-series.kieran.bingham+renesas@ideasonboard.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <07ad1ecd-a63e-3c94-87ad-4e1978759011@xs4all.nl>
Date: Mon, 19 Jun 2017 11:13:15 +0200
MIME-Version: 1.0
In-Reply-To: <865b71d4fcf6ce407a94a10d5dcb06944ddb6dcb.1497313626.git-series.kieran.bingham+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/13/2017 02:35 AM, Kieran Bingham wrote:
> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> Provide support for the ADV7481 and ADV7482.
> 
> The driver is modelled with 4 subdevices to allow simultaneous streaming
> from the AFE (Analog front end) and HDMI inputs though two CSI TX
> entities.
> 
> The HDMI entity is linked to the TXA CSI bus, whilst the AFE is linked
> to the TXB CSI bus.
> 
> The driver is based on a prototype by Koji Matsuoka in the Renesas BSP,
> and an earlier rework by Niklas Söderlund.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> ---
> 
> v2:
>   - Implement DT parsing
>   - adv748x: Add CSI2 entity
>   - adv748x: Rework pad allocations and fmts
>   - Give AFE 8 input pads and move pad defines
>   - Use the enums to ensure pads are referenced correctly.
>   - adv748x: Rename AFE/HDMI entities
>     Now they are 'just afe' and 'just hdmi'
>   - Reorder the entity enum and structures
>   - Added pad-format for the CSI2 entities
>   - CSI2 s_stream pass through
>   - CSI2 control pass through (with link following)
> 
> v3:
>   - dt: Extend DT documentation to specify interrupt mappings
>   - simplify adv748x_parse_dt
>   - core: Add banner to header file describing ADV748x variants
>   - Use entity structure pointers rather than global state pointers where
>     possible
>   - afe: Reduce indent on afe_status
>   - hdmi: Add error checking to the bt->pixelclock values.
>   - Remove all unnecessary pad checks: handled by core
>   - Fix all probe cleanup paths
>   - adv748x_csi2_probe() now fails if it has no endpoint
>   - csi2: Fix small oneliners for is_txa and get_remote_sd()
>   - csi2: Fix checkpatch warnings
>   - csi2: Fix up s_stream pass-through
>   - csi2: Fix up Pixel Rate passthrough
>   - csi2: simplify adv748x_csi2_get_pad_format()
>   - Remove 'async notifiers' from AFE/HDMI
>     Using async notifiers was overkill, when we have access to the
>     subdevices internally and can register them directly.
>   - Use state lock in control handlers and clean up s_ctrls
>   - remove _interruptible mutex locks
> 
> v4:
>   - all: Convert hex 0xXX to lowercase
>   - all: Use defines instead of hardcoded register values
>   - all: Use regmap
>   - afe, csi2, hdmi: _probe -> _init
>   - afe, csi2, hdmi: _remove -> _cleanup
>   - afe, hdmi: Convert pattern generator to a control
>   - afe, hdmi: get/set-fmt refactor
>   - afe, hdmi, csi2: Convert to internal calls for pixelrate
>   - afe: Allow the AFE to configure the Input Select from DT
>   - afe: Reduce indent on adv748x_afe_status switch
>   - afe: Remove ununsed macro definitions AIN0-7
>   - afe: Remove extraneous control checks handled by core
>   - afe: Comment fixups
>   - afe: Rename error label
>   - afe: Correct control names on the SDP
>   - afe: Use AIN0-7 rather than AIN1-8 to match ports and MC pads
>   - core: adv748x_parse_dt references to nodes, and catch multiple
>     endpoints in a port.
>   - core: adv748x_dt_cleanup to simplify releasing DT nodes
>   - core: adv748x_print_info renamed to adv748x_identify_chip
>   - core: reorganise ordering of probe sequence
>   - core: No need for of_match_ptr
>   - core: Fix up i2c read/writes (regmap still on todo list)
>   - core: Set specific functions from the entities on subdev-init
>   - core: Use kzalloc for state instead of devm
>   - core: Improve probe error reporting
>   - core: Track unknown BIT(6) in tx{a,b}_power
>   - csi2: Improve adv748x_csi2_get_remote_sd as adv748x_csi2_get_source_sd
>   - csi2: -EPIPE instead of -ENODEV
>   - csi2: adv_dbg, instead of adv_info
>   - csi2: adv748x_csi2_set_format fix
>   - csi2: remove async notifier and sd member variables
>   - csi2: register links from the CSI2
>   - csi2: create virtual channel helper function
>   - dt: Remove numbering from endpoints
>   - dt: describe ports and interrupts as optional
>   - dt: Re-tab
>   - hdmi: adv748x_hdmi_have_signal -> adv748x_hdmi_has_signal
>   - hdmi: fix adv748x_hdmi_read_pixelclock return checks
>   - hdmi: improve adv748x_hdmi_set_video_timings
>   - hdmi: Fix tmp variable as polarity
>   - hdmi: Improve adv748x_hdmi_s_stream
>   - hdmi: Clean up adv748x_hdmi_s_ctrl register definitions and usage
>   - hdmi: Fix up adv748x_hdmi_s_dv_timings with macro names for register
>   - hdmi: Add locking to adv748x_hdmi_g_dv_timings
>     writes and locking
>   - hdmi: adv748x_hdmi_set_de_timings function added to clarify DE writes
>   - hdmi: Use CP in control register naming to match component processor
>   - hdmi: clean up adv748x_hdmi_query_dv_timings()
>   - KConfig: Fix up dependency and capitalisation
> 
> 
>   Documentation/devicetree/bindings/media/i2c/adv748x.txt |  96 +-

This should be a separate patch cross posted to the devicetree mailinglist.

>   MAINTAINERS                                             |   6 +-

This should also be a separate patch.

>   drivers/media/i2c/Kconfig                               |  11 +-
>   drivers/media/i2c/Makefile                              |   1 +-
>   drivers/media/i2c/adv748x/Makefile                      |   7 +-
>   drivers/media/i2c/adv748x/adv748x-afe.c                 | 571 ++++++-
>   drivers/media/i2c/adv748x/adv748x-core.c                | 907 +++++++++-
>   drivers/media/i2c/adv748x/adv748x-csi2.c                | 323 +++-
>   drivers/media/i2c/adv748x/adv748x-hdmi.c                | 652 ++++++-
>   drivers/media/i2c/adv748x/adv748x.h                     | 415 ++++-
>   10 files changed, 2989 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/media/i2c/adv748x.txt
>   create mode 100644 drivers/media/i2c/adv748x/Makefile
>   create mode 100644 drivers/media/i2c/adv748x/adv748x-afe.c
>   create mode 100644 drivers/media/i2c/adv748x/adv748x-core.c
>   create mode 100644 drivers/media/i2c/adv748x/adv748x-csi2.c
>   create mode 100644 drivers/media/i2c/adv748x/adv748x-hdmi.c
>   create mode 100644 drivers/media/i2c/adv748x/adv748x.h
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/adv748x.txt b/Documentation/devicetree/bindings/media/i2c/adv748x.txt
> new file mode 100644
> index 000000000000..b17f8983c992
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/adv748x.txt
> @@ -0,0 +1,96 @@
> +* Analog Devices ADV748X video decoder with HDMI receiver
> + > +The ADV7481, and ADV7482 are multi format video decoders with an integrated

No comma needed.

> +HDMI receiver. They can output CSI-2 on two independent outputs TXA and TXB
> +from three input sources HDMI, analog and TTL.
> +
> +Required Properties:
> +
> +  - compatible: Must contain one of the following
> +    - "adi,adv7481" for the ADV7481
> +    - "adi,adv7482" for the ADV7482
> +
> +  - reg: I2C slave address
> +
> +Optional Properties:
> +
> +  - interrupt-names: Should specify the interrupts as "intrq1", "intrq2" and/or
> +		     "intrq3". All interrupts are optional. The "intrq3" interrupt
> +		     is only available on the adv7481
> +  - interrupts: Specify the interrupt lines for the ADV748x
> +
> +The device node must contain one 'port' child node per device input and output
> +port, in accordance with the video interface bindings defined in
> +Documentation/devicetree/bindings/media/video-interfaces.txt. The port nodes
> +are numbered as follows.
> +
> +	  Name		Type		Port
> +	---------------------------------------
> +	  AIN0		sink		0
> +	  AIN1		sink		1
> +	  AIN2		sink		2
> +	  AIN3		sink		3
> +	  AIN4		sink		4
> +	  AIN5		sink		5
> +	  AIN6		sink		6
> +	  AIN7		sink		7
> +	  HDMI		sink		8
> +	  TTL		sink		9
> +	  TXA		source		10
> +	  TXB		source		11
> +
> +The digital output port nodes must contain at least one endpoint.
> +
> +Ports are optional if they are not connected to anything at the hardware level,
> +but the driver may not provide any support for ports which are not described.

Not sure what is meant by 'but the driver may not provide any support for ports
which are not described'. Isn't that expected behavior if you leave out the port?

> +
> +Example:
> +
> +	video_receiver@70 {
> +		compatible = "adi,adv7482";
> +		reg = <0x70>;
> +
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		interrupt-parent = <&gpio6>;
> +		interrupt-names = "intrq1", "intrq2";
> +		interrupts = <30 IRQ_TYPE_LEVEL_LOW>,
> +			     <31 IRQ_TYPE_LEVEL_LOW>;
> +
> +		port@7 {
> +			reg = <7>;
> +
> +			adv7482_ain7: endpoint {
> +				remote-endpoint = <&cvbs_in>;
> +			};
> +		};
> +
> +		port@8 {
> +			reg = <8>;
> +
> +			adv7482_hdmi: endpoint {
> +				remote-endpoint = <&hdmi_in>;
> +			};
> +		};
> +
> +		port@10 {
> +			reg = <10>;
> +
> +			adv7482_txa: endpoint {
> +				clock-lanes = <0>;
> +				data-lanes = <1 2 3 4>;
> +				remote-endpoint = <&csi40_in>;
> +			};
> +		};
> +
> +		port@11 {
> +			reg = <11>;
> +
> +			adv7482_txb: endpoint {
> +				clock-lanes = <0>;
> +				data-lanes = <1>;
> +				remote-endpoint = <&csi20_in>;
> +			};
> +		};
> +	};
> diff --git a/MAINTAINERS b/MAINTAINERS
> index eaaa35419fa2..7e2b65240a6f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -776,6 +776,12 @@ L:	linux-media@vger.kernel.org
>   S:	Maintained
>   F:	drivers/media/i2c/adv7511*
>   
> +ANALOG DEVICES INC ADV748X DRIVER
> +M:	Kieran Bingham <kieran.bingham@ideasonboard.com>
> +L:	linux-media@vger.kernel.org
> +S:	Maintained
> +F:	drivers/media/i2c/adv748x/*
> +
>   ANALOG DEVICES INC ADV7604 DRIVER
>   M:	Hans Verkuil <hans.verkuil@cisco.com>
>   L:	linux-media@vger.kernel.org
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index 7c23b7a1fd05..fcbec4273fef 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -204,6 +204,17 @@ config VIDEO_ADV7183
>   	  To compile this driver as a module, choose M here: the
>   	  module will be called adv7183.
>   
> +config VIDEO_ADV748X
> +	tristate "Analog Devices ADV748x decoder"
> +	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
> +	depends on OF
> +	---help---
> +	  V4L2 subdevice driver for the Analog Devices
> +	  ADV7481 and ADV7482 HDMI/Analog video decoders.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called adv748x.
> +
>   config VIDEO_ADV7604
>   	tristate "Analog Devices ADV7604 decoder"
>   	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
> index 62323ec66be8..e0e6045a2ec8 100644
> --- a/drivers/media/i2c/Makefile
> +++ b/drivers/media/i2c/Makefile
> @@ -27,6 +27,7 @@ obj-$(CONFIG_VIDEO_ADV7180) += adv7180.o
>   obj-$(CONFIG_VIDEO_ADV7183) += adv7183.o
>   obj-$(CONFIG_VIDEO_ADV7343) += adv7343.o
>   obj-$(CONFIG_VIDEO_ADV7393) += adv7393.o
> +obj-$(CONFIG_VIDEO_ADV748X) += adv748x/
>   obj-$(CONFIG_VIDEO_ADV7604) += adv7604.o
>   obj-$(CONFIG_VIDEO_ADV7842) += adv7842.o
>   obj-$(CONFIG_VIDEO_AD9389B) += ad9389b.o
> diff --git a/drivers/media/i2c/adv748x/Makefile b/drivers/media/i2c/adv748x/Makefile
> new file mode 100644
> index 000000000000..c0711e076f1d
> --- /dev/null
> +++ b/drivers/media/i2c/adv748x/Makefile
> @@ -0,0 +1,7 @@
> +adv748x-objs	:= \
> +		adv748x-afe.o \
> +		adv748x-core.o \
> +		adv748x-csi2.o \
> +		adv748x-hdmi.o
> +
> +obj-$(CONFIG_VIDEO_ADV748X)	+= adv748x.o
> diff --git a/drivers/media/i2c/adv748x/adv748x-afe.c b/drivers/media/i2c/adv748x/adv748x-afe.c
> new file mode 100644
> index 000000000000..28e95b292d9b
> --- /dev/null
> +++ b/drivers/media/i2c/adv748x/adv748x-afe.c
> @@ -0,0 +1,571 @@
> +/*
> + * Driver for Analog Devices ADV748X 8 channel analog front end (AFE) receiver
> + * with standard definition processor (SDP)
> + *
> + * Copyright (C) 2017 Renesas Electronics Corp.
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/v4l2-dv-timings.h>
> +
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-dv-timings.h>
> +#include <media/v4l2-ioctl.h>
> +
> +#include "adv748x.h"
> +
> +/* -----------------------------------------------------------------------------
> + * SDP
> + */
> +
> +#define ADV748X_AFE_STD_AD_PAL_BG_NTSC_J_SECAM		0x0
> +#define ADV748X_AFE_STD_AD_PAL_BG_NTSC_J_SECAM_PED	0x1
> +#define ADV748X_AFE_STD_AD_PAL_N_NTSC_J_SECAM		0x2
> +#define ADV748X_AFE_STD_AD_PAL_N_NTSC_M_SECAM		0x3
> +#define ADV748X_AFE_STD_NTSC_J				0x4
> +#define ADV748X_AFE_STD_NTSC_M				0x5
> +#define ADV748X_AFE_STD_PAL60				0x6
> +#define ADV748X_AFE_STD_NTSC_443			0x7
> +#define ADV748X_AFE_STD_PAL_BG				0x8
> +#define ADV748X_AFE_STD_PAL_N				0x9
> +#define ADV748X_AFE_STD_PAL_M				0xa
> +#define ADV748X_AFE_STD_PAL_M_PED			0xb
> +#define ADV748X_AFE_STD_PAL_COMB_N			0xc
> +#define ADV748X_AFE_STD_PAL_COMB_N_PED			0xd
> +#define ADV748X_AFE_STD_PAL_SECAM			0xe
> +#define ADV748X_AFE_STD_PAL_SECAM_PED			0xf
> +
> +static int adv748x_afe_read_ro_map(struct adv748x_state *state, u8 reg)
> +{
> +	int ret;
> +
> +	/* Select SDP Read-Only Main Map */
> +	ret = sdp_write(state, ADV748X_SDP_MAP_SEL,
> +			ADV748X_SDP_MAP_SEL_RO_MAIN);
> +	if (ret < 0)
> +		return ret;
> +
> +	return sdp_read(state, reg);
> +}
> +
> +static int adv748x_afe_status(struct adv748x_afe *afe, u32 *signal,
> +			      v4l2_std_id *std)
> +{
> +	struct adv748x_state *state = adv748x_afe_to_state(afe);
> +	int info;
> +
> +	/* Read status from reg 0x10 of SDP RO Map */
> +	info = adv748x_afe_read_ro_map(state, ADV748X_SDP_RO_10);
> +	if (info < 0)
> +		return info;
> +
> +	if (signal)
> +		*signal = info & ADV748X_SDP_RO_10_IN_LOCK ?
> +				0 : V4L2_IN_ST_NO_SIGNAL;
> +
> +	if (!std)
> +		return 0;
> +
> +	/* Standard not valid if there is no signal */
> +	if (info & BIT(0)) {
> +		*std = V4L2_STD_UNKNOWN;
> +		return 0;
> +	}
> +
> +	switch (info & 0x70) {
> +	case 0x00:
> +		*std = V4L2_STD_NTSC;
> +		break;
> +	case 0x10:
> +		*std = V4L2_STD_NTSC_443;
> +		break;
> +	case 0x20:
> +		*std = V4L2_STD_PAL_M;
> +		break;
> +	case 0x30:
> +		*std = V4L2_STD_PAL_60;
> +		break;
> +	case 0x40:
> +		*std = V4L2_STD_PAL;
> +		break;
> +	case 0x50:
> +		*std = V4L2_STD_SECAM;
> +		break;
> +	case 0x60:
> +		*std = V4L2_STD_PAL_Nc | V4L2_STD_PAL_N;
> +		break;
> +	case 0x70:
> +		*std = V4L2_STD_SECAM;
> +		break;
> +	default:
> +		*std = V4L2_STD_UNKNOWN;
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
> +static void adv748x_afe_fill_format(struct adv748x_afe *afe,
> +				    struct v4l2_mbus_framefmt *fmt)
> +{
> +	v4l2_std_id std;
> +
> +	memset(fmt, 0, sizeof(*fmt));
> +
> +	fmt->code = MEDIA_BUS_FMT_UYVY8_2X8;
> +	fmt->colorspace = V4L2_COLORSPACE_SMPTE170M;
> +	fmt->field = V4L2_FIELD_INTERLACED;
> +
> +	fmt->width = 720;
> +
> +	if (afe->curr_norm == V4L2_STD_ALL)
> +		adv748x_afe_status(afe, NULL,  &std);
> +	else
> +		std = afe->curr_norm;
> +
> +	fmt->height = std & V4L2_STD_525_60 ? 480 : 576;
> +}
> +
> +static int adv748x_afe_std(v4l2_std_id std)
> +{
> +	if (std == V4L2_STD_ALL)
> +		return ADV748X_AFE_STD_AD_PAL_BG_NTSC_J_SECAM;
> +	if (std == V4L2_STD_PAL_60)
> +		return ADV748X_AFE_STD_PAL60;
> +	if (std == V4L2_STD_NTSC_443)
> +		return ADV748X_AFE_STD_NTSC_443;
> +	if (std == V4L2_STD_PAL_N)
> +		return ADV748X_AFE_STD_PAL_N;
> +	if (std == V4L2_STD_PAL_M)
> +		return ADV748X_AFE_STD_PAL_M;
> +	if (std == V4L2_STD_PAL_Nc)
> +		return ADV748X_AFE_STD_PAL_COMB_N;
> +	if (std & V4L2_STD_PAL)
> +		return ADV748X_AFE_STD_PAL_BG;
> +	if (std & V4L2_STD_NTSC)
> +		return ADV748X_AFE_STD_NTSC_M;

This NTSC test should come before the PAL test. This is the order other drivers
do this as well. So a standard with a mix of NTSC and PAL bits will map to NTSC.

> +	if (std & V4L2_STD_SECAM)
> +		return ADV748X_AFE_STD_PAL_SECAM;
> +
> +	return -EINVAL;
> +}
> +
> +static int adv748x_afe_set_video_standard(struct adv748x_state *state,
> +					  v4l2_std_id std)
> +{
> +	int sdpstd;
> +
> +	sdpstd = adv748x_afe_std(std);
> +	if (sdpstd < 0)
> +		return sdpstd;
> +
> +	sdp_clrset(state, ADV748X_SDP_VID_SEL, ADV748X_SDP_VID_SEL_MASK,
> +		   (sdpstd & 0xf) << ADV748X_SDP_VID_SEL_SHIFT);
> +
> +	return 0;
> +}
> +
> +static int adv748x_afe_s_input(struct adv748x_afe *afe, unsigned int input)
> +{
> +	struct adv748x_state *state = adv748x_afe_to_state(afe);
> +
> +	return sdp_write(state, ADV748X_SDP_INSEL, input);
> +}
> +
> +static int adv748x_afe_g_pixelaspect(struct v4l2_subdev *sd,
> +				     struct v4l2_fract *aspect)
> +{
> +	struct adv748x_afe *afe = adv748x_sd_to_afe(sd);
> +	v4l2_std_id std;
> +
> +	if (afe->curr_norm == V4L2_STD_ALL)
> +		adv748x_afe_status(afe, NULL,  &std);
> +	else
> +		std = afe->curr_norm;
> +
> +	if (std & V4L2_STD_525_60) {
> +		aspect->numerator = 11;
> +		aspect->denominator = 10;
> +	} else {
> +		aspect->numerator = 54;
> +		aspect->denominator = 59;
> +	}
> +
> +	return 0;
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * v4l2_subdev_video_ops
> + */
> +
> +static int adv748x_afe_g_std(struct v4l2_subdev *sd, v4l2_std_id *norm)
> +{
> +	struct adv748x_afe *afe = adv748x_sd_to_afe(sd);
> +
> +	if (afe->curr_norm == V4L2_STD_ALL)
> +		adv748x_afe_status(afe, NULL,  norm);
> +	else
> +		*norm = afe->curr_norm;
> +
> +	return 0;
> +}
> +
> +static int adv748x_afe_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
> +{
> +	struct adv748x_afe *afe = adv748x_sd_to_afe(sd);
> +	struct adv748x_state *state = adv748x_afe_to_state(afe);
> +	int ret;
> +
> +	mutex_lock(&state->mutex);
> +
> +	ret = adv748x_afe_set_video_standard(state, std);
> +	if (ret ==  0)
> +		afe->curr_norm = std;

OK, so this is a bit of a problem: you are using V4L2_STD_ALL as an autodetect
mechanism, but that is not allowed by the V4L2 specification. Yes, some old
drivers do this and we don't dare to change that, but new drivers should not
attempt this. The standard set and reported by s_std and g_std must always
be precise, i.e. no mix of NTSC and PAL.

Only QUERYSTD is allowed to detect the format.

So

> +
> +	mutex_unlock(&state->mutex);
> +
> +	return ret;
> +}
> +
> +static int adv748x_afe_querystd(struct v4l2_subdev *sd, v4l2_std_id *std)
> +{
> +	struct adv748x_afe *afe = adv748x_sd_to_afe(sd);
> +	struct adv748x_state *state = adv748x_afe_to_state(afe);
> +	int ret;
> +
> +	mutex_lock(&state->mutex);
> +
> +	if (afe->streaming) {
> +		ret = -EBUSY;
> +		goto unlock;
> +	}
> +
> +	/* Set auto detect mode */
> +	ret = adv748x_afe_set_video_standard(state, V4L2_STD_ALL);
> +	if (ret)
> +		goto unlock;
> +
> +	msleep(100);
> +
> +	/* Read detected standard */
> +	ret = adv748x_afe_status(afe, NULL, std);
> +unlock:
> +	mutex_unlock(&state->mutex);
> +
> +	return ret;
> +}
> +
> +static int adv748x_afe_g_tvnorms(struct v4l2_subdev *sd, v4l2_std_id *norm)
> +{
> +	*norm = V4L2_STD_ALL;
> +
> +	return 0;
> +}
> +
> +static int adv748x_afe_g_input_status(struct v4l2_subdev *sd, u32 *status)
> +{
> +	struct adv748x_afe *afe = adv748x_sd_to_afe(sd);
> +	struct adv748x_state *state = adv748x_afe_to_state(afe);
> +	int ret;
> +
> +	mutex_lock(&state->mutex);
> +
> +	ret = adv748x_afe_status(afe, status, NULL);
> +
> +	mutex_unlock(&state->mutex);
> +	return ret;
> +}
> +
> +static int adv748x_afe_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +	struct adv748x_afe *afe = adv748x_sd_to_afe(sd);
> +	struct adv748x_state *state = adv748x_afe_to_state(afe);
> +	int ret, signal = V4L2_IN_ST_NO_SIGNAL;
> +
> +	mutex_lock(&state->mutex);
> +
> +	if (enable) {
> +		ret = adv748x_afe_s_input(afe, afe->input);
> +		if (ret)
> +			goto unlock;
> +	}
> +
> +	ret = adv748x_txb_power(state, enable);
> +	if (ret)
> +		goto unlock;
> +
> +	afe->streaming = enable;
> +
> +	adv748x_afe_status(afe, &signal, NULL);
> +	if (signal != V4L2_IN_ST_NO_SIGNAL)
> +		adv_dbg(state, "Detected SDP signal\n");
> +	else
> +		adv_dbg(state, "Couldn't detect SDP video signal\n");
> +
> +unlock:
> +	mutex_unlock(&state->mutex);
> +
> +	return ret;
> +}
> +
> +static const struct v4l2_subdev_video_ops adv748x_afe_video_ops = {
> +	.g_std = adv748x_afe_g_std,
> +	.s_std = adv748x_afe_s_std,
> +	.querystd = adv748x_afe_querystd,
> +	.g_tvnorms = adv748x_afe_g_tvnorms,
> +	.g_input_status = adv748x_afe_g_input_status,
> +	.s_stream = adv748x_afe_s_stream,
> +	.g_pixelaspect = adv748x_afe_g_pixelaspect,
> +};
> +
> +/* -----------------------------------------------------------------------------
> + * v4l2_subdev_pad_ops
> + */
> +
> +static int adv748x_afe_set_pixelrate(struct adv748x_afe *afe)
> +{
> +	struct v4l2_subdev *tx;
> +	unsigned int width, height, fps;
> +
> +	tx = adv748x_get_remote_sd(&afe->pads[ADV748X_AFE_SOURCE]);
> +	if (!tx)
> +		return -ENOLINK;
> +
> +	width = 720;
> +	height = afe->curr_norm & V4L2_STD_525_60 ? 480 : 576;
> +	fps = afe->curr_norm & V4L2_STD_525_60 ? 30 : 25;
> +
> +	return adv748x_csi2_set_pixelrate(tx, width * height * fps);
> +}
> +
> +static int adv748x_afe_enum_mbus_code(struct v4l2_subdev *sd,
> +				      struct v4l2_subdev_pad_config *cfg,
> +				      struct v4l2_subdev_mbus_code_enum *code)
> +{
> +	if (code->index != 0)
> +		return -EINVAL;
> +
> +	code->code = MEDIA_BUS_FMT_UYVY8_2X8;
> +
> +	return 0;
> +}
> +
> +static int adv748x_afe_get_format(struct v4l2_subdev *sd,
> +				      struct v4l2_subdev_pad_config *cfg,
> +				      struct v4l2_subdev_format *sdformat)
> +{
> +	struct adv748x_afe *afe = adv748x_sd_to_afe(sd);
> +	struct v4l2_mbus_framefmt *mbusformat;
> +
> +	/* The format of the analog sink pads is nonsensical */

You mean: /* It makes no sense to get the format of analog sink pads */

I misread your comment as meaning that the *format* made no sense.

> +	if (sdformat->pad != ADV748X_AFE_SOURCE)
> +		return -EINVAL;
> +
> +	if (sdformat->which == V4L2_SUBDEV_FORMAT_TRY) {
> +		mbusformat = v4l2_subdev_get_try_format(sd, cfg, sdformat->pad);
> +		sdformat->format = *mbusformat;
> +	} else {
> +		adv748x_afe_fill_format(afe, &sdformat->format);
> +		adv748x_afe_set_pixelrate(afe);
> +	}
> +
> +	return 0;
> +}
> +
> +static int adv748x_afe_set_format(struct v4l2_subdev *sd,
> +				      struct v4l2_subdev_pad_config *cfg,
> +				      struct v4l2_subdev_format *sdformat)
> +{
> +	struct v4l2_mbus_framefmt *mbusformat;
> +
> +	/* The format of the analog sink pads is nonsensical */

Ditto.

> +	if (sdformat->pad != ADV748X_AFE_SOURCE)
> +		return -EINVAL;
> +
> +	if (sdformat->which == V4L2_SUBDEV_FORMAT_ACTIVE)
> +		return adv748x_afe_get_format(sd, cfg, sdformat);
> +
> +	mbusformat = v4l2_subdev_get_try_format(sd, cfg, sdformat->pad);
> +	*mbusformat = sdformat->format;
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_subdev_pad_ops adv748x_afe_pad_ops = {
> +	.enum_mbus_code = adv748x_afe_enum_mbus_code,
> +	.set_fmt = adv748x_afe_set_format,
> +	.get_fmt = adv748x_afe_get_format,
> +};
> +
> +/* -----------------------------------------------------------------------------
> + * v4l2_subdev_ops
> + */
> +
> +static const struct v4l2_subdev_ops adv748x_afe_ops = {
> +	.video = &adv748x_afe_video_ops,
> +	.pad = &adv748x_afe_pad_ops,
> +};
> +
> +/* -----------------------------------------------------------------------------
> + * Controls
> + */
> +
> +static const char * const afe_ctrl_frp_menu[] = {
> +	"Disabled",
> +	"Default Value",

What does this mean? It is not very descriptive.

> +	"Color Bars",
> +	"Grey Ramp",
> +	"Cb Ramp",
> +	"Cr Ramp",
> +	"Boundary"
> +};
> +
> +static int adv748x_afe_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct adv748x_afe *afe = adv748x_ctrl_to_afe(ctrl);
> +	struct adv748x_state *state = adv748x_afe_to_state(afe);
> +	bool enable;
> +	int ret;
> +
> +	ret = sdp_write(state, 0x0e, 0x00);
> +	if (ret < 0)
> +		return ret;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_BRIGHTNESS:
> +		ret = sdp_write(state, ADV748X_SDP_BRI, ctrl->val);
> +		break;
> +	case V4L2_CID_HUE:
> +		/* Hue is inverted according to HSL chart */
> +		ret = sdp_write(state, ADV748X_SDP_HUE, -ctrl->val);
> +		break;
> +	case V4L2_CID_CONTRAST:
> +		ret = sdp_write(state, ADV748X_SDP_CON, ctrl->val);
> +		break;
> +	case V4L2_CID_SATURATION:
> +		ret = sdp_write(state, ADV748X_SDP_SD_SAT_U, ctrl->val);
> +		if (ret)
> +			break;
> +		ret = sdp_write(state, ADV748X_SDP_SD_SAT_V, ctrl->val);
> +		break;
> +	case V4L2_CID_TEST_PATTERN:
> +		enable = !!ctrl->val;
> +
> +		/* Enable/Disable Color bar test patterns */
> +		ret = sdp_clrset(state, ADV748X_SDP_DEF, ADV748X_SDP_DEF_VAL_EN,
> +				enable);
> +		if (ret)
> +			break;
> +		ret = sdp_clrset(state, ADV748X_SDP_FRP, ADV748X_SDP_FRP_MASK,
> +				enable ? ctrl->val - 1 : 0);
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +
> +static const struct v4l2_ctrl_ops adv748x_afe_ctrl_ops = {
> +	.s_ctrl = adv748x_afe_s_ctrl,
> +};
> +
> +static int adv748x_afe_init_controls(struct adv748x_afe *afe)
> +{
> +	struct adv748x_state *state = adv748x_afe_to_state(afe);
> +
> +	v4l2_ctrl_handler_init(&afe->ctrl_hdl, 5);
> +
> +	/* Use our mutex for the controls */
> +	afe->ctrl_hdl.lock = &state->mutex;
> +
> +	v4l2_ctrl_new_std(&afe->ctrl_hdl, &adv748x_afe_ctrl_ops,
> +			  V4L2_CID_BRIGHTNESS, ADV748X_SDP_BRI_MIN,
> +			  ADV748X_SDP_BRI_MAX, 1, ADV748X_SDP_BRI_DEF);
> +	v4l2_ctrl_new_std(&afe->ctrl_hdl, &adv748x_afe_ctrl_ops,
> +			  V4L2_CID_CONTRAST, ADV748X_SDP_CON_MIN,
> +			  ADV748X_SDP_CON_MAX, 1, ADV748X_SDP_CON_DEF);
> +	v4l2_ctrl_new_std(&afe->ctrl_hdl, &adv748x_afe_ctrl_ops,
> +			  V4L2_CID_SATURATION, ADV748X_SDP_SAT_MIN,
> +			  ADV748X_SDP_SAT_MAX, 1, ADV748X_SDP_SAT_DEF);
> +	v4l2_ctrl_new_std(&afe->ctrl_hdl, &adv748x_afe_ctrl_ops,
> +			  V4L2_CID_HUE, ADV748X_SDP_HUE_MIN,
> +			  ADV748X_SDP_HUE_MAX, 1, ADV748X_SDP_HUE_DEF);
> +
> +	v4l2_ctrl_new_std_menu_items(&afe->ctrl_hdl, &adv748x_afe_ctrl_ops,
> +				     V4L2_CID_TEST_PATTERN,
> +				     ARRAY_SIZE(afe_ctrl_frp_menu) - 1,
> +				     0, 0, afe_ctrl_frp_menu);
> +
> +	afe->sd.ctrl_handler = &afe->ctrl_hdl;
> +	if (afe->ctrl_hdl.error) {
> +		v4l2_ctrl_handler_free(&afe->ctrl_hdl);
> +		return afe->ctrl_hdl.error;
> +	}
> +
> +	return v4l2_ctrl_handler_setup(&afe->ctrl_hdl);
> +}
> +
> +int adv748x_afe_init(struct adv748x_afe *afe)
> +{
> +	struct adv748x_state *state = adv748x_afe_to_state(afe);
> +	int ret;
> +	unsigned int i;
> +
> +	afe->input = 0;
> +	afe->streaming = false;
> +	afe->curr_norm = V4L2_STD_ALL;

No. This must be a valid standard. Typically V4L2_STD_NTSC_M.

> +
> +	adv748x_subdev_init(&afe->sd, state, &adv748x_afe_ops,
> +			    MEDIA_ENT_F_ATV_DECODER, "afe");
> +
> +	/* Identify the first connector found as a default input if set */
> +	for (i = ADV748X_PORT_AIN0; i <= ADV748X_PORT_AIN7; i++) {
> +		/* Inputs and ports are 1-indexed to match the data sheet */
> +		if (state->endpoints[i]) {
> +			afe->input = i;
> +			break;
> +		}
> +	}
> +
> +	adv748x_afe_s_input(afe, afe->input);
> +
> +	adv_dbg(state, "AFE Default input set to %d\n", afe->input);
> +
> +	/* Entity pads and sinks are 0-indexed to match the pads */
> +	for (i = ADV748X_AFE_SINK_AIN0; i <= ADV748X_AFE_SINK_AIN7; i++)
> +		afe->pads[i].flags = MEDIA_PAD_FL_SINK;
> +
> +	afe->pads[ADV748X_AFE_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
> +
> +	ret = media_entity_pads_init(&afe->sd.entity, ADV748X_AFE_NR_PADS,
> +			afe->pads);
> +	if (ret)
> +		return ret;
> +
> +	ret = adv748x_afe_init_controls(afe);
> +	if (ret)
> +		goto error;
> +
> +	return 0;
> +
> +error:
> +	media_entity_cleanup(&afe->sd.entity);
> +
> +	return ret;
> +}
> +
> +void adv748x_afe_cleanup(struct adv748x_afe *afe)
> +{
> +	v4l2_device_unregister_subdev(&afe->sd);
> +	media_entity_cleanup(&afe->sd.entity);
> +	v4l2_ctrl_handler_free(&afe->ctrl_hdl);
> +}
> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
> new file mode 100644
> index 000000000000..6e395a4524ec
> --- /dev/null
> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> @@ -0,0 +1,907 @@
> +/*
> + * Driver for Analog Devices ADV748X HDMI receiver with AFE
> + *
> + * Copyright (C) 2017 Renesas Electronics Corp.
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + *
> + * Authors:
> + *	Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> + *	Niklas Söderlund <niklas.soderlund@ragnatech.se>
> + *	Kieran Bingham <kieran.bingham@ideasonboard.com>
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/errno.h>
> +#include <linux/i2c.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/of_graph.h>
> +#include <linux/regmap.h>
> +#include <linux/v4l2-dv-timings.h>
> +
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-dv-timings.h>
> +#include <media/v4l2-ioctl.h>
> +
> +#include "adv748x.h"
> +
> +/* -----------------------------------------------------------------------------
> + * Register manipulation
> + */
> +
> +static const struct regmap_config adv748x_regmap_cnf[] = {
> +	{
> +		.name			= "io",
> +		.reg_bits		= 8,
> +		.val_bits		= 8,
> +
> +		.max_register		= 0xff,
> +		.cache_type		= REGCACHE_NONE,
> +	},
> +	{
> +		.name			= "dpll",
> +		.reg_bits		= 8,
> +		.val_bits		= 8,
> +
> +		.max_register		= 0xff,
> +		.cache_type		= REGCACHE_NONE,
> +	},
> +	{
> +		.name			= "cp",
> +		.reg_bits		= 8,
> +		.val_bits		= 8,
> +
> +		.max_register		= 0xff,
> +		.cache_type		= REGCACHE_NONE,
> +	},
> +	{
> +		.name			= "hdmi",
> +		.reg_bits		= 8,
> +		.val_bits		= 8,
> +
> +		.max_register		= 0xff,
> +		.cache_type		= REGCACHE_NONE,
> +	},
> +	{
> +		.name			= "edid",
> +		.reg_bits		= 8,
> +		.val_bits		= 8,
> +
> +		.max_register		= 0xff,
> +		.cache_type		= REGCACHE_NONE,
> +	},
> +	{
> +		.name			= "repeater",
> +		.reg_bits		= 8,
> +		.val_bits		= 8,
> +
> +		.max_register		= 0xff,
> +		.cache_type		= REGCACHE_NONE,
> +	},
> +	{
> +		.name			= "infoframe",
> +		.reg_bits		= 8,
> +		.val_bits		= 8,
> +
> +		.max_register		= 0xff,
> +		.cache_type		= REGCACHE_NONE,
> +	},
> +	{
> +		.name			= "cec",
> +		.reg_bits		= 8,
> +		.val_bits		= 8,
> +
> +		.max_register		= 0xff,
> +		.cache_type		= REGCACHE_NONE,
> +	},
> +	{
> +		.name			= "sdp",
> +		.reg_bits		= 8,
> +		.val_bits		= 8,
> +
> +		.max_register		= 0xff,
> +		.cache_type		= REGCACHE_NONE,
> +	},
> +
> +	{
> +		.name			= "txb",
> +		.reg_bits		= 8,
> +		.val_bits		= 8,
> +
> +		.max_register		= 0xff,
> +		.cache_type		= REGCACHE_NONE,
> +	},
> +	{
> +		.name			= "txa",
> +		.reg_bits		= 8,
> +		.val_bits		= 8,
> +
> +		.max_register		= 0xff,
> +		.cache_type		= REGCACHE_NONE,
> +	},
> +};
> +
> +static int adv748x_configure_regmap(struct adv748x_state *state, int region)
> +{
> +	int err;
> +
> +	if (!state->i2c_clients[region])
> +		return -ENODEV;
> +
> +	state->regmap[region] =
> +		devm_regmap_init_i2c(state->i2c_clients[region],
> +				     &adv748x_regmap_cnf[region]);
> +
> +	if (IS_ERR(state->regmap[region])) {
> +		err = PTR_ERR(state->regmap[region]);
> +		adv_err(state,
> +			"Error initializing regmap %d with error %d\n",
> +			region, err);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +/* Default addresses for the I2C pages */
> +static int adv748x_i2c_addresses[ADV748X_PAGE_MAX] = {
> +	ADV748X_I2C_IO,
> +	ADV748X_I2C_DPLL,
> +	ADV748X_I2C_CP,
> +	ADV748X_I2C_HDMI,
> +	ADV748X_I2C_EDID,
> +	ADV748X_I2C_REPEATER,
> +	ADV748X_I2C_INFOFRAME,
> +	ADV748X_I2C_CEC,
> +	ADV748X_I2C_SDP,
> +	ADV748X_I2C_TXB,
> +	ADV748X_I2C_TXA,
> +};
> +
> +static int adv748x_read_check(struct adv748x_state *state,
> +			      int client_page, u8 reg)
> +{
> +	struct i2c_client *client = state->i2c_clients[client_page];
> +	int err;
> +	unsigned int val;
> +
> +	err = regmap_read(state->regmap[client_page], reg, &val);
> +
> +	if (err) {
> +		adv_err(state, "error reading %02x, %02x\n",
> +				client->addr, reg);
> +		return err;
> +	}
> +
> +	return val;
> +}
> +
> +int adv748x_read(struct adv748x_state *state, u8 page, u8 reg)
> +{
> +	return adv748x_read_check(state, page, reg);
> +}
> +
> +int adv748x_write(struct adv748x_state *state, u8 page, u8 reg, u8 value)
> +{
> +	return regmap_write(state->regmap[page], reg, value);
> +}
> +
> +/* adv748x_write_block(): Write raw data with a maximum of I2C_SMBUS_BLOCK_MAX
> + * size to one or more registers.
> + *
> + * A value of zero will be returned on success, a negative errno will
> + * be returned in error cases.
> + */
> +int adv748x_write_block(struct adv748x_state *state, int client_page,
> +			unsigned int init_reg, const void *val,
> +			size_t val_len)
> +{
> +	struct regmap *regmap = state->regmap[client_page];
> +
> +	if (val_len > I2C_SMBUS_BLOCK_MAX)
> +		val_len = I2C_SMBUS_BLOCK_MAX;
> +
> +	return regmap_raw_write(regmap, init_reg, val, val_len);
> +}
> +
> +
> +static struct i2c_client *adv748x_dummy_client(struct adv748x_state *state,
> +					       u8 addr, u8 io_reg)
> +{
> +	struct i2c_client *client = state->client;
> +
> +	if (addr)
> +		io_write(state, io_reg, addr << 1);
> +
> +	return i2c_new_dummy(client->adapter, io_read(state, io_reg) >> 1);
> +}
> +
> +static void adv748x_unregister_clients(struct adv748x_state *state)
> +{
> +	unsigned int i;
> +
> +	for (i = 1; i < ARRAY_SIZE(state->i2c_clients); ++i) {
> +		if (state->i2c_clients[i])
> +			i2c_unregister_device(state->i2c_clients[i]);
> +	}
> +}
> +
> +static int adv748x_initialise_clients(struct adv748x_state *state)
> +{
> +	int i;
> +	int ret;
> +
> +	for (i = ADV748X_PAGE_DPLL; i < ADV748X_PAGE_MAX; ++i) {
> +		state->i2c_clients[i] =
> +			adv748x_dummy_client(state, adv748x_i2c_addresses[i],
> +					     ADV748X_IO_SLAVE_ADDR_BASE + i);
> +		if (state->i2c_clients[i] == NULL) {
> +			adv_err(state, "failed to create i2c client %u\n", i);
> +			return -ENOMEM;
> +		}
> +
> +		ret = adv748x_configure_regmap(state, i);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * struct adv748x_reg_value - Register write instruction
> + * @page:		Regmap page identifier
> + * @reg:		I2C register
> + * @value:		value to write to @page at @reg
> + */
> +struct adv748x_reg_value {
> +	u8 page;
> +	u8 reg;
> +	u8 value;
> +};
> +
> +static int adv748x_write_regs(struct adv748x_state *state,
> +			      const struct adv748x_reg_value *regs)
> +{
> +	int ret;
> +
> +	while (regs->page != ADV748X_PAGE_EOR) {
> +		if (regs->page == ADV748X_PAGE_WAIT) {
> +			msleep(regs->value);
> +		} else {
> +			ret = adv748x_write(state, regs->page, regs->reg,
> +				      regs->value);
> +			if (ret < 0) {
> +				adv_err(state,
> +					"Error regs page: 0x%02x reg: 0x%02x\n",
> +					regs->page, regs->reg);
> +				return ret;
> +			}
> +		}
> +		regs++;
> +	}
> +
> +	return 0;
> +}
> +
> +
> +/* -----------------------------------------------------------------------------
> + * TXA and TXB
> + */
> +
> +static const struct adv748x_reg_value adv748x_power_up_txa_4lane[] = {
> +
> +	{ADV748X_PAGE_TXA, 0x00, 0x84},	/* Enable 4-lane MIPI */
> +	{ADV748X_PAGE_TXA, 0x00, 0xa4},	/* Set Auto DPHY Timing */
> +
> +	{ADV748X_PAGE_TXA, 0x31, 0x82},	/* ADI Required Write */
> +	{ADV748X_PAGE_TXA, 0x1e, 0x40},	/* ADI Required Write */
> +	{ADV748X_PAGE_TXA, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> +	{ADV748X_PAGE_WAIT, 0x00, 0x02},/* delay 2 */
> +	{ADV748X_PAGE_TXA, 0x00, 0x24 },/* Power-up CSI-TX */
> +	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
> +	{ADV748X_PAGE_TXA, 0xc1, 0x2b},	/* ADI Required Write */
> +	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
> +	{ADV748X_PAGE_TXA, 0x31, 0x80},	/* ADI Required Write */
> +
> +	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
> +};
> +
> +static const struct adv748x_reg_value adv748x_power_down_txa_4lane[] = {
> +
> +	{ADV748X_PAGE_TXA, 0x31, 0x82},	/* ADI Required Write */
> +	{ADV748X_PAGE_TXA, 0x1e, 0x00},	/* ADI Required Write */
> +	{ADV748X_PAGE_TXA, 0x00, 0x84},	/* Enable 4-lane MIPI */
> +	{ADV748X_PAGE_TXA, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> +	{ADV748X_PAGE_TXA, 0xc1, 0x3b},	/* ADI Required Write */
> +
> +	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
> +};
> +
> +static const struct adv748x_reg_value adv748x_power_up_txb_1lane[] = {
> +
> +	{ADV748X_PAGE_TXB, 0x00, 0x81},	/* Enable 1-lane MIPI */
> +	{ADV748X_PAGE_TXB, 0x00, 0xa1},	/* Set Auto DPHY Timing */
> +
> +	{ADV748X_PAGE_TXB, 0x31, 0x82},	/* ADI Required Write */
> +	{ADV748X_PAGE_TXB, 0x1e, 0x40},	/* ADI Required Write */
> +	{ADV748X_PAGE_TXB, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> +	{ADV748X_PAGE_WAIT, 0x00, 0x02},/* delay 2 */
> +	{ADV748X_PAGE_TXB, 0x00, 0x21 },/* Power-up CSI-TX */
> +	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
> +	{ADV748X_PAGE_TXB, 0xc1, 0x2b},	/* ADI Required Write */
> +	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
> +	{ADV748X_PAGE_TXB, 0x31, 0x80},	/* ADI Required Write */
> +
> +	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
> +};
> +
> +static const struct adv748x_reg_value adv748x_power_down_txb_1lane[] = {
> +
> +	{ADV748X_PAGE_TXB, 0x31, 0x82},	/* ADI Required Write */
> +	{ADV748X_PAGE_TXB, 0x1e, 0x00},	/* ADI Required Write */
> +	{ADV748X_PAGE_TXB, 0x00, 0x81},	/* Enable 4-lane MIPI */
> +	{ADV748X_PAGE_TXB, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> +	{ADV748X_PAGE_TXB, 0xc1, 0x3b},	/* ADI Required Write */
> +
> +	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
> +};
> +
> +int adv748x_txa_power(struct adv748x_state *state, bool on)
> +{
> +	int val;
> +
> +	val = txa_read(state, ADV748X_CSI_FS_AS_LS);
> +	if (val < 0)
> +		return val;
> +
> +	/*
> +	 * This test against BIT(6) is not documented by the datasheet, but was
> +	 * specified in the downstream driver.
> +	 * Track with a WARN_ONCE to determine if it is ever set by HW.
> +	 */
> +	WARN_ONCE((on && val & ADV748X_CSI_FS_AS_LS_UNKNOWN),
> +			"Enabling with unknown bit set");
> +
> +	if (on)
> +		return adv748x_write_regs(state, adv748x_power_up_txa_4lane);
> +	else

'else' isn't needed.

> +		return adv748x_write_regs(state, adv748x_power_down_txa_4lane);
> +}
> +
> +int adv748x_txb_power(struct adv748x_state *state, bool on)
> +{
> +	int val;
> +
> +	val = txb_read(state, ADV748X_CSI_FS_AS_LS);
> +	if (val < 0)
> +		return val;
> +
> +	/*
> +	 * This test against BIT(6) is not documented by the datasheet, but was
> +	 * specified in the downstream driver.
> +	 * Track with a WARN_ONCE to determine if it is ever set by HW.
> +	 */
> +	WARN_ONCE((on && val & ADV748X_CSI_FS_AS_LS_UNKNOWN),
> +			"Enabling with unknown bit set");
> +
> +	if (on)
> +		return adv748x_write_regs(state, adv748x_power_up_txb_1lane);
> +	else

Ditto.

> +		return adv748x_write_regs(state, adv748x_power_down_txb_1lane);
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * Media Operations
> + */
> +
> +static const struct media_entity_operations adv748x_media_ops = {
> +	.link_validate = v4l2_subdev_link_validate,
> +};
> +
> +/* -----------------------------------------------------------------------------
> + * HW setup
> + */
> +
> +static const struct adv748x_reg_value adv748x_sw_reset[] = {
> +
> +	{ADV748X_PAGE_IO, 0xff, 0xff},	/* SW reset */
> +	{ADV748X_PAGE_WAIT, 0x00, 0x05},/* delay 5 */
> +	{ADV748X_PAGE_IO, 0x01, 0x76},	/* ADI Required Write */
> +	{ADV748X_PAGE_IO, 0xf2, 0x01},	/* Enable I2C Read Auto-Increment */
> +	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
> +};
> +
> +static const struct adv748x_reg_value adv748x_set_slave_address[] = {
> +	{ADV748X_PAGE_IO, 0xf3, ADV748X_I2C_DPLL << 1},
> +	{ADV748X_PAGE_IO, 0xf4, ADV748X_I2C_CP << 1},
> +	{ADV748X_PAGE_IO, 0xf5, ADV748X_I2C_HDMI << 1},
> +	{ADV748X_PAGE_IO, 0xf6, ADV748X_I2C_EDID << 1},
> +	{ADV748X_PAGE_IO, 0xf7, ADV748X_I2C_REPEATER << 1},
> +	{ADV748X_PAGE_IO, 0xf8, ADV748X_I2C_INFOFRAME << 1},
> +	{ADV748X_PAGE_IO, 0xfa, ADV748X_I2C_CEC << 1},
> +	{ADV748X_PAGE_IO, 0xfb, ADV748X_I2C_SDP << 1},
> +	{ADV748X_PAGE_IO, 0xfc, ADV748X_I2C_TXB << 1},
> +	{ADV748X_PAGE_IO, 0xfd, ADV748X_I2C_TXA << 1},
> +	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
> +};
> +
> +/* Supported Formats For Script Below */
> +/* - 01-29 HDMI to MIPI TxA CSI 4-Lane - RGB888: */
> +static const struct adv748x_reg_value adv748x_init_txa_4lane[] = {
> +	/* Disable chip powerdown & Enable HDMI Rx block */
> +	{ADV748X_PAGE_IO, 0x00, 0x40},
> +
> +	{ADV748X_PAGE_REPEATER, 0x40, 0x83}, /* Enable HDCP 1.1 */
> +
> +	{ADV748X_PAGE_HDMI, 0x00, 0x08},/* Foreground Channel = A */
> +	{ADV748X_PAGE_HDMI, 0x98, 0xff},/* ADI Required Write */
> +	{ADV748X_PAGE_HDMI, 0x99, 0xa3},/* ADI Required Write */
> +	{ADV748X_PAGE_HDMI, 0x9a, 0x00},/* ADI Required Write */
> +	{ADV748X_PAGE_HDMI, 0x9b, 0x0a},/* ADI Required Write */
> +	{ADV748X_PAGE_HDMI, 0x9d, 0x40},/* ADI Required Write */
> +	{ADV748X_PAGE_HDMI, 0xcb, 0x09},/* ADI Required Write */
> +	{ADV748X_PAGE_HDMI, 0x3d, 0x10},/* ADI Required Write */
> +	{ADV748X_PAGE_HDMI, 0x3e, 0x7b},/* ADI Required Write */
> +	{ADV748X_PAGE_HDMI, 0x3f, 0x5e},/* ADI Required Write */
> +	{ADV748X_PAGE_HDMI, 0x4e, 0xfe},/* ADI Required Write */
> +	{ADV748X_PAGE_HDMI, 0x4f, 0x18},/* ADI Required Write */
> +	{ADV748X_PAGE_HDMI, 0x57, 0xa3},/* ADI Required Write */
> +	{ADV748X_PAGE_HDMI, 0x58, 0x04},/* ADI Required Write */
> +	{ADV748X_PAGE_HDMI, 0x85, 0x10},/* ADI Required Write */
> +
> +	{ADV748X_PAGE_HDMI, 0x83, 0x00},/* Enable All Terminations */
> +	{ADV748X_PAGE_HDMI, 0xa3, 0x01},/* ADI Required Write */
> +	{ADV748X_PAGE_HDMI, 0xbe, 0x00},/* ADI Required Write */
> +
> +	{ADV748X_PAGE_HDMI, 0x6c, 0x01},/* HPA Manual Enable */
> +	{ADV748X_PAGE_HDMI, 0xf8, 0x01},/* HPA Asserted */
> +	{ADV748X_PAGE_HDMI, 0x0f, 0x00},/* Audio Mute Speed Set to Fastest */
> +	/* (Smallest Step Size) */
> +
> +	{ADV748X_PAGE_IO, 0x04, 0x02},	/* RGB Out of CP */
> +	{ADV748X_PAGE_IO, 0x12, 0xf0},	/* CSC Depends on ip Packets, SDR 444 */
> +	{ADV748X_PAGE_IO, 0x17, 0x80},	/* Luma & Chroma can reach 254d */
> +	{ADV748X_PAGE_IO, 0x03, 0x86},	/* CP-Insert_AV_Code */
> +
> +	{ADV748X_PAGE_CP, 0x7c, 0x00},	/* ADI Required Write */
> +
> +	{ADV748X_PAGE_IO, 0x0c, 0xe0},	/* Enable LLC_DLL & Double LLC Timing */
> +	{ADV748X_PAGE_IO, 0x0e, 0xdd},	/* LLC/PIX/SPI PINS TRISTATED AUD */
> +	/* Outputs Enabled */
> +	{ADV748X_PAGE_IO, 0x10, 0xa0},	/* Enable 4-lane CSI Tx & Pixel Port */
> +
> +	{ADV748X_PAGE_TXA, 0x00, 0x84},	/* Enable 4-lane MIPI */
> +	{ADV748X_PAGE_TXA, 0x00, 0xa4},	/* Set Auto DPHY Timing */
> +	{ADV748X_PAGE_TXA, 0xdb, 0x10},	/* ADI Required Write */
> +	{ADV748X_PAGE_TXA, 0xd6, 0x07},	/* ADI Required Write */
> +	{ADV748X_PAGE_TXA, 0xc4, 0x0a},	/* ADI Required Write */
> +	{ADV748X_PAGE_TXA, 0x71, 0x33},	/* ADI Required Write */
> +	{ADV748X_PAGE_TXA, 0x72, 0x11},	/* ADI Required Write */
> +	{ADV748X_PAGE_TXA, 0xf0, 0x00},	/* i2c_dphy_pwdn - 1'b0 */
> +
> +	{ADV748X_PAGE_TXA, 0x31, 0x82},	/* ADI Required Write */
> +	{ADV748X_PAGE_TXA, 0x1e, 0x40},	/* ADI Required Write */
> +	{ADV748X_PAGE_TXA, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> +	{ADV748X_PAGE_WAIT, 0x00, 0x02},/* delay 2 */
> +	{ADV748X_PAGE_TXA, 0x00, 0x24 },/* Power-up CSI-TX */
> +	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
> +	{ADV748X_PAGE_TXA, 0xc1, 0x2b},	/* ADI Required Write */
> +	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
> +	{ADV748X_PAGE_TXA, 0x31, 0x80},	/* ADI Required Write */
> +
> +	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
> +};
> +
> +/* 02-01 Analog CVBS to MIPI TX-B CSI 1-Lane - */
> +/* Autodetect CVBS Single Ended In Ain 1 - MIPI Out */
> +static const struct adv748x_reg_value adv748x_init_txb_1lane[] = {
> +
> +	{ADV748X_PAGE_IO, 0x00, 0x30},	/* Disable chip powerdown Rx */
> +	{ADV748X_PAGE_IO, 0xf2, 0x01},	/* Enable I2C Read Auto-Increment */
> +
> +	{ADV748X_PAGE_IO, 0x0e, 0xff},	/* LLC/PIX/AUD/SPI PINS TRISTATED */
> +
> +	{ADV748X_PAGE_SDP, 0x0f, 0x00},	/* Exit Power Down Mode */
> +	{ADV748X_PAGE_SDP, 0x52, 0xcd},	/* ADI Required Write */
> +
> +	{ADV748X_PAGE_SDP, 0x0e, 0x80},	/* ADI Required Write */
> +	{ADV748X_PAGE_SDP, 0x9c, 0x00},	/* ADI Required Write */
> +	{ADV748X_PAGE_SDP, 0x9c, 0xff},	/* ADI Required Write */
> +	{ADV748X_PAGE_SDP, 0x0e, 0x00},	/* ADI Required Write */
> +
> +	/* ADI recommended writes for improved video quality */
> +	{ADV748X_PAGE_SDP, 0x80, 0x51},	/* ADI Required Write */
> +	{ADV748X_PAGE_SDP, 0x81, 0x51},	/* ADI Required Write */
> +	{ADV748X_PAGE_SDP, 0x82, 0x68},	/* ADI Required Write */
> +
> +	{ADV748X_PAGE_SDP, 0x03, 0x42},	/* Tri-S Output , PwrDwn 656 pads */
> +	{ADV748X_PAGE_SDP, 0x04, 0xb5},	/* ITU-R BT.656-4 compatible */
> +	{ADV748X_PAGE_SDP, 0x13, 0x00},	/* ADI Required Write */
> +
> +	{ADV748X_PAGE_SDP, 0x17, 0x41},	/* Select SH1 */
> +	{ADV748X_PAGE_SDP, 0x31, 0x12},	/* ADI Required Write */
> +	{ADV748X_PAGE_SDP, 0xe6, 0x4f},  /* V bit end pos manually in NTSC */
> +
> +	/* Enable 1-Lane MIPI Tx, */
> +	/* enable pixel output and route SD through Pixel port */
> +	{ADV748X_PAGE_IO, 0x10, 0x70},
> +
> +	{ADV748X_PAGE_TXB, 0x00, 0x81},	/* Enable 1-lane MIPI */
> +	{ADV748X_PAGE_TXB, 0x00, 0xa1},	/* Set Auto DPHY Timing */
> +	{ADV748X_PAGE_TXB, 0xd2, 0x40},	/* ADI Required Write */
> +	{ADV748X_PAGE_TXB, 0xc4, 0x0a},	/* ADI Required Write */
> +	{ADV748X_PAGE_TXB, 0x71, 0x33},	/* ADI Required Write */
> +	{ADV748X_PAGE_TXB, 0x72, 0x11},	/* ADI Required Write */
> +	{ADV748X_PAGE_TXB, 0xf0, 0x00},	/* i2c_dphy_pwdn - 1'b0 */
> +	{ADV748X_PAGE_TXB, 0x31, 0x82},	/* ADI Required Write */
> +	{ADV748X_PAGE_TXB, 0x1e, 0x40},	/* ADI Required Write */
> +	{ADV748X_PAGE_TXB, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> +
> +	{ADV748X_PAGE_WAIT, 0x00, 0x02},/* delay 2 */
> +	{ADV748X_PAGE_TXB, 0x00, 0x21 },/* Power-up CSI-TX */
> +	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
> +	{ADV748X_PAGE_TXB, 0xc1, 0x2b},	/* ADI Required Write */
> +	{ADV748X_PAGE_WAIT, 0x00, 0x01},/* delay 1 */
> +	{ADV748X_PAGE_TXB, 0x31, 0x80},	/* ADI Required Write */
> +
> +	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
> +};
> +
> +static int adv748x_reset(struct adv748x_state *state)
> +{
> +	int ret;
> +
> +	ret = adv748x_write_regs(state, adv748x_sw_reset);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = adv748x_write_regs(state, adv748x_set_slave_address);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* Init and power down TXA */
> +	ret = adv748x_write_regs(state, adv748x_init_txa_4lane);
> +	if (ret)
> +		return ret;
> +
> +	adv748x_txa_power(state, 0);
> +
> +	/* Init and power down TXB */
> +	ret = adv748x_write_regs(state, adv748x_init_txb_1lane);
> +	if (ret)
> +		return ret;
> +
> +	adv748x_txb_power(state, 0);
> +
> +	/* Disable chip powerdown & Enable HDMI Rx block */
> +	io_write(state, ADV748X_IO_PD, ADV748X_IO_PD_RX_EN);
> +
> +	/* Enable 4-lane CSI Tx & Pixel Port */
> +	io_write(state, ADV748X_IO_10, ADV748X_IO_10_CSI4_EN |
> +				       ADV748X_IO_10_CSI1_EN |
> +				       ADV748X_IO_10_PIX_OUT_EN);
> +
> +	/* Use vid_std and v_freq as freerun resolution for CP */
> +	cp_clrset(state, ADV748X_CP_CLMP_POS, ADV748X_CP_CLMP_POS_DIS_AUTO,
> +					      ADV748X_CP_CLMP_POS_DIS_AUTO);
> +
> +	return 0;
> +}
> +
> +static int adv748x_identify_chip(struct adv748x_state *state)
> +{
> +	int msb, lsb;
> +
> +	lsb = io_read(state, ADV748X_IO_CHIP_REV_ID_1);
> +	msb = io_read(state, ADV748X_IO_CHIP_REV_ID_2);
> +
> +	if (lsb < 0 || msb < 0) {
> +		adv_err(state, "Failed to read chip revision\n");
> +		return -EIO;
> +	}
> +
> +	adv_info(state, "chip found @ 0x%02x revision %02x%02x\n",
> +		 state->client->addr << 1, lsb, msb);
> +
> +	return 0;
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * i2c driver
> + */
> +
> +void adv748x_subdev_init(struct v4l2_subdev *sd, struct adv748x_state *state,
> +			 const struct v4l2_subdev_ops *ops, u32 function,
> +			 const char *ident)
> +{
> +	v4l2_subdev_init(sd, ops);
> +	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +
> +	/* the owner is the same as the i2c_client's driver owner */
> +	sd->owner = state->dev->driver->owner;
> +	sd->dev = state->dev;
> +
> +	v4l2_set_subdevdata(sd, state);
> +
> +	/* initialize name */
> +	snprintf(sd->name, sizeof(sd->name), "%s %d-%04x %s",
> +		state->dev->driver->name,
> +		i2c_adapter_id(state->client->adapter),
> +		state->client->addr, ident);
> +
> +	sd->entity.function = function;
> +	sd->entity.ops = &adv748x_media_ops;
> +}
> +
> +static int adv748x_parse_dt(struct adv748x_state *state)
> +{
> +	struct device_node *ep_np = NULL;
> +	struct of_endpoint ep;
> +	bool found = false;
> +
> +	for_each_endpoint_of_node(state->dev->of_node, ep_np) {
> +		of_graph_parse_endpoint(ep_np, &ep);
> +		adv_info(state, "Endpoint %s on port %d",
> +				of_node_full_name(ep.local_node),
> +				ep.port);
> +
> +		if (ep.port >= ADV748X_PORT_MAX) {
> +			adv_err(state, "Invalid endpoint %s on port %d",
> +				of_node_full_name(ep.local_node),
> +				ep.port);
> +
> +			continue;
> +		}
> +
> +		if (state->endpoints[ep.port]) {
> +			adv_err(state,
> +				"Multiple port endpoints are not supported");
> +			continue;
> +		}
> +
> +		of_node_get(ep_np);
> +		state->endpoints[ep.port] = ep_np;
> +
> +		found = true;
> +	}
> +
> +	return found ? 0 : -ENODEV;
> +}
> +
> +static void adv748x_dt_cleanup(struct adv748x_state *state)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < ADV748X_PORT_MAX; i++)
> +		of_node_put(state->endpoints[i]);
> +}
> +
> +static int adv748x_setup_links(struct adv748x_state *state)
> +{
> +	int ret;
> +	int enabled = MEDIA_LNK_FL_ENABLED;
> +
> +/*
> + * HACK/Workaround:
> + *
> + * Currently non-immutable link resets go through the RVin
> + * driver, and cause the links to fail, due to not being part of RVIN.
> + * As a temporary workaround until the RVIN driver knows better than to parse
> + * links that do not belong to it, use static immutable links for our internal
> + * media paths.
> + */
> +#define ADV748x_DEV_STATIC_LINKS
> +#ifdef ADV748x_DEV_STATIC_LINKS
> +	enabled |= MEDIA_LNK_FL_IMMUTABLE;
> +#endif

Has an RVIN patch fixing this been posted yet? If not, is anyone looking at that?
Perhaps this should use #ifdef CONFIG_VIDEO_RCAR_VIN instead of inventing a define?

> +
> +	/* TXA - Default link is with HDMI */
> +	ret = media_create_pad_link(&state->hdmi.sd.entity, 1,
> +				    &state->txa.sd.entity, 0, enabled);
> +	if (ret) {
> +		adv_err(state, "Failed to create HDMI-TXA pad link");
> +		return ret;
> +	}
> +
> +#ifndef ADV748x_DEV_STATIC_LINKS
> +	ret = media_create_pad_link(&state->afe.sd.entity, ADV748X_AFE_SOURCE,
> +				    &state->txa.sd.entity, 0, 0);
> +	if (ret) {
> +		adv_err(state, "Failed to create AFE-TXA pad link");
> +		return ret;
> +	}
> +#endif
> +
> +	/* TXB - Can only output from the AFE */
> +	ret = media_create_pad_link(&state->afe.sd.entity, ADV748X_AFE_SOURCE,
> +				    &state->txb.sd.entity, 0, enabled);
> +	if (ret) {
> +		adv_err(state, "Failed to create AFE-TXB pad link");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +int adv748x_register_subdevs(struct adv748x_state *state,
> +			     struct v4l2_device *v4l2_dev)
> +{
> +	int ret;
> +
> +	ret = v4l2_device_register_subdev(v4l2_dev, &state->hdmi.sd);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = v4l2_device_register_subdev(v4l2_dev, &state->afe.sd);
> +	if (ret < 0)
> +		goto err_unregister_hdmi;
> +
> +	ret = adv748x_setup_links(state);
> +	if (ret < 0)
> +		goto err_unregister_afe;
> +
> +	return 0;
> +
> +err_unregister_afe:
> +	v4l2_device_unregister_subdev(&state->afe.sd);
> +err_unregister_hdmi:
> +	v4l2_device_unregister_subdev(&state->hdmi.sd);
> +
> +	return ret;
> +}
> +
> +static int adv748x_probe(struct i2c_client *client,
> +			 const struct i2c_device_id *id)
> +{
> +	struct adv748x_state *state;
> +	int ret;
> +
> +	/* Check if the adapter supports the needed features */
> +	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
> +		return -EIO;
> +
> +	state = kzalloc(sizeof(struct adv748x_state), GFP_KERNEL);
> +	if (!state)
> +		return -ENOMEM;
> +
> +	mutex_init(&state->mutex);
> +
> +	state->dev = &client->dev;
> +	state->client = client;
> +	state->i2c_clients[ADV748X_PAGE_IO] = client;
> +	i2c_set_clientdata(client, state);
> +
> +	/* Discover and process ports declared by the Device tree endpoints */
> +	ret = adv748x_parse_dt(state);
> +	if (ret) {
> +		adv_err(state, "Failed to parse device tree");
> +		goto err_free_mutex;
> +	}
> +
> +	/* Configure IO Regmap region */
> +	ret = adv748x_configure_regmap(state, ADV748X_PAGE_IO);
> +	if (ret) {
> +		adv_err(state, "Error configuring IO regmap region");
> +		goto err_cleanup_dt;
> +	}
> +
> +	ret = adv748x_identify_chip(state);
> +	if (ret) {
> +		adv_err(state, "Failed to identify chip");
> +		goto err_cleanup_clients;
> +	}
> +
> +	/* Configure remaining pages as I2C clients with regmap access */
> +	ret = adv748x_initialise_clients(state);
> +	if (ret) {
> +		adv_err(state, "Failed to setup client regmap pages");
> +		goto err_cleanup_clients;
> +	}
> +
> +	/* SW reset ADV748X to its default values */
> +	ret = adv748x_reset(state);
> +	if (ret) {
> +		adv_err(state, "Failed to reset hardware");
> +		goto err_cleanup_clients;
> +	}
> +
> +	/* Initialise HDMI */
> +	ret = adv748x_hdmi_init(&state->hdmi);
> +	if (ret) {
> +		adv_err(state, "Failed to probe HDMI");
> +		goto err_cleanup_clients;
> +	}
> +
> +	/* Initialise AFE */
> +	ret = adv748x_afe_init(&state->afe);
> +	if (ret) {
> +		adv_err(state, "Failed to probe AFE");
> +		goto err_cleanup_hdmi;
> +	}
> +
> +	/* Initialise TXA */
> +	ret = adv748x_csi2_init(state, &state->txa);
> +	if (ret) {
> +		adv_err(state, "Failed to probe TXA");
> +		goto err_cleanup_afe;
> +	}
> +
> +	/* Initialise TXB */
> +	ret = adv748x_csi2_init(state, &state->txb);
> +	if (ret) {
> +		adv_err(state, "Failed to probe TXB");
> +		goto err_cleanup_txa;
> +	}
> +
> +	return 0;
> +
> +err_cleanup_txa:
> +	adv748x_csi2_cleanup(&state->txa);
> +err_cleanup_afe:
> +	adv748x_afe_cleanup(&state->afe);
> +err_cleanup_hdmi:
> +	adv748x_hdmi_cleanup(&state->hdmi);
> +err_cleanup_clients:
> +	adv748x_unregister_clients(state);
> +err_cleanup_dt:
> +	adv748x_dt_cleanup(state);
> +err_free_mutex:
> +	mutex_destroy(&state->mutex);
> +	kfree(state);
> +
> +	return ret;
> +}
> +
> +static int adv748x_remove(struct i2c_client *client)
> +{
> +	struct adv748x_state *state = i2c_get_clientdata(client);
> +
> +	adv748x_afe_cleanup(&state->afe);
> +	adv748x_hdmi_cleanup(&state->hdmi);
> +
> +	adv748x_csi2_cleanup(&state->txa);
> +	adv748x_csi2_cleanup(&state->txb);
> +
> +	adv748x_unregister_clients(state);
> +	adv748x_dt_cleanup(state);
> +	mutex_destroy(&state->mutex);
> +
> +	kfree(state);
> +
> +	return 0;
> +}
> +
> +static const struct i2c_device_id adv748x_id[] = {
> +	{ "adv7481", 0 },
> +	{ "adv7482", 0 },
> +	{ },
> +};
> +
> +static const struct of_device_id adv748x_of_table[] = {
> +	{ .compatible = "adi,adv7481", },
> +	{ .compatible = "adi,adv7482", },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, adv748x_of_table);
> +
> +static struct i2c_driver adv748x_driver = {
> +	.driver = {
> +		.name = "adv748x",
> +		.of_match_table = adv748x_of_table,
> +	},
> +	.probe = adv748x_probe,
> +	.remove = adv748x_remove,
> +	.id_table = adv748x_id,
> +};
> +
> +module_i2c_driver(adv748x_driver);
> +
> +MODULE_AUTHOR("Kieran Bingham <kieran.bingham@ideasonboard.com>");
> +MODULE_DESCRIPTION("ADV748X video decoder");
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
> new file mode 100644
> index 000000000000..a9b7fbd93530
> --- /dev/null
> +++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
> @@ -0,0 +1,323 @@
> +/*
> + * Driver for Analog Devices ADV748X CSI-2 Transmitter
> + *
> + * Copyright (C) 2017 Renesas Electronics Corp.
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-ioctl.h>
> +
> +#include "adv748x.h"
> +
> +static bool is_txa(struct adv748x_csi2 *tx)
> +{
> +	return tx == &tx->state->txa;
> +}
> +
> +static int adv748x_csi2_set_virtual_channel(struct adv748x_csi2 *tx,
> +					    unsigned int vc)
> +{
> +	return tx_write(tx, ADV748X_CSI_VC_REF, vc << ADV748X_CSI_VC_REF_SHIFT);
> +}
> +
> +/**
> + * adv748x_csi2_register_link : Register and link internal entities
> + *
> + * @tx: CSI2 private entity
> + * @v4l2_dev: Video registration device
> + * @src: Source subdevice to establish link
> + * @src_pad: Pad number of source to link to this @tx
> + * @preferred: Specify if this link is preferred over pre-existing links
> + *
> + * Ensure that the subdevice is registered against the v4l2_device, and link the
> + * source pad to the sink pad of the CSI2 bus entity.
> + */
> +static int adv748x_csi2_register_link(struct adv748x_csi2 *tx,
> +				      struct v4l2_device *v4l2_dev,
> +				      struct v4l2_subdev *src,
> +				      unsigned int src_pad,
> +				      bool preferred)
> +{
> +	int enabled = 0;
> +	int ret;
> +
> +	if (preferred)
> +		enabled = MEDIA_LNK_FL_ENABLED;
> +
> +	if (!src->v4l2_dev) {
> +		ret = v4l2_device_register_subdev(v4l2_dev, src);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return media_create_pad_link(&src->entity, src_pad,
> +				     &tx->sd.entity, ADV748X_CSI2_SINK,
> +				     enabled);
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * v4l2_subdev_internal_ops
> + *
> + * We use the internal registered operation to be able to ensure that our
> + * incremental subdevices (not connected in the forward path) can be registered
> + * against the resulting video path and media device.
> + */
> +
> +static int adv748x_csi2_registered(struct v4l2_subdev *sd)
> +{
> +	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
> +	struct adv748x_state *state = tx->state;
> +	int ret;
> +
> +	adv_dbg(state, "Registered %s (%s)", is_txa(tx) ? "TXA":"TXB",
> +			sd->name);
> +
> +	ret = adv748x_csi2_register_link(tx, sd->v4l2_dev, &state->afe.sd,
> +					 ADV748X_AFE_SOURCE, !is_txa(tx));
> +	if (ret)
> +		return ret;
> +
> +	/* TX-B only supports AFE */
> +	if (!is_txa(tx))
> +		return 0;
> +
> +	return adv748x_csi2_register_link(tx, sd->v4l2_dev, &state->hdmi.sd,
> +					  ADV748X_HDMI_SOURCE, true);
> +}
> +
> +static const struct v4l2_subdev_internal_ops adv748x_csi2_internal_ops = {
> +	.registered = adv748x_csi2_registered,
> +};
> +
> +/* -----------------------------------------------------------------------------
> + * v4l2_subdev_video_ops
> + */
> +
> +static int adv748x_csi2_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
> +	struct v4l2_subdev *src;
> +
> +	src = adv748x_get_remote_sd(&tx->pads[ADV748X_CSI2_SINK]);
> +	if (!src)
> +		return -EPIPE;
> +
> +	return v4l2_subdev_call(src, video, s_stream, enable);
> +}
> +
> +static const struct v4l2_subdev_video_ops adv748x_csi2_video_ops = {
> +	.s_stream = adv748x_csi2_s_stream,
> +};
> +
> +/* -----------------------------------------------------------------------------
> + * v4l2_subdev_pad_ops
> + *
> + * The CSI2 bus pads are ignorant to the data sizes or formats.
> + * But we must support setting the pad formats for format propagation.
> + */
> +
> +static struct v4l2_mbus_framefmt *
> +adv748x_csi2_get_pad_format(struct v4l2_subdev *sd,
> +			    struct v4l2_subdev_pad_config *cfg,
> +			    unsigned int pad, u32 which)
> +{
> +	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
> +
> +	if (which == V4L2_SUBDEV_FORMAT_TRY)
> +		return v4l2_subdev_get_try_format(sd, cfg, pad);
> +	else

'else' is not needed.

> +		return &tx->format;
> +}
> +
> +static int adv748x_csi2_get_format(struct v4l2_subdev *sd,
> +				   struct v4l2_subdev_pad_config *cfg,
> +				   struct v4l2_subdev_format *sdformat)
> +{
> +	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
> +	struct adv748x_state *state = tx->state;
> +	struct v4l2_mbus_framefmt *mbusformat;
> +
> +	mbusformat = adv748x_csi2_get_pad_format(sd, cfg, sdformat->pad,
> +						 sdformat->which);
> +	if (!mbusformat)
> +		return -EINVAL;
> +
> +	mutex_lock(&state->mutex);
> +
> +	sdformat->format = *mbusformat;
> +
> +	mutex_unlock(&state->mutex);
> +
> +	return 0;
> +}
> +
> +static int adv748x_csi2_set_format(struct v4l2_subdev *sd,
> +				   struct v4l2_subdev_pad_config *cfg,
> +				   struct v4l2_subdev_format *sdformat)
> +{
> +	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
> +	struct adv748x_state *state = tx->state;
> +	struct v4l2_mbus_framefmt *mbusformat;
> +	int ret = 0;
> +
> +	mbusformat = adv748x_csi2_get_pad_format(sd, cfg, sdformat->pad,
> +						 sdformat->which);
> +	if (!mbusformat)
> +		return -EINVAL;
> +
> +	mutex_lock(&state->mutex);
> +
> +	if (sdformat->pad == ADV748X_CSI2_SOURCE) {
> +		const struct v4l2_mbus_framefmt *sink_fmt;
> +
> +		sink_fmt = adv748x_csi2_get_pad_format(sd, cfg,
> +						       ADV748X_CSI2_SINK,
> +						       sdformat->which);
> +
> +		if (!sink_fmt) {
> +			ret = -EINVAL;
> +			goto unlock;
> +		}
> +
> +		sdformat->format = *sink_fmt;
> +	}
> +
> +	*mbusformat = sdformat->format;
> +
> +unlock:
> +	mutex_unlock(&state->mutex);
> +
> +	return ret;
> +}
> +
> +static const struct v4l2_subdev_pad_ops adv748x_csi2_pad_ops = {
> +	.get_fmt = adv748x_csi2_get_format,
> +	.set_fmt = adv748x_csi2_set_format,
> +};
> +
> +/* -----------------------------------------------------------------------------
> + * v4l2_subdev_ops
> + */
> +
> +static const struct v4l2_subdev_ops adv748x_csi2_ops = {
> +	.video = &adv748x_csi2_video_ops,
> +	.pad = &adv748x_csi2_pad_ops,
> +};
> +
> +/* -----------------------------------------------------------------------------
> + * Subdev module and controls
> + */
> +
> +int adv748x_csi2_set_pixelrate(struct v4l2_subdev *sd, s64 rate)
> +{
> +	struct v4l2_ctrl *ctrl;
> +
> +	ctrl = v4l2_ctrl_find(sd->ctrl_handler, V4L2_CID_PIXEL_RATE);
> +	if (!ctrl)
> +		return -EINVAL;
> +
> +	return v4l2_ctrl_s_ctrl_int64(ctrl, rate);
> +}
> +
> +static int adv748x_csi2_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	switch (ctrl->id) {
> +	case V4L2_CID_PIXEL_RATE:
> +		return 0;
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +static const struct v4l2_ctrl_ops adv748x_csi2_ctrl_ops = {
> +	.s_ctrl = adv748x_csi2_s_ctrl,
> +};
> +
> +static int adv748x_csi2_init_controls(struct adv748x_csi2 *tx)
> +{
> +	struct v4l2_ctrl *ctrl;
> +
> +	v4l2_ctrl_handler_init(&tx->ctrl_hdl, 1);
> +
> +	ctrl = v4l2_ctrl_new_std(&tx->ctrl_hdl, &adv748x_csi2_ctrl_ops,
> +				 V4L2_CID_PIXEL_RATE, 1, INT_MAX, 1, 1);
> +
> +	tx->sd.ctrl_handler = &tx->ctrl_hdl;
> +	if (tx->ctrl_hdl.error) {
> +		v4l2_ctrl_handler_free(&tx->ctrl_hdl);
> +		return tx->ctrl_hdl.error;
> +	}
> +
> +	return v4l2_ctrl_handler_setup(&tx->ctrl_hdl);
> +}
> +
> +int adv748x_csi2_init(struct adv748x_state *state, struct adv748x_csi2 *tx)
> +{
> +	struct device_node *ep;
> +	int ret;
> +
> +	/* We can not use container_of to get back to the state with two TXs */
> +	tx->state = state;
> +	tx->page = is_txa(tx) ? ADV748X_PAGE_TXA : ADV748X_PAGE_TXB;
> +
> +	ep = state->endpoints[is_txa(tx) ? ADV748X_PORT_TXA : ADV748X_PORT_TXB];
> +	if (!ep) {
> +		adv_err(state, "No endpoint found for %s\n",
> +				is_txa(tx) ? "txa" : "txb");
> +		return -ENODEV;
> +	}
> +
> +	/* Initialise the virtual channel */
> +	adv748x_csi2_set_virtual_channel(tx, 0);
> +
> +	adv748x_subdev_init(&tx->sd, state, &adv748x_csi2_ops,
> +			    MEDIA_ENT_F_UNKNOWN,
> +			    is_txa(tx) ? "txa" : "txb");
> +
> +	/* Ensure that matching is based upon the endpoint fwnodes */
> +	tx->sd.fwnode = of_fwnode_handle(ep);
> +
> +	/* Register internal ops for incremental subdev registration */
> +	tx->sd.internal_ops = &adv748x_csi2_internal_ops;
> +
> +	tx->pads[ADV748X_CSI2_SINK].flags = MEDIA_PAD_FL_SINK;
> +	tx->pads[ADV748X_CSI2_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
> +
> +	ret = media_entity_pads_init(&tx->sd.entity, ADV748X_CSI2_NR_PADS,
> +				     tx->pads);
> +	if (ret)
> +		return ret;
> +
> +	ret = adv748x_csi2_init_controls(tx);
> +	if (ret)
> +		goto err_free_media;
> +
> +	ret = v4l2_async_register_subdev(&tx->sd);
> +	if (ret)
> +		goto err_free_ctrl;
> +
> +	return 0;
> +
> +err_free_ctrl:
> +	v4l2_ctrl_handler_free(&tx->ctrl_hdl);
> +err_free_media:
> +	media_entity_cleanup(&tx->sd.entity);
> +
> +	return ret;
> +}
> +
> +void adv748x_csi2_cleanup(struct adv748x_csi2 *tx)
> +{
> +	v4l2_async_unregister_subdev(&tx->sd);
> +	media_entity_cleanup(&tx->sd.entity);
> +	v4l2_ctrl_handler_free(&tx->ctrl_hdl);
> +}
> diff --git a/drivers/media/i2c/adv748x/adv748x-hdmi.c b/drivers/media/i2c/adv748x/adv748x-hdmi.c
> new file mode 100644
> index 000000000000..8f02c851bbc0
> --- /dev/null
> +++ b/drivers/media/i2c/adv748x/adv748x-hdmi.c
> @@ -0,0 +1,652 @@
> +/*
> + * Driver for Analog Devices ADV748X HDMI receiver and Component Processor (CP)
> + *
> + * Copyright (C) 2017 Renesas Electronics Corp.
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-dv-timings.h>
> +#include <media/v4l2-ioctl.h>
> +
> +#include <uapi/linux/v4l2-dv-timings.h>
> +
> +#include "adv748x.h"
> +
> +/* -----------------------------------------------------------------------------
> + * HDMI and CP
> + */
> +
> +#define ADV748X_HDMI_MIN_WIDTH		640
> +#define ADV748X_HDMI_MAX_WIDTH		1920
> +#define ADV748X_HDMI_MIN_HEIGHT		480
> +#define ADV748X_HDMI_MAX_HEIGHT		1200
> +#define ADV748X_HDMI_MIN_PIXELCLOCK	0		/* unknown */

I wouldn't use 0 for the min pixelclock. Pick something like 13000000
instead (the lowest pixelclock rate for CEA timings, lowered by 0.5 MHz).

> +#define ADV748X_HDMI_MAX_PIXELCLOCK	162000000
> +
> +static const struct v4l2_dv_timings_cap adv748x_hdmi_timings_cap = {
> +	.type = V4L2_DV_BT_656_1120,
> +	/* keep this initialization for compatibility with GCC < 4.4.6 */
> +	.reserved = { 0 },
> +	/* Min pixelclock value is unknown */
> +	V4L2_INIT_BT_TIMINGS(ADV748X_HDMI_MIN_WIDTH, ADV748X_HDMI_MAX_WIDTH,
> +			     ADV748X_HDMI_MIN_HEIGHT, ADV748X_HDMI_MAX_HEIGHT,
> +			     ADV748X_HDMI_MIN_PIXELCLOCK,
> +			     ADV748X_HDMI_MAX_PIXELCLOCK,
> +			     V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT,
> +			     V4L2_DV_BT_CAP_INTERLACED |

Has interlaced been tested?

> +			     V4L2_DV_BT_CAP_PROGRESSIVE)
> +};
> +
> +struct adv748x_hdmi_video_standards {
> +	struct v4l2_dv_timings timings;
> +	u8 vid_std;
> +	u8 v_freq;
> +};
> +
> +static const struct adv748x_hdmi_video_standards
> +adv748x_hdmi_video_standards[] = {
> +	{ V4L2_DV_BT_CEA_720X480I59_94, 0x40, 0x00 },
> +	{ V4L2_DV_BT_CEA_720X576I50, 0x41, 0x01 },
> +	{ V4L2_DV_BT_CEA_720X480P59_94, 0x4a, 0x00 },
> +	{ V4L2_DV_BT_CEA_720X576P50, 0x4b, 0x00 },
> +	{ V4L2_DV_BT_CEA_1280X720P60, 0x53, 0x00 },
> +	{ V4L2_DV_BT_CEA_1280X720P50, 0x53, 0x01 },
> +	{ V4L2_DV_BT_CEA_1280X720P30, 0x53, 0x02 },
> +	{ V4L2_DV_BT_CEA_1280X720P25, 0x53, 0x03 },
> +	{ V4L2_DV_BT_CEA_1280X720P24, 0x53, 0x04 },
> +	{ V4L2_DV_BT_CEA_1920X1080I60, 0x54, 0x00 },
> +	{ V4L2_DV_BT_CEA_1920X1080I50, 0x54, 0x01 },
> +	{ V4L2_DV_BT_CEA_1920X1080P60, 0x5e, 0x00 },
> +	{ V4L2_DV_BT_CEA_1920X1080P50, 0x5e, 0x01 },
> +	{ V4L2_DV_BT_CEA_1920X1080P30, 0x5e, 0x02 },
> +	{ V4L2_DV_BT_CEA_1920X1080P25, 0x5e, 0x03 },
> +	{ V4L2_DV_BT_CEA_1920X1080P24, 0x5e, 0x04 },
> +	/* SVGA */
> +	{ V4L2_DV_BT_DMT_800X600P56, 0x80, 0x00 },
> +	{ V4L2_DV_BT_DMT_800X600P60, 0x81, 0x00 },
> +	{ V4L2_DV_BT_DMT_800X600P72, 0x82, 0x00 },
> +	{ V4L2_DV_BT_DMT_800X600P75, 0x83, 0x00 },
> +	{ V4L2_DV_BT_DMT_800X600P85, 0x84, 0x00 },
> +	/* SXGA */
> +	{ V4L2_DV_BT_DMT_1280X1024P60, 0x85, 0x00 },
> +	{ V4L2_DV_BT_DMT_1280X1024P75, 0x86, 0x00 },
> +	/* VGA */
> +	{ V4L2_DV_BT_DMT_640X480P60, 0x88, 0x00 },
> +	{ V4L2_DV_BT_DMT_640X480P72, 0x89, 0x00 },
> +	{ V4L2_DV_BT_DMT_640X480P75, 0x8a, 0x00 },
> +	{ V4L2_DV_BT_DMT_640X480P85, 0x8b, 0x00 },
> +	/* XGA */
> +	{ V4L2_DV_BT_DMT_1024X768P60, 0x8c, 0x00 },
> +	{ V4L2_DV_BT_DMT_1024X768P70, 0x8d, 0x00 },
> +	{ V4L2_DV_BT_DMT_1024X768P75, 0x8e, 0x00 },
> +	{ V4L2_DV_BT_DMT_1024X768P85, 0x8f, 0x00 },
> +	/* UXGA */
> +	{ V4L2_DV_BT_DMT_1600X1200P60, 0x96, 0x00 },
> +};
> +
> +static void adv748x_hdmi_fill_format(struct adv748x_hdmi *hdmi,
> +				     struct v4l2_mbus_framefmt *fmt)
> +{
> +	memset(fmt, 0, sizeof(*fmt));
> +
> +	fmt->code = MEDIA_BUS_FMT_RGB888_1X24;
> +	fmt->colorspace = V4L2_COLORSPACE_SRGB;

It's OK for now, but the colorspace depends on the AVI InfoFrame contents.
Add some comment stating this.

> +	fmt->field = hdmi->timings.bt.interlaced ?
> +		V4L2_FIELD_INTERLACED : V4L2_FIELD_NONE;
> +
> +	fmt->width = hdmi->timings.bt.width;
> +	fmt->height = hdmi->timings.bt.height;
> +}
> +
> +static void adv748x_fill_optional_dv_timings(struct v4l2_dv_timings *timings)
> +{
> +	v4l2_find_dv_timings_cap(timings, &adv748x_hdmi_timings_cap,
> +				 250000, NULL, NULL);
> +}
> +
> +static bool adv748x_hdmi_has_signal(struct adv748x_state *state)
> +{
> +	int val;
> +
> +	/* Check that VERT_FILTER and DE_REGEN is locked */
> +	val = hdmi_read(state, ADV748X_HDMI_LW1);
> +	return (val & ADV748X_HDMI_LW1_VERT_FILTER) &&
> +	       (val & ADV748X_HDMI_LW1_DE_REGEN);
> +}
> +
> +static int adv748x_hdmi_read_pixelclock(struct adv748x_state *state)
> +{
> +	int a, b;
> +
> +	a = hdmi_read(state, ADV748X_HDMI_TMDS_1);
> +	b = hdmi_read(state, ADV748X_HDMI_TMDS_2);
> +	if (a < 0 || b < 0)
> +		return -ENODATA;
> +
> +	/*
> +	 * The High 9 bits store TMDS frequency measurement in MHz
> +	 * The low 7 bits of TMDS_2 store the 7-bit TMDS fractional frequency
> +	 * measurement in 1/128 MHz
> +	 */
> +	return ((a << 1) | (b >> 7)) * 1000000 + (b & 0x7f) * 1000000 / 128;
> +}
> +
> +/*
> + * adv748x_hdmi_set_de_timings: Adjust horizontal picture offset through DE
> + *
> + * HDMI CP uses a Data Enable synchronisation timing reference
> + *
> + * Vary the leading and trailing edge position of the DE signal output by the CP
> + * core. Values are stored as signed-twos-complement in one-pixel-clock units
> + *
> + * The start and end are shifted equally by the 10-bit shift value.
> + */
> +static void adv748x_hdmi_set_de_timings(struct adv748x_state *state, int shift)
> +{
> +	u8 high, low;
> +
> +	/* POS_HIGH stores bits 8 and 9 of both the start and end */
> +	high = ADV748X_CP_DE_POS_HIGH_SET;
> +	high |= (shift & 0x300) >> 8;
> +	low = shift & 0xff;
> +
> +	/* The sequence of the writes is important and must be followed */
> +	cp_write(state, ADV748X_CP_DE_POS_HIGH, high);
> +	cp_write(state, ADV748X_CP_DE_POS_END_LOW, low);
> +
> +	high |= (shift & 0x300) >> 6;
> +
> +	cp_write(state, ADV748X_CP_DE_POS_HIGH, high);
> +	cp_write(state, ADV748X_CP_DE_POS_START_LOW, low);
> +}
> +
> +static int adv748x_hdmi_set_video_timings(struct adv748x_state *state,
> +					  const struct v4l2_dv_timings *timings)
> +{
> +	const struct adv748x_hdmi_video_standards *stds =
> +		adv748x_hdmi_video_standards;
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(adv748x_hdmi_video_standards); i++) {
> +		if (!v4l2_match_dv_timings(timings, &stds[i].timings, 250000,
> +					   false))
> +			continue;
> +	}
> +
> +	if (i >= ARRAY_SIZE(adv748x_hdmi_video_standards))
> +		return -EINVAL;
> +
> +	/*
> +	 * When setting cp_vid_std to either 720p, 1080i, or 1080p, the video
> +	 * will get shifted horizontally to the left in active video mode.
> +	 * The de_h_start and de_h_end controls are used to centre the picture
> +	 * correctly
> +	 */
> +	switch (stds[i].vid_std) {
> +	case 0x53: /* 720p */
> +		adv748x_hdmi_set_de_timings(state, -40);
> +		break;
> +	case 0x54: /* 1080i */
> +	case 0x5e: /* 1080p */
> +		adv748x_hdmi_set_de_timings(state, -44);
> +		break;
> +	default:
> +		adv748x_hdmi_set_de_timings(state, 0);
> +		break;
> +	}
> +
> +	io_write(state, ADV748X_IO_VID_STD, stds[i].vid_std);
> +	io_clrset(state, ADV748X_IO_DATAPATH, ADV748X_IO_DATAPATH_VFREQ_M,
> +		  stds[i].v_freq << ADV748X_IO_DATAPATH_VFREQ_SHIFT);
> +
> +	return 0;
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * v4l2_subdev_video_ops
> + */
> +
> +static int adv748x_hdmi_s_dv_timings(struct v4l2_subdev *sd,
> +				     struct v4l2_dv_timings *timings)
> +{
> +	struct adv748x_hdmi *hdmi = adv748x_sd_to_hdmi(sd);
> +	struct adv748x_state *state = adv748x_hdmi_to_state(hdmi);
> +	int ret;
> +
> +	if (!timings)
> +		return -EINVAL;
> +
> +	if (v4l2_match_dv_timings(&hdmi->timings, timings, 0, false))
> +		return 0;
> +
> +	if (!v4l2_valid_dv_timings(timings, &adv748x_hdmi_timings_cap,
> +				   NULL, NULL))
> +		return -ERANGE;
> +
> +	adv748x_fill_optional_dv_timings(timings);
> +
> +	mutex_lock(&state->mutex);
> +
> +	ret = adv748x_hdmi_set_video_timings(state, timings);
> +	if (ret)
> +		goto error;
> +
> +	hdmi->timings = *timings;
> +
> +	cp_clrset(state, ADV748X_CP_VID_ADJ_2, ADV748X_CP_VID_ADJ_2_INTERLACED,
> +		  timings->bt.interlaced ?
> +				  ADV748X_CP_VID_ADJ_2_INTERLACED : 0);
> +
> +	mutex_unlock(&state->mutex);
> +
> +	return 0;
> +
> +error:
> +	mutex_unlock(&state->mutex);
> +	return ret;
> +}
> +
> +static int adv748x_hdmi_g_dv_timings(struct v4l2_subdev *sd,
> +				     struct v4l2_dv_timings *timings)
> +{
> +	struct adv748x_hdmi *hdmi = adv748x_sd_to_hdmi(sd);
> +	struct adv748x_state *state = adv748x_hdmi_to_state(hdmi);
> +
> +	mutex_lock(&state->mutex);
> +
> +	*timings = hdmi->timings;
> +
> +	mutex_unlock(&state->mutex);
> +
> +	return 0;
> +}
> +
> +static int adv748x_hdmi_query_dv_timings(struct v4l2_subdev *sd,
> +					 struct v4l2_dv_timings *timings)
> +{
> +	struct adv748x_hdmi *hdmi = adv748x_sd_to_hdmi(sd);
> +	struct adv748x_state *state = adv748x_hdmi_to_state(hdmi);
> +	struct v4l2_bt_timings *bt = &timings->bt;
> +	int pixelclock;
> +	int polarity;
> +
> +	if (!timings)
> +		return -EINVAL;
> +
> +	memset(timings, 0, sizeof(struct v4l2_dv_timings));
> +
> +	if (!adv748x_hdmi_has_signal(state))
> +		return -ENOLINK;
> +
> +	pixelclock = adv748x_hdmi_read_pixelclock(state);
> +	if (pixelclock < 0)
> +		return -ENODATA;
> +
> +	timings->type = V4L2_DV_BT_656_1120;
> +
> +	bt->pixelclock = pixelclock;
> +	bt->interlaced = hdmi_read(state, ADV748X_HDMI_F1H1) &
> +				ADV748X_HDMI_F1H1_INTERLACED ?
> +				V4L2_DV_INTERLACED : V4L2_DV_PROGRESSIVE;
> +	bt->width = hdmi_read16(state, ADV748X_HDMI_LW1,
> +				ADV748X_HDMI_LW1_WIDTH_MASK);
> +	bt->height = hdmi_read16(state, ADV748X_HDMI_F0H1,
> +				 ADV748X_HDMI_F0H1_HEIGHT_MASK);
> +	bt->hfrontporch = hdmi_read16(state, ADV748X_HDMI_HFRONT_PORCH,
> +				      ADV748X_HDMI_HFRONT_PORCH_MASK);
> +	bt->hsync = hdmi_read16(state, ADV748X_HDMI_HSYNC_WIDTH,
> +				ADV748X_HDMI_HSYNC_WIDTH_MASK);
> +	bt->hbackporch = hdmi_read16(state, ADV748X_HDMI_HBACK_PORCH,
> +				     ADV748X_HDMI_HBACK_PORCH_MASK);
> +	bt->vfrontporch = hdmi_read16(state, ADV748X_HDMI_VFRONT_PORCH,
> +				      ADV748X_HDMI_VFRONT_PORCH_MASK) / 2;
> +	bt->vsync = hdmi_read16(state, ADV748X_HDMI_VSYNC_WIDTH,
> +				ADV748X_HDMI_VSYNC_WIDTH_MASK) / 2;
> +	bt->vbackporch = hdmi_read16(state, ADV748X_HDMI_VBACK_PORCH,
> +				     ADV748X_HDMI_VBACK_PORCH_MASK) / 2;
> +
> +
> +	polarity = hdmi_read(state, 0x05);
> +	bt->polarities = (polarity & BIT(4) ? V4L2_DV_VSYNC_POS_POL : 0) |
> +		(polarity & BIT(5) ? V4L2_DV_HSYNC_POS_POL : 0);
> +
> +	if (bt->interlaced == V4L2_DV_INTERLACED) {
> +		bt->height += hdmi_read16(state, 0x0b, 0x1fff);
> +		bt->il_vfrontporch = hdmi_read16(state, 0x2c, 0x3fff) / 2;
> +		bt->il_vsync = hdmi_read16(state, 0x30, 0x3fff) / 2;
> +		bt->il_vbackporch = hdmi_read16(state, 0x34, 0x3fff) / 2;
> +	}
> +
> +	adv748x_fill_optional_dv_timings(timings);
> +
> +	/*
> +	 * No interrupt handling is implemented yet.
> +	 * There should be an IRQ when a cable is plugged and the new timings
> +	 * should be figured out and stored to state.
> +	 */
> +	hdmi->timings = *timings;
> +
> +	return 0;
> +}
> +
> +static int adv748x_hdmi_g_input_status(struct v4l2_subdev *sd, u32 *status)
> +{
> +	struct adv748x_hdmi *hdmi = adv748x_sd_to_hdmi(sd);
> +	struct adv748x_state *state = adv748x_hdmi_to_state(hdmi);
> +
> +	mutex_lock(&state->mutex);
> +
> +	*status = adv748x_hdmi_has_signal(state) ? 0 : V4L2_IN_ST_NO_SIGNAL;

It would be nice if this could be a bit more detailed. Esp. being able to tell the
difference between whether or not there is a signal, and whether or not the
signal is stable (i.e. has sync).

> +
> +	mutex_unlock(&state->mutex);
> +
> +	return 0;
> +}
> +
> +static int adv748x_hdmi_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +	struct adv748x_hdmi *hdmi = adv748x_sd_to_hdmi(sd);
> +	struct adv748x_state *state = adv748x_hdmi_to_state(hdmi);
> +	int ret;
> +
> +	mutex_lock(&state->mutex);
> +
> +	ret = adv748x_txa_power(state, enable);
> +	if (ret)
> +		goto done;
> +
> +	if (adv748x_hdmi_has_signal(state))
> +		adv_dbg(state, "Detected HDMI signal\n");
> +	else
> +		adv_dbg(state, "Couldn't detect HDMI video signal\n");
> +
> +done:
> +	mutex_unlock(&state->mutex);
> +	return ret;
> +}
> +
> +static int adv748x_hdmi_g_pixelaspect(struct v4l2_subdev *sd,
> +				      struct v4l2_fract *aspect)
> +{
> +	aspect->numerator = 1;
> +	aspect->denominator = 1;
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_subdev_video_ops adv748x_video_ops_hdmi = {
> +	.s_dv_timings = adv748x_hdmi_s_dv_timings,
> +	.g_dv_timings = adv748x_hdmi_g_dv_timings,
> +	.query_dv_timings = adv748x_hdmi_query_dv_timings,
> +	.g_input_status = adv748x_hdmi_g_input_status,
> +	.s_stream = adv748x_hdmi_s_stream,
> +	.g_pixelaspect = adv748x_hdmi_g_pixelaspect,
> +};
> +
> +/* -----------------------------------------------------------------------------
> + * v4l2_subdev_pad_ops
> + */
> +
> +static int adv748x_hdmi_set_pixelrate(struct adv748x_hdmi *hdmi)
> +{
> +	struct v4l2_subdev *tx;
> +	struct v4l2_dv_timings timings;
> +	struct v4l2_bt_timings *bt = &timings.bt;
> +	unsigned int fps;
> +
> +	tx = adv748x_get_remote_sd(&hdmi->pads[ADV748X_HDMI_SOURCE]);
> +	if (!tx)
> +		return -ENOLINK;
> +
> +	adv748x_hdmi_query_dv_timings(&hdmi->sd, &timings);
> +
> +	fps = DIV_ROUND_CLOSEST(bt->pixelclock,
> +				V4L2_DV_BT_FRAME_WIDTH(bt) *
> +				V4L2_DV_BT_FRAME_HEIGHT(bt));
> +
> +	return adv748x_csi2_set_pixelrate(tx, bt->width * bt->height * fps);
> +}
> +
> +static int adv748x_hdmi_enum_mbus_code(struct v4l2_subdev *sd,
> +				  struct v4l2_subdev_pad_config *cfg,
> +				  struct v4l2_subdev_mbus_code_enum *code)
> +{
> +	if (code->index != 0)
> +		return -EINVAL;
> +
> +	code->code = MEDIA_BUS_FMT_RGB888_1X24;
> +
> +	return 0;
> +}
> +
> +static int adv748x_hdmi_get_format(struct v4l2_subdev *sd,
> +				   struct v4l2_subdev_pad_config *cfg,
> +				   struct v4l2_subdev_format *sdformat)
> +{
> +	struct adv748x_hdmi *hdmi = adv748x_sd_to_hdmi(sd);
> +	struct v4l2_mbus_framefmt *mbusformat;
> +
> +	if (sdformat->pad != ADV748X_HDMI_SOURCE)
> +		return -EINVAL;
> +
> +	if (sdformat->which == V4L2_SUBDEV_FORMAT_TRY) {
> +		mbusformat = v4l2_subdev_get_try_format(sd, cfg, sdformat->pad);
> +		sdformat->format = *mbusformat;
> +	} else {
> +		adv748x_hdmi_fill_format(hdmi, &sdformat->format);
> +		adv748x_hdmi_set_pixelrate(hdmi);
> +	}
> +
> +	return 0;
> +}
> +
> +static int adv748x_hdmi_set_format(struct v4l2_subdev *sd,
> +				   struct v4l2_subdev_pad_config *cfg,
> +				   struct v4l2_subdev_format *sdformat)
> +{
> +	struct v4l2_mbus_framefmt *mbusformat;
> +
> +	if (sdformat->pad != ADV748X_HDMI_SOURCE)
> +		return -EINVAL;
> +
> +	if (sdformat->which == V4L2_SUBDEV_FORMAT_ACTIVE)
> +		return adv748x_hdmi_get_format(sd, cfg, sdformat);
> +
> +	mbusformat = v4l2_subdev_get_try_format(sd, cfg, sdformat->pad);
> +	*mbusformat = sdformat->format;
> +
> +	return 0;
> +}
> +
> +static bool adv748x_hdmi_check_dv_timings(const struct v4l2_dv_timings *timings,
> +					  void *hdl)
> +{
> +	const struct adv748x_hdmi_video_standards *stds =
> +		adv748x_hdmi_video_standards;
> +	unsigned int i;
> +
> +	for (i = 0; stds[i].timings.bt.width; i++)
> +		if (v4l2_match_dv_timings(timings, &stds[i].timings, 0, false))
> +			return true;
> +
> +	return false;
> +}
> +
> +static int adv748x_hdmi_enum_dv_timings(struct v4l2_subdev *sd,
> +					struct v4l2_enum_dv_timings *timings)
> +{
> +	return v4l2_enum_dv_timings_cap(timings, &adv748x_hdmi_timings_cap,
> +					adv748x_hdmi_check_dv_timings, NULL);
> +}
> +
> +static int adv748x_hdmi_dv_timings_cap(struct v4l2_subdev *sd,
> +				       struct v4l2_dv_timings_cap *cap)
> +{
> +	*cap = adv748x_hdmi_timings_cap;
> +	return 0;
> +}
> +
> +static const struct v4l2_subdev_pad_ops adv748x_pad_ops_hdmi = {
> +	.enum_mbus_code = adv748x_hdmi_enum_mbus_code,
> +	.set_fmt = adv748x_hdmi_set_format,
> +	.get_fmt = adv748x_hdmi_get_format,
> +	.dv_timings_cap = adv748x_hdmi_dv_timings_cap,
> +	.enum_dv_timings = adv748x_hdmi_enum_dv_timings,

No get/set_edid ops? How can you use HDMI without having these ops?

> +};
> +
> +/* -----------------------------------------------------------------------------
> + * v4l2_subdev_ops
> + */
> +
> +static const struct v4l2_subdev_ops adv748x_ops_hdmi = {
> +	.video = &adv748x_video_ops_hdmi,
> +	.pad = &adv748x_pad_ops_hdmi,
> +};
> +
> +/* -----------------------------------------------------------------------------
> + * Controls
> + */
> +
> +static const char * const hdmi_ctrl_patgen_menu[] = {
> +	"Disabled",
> +	"Plain Blue",

I'd say just "Blue" or possibly "Solid Blue".

> +	"Color Bars",
> +	"Ramp Grey",
> +	"Ramp Blue",
> +	"Ramp Red",
> +	"Checkered"

I assume this is a black and white pattern? If so, say: "B&W Checkered"

> +};
> +
> +static int adv748x_hdmi_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct adv748x_hdmi *hdmi = adv748x_ctrl_to_hdmi(ctrl);
> +	struct adv748x_state *state = adv748x_hdmi_to_state(hdmi);
> +	int ret;
> +	u8 pattern;
> +
> +	/* Enable video adjustment first */
> +	ret = cp_clrset(state, ADV748X_CP_VID_ADJ,
> +			ADV748X_CP_VID_ADJ_ENABLE,
> +			ADV748X_CP_VID_ADJ_ENABLE);
> +	if (ret < 0)
> +		return ret;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_BRIGHTNESS:
> +		ret = cp_write(state, ADV748X_CP_BRI, ctrl->val);
> +		break;
> +	case V4L2_CID_HUE:
> +		ret = cp_write(state, ADV748X_CP_HUE, ctrl->val);
> +		break;
> +	case V4L2_CID_CONTRAST:
> +		ret = cp_write(state, ADV748X_CP_CON, ctrl->val);
> +		break;
> +	case V4L2_CID_SATURATION:
> +		ret = cp_write(state, ADV748X_CP_SAT, ctrl->val);
> +		break;
> +	case V4L2_CID_TEST_PATTERN:
> +		pattern = ctrl->val;
> +
> +		/* Pattern is 0-indexed. Ctrl Menu is 1-indexed */
> +		if (pattern) {
> +			pattern--;
> +			pattern |= ADV748X_CP_PAT_GEN_EN;
> +		}
> +
> +		ret = cp_write(state, ADV748X_CP_PAT_GEN, pattern);
> +
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +
> +static const struct v4l2_ctrl_ops adv748x_hdmi_ctrl_ops = {
> +	.s_ctrl = adv748x_hdmi_s_ctrl,
> +};
> +
> +static int adv748x_hdmi_init_controls(struct adv748x_hdmi *hdmi)
> +{
> +	struct adv748x_state *state = adv748x_hdmi_to_state(hdmi);
> +
> +	v4l2_ctrl_handler_init(&hdmi->ctrl_hdl, 5);
> +
> +	/* Use our mutex for the controls */
> +	hdmi->ctrl_hdl.lock = &state->mutex;
> +
> +	v4l2_ctrl_new_std(&hdmi->ctrl_hdl, &adv748x_hdmi_ctrl_ops,
> +			  V4L2_CID_BRIGHTNESS, ADV748X_CP_BRI_MIN,
> +			  ADV748X_CP_BRI_MAX, 1, ADV748X_CP_BRI_DEF);
> +	v4l2_ctrl_new_std(&hdmi->ctrl_hdl, &adv748x_hdmi_ctrl_ops,
> +			  V4L2_CID_CONTRAST, ADV748X_CP_CON_MIN,
> +			  ADV748X_CP_CON_MAX, 1, ADV748X_CP_CON_DEF);
> +	v4l2_ctrl_new_std(&hdmi->ctrl_hdl, &adv748x_hdmi_ctrl_ops,
> +			  V4L2_CID_SATURATION, ADV748X_CP_SAT_MIN,
> +			  ADV748X_CP_SAT_MAX, 1, ADV748X_CP_SAT_DEF);
> +	v4l2_ctrl_new_std(&hdmi->ctrl_hdl, &adv748x_hdmi_ctrl_ops,
> +			  V4L2_CID_HUE, ADV748X_CP_HUE_MIN,
> +			  ADV748X_CP_HUE_MAX, 1, ADV748X_CP_HUE_DEF);

You should implement the V4L2_CID_DV_RX_POWER_PRESENT control as well,
once interrupts are working.

Perhaps add a comment as a reminder?

> +
> +	v4l2_ctrl_new_std_menu_items(&hdmi->ctrl_hdl, &adv748x_hdmi_ctrl_ops,
> +				     V4L2_CID_TEST_PATTERN,
> +				     ARRAY_SIZE(hdmi_ctrl_patgen_menu) - 1,
> +				     0, 0, hdmi_ctrl_patgen_menu);
> +
> +	hdmi->sd.ctrl_handler = &hdmi->ctrl_hdl;
> +	if (hdmi->ctrl_hdl.error) {
> +		v4l2_ctrl_handler_free(&hdmi->ctrl_hdl);
> +		return hdmi->ctrl_hdl.error;
> +	}
> +
> +	return v4l2_ctrl_handler_setup(&hdmi->ctrl_hdl);
> +}
> +
> +int adv748x_hdmi_init(struct adv748x_hdmi *hdmi)
> +{
> +	struct adv748x_state *state = adv748x_hdmi_to_state(hdmi);
> +	static const struct v4l2_dv_timings cea720x480 =
> +		V4L2_DV_BT_CEA_720X480I59_94;
> +	int ret;
> +
> +	hdmi->timings = cea720x480;
> +
> +	adv748x_subdev_init(&hdmi->sd, state, &adv748x_ops_hdmi,
> +			    MEDIA_ENT_F_IO_DTV, "hdmi");
> +
> +	hdmi->pads[ADV748X_HDMI_SINK].flags = MEDIA_PAD_FL_SINK;
> +	hdmi->pads[ADV748X_HDMI_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
> +
> +	ret = media_entity_pads_init(&hdmi->sd.entity,
> +				     ADV748X_HDMI_NR_PADS, hdmi->pads);
> +	if (ret)
> +		return ret;
> +
> +	ret = adv748x_hdmi_init_controls(hdmi);
> +	if (ret)
> +		goto err_free_media;
> +
> +	return 0;
> +
> +err_free_media:
> +	media_entity_cleanup(&hdmi->sd.entity);
> +
> +	return ret;
> +}
> +
> +void adv748x_hdmi_cleanup(struct adv748x_hdmi *hdmi)
> +{
> +	v4l2_device_unregister_subdev(&hdmi->sd);
> +	media_entity_cleanup(&hdmi->sd.entity);
> +	v4l2_ctrl_handler_free(&hdmi->ctrl_hdl);
> +}
> diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
> new file mode 100644
> index 000000000000..2f36e5052f08
> --- /dev/null
> +++ b/drivers/media/i2c/adv748x/adv748x.h
> @@ -0,0 +1,415 @@
> +/*
> + * Driver for Analog Devices ADV748X video decoder and HDMI receiver
> + *
> + * Copyright (C) 2017 Renesas Electronics Corp.
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + *
> + * Authors:
> + *	Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> + *	Niklas Söderlund <niklas.soderlund@ragnatech.se>
> + *	Kieran Bingham <kieran.bingham@ideasonboard.com>
> + *
> + * The ADV748x range of receivers have the following configurations:
> + *
> + *                  Analog   HDMI  MHL  4-Lane  1-Lane
> + *                    In      In         CSI     CSI
> + *       ADV7480               X    X     X
> + *       ADV7481      X        X    X     X       X
> + *       ADV7482      X        X          X       X
> + */
> +
> +#include <linux/i2c.h>
> +
> +#ifndef _ADV748X_H_
> +#define _ADV748X_H_
> +
> +/* I2C slave addresses */
> +#define ADV748X_I2C_IO			0x70	/* IO Map */
> +#define ADV748X_I2C_DPLL		0x26	/* DPLL Map */
> +#define ADV748X_I2C_CP			0x22	/* CP Map */
> +#define ADV748X_I2C_HDMI		0x34	/* HDMI Map */
> +#define ADV748X_I2C_EDID		0x36	/* EDID Map */
> +#define ADV748X_I2C_REPEATER		0x32	/* HDMI RX Repeater Map */
> +#define ADV748X_I2C_INFOFRAME		0x31	/* HDMI RX InfoFrame Map */
> +#define ADV748X_I2C_CEC			0x41	/* CEC Map */
> +#define ADV748X_I2C_SDP			0x79	/* SDP Map */
> +#define ADV748X_I2C_TXB			0x48	/* CSI-TXB Map */
> +#define ADV748X_I2C_TXA			0x4a	/* CSI-TXA Map */
> +
> +enum adv748x_page {
> +	ADV748X_PAGE_IO,
> +	ADV748X_PAGE_DPLL,
> +	ADV748X_PAGE_CP,
> +	ADV748X_PAGE_HDMI,
> +	ADV748X_PAGE_EDID,
> +	ADV748X_PAGE_REPEATER,
> +	ADV748X_PAGE_INFOFRAME,
> +	ADV748X_PAGE_CEC,
> +	ADV748X_PAGE_SDP,
> +	ADV748X_PAGE_TXB,
> +	ADV748X_PAGE_TXA,
> +	ADV748X_PAGE_MAX,
> +
> +	/* Fake pages for register sequences */
> +	ADV748X_PAGE_WAIT,		/* Wait x msec */
> +	ADV748X_PAGE_EOR,		/* End Mark */
> +};
> +
> +/**
> + * enum adv748x_ports - Device tree port number definitions
> + *
> + * The ADV748X ports define the mapping between subdevices
> + * and the device tree specification
> + */
> +enum adv748x_ports {
> +	ADV748X_PORT_AIN0 = 0,
> +	ADV748X_PORT_AIN1 = 1,
> +	ADV748X_PORT_AIN2 = 2,
> +	ADV748X_PORT_AIN3 = 3,
> +	ADV748X_PORT_AIN4 = 4,
> +	ADV748X_PORT_AIN5 = 5,
> +	ADV748X_PORT_AIN6 = 6,
> +	ADV748X_PORT_AIN7 = 7,
> +	ADV748X_PORT_HDMI = 8,
> +	ADV748X_PORT_TTL = 9,
> +	ADV748X_PORT_TXA = 10,
> +	ADV748X_PORT_TXB = 11,
> +	ADV748X_PORT_MAX = 12,
> +};
> +
> +enum adv748x_csi2_pads {
> +	ADV748X_CSI2_SINK,
> +	ADV748X_CSI2_SOURCE,
> +	ADV748X_CSI2_NR_PADS,
> +};
> +
> +/* CSI2 transmitters can have 2 internal connections, HDMI/AFE */
> +#define ADV748X_CSI2_MAX_SUBDEVS 2
> +
> +struct adv748x_csi2 {
> +	struct adv748x_state *state;
> +	struct v4l2_mbus_framefmt format;
> +	unsigned int page;
> +
> +	struct media_pad pads[ADV748X_CSI2_NR_PADS];
> +	struct v4l2_ctrl_handler ctrl_hdl;
> +	struct v4l2_subdev sd;
> +};
> +
> +#define notifier_to_csi2(n) container_of(n, struct adv748x_csi2, notifier)
> +#define adv748x_sd_to_csi2(sd) container_of(sd, struct adv748x_csi2, sd)
> +
> +enum adv748x_hdmi_pads {
> +	ADV748X_HDMI_SINK,
> +	ADV748X_HDMI_SOURCE,
> +	ADV748X_HDMI_NR_PADS,
> +};
> +
> +struct adv748x_hdmi {
> +	struct media_pad pads[ADV748X_HDMI_NR_PADS];
> +	struct v4l2_ctrl_handler ctrl_hdl;
> +	struct v4l2_subdev sd;
> +	struct v4l2_mbus_framefmt format;
> +
> +	struct v4l2_dv_timings timings;
> +};
> +
> +#define adv748x_ctrl_to_hdmi(ctrl) \
> +	container_of(ctrl->handler, struct adv748x_hdmi, ctrl_hdl)
> +#define adv748x_sd_to_hdmi(sd) container_of(sd, struct adv748x_hdmi, sd)
> +
> +enum adv748x_afe_pads {
> +	ADV748X_AFE_SINK_AIN0,
> +	ADV748X_AFE_SINK_AIN1,
> +	ADV748X_AFE_SINK_AIN2,
> +	ADV748X_AFE_SINK_AIN3,
> +	ADV748X_AFE_SINK_AIN4,
> +	ADV748X_AFE_SINK_AIN5,
> +	ADV748X_AFE_SINK_AIN6,
> +	ADV748X_AFE_SINK_AIN7,
> +	ADV748X_AFE_SOURCE,
> +	ADV748X_AFE_NR_PADS,
> +};
> +
> +struct adv748x_afe {
> +	struct media_pad pads[ADV748X_AFE_NR_PADS];
> +	struct v4l2_ctrl_handler ctrl_hdl;
> +	struct v4l2_subdev sd;
> +	struct v4l2_mbus_framefmt format;
> +
> +	bool streaming;
> +	v4l2_std_id curr_norm;
> +	unsigned int input;
> +};
> +
> +#define adv748x_ctrl_to_afe(ctrl) \
> +	container_of(ctrl->handler, struct adv748x_afe, ctrl_hdl)
> +#define adv748x_sd_to_afe(sd) container_of(sd, struct adv748x_afe, sd)
> +
> +/**
> + * struct adv748x_state - State of ADV748X
> + * @dev:		(OF) device
> + * @client:		I2C client
> + * @mutex:		protect global state
> + *
> + * @endpoints:		parsed device node endpoints for each port
> + *
> + * @i2c_addresses	I2C Page addresses
> + * @i2c_clients		I2C clients for the page accesses
> + * @regmap		regmap configuration pages.
> + *
> + * @hdmi:		state of HDMI receiver context
> + * @afe:		state of AFE receiver context
> + * @txa:		state of TXA transmitter context
> + * @txb:		state of TXB transmitter context
> + */
> +struct adv748x_state {
> +	struct device *dev;
> +	struct i2c_client *client;
> +	struct mutex mutex;
> +
> +	struct device_node *endpoints[ADV748X_PORT_MAX];
> +
> +	struct i2c_client *i2c_clients[ADV748X_PAGE_MAX];
> +	struct regmap *regmap[ADV748X_PAGE_MAX];
> +
> +	struct adv748x_hdmi hdmi;
> +	struct adv748x_afe afe;
> +	struct adv748x_csi2 txa;
> +	struct adv748x_csi2 txb;
> +};
> +
> +#define adv748x_hdmi_to_state(h) container_of(h, struct adv748x_state, hdmi)
> +#define adv748x_afe_to_state(a) container_of(a, struct adv748x_state, afe)
> +
> +#define adv_err(a, fmt, arg...)	dev_err(a->dev, fmt, ##arg)
> +#define adv_info(a, fmt, arg...) dev_info(a->dev, fmt, ##arg)
> +#define adv_dbg(a, fmt, arg...)	dev_dbg(a->dev, fmt, ##arg)
> +
> +/* Register Mappings */
> +
> +/* IO Map */
> +#define ADV748X_IO_PD			0x00	/* power down controls */
> +#define ADV748X_IO_PD_RX_EN		BIT(6)
> +
> +#define ADV748X_IO_REG_04		0x04
> +#define ADV748X_IO_REG_04_FORCE_FR	BIT(0)	/* Force CP free-run */
> +
> +#define ADV748X_IO_DATAPATH		0x03	/* datapath cntrl */
> +#define ADV748X_IO_DATAPATH_VFREQ_M	0x70
> +#define ADV748X_IO_DATAPATH_VFREQ_SHIFT	4
> +
> +#define ADV748X_IO_VID_STD		0x05
> +
> +#define ADV748X_IO_10			0x10	/* io_reg_10 */
> +#define ADV748X_IO_10_CSI4_EN		BIT(7)
> +#define ADV748X_IO_10_CSI1_EN		BIT(6)
> +#define ADV748X_IO_10_PIX_OUT_EN	BIT(5)
> +
> +#define ADV748X_IO_CHIP_REV_ID_1	0xdf
> +#define ADV748X_IO_CHIP_REV_ID_2	0xe0
> +
> +#define ADV748X_IO_SLAVE_ADDR_BASE	0xf2
> +
> +/* HDMI RX Map */
> +#define ADV748X_HDMI_LW1		0x07	/* line width_1 */
> +#define ADV748X_HDMI_LW1_VERT_FILTER	BIT(7)
> +#define ADV748X_HDMI_LW1_DE_REGEN	BIT(5)
> +#define ADV748X_HDMI_LW1_WIDTH_MASK	0x1fff
> +
> +#define ADV748X_HDMI_F0H1		0x09	/* field0 height_1 */
> +#define ADV748X_HDMI_F0H1_HEIGHT_MASK	0x1fff
> +
> +#define ADV748X_HDMI_F1H1		0x0b	/* field1 height_1 */
> +#define ADV748X_HDMI_F1H1_INTERLACED	BIT(5)
> +
> +#define ADV748X_HDMI_HFRONT_PORCH	0x20	/* hsync_front_porch_1 */
> +#define ADV748X_HDMI_HFRONT_PORCH_MASK	0x1fff
> +
> +#define ADV748X_HDMI_HSYNC_WIDTH	0x22	/* hsync_pulse_width_1 */
> +#define ADV748X_HDMI_HSYNC_WIDTH_MASK	0x1fff
> +
> +#define ADV748X_HDMI_HBACK_PORCH	0x24	/* hsync_back_porch_1 */
> +#define ADV748X_HDMI_HBACK_PORCH_MASK	0x1fff
> +
> +#define ADV748X_HDMI_VFRONT_PORCH	0x2a	/* field0_vs_front_porch_1 */
> +#define ADV748X_HDMI_VFRONT_PORCH_MASK	0x3fff
> +
> +#define ADV748X_HDMI_VSYNC_WIDTH	0x2e	/* field0_vs_pulse_width_1 */
> +#define ADV748X_HDMI_VSYNC_WIDTH_MASK	0x3fff
> +
> +#define ADV748X_HDMI_VBACK_PORCH	0x32	/* field0_vs_back_porch_1 */
> +#define ADV748X_HDMI_VBACK_PORCH_MASK	0x3fff
> +
> +#define ADV748X_HDMI_TMDS_1		0x51	/* hdmi_reg_51 */
> +#define ADV748X_HDMI_TMDS_2		0x52	/* hdmi_reg_52 */
> +
> +/* SDP Main Map */
> +#define ADV748X_SDP_INSEL		0x00	/* user_map_rw_reg_00 */
> +
> +#define ADV748X_SDP_VID_SEL		0x02	/* user_map_rw_reg_02 */
> +#define ADV748X_SDP_VID_SEL_MASK	0xf0
> +#define ADV748X_SDP_VID_SEL_SHIFT	4
> +
> +/* Contrast - Unsigned*/
> +#define ADV748X_SDP_CON			0x08	/* user_map_rw_reg_08 */
> +#define ADV748X_SDP_CON_MIN		0
> +#define ADV748X_SDP_CON_DEF		128
> +#define ADV748X_SDP_CON_MAX		255
> +
> +/* Brightness - Signed */
> +#define ADV748X_SDP_BRI			0x0a	/* user_map_rw_reg_0a */
> +#define ADV748X_SDP_BRI_MIN		-128
> +#define ADV748X_SDP_BRI_DEF		0
> +#define ADV748X_SDP_BRI_MAX		127
> +
> +/* Hue - Signed, inverted*/
> +#define ADV748X_SDP_HUE			0x0b	/* user_map_rw_reg_0b */
> +#define ADV748X_SDP_HUE_MIN		-127
> +#define ADV748X_SDP_HUE_DEF		0
> +#define ADV748X_SDP_HUE_MAX		128
> +
> +/* Test Patterns / Default Values */
> +#define ADV748X_SDP_DEF			0x0c	/* user_map_rw_reg_0c */
> +#define ADV748X_SDP_DEF_VAL_EN		BIT(0)	/* Force free run mode */
> +#define ADV748X_SDP_DEF_VAL_AUTO_EN	BIT(1)	/* Free run when no signal */
> +
> +#define ADV748X_SDP_MAP_SEL		0x0e	/* user_map_rw_reg_0e */
> +#define ADV748X_SDP_MAP_SEL_RO_MAIN	1
> +
> +/* Free run pattern select */
> +#define ADV748X_SDP_FRP			0x14
> +#define ADV748X_SDP_FRP_MASK		GENMASK(3, 1)
> +
> +/* Saturation */
> +#define ADV748X_SDP_SD_SAT_U		0xe3	/* user_map_rw_reg_e3 */
> +#define ADV748X_SDP_SD_SAT_V		0xe4	/* user_map_rw_reg_e4 */
> +#define ADV748X_SDP_SAT_MIN		0
> +#define ADV748X_SDP_SAT_DEF		128
> +#define ADV748X_SDP_SAT_MAX		255
> +
> +/* SDP RO Main Map */
> +#define ADV748X_SDP_RO_10		0x10
> +#define ADV748X_SDP_RO_10_IN_LOCK	BIT(0)
> +
> +/* CP Map */
> +#define ADV748X_CP_PAT_GEN		0x37	/* int_pat_gen_1 */
> +#define ADV748X_CP_PAT_GEN_EN		BIT(7)
> +
> +/* Contrast Control - Unsigned */
> +#define ADV748X_CP_CON			0x3a	/* contrast_cntrl */
> +#define ADV748X_CP_CON_MIN		0	/* Minimum contrast */
> +#define ADV748X_CP_CON_DEF		128	/* Default */
> +#define ADV748X_CP_CON_MAX		255	/* Maximum contrast */
> +
> +/* Saturation Control - Unsigned */
> +#define ADV748X_CP_SAT			0x3b	/* saturation_cntrl */
> +#define ADV748X_CP_SAT_MIN		0	/* Minimum saturation */
> +#define ADV748X_CP_SAT_DEF		128	/* Default */
> +#define ADV748X_CP_SAT_MAX		255	/* Maximum saturation */
> +
> +/* Brightness Control - Signed */
> +#define ADV748X_CP_BRI			0x3c	/* brightness_cntrl */
> +#define ADV748X_CP_BRI_MIN		-128	/* Luma is -512d */
> +#define ADV748X_CP_BRI_DEF		0	/* Luma is 0 */
> +#define ADV748X_CP_BRI_MAX		127	/* Luma is 508d */
> +
> +/* Hue Control */
> +#define ADV748X_CP_HUE			0x3d	/* hue_cntrl */
> +#define ADV748X_CP_HUE_MIN		0	/* -90 degree */
> +#define ADV748X_CP_HUE_DEF		0	/* -90 degree */
> +#define ADV748X_CP_HUE_MAX		255	/* +90 degree */
> +
> +#define ADV748X_CP_VID_ADJ		0x3e	/* vid_adj_0 */
> +#define ADV748X_CP_VID_ADJ_ENABLE	BIT(7)	/* Enable colour controls */
> +
> +#define ADV748X_CP_DE_POS_HIGH		0x8b	/* de_pos_adj_6 */
> +#define ADV748X_CP_DE_POS_HIGH_SET	BIT(6)
> +#define ADV748X_CP_DE_POS_END_LOW	0x8c	/* de_pos_adj_7 */
> +#define ADV748X_CP_DE_POS_START_LOW	0x8d	/* de_pos_adj_8 */
> +
> +#define ADV748X_CP_VID_ADJ_2			0x91
> +#define ADV748X_CP_VID_ADJ_2_INTERLACED		BIT(6)
> +#define ADV748X_CP_VID_ADJ_2_INTERLACED_3D	BIT(4)
> +
> +#define ADV748X_CP_CLMP_POS		0xc9	/* clmp_pos_cntrl_4 */
> +#define ADV748X_CP_CLMP_POS_DIS_AUTO	BIT(0)	/* dis_auto_param_buff */
> +
> +/* CSI : TXA/TXB Maps */
> +#define ADV748X_CSI_VC_REF		0x0d	/* csi_tx_top_reg_0d */
> +#define ADV748X_CSI_VC_REF_SHIFT	6
> +
> +#define ADV748X_CSI_FS_AS_LS		0x1e	/* csi_tx_top_reg_1e */
> +#define ADV748X_CSI_FS_AS_LS_UNKNOWN	BIT(6)	/* Undocumented bit */
> +
> +/* Register handling */
> +
> +int adv748x_read(struct adv748x_state *state, u8 addr, u8 reg);
> +int adv748x_write(struct adv748x_state *state, u8 page, u8 reg, u8 value);
> +int adv748x_write_block(struct adv748x_state *state, int client_page,
> +			unsigned int init_reg, const void *val,
> +			size_t val_len);
> +
> +#define io_read(s, r) adv748x_read(s, ADV748X_PAGE_IO, r)
> +#define io_write(s, r, v) adv748x_write(s, ADV748X_PAGE_IO, r, v)
> +#define io_clrset(s, r, m, v) io_write(s, r, (io_read(s, r) & ~m) | v)
> +
> +#define hdmi_read(s, r) adv748x_read(s, ADV748X_PAGE_HDMI, r)
> +#define hdmi_read16(s, r, m) (((hdmi_read(s, r) << 8) | hdmi_read(s, r+1)) & m)
> +#define hdmi_write(s, r, v) adv748x_write(s, ADV748X_PAGE_HDMI, r, v)
> +#define hdmi_clrset(s, r, m, v) hdmi_write(s, r, (hdmi_read(s, r) & ~m) | v)
> +
> +#define sdp_read(s, r) adv748x_read(s, ADV748X_PAGE_SDP, r)
> +#define sdp_write(s, r, v) adv748x_write(s, ADV748X_PAGE_SDP, r, v)
> +#define sdp_clrset(s, r, m, v) sdp_write(s, r, (sdp_read(s, r) & ~m) | v)
> +
> +#define cp_read(s, r) adv748x_read(s, ADV748X_PAGE_CP, r)
> +#define cp_write(s, r, v) adv748x_write(s, ADV748X_PAGE_CP, r, v)
> +#define cp_clrset(s, r, m, v) cp_write(s, r, (cp_read(s, r) & ~m) | v)
> +
> +#define txa_read(s, r) adv748x_read(s, ADV748X_PAGE_TXA, r)
> +#define txa_write(s, r, v) adv748x_write(s, ADV748X_PAGE_TXA, r, v)
> +#define txa_clrset(s, r, m, v) txa_write(s, r, (txa_read(s, r) & ~m) | v)
> +
> +#define txb_read(s, r) adv748x_read(s, ADV748X_PAGE_TXB, r)
> +#define txb_write(s, r, v) adv748x_write(s, ADV748X_PAGE_TXB, r, v)
> +#define txb_clrset(s, r, m, v) txb_write(s, r, (txb_read(s, r) & ~m) | v)
> +
> +#define tx_read(t, r) adv748x_read(t->state, t->page, r)
> +#define tx_write(t, r, v) adv748x_write(t->state, t->page, r, v)
> +#define tx_clrset(t, r, m, v) tx_write(t, r, (tx_read(t, r) & ~m) | v)
> +
> +static inline struct v4l2_subdev *adv748x_get_remote_sd(struct media_pad *pad)
> +{
> +	pad = media_entity_remote_pad(pad);
> +	if (!pad)
> +		return NULL;
> +
> +	return media_entity_to_v4l2_subdev(pad->entity);
> +}
> +
> +void adv748x_subdev_init(struct v4l2_subdev *sd, struct adv748x_state *state,
> +			 const struct v4l2_subdev_ops *ops, u32 function,
> +			 const char *ident);
> +
> +int adv748x_register_subdevs(struct adv748x_state *state,
> +			     struct v4l2_device *v4l2_dev);
> +
> +int adv748x_txa_power(struct adv748x_state *state, bool on);
> +int adv748x_txb_power(struct adv748x_state *state, bool on);
> +
> +int adv748x_afe_init(struct adv748x_afe *afe);
> +void adv748x_afe_cleanup(struct adv748x_afe *afe);
> +
> +int adv748x_csi2_init(struct adv748x_state *state, struct adv748x_csi2 *tx);
> +void adv748x_csi2_cleanup(struct adv748x_csi2 *tx);
> +int adv748x_csi2_set_pixelrate(struct v4l2_subdev *sd, s64 rate);
> +
> +int adv748x_hdmi_init(struct adv748x_hdmi *hdmi);
> +void adv748x_hdmi_cleanup(struct adv748x_hdmi *hdmi);
> +
> +#endif /* _ADV748X_H_ */
> 

Regards,

	Hans
