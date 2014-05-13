Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52577 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbaEMQv0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 May 2014 12:51:26 -0400
Date: Tue, 13 May 2014 13:51:20 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH v4 05/49] v4l: Add pad-level DV timings subdev
 operations
Message-ID: <20140513135120.3545bfad@recife.lan>
In-Reply-To: <1397744000-23967-6-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1397744000-23967-1-git-send-email-laurent.pinchart@ideasonboard.com>
	<1397744000-23967-6-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 17 Apr 2014 16:12:36 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  include/media/v4l2-subdev.h    |  4 ++++
>  include/uapi/linux/videodev2.h | 10 ++++++++--
>  2 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index ee1cb2d..341ca4d 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -510,6 +510,10 @@ struct v4l2_subdev_pad_ops {
>  			     struct v4l2_subdev_selection *sel);
>  	int (*get_edid)(struct v4l2_subdev *sd, struct v4l2_edid *edid);
>  	int (*set_edid)(struct v4l2_subdev *sd, struct v4l2_edid *edid);
> +	int (*dv_timings_cap)(struct v4l2_subdev *sd,
> +			      struct v4l2_dv_timings_cap *cap);
> +	int (*enum_dv_timings)(struct v4l2_subdev *sd,
> +			       struct v4l2_enum_dv_timings *timings);
>  #ifdef CONFIG_MEDIA_CONTROLLER
>  	int (*link_validate)(struct v4l2_subdev *sd, struct media_link *link,
>  			     struct v4l2_subdev_format *source_fmt,
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index ea468ee..8e5077e 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -1107,12 +1107,15 @@ struct v4l2_dv_timings {
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
> @@ -1150,11 +1153,14 @@ struct v4l2_bt_timings_cap {
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

Please document its usage at the media DocBook.

> +	__u32 reserved[2];
>  	union {
>  		struct v4l2_bt_timings_cap bt;
>  		__u32 raw_data[32];
