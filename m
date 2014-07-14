Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754305AbaGNM2c (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 08:28:32 -0400
Message-ID: <53C3CCED.90100@redhat.com>
Date: Mon, 14 Jul 2014 14:28:29 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] libv4lconvert: add support for extended controls
References: <53BBD035.5030608@xs4all.nl>
In-Reply-To: <53BBD035.5030608@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 07/08/2014 01:04 PM, Hans Verkuil wrote:
> libv4lconvert did not support the extended control API so qv4l2, which
> uses it, didn't work properly with libv4l2 since passing software
> emulated controls using the extended control API will fail as those
> controls are obviously not known to the driver.
> 
> This patch adds support for this API.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Looks good, feel free to push:

Reviewed by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans

> ---
>  lib/include/libv4lconvert.h               |   6 ++
>  lib/libv4l2/libv4l2.c                     |  15 ++++
>  lib/libv4lconvert/control/libv4lcontrol.c | 141 ++++++++++++++++++++++++++++++
>  lib/libv4lconvert/control/libv4lcontrol.h |   3 +
>  lib/libv4lconvert/libv4lconvert.c         |  15 ++++
>  5 files changed, 180 insertions(+)
> 
> diff --git a/lib/include/libv4lconvert.h b/lib/include/libv4lconvert.h
> index 2c1f199..e94d3bd 100644
> --- a/lib/include/libv4lconvert.h
> +++ b/lib/include/libv4lconvert.h
> @@ -132,6 +132,12 @@ LIBV4L_PUBLIC int v4lconvert_vidioc_g_ctrl(struct v4lconvert_data *data,
>  		void *arg);
>  LIBV4L_PUBLIC int v4lconvert_vidioc_s_ctrl(struct v4lconvert_data *data,
>  		void *arg);
> +LIBV4L_PUBLIC int v4lconvert_vidioc_g_ext_ctrls(struct v4lconvert_data *data,
> +		void *arg);
> +LIBV4L_PUBLIC int v4lconvert_vidioc_try_ext_ctrls(struct v4lconvert_data *data,
> +		void *arg);
> +LIBV4L_PUBLIC int v4lconvert_vidioc_s_ext_ctrls(struct v4lconvert_data *data,
> +		void *arg);
>  
>  /* Is the passed in pixelformat supported as destination format? */
>  LIBV4L_PUBLIC int v4lconvert_supported_dst_format(unsigned int pixelformat);
> diff --git a/lib/libv4l2/libv4l2.c b/lib/libv4l2/libv4l2.c
> index 1dcf34d..8291ebe 100644
> --- a/lib/libv4l2/libv4l2.c
> +++ b/lib/libv4l2/libv4l2.c
> @@ -1022,6 +1022,9 @@ int v4l2_ioctl(int fd, unsigned long int request, ...)
>  	case VIDIOC_QUERYCTRL:
>  	case VIDIOC_G_CTRL:
>  	case VIDIOC_S_CTRL:
> +	case VIDIOC_G_EXT_CTRLS:
> +	case VIDIOC_TRY_EXT_CTRLS:
> +	case VIDIOC_S_EXT_CTRLS:
>  	case VIDIOC_ENUM_FRAMESIZES:
>  	case VIDIOC_ENUM_FRAMEINTERVALS:
>  		is_capture_request = 1;
> @@ -1129,6 +1132,18 @@ no_capture_request:
>  		result = v4lconvert_vidioc_s_ctrl(devices[index].convert, arg);
>  		break;
>  
> +	case VIDIOC_G_EXT_CTRLS:
> +		result = v4lconvert_vidioc_g_ext_ctrls(devices[index].convert, arg);
> +		break;
> +
> +	case VIDIOC_TRY_EXT_CTRLS:
> +		result = v4lconvert_vidioc_try_ext_ctrls(devices[index].convert, arg);
> +		break;
> +
> +	case VIDIOC_S_EXT_CTRLS:
> +		result = v4lconvert_vidioc_s_ext_ctrls(devices[index].convert, arg);
> +		break;
> +
>  	case VIDIOC_QUERYCAP: {
>  		struct v4l2_capability *cap = arg;
>  
> diff --git a/lib/libv4lconvert/control/libv4lcontrol.c b/lib/libv4lconvert/control/libv4lcontrol.c
> index ee39ba7..2fd585d 100644
> --- a/lib/libv4lconvert/control/libv4lcontrol.c
> +++ b/lib/libv4lconvert/control/libv4lcontrol.c
> @@ -916,6 +916,81 @@ int v4lcontrol_vidioc_g_ctrl(struct v4lcontrol_data *data, void *arg)
>  			VIDIOC_G_CTRL, arg);
>  }
>  
> +static void v4lcontrol_alloc_valid_controls(struct v4lcontrol_data *data,
> +			const struct v4l2_ext_controls *src,
> +			struct v4l2_ext_controls *dst)
> +{
> +	struct v4l2_ext_control *ctrl;
> +	unsigned i, j;
> +
> +	*dst = *src;
> +	if (data->controls == 0)
> +		return;
> +	ctrl = malloc(src->count * sizeof(*ctrl));
> +	if (ctrl == NULL)
> +		return;
> +	dst->controls = ctrl;
> +	dst->count = 0;
> +	for (i = 0; i < src->count; i++) {
> +		for (j = 0; j < V4LCONTROL_COUNT; j++)
> +			if ((data->controls & (1 << j)) &&
> +			    src->controls[i].id == fake_controls[j].id)
> +				break;
> +		if (j == V4LCONTROL_COUNT)
> +			ctrl[dst->count++] = src->controls[i];
> +	}
> +}
> +
> +static void v4lcontrol_free_valid_controls(struct v4lcontrol_data *data,
> +			struct v4l2_ext_controls *src,
> +			struct v4l2_ext_controls *dst)
> +{
> +	unsigned i, j, k = 0;
> +	int inc_idx;
> +
> +	src->error_idx = dst->error_idx;
> +	if (dst->controls == src->controls)
> +		return;
> +
> +	inc_idx = dst->error_idx < dst->count;
> +	for (i = 0; i < src->count; i++) {
> +		for (j = 0; j < V4LCONTROL_COUNT; j++)
> +			if ((data->controls & (1 << j)) &&
> +			    src->controls[i].id == fake_controls[j].id)
> +				break;
> +		if (j == V4LCONTROL_COUNT)
> +			src->controls[i] = dst->controls[k++];
> +		else if (inc_idx)
> +			src->error_idx++;
> +	}
> +	free(dst->controls);
> +}
> +
> +int v4lcontrol_vidioc_g_ext_ctrls(struct v4lcontrol_data *data, void *arg)
> +{
> +	struct v4l2_ext_controls *ctrls = arg;
> +	struct v4l2_ext_controls dst;
> +	int i, j;
> +	int res;
> +
> +	v4lcontrol_alloc_valid_controls(data, ctrls, &dst);
> +	res = data->dev_ops->ioctl(data->dev_ops_priv, data->fd,
> +			VIDIOC_G_EXT_CTRLS, &dst);
> +	v4lcontrol_free_valid_controls(data, ctrls, &dst);
> +	if (res)
> +		return res;
> +
> +	for (i = 0; i < ctrls->count; i++) {
> +		for (j = 0; j < V4LCONTROL_COUNT; j++)
> +			if ((data->controls & (1 << j)) &&
> +			    ctrls->controls[i].id == fake_controls[j].id) {
> +				ctrls->controls[i].value = data->shm_values[j];
> +				break;
> +			}
> +	}
> +	return 0;
> +}
> +
>  int v4lcontrol_vidioc_s_ctrl(struct v4lcontrol_data *data, void *arg)
>  {
>  	int i;
> @@ -938,6 +1013,72 @@ int v4lcontrol_vidioc_s_ctrl(struct v4lcontrol_data *data, void *arg)
>  			VIDIOC_S_CTRL, arg);
>  }
>  
> +static int v4lcontrol_validate_ext_ctrls(struct v4lcontrol_data *data,
> +		struct v4l2_ext_controls *ctrls)
> +{
> +	int i, j;
> +
> +	if (data->controls == 0)
> +		return 0;
> +	for (i = 0; i < ctrls->count; i++) {
> +		for (j = 0; j < V4LCONTROL_COUNT; j++)
> +			if ((data->controls & (1 << j)) &&
> +			    ctrls->controls[i].id == fake_controls[j].id) {
> +				if (ctrls->controls[i].value > fake_controls[j].maximum ||
> +				    ctrls->controls[i].value < fake_controls[j].minimum) {
> +					ctrls->error_idx = i;
> +					errno = EINVAL;
> +					return -1;
> +				}
> +			}
> +	}
> +	return 0;
> +}
> +
> +int v4lcontrol_vidioc_try_ext_ctrls(struct v4lcontrol_data *data, void *arg)
> +{
> +	struct v4l2_ext_controls *ctrls = arg;
> +	struct v4l2_ext_controls dst;
> +	int res = v4lcontrol_validate_ext_ctrls(data, ctrls);
> +
> +	if (res)
> +		return res;
> +
> +	v4lcontrol_alloc_valid_controls(data, ctrls, &dst);
> +	res = data->dev_ops->ioctl(data->dev_ops_priv, data->fd,
> +			VIDIOC_TRY_EXT_CTRLS, &dst);
> +	v4lcontrol_free_valid_controls(data, ctrls, &dst);
> +	return res;
> +}
> +
> +int v4lcontrol_vidioc_s_ext_ctrls(struct v4lcontrol_data *data, void *arg)
> +{
> +	struct v4l2_ext_controls *ctrls = arg;
> +	struct v4l2_ext_controls dst;
> +	int i, j;
> +	int res = v4lcontrol_validate_ext_ctrls(data, ctrls);
> +
> +	if (res)
> +		return res;
> +
> +	v4lcontrol_alloc_valid_controls(data, ctrls, &dst);
> +	res = data->dev_ops->ioctl(data->dev_ops_priv, data->fd,
> +			VIDIOC_S_EXT_CTRLS, &dst);
> +	v4lcontrol_free_valid_controls(data, ctrls, &dst);
> +	if (res)
> +		return res;
> +
> +	for (i = 0; i < ctrls->count; i++) {
> +		for (j = 0; j < V4LCONTROL_COUNT; j++)
> +			if ((data->controls & (1 << j)) &&
> +			    ctrls->controls[i].id == fake_controls[j].id) {
> +				data->shm_values[j] = ctrls->controls[i].value;
> +				break;
> +			}
> +	}
> +	return 0;
> +}
> +
>  int v4lcontrol_get_bandwidth(struct v4lcontrol_data *data)
>  {
>  	return data->bandwidth;
> diff --git a/lib/libv4lconvert/control/libv4lcontrol.h b/lib/libv4lconvert/control/libv4lcontrol.h
> index 804f1c5..fa9cf42 100644
> --- a/lib/libv4lconvert/control/libv4lcontrol.h
> +++ b/lib/libv4lconvert/control/libv4lcontrol.h
> @@ -72,5 +72,8 @@ int v4lcontrol_needs_conversion(struct v4lcontrol_data *data);
>  int v4lcontrol_vidioc_queryctrl(struct v4lcontrol_data *data, void *arg);
>  int v4lcontrol_vidioc_g_ctrl(struct v4lcontrol_data *data, void *arg);
>  int v4lcontrol_vidioc_s_ctrl(struct v4lcontrol_data *data, void *arg);
> +int v4lcontrol_vidioc_g_ext_ctrls(struct v4lcontrol_data *data, void *arg);
> +int v4lcontrol_vidioc_try_ext_ctrls(struct v4lcontrol_data *data, void *arg);
> +int v4lcontrol_vidioc_s_ext_ctrls(struct v4lcontrol_data *data, void *arg);
>  
>  #endif
> diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lconvert.c
> index acb8085..7ee7c19 100644
> --- a/lib/libv4lconvert/libv4lconvert.c
> +++ b/lib/libv4lconvert/libv4lconvert.c
> @@ -1659,6 +1659,21 @@ int v4lconvert_vidioc_s_ctrl(struct v4lconvert_data *data, void *arg)
>  	return v4lcontrol_vidioc_s_ctrl(data->control, arg);
>  }
>  
> +int v4lconvert_vidioc_g_ext_ctrls(struct v4lconvert_data *data, void *arg)
> +{
> +	return v4lcontrol_vidioc_g_ext_ctrls(data->control, arg);
> +}
> +
> +int v4lconvert_vidioc_try_ext_ctrls(struct v4lconvert_data *data, void *arg)
> +{
> +	return v4lcontrol_vidioc_try_ext_ctrls(data->control, arg);
> +}
> +
> +int v4lconvert_vidioc_s_ext_ctrls(struct v4lconvert_data *data, void *arg)
> +{
> +	return v4lcontrol_vidioc_s_ext_ctrls(data->control, arg);
> +}
> +
>  int v4lconvert_get_fps(struct v4lconvert_data *data)
>  {
>  	return data->fps;
> 
