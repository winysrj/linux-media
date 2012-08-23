Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34425 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932566Ab2HWMNy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Aug 2012 08:13:54 -0400
Date: Thu, 23 Aug 2012 15:13:49 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com, kyungmin.park@samsung.com
Subject: Re: [PATCH RFC 1/4] V4L: Add V4L2_CID_FRAMESIZE image source class
 control
Message-ID: <20120823121349.GI721@valkosipuli.retiisi.org.uk>
References: <1345715489-30158-1-git-send-email-s.nawrocki@samsung.com>
 <1345715489-30158-2-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345715489-30158-2-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thanks for the patch.

On Thu, Aug 23, 2012 at 11:51:26AM +0200, Sylwester Nawrocki wrote:
> The V4L2_CID_FRAMESIZE control determines maximum number
> of media bus samples transmitted within a single data frame.
> It is useful for determining size of data buffer at the
> receiver side.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  Documentation/DocBook/media/v4l/controls.xml | 12 ++++++++++++
>  drivers/media/v4l2-core/v4l2-ctrls.c         |  2 ++
>  include/linux/videodev2.h                    |  1 +
>  3 files changed, 15 insertions(+)
> 
> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
> index 93b9c68..ad5d4e5 100644
> --- a/Documentation/DocBook/media/v4l/controls.xml
> +++ b/Documentation/DocBook/media/v4l/controls.xml
> @@ -4184,6 +4184,18 @@ interface and may change in the future.</para>
>  	    conversion.
>  	    </entry>
>  	  </row>
> +	  <row>
> +	    <entry spanname="id"><constant>V4L2_CID_FRAMESIZE</constant></entry>
> +	    <entry>integer</entry>
> +	  </row>
> +	  <row>
> +	    <entry spanname="descr">Maximum size of a data frame in media bus
> +	      sample units. This control determines maximum number of samples
> +	      transmitted per single compressed data frame. For generic raw
> +	      pixel formats the value of this control is undefined. This is
> +	      a read-only control.
> +	    </entry>
> +	  </row>
>  	  <row><entry></entry></row>
>  	</tbody>
>        </tgroup>
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index b6a2ee7..0043fd2 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -727,6 +727,7 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_VBLANK:			return "Vertical Blanking";
>  	case V4L2_CID_HBLANK:			return "Horizontal Blanking";
>  	case V4L2_CID_ANALOGUE_GAIN:		return "Analogue Gain";
> +	case V4L2_CID_FRAMESIZE:		return "Maximum Frame Size";

I would put this to the image processing class, as the control isn't related
to image capture. Jpeg encoding (or image compression in general) after all
is related to image processing rather than capturing it.

>  	/* Image processing controls */
>  	case V4L2_CID_IMAGE_PROC_CLASS:		return "Image Processing Controls";
> @@ -933,6 +934,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>  	case V4L2_CID_FLASH_STROBE_STATUS:
>  	case V4L2_CID_AUTO_FOCUS_STATUS:
>  	case V4L2_CID_FLASH_READY:
> +	case V4L2_CID_FRAMESIZE:
>  		*flags |= V4L2_CTRL_FLAG_READ_ONLY;
>  		break;
>  	}
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 7a147c8..d3fd19f 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -1985,6 +1985,7 @@ enum v4l2_jpeg_chroma_subsampling {
>  #define V4L2_CID_VBLANK				(V4L2_CID_IMAGE_SOURCE_CLASS_BASE + 1)
>  #define V4L2_CID_HBLANK				(V4L2_CID_IMAGE_SOURCE_CLASS_BASE + 2)
>  #define V4L2_CID_ANALOGUE_GAIN			(V4L2_CID_IMAGE_SOURCE_CLASS_BASE + 3)
> +#define V4L2_CID_FRAMESIZE			(V4L2_CID_IMAGE_SOURCE_CLASS_BASE + 4)
>  
>  /* Image processing controls */
>  #define V4L2_CID_IMAGE_PROC_CLASS_BASE		(V4L2_CTRL_CLASS_IMAGE_PROC | 0x900)

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
