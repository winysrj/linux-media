Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55969 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab1AGNwX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jan 2011 08:52:23 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC PATCH 1/5] v4l2-subdev: remove core.s_config and v4l2_i2c_new_subdev_cfg()
Date: Fri, 7 Jan 2011 14:53:06 +0100
Cc: linux-media@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
References: <1294404455-22050-1-git-send-email-hverkuil@xs4all.nl> <cc5591b13e048b8fbc1482db6dffeb7d48f9134b.1294402580.git.hverkuil@xs4all.nl>
In-Reply-To: <cc5591b13e048b8fbc1482db6dffeb7d48f9134b.1294402580.git.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201101071453.07271.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

On Friday 07 January 2011 13:47:31 Hans Verkuil wrote:

[snip]
 
> diff --git a/drivers/media/video/cx25840/cx25840-core.c
> b/drivers/media/video/cx25840/cx25840-core.c index dfb198d..9b384ac 100644
> --- a/drivers/media/video/cx25840/cx25840-core.c
> +++ b/drivers/media/video/cx25840/cx25840-core.c
> @@ -1682,20 +1682,6 @@ static int cx25840_log_status(struct v4l2_subdev
> *sd) return 0;
>  }
> 
> -static int cx25840_s_config(struct v4l2_subdev *sd, int irq, void
> *platform_data) -{
> -	struct cx25840_state *state = to_state(sd);
> -	struct i2c_client *client = v4l2_get_subdevdata(sd);
> -
> -	if (platform_data) {
> -		struct cx25840_platform_data *pdata = platform_data;
> -
> -		state->pvr150_workaround = pdata->pvr150_workaround;
> -		set_input(client, state->vid_input, state->aud_input);
> -	}
> -	return 0;
> -}
> -
>  static int cx23885_irq_handler(struct v4l2_subdev *sd, u32 status,
>  			       bool *handled)
>  {

[snip]

> @@ -2019,6 +2003,12 @@ static int cx25840_probe(struct i2c_client *client,
>  	v4l2_ctrl_cluster(2, &state->volume);
>  	v4l2_ctrl_handler_setup(&state->hdl);
> 
> +	if (client->dev.platform_data) {
> +		struct cx25840_platform_data *pdata = client->dev.platform_data;
> +
> +		state->pvr150_workaround = pdata->pvr150_workaround;
> +	}
> +

No need to call set_input() anymore ?

>  	cx25840_ir_probe(sd);
>  	return 0;
>  }

[snip]

> diff --git a/drivers/media/video/mt9v011_regs.h
> b/drivers/media/video/mt9v011_regs.h new file mode 100644
> index 0000000..d6a5a08
> --- /dev/null
> +++ b/drivers/media/video/mt9v011_regs.h
> @@ -0,0 +1,36 @@
> +/*
> + * mt9v011 -Micron 1/4-Inch VGA Digital Image Sensor
> + *
> + * Copyright (c) 2009 Mauro Carvalho Chehab (mchehab@redhat.com)
> + * This code is placed under the terms of the GNU General Public License
> v2 + */
> +
> +#ifndef MT9V011_REGS_H_
> +#define MT9V011_REGS_H_
> +
> +#define R00_MT9V011_CHIP_VERSION	0x00
> +#define R01_MT9V011_ROWSTART		0x01
> +#define R02_MT9V011_COLSTART		0x02
> +#define R03_MT9V011_HEIGHT		0x03
> +#define R04_MT9V011_WIDTH		0x04
> +#define R05_MT9V011_HBLANK		0x05
> +#define R06_MT9V011_VBLANK		0x06
> +#define R07_MT9V011_OUT_CTRL		0x07
> +#define R09_MT9V011_SHUTTER_WIDTH	0x09
> +#define R0A_MT9V011_CLK_SPEED		0x0a
> +#define R0B_MT9V011_RESTART		0x0b
> +#define R0C_MT9V011_SHUTTER_DELAY	0x0c
> +#define R0D_MT9V011_RESET		0x0d
> +#define R1E_MT9V011_DIGITAL_ZOOM	0x1e
> +#define R20_MT9V011_READ_MODE		0x20
> +#define R2B_MT9V011_GREEN_1_GAIN	0x2b
> +#define R2C_MT9V011_BLUE_GAIN		0x2c
> +#define R2D_MT9V011_RED_GAIN		0x2d
> +#define R2E_MT9V011_GREEN_2_GAIN	0x2e
> +#define R35_MT9V011_GLOBAL_GAIN		0x35
> +#define RF1_MT9V011_CHIP_ENABLE		0xf1
> +
> +#define MT9V011_VERSION			0x8232
> +#define MT9V011_REV_B_VERSION		0x8243

What about merging this into mt9v011.c ?

> +
> +#endif

-- 
Regards,

Laurent Pinchart
