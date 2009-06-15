Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f214.google.com ([209.85.217.214]:46917 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbZFOE5P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2009 00:57:15 -0400
Received: by gxk10 with SMTP id 10so6140979gxk.13
        for <linux-media@vger.kernel.org>; Sun, 14 Jun 2009 21:57:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1244580953-24188-1-git-send-email-m-karicheri2@ti.com>
References: <1244580953-24188-1-git-send-email-m-karicheri2@ti.com>
Date: Mon, 15 Jun 2009 13:57:16 +0900
Message-ID: <aec7e5c30906142157t313e7c95v3d1ab19f80745cf5@mail.gmail.com>
Subject: Re: [PATCH RFC] adding support for setting bus parameters in sub
	device
From: Magnus Damm <magnus.damm@gmail.com>
To: m-karicheri2@ti.com
Cc: linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 10, 2009 at 5:55 AM, <m-karicheri2@ti.com> wrote:
> From: Muralidharan Karicheri <a0868495@gt516km11.gt.design.ti.com>
>
> re-sending with RFC in the header
>
> This patch adds support for setting bus parameters such as bus type
> (BT.656, BT.1120 etc), width (example 10 bit raw image data bus)
> and polarities (vsync, hsync, field etc) in sub device. This allows
> bridge driver to configure the sub device for a specific set of bus
> parameters through s_bus() function call.
>
> Reviewed By "Hans Verkuil".
> Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> ---
> Applies to v4l-dvb repository
>
>  include/media/v4l2-subdev.h |   36 ++++++++++++++++++++++++++++++++++++
>  1 files changed, 36 insertions(+), 0 deletions(-)
>
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 1785608..c1cfb3b 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -37,6 +37,41 @@ struct v4l2_decode_vbi_line {
>        u32 type;               /* VBI service type (V4L2_SLICED_*). 0 if no service found */
>  };
>
> +/*
> + * Some sub-devices are connected to the bridge device through a bus that
> + * carries * the clock, vsync, hsync and data. Some interfaces such as BT.656
> + * carries the sync embedded in the data where as others have separate line
> + * carrying the sync signals. The structure below is used by bridge driver to
> + * set the desired bus parameters in the sub device to work with it.
> + */
> +enum v4l2_subdev_bus_type {
> +       /* BT.656 interface. Embedded sync */
> +       V4L2_SUBDEV_BUS_BT_656,
> +       /* BT.1120 interface. Embedded sync */
> +       V4L2_SUBDEV_BUS_BT_1120,
> +       /* 8 bit muxed YCbCr bus, separate sync and field signals */
> +       V4L2_SUBDEV_BUS_YCBCR_8,
> +       /* 16 bit YCbCr bus, separate sync and field signals */
> +       V4L2_SUBDEV_BUS_YCBCR_16,
> +       /* Raw Bayer image data bus , 8 - 16 bit wide, sync signals */
> +       V4L2_SUBDEV_BUS_RAW_BAYER
> +};
> +
> +struct v4l2_subdev_bus {
> +       enum v4l2_subdev_bus_type type;
> +       u8 width;
> +       /* 0 - active low, 1 - active high */
> +       unsigned pol_vsync:1;
> +       /* 0 - active low, 1 - active high */
> +       unsigned pol_hsync:1;
> +       /* 0 - low to high , 1 - high to low */
> +       unsigned pol_field:1;
> +       /* 0 - sample at falling edge , 1 - sample at rising edge */
> +       unsigned pol_pclock:1;
> +       /* 0 - active low , 1 - active high */
> +       unsigned pol_data:1;
> +};

As for the pins/signals, I wonder if per-signal polarity/edge is
enough. If this is going to be used by/replace the soc_camera
interface then we also need to know if the signal is present or not.
For instance, I have a SuperH board using my CEU driver together with
one OV7725 camera or one TW9910 video decoder. Some revisions of the
board do not route the field signal between the SuperH on-chip CEU and
the TW9910. Both the CEU and the TW9910 support this signal, it just
happen to be missing. I think we need a way to include this board
specific property somehow.

/ magnus
