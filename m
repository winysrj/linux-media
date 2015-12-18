Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:36463 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751876AbbLRLU7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2015 06:20:59 -0500
Subject: Re: [PATCH/RFC 27/48] v4l2-subdev.h: Add request field to format and
 selection structures
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org
References: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1450341626-6695-28-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-sh@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5673EC16.6020302@xs4all.nl>
Date: Fri, 18 Dec 2015 12:20:54 +0100
MIME-Version: 1.0
In-Reply-To: <1450341626-6695-28-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 12/17/2015 09:40 AM, Laurent Pinchart wrote:
> Let userspace specify a request ID when getting or setting formats or
> selection rectangles.
> 
> From a userspace point of view the API change is minimized and doesn't
> require any new ioctl.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  include/uapi/linux/v4l2-subdev.h | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/v4l2-subdev.h b/include/uapi/linux/v4l2-subdev.h
> index dbce2b554e02..2f1691ce9df5 100644
> --- a/include/uapi/linux/v4l2-subdev.h
> +++ b/include/uapi/linux/v4l2-subdev.h
> @@ -32,10 +32,12 @@
>   * enum v4l2_subdev_format_whence - Media bus format type
>   * @V4L2_SUBDEV_FORMAT_TRY: try format, for negotiation only
>   * @V4L2_SUBDEV_FORMAT_ACTIVE: active format, applied to the device
> + * @V4L2_SUBDEV_FORMAT_REQUEST: format stored in request
>   */
>  enum v4l2_subdev_format_whence {
>  	V4L2_SUBDEV_FORMAT_TRY = 0,
>  	V4L2_SUBDEV_FORMAT_ACTIVE = 1,
> +	V4L2_SUBDEV_FORMAT_REQUEST = 2,
>  };
>  
>  /**
> @@ -43,12 +45,17 @@ enum v4l2_subdev_format_whence {
>   * @which: format type (from enum v4l2_subdev_format_whence)
>   * @pad: pad number, as reported by the media API
>   * @format: media bus format (format code and frame size)
> + * @request: request ID (when which is set to V4L2_SUBDEV_FORMAT_REQUEST)
> + * @reserved2: for future use, set to zero for now
> + * @reserved: for future use, set to zero for now
>   */
>  struct v4l2_subdev_format {
>  	__u32 which;
>  	__u32 pad;
>  	struct v4l2_mbus_framefmt format;
> -	__u32 reserved[8];
> +	__u16 request;
> +	__u16 reserved2;
> +	__u32 reserved[7];

I would prefer:

	__u16 request;
	__u16 reserved[15];

>  };
>  
>  /**
> @@ -139,6 +146,8 @@ struct v4l2_subdev_frame_interval_enum {
>   *	    defined in v4l2-common.h; V4L2_SEL_TGT_* .
>   * @flags: constraint flags, defined in v4l2-common.h; V4L2_SEL_FLAG_*.
>   * @r: coordinates of the selection window
> + * @request: request ID (when which is set to V4L2_SUBDEV_FORMAT_REQUEST)
> + * @reserved2: for future use, set to zero for now
>   * @reserved: for future use, set to zero for now
>   *
>   * Hardware may use multiple helper windows to process a video stream.
> @@ -151,7 +160,9 @@ struct v4l2_subdev_selection {
>  	__u32 target;
>  	__u32 flags;
>  	struct v4l2_rect r;
> -	__u32 reserved[8];
> +	__u16 request;
> +	__u16 reserved2;
> +	__u32 reserved[7];

Ditto.

Generally apps do a memset of reserved, and that will just keep working.
But adding a reserved2 field means that they have to explicitly set reserved2
to 0, which won't happen.

>  };
>  
>  /* Backwards compatibility define --- to be removed */
> 

Regards,

	Hans
