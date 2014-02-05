Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1904 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbaBEROO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Feb 2014 12:14:14 -0500
Message-ID: <52F2714A.1000103@xs4all.nl>
Date: Wed, 05 Feb 2014 18:13:46 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 06/47] v4l: Add pad-level DV timings subdev operations
References: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com> <1391618558-5580-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1391618558-5580-7-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/05/2014 05:41 PM, Laurent Pinchart wrote:
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  include/media/v4l2-subdev.h    | 4 ++++
>  include/uapi/linux/videodev2.h | 8 ++++++--
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index d67210a..2c7355a 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -505,6 +505,10 @@ struct v4l2_subdev_pad_ops {
>  			     struct v4l2_subdev_selection *sel);
>  	int (*get_edid)(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edid);
>  	int (*set_edid)(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edid);
> +	int (*dv_timings_cap)(struct v4l2_subdev *sd,
> +			      struct v4l2_dv_timings_cap *cap);
> +	int (*enum_dv_timings)(struct v4l2_subdev *sd,
> +			       struct v4l2_enum_dv_timings *timings);
>  #ifdef CONFIG_MEDIA_CONTROLLER
>  	int (*link_validate)(struct v4l2_subdev *sd, struct media_link *link,
>  			     struct v4l2_subdev_format *source_fmt,
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 6ae7bbe..b75970d 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -1086,12 +1086,14 @@ struct v4l2_dv_timings {
>  
>  /** struct v4l2_enum_dv_timings - DV timings enumeration
>   * @index:	enumeration index
> + * @pad:	the pad number for which to query capabilities

Add something like: "pad is only used with v4l-subdev nodes."

>   * @reserved:	must be zeroed
>   * @timings:	the timings for the given index
>   */
>  struct v4l2_enum_dv_timings {
>  	__u32 index;
> -	__u32 reserved[3];
> +	__u32 pad;
> +	__u32 reserved[2];
>  	struct v4l2_dv_timings timings;
>  };
>  
> @@ -1129,11 +1131,13 @@ struct v4l2_bt_timings_cap {
>  
>  /** struct v4l2_dv_timings_cap - DV timings capabilities
>   * @type:	the type of the timings (same as in struct v4l2_dv_timings)
> + * @pad:	the pad number for which to query capabilities

Ditto.

>   * @bt:		the BT656/1120 timings capabilities
>   */
>  struct v4l2_dv_timings_cap {
>  	__u32 type;
> -	__u32 reserved[3];
> +	__u32 pad;
> +	__u32 reserved[2];
>  	union {
>  		struct v4l2_bt_timings_cap bt;
>  		__u32 raw_data[32];
> 

See also my comments for patch 27.

Regards,

	Hans
