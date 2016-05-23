Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:35995 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752084AbcEWJQq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2016 05:16:46 -0400
Subject: Re: [PATCH v4 1/6] media: Add video processing entity functions
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org
References: <1463701232-22008-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1463701232-22008-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5742C833.50204@xs4all.nl>
Date: Mon, 23 May 2016 11:06:59 +0200
MIME-Version: 1.0
In-Reply-To: <1463701232-22008-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/20/2016 01:40 AM, Laurent Pinchart wrote:
> Add composer, pixel formatter, pixel encoding converter and scaler
> functions.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Looks good!

	Hans

> ---
>  Documentation/DocBook/media/v4l/media-types.xml | 55 +++++++++++++++++++++++++
>  include/uapi/linux/media.h                      |  9 ++++
>  2 files changed, 64 insertions(+)
> 
> diff --git a/Documentation/DocBook/media/v4l/media-types.xml b/Documentation/DocBook/media/v4l/media-types.xml
> index 5e3f20fdcf17..60fe841f8846 100644
> --- a/Documentation/DocBook/media/v4l/media-types.xml
> +++ b/Documentation/DocBook/media/v4l/media-types.xml
> @@ -121,6 +121,61 @@
>  	    <entry><constant>MEDIA_ENT_F_AUDIO_MIXER</constant></entry>
>  	    <entry>Audio Mixer Function Entity.</entry>
>  	  </row>
> +	  <row>
> +	    <entry><constant>MEDIA_ENT_F_PROC_VIDEO_COMPOSER</constant></entry>
> +	    <entry>Video composer (blender). An entity capable of video
> +		   composing must have at least two sink pads and one source
> +		   pad, and composes input video frames onto output video
> +		   frames. Composition can be performed using alpha blending,
> +		   color keying, raster operations (ROP), stitching or any other
> +		   means.
> +	    </entry>
> +	  </row>
> +	  <row>
> +	    <entry><constant>MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER</constant></entry>
> +	    <entry>Video pixel formatter. An entity capable of pixel formatting
> +		   must have at least one sink pad and one source pad. Read
> +		   pixel formatters read pixels from memory and perform a subset
> +		   of unpacking, cropping, color keying, alpha multiplication
> +		   and pixel encoding conversion. Write pixel formatters perform
> +		   a subset of dithering, pixel encoding conversion and packing
> +		   and write pixels to memory.
> +	    </entry>
> +	  </row>
> +	  <row>
> +	    <entry><constant>MEDIA_ENT_F_PROC_VIDEO_PIXEL_ENC_CONV</constant></entry>
> +	    <entry>Video pixel encoding converter. An entity capable of pixel
> +		   enconding conversion must have at least one sink pad and one
> +		   source pad, and convert the encoding of pixels received on
> +		   its sink pad(s) to a different encoding output on its source
> +		   pad(s). Pixel encoding conversion includes but isn't limited
> +		   to RGB to/from HSV, RGB to/from YUV and CFA (Bayer) to RGB
> +		   conversions.
> +	    </entry>
> +	  </row>
> +	  <row>
> +	    <entry><constant>MEDIA_ENT_F_PROC_VIDEO_LUT</constant></entry>
> +	    <entry>Video look-up table. An entity capable of video lookup table
> +		   processing must have one sink pad and one source pad. It uses
> +		   the values of the pixels received on its sink pad to look up
> +		   entries in internal tables and output them on its source pad.
> +		   The lookup processing can be performed on all components
> +		   separately or combine them for multi-dimensional table
> +		   lookups.
> +	    </entry>
> +	  </row>
> +	  <row>
> +	    <entry><constant>MEDIA_ENT_F_PROC_VIDEO_SCALER</constant></entry>
> +	    <entry>Video scaler. An entity capable of video scaling must have
> +		   at least one sink pad and one source pad, and scale the
> +		   video frame(s) received on its sink pad(s) to a different
> +		   resolution output on its source pad(s). The range of
> +		   supported scaling ratios is entity-specific and can differ
> +		   between the horizontal and vertical directions (in particular
> +		   scaling can be supported in one direction only). Binning and
> +		   skipping are considered as scaling.
> +	    </entry>
> +	  </row>
>  	</tbody>
>        </tgroup>
>      </table>
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index e226bc35c639..bff3ffdfd55f 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -96,6 +96,15 @@ struct media_device_info {
>  #define MEDIA_ENT_F_AUDIO_MIXER		(MEDIA_ENT_F_BASE + 0x03003)
>  
>  /*
> + * Processing entities
> + */
> +#define MEDIA_ENT_F_PROC_VIDEO_COMPOSER		(MEDIA_ENT_F_BASE + 0x4001)
> +#define MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER	(MEDIA_ENT_F_BASE + 0x4002)
> +#define MEDIA_ENT_F_PROC_VIDEO_PIXEL_ENC_CONV	(MEDIA_ENT_F_BASE + 0x4003)
> +#define MEDIA_ENT_F_PROC_VIDEO_LUT		(MEDIA_ENT_F_BASE + 0x4004)
> +#define MEDIA_ENT_F_PROC_VIDEO_SCALER		(MEDIA_ENT_F_BASE + 0x4005)
> +
> +/*
>   * Connectors
>   */
>  /* It is a responsibility of the entity drivers to add connectors and links */
> 
