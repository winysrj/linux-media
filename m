Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:42631 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754883AbcJUOe5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Oct 2016 10:34:57 -0400
Subject: Re: [PATCH v3 02/10] v4l: ctrls: Add deinterlacing mode control
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org
References: <1473287110-780-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1473287110-780-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran@ksquared.org.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b31db639-f1da-0343-178f-8d351c5a4e4c@xs4all.nl>
Date: Fri, 21 Oct 2016 16:34:50 +0200
MIME-Version: 1.0
In-Reply-To: <1473287110-780-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/08/16 00:25, Laurent Pinchart wrote:
> The menu control selects the operation mode of a video deinterlacer. The
> menu entries are driver specific.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  Documentation/media/uapi/v4l/extended-controls.rst | 4 ++++
>  drivers/media/v4l2-core/v4l2-ctrls.c               | 2 ++
>  include/uapi/linux/v4l2-controls.h                 | 1 +
>  3 files changed, 7 insertions(+)
>
> diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
> index 1f1518e4859d..8e6314e23cd3 100644
> --- a/Documentation/media/uapi/v4l/extended-controls.rst
> +++ b/Documentation/media/uapi/v4l/extended-controls.rst
> @@ -4250,6 +4250,10 @@ Image Process Control IDs
>      test pattern images. These hardware specific test patterns can be
>      used to test if a device is working properly.
>
> +``V4L2_CID_DEINTERLACING_MODE (menu)``
> +    The video deinterlacing mode (such as Bob, Weave, ...). The menu items are
> +    driver specific.
> +

I'm fine with the patch but I wonder where these modes will be documented.
I know that some of those modes will be hard to document since the HW docs
might give little or no information, but even that is useful information to
have.

We now have driver-specific documentation as part of the kernel docs, so I
would suggest that that is a good place. If we do that, then this control
documentation should refer there.

For this patch:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

BUT: it can't be merged without an actual driver that uses this, and as
I mentioned on irc I didn't see a patch for that yet.

Regards,

	Hans

>
>  .. _dv-controls:
>
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index adc2147fcff7..47001e25fd9e 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -885,6 +885,7 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_LINK_FREQ:		return "Link Frequency";
>  	case V4L2_CID_PIXEL_RATE:		return "Pixel Rate";
>  	case V4L2_CID_TEST_PATTERN:		return "Test Pattern";
> +	case V4L2_CID_DEINTERLACING_MODE:	return "Deinterlacing Mode";
>
>  	/* DV controls */
>  	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
> @@ -1058,6 +1059,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>  	case V4L2_CID_DV_RX_RGB_RANGE:
>  	case V4L2_CID_DV_RX_IT_CONTENT_TYPE:
>  	case V4L2_CID_TEST_PATTERN:
> +	case V4L2_CID_DEINTERLACING_MODE:
>  	case V4L2_CID_TUNE_DEEMPHASIS:
>  	case V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_SEL:
>  	case V4L2_CID_DETECT_MD_MODE:
> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> index b6a357a5f053..0d2e1e01fbd5 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -892,6 +892,7 @@ enum v4l2_jpeg_chroma_subsampling {
>  #define V4L2_CID_LINK_FREQ			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 1)
>  #define V4L2_CID_PIXEL_RATE			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 2)
>  #define V4L2_CID_TEST_PATTERN			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 3)
> +#define V4L2_CID_DEINTERLACING_MODE		(V4L2_CID_IMAGE_PROC_CLASS_BASE + 4)
>
>
>  /*  DV-class control IDs defined by V4L2 */
>
