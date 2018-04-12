Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56880 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752469AbeDLMYl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 08:24:41 -0400
Date: Thu, 12 Apr 2018 15:24:39 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Subject: Re: [RFCv11 PATCH 08/29] videodev2.h: add request_fd field to
 v4l2_ext_controls
Message-ID: <20180412122439.i2a6yajrp7cfejuj@valkosipuli.retiisi.org.uk>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
 <20180409142026.19369-9-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180409142026.19369-9-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 09, 2018 at 04:20:05PM +0200, Hans Verkuil wrote:
> From: Alexandre Courbot <acourbot@chromium.org>
> 
> If which is V4L2_CTRL_WHICH_REQUEST, then the request_fd field can be
> used to specify a request for the G/S/TRY_EXT_CTRLS ioctls.
> 
> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
> ---
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 5 ++++-
>  drivers/media/v4l2-core/v4l2-ioctl.c          | 6 +++---
>  include/uapi/linux/videodev2.h                | 4 +++-
>  3 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> index 5198c9eeb348..0782b3666deb 100644
> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> @@ -732,7 +732,8 @@ struct v4l2_ext_controls32 {
>  	__u32 which;
>  	__u32 count;
>  	__u32 error_idx;
> -	__u32 reserved[2];
> +	__s32 request_fd;
> +	__u32 reserved[1];

No need for an array.

>  	compat_caddr_t controls; /* actually struct v4l2_ext_control32 * */
>  };
>  
> @@ -807,6 +808,7 @@ static int get_v4l2_ext_controls32(struct file *file,
>  	    get_user(count, &up->count) ||
>  	    put_user(count, &kp->count) ||
>  	    assign_in_user(&kp->error_idx, &up->error_idx) ||
> +	    assign_in_user(&kp->request_fd, &up->request_fd) ||
>  	    copy_in_user(kp->reserved, up->reserved, sizeof(kp->reserved)))
>  		return -EFAULT;
>  
> @@ -865,6 +867,7 @@ static int put_v4l2_ext_controls32(struct file *file,
>  	    get_user(count, &kp->count) ||
>  	    put_user(count, &up->count) ||
>  	    assign_in_user(&up->error_idx, &kp->error_idx) ||
> +	    assign_in_user(&up->request_fd, &kp->request_fd) ||
>  	    copy_in_user(up->reserved, kp->reserved, sizeof(up->reserved)) ||
>  	    get_user(kcontrols, &kp->controls))
>  		return -EFAULT;
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index f48c505550e0..9ce23e23c5bf 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -553,8 +553,8 @@ static void v4l_print_ext_controls(const void *arg, bool write_only)
>  	const struct v4l2_ext_controls *p = arg;
>  	int i;
>  
> -	pr_cont("which=0x%x, count=%d, error_idx=%d",
> -			p->which, p->count, p->error_idx);
> +	pr_cont("which=0x%x, count=%d, error_idx=%d, request_fd=%d",
> +			p->which, p->count, p->error_idx, p->request_fd);
>  	for (i = 0; i < p->count; i++) {
>  		if (!p->controls[i].size)
>  			pr_cont(", id/val=0x%x/0x%x",
> @@ -870,7 +870,7 @@ static int check_ext_ctrls(struct v4l2_ext_controls *c, int allow_priv)
>  	__u32 i;
>  
>  	/* zero the reserved fields */
> -	c->reserved[0] = c->reserved[1] = 0;
> +	c->reserved[0] = 0;
>  	for (i = 0; i < c->count; i++)
>  		c->controls[i].reserved2[0] = 0;
>  
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 600877be5c22..6f41baa53787 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -1592,7 +1592,8 @@ struct v4l2_ext_controls {
>  	};
>  	__u32 count;
>  	__u32 error_idx;
> -	__u32 reserved[2];
> +	__s32 request_fd;
> +	__u32 reserved[1];
>  	struct v4l2_ext_control *controls;
>  };
>  
> @@ -1605,6 +1606,7 @@ struct v4l2_ext_controls {
>  #define V4L2_CTRL_MAX_DIMS	  (4)
>  #define V4L2_CTRL_WHICH_CUR_VAL   0
>  #define V4L2_CTRL_WHICH_DEF_VAL   0x0f000000
> +#define V4L2_CTRL_WHICH_REQUEST   0x0f010000
>  
>  enum v4l2_ctrl_type {
>  	V4L2_CTRL_TYPE_INTEGER	     = 1,
> -- 
> 2.16.3
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
