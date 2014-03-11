Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1376 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431AbaCKK1v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 06:27:51 -0400
Message-ID: <531EE4F7.9070807@xs4all.nl>
Date: Tue, 11 Mar 2014 11:27:03 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH v2 06/48] v4l: Add pad-level DV timings subdev operations
References: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com> <1394493359-14115-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1394493359-14115-7-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

On 03/11/14 00:15, Laurent Pinchart wrote:
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  include/media/v4l2-subdev.h    |  4 ++++
>  include/uapi/linux/videodev2.h | 10 ++++++++--
>  2 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 1752530..2b5ec32 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -509,6 +509,10 @@ struct v4l2_subdev_pad_ops {
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
> index 17acba8..72fbbd4 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -1103,12 +1103,15 @@ struct v4l2_dv_timings {
>  
>  /** struct v4l2_enum_dv_timings - DV timings enumeration
>   * @index:	enumeration index
> + * @pad:	the pad number for which to enumerate timings (used with
> + *		v4l-subdev nodes only)
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
> @@ -1146,11 +1149,14 @@ struct v4l2_bt_timings_cap {
>  
>  /** struct v4l2_dv_timings_cap - DV timings capabilities
>   * @type:	the type of the timings (same as in struct v4l2_dv_timings)
> + * @pad:	the pad number for which to query capabilities (used with
> + *		v4l-subdev nodes only)
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

