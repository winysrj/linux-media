Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46158 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755124AbdELQqj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 May 2017 12:46:39 -0400
Date: Fri, 12 May 2017 19:46:34 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Kieran Bingham <kbingham@kernel.org>
Cc: laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [RFC PATCH v2 1/4] media: i2c: adv748x: add adv748x driver
Message-ID: <20170512164633.GL3227@valkosipuli.retiisi.org.uk>
References: <cover.5d2526b759f71c06d51df279c3d5885aca476fb6.1494523203.git-series.kieran.bingham+renesas@ideasonboard.com>
 <6aba7dbe2cdecc1afe6efc25fd0cea3f26508b1d.1494523203.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6aba7dbe2cdecc1afe6efc25fd0cea3f26508b1d.1494523203.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thanks for the patches!

Would you have a media-ctl -p && media-ctl --print-dot (or the PS file) to
see how this looks like in practice?

Please see my comments below.

On Thu, May 11, 2017 at 06:21:20PM +0100, Kieran Bingham wrote:
> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> Provide basic support for the ADV7481 and ADV7482.
> 
> The driver is modelled with 2 subdevices to allow simultaneous streaming
> from the AFE (Analog front end) and HDMI inputs.
> 
> Presently the HDMI is hardcoded to link to the TXA CSI bus, whilst the
> AFE is linked to the TXB CSI bus.
> 
> The driver is based on a prototype by Koji Matsuoka in the Renesas BSP,
> and an earlier rework by Niklas Söderlund.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> ---
> 
> v2:
>  - Implement DT parsing
>  - adv748x: Add CSI2 entity
>  - adv748x: Rework pad allocations and fmts
>  - Give AFE 8 input pads and move pad defines
>  - Use the enums to ensure pads are referenced correctly.
>  - adv748x: Rename AFE/HDMI entities
>    Now they are 'just afe' and 'just hdmi'
>  - Reorder the entity enum and structures
>  - Added pad-format for the CSI2 entities
>  - CSI2 s_stream pass through
>  - CSI2 control pass through (with link following)
> ---
>  Documentation/devicetree/bindings/media/i2c/adv748x.txt |  63 +-
>  MAINTAINERS                                             |   6 +-
>  drivers/media/i2c/Kconfig                               |  10 +-
>  drivers/media/i2c/Makefile                              |   1 +-
>  drivers/media/i2c/adv748x/Makefile                      |   7 +-
>  drivers/media/i2c/adv748x/adv748x-afe.c                 | 599 ++++++++-
>  drivers/media/i2c/adv748x/adv748x-core.c                | 698 +++++++++-
>  drivers/media/i2c/adv748x/adv748x-csi2.c                | 373 +++++-
>  drivers/media/i2c/adv748x/adv748x-hdmi.c                | 671 +++++++++-
>  drivers/media/i2c/adv748x/adv748x.h                     | 201 +++-
>  10 files changed, 2629 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/adv748x.txt
>  create mode 100644 drivers/media/i2c/adv748x/Makefile
>  create mode 100644 drivers/media/i2c/adv748x/adv748x-afe.c
>  create mode 100644 drivers/media/i2c/adv748x/adv748x-core.c
>  create mode 100644 drivers/media/i2c/adv748x/adv748x-csi2.c
>  create mode 100644 drivers/media/i2c/adv748x/adv748x-hdmi.c
>  create mode 100644 drivers/media/i2c/adv748x/adv748x.h
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/adv748x.txt b/Documentation/devicetree/bindings/media/i2c/adv748x.txt
> new file mode 100644
> index 000000000000..04d9ebc674a6
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/adv748x.txt
> @@ -0,0 +1,63 @@
> +* Analog Devices ADV748X video decoder with HDMI receiver
> +
> +The ADV7481, and ADV7482 are multi format video decoders with an integrated
> +HDMI receiver. It can output CSI-2 on two independent outputs TXA and TXB from
> +three input sources HDMI, analog and TTL.
> +
> +Required Properties:
> +
> +  - compatible: Must contain one of the following
> +    - "adi,adv7481" for the ADV7481
> +    - "adi,adv7482" for the ADV7482
> +
> +  - reg: I2C slave address
> +
> +The device node must contain one 'port' child node per device input and output
> +port, in accordance with the video interface bindings defined in
> +Documentation/devicetree/bindings/media/video-interfaces.txt. The port nodes
> +are numbered as follows.
> +
> +  Name                  Type            Port
> +------------------------------------------------------------
> +  HDMI                  sink            0
> +  AIN1                  sink            1
> +  AIN2                  sink            2
> +  AIN3                  sink            3
> +  AIN4                  sink            4
> +  AIN5                  sink            5
> +  AIN6                  sink            6
> +  AIN7                  sink            7
> +  AIN8                  sink            8
> +  TTL                   sink            9
> +  TXA                   source          10
> +  TXB                   source          11
> +
> +The digital output port node must contain at least one source endpoint.
> +
> +Example:
> +
> +    video_receiver@70 {
> +            compatible = "adi,adv7482";
> +            reg = <0x70>;
> +
> +            #address-cells = <1>;
> +            #size-cells = <0>;
> +
> +            port@10 {
> +                    reg = <10>;
> +                    adv7482_txa: endpoint@1 {
> +                            clock-lanes = <0>;
> +                            data-lanes = <1 2 3 4>;
> +                            remote-endpoint = <&csi40_in>;
> +                    };
> +            };
> +
> +            port@11 {
> +                    reg = <11>;
> +                    adv7482_txb: endpoint@1 {
> +                            clock-lanes = <0>;
> +                            data-lanes = <1>;
> +                            remote-endpoint = <&csi20_in>;
> +                    };
> +            };
> +    };
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 84f185731b3c..76356d2b8a69 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -774,6 +774,12 @@ L:	linux-media@vger.kernel.org
>  S:	Maintained
>  F:	drivers/media/i2c/adv7511*
>  
> +ANALOG DEVICES INC ADV748X DRIVER
> +M:	Kieran Bingham <kieran.bingham@ideasonboard.com>
> +L:	linux-media@vger.kernel.org
> +S:	Maintained
> +F:	drivers/media/i2c/adv748x/*
> +
>  ANALOG DEVICES INC ADV7604 DRIVER
>  M:	Hans Verkuil <hans.verkuil@cisco.com>
>  L:	linux-media@vger.kernel.org
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index 7c23b7a1fd05..78f495c939a2 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -204,6 +204,16 @@ config VIDEO_ADV7183
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called adv7183.
>  
> +config VIDEO_ADV748X
> +	tristate "Analog Devices ADV748x decoder"
> +	depends on VIDEO_V4L2 && I2C

VIDEO_V4L2_SUBDEV_API && 

> +	---help---
> +	  V4l2 subdevice driver for the Analog Devices
> +	  ADV7481 and ADV7482 HDMI/Analog video decoder.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called adv748x.
> +
>  config VIDEO_ADV7604
>  	tristate "Analog Devices ADV7604 decoder"
>  	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
> index 62323ec66be8..e17faab108d6 100644
> --- a/drivers/media/i2c/Makefile
> +++ b/drivers/media/i2c/Makefile
> @@ -1,6 +1,7 @@
>  msp3400-objs	:=	msp3400-driver.o msp3400-kthreads.o
>  obj-$(CONFIG_VIDEO_MSP3400) += msp3400.o
>  
> +obj-$(CONFIG_VIDEO_ADV748X) += adv748x/
>  obj-$(CONFIG_VIDEO_SMIAPP)	+= smiapp/
>  obj-$(CONFIG_VIDEO_ET8EK8)	+= et8ek8/
>  obj-$(CONFIG_VIDEO_CX25840) += cx25840/
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
> index 000000000000..ad2681c9d3b4
> --- /dev/null
> +++ b/drivers/media/i2c/adv748x/adv748x-afe.c
> @@ -0,0 +1,599 @@
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
> +#define ADV748X_AFE_INPUT_CVBS_AIN1			0x00
> +#define ADV748X_AFE_INPUT_CVBS_AIN2			0x01
> +#define ADV748X_AFE_INPUT_CVBS_AIN3			0x02
> +#define ADV748X_AFE_INPUT_CVBS_AIN4			0x03
> +#define ADV748X_AFE_INPUT_CVBS_AIN5			0x04
> +#define ADV748X_AFE_INPUT_CVBS_AIN6			0x05
> +#define ADV748X_AFE_INPUT_CVBS_AIN7			0x06
> +#define ADV748X_AFE_INPUT_CVBS_AIN8			0x07
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
> +	ret = sdp_write(state, 0x0e, 0x01);
> +	if (ret < 0)
> +		return ret;
> +
> +	return sdp_read(state, reg);
> +}
> +
> +static int adv748x_afe_status(struct adv748x_state *state, u32 *signal,
> +			      v4l2_std_id *std)
> +{
> +	int info;
> +
> +	/* Read status from reg 0x10 of SDP RO Map */
> +	info = adv748x_afe_read_ro_map(state, 0x10);
> +	if (info < 0)
> +		return info;
> +
> +	if (signal)
> +		*signal = info & BIT(0) ? 0 : V4L2_IN_ST_NO_SIGNAL;
> +
> +	if (std) {

if (!std)
	return 0;

And you can unindent the rest by one tab stop. I think it'd look nicer that
way.

> +		*std = V4L2_STD_UNKNOWN;
> +
> +		/* Standard not valid if there is no signal */
> +		if (info & BIT(0)) {
> +			switch (info & 0x70) {
> +			case 0x00:
> +				*std = V4L2_STD_NTSC;
> +				break;
> +			case 0x10:
> +				*std = V4L2_STD_NTSC_443;
> +				break;
> +			case 0x20:
> +				*std = V4L2_STD_PAL_M;
> +				break;
> +			case 0x30:
> +				*std = V4L2_STD_PAL_60;
> +				break;
> +			case 0x40:
> +				*std = V4L2_STD_PAL;
> +				break;
> +			case 0x50:
> +				*std = V4L2_STD_SECAM;
> +				break;
> +			case 0x60:
> +				*std = V4L2_STD_PAL_Nc | V4L2_STD_PAL_N;
> +				break;
> +			case 0x70:
> +				*std = V4L2_STD_SECAM;
> +				break;
> +			default:
> +				*std = V4L2_STD_UNKNOWN;
> +				break;
> +			}
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static void adv748x_afe_fill_format(struct adv748x_state *state,
> +				    struct v4l2_mbus_framefmt *fmt)
> +{
> +	v4l2_std_id std;
> +
> +	memset(fmt, 0, sizeof(*fmt));

I think it'd be good to leave this up to the V4L2 subdev framework to do:
not every driver should be responsible for doing that. E.g. smiapp does not.
I'm sure there are others. The V4L2 sub-device framework doesn't really help
with that in any way and I'd say it's for historical reasons.

But please keep this for now...

> +
> +	fmt->code = MEDIA_BUS_FMT_UYVY8_2X8;
> +	fmt->colorspace = V4L2_COLORSPACE_SMPTE170M;
> +	fmt->field = V4L2_FIELD_INTERLACED;
> +
> +	fmt->width = 720;
> +
> +	if (state->afe.curr_norm == V4L2_STD_ALL)
> +		adv748x_afe_status(state, NULL,  &std);
> +	else
> +		std = state->afe.curr_norm;
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
> +	sdp_clrset(state, 0x02, 0xf0, (sdpstd & 0xf) << 4);
> +
> +	return 0;
> +}
> +
> +static int adv748x_afe_g_pixelaspect(struct v4l2_subdev *sd,
> +				     struct v4l2_fract *aspect)
> +{
> +	struct adv748x_state *state = adv748x_afe_to_state(sd);
> +	v4l2_std_id std;
> +
> +	if (state->afe.curr_norm == V4L2_STD_ALL)
> +		adv748x_afe_status(state, NULL,  &std);
> +	else
> +		std = state->afe.curr_norm;
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
> +	struct adv748x_state *state = adv748x_afe_to_state(sd);
> +
> +	if (state->afe.curr_norm == V4L2_STD_ALL)
> +		adv748x_afe_status(state, NULL,  norm);
> +	else
> +		*norm = state->afe.curr_norm;
> +
> +	return 0;
> +}
> +
> +
> +static int adv748x_afe_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
> +{
> +	struct adv748x_state *state = adv748x_afe_to_state(sd);
> +	int ret;
> +
> +	ret = mutex_lock_interruptible(&state->mutex);
> +	if (ret)
> +		return ret;
> +
> +	ret = adv748x_afe_set_video_standard(state, std);
> +	if (ret < 0)
> +		goto out;
> +
> +	state->afe.curr_norm = std;
> +
> +out:
> +	mutex_unlock(&state->mutex);
> +	return ret;
> +}
> +
> +static int adv748x_afe_querystd(struct v4l2_subdev *sd, v4l2_std_id *std)
> +{
> +	struct adv748x_state *state = adv748x_afe_to_state(sd);
> +	int ret;
> +
> +	ret = mutex_lock_interruptible(&state->mutex);
> +	if (ret)
> +		return ret;
> +
> +	if (state->afe.streaming) {
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
> +	ret = adv748x_afe_status(state, NULL, std);
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
> +	struct adv748x_state *state = adv748x_afe_to_state(sd);
> +	int ret;
> +
> +	ret = mutex_lock_interruptible(&state->mutex);

I wonder if this is necessary. Do you expect the mutex to be taken for
extended periods of time?

> +	if (ret)
> +		return ret;
> +
> +	ret = adv748x_afe_status(state, status, NULL);
> +
> +	mutex_unlock(&state->mutex);
> +	return ret;
> +}
> +
> +static int adv748x_afe_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +	struct adv748x_state *state = adv748x_afe_to_state(sd);
> +	int ret, signal = V4L2_IN_ST_NO_SIGNAL;
> +
> +	ret = mutex_lock_interruptible(&state->mutex);
> +	if (ret)
> +		return ret;
> +
> +	ret = adv748x_txb_power(state, enable);
> +	if (ret)
> +		goto error;
> +
> +	state->afe.streaming = enable;
> +
> +	adv748x_afe_status(state, &signal, NULL);
> +	if (signal != V4L2_IN_ST_NO_SIGNAL)
> +		adv_dbg(state, "Detected SDP signal\n");
> +	else
> +		adv_info(state, "Couldn't detect SDP video signal\n");
> +
> +error:
> +	mutex_unlock(&state->mutex);
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
> +static int adv748x_afe_enum_mbus_code(struct v4l2_subdev *sd,
> +				      struct v4l2_subdev_pad_config *cfg,
> +				      struct v4l2_subdev_mbus_code_enum *code)
> +{
> +	if (code->index != 0)
> +		return -EINVAL;
> +
> +	if (code->pad >= ADV748X_AFE_NR_PADS)
> +		return -EINVAL;

That check exists in v4l2-subdev.c.

> +
> +	code->code = MEDIA_BUS_FMT_UYVY8_2X8;
> +
> +	return 0;
> +}
> +
> +
> +static int adv748x_afe_get_pad_format(struct v4l2_subdev *sd,
> +				      struct v4l2_subdev_pad_config *cfg,
> +				      struct v4l2_subdev_format *format)
> +{
> +	struct adv748x_state *state = adv748x_afe_to_state(sd);
> +
> +	if (format->pad >= ADV748X_AFE_NR_PADS)
> +		return -EINVAL;

Ditto.

> +
> +	adv748x_afe_fill_format(state, &format->format);
> +
> +	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
> +		struct v4l2_mbus_framefmt *fmt;
> +
> +		fmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
> +		format->format.code = fmt->code;
> +	}
> +
> +	return 0;
> +}
> +
> +static int adv748x_afe_set_pad_format(struct v4l2_subdev *sd,
> +				      struct v4l2_subdev_pad_config *cfg,
> +				      struct v4l2_subdev_format *format)
> +{
> +	struct adv748x_state *state = adv748x_afe_to_state(sd);
> +
> +	if (format->pad >= ADV748X_AFE_NR_PADS)
> +		return -EINVAL;

Ditto.

> +
> +	adv748x_afe_fill_format(state, &format->format);
> +
> +	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
> +		struct v4l2_mbus_framefmt *fmt;
> +
> +		fmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
> +		fmt->code = format->format.code;
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_subdev_pad_ops adv748x_afe_pad_ops = {
> +	.enum_mbus_code = adv748x_afe_enum_mbus_code,
> +	.set_fmt = adv748x_afe_set_pad_format,
> +	.get_fmt = adv748x_afe_get_pad_format,
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
> +/* Contrast */
> +#define ADV748X_AFE_REG_CON		0x08	/*Unsigned */
> +#define ADV748X_AFE_CON_MIN		0
> +#define ADV748X_AFE_CON_DEF		128
> +#define ADV748X_AFE_CON_MAX		255
> +/* Brightness*/
> +#define ADV748X_AFE_REG_BRI		0x0a	/*Signed */
> +#define ADV748X_AFE_BRI_MIN		-128
> +#define ADV748X_AFE_BRI_DEF		0
> +#define ADV748X_AFE_BRI_MAX		127
> +/* Hue */
> +#define ADV748X_AFE_REG_HUE		0x0b	/*Signed, inverted */
> +#define ADV748X_AFE_HUE_MIN		-127
> +#define ADV748X_AFE_HUE_DEF		0
> +#define ADV748X_AFE_HUE_MAX		128
> +
> +/* Saturation */
> +#define ADV748X_AFE_REG_SD_SAT_CB	0xe3
> +#define ADV748X_AFE_REG_SD_SAT_CR	0xe4
> +#define ADV748X_AFE_SAT_MIN		0
> +#define ADV748X_AFE_SAT_DEF		128
> +#define ADV748X_AFE_SAT_MAX		255
> +
> +static int __adv748x_afe_s_ctrl(struct v4l2_ctrl *ctrl,
> +				struct adv748x_state *state)
> +{
> +	int ret;
> +
> +	ret = sdp_write(state, 0x0e, 0x00);
> +	if (ret < 0)
> +		return ret;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_BRIGHTNESS:
> +		if (ctrl->val < ADV748X_AFE_BRI_MIN ||
> +		    ctrl->val > ADV748X_AFE_BRI_MAX)
> +			return -ERANGE;
> +
> +		ret = sdp_write(state, ADV748X_AFE_REG_BRI, ctrl->val);
> +		break;
> +	case V4L2_CID_HUE:
> +		if (ctrl->val < ADV748X_AFE_HUE_MIN ||
> +		    ctrl->val > ADV748X_AFE_HUE_MAX)
> +			return -ERANGE;
> +
> +		/* Hue is inverted according to HSL chart */
> +		ret = sdp_write(state, ADV748X_AFE_REG_HUE, -ctrl->val);
> +		break;
> +	case V4L2_CID_CONTRAST:
> +		if (ctrl->val < ADV748X_AFE_CON_MIN ||
> +		    ctrl->val > ADV748X_AFE_CON_MAX)
> +			return -ERANGE;
> +
> +		ret = sdp_write(state, ADV748X_AFE_REG_CON, ctrl->val);
> +		break;
> +	case V4L2_CID_SATURATION:
> +		if (ctrl->val < ADV748X_AFE_SAT_MIN ||
> +		    ctrl->val > ADV748X_AFE_SAT_MAX)
> +			return -ERANGE;
> +		/*
> +		 * This could be V4L2_CID_BLUE_BALANCE/V4L2_CID_RED_BALANCE
> +		 * Let's not confuse the user, everybody understands saturation
> +		 */
> +		ret = sdp_write(state, ADV748X_AFE_REG_SD_SAT_CB, ctrl->val);
> +		if (ret)
> +			break;
> +		ret = sdp_write(state, ADV748X_AFE_REG_SD_SAT_CR, ctrl->val);
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +
> +static int adv748x_afe_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct adv748x_state *state =
> +		container_of(ctrl->handler, struct adv748x_state, afe.ctrl_hdl);
> +	int ret;
> +
> +	ret = mutex_lock_interruptible(&state->mutex);
> +	if (ret)
> +		return ret;
> +
> +	ret = __adv748x_afe_s_ctrl(ctrl, state);
> +
> +	mutex_unlock(&state->mutex);
> +
> +	return ret;
> +}
> +
> +static int adv748x_afe_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct adv748x_state *state =
> +		container_of(ctrl->handler, struct adv748x_state, afe.ctrl_hdl);
> +	unsigned int width, height, fps;
> +	v4l2_std_id std;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_PIXEL_RATE:

I presume you will know when PIXEL_RATE changes? You can use
v4l2_ctrl_s_ctrl_int64() to change it. That way control events will be
emitted correctly, too.

PIXEL_RATE is set READONLY (control flag) by the framework already.

> +		width = 720;
> +		if (state->afe.curr_norm == V4L2_STD_ALL)
> +			adv748x_afe_status(state, NULL,  &std);
> +		else
> +			std = state->afe.curr_norm;
> +
> +		height = std & V4L2_STD_525_60 ? 480 : 576;
> +		fps = std & V4L2_STD_525_60 ? 30 : 25;
> +
> +		*ctrl->p_new.p_s64 = width * height * fps;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_ctrl_ops adv748x_afe_ctrl_ops = {
> +	.s_ctrl = adv748x_afe_s_ctrl,
> +	.g_volatile_ctrl = adv748x_afe_g_volatile_ctrl,
> +};
> +
> +static int adv748x_afe_init_controls(struct adv748x_state *state)
> +{
> +	struct v4l2_ctrl *ctrl;
> +
> +	v4l2_ctrl_handler_init(&state->afe.ctrl_hdl, 5);
> +
> +	v4l2_ctrl_new_std(&state->afe.ctrl_hdl, &adv748x_afe_ctrl_ops,
> +			  V4L2_CID_BRIGHTNESS, ADV748X_AFE_BRI_MIN,
> +			  ADV748X_AFE_BRI_MAX, 1, ADV748X_AFE_BRI_DEF);
> +	v4l2_ctrl_new_std(&state->afe.ctrl_hdl, &adv748x_afe_ctrl_ops,
> +			  V4L2_CID_CONTRAST, ADV748X_AFE_CON_MIN,
> +			  ADV748X_AFE_CON_MAX, 1, ADV748X_AFE_CON_DEF);
> +	v4l2_ctrl_new_std(&state->afe.ctrl_hdl, &adv748x_afe_ctrl_ops,
> +			  V4L2_CID_SATURATION, ADV748X_AFE_SAT_MIN,
> +			  ADV748X_AFE_SAT_MAX, 1, ADV748X_AFE_SAT_DEF);
> +	v4l2_ctrl_new_std(&state->afe.ctrl_hdl, &adv748x_afe_ctrl_ops,
> +			  V4L2_CID_HUE, ADV748X_AFE_HUE_MIN,
> +			  ADV748X_AFE_HUE_MAX, 1, ADV748X_AFE_HUE_DEF);
> +	ctrl = v4l2_ctrl_new_std(&state->afe.ctrl_hdl, &adv748x_afe_ctrl_ops,
> +				 V4L2_CID_PIXEL_RATE, 1, INT_MAX, 1, 1);
> +	if (ctrl)
> +		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
> +
> +	state->afe.sd.ctrl_handler = &state->afe.ctrl_hdl;
> +	if (state->afe.ctrl_hdl.error) {
> +		v4l2_ctrl_handler_free(&state->afe.ctrl_hdl);
> +		return state->afe.ctrl_hdl.error;
> +	}
> +
> +	return v4l2_ctrl_handler_setup(&state->afe.ctrl_hdl);
> +}
> +
> +int adv748x_afe_probe(struct adv748x_state *state, struct device_node *ep)
> +{
> +	int ret;
> +	unsigned int i;
> +
> +	state->afe.streaming = false;
> +	state->afe.curr_norm = V4L2_STD_ALL;
> +
> +	adv748x_subdev_init(&state->afe.sd, state, &adv748x_afe_ops, "afe");
> +
> +	/* Ensure that matching is based upon the endpoint fwnodes */
> +	state->afe.sd.fwnode = &ep->fwnode;

I wonder if you really need to convert all users of async matching to use
endpoints --- could you opportunistically peek if the device node matches,
just in case? You can't have an accidental positive match anyway.

So, the match is now for plain fwnode pointers, and it would be:

return async->fwnode == fwnode ||
	port_parent(parent(async->fwnode)) == fwnode ||
	async->fwnode == port_parent(parent(fwnode));

> +
> +	for (i = ADV748X_AFE_SINK_AIN0; i <= ADV748X_AFE_SINK_AIN7; i++)
> +		state->afe.pads[i].flags = MEDIA_PAD_FL_SINK;
> +
> +	state->afe.pads[ADV748X_AFE_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
> +
> +	ret = media_entity_pads_init(&state->afe.sd.entity, ADV748X_AFE_NR_PADS,
> +			state->afe.pads);
> +
> +	ret = adv748x_afe_init_controls(state);
> +	if (ret)
> +		return ret;
> +
> +	ret = v4l2_async_register_subdev(&state->afe.sd);

If v4l2_async_register_subdev() fails, you should release the control
handler, shouldn't you?

> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +void adv748x_afe_remove(struct adv748x_state *state)
> +{
> +	v4l2_async_unregister_subdev(&state->afe.sd);
> +	media_entity_cleanup(&state->afe.sd.entity);
> +	v4l2_ctrl_handler_free(&state->afe.ctrl_hdl);
> +}
> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
> new file mode 100644
> index 000000000000..baa93c9f3fc6
> --- /dev/null
> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
> @@ -0,0 +1,698 @@
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
> +/**
> + * struct adv748x_reg_value - Register write instruction
> + * @addr:		I2C slave address
> + * @reg:		I2c register
> + * @value:		value to write to @addr at @reg
> + */
> +struct adv748x_reg_value {
> +	u8 addr;
> +	u8 reg;
> +	u8 value;
> +};
> +
> +static int adv748x_write_regs(struct adv748x_state *state,
> +			      const struct adv748x_reg_value *regs)
> +{
> +	struct i2c_msg msg;
> +	u8 data_buf[2];
> +	int ret = -EINVAL;
> +
> +	if (!state->client->adapter) {
> +		adv_err(state, "No adapter for regs write\n");
> +		return -ENODEV;
> +	}
> +
> +	msg.flags = 0;
> +	msg.len = 2;
> +	msg.buf = &data_buf[0];
> +
> +	while (regs->addr != ADV748X_I2C_EOR) {
> +
> +		if (regs->addr == ADV748X_I2C_WAIT)
> +			msleep(regs->value);
> +		else {
> +			msg.addr = regs->addr;
> +			data_buf[0] = regs->reg;
> +			data_buf[1] = regs->value;
> +
> +			ret = i2c_transfer(state->client->adapter, &msg, 1);
> +			if (ret < 0) {
> +				adv_err(state,
> +					"Error regs addr: 0x%02x reg: 0x%02x\n",
> +					regs->addr, regs->reg);
> +				break;
> +			}
> +		}
> +		regs++;
> +	}
> +
> +	return (ret < 0) ? ret : 0;
> +}
> +
> +int adv748x_write(struct adv748x_state *state, u8 addr, u8 reg, u8 value)
> +{
> +	struct adv748x_reg_value regs[2];
> +	int ret;
> +
> +	regs[0].addr = addr;
> +	regs[0].reg = reg;
> +	regs[0].value = value;
> +	regs[1].addr = ADV748X_I2C_EOR;
> +	regs[1].reg = 0xFF;
> +	regs[1].value = 0xFF;
> +
> +	ret = adv748x_write_regs(state, regs);
> +
> +	return ret;
> +}
> +
> +int adv748x_read(struct adv748x_state *state, u8 addr, u8 reg)
> +{
> +	struct i2c_msg msg[2];
> +	u8 reg_buf, data_buf;
> +	int ret;
> +
> +	if (!state->client->adapter) {
> +		adv_err(state, "No adapter reading addr: 0x%02x reg: 0x%02x\n",
> +			addr, reg);
> +		return -ENODEV;
> +	}
> +
> +	msg[0].addr = addr;
> +	msg[0].flags = 0;
> +	msg[0].len = 1;
> +	msg[0].buf = &reg_buf;
> +	msg[1].addr = addr;
> +	msg[1].flags = I2C_M_RD;
> +	msg[1].len = 1;
> +	msg[1].buf = &data_buf;
> +
> +	reg_buf = reg;
> +
> +	ret = i2c_transfer(state->client->adapter, msg, 2);
> +	if (ret < 0) {
> +		trace_printk("Error reading addr: 0x%02x reg: 0x%02x\n",
> +			addr, reg);
> +		adv_err(state, "Error reading addr: 0x%02x reg: 0x%02x\n",
> +			addr, reg);
> +		return ret;
> +	}
> +
> +	return data_buf;
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * TXA and TXB
> + */
> +
> +static const struct adv748x_reg_value adv748x_power_up_txa_4lane[] = {
> +
> +	{ADV748X_I2C_TXA, 0x00, 0x84},	/* Enable 4-lane MIPI */
> +	{ADV748X_I2C_TXA, 0x00, 0xA4},	/* Set Auto DPHY Timing */
> +
> +	{ADV748X_I2C_TXA, 0x31, 0x82},	/* ADI Required Write */
> +	{ADV748X_I2C_TXA, 0x1E, 0x40},	/* ADI Required Write */
> +	{ADV748X_I2C_TXA, 0xDA, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> +	{ADV748X_I2C_WAIT, 0x00, 0x02},	/* delay 2 */
> +	{ADV748X_I2C_TXA, 0x00, 0x24 },	/* Power-up CSI-TX */
> +	{ADV748X_I2C_WAIT, 0x00, 0x01},	/* delay 1 */
> +	{ADV748X_I2C_TXA, 0xC1, 0x2B},	/* ADI Required Write */
> +	{ADV748X_I2C_WAIT, 0x00, 0x01},	/* delay 1 */
> +	{ADV748X_I2C_TXA, 0x31, 0x80},	/* ADI Required Write */
> +
> +	{ADV748X_I2C_EOR, 0xFF, 0xFF}	/* End of register table */
> +};
> +
> +static const struct adv748x_reg_value adv748x_power_down_txa_4lane[] = {
> +
> +	{ADV748X_I2C_TXA, 0x31, 0x82},	/* ADI Required Write */
> +	{ADV748X_I2C_TXA, 0x1E, 0x00},	/* ADI Required Write */
> +	{ADV748X_I2C_TXA, 0x00, 0x84},	/* Enable 4-lane MIPI */
> +	{ADV748X_I2C_TXA, 0xDA, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> +	{ADV748X_I2C_TXA, 0xC1, 0x3B},	/* ADI Required Write */
> +
> +	{ADV748X_I2C_EOR, 0xFF, 0xFF}	/* End of register table */
> +};
> +
> +static const struct adv748x_reg_value adv748x_power_up_txb_1lane[] = {
> +
> +	{ADV748X_I2C_TXB, 0x00, 0x81},	/* Enable 1-lane MIPI */
> +	{ADV748X_I2C_TXB, 0x00, 0xA1},	/* Set Auto DPHY Timing */
> +
> +	{ADV748X_I2C_TXB, 0x31, 0x82},	/* ADI Required Write */
> +	{ADV748X_I2C_TXB, 0x1E, 0x40},	/* ADI Required Write */
> +	{ADV748X_I2C_TXB, 0xDA, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> +	{ADV748X_I2C_WAIT, 0x00, 0x02},	/* delay 2 */
> +	{ADV748X_I2C_TXB, 0x00, 0x21 },	/* Power-up CSI-TX */
> +	{ADV748X_I2C_WAIT, 0x00, 0x01},	/* delay 1 */
> +	{ADV748X_I2C_TXB, 0xC1, 0x2B},	/* ADI Required Write */
> +	{ADV748X_I2C_WAIT, 0x00, 0x01},	/* delay 1 */
> +	{ADV748X_I2C_TXB, 0x31, 0x80},	/* ADI Required Write */
> +
> +	{ADV748X_I2C_EOR, 0xFF, 0xFF}	/* End of register table */
> +};
> +
> +static const struct adv748x_reg_value adv748x_power_down_txb_1lane[] = {
> +
> +	{ADV748X_I2C_TXB, 0x31, 0x82},	/* ADI Required Write */
> +	{ADV748X_I2C_TXB, 0x1E, 0x00},	/* ADI Required Write */
> +	{ADV748X_I2C_TXB, 0x00, 0x81},	/* Enable 4-lane MIPI */
> +	{ADV748X_I2C_TXB, 0xDA, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> +	{ADV748X_I2C_TXB, 0xC1, 0x3B},	/* ADI Required Write */
> +
> +	{ADV748X_I2C_EOR, 0xFF, 0xFF}	/* End of register table */
> +};
> +
> +int adv748x_txa_power(struct adv748x_state *state, bool on)
> +{
> +	int val, ret;
> +
> +	val = txa_read(state, 0x1e);
> +	if (val < 0)
> +		return val;
> +
> +	if (on && ((val & 0x40) == 0))
> +		ret = adv748x_write_regs(state, adv748x_power_up_txa_4lane);
> +	else
> +		ret = adv748x_write_regs(state, adv748x_power_down_txa_4lane);
> +
> +	return ret;
> +}
> +
> +int adv748x_txb_power(struct adv748x_state *state, bool on)
> +{
> +	int val, ret;
> +
> +	val = txb_read(state, 0x1e);
> +	if (val < 0)
> +		return val;
> +
> +	if (on && ((val & 0x40) == 0))
> +		ret = adv748x_write_regs(state, adv748x_power_up_txb_1lane);
> +	else
> +		ret = adv748x_write_regs(state, adv748x_power_down_txb_1lane);
> +
> +	return ret;
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
> +	{ADV748X_I2C_IO, 0xFF, 0xFF},	/* SW reset */
> +	{ADV748X_I2C_WAIT, 0x00, 0x05},	/* delay 5 */
> +	{ADV748X_I2C_IO, 0x01, 0x76},	/* ADI Required Write */
> +	{ADV748X_I2C_IO, 0xF2, 0x01},	/* Enable I2C Read Auto-Increment */
> +	{ADV748X_I2C_EOR, 0xFF, 0xFF}	/* End of register table */
> +};
> +
> +static const struct adv748x_reg_value adv748x_set_slave_address[] = {
> +	{ADV748X_I2C_IO, 0xF3, ADV748X_I2C_DPLL << 1},	/* DPLL */
> +	{ADV748X_I2C_IO, 0xF4, ADV748X_I2C_CP << 1},	/* CP */
> +	{ADV748X_I2C_IO, 0xF5, ADV748X_I2C_HDMI << 1},	/* HDMI */
> +	{ADV748X_I2C_IO, 0xF6, ADV748X_I2C_EDID << 1},	/* EDID */
> +	{ADV748X_I2C_IO, 0xF7, ADV748X_I2C_REPEATER << 1}, /* HDMI RX Repeater */
> +	{ADV748X_I2C_IO, 0xF8, ADV748X_I2C_INFOFRAME << 1},/* HDMI RX InfoFrame*/
> +	{ADV748X_I2C_IO, 0xFA, ADV748X_I2C_CEC << 1},	/* CEC */
> +	{ADV748X_I2C_IO, 0xFB, ADV748X_I2C_SDP << 1},	/* SDP */
> +	{ADV748X_I2C_IO, 0xFC, ADV748X_I2C_TXB << 1},	/* CSI-TXB */
> +	{ADV748X_I2C_IO, 0xFD, ADV748X_I2C_TXA << 1},	/* CSI-TXA */
> +	{ADV748X_I2C_EOR, 0xFF, 0xFF}	/* End of register table */
> +};
> +
> +/* Supported Formats For Script Below */
> +/* - 01-29 HDMI to MIPI TxA CSI 4-Lane - RGB888: */
> +static const struct adv748x_reg_value adv748x_init_txa_4lane[] = {
> +	/* Disable chip powerdown & Enable HDMI Rx block */
> +	{ADV748X_I2C_IO, 0x00, 0x40},
> +
> +	{ADV748X_I2C_REPEATER, 0x40, 0x83}, /* Enable HDCP 1.1 */
> +
> +	{ADV748X_I2C_HDMI, 0x00, 0x08},	/* Foreground Channel = A */
> +	{ADV748X_I2C_HDMI, 0x98, 0xFF},	/* ADI Required Write */
> +	{ADV748X_I2C_HDMI, 0x99, 0xA3},	/* ADI Required Write */
> +	{ADV748X_I2C_HDMI, 0x9A, 0x00},	/* ADI Required Write */
> +	{ADV748X_I2C_HDMI, 0x9B, 0x0A},	/* ADI Required Write */
> +	{ADV748X_I2C_HDMI, 0x9D, 0x40},	/* ADI Required Write */
> +	{ADV748X_I2C_HDMI, 0xCB, 0x09},	/* ADI Required Write */
> +	{ADV748X_I2C_HDMI, 0x3D, 0x10},	/* ADI Required Write */
> +	{ADV748X_I2C_HDMI, 0x3E, 0x7B},	/* ADI Required Write */
> +	{ADV748X_I2C_HDMI, 0x3F, 0x5E},	/* ADI Required Write */
> +	{ADV748X_I2C_HDMI, 0x4E, 0xFE},	/* ADI Required Write */
> +	{ADV748X_I2C_HDMI, 0x4F, 0x18},	/* ADI Required Write */
> +	{ADV748X_I2C_HDMI, 0x57, 0xA3},	/* ADI Required Write */
> +	{ADV748X_I2C_HDMI, 0x58, 0x04},	/* ADI Required Write */
> +	{ADV748X_I2C_HDMI, 0x85, 0x10},	/* ADI Required Write */
> +
> +	{ADV748X_I2C_HDMI, 0x83, 0x00},	/* Enable All Terminations */
> +	{ADV748X_I2C_HDMI, 0xA3, 0x01},	/* ADI Required Write */
> +	{ADV748X_I2C_HDMI, 0xBE, 0x00},	/* ADI Required Write */
> +
> +	{ADV748X_I2C_HDMI, 0x6C, 0x01},	/* HPA Manual Enable */
> +	{ADV748X_I2C_HDMI, 0xF8, 0x01},	/* HPA Asserted */
> +	{ADV748X_I2C_HDMI, 0x0F, 0x00},	/* Audio Mute Speed Set to Fastest */
> +	/* (Smallest Step Size) */
> +
> +	{ADV748X_I2C_IO, 0x04, 0x02},	/* RGB Out of CP */
> +	{ADV748X_I2C_IO, 0x12, 0xF0},	/* CSC Depends on ip Packets, SDR 444 */
> +	{ADV748X_I2C_IO, 0x17, 0x80},	/* Luma & Chroma can reach 254d */
> +	{ADV748X_I2C_IO, 0x03, 0x86},	/* CP-Insert_AV_Code */
> +
> +	{ADV748X_I2C_CP, 0x7C, 0x00},	/* ADI Required Write */
> +
> +	{ADV748X_I2C_IO, 0x0C, 0xE0},	/* Enable LLC_DLL & Double LLC Timing */
> +	{ADV748X_I2C_IO, 0x0E, 0xDD},	/* LLC/PIX/SPI PINS TRISTATED AUD */
> +	/* Outputs Enabled */
> +	{ADV748X_I2C_IO, 0x10, 0xA0},	/* Enable 4-lane CSI Tx & Pixel Port */
> +
> +	{ADV748X_I2C_TXA, 0x00, 0x84},	/* Enable 4-lane MIPI */
> +	{ADV748X_I2C_TXA, 0x00, 0xA4},	/* Set Auto DPHY Timing */
> +	{ADV748X_I2C_TXA, 0xDB, 0x10},	/* ADI Required Write */
> +	{ADV748X_I2C_TXA, 0xD6, 0x07},	/* ADI Required Write */
> +	{ADV748X_I2C_TXA, 0xC4, 0x0A},	/* ADI Required Write */
> +	{ADV748X_I2C_TXA, 0x71, 0x33},	/* ADI Required Write */
> +	{ADV748X_I2C_TXA, 0x72, 0x11},	/* ADI Required Write */
> +	{ADV748X_I2C_TXA, 0xF0, 0x00},	/* i2c_dphy_pwdn - 1'b0 */
> +
> +	{ADV748X_I2C_TXA, 0x31, 0x82},	/* ADI Required Write */
> +	{ADV748X_I2C_TXA, 0x1E, 0x40},	/* ADI Required Write */
> +	{ADV748X_I2C_TXA, 0xDA, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> +	{ADV748X_I2C_WAIT, 0x00, 0x02},	/* delay 2 */
> +	{ADV748X_I2C_TXA, 0x00, 0x24 },	/* Power-up CSI-TX */
> +	{ADV748X_I2C_WAIT, 0x00, 0x01},	/* delay 1 */
> +	{ADV748X_I2C_TXA, 0xC1, 0x2B},	/* ADI Required Write */
> +	{ADV748X_I2C_WAIT, 0x00, 0x01},	/* delay 1 */
> +	{ADV748X_I2C_TXA, 0x31, 0x80},	/* ADI Required Write */
> +
> +#ifdef REL_DGB_FORCE_TO_SEND_COLORBAR
> +	{ADV748X_I2C_CP, 0x37, 0x81},	/* Output Colorbars Pattern */
> +#endif
> +	{ADV748X_I2C_EOR, 0xFF, 0xFF}	/* End of register table */
> +};
> +
> +/* TODO:KPB: Need to work out how to provide AFE port select! More entities? */
> +#define ADV748X_SDP_INPUT_CVBS_AIN8 0x07
> +
> +/* 02-01 Analog CVBS to MIPI TX-B CSI 1-Lane - */
> +/* Autodetect CVBS Single Ended In Ain 1 - MIPI Out */
> +static const struct adv748x_reg_value adv748x_init_txb_1lane[] = {
> +
> +	{ADV748X_I2C_IO, 0x00, 0x30},  /* Disable chip powerdown powerdown Rx */
> +	{ADV748X_I2C_IO, 0xF2, 0x01},  /* Enable I2C Read Auto-Increment */
> +
> +	{ADV748X_I2C_IO, 0x0E, 0xFF},  /* LLC/PIX/AUD/SPI PINS TRISTATED */
> +
> +	{ADV748X_I2C_SDP, 0x0f, 0x00}, /* Exit Power Down Mode */
> +	{ADV748X_I2C_SDP, 0x52, 0xCD},/* ADI Required Write */
> +	/* TODO: do not use hard codeded INSEL */
> +	{ADV748X_I2C_SDP, 0x00, ADV748X_SDP_INPUT_CVBS_AIN8},
> +	{ADV748X_I2C_SDP, 0x0E, 0x80},	/* ADI Required Write */
> +	{ADV748X_I2C_SDP, 0x9C, 0x00},	/* ADI Required Write */
> +	{ADV748X_I2C_SDP, 0x9C, 0xFF},	/* ADI Required Write */
> +	{ADV748X_I2C_SDP, 0x0E, 0x00},	/* ADI Required Write */
> +
> +	/* ADI recommended writes for improved video quality */
> +	{ADV748X_I2C_SDP, 0x80, 0x51},	/* ADI Required Write */
> +	{ADV748X_I2C_SDP, 0x81, 0x51},	/* ADI Required Write */
> +	{ADV748X_I2C_SDP, 0x82, 0x68},	/* ADI Required Write */
> +
> +	{ADV748X_I2C_SDP, 0x03, 0x42},  /* Tri-S Output , PwrDwn 656 pads */
> +	{ADV748X_I2C_SDP, 0x04, 0xB5},	/* ITU-R BT.656-4 compatible */
> +	{ADV748X_I2C_SDP, 0x13, 0x00},	/* ADI Required Write */
> +
> +	{ADV748X_I2C_SDP, 0x17, 0x41},	/* Select SH1 */
> +	{ADV748X_I2C_SDP, 0x31, 0x12},	/* ADI Required Write */
> +	{ADV748X_I2C_SDP, 0xE6, 0x4F},  /* V bit end pos manually in NTSC */
> +
> +	/* TODO: Convert this to a control option */
> +#ifdef REL_DGB_FORCE_TO_SEND_COLORBAR
> +	{ADV748X_I2C_SDP, 0x0C, 0x01},	/* ColorBar */
> +	{ADV748X_I2C_SDP, 0x14, 0x01},	/* ColorBar */
> +#endif
> +	/* Enable 1-Lane MIPI Tx, */
> +	/* enable pixel output and route SD through Pixel port */
> +	{ADV748X_I2C_IO, 0x10, 0x70},
> +
> +	{ADV748X_I2C_TXB, 0x00, 0x81},	/* Enable 1-lane MIPI */
> +	{ADV748X_I2C_TXB, 0x00, 0xA1},	/* Set Auto DPHY Timing */
> +	{ADV748X_I2C_TXB, 0xD2, 0x40},	/* ADI Required Write */
> +	{ADV748X_I2C_TXB, 0xC4, 0x0A},	/* ADI Required Write */
> +	{ADV748X_I2C_TXB, 0x71, 0x33},	/* ADI Required Write */
> +	{ADV748X_I2C_TXB, 0x72, 0x11},	/* ADI Required Write */
> +	{ADV748X_I2C_TXB, 0xF0, 0x00},	/* i2c_dphy_pwdn - 1'b0 */
> +	{ADV748X_I2C_TXB, 0x31, 0x82},	/* ADI Required Write */
> +	{ADV748X_I2C_TXB, 0x1E, 0x40},	/* ADI Required Write */
> +	{ADV748X_I2C_TXB, 0xDA, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
> +
> +	{ADV748X_I2C_WAIT, 0x00, 0x02},	/* delay 2 */
> +	{ADV748X_I2C_TXB, 0x00, 0x21 },	/* Power-up CSI-TX */
> +	{ADV748X_I2C_WAIT, 0x00, 0x01},	/* delay 1 */
> +	{ADV748X_I2C_TXB, 0xC1, 0x2B},	/* ADI Required Write */
> +	{ADV748X_I2C_WAIT, 0x00, 0x01},	/* delay 1 */
> +	{ADV748X_I2C_TXB, 0x31, 0x80},	/* ADI Required Write */
> +
> +	{ADV748X_I2C_EOR, 0xFF, 0xFF}	/* End of register table */
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
> +	/* Set VC 0 */
> +	txa_clrset(state, 0x0d, 0xc0, 0x00);
> +
> +	/* Init and power down TXB */
> +	ret = adv748x_write_regs(state, adv748x_init_txb_1lane);
> +	if (ret)
> +		return ret;
> +
> +	adv748x_txb_power(state, 0);
> +
> +	/* Set VC 0 */
> +	txb_clrset(state, 0x0d, 0xc0, 0x00);
> +
> +	/* Disable chip powerdown & Enable HDMI Rx block */
> +	io_write(state, 0x00, 0x40);
> +
> +	/* Enable 4-lane CSI Tx & Pixel Port */
> +	io_write(state, 0x10, 0xe0);
> +
> +	/* Use vid_std and v_freq as freerun resolution for CP */
> +	cp_clrset(state, 0xc9, 0x01, 0x01);
> +
> +	return 0;
> +}
> +
> +static int adv748x_print_info(struct adv748x_state *state)
> +{
> +	int msb, lsb;
> +
> +	lsb = io_read(state, 0xdf);
> +	msb = io_read(state, 0xe0);
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
> +		const struct v4l2_subdev_ops *ops, const char *ident)
> +{
> +	v4l2_subdev_init(sd, ops);
> +	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +
> +	/* the owner is the same as the i2c_client's driver owner */
> +	sd->owner = state->dev->driver->owner;
> +	sd->dev = state->dev;
> +
> +	v4l2_set_subdevdata(sd, state);

A lot of this would be done by v4l2_i2c_subdev_init(). You'd have to
relinquish your use of v4l2_set_subdevdata() --- it always points to the I²C
client in that case. You'll just need to dig your device state in a bit
different manner in that case.

> +
> +	/* initialize name */
> +	snprintf(sd->name, sizeof(sd->name), "%s %d-%04x %s",
> +		state->dev->driver->name,
> +		i2c_adapter_id(state->client->adapter),
> +		state->client->addr, ident);
> +
> +	sd->entity.function = MEDIA_ENT_F_ATV_DECODER;
> +	sd->entity.ops = &adv748x_media_ops;
> +}
> +
> +static int adv748x_parse_dt(struct adv748x_state *state)
> +{
> +	struct device_node *ep_np = NULL;
> +	struct of_endpoint ep;
> +	unsigned int found = 0;
> +	int ret;
> +

Would of_graph_get_remote_node() do this more simple? Not necessarily, just
wondering.

> +	for_each_endpoint_of_node(state->dev->of_node, ep_np) {
> +		ret = of_graph_parse_endpoint(ep_np, &ep);
> +		if (!ret) {
> +			adv_info(state, "Endpoint %s on port %d",
> +					of_node_full_name(ep.local_node),
> +					ep.port);
> +
> +			if (ep.port > ADV748X_PORT_MAX) {
> +				adv_err(state, "Invalid endpoint %s on port %d",
> +					of_node_full_name(ep.local_node),
> +					ep.port);
> +
> +				continue;
> +			}
> +
> +			state->endpoints[ep.port] = ep_np;
> +			found++;
> +		}
> +	}
> +
> +	return found ? 0 : -ENODEV;
> +}
> +
> +int adv748x_setup_links(struct adv748x_state *state)
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
> +
> +	/* TXA - Default link is with HDMI */
> +	ret = media_create_pad_link(&state->hdmi.sd.entity, 1,
> +				    &state->txa.sd.entity, 0, enabled);
> +	if (ret) {
> +		adv_err(state, "Failed to create HDMI-TXA pad links");
> +		return ret;
> +	}
> +
> +#ifndef ADV748x_DEV_STATIC_LINKS
> +	ret = media_create_pad_link(&state->afe.sd.entity, ADV748X_AFE_SOURCE,
> +				    &state->txa.sd.entity, 0, 0);
> +	if (ret) {
> +		adv_err(state, "Failed to create AFE-TXA pad links");
> +		return ret;
> +	}
> +#endif
> +
> +	/* TXB - Can only output from the AFE */
> +	ret = media_create_pad_link(&state->afe.sd.entity, ADV748X_AFE_SOURCE,
> +				    &state->txb.sd.entity, 0, enabled);
> +	if (ret) {
> +		adv_err(state, "Failed to create AFE-TXB pad links");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int adv748x_probe(struct i2c_client *client,
> +			 const struct i2c_device_id *id)
> +{
> +	struct adv748x_state *state;
> +	struct device_node *ep;
> +	int ret;
> +
> +	/* Check if the adapter supports the needed features */
> +	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
> +		return -EIO;
> +
> +	state = devm_kzalloc(&client->dev, sizeof(struct adv748x_state),
> +			     GFP_KERNEL);
> +	if (!state)
> +		return -ENOMEM;
> +
> +	mutex_init(&state->mutex);
> +
> +	state->dev = &client->dev;
> +	state->client = client;
> +	i2c_set_clientdata(client, state);
> +
> +	/* SW reset ADV748X to its default values */
> +	ret = adv748x_reset(state);
> +	if (ret) {
> +		adv_err(state, "Failed to reset hardware");
> +		return ret;

Remember mutex_destroy(&state->mutex); . Perhaps worth using goto?

> +	}
> +
> +	ret = adv748x_print_info(state);
> +	if (ret)
> +		return ret;
> +
> +	/* Discover and process ports declared by the Device tree endpoints */
> +	ret = adv748x_parse_dt(state);
> +	if (ret)
> +		return ret;
> +
> +	/* Process HDMI/TXA */
> +	if (state->endpoints[ADV748X_PORT_HDMI]) {
> +		ep = state->endpoints[ADV748X_PORT_HDMI];
> +		adv_info(state, "Got TXA/HDMI EP: %s\n", of_node_full_name(ep));
> +
> +		/* Initialise HDMI */
> +		ret = adv748x_hdmi_probe(state, ep);
> +		if (ret) {
> +			adv_err(state, "Failed to probe HDMI");
> +			return ret;
> +		}
> +	} else {
> +		adv_err(state, "No HDMI endpoint found at %s",
> +				of_node_full_name(state->dev->of_node));
> +	}
> +
> +	/* Process AFE/TXB */
> +	/* TODO: EEP - HARDWARED AFE */
> +	if (state->endpoints[ADV748X_PORT_AIN8]) {
> +		ep = state->endpoints[ADV748X_PORT_AIN8];
> +		adv_info(state, "Got TXB/AFE EP: %s\n", of_node_full_name(ep));
> +
> +		/* Initialise AFE */
> +		ret = adv748x_afe_probe(state, ep);
> +		if (ret) {
> +			adv_err(state, "Failed to probe AFE");
> +			return ret;
> +		}
> +	} else {
> +		/* if has_afe(state) */
> +		adv_err(state, "No AFE endpoint found at %s",
> +				of_node_full_name(state->dev->of_node));
> +	}
> +
> +
> +	/* Initialise TXA */
> +	ret = adv748x_csi2_probe(state, &state->txa);
> +	if (ret) {
> +		adv_err(state, "Failed to probe TXA");
> +		return ret;
> +	}
> +
> +	/* Initialise TXB  (Not 7480) */
> +	ret = adv748x_csi2_probe(state, &state->txb);

Don't forget to clean up state->txa if this fails.

> +	if (ret) {
> +		adv_err(state, "Failed to probe TXB");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int adv748x_remove(struct i2c_client *client)
> +{
> +	struct adv748x_state *state = i2c_get_clientdata(client);
> +
> +	adv748x_afe_remove(state);
> +	adv748x_hdmi_remove(state);
> +
> +	adv748x_csi2_remove(&state->txa);
> +	adv748x_csi2_remove(&state->txb);
> +
> +	mutex_destroy(&state->mutex);
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
> +		.of_match_table = of_match_ptr(adv748x_of_table),
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
> index 000000000000..d0a0fcfeae2e
> --- /dev/null
> +++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
> @@ -0,0 +1,373 @@
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
> +	return (tx == &tx->state->txa);

The parentheses are extra.

> +}
> +
> +static struct v4l2_subdev *adv748x_csi2_get_remote_sd(struct media_pad *local)
> +{
> +	struct media_pad *pad;
> +
> +	pad = media_entity_remote_pad(local);
> +	if (!pad) {
> +		return NULL;

if (...)
	return NULL;

> +	}
> +
> +	return media_entity_to_v4l2_subdev(pad->entity);

Or:

return pad ? media...(pad->entity) : NULL;

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
> +static int adv748x_csi2_notify_complete(struct v4l2_async_notifier *notifier)
> +{
> +	struct adv748x_csi2 *tx = notifier_to_csi2(notifier);
> +	struct adv748x_state *state = tx->state;
> +	int ret;
> +
> +	ret = v4l2_device_register_subdev_nodes(tx->sd.v4l2_dev);
> +	if (ret) {
> +		adv_err(state, "Failed to register subdev nodes\n");
> +		return ret;
> +	}
> +
> +	/* Return early until we register TXB */
> +	if (is_txa(tx))
> +		return ret;
> +
> +	ret = adv748x_setup_links(state);

Could you set up links first? It'd be really annoying to clean up the mess
after the sub-device nodes have been registered. Actually --- it's not even
doable at the moment.

> +	if (ret) {
> +		adv_err(state, "Failed to setup entity links");
> +		return ret;
> +	}
> +
> +	return ret;
> +}
> +
> +static int adv748x_csi2_notify_bound(struct v4l2_async_notifier *notifier,
> +				   struct v4l2_subdev *subdev,
> +				   struct v4l2_async_subdev *asd)
> +{
> +	struct adv748x_csi2 *tx = notifier_to_csi2(notifier);
> +	struct adv748x_state *state = tx->state;
> +
> +	v4l2_set_subdev_hostdata(subdev, tx);
> +
> +	adv_info(state, "Bind %s -> %s", is_txa(tx)? "TXA":"TXB", subdev->name);
> +
> +	return 0;
> +}
> +static void adv748x_csi2_notify_unbind(struct v4l2_async_notifier *notifier,
> +				     struct v4l2_subdev *subdev,
> +				     struct v4l2_async_subdev *asd)
> +{
> +	struct adv748x_csi2 *tx = notifier_to_csi2(notifier);
> +	struct adv748x_state *state = tx->state;
> +
> +	adv_info(state, "Unbind %s -> %s", is_txa(tx)? "TXA":"TXB",
> +			subdev->name);
> +}
> +
> +static int adv748x_csi2_registered(struct v4l2_subdev *sd)
> +{
> +	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
> +	struct adv748x_state *state = tx->state;
> +	int ret;
> +
> +	adv_info(state, "Registered %s (%s)", is_txa(tx)? "TXA":"TXB",
> +			sd->name);
> +
> +	/*
> +	 * Register HDMI on TXA, and AFE on TXB.
> +	 */
> +	if (is_txa(tx)) {
> +		tx->subdevs[0].match_type = V4L2_ASYNC_MATCH_FWNODE;
> +		tx->subdevs[0].match.fwnode.fwnode =
> +			of_fwnode_handle(state->endpoints[ADV748X_PORT_HDMI]);
> +	} else {
> +		/* TODO: This isn't right - Hardwiring to AIN8 ... ???? */
> +		tx->subdevs[0].match_type = V4L2_ASYNC_MATCH_FWNODE;
> +		tx->subdevs[0].match.fwnode.fwnode =
> +			of_fwnode_handle(state->endpoints[ADV748X_PORT_AIN8]);
> +	}
> +
> +	tx->subdev_p[0] = &tx->subdevs[0];
> +
> +	tx->notifier.num_subdevs = 1;
> +	tx->notifier.subdevs = tx->subdev_p;
> +
> +	tx->notifier.bound = adv748x_csi2_notify_bound;
> +	tx->notifier.unbind = adv748x_csi2_notify_unbind;
> +	tx->notifier.complete = adv748x_csi2_notify_complete;
> +
> +	ret = v4l2_async_subnotifier_register(&tx->sd, &tx->notifier);

How do things work out if there's a failure here? Any idea?

> +	if (ret < 0) {
> +		adv_err(state, "Notifier registration failed\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static void adv748x_csi2_unregistered(struct v4l2_subdev *sd)
> +{
> +	struct adv748x_csi2 *tx = container_of(sd, struct adv748x_csi2, sd);
> +
> +	v4l2_async_subnotifier_unregister(&tx->notifier);
> +}
> +
> +static const struct v4l2_subdev_internal_ops adv748x_csi2_internal_ops = {
> +	.registered = adv748x_csi2_registered,
> +	.unregistered = adv748x_csi2_unregistered,
> +};
> +
> +/* -----------------------------------------------------------------------------
> + * v4l2_subdev_pad_ops
> + */
> +
> +static int adv748x_csi2_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +	struct adv748x_csi2 *tx = adv748x_sd_to_csi2(sd);
> +	struct v4l2_subdev *src;
> +	int ret;
> +
> +	src = adv748x_csi2_get_remote_sd(&tx->pads[ADV748X_CSI2_SINK]);
> +	if (!src)
> +		return -ENODEV;
> +
> +	ret = v4l2_subdev_call(src, video, s_stream, enable);

return v4l2_subdev_call();

> +
> +	return ret;
> +}
> +
> +static const struct v4l2_subdev_video_ops adv748x_csi2_video_ops = {
> +	.s_stream = adv748x_csi2_s_stream,
> +};
> +
> +/* -----------------------------------------------------------------------------
> + * v4l2_subdev_pad_ops
> + *
> + * The CSI2 bus pads, are ignorant to the data sizes or formats.
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
> +	switch (which) {
> +	case V4L2_SUBDEV_FORMAT_TRY:
> +		return v4l2_subdev_get_try_format(sd, cfg, pad);
> +	case V4L2_SUBDEV_FORMAT_ACTIVE:
> +		return &tx->format;
> +	default:

This won't happen. I think a lot of drivers assume that.

> +		return NULL;
> +	}
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
> +	struct media_pad *pad = &tx->pads[sdformat->pad];
> +	struct v4l2_mbus_framefmt *mbusformat;
> +
> +	mbusformat = adv748x_csi2_get_pad_format(sd, cfg, sdformat->pad,
> +						 sdformat->which);
> +	if (!mbusformat)
> +		return -EINVAL;
> +
> +	mutex_lock(&state->mutex);
> +
> +	if (pad->flags & MEDIA_PAD_FL_SOURCE)
> +		sdformat->format = tx->format;
> +
> +	*mbusformat = sdformat->format;
> +
> +	mutex_unlock(&state->mutex);
> +
> +	return 0;
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
> +static int adv748x_csi2_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct adv748x_csi2 *tx = container_of(ctrl->handler,
> +					struct adv748x_csi2, ctrl_hdl);
> +	struct adv748x_state *state = tx->state;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_PIXEL_RATE:
> +	{
> +		/* Direct control pass through */
> +		struct v4l2_ext_controls ctrls;
> +		struct v4l2_ext_control ectrl;
> +		struct v4l2_subdev *src;
> +		int ret;
> +
> +		src = adv748x_csi2_get_remote_sd(&tx->pads[ADV748X_CSI2_SINK]);
> +		if (!src)
> +			return -ENODEV;
> +
> +		memset(&ctrls, 0, sizeof(ctrls));
> +		memset(&ectrl, 0, sizeof(ectrl));
> +
> +		ectrl.id = V4L2_CID_PIXEL_RATE;
> +
> +		ctrls.count = 1;
> +		ctrls.controls = &ectrl;

Can you use v4l2_ctrl_g_ctrl_int64()?

> +
> +		ret = v4l2_g_ext_ctrls(src->ctrl_handler, &ctrls);
> +		if (ret < 0) {
> +			adv_err(state, "%s: subdev link freq control failed\n",
> +				tx->sd.name);
> +			return ret;
> +		}
> +
> +		*ctrl->p_new.p_s64 = ectrl.value64;
> +
> +		break;
> +	}
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_ctrl_ops adv748x_csi2_ctrl_ops = {
> +	.g_volatile_ctrl = adv748x_csi2_g_volatile_ctrl,
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
> +	if (ctrl)
> +		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
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
> +int adv748x_csi2_probe(struct adv748x_state *state, struct adv748x_csi2 *tx)
> +{
> +	struct device_node *ep;
> +	int ret;
> +
> +	/* We can not use container_of to get back to the state with two TXs */
> +	tx->state = state;
> +
> +	adv748x_subdev_init(&tx->sd, state, &adv748x_csi2_ops,
> +			is_txa(tx) ? "txa" : "txb");
> +
> +	ep = state->endpoints[is_txa(tx) ? ADV748X_PORT_TXA : ADV748X_PORT_TXB];
> +
> +	/* Ensure that matching is based upon the endpoint fwnodes */
> +	tx->sd.fwnode = of_fwnode_handle(ep);
> +
> +	/* Register internal ops for Incremental subdev discovery */
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
> +		return ret;
> +
> +	ret = v4l2_async_register_subdev(&tx->sd);

Clean up the control handler on error?

> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +
> +void adv748x_csi2_remove(struct adv748x_csi2 *tx)
> +{
> +	v4l2_async_unregister_subdev(&tx->sd);
> +	media_entity_cleanup(&tx->sd.entity);
> +}
> diff --git a/drivers/media/i2c/adv748x/adv748x-hdmi.c b/drivers/media/i2c/adv748x/adv748x-hdmi.c
> new file mode 100644
> index 000000000000..19c1bd41cc6c
> --- /dev/null
> +++ b/drivers/media/i2c/adv748x/adv748x-hdmi.c
> @@ -0,0 +1,671 @@
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
> +#include <linux/v4l2-dv-timings.h>

Why is that header here...? Is it a uAPI header? Then add uapi/.

> +
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-dv-timings.h>
> +#include <media/v4l2-ioctl.h>
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
> +#define ADV748X_HDMI_MAX_PIXELCLOCK	162000000
> +
> +static const struct v4l2_dv_timings_cap adv748x_hdmi_timings_cap = {
> +	.type = V4L2_DV_BT_656_1120,
> +	/* keep this initialization for compatibility with GCC < 4.4.6 */
> +	.reserved = { 0 },

Is this necessary? Aren't the uninitialised fields zeroed if any field in a
struct is initialised, also on those versions of GCC? (Of course there have
been bugs, but nothing rings a bell.)

> +	/* Min pixelclock value is unknown */
> +	V4L2_INIT_BT_TIMINGS(ADV748X_HDMI_MIN_WIDTH, ADV748X_HDMI_MAX_WIDTH,
> +			     ADV748X_HDMI_MIN_HEIGHT, ADV748X_HDMI_MAX_HEIGHT,
> +			     ADV748X_HDMI_MIN_PIXELCLOCK,
> +			     ADV748X_HDMI_MAX_PIXELCLOCK,
> +			     V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT,
> +			     V4L2_DV_BT_CAP_INTERLACED |
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
> +	/* End of standards */
> +	{ },
> +};
> +
> +static void adv748x_hdmi_fill_format(struct adv748x_state *state,
> +				     struct v4l2_mbus_framefmt *fmt)
> +{
> +	memset(fmt, 0, sizeof(*fmt));
> +
> +	fmt->code = MEDIA_BUS_FMT_RGB888_1X24;
> +	fmt->colorspace = V4L2_COLORSPACE_SRGB;
> +	fmt->field = state->hdmi.timings.bt.interlaced ?
> +		V4L2_FIELD_INTERLACED : V4L2_FIELD_NONE;
> +
> +	fmt->width = state->hdmi.timings.bt.width;
> +	fmt->height = state->hdmi.timings.bt.height;
> +}
> +
> +static void adv748x_fill_optional_dv_timings(struct adv748x_state *state,
> +					     struct v4l2_dv_timings *timings)
> +{
> +	v4l2_find_dv_timings_cap(timings, &adv748x_hdmi_timings_cap,
> +				 250000, NULL, NULL);
> +}
> +
> +static bool adv748x_hdmi_have_signal(struct adv748x_state *state)
> +{
> +	int val;
> +
> +	/* Check that VERT_FILTER and DG_REGEN is locked */
> +	val = hdmi_read(state, 0x07);
> +	return !!((val & BIT(7)) && (val & BIT(5)));

No need for !!; casting non-zero value to bool will be true.

> +}
> +
> +static unsigned int adv748x_hdmi_read_pixelclock(struct adv748x_state *state)
> +{
> +	int a, b;
> +
> +	a = hdmi_read(state, 0x51);
> +	b = hdmi_read(state, 0x52);
> +	if (a < 0 || b < 0)
> +		return 0;

I think I'd have explicit error handling. A lot of users of the control
value would be upset if they'd get 0.

> +	return ((a << 1) | (b >> 7)) * 1000000 + (b & 0x7f) * 1000000 / 128;
> +}
> +
> +static int adv748x_hdmi_set_video_timings(struct adv748x_state *state,
> +					  const struct v4l2_dv_timings *timings)
> +{
> +	const struct adv748x_hdmi_video_standards *stds =
> +		adv748x_hdmi_video_standards;
> +	int i;
> +
> +	for (i = 0; stds[i].timings.bt.width; i++) {
> +		if (!v4l2_match_dv_timings(timings, &stds[i].timings, 250000,
> +					   false))
> +			continue;
> +		/*
> +		 * The resolution of 720p, 1080i and 1080p is Hsync width of
> +		 * 40 pixelclock cycles. These resolutions must be shifted
> +		 * horizontally to the left in active video mode.
> +		 */
> +		switch (stds[i].vid_std) {
> +		case 0x53: /* 720p */
> +			cp_write(state, 0x8B, 0x43);
> +			cp_write(state, 0x8C, 0xD8);
> +			cp_write(state, 0x8B, 0x4F);
> +			cp_write(state, 0x8D, 0xD8);
> +			break;
> +		case 0x54: /* 1080i */
> +		case 0x5e: /* 1080p */
> +			cp_write(state, 0x8B, 0x43);
> +			cp_write(state, 0x8C, 0xD4);
> +			cp_write(state, 0x8B, 0x4F);
> +			cp_write(state, 0x8D, 0xD4);
> +			break;
> +		default:
> +			cp_write(state, 0x8B, 0x40);
> +			cp_write(state, 0x8C, 0x00);
> +			cp_write(state, 0x8B, 0x40);
> +			cp_write(state, 0x8D, 0x00);
> +			break;
> +		}
> +
> +		io_write(state, 0x05, stds[i].vid_std);
> +		io_clrset(state, 0x03, 0x70, stds[i].v_freq << 4);
> +
> +		return 0;
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * v4l2_subdev_video_ops
> + */
> +
> +static int adv748x_hdmi_s_dv_timings(struct v4l2_subdev *sd,
> +				     struct v4l2_dv_timings *timings)
> +{
> +	struct adv748x_state *state = adv748x_hdmi_to_state(sd);
> +	struct v4l2_bt_timings *bt;
> +	int ret;
> +
> +	if (!timings)
> +		return -EINVAL;
> +
> +	if (v4l2_match_dv_timings(&state->hdmi.timings, timings, 0, false))
> +		return 0;
> +
> +	bt = &timings->bt;

You're using this once...

> +
> +	if (!v4l2_valid_dv_timings(timings, &adv748x_hdmi_timings_cap,
> +				   NULL, NULL))
> +		return -ERANGE;
> +
> +	adv748x_fill_optional_dv_timings(state, timings);
> +
> +	ret = adv748x_hdmi_set_video_timings(state, timings);
> +	if (ret)
> +		return ret;
> +
> +	state->hdmi.timings = *timings;
> +
> +	cp_clrset(state, 0x91, 0x40, bt->interlaced ? 0x40 : 0x00);

timings->bt.interlaced ?

> +
> +	return 0;
> +}
> +
> +static int adv748x_hdmi_g_dv_timings(struct v4l2_subdev *sd,
> +				     struct v4l2_dv_timings *timings)
> +{
> +	struct adv748x_state *state = adv748x_hdmi_to_state(sd);
> +
> +	*timings = state->hdmi.timings;
> +
> +	return 0;
> +}
> +
> +static int adv748x_hdmi_query_dv_timings(struct v4l2_subdev *sd,
> +					 struct v4l2_dv_timings *timings)
> +{
> +	struct adv748x_state *state = adv748x_hdmi_to_state(sd);
> +	struct v4l2_bt_timings *bt = &timings->bt;
> +	int tmp;
> +
> +	if (!timings)
> +		return -EINVAL;
> +
> +	memset(timings, 0, sizeof(struct v4l2_dv_timings));
> +
> +	if (!adv748x_hdmi_have_signal(state))
> +		return -ENOLINK;
> +
> +	timings->type = V4L2_DV_BT_656_1120;
> +
> +	bt->interlaced = hdmi_read(state, 0x0b) & BIT(5) ?
> +		V4L2_DV_INTERLACED : V4L2_DV_PROGRESSIVE;
> +
> +	bt->width = hdmi_read16(state, 0x07, 0x1fff);
> +	bt->height = hdmi_read16(state, 0x09, 0x1fff);
> +	bt->hfrontporch = hdmi_read16(state, 0x20, 0x1fff);
> +	bt->hsync = hdmi_read16(state, 0x22, 0x1fff);
> +	bt->hbackporch = hdmi_read16(state, 0x24, 0x1fff);
> +	bt->vfrontporch = hdmi_read16(state, 0x2a, 0x3fff) / 2;
> +	bt->vsync = hdmi_read16(state, 0x2e, 0x3fff) / 2;
> +	bt->vbackporch = hdmi_read16(state, 0x32, 0x3fff) / 2;
> +
> +	bt->pixelclock = adv748x_hdmi_read_pixelclock(state);
> +
> +	tmp = hdmi_read(state, 0x05);
> +	bt->polarities = (tmp & BIT(4) ? V4L2_DV_VSYNC_POS_POL : 0) |
> +		(tmp & BIT(5) ? V4L2_DV_HSYNC_POS_POL : 0);
> +
> +	if (bt->interlaced == V4L2_DV_INTERLACED) {
> +		bt->height += hdmi_read16(state, 0x0b, 0x1fff);
> +		bt->il_vfrontporch = hdmi_read16(state, 0x2c, 0x3fff) / 2;
> +		bt->il_vsync = hdmi_read16(state, 0x30, 0x3fff) / 2;
> +		bt->il_vbackporch = hdmi_read16(state, 0x34, 0x3fff) / 2;
> +	}
> +
> +	adv748x_fill_optional_dv_timings(state, timings);
> +
> +	if (!adv748x_hdmi_have_signal(state)) {
> +		adv_info(state, "HDMI signal lost during readout\n");
> +		return -ENOLINK;
> +	}
> +
> +	/*
> +	 * TODO: No interrupt handling is implemented yet.
> +	 * There should be an IRQ when a cable is plugged and a the new
> +	 * timings figured out and stored to state. This the next best thing
> +	 */
> +	state->hdmi.timings = *timings;
> +
> +	adv_dbg(state, "HDMI %dx%d%c clock: %llu Hz pol: %x "
> +		"hfront: %d hsync: %d hback: %d "
> +		"vfront: %d vsync: %d vback: %d "
> +		"il_vfron: %d il_vsync: %d il_vback: %d\n",
> +		bt->width, bt->height,
> +		bt->interlaced == V4L2_DV_INTERLACED ? 'i' : 'p',
> +		bt->pixelclock, bt->polarities,
> +		bt->hfrontporch, bt->hsync, bt->hbackporch,
> +		bt->vfrontporch, bt->vsync, bt->vbackporch,
> +		bt->il_vfrontporch, bt->il_vsync, bt->il_vbackporch);
> +
> +	return 0;
> +}
> +
> +static int adv748x_hdmi_g_input_status(struct v4l2_subdev *sd, u32 *status)
> +{
> +	struct adv748x_state *state = adv748x_hdmi_to_state(sd);
> +	int ret;
> +
> +	ret = mutex_lock_interruptible(&state->mutex);
> +	if (ret)
> +		return ret;
> +
> +	*status = adv748x_hdmi_have_signal(state) ? 0 : V4L2_IN_ST_NO_SIGNAL;
> +
> +	mutex_unlock(&state->mutex);
> +
> +	return ret;
> +}
> +
> +static int adv748x_hdmi_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +	struct adv748x_state *state = adv748x_hdmi_to_state(sd);
> +	int ret;
> +
> +	ret = mutex_lock_interruptible(&state->mutex);
> +	if (ret)
> +		return ret;
> +
> +	ret = adv748x_txa_power(state, enable);
> +	if (ret)
> +		goto error;
> +
> +	if (adv748x_hdmi_have_signal(state))
> +		adv_dbg(state, "Detected HDMI signal\n");
> +	else
> +		adv_info(state, "Couldn't detect HDMI video signal\n");
> +
> +error:
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
> +static int adv748x_hdmi_enum_mbus_code(struct v4l2_subdev *sd,
> +				  struct v4l2_subdev_pad_config *cfg,
> +				  struct v4l2_subdev_mbus_code_enum *code)
> +{
> +	if (code->index != 0)
> +		return -EINVAL;
> +
> +	if (code->pad >= ADV748X_HDMI_NR_PADS)
> +		return -EINVAL;

Checked in v4l2-subdev.c.

> +
> +	code->code = MEDIA_BUS_FMT_RGB888_1X24;
> +
> +	return 0;
> +}
> +
> +static int adv748x_hdmi_get_pad_format(struct v4l2_subdev *sd,
> +				  struct v4l2_subdev_pad_config *cfg,
> +				  struct v4l2_subdev_format *format)
> +{
> +	struct adv748x_state *state = adv748x_hdmi_to_state(sd);
> +
> +	if (format->pad >= ADV748X_HDMI_NR_PADS)
> +		return -EINVAL;

Ditto.

> +
> +	adv748x_hdmi_fill_format(state, &format->format);
> +
> +	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
> +		struct v4l2_mbus_framefmt *fmt;
> +
> +		fmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
> +		format->format.code = fmt->code;
> +	}
> +
> +	return 0;
> +}
> +
> +static int adv748x_hdmi_set_pad_format(struct v4l2_subdev *sd,
> +				       struct v4l2_subdev_pad_config *cfg,
> +				       struct v4l2_subdev_format *format)
> +{
> +	struct adv748x_state *state = adv748x_hdmi_to_state(sd);
> +
> +	if (format->pad >= ADV748X_HDMI_NR_PADS)
> +		return -EINVAL;

Ditto.

> +
> +	adv748x_hdmi_fill_format(state, &format->format);
> +
> +	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
> +		struct v4l2_mbus_framefmt *fmt;
> +
> +		fmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
> +		fmt->code = format->format.code;
> +	}
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
> +	.set_fmt = adv748x_hdmi_set_pad_format,
> +	.get_fmt = adv748x_hdmi_get_pad_format,
> +	.dv_timings_cap = adv748x_hdmi_dv_timings_cap,
> +	.enum_dv_timings = adv748x_hdmi_enum_dv_timings,
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
> +/* Contrast Control */
> +#define ADV748X_HDMI_CON_REG	0x3a	/* Contrast (unsigned) */
> +#define ADV748X_HDMI_CON_MIN	0	/* Minimum contrast */
> +#define ADV748X_HDMI_CON_DEF	128	/* Default */
> +#define ADV748X_HDMI_CON_MAX	255	/* Maximum contrast */
> +
> +/* Saturation Control */
> +#define ADV748X_HDMI_SAT_REG	0x3b	/* Saturation (unsigned) */
> +#define ADV748X_HDMI_SAT_MIN	0	/* Minimum saturation */
> +#define ADV748X_HDMI_SAT_DEF	128	/* Default */
> +#define ADV748X_HDMI_SAT_MAX	255	/* Maximum saturation */
> +
> +/* Brightness Control */
> +#define ADV748X_HDMI_BRI_REG	0x3c	/* Brightness (signed) */
> +#define ADV748X_HDMI_BRI_MIN	-128	/* Luma is -512d */
> +#define ADV748X_HDMI_BRI_DEF	0	/* Luma is 0 */
> +#define ADV748X_HDMI_BRI_MAX	127	/* Luma is 508d */
> +
> +/* Hue Control */
> +#define ADV748X_HDMI_HUE_REG	0x3d	/* Hue (unsigned) */
> +#define ADV748X_HDMI_HUE_MIN	0	/* -90 degree */
> +#define ADV748X_HDMI_HUE_DEF	0	/* -90 degree */
> +#define ADV748X_HDMI_HUE_MAX	255	/* +90 degree */
> +
> +/* Video adjustment register */
> +#define ADV748X_HDMI_VID_ADJ_REG		0x3e
> +/* Video adjustment mask */
> +#define ADV748X_HDMI_VID_ADJ_MASK		0x7F
> +/* Enable color controls */
> +#define ADV748X_HDMI_VID_ADJ_ENABLE	0x80
> +
> +static int __adv748x_hdmi_s_ctrl(struct v4l2_ctrl *ctrl,
> +				 struct adv748x_state *state)
> +{
> +	int ret;
> +
> +	/* Enable video adjustment first */
> +	ret = cp_read(state, ADV748X_HDMI_VID_ADJ_REG);
> +	if (ret < 0)
> +		return ret;
> +	ret |= ADV748X_HDMI_VID_ADJ_ENABLE;
> +
> +	ret = cp_write(state, ADV748X_HDMI_VID_ADJ_REG, ret);
> +	if (ret < 0)
> +		return ret;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_BRIGHTNESS:
> +		if (ctrl->val < ADV748X_HDMI_BRI_MIN ||
> +		    ctrl->val > ADV748X_HDMI_BRI_MAX)
> +			return -ERANGE;
> +
> +		ret = cp_write(state, ADV748X_HDMI_BRI_REG, ctrl->val);
> +		break;
> +	case V4L2_CID_HUE:
> +		if (ctrl->val < ADV748X_HDMI_HUE_MIN ||
> +		    ctrl->val > ADV748X_HDMI_HUE_MAX)
> +			return -ERANGE;
> +
> +		ret = cp_write(state, ADV748X_HDMI_HUE_REG, ctrl->val);
> +		break;
> +	case V4L2_CID_CONTRAST:
> +		if (ctrl->val < ADV748X_HDMI_CON_MIN ||
> +		    ctrl->val > ADV748X_HDMI_CON_MAX)
> +			return -ERANGE;
> +
> +		ret = cp_write(state, ADV748X_HDMI_CON_REG, ctrl->val);
> +		break;
> +	case V4L2_CID_SATURATION:
> +		if (ctrl->val < ADV748X_HDMI_SAT_MIN ||
> +		    ctrl->val > ADV748X_HDMI_SAT_MAX)
> +			return -ERANGE;
> +
> +		ret = cp_write(state, ADV748X_HDMI_SAT_REG, ctrl->val);
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +
> +static int adv748x_hdmi_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct adv748x_state *state = container_of(ctrl->handler,
> +					struct adv748x_state, hdmi.ctrl_hdl);
> +	int ret;
> +
> +	ret = mutex_lock_interruptible(&state->mutex);

Could you use the same mutex for the control handler? It'd make things
simpler...

> +	if (ret)
> +		return ret;
> +
> +	ret = __adv748x_hdmi_s_ctrl(ctrl, state);
> +
> +	mutex_unlock(&state->mutex);
> +
> +	return ret;
> +}
> +
> +static int adv748x_hdmi_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct adv748x_state *state = container_of(ctrl->handler,
> +					struct adv748x_state, hdmi.ctrl_hdl);
> +	unsigned int width, height, fps;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_PIXEL_RATE:
> +	{
> +		struct v4l2_dv_timings timings;
> +		struct v4l2_bt_timings *bt = &timings.bt;
> +
> +		adv748x_hdmi_query_dv_timings(&state->hdmi.sd, &timings);
> +
> +		width = bt->width;
> +		height = bt->height;
> +		fps = DIV_ROUND_CLOSEST(bt->pixelclock,
> +					V4L2_DV_BT_FRAME_WIDTH(bt) *
> +					V4L2_DV_BT_FRAME_HEIGHT(bt));
> +
> +		*ctrl->p_new.p_s64 = width * height * fps;
> +		break;
> +	}
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_ctrl_ops adv748x_hdmi_ctrl_ops = {
> +	.s_ctrl = adv748x_hdmi_s_ctrl,
> +	.g_volatile_ctrl = adv748x_hdmi_g_volatile_ctrl,
> +};
> +
> +static int adv748x_hdmi_init_controls(struct adv748x_state *state)
> +{
> +	struct v4l2_ctrl *ctrl;
> +
> +	v4l2_ctrl_handler_init(&state->hdmi.ctrl_hdl, 5);
> +
> +	v4l2_ctrl_new_std(&state->hdmi.ctrl_hdl, &adv748x_hdmi_ctrl_ops,
> +			  V4L2_CID_BRIGHTNESS, ADV748X_HDMI_BRI_MIN,
> +			  ADV748X_HDMI_BRI_MAX, 1, ADV748X_HDMI_BRI_DEF);
> +	v4l2_ctrl_new_std(&state->hdmi.ctrl_hdl, &adv748x_hdmi_ctrl_ops,
> +			  V4L2_CID_CONTRAST, ADV748X_HDMI_CON_MIN,
> +			  ADV748X_HDMI_CON_MAX, 1, ADV748X_HDMI_CON_DEF);
> +	v4l2_ctrl_new_std(&state->hdmi.ctrl_hdl, &adv748x_hdmi_ctrl_ops,
> +			  V4L2_CID_SATURATION, ADV748X_HDMI_SAT_MIN,
> +			  ADV748X_HDMI_SAT_MAX, 1, ADV748X_HDMI_SAT_DEF);
> +	v4l2_ctrl_new_std(&state->hdmi.ctrl_hdl, &adv748x_hdmi_ctrl_ops,
> +			  V4L2_CID_HUE, ADV748X_HDMI_HUE_MIN,
> +			  ADV748X_HDMI_HUE_MAX, 1, ADV748X_HDMI_HUE_DEF);
> +	ctrl = v4l2_ctrl_new_std(&state->hdmi.ctrl_hdl, &adv748x_hdmi_ctrl_ops,
> +				 V4L2_CID_PIXEL_RATE, 1, INT_MAX, 1, 1);
> +	if (ctrl)
> +		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
> +
> +	state->hdmi.sd.ctrl_handler = &state->hdmi.ctrl_hdl;
> +	if (state->hdmi.ctrl_hdl.error) {
> +		v4l2_ctrl_handler_free(&state->hdmi.ctrl_hdl);
> +		return state->hdmi.ctrl_hdl.error;
> +	}
> +
> +	return v4l2_ctrl_handler_setup(&state->hdmi.ctrl_hdl);
> +}
> +
> +int adv748x_hdmi_probe(struct adv748x_state *state, struct device_node *ep)
> +{
> +	static const struct v4l2_dv_timings cea720x480 =
> +		V4L2_DV_BT_CEA_720X480I59_94;
> +	int ret;
> +
> +	state->hdmi.timings = cea720x480;
> +
> +	adv748x_subdev_init(&state->hdmi.sd, state, &adv748x_ops_hdmi, "hdmi");
> +
> +	/* HDMI is currently statically routed to TXA */
> +	state->hdmi.sd.fwnode = &ep->fwnode;
> +
> +	state->hdmi.pads[ADV748X_HDMI_SINK].flags = MEDIA_PAD_FL_SINK;
> +	state->hdmi.pads[ADV748X_HDMI_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
> +
> +	ret = media_entity_pads_init(&state->hdmi.sd.entity,
> +				     ADV748X_HDMI_NR_PADS, state->hdmi.pads);
> +	if (ret)
> +		return ret;
> +
> +	ret = adv748x_hdmi_init_controls(state);
> +	if (ret)
> +		return ret;
> +
> +	ret = v4l2_async_register_subdev(&state->hdmi.sd);
> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +void adv748x_hdmi_remove(struct adv748x_state *state)
> +{
> +	v4l2_async_unregister_subdev(&state->hdmi.sd);
> +	media_entity_cleanup(&state->hdmi.sd.entity);
> +	v4l2_ctrl_handler_free(&state->hdmi.ctrl_hdl);
> +}
> diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
> new file mode 100644
> index 000000000000..1943995a2bad
> --- /dev/null
> +++ b/drivers/media/i2c/adv748x/adv748x.h
> @@ -0,0 +1,201 @@
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
> +#define ADV748X_I2C_TXA			0x4A	/* CSI-TXA Map */
> +#define ADV748X_I2C_WAIT		0xFE	/* Wait x mesec */
> +#define ADV748X_I2C_EOR			0xFF	/* End Mark */
> +
> +/**
> + * enum adv748x_ports - Device tree port number definitions
> + *
> + * The ADV748X ports define the mapping between subdevices
> + * and the device tree specification
> + */
> +enum adv748x_ports {
> +	ADV748X_PORT_HDMI = 0,
> +	ADV748X_PORT_AIN1 = 1,
> +	ADV748X_PORT_AIN2 = 2,
> +	ADV748X_PORT_AIN3 = 3,
> +	ADV748X_PORT_AIN4 = 4,
> +	ADV748X_PORT_AIN5 = 5,
> +	ADV748X_PORT_AIN6 = 6,
> +	ADV748X_PORT_AIN7 = 7,
> +	ADV748X_PORT_AIN8 = 8,
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
> +/* CSI2 transmitters can have 3 internal connections, HDMI/AFE/TTL */
> +#define ADV748X_CSI2_MAX_SUBDEVS 3
> +
> +struct adv748x_csi2 {
> +	struct adv748x_state *state;
> +	struct v4l2_mbus_framefmt format;
> +
> +	struct media_pad pads[ADV748X_CSI2_NR_PADS];
> +	struct v4l2_ctrl_handler ctrl_hdl;
> +	struct v4l2_subdev sd;
> +
> +	/* Incremental async - not used now */
> +	struct v4l2_async_subdev subdevs[ADV748X_CSI2_MAX_SUBDEVS];
> +	struct v4l2_async_subdev *subdev_p[ADV748X_CSI2_MAX_SUBDEVS];
> +	struct v4l2_async_notifier notifier;
> +};
> +
> +#define notifier_to_csi2(n) container_of(n, struct adv748x_csi2, notifier)
> +#define adv748x_sd_to_csi2(a) container_of(a, struct adv748x_csi2, sd)
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
> +
> +	struct v4l2_dv_timings timings;
> +};
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
> +
> +	bool streaming;
> +	v4l2_std_id curr_norm;
> +};
> +
> +/**
> + * struct adv748x_state - State of ADV748X
> + * @dev:		(OF) device
> + * @client:		I2C client
> + * @mutex:		protect global state
> + *
> + * @endpoints:		parsed device node endpoints for each port
> + *
> + * @hdmi:		state of HDMI receiver context
> + * @sdp:		state of AFE receiver context
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
> +	struct adv748x_hdmi hdmi;
> +	struct adv748x_afe afe;
> +
> +	struct adv748x_csi2 txa;
> +	struct adv748x_csi2 txb;
> +};
> +
> +#define adv748x_hdmi_to_state(a) container_of(a, struct adv748x_state, hdmi.sd)
> +#define adv748x_afe_to_state(a) container_of(a, struct adv748x_state, afe.sd)
> +
> +#define adv_err(a, fmt, arg...)	dev_err(a->dev, fmt, ##arg)
> +#define adv_info(a, fmt, arg...) dev_info(a->dev, fmt, ##arg)
> +#define adv_dbg(a, fmt, arg...)	dev_dbg(a->dev, fmt, ##arg)
> +
> +/* Register handling */
> +int adv748x_read(struct adv748x_state *state, u8 addr, u8 reg);
> +int adv748x_write(struct adv748x_state *state, u8 addr, u8 reg, u8 value);
> +
> +#define io_read(s, r) adv748x_read(s, ADV748X_I2C_IO, r)
> +#define io_write(s, r, v) adv748x_write(s, ADV748X_I2C_IO, r, v)
> +#define io_clrset(s, r, m, v) io_write(s, r, (io_read(s, r) & ~m) | v)
> +
> +#define hdmi_read(s, r) adv748x_read(s, ADV748X_I2C_HDMI, r)
> +#define hdmi_read16(s, r, m) (((hdmi_read(s, r) << 8) | hdmi_read(s, r+1)) & m)
> +#define hdmi_write(s, r, v) adv748x_write(s, ADV748X_I2C_HDMI, r, v)
> +#define hdmi_clrset(s, r, m, v) hdmi_write(s, r, (hdmi_read(s, r) & ~m) | v)
> +
> +#define sdp_read(s, r) adv748x_read(s, ADV748X_I2C_SDP, r)
> +#define sdp_write(s, r, v) adv748x_write(s, ADV748X_I2C_SDP, r, v)
> +#define sdp_clrset(s, r, m, v) sdp_write(s, r, (sdp_read(s, r) & ~m) | v)
> +
> +#define cp_read(s, r) adv748x_read(s, ADV748X_I2C_CP, r)
> +#define cp_write(s, r, v) adv748x_write(s, ADV748X_I2C_CP, r, v)
> +#define cp_clrset(s, r, m, v) cp_write(s, r, (cp_read(s, r) & ~m) | v)
> +
> +#define txa_read(s, r) adv748x_read(s, ADV748X_I2C_TXA, r)
> +#define txa_write(s, r, v) adv748x_write(s, ADV748X_I2C_TXA, r, v)
> +#define txa_clrset(s, r, m, v) txa_write(s, r, (txa_read(s, r) & ~m) | v)
> +
> +#define txb_read(s, r) adv748x_read(s, ADV748X_I2C_TXB, r)
> +#define txb_write(s, r, v) adv748x_write(s, ADV748X_I2C_TXB, r, v)
> +#define txb_clrset(s, r, m, v) txb_write(s, r, (txb_read(s, r) & ~m) | v)
> +
> +void adv748x_subdev_init(struct v4l2_subdev *sd, struct adv748x_state *state,
> +		const struct v4l2_subdev_ops *ops, const char *ident);
> +
> +int adv748x_setup_links(struct adv748x_state *state);
> +
> +int adv748x_txa_power(struct adv748x_state *state, bool on);
> +int adv748x_txb_power(struct adv748x_state *state, bool on);
> +
> +int adv748x_afe_probe(struct adv748x_state *state, struct device_node *ep);
> +void adv748x_afe_remove(struct adv748x_state *state);
> +
> +int adv748x_csi2_probe(struct adv748x_state *state, struct adv748x_csi2 *tx);
> +void adv748x_csi2_remove(struct adv748x_csi2 *tx);
> +
> +int adv748x_hdmi_probe(struct adv748x_state *state, struct device_node *ep);
> +void adv748x_hdmi_remove(struct adv748x_state *state);
> +
> +#endif /* _ADV748X_H_ */

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
