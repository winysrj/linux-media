Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52320 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751728Ab2GUHcg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jul 2012 03:32:36 -0400
Date: Sat, 21 Jul 2012 10:32:31 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Prabhakar Lad <prabhakar.lad@ti.com>
Cc: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Hans Verkuil <hansverk@cisco.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v6 1/2] media: add new mediabus format enums for dm365
Message-ID: <20120721073231.GE22859@valkosipuli.retiisi.org.uk>
References: <1342796290-18947-1-git-send-email-prabhakar.lad@ti.com>
 <1342796290-18947-2-git-send-email-prabhakar.lad@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342796290-18947-2-git-send-email-prabhakar.lad@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

Thanks for the patch!

Just a few comments.

On Fri, Jul 20, 2012 at 08:28:09PM +0530, Prabhakar Lad wrote:
> From: Manjunath Hadli <manjunath.hadli@ti.com>
> 
> add new enum entries for supporting the media-bus formats on dm365.
> These include some bayer and some non-bayer formats.
> V4L2_MBUS_FMT_YDYUYDYV8_1X16 and V4L2_MBUS_FMT_UV8_1X8 are used
> internal to the hardware by the resizer.
> V4L2_MBUS_FMT_SBGGR10_ALAW8_1X8 represents the bayer ALAW format
> that is supported by dm365 hardware.
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  Documentation/DocBook/media/v4l/subdev-formats.xml |  250 +++++++++++++++++++-
>  include/linux/v4l2-mediabus.h                      |   10 +-
>  2 files changed, 252 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
> index 49c532e..01b2811 100644
> --- a/Documentation/DocBook/media/v4l/subdev-formats.xml
> +++ b/Documentation/DocBook/media/v4l/subdev-formats.xml

...

> @@ -853,10 +921,16 @@
>        <title>Packed YUV Formats</title>
>  
>        <para>Those data formats transfer pixel data as (possibly downsampled) Y, U
> -      and V components. The format code is made of the following information.
> +      and V components. Some formats include dummy bits in some of their samples
> +      and are collectively referred to as "YDYC" (Y-Dummy-Y-Chroma) formats.
> +      One cannot rely on the values of these dummy bits as those are undefined.
> +      </para>
> +      <para>The format code is made of the following information.

Also many raw bayer formats contain padding bits to align pixels to byte
boundaries. We haven't had a situation where we'd have the same amount of
information per pixel on a pixel format with and without padding.

The definition of those formats does not require the padding bits to be
zero, but in practice they always are. How about the dm series of chips; are
the bits always zero? The OMAP 3 ISP spec doesn't specify that either AFAIR
but in practice the ISP only writes zeros there.

...
> @@ -877,7 +951,21 @@
>        U, Y, V, Y order will be named <constant>V4L2_MBUS_FMT_UYVY8_2X8</constant>.
>        </para>
>  
> -      <para>The following table lisst existing packet YUV formats.</para>
> +	<para><xref linkend="v4l2-mbus-pixelcode-yuv8"/> list existing packet YUV

s/list/lists/ ?

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
