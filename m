Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4570 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbZC3L6q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2009 07:58:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hardik Shah <hardik.shah@ti.com>
Subject: Re: [PATCH 2/3] New V4L2 CIDs for OMAP class of Devices.
Date: Mon, 30 Mar 2009 13:58:40 +0200
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	Brijesh Jadav <brijesh.j@ti.com>,
	Vaibhav Hiremath <hvaibhav@ti.com>
References: <1237526397-14101-1-git-send-email-hardik.shah@ti.com>
In-Reply-To: <1237526397-14101-1-git-send-email-hardik.shah@ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903301358.40555.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 20 March 2009 06:19:57 Hardik Shah wrote:
> Added V4L2_CID_BG_COLOR for background color setting.
> Added V4L2_CID_ROTATION for rotation setting.
> Above two ioclts are indepth discussed. Posting
> again with the driver usage.
> 
> V4L2 supports chroma keying added new flags for the
> source chroma keying which is exactly opposite of the
> chorma keying supported by V4L2.  In current implementation
> video data is replaced by the graphics buffer data for some
> specific color.  While for the source chroma keying grahics
> data is replaced by the video data for some specific color.
> Both are exactly opposite so are mutually exclusive
> 
> Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
> Signed-off-by: Hardik Shah <hardik.shah@ti.com>
> Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> ---
>  linux/drivers/media/video/v4l2-common.c |    7 +++++++
>  linux/include/linux/videodev2.h         |    6 +++++-
>  2 files changed, 12 insertions(+), 1 deletions(-)
> 
> diff --git a/linux/drivers/media/video/v4l2-common.c b/linux/drivers/media/video/v4l2-common.c
> index 3c42316..fa408f0 100644
> --- a/linux/drivers/media/video/v4l2-common.c
> +++ b/linux/drivers/media/video/v4l2-common.c
> @@ -422,6 +422,8 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_CHROMA_AGC:		return "Chroma AGC";
>  	case V4L2_CID_COLOR_KILLER:		return "Color Killer";
>  	case V4L2_CID_COLORFX:			return "Color Effects";
> +	case V4L2_CID_ROTATION:                 return "Rotation";

I'm having second thoughts about this name. I think V4L2_CID_ROTATE is better,
since it is an action ('you rotate an image') rather than a status ('what is
the rotation of an image').

What do you think?

> +	case V4L2_CID_BG_COLOR:                 return "Background color";
> 
>  	/* MPEG controls */
>  	case V4L2_CID_MPEG_CLASS: 		return "MPEG Encoder Controls";
> @@ -547,6 +549,10 @@ int v4l2_ctrl_query_fill(struct v4l2_queryctrl *qctrl, s32 min, s32 max, s32 ste
>  		qctrl->flags |= V4L2_CTRL_FLAG_READ_ONLY;
>  		min = max = step = def = 0;
>  		break;
> +	case V4L2_CID_BG_COLOR:
> +		 qctrl->type = V4L2_CTRL_TYPE_INTEGER;
> +		 step = 1;
> +		 break;

Set the min to 0 and max to 0xffffff.

>  	default:
>  		qctrl->type = V4L2_CTRL_TYPE_INTEGER;
>  		break;
> @@ -571,6 +577,7 @@ int v4l2_ctrl_query_fill(struct v4l2_queryctrl *qctrl, s32 min, s32 max, s32 ste
>  	case V4L2_CID_BLUE_BALANCE:
>  	case V4L2_CID_GAMMA:
>  	case V4L2_CID_SHARPNESS:
> +	case V4L2_CID_BG_COLOR:

This definitely isn't a slider control.

>  		qctrl->flags |= V4L2_CTRL_FLAG_SLIDER;
>  		break;
>  	case V4L2_CID_PAN_RELATIVE:
> diff --git a/linux/include/linux/videodev2.h b/linux/include/linux/videodev2.h
> index 2c83935..592d1c8 100644
> --- a/linux/include/linux/videodev2.h
> +++ b/linux/include/linux/videodev2.h
> @@ -548,6 +548,7 @@ struct v4l2_framebuffer {
>  #define V4L2_FBUF_CAP_LOCAL_ALPHA	0x0010
>  #define V4L2_FBUF_CAP_GLOBAL_ALPHA	0x0020
>  #define V4L2_FBUF_CAP_LOCAL_INV_ALPHA	0x0040
> +#define V4L2_FBUF_CAP_SRC_CHROMAKEY	0x0080
>  /*  Flags for the 'flags' field. */
>  #define V4L2_FBUF_FLAG_PRIMARY		0x0001
>  #define V4L2_FBUF_FLAG_OVERLAY		0x0002
> @@ -555,6 +556,7 @@ struct v4l2_framebuffer {
>  #define V4L2_FBUF_FLAG_LOCAL_ALPHA	0x0008
>  #define V4L2_FBUF_FLAG_GLOBAL_ALPHA	0x0010
>  #define V4L2_FBUF_FLAG_LOCAL_INV_ALPHA	0x0020
> +#define V4L2_FBUF_FLAG_SRC_CHROMAKEY	0x0040
> 
>  struct v4l2_clip {
>  	struct v4l2_rect        c;
> @@ -882,6 +884,8 @@ enum v4l2_power_line_frequency {
>  #define V4L2_CID_CHROMA_AGC                     (V4L2_CID_BASE+29)
>  #define V4L2_CID_COLOR_KILLER                   (V4L2_CID_BASE+30)
>  #define V4L2_CID_COLORFX			(V4L2_CID_BASE+31)
> +#define V4L2_CID_ROTATION                     	(V4L2_CID_BASE+32)
> +#define V4L2_CID_BG_COLOR                       (V4L2_CID_BASE+33)
>  enum v4l2_colorfx {
>  	V4L2_COLORFX_NONE	= 0,
>  	V4L2_COLORFX_BW		= 1,
> @@ -889,7 +893,7 @@ enum v4l2_colorfx {
>  };
> 
>  /* last CID + 1 */
> -#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+32)
> +#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+34)
> 
>  /*  MPEG-class control IDs defined by V4L2 */
>  #define V4L2_CID_MPEG_BASE 			(V4L2_CTRL_CLASS_MPEG | 0x900)
> --
> 1.5.6

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
