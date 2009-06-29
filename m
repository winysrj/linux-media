Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4944 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbZF2J0Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2009 05:26:16 -0400
Message-ID: <42333.62.70.2.252.1246267577.squirrel@webmail.xs4all.nl>
Date: Mon, 29 Jun 2009 11:26:17 +0200 (CEST)
Subject: Re: [RFC PATCH] adding support for setting bus parameters in sub
     device
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: m-karicheri2@ti.com
Cc: linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Murali,

> From: Muralidharan Karicheri <a0868495@gt516km11.gt.design.ti.com>
>
> This patch adds support for setting bus parameters such as bus type
> (Raw Bayer or Raw YUV image data bus), bus width (example 10 bit raw
> image data bus, 10 bit BT.656 etc.), and polarities (vsync, hsync, field
> etc) in sub device. This allows bridge driver to configure the sub device
> bus for a specific set of bus parameters through s_bus() function call.
> This also can be used to define platform specific bus parameters for
> host and sub-devices.
>
> Reviewed by: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> ---
> Applies to v4l-dvb repository
>
>  include/media/v4l2-subdev.h |   40
> ++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 40 insertions(+), 0 deletions(-)
>
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 1785608..2f5ec98 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -37,6 +37,43 @@ struct v4l2_decode_vbi_line {
>  	u32 type;		/* VBI service type (V4L2_SLICED_*). 0 if no service found */
>  };
>
> +/*
> + * Some sub-devices are connected to the host/bridge device through a bus
> that
> + * carries the clock, vsync, hsync and data. Some interfaces such as
> BT.656
> + * carries the sync embedded in the data where as others have separate
> line
> + * carrying the sync signals. The structure below is used to define bus
> + * configuration parameters for host as well as sub-device
> + */
> +enum v4l2_subdev_bus_type {
> +	/* Raw YUV image data bus */
> +	V4L2_SUBDEV_BUS_RAW_YUV,
> +	/* Raw Bayer image data bus */
> +	V4L2_SUBDEV_BUS_RAW_BAYER
> +};
> +
> +struct v4l2_bus_settings {
> +	/* yuv or bayer image data bus */
> +	enum v4l2_subdev_bus_type type;
> +	/* subdev bus width */
> +	u8 subdev_width;
> +	/* host bus width */
> +	u8 host_width;
> +	/* embedded sync, set this when sync is embedded in the data stream */
> +	unsigned embedded_sync:1;
> +	/* master or slave */
> +	unsigned host_is_master:1;
> +	/* 0 - active low, 1 - active high */
> +	unsigned pol_vsync:1;
> +	/* 0 - active low, 1 - active high */
> +	unsigned pol_hsync:1;
> +	/* 0 - low to high , 1 - high to low */
> +	unsigned pol_field:1;
> +	/* 0 - sample at falling edge , 1 - sample at rising edge */
> +	unsigned pol_pclock:1;
> +	/* 0 - active low , 1 - active high */
> +	unsigned pol_data:1;
> +};

I've been thinking about this for a while and I think this struct should
be extended with the host bus parameters as well:

struct v4l2_bus_settings {
	/* yuv or bayer image data bus */
	enum v4l2_bus_type type;
	/* embedded sync, set this when sync is embedded in the data stream */
	unsigned embedded_sync:1;
	/* master or slave */
	unsigned host_is_master:1;

	/* bus width */
	unsigned sd_width:8;
	/* 0 - active low, 1 - active high */
	unsigned sd_pol_vsync:1;
	/* 0 - active low, 1 - active high */
	unsigned sd_pol_hsync:1;
	/* 0 - low to high, 1 - high to low */
	unsigned sd_pol_field:1;
	/* 0 - sample at falling edge, 1 - sample at rising edge */
	unsigned sd_edge_pclock:1;
	/* 0 - active low, 1 - active high */
	unsigned sd_pol_data:1;

	/* host bus width */
	unsigned host_width:8;
	/* 0 - active low, 1 - active high */
	unsigned host_pol_vsync:1;
	/* 0 - active low, 1 - active high */
	unsigned host_pol_hsync:1;
	/* 0 - low to high, 1 - high to low */
	unsigned host_pol_field:1;
	/* 0 - sample at falling edge, 1 - sample at rising edge */
	unsigned host_edge_pclock:1;
	/* 0 - active low, 1 - active high */
	unsigned host_pol_data:1;
};

It makes sense since you need to setup both ends of the bus, and having
both ends defined in the same struct keeps everything together. I have
thought about having separate host and subdev structs, but part of the bus
description is always common (bus type, master/slave, embedded/separate
syncs), while another part can be different for each end of the bus.

It's all bitfields, so it is a very compact representation.

In addition, I think we need to require that at the start of the s_bus
implementation in the host or subdev there should be a standard comment
block describing the possible combinations supported by the hardware:

/* Subdevice foo supports the following bus settings:

   types: RAW_BAYER (widths: 8/10/12, syncs: embedded/separate)
          RAW_YUV (widths: 8/16, syncs: embedded)
   bus master: slave
   vsync polarity: 0/1
   hsync polarity: 0/1
   field polarity: not applicable
   sampling edge pixelclock: 0/1
   data polarity: 1
 */

This should make it easy for implementers to pick a valid set of bus
parameters.

Regards,

       Hans

> +
>  /* Sub-devices are devices that are connected somehow to the main bridge
>     device. These devices are usually audio/video muxers/encoders/decoders
> or
>     sensors and webcam controllers.
> @@ -199,6 +236,8 @@ struct v4l2_subdev_audio_ops {
>
>     s_routing: see s_routing in audio_ops, except this version is for
> video
>  	devices.
> +
> +   s_bus: set bus parameters in sub device to configure the bus
>   */
>  struct v4l2_subdev_video_ops {
>  	int (*s_routing)(struct v4l2_subdev *sd, u32 input, u32 output, u32
> config);
> @@ -219,6 +258,7 @@ struct v4l2_subdev_video_ops {
>  	int (*s_parm)(struct v4l2_subdev *sd, struct v4l2_streamparm *param);
>  	int (*enum_framesizes)(struct v4l2_subdev *sd, struct v4l2_frmsizeenum
> *fsize);
>  	int (*enum_frameintervals)(struct v4l2_subdev *sd, struct
> v4l2_frmivalenum *fival);
> +	int (*s_bus)(struct v4l2_subdev *sd, const struct v4l2_bus_settings
> *bus);
>  };
>
>  struct v4l2_subdev_ops {
> --
> 1.6.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

