Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34132 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755371AbcC1XCa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Mar 2016 19:02:30 -0400
Date: Tue, 29 Mar 2016 02:01:55 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 01/54] media: Add video processing entity functions
Message-ID: <20160328230155.GE32125@valkosipuli.retiisi.org.uk>
References: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1458902668-1141-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1458902668-1141-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Fri, Mar 25, 2016 at 12:43:35PM +0200, Laurent Pinchart wrote:
> Add composer, format converter and scaler functions, as well as generic
> video processing to be used when no other processing function is
> applicable.

How are these intended to be used?

Say, if a sub-device implements functionality that matches more than one of
these, do you pick one?

Supposedly you control at least some of this functionality using the
selections API, and frankly, I think the way it's currently defined in the
spec worked okay-ish for the devices at hand at the time, but defining that
the order of processing from the sink towards the source is sink crop, sink
compose and then source crop is not generic. We should have a better way to
tell this, using a similar API which is used to control the functionality,
just as is done with V4L2 controls.

> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  Documentation/DocBook/media/v4l/media-types.xml | 34 +++++++++++++++++++++++++
>  include/uapi/linux/media.h                      |  8 ++++++
>  2 files changed, 42 insertions(+)
> 
> diff --git a/Documentation/DocBook/media/v4l/media-types.xml b/Documentation/DocBook/media/v4l/media-types.xml
> index 5e3f20fdcf17..a6e171e80bce 100644
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
> +	  <row>
> +	    <entry><constant>MEDIA_ENT_F_PROC_VIDEO_COMPOSER</constant></entry>
> +	    <entry>Video composer (blender). An entity capable of video
> +		   composing must have at least two sink pads and one source
> +		   pad, and composes input video frames onto output video
> +		   frames. Composition can be performed using alpha blending,
> +		   color keying, raster operations (ROP), stitching or any other
> +		   mean.
> +	    </entry>
> +	  </row>
> +	  </row>
> +	    <entry><constant>MEDIA_ENT_F_PROC_VIDEO_CONVERTER</constant></entry>
> +	    <entry>Video format converter. An entity capable of video format
> +		   conversion must have at least one sink pad and one source
> +		   pad, and convert the format of pixels received on its sink
> +		   pad(s) to a different format output on its source pad(s).
> +	    </entry>
> +	  </row>
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

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
