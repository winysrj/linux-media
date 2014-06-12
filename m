Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52661 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752742AbaFLMjS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 08:39:18 -0400
Date: Thu, 12 Jun 2014 15:38:44 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv4 PATCH 04/34] videodev2.h: add struct
 v4l2_query_ext_ctrl and VIDIOC_QUERY_EXT_CTRL.
Message-ID: <20140612123843.GO2073@valkosipuli.retiisi.org.uk>
References: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
 <5c0945c0e8a31f17fab4a8d6c5f797b8c70a7a5f.1402573818.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c0945c0e8a31f17fab4a8d6c5f797b8c70a7a5f.1402573818.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thu, Jun 12, 2014 at 01:52:36PM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add a new struct and ioctl to extend the amount of information you can
> get for a control.
> 
> The range is now a s64 type, and array dimensions and element size can be
> reported through nr_of_dims/dims/elems/elem_size.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  include/uapi/linux/videodev2.h | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 438c4a6..7d94adc 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -1269,6 +1269,7 @@ struct v4l2_ext_controls {
>  #define V4L2_CTRL_ID_MASK      	  (0x0fffffff)
>  #define V4L2_CTRL_ID2CLASS(id)    ((id) & 0x0fff0000UL)
>  #define V4L2_CTRL_DRIVER_PRIV(id) (((id) & 0xffff) >= 0x1000)
> +#define V4L2_CTRL_MAX_DIMS	  (8)
>  
>  enum v4l2_ctrl_type {
>  	V4L2_CTRL_TYPE_INTEGER	     = 1,
> @@ -1298,6 +1299,23 @@ struct v4l2_queryctrl {
>  	__u32		     reserved[2];
>  };
>  
> +/*  Used in the VIDIOC_QUERY_EXT_CTRL ioctl for querying extended controls */
> +struct v4l2_query_ext_ctrl {
> +	__u32		     id;
> +	__u32		     type;
> +	char		     name[32];
> +	__s64		     minimum;
> +	__s64		     maximum;
> +	__u64		     step;
> +	__s64		     default_value;
> +	__u32                flags;
> +	__u32                elem_size;
> +	__u32                elems;
> +	__u32                nr_of_dims;
> +	__u32                dims[V4L2_CTRL_MAX_DIMS];
> +	__u32		     reserved[16];

Considering that units are going to be added (probably 16 or even 32 bytes),
I might add even more. Something to be discussed is fractional parts which
is a related topic.

As you have already 34 patches in your set, perhaps it'd be good to postpone
these.

> +};
> +
>  /*  Used in the VIDIOC_QUERYMENU ioctl for querying menu items */
>  struct v4l2_querymenu {
>  	__u32		id;
> @@ -2011,6 +2029,8 @@ struct v4l2_create_buffers {
>     Never use these in applications! */
>  #define VIDIOC_DBG_G_CHIP_INFO  _IOWR('V', 102, struct v4l2_dbg_chip_info)
>  
> +#define VIDIOC_QUERY_EXT_CTRL	_IOWR('V', 103, struct v4l2_query_ext_ctrl)
> +
>  /* Reminder: when adding new ioctls please add support for them to
>     drivers/media/video/v4l2-compat-ioctl32.c as well! */
>  

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
