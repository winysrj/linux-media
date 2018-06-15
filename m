Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:37296 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755825AbeFOHUN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 03:20:13 -0400
Subject: Re: [PATCHv15 14/35] v4l2-ctrls: support g/s_ext_ctrls for requests
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
References: <20180604114648.26159-1-hverkuil@xs4all.nl>
 <20180604114648.26159-15-hverkuil@xs4all.nl>
Message-ID: <78f38df7-9381-48aa-d2f2-91d829eef277@xs4all.nl>
Date: Fri, 15 Jun 2018 09:20:11 +0200
MIME-Version: 1.0
In-Reply-To: <20180604114648.26159-15-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/06/18 13:46, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The v4l2_g/s_ext_ctrls functions now support control handlers that
> represent requests.
> 
> The v4l2_ctrls_find_req_obj() function is responsible for finding the
> request from the fd.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/omap3isp/ispvideo.c |   2 +-
>  drivers/media/v4l2-core/v4l2-ctrls.c       | 128 +++++++++++++++++++--
>  drivers/media/v4l2-core/v4l2-ioctl.c       |  12 +-
>  drivers/media/v4l2-core/v4l2-subdev.c      |   9 +-
>  include/media/v4l2-ctrls.h                 |   7 +-
>  5 files changed, 139 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
> index 9d228eac24ea..674e7fd3ad99 100644
> --- a/drivers/media/platform/omap3isp/ispvideo.c
> +++ b/drivers/media/platform/omap3isp/ispvideo.c
> @@ -1028,7 +1028,7 @@ static int isp_video_check_external_subdevs(struct isp_video *video,
>  	ctrls.count = 1;
>  	ctrls.controls = &ctrl;
>  
> -	ret = v4l2_g_ext_ctrls(pipe->external->ctrl_handler, &ctrls);
> +	ret = v4l2_g_ext_ctrls(pipe->external->ctrl_handler, NULL, &ctrls);
>  	if (ret < 0) {
>  		dev_warn(isp->dev, "no pixel rate control in subdev %s\n",
>  			 pipe->external->name);
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index bd4818507486..ab5e8827fde0 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -3124,7 +3124,8 @@ static int class_check(struct v4l2_ctrl_handler *hdl, u32 which)
>  }
>  
>  /* Get extended controls. Allocates the helpers array if needed. */
> -int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs)
> +int __v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl,
> +		       struct v4l2_ext_controls *cs)
>  {
>  	struct v4l2_ctrl_helper helper[4];
>  	struct v4l2_ctrl_helper *helpers = helper;
> @@ -3204,6 +3205,77 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
>  		kvfree(helpers);
>  	return ret;
>  }
> +
> +static struct media_request_object *
> +v4l2_ctrls_find_req_obj(struct v4l2_ctrl_handler *hdl,
> +			struct media_request *req, bool set)
> +{
> +	struct media_request_object *obj;
> +	struct v4l2_ctrl_handler *new_hdl;
> +	int ret;
> +
> +	if (IS_ERR(req))
> +		return ERR_CAST(req);
> +
> +	if (set && WARN_ON(req->state != MEDIA_REQUEST_STATE_UPDATING))
> +		return ERR_PTR(-EBUSY);
> +
> +	obj = media_request_object_find(req, &req_ops, hdl);
> +	if (obj)
> +		return obj;
> +	if (!set)
> +		return ERR_PTR(-ENOENT);
> +
> +	new_hdl = kzalloc(sizeof(*new_hdl), GFP_KERNEL);
> +	if (!new_hdl)
> +		return ERR_PTR(-ENOMEM);
> +
> +	obj = &new_hdl->req_obj;
> +	ret = v4l2_ctrl_handler_init(new_hdl, (hdl->nr_of_buckets - 1) * 8);
> +	if (!ret)
> +		ret = v4l2_ctrl_request_bind(req, new_hdl, hdl);
> +	if (ret) {
> +		kfree(new_hdl);
> +
> +		return ERR_PTR(ret);
> +	}
> +
> +	media_request_object_get(obj);
> +	return obj;
> +}
> +
> +int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct media_device *mdev,
> +		     struct v4l2_ext_controls *cs)
> +{
> +	struct media_request_object *obj = NULL;
> +	int ret;
> +
> +	if (cs->which == V4L2_CTRL_WHICH_REQUEST_VAL) {
> +		struct media_request *req;
> +
> +		if (!mdev || cs->request_fd < 0)
> +			return -EINVAL;
> +
> +		req = media_request_get_by_fd(mdev, cs->request_fd);
> +		if (IS_ERR(req))
> +			return PTR_ERR(req);
> +
> +		obj = v4l2_ctrls_find_req_obj(hdl, req, false);
> +		/* Reference to the request held through obj */
> +		media_request_put(req);
> +		if (IS_ERR(obj))
> +			return PTR_ERR(obj);
> +
> +		hdl = container_of(obj, struct v4l2_ctrl_handler,
> +				   req_obj);
> +	}
> +
> +	ret = __v4l2_g_ext_ctrls(hdl, cs);
> +
> +	if (obj)
> +		media_request_object_put(obj);
> +	return ret;
> +}
>  EXPORT_SYMBOL(v4l2_g_ext_ctrls);
>  
>  /* Helper function to get a single control */
> @@ -3379,9 +3451,9 @@ static void update_from_auto_cluster(struct v4l2_ctrl *master)
>  }
>  
>  /* Try or try-and-set controls */
> -static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
> -			     struct v4l2_ext_controls *cs,
> -			     bool set)
> +static int __try_set_ext_ctrls(struct v4l2_fh *fh,
> +			       struct v4l2_ctrl_handler *hdl,
> +			       struct v4l2_ext_controls *cs, bool set)
>  {
>  	struct v4l2_ctrl_helper helper[4];
>  	struct v4l2_ctrl_helper *helpers = helper;
> @@ -3494,16 +3566,56 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
>  	return ret;
>  }
>  
> -int v4l2_try_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs)
> +static int try_set_ext_ctrls(struct v4l2_fh *fh,
> +			     struct v4l2_ctrl_handler *hdl, struct media_device *mdev,
> +			     struct v4l2_ext_controls *cs, bool set)
> +{
> +	struct media_request_object *obj = NULL;
> +	struct media_request *req = NULL;
> +	int ret;
> +
> +	if (cs->which == V4L2_CTRL_WHICH_REQUEST_VAL) {
> +		if (!mdev || cs->request_fd < 0)
> +			return -EINVAL;
> +
> +		req = media_request_get_by_fd(mdev, cs->request_fd);
> +		if (IS_ERR(req))
> +			return PTR_ERR(req);
> +
> +		ret = media_request_lock_for_update(req);
> +		if (ret) {
> +			media_request_put(req);

Missing call to media_request_unlock_for_update().

> +			return ret;
> +		}
> +
> +		obj = v4l2_ctrls_find_req_obj(hdl, req, set);
> +		/* Reference to the request held through obj */
> +		media_request_put(req);
> +		if (IS_ERR(obj))
> +			return PTR_ERR(obj);
> +		hdl = container_of(obj, struct v4l2_ctrl_handler,
> +				   req_obj);
> +	}
> +
> +	ret = __try_set_ext_ctrls(fh, hdl, cs, set);
> +
> +	if (obj)
> +		media_request_unlock_for_update(obj->req);

Missing call to media_request_object_put(obj)!

Regards,

	Hans

> +
> +	return ret;
> +}
> +
> +int v4l2_try_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct media_device *mdev,
> +		       struct v4l2_ext_controls *cs)
>  {
> -	return try_set_ext_ctrls(NULL, hdl, cs, false);
> +	return try_set_ext_ctrls(NULL, hdl, mdev, cs, false);
>  }
>  EXPORT_SYMBOL(v4l2_try_ext_ctrls);
>  
>  int v4l2_s_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
> -					struct v4l2_ext_controls *cs)
> +		     struct media_device *mdev, struct v4l2_ext_controls *cs)
>  {
> -	return try_set_ext_ctrls(fh, hdl, cs, true);
> +	return try_set_ext_ctrls(fh, hdl, mdev, cs, true);
>  }
>  EXPORT_SYMBOL(v4l2_s_ext_ctrls);
>  
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 3fa66103ffd0..fd3ea7e504e3 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -2094,9 +2094,9 @@ static int v4l_g_ext_ctrls(const struct v4l2_ioctl_ops *ops,
>  
>  	p->error_idx = p->count;
>  	if (vfh && vfh->ctrl_handler)
> -		return v4l2_g_ext_ctrls(vfh->ctrl_handler, p);
> +		return v4l2_g_ext_ctrls(vfh->ctrl_handler, vfd->v4l2_dev->mdev, p);
>  	if (vfd->ctrl_handler)
> -		return v4l2_g_ext_ctrls(vfd->ctrl_handler, p);
> +		return v4l2_g_ext_ctrls(vfd->ctrl_handler, vfd->v4l2_dev->mdev, p);
>  	if (ops->vidioc_g_ext_ctrls == NULL)
>  		return -ENOTTY;
>  	return check_ext_ctrls(p, 0) ? ops->vidioc_g_ext_ctrls(file, fh, p) :
> @@ -2113,9 +2113,9 @@ static int v4l_s_ext_ctrls(const struct v4l2_ioctl_ops *ops,
>  
>  	p->error_idx = p->count;
>  	if (vfh && vfh->ctrl_handler)
> -		return v4l2_s_ext_ctrls(vfh, vfh->ctrl_handler, p);
> +		return v4l2_s_ext_ctrls(vfh, vfh->ctrl_handler, vfd->v4l2_dev->mdev, p);
>  	if (vfd->ctrl_handler)
> -		return v4l2_s_ext_ctrls(NULL, vfd->ctrl_handler, p);
> +		return v4l2_s_ext_ctrls(NULL, vfd->ctrl_handler, vfd->v4l2_dev->mdev, p);
>  	if (ops->vidioc_s_ext_ctrls == NULL)
>  		return -ENOTTY;
>  	return check_ext_ctrls(p, 0) ? ops->vidioc_s_ext_ctrls(file, fh, p) :
> @@ -2132,9 +2132,9 @@ static int v4l_try_ext_ctrls(const struct v4l2_ioctl_ops *ops,
>  
>  	p->error_idx = p->count;
>  	if (vfh && vfh->ctrl_handler)
> -		return v4l2_try_ext_ctrls(vfh->ctrl_handler, p);
> +		return v4l2_try_ext_ctrls(vfh->ctrl_handler, vfd->v4l2_dev->mdev, p);
>  	if (vfd->ctrl_handler)
> -		return v4l2_try_ext_ctrls(vfd->ctrl_handler, p);
> +		return v4l2_try_ext_ctrls(vfd->ctrl_handler, vfd->v4l2_dev->mdev, p);
>  	if (ops->vidioc_try_ext_ctrls == NULL)
>  		return -ENOTTY;
>  	return check_ext_ctrls(p, 0) ? ops->vidioc_try_ext_ctrls(file, fh, p) :
> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
> index 6a7f7f75dfd7..b9cff2389eae 100644
> --- a/drivers/media/v4l2-core/v4l2-subdev.c
> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> @@ -222,17 +222,20 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>  	case VIDIOC_G_EXT_CTRLS:
>  		if (!vfh->ctrl_handler)
>  			return -ENOTTY;
> -		return v4l2_g_ext_ctrls(vfh->ctrl_handler, arg);
> +		return v4l2_g_ext_ctrls(vfh->ctrl_handler,
> +					sd->v4l2_dev->mdev, arg);
>  
>  	case VIDIOC_S_EXT_CTRLS:
>  		if (!vfh->ctrl_handler)
>  			return -ENOTTY;
> -		return v4l2_s_ext_ctrls(vfh, vfh->ctrl_handler, arg);
> +		return v4l2_s_ext_ctrls(vfh, vfh->ctrl_handler,
> +					sd->v4l2_dev->mdev, arg);
>  
>  	case VIDIOC_TRY_EXT_CTRLS:
>  		if (!vfh->ctrl_handler)
>  			return -ENOTTY;
> -		return v4l2_try_ext_ctrls(vfh->ctrl_handler, arg);
> +		return v4l2_try_ext_ctrls(vfh->ctrl_handler,
> +					  sd->v4l2_dev->mdev, arg);
>  
>  	case VIDIOC_DQEVENT:
>  		if (!(sd->flags & V4L2_SUBDEV_FL_HAS_EVENTS))
> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> index 65eade646156..de70cc3a1b80 100644
> --- a/include/media/v4l2-ctrls.h
> +++ b/include/media/v4l2-ctrls.h
> @@ -1179,11 +1179,12 @@ int v4l2_s_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
>   *	:ref:`VIDIOC_G_EXT_CTRLS <vidioc_g_ext_ctrls>` ioctl
>   *
>   * @hdl: pointer to &struct v4l2_ctrl_handler
> + * @mdev: pointer to &struct media_device
>   * @c: pointer to &struct v4l2_ext_controls
>   *
>   * If hdl == NULL then they will all return -EINVAL.
>   */
> -int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl,
> +int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct media_device *mdev,
>  		     struct v4l2_ext_controls *c);
>  
>  /**
> @@ -1191,11 +1192,13 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl,
>   *	:ref:`VIDIOC_TRY_EXT_CTRLS <vidioc_g_ext_ctrls>` ioctl
>   *
>   * @hdl: pointer to &struct v4l2_ctrl_handler
> + * @mdev: pointer to &struct media_device
>   * @c: pointer to &struct v4l2_ext_controls
>   *
>   * If hdl == NULL then they will all return -EINVAL.
>   */
>  int v4l2_try_ext_ctrls(struct v4l2_ctrl_handler *hdl,
> +		       struct media_device *mdev,
>  		       struct v4l2_ext_controls *c);
>  
>  /**
> @@ -1204,11 +1207,13 @@ int v4l2_try_ext_ctrls(struct v4l2_ctrl_handler *hdl,
>   *
>   * @fh: pointer to &struct v4l2_fh
>   * @hdl: pointer to &struct v4l2_ctrl_handler
> + * @mdev: pointer to &struct media_device
>   * @c: pointer to &struct v4l2_ext_controls
>   *
>   * If hdl == NULL then they will all return -EINVAL.
>   */
>  int v4l2_s_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
> +		     struct media_device *mdev,
>  		     struct v4l2_ext_controls *c);
>  
>  /**
> 
