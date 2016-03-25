Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:57481 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751884AbcCYPPI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2016 11:15:08 -0400
Subject: Re: [PATCH v3] media: Add video processing entity functions
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org
References: <56F532AB.3000107@xs4all.nl>
 <1458915565-12596-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56F555F3.4000308@xs4all.nl>
Date: Fri, 25 Mar 2016 16:14:59 +0100
MIME-Version: 1.0
In-Reply-To: <1458915565-12596-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/25/2016 03:19 PM, Laurent Pinchart wrote:
> Add composer, format converter and scaler functions, as well as generic
> video processing to be used when no other processing function is
> applicable.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  Documentation/DocBook/media/v4l/media-types.xml | 34 +++++++++++++++++++++++++
>  include/uapi/linux/media.h                      |  8 ++++++
>  2 files changed, 42 insertions(+)
> 
> Changes since v2:
> 
> - Fix typo (any other mean -> any other means)
> 
> diff --git a/Documentation/DocBook/media/v4l/media-types.xml b/Documentation/DocBook/media/v4l/media-types.xml
> index 5e3f20fdcf17..38e8d6c25d49 100644
> --- a/Documentation/DocBook/media/v4l/media-types.xml
> +++ b/Documentation/DocBook/media/v4l/media-types.xml
> @@ -121,6 +121,40 @@
>  	    <entry><constant>MEDIA_ENT_F_AUDIO_MIXER</constant></entry>
>  	    <entry>Audio Mixer Function Entity.</entry>
>  	  </row>
> +	  <row>
> +	    <entry><constant>MEDIA_ENT_F_PROC_VIDEO_GENERIC</constant></entry>
> +	    <entry>Generic video processing, when no other processing function
> +		   is applicable.
> +	    </entry>

I'll be honest and say that I don't really like this. A VIDEO_GENERIC function
is only marginally more useful than UNKNOWN. And I think I prefer UNKNOWN for
now until we have a clear picture how these functions are going to work. The
main missing piece in this puzzle are properties that allow us to register
multiple functions and some decision as to what the scope of 'functions' is going
to be.

You mentioned that you have a few entities that are using this function, but
if you would specify the exact function of those entities, what would the
function name(s) be?

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

This one looks OK to me.

> +	  </row>
> +	    <entry><constant>MEDIA_ENT_F_PROC_VIDEO_CONVERTER</constant></entry>
> +	    <entry>Video format converter. An entity capable of video format
> +		   conversion must have at least one sink pad and one source
> +		   pad, and convert the format of pixels received on its sink
> +		   pad(s) to a different format output on its source pad(s).
> +	    </entry>
> +	  </row>

This is too vague as well, I think. You said that you don't consider de-interlacing
a converter function, but what about colorimetry conversion? Debayer? 4:2:2 to 4:2:0
conversion or vice versa?

> +	  <row>
> +	    <entry><constant>MEDIA_ENT_F_PROC_VIDEO_SCALER</constant></entry>
> +	    <entry>Video scaler. An entity capable of video scaling must have
> +		   at least one sink pad and one source pad, and scaling the
> +		   video frame(s) received on its sink pad(s) to a different
> +		   resolution output on its source pad(s). The range of
> +		   supported scaling ratios is entity-specific and can differ
> +		   between the horizontal and vertical directions. In particular
> +		   scaling can be supported in one direction only.
> +	    </entry>
> +	  </row>

This looks OK too, although would sensor binning and/or skipping also be considered
scaling?

Regards,

	Hans

>  	</tbody>
>        </tgroup>
>      </table>
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index df59edee25d1..884ec1cae09d 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -95,6 +95,14 @@ struct media_device_info {
>  #define MEDIA_ENT_F_AUDIO_MIXER		(MEDIA_ENT_F_BASE + 0x03003)
>  
>  /*
> + * Processing entities
> + */
> +#define MEDIA_ENT_F_PROC_VIDEO_GENERIC		(MEDIA_ENT_F_BASE + 0x4001)
> +#define MEDIA_ENT_F_PROC_VIDEO_COMPOSER		(MEDIA_ENT_F_BASE + 0x4002)
> +#define MEDIA_ENT_F_PROC_VIDEO_CONVERTER	(MEDIA_ENT_F_BASE + 0x4003)
> +#define MEDIA_ENT_F_PROC_VIDEO_SCALER		(MEDIA_ENT_F_BASE + 0x4004)
> +
> +/*
>   * Connectors
>   */
>  /* It is a responsibility of the entity drivers to add connectors and links */
> 

