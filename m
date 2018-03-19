Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:45360 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755291AbeCSJrI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 05:47:08 -0400
Subject: Re: [RFC, libv4l]: Make libv4l2 usable on devices with complex
 pipeline
To: Pavel Machek <pavel@ucw.cz>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        pali.rohar@gmail.com, sre@kernel.org,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com
References: <20170426105300.GA857@amd> <20170426081330.6ca10e42@vento.lan>
 <20170426132337.GA6482@amd> <cedfd68d-d0fe-6fa8-2676-b61f3ddda652@gmail.com>
 <20170508222819.GA14833@amd> <db37ee9a-9675-d1db-5d2e-b0549ba004fd@xs4all.nl>
 <20170509110440.GC28248@amd> <c4f61bc5-6650-9468-5fbf-8041403a0ef2@xs4all.nl>
 <20170516124519.GA25650@amd> <76e09f45-8f04-1149-a744-ccb19f36871a@xs4all.nl>
 <20180316205512.GA6069@amd>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c2a7e1f3-589d-7186-2a85-545bfa1c4536@xs4all.nl>
Date: Mon, 19 Mar 2018 10:47:00 +0100
MIME-Version: 1.0
In-Reply-To: <20180316205512.GA6069@amd>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

I really don't want to add functions for this to libv4l2. That's just a
quick hack. The real solution is to parse this from a config file. But
that is a lot more work and it is something that needs to be designed
properly.

And that requires someone to put in the time and effort...

Regards,

	Hans

On 03/16/2018 09:55 PM, Pavel Machek wrote:
> Hi!
> 
> What about something like this?
> 
> Pass map of controls and expects fds to libv4l2...
>  
> +static struct v4l2_controls_map map = {
> +  .num_fds = 2,
> +  .num_controls = 3,
> +  .map = { [0] = { .control = 0x00980913, .fd = 1 },
> +	   [1] = { .control = V4L2_CID_EXPOSURE_ABSOLUTE, .fd = 1 },
> +	   [2] = { .control = V4L2_CID_FOCUS_ABSOLUTE, .fd = 2 },
> +	   
> +         },
> +};
> +
> +static void open_chk(char *name, int fd)
> +{
> +	int f = open(name, O_RDWR);
> +
> +	if (fd != f) {
> +	  printf("Unexpected error %m opening %s\n", name);
> +	  exit(1);
> +	}
> +}
> +
> +static void cam_open_n900(struct dev_info *dev)
> +{
> +	struct v4l2_format *fmt = &dev->fmt;
> +	int fd;
> +	
> +	map.main_fd = open("/dev/video_ccdc", O_RDWR);
> +
> +	open_chk("/dev/video_sensor", map.main_fd+1);
> +	open_chk("/dev/video_focus", map.main_fd+2);
> +	//	open_chk("/dev/video_flash", map.main_fd+3);
> +
> +	v4l2_open_pipeline(&map, 0);
> +	dev->fd = map.main_fd;
> +
> 
> ...so you can use it on complex devices. Tested on my N900.
> 
> I guess later helper would be added that would parse some kind of
> descritption file and do open_pipeline(). But.. lets solve that
> next. In the first place, it would be nice to have libv4l2 usable on
> complex devices.
> 
> Best regards,
> 							Pavel
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> diff --git a/lib/include/libv4l2.h b/lib/include/libv4l2.h
> index ea1870d..6220dfd 100644
> --- a/lib/include/libv4l2.h
> +++ b/lib/include/libv4l2.h
> @@ -109,6 +109,23 @@ LIBV4L_PUBLIC int v4l2_get_control(int fd, int cid);
>     (note the fd is left open in this case). */
>  LIBV4L_PUBLIC int v4l2_fd_open(int fd, int v4l2_flags);
>  
> +struct v4l2_control_map {
> +	unsigned long control;
> +	int fd;
> +};
> +
> +struct v4l2_controls_map {
> +	int main_fd;
> +	int num_fds;
> +	int num_controls;
> +	struct v4l2_control_map map[];
> +};
> +
> +LIBV4L_PUBLIC int v4l2_open_pipeline(struct v4l2_controls_map *map, int v4l2_flags);
> +
> +LIBV4L_PUBLIC int v4l2_get_fd_for_control(int fd, unsigned long control);
> +
> +
>  #ifdef __cplusplus
>  }
>  #endif /* __cplusplus */
> diff --git a/lib/libv4l2/libv4l2-priv.h b/lib/libv4l2/libv4l2-priv.h
> index 1924c91..ebe5dad 100644
> --- a/lib/libv4l2/libv4l2-priv.h
> +++ b/lib/libv4l2/libv4l2-priv.h
> @@ -104,6 +104,7 @@ struct v4l2_dev_info {
>  	void *plugin_library;
>  	void *dev_ops_priv;
>  	const struct libv4l_dev_ops *dev_ops;
> +	struct v4l2_controls_map *map;
>  };
>  
>  /* From v4l2-plugin.c */
> diff --git a/lib/libv4l2/libv4l2.c b/lib/libv4l2/libv4l2.c
> index 2db25d1..b3ae70b 100644
> --- a/lib/libv4l2/libv4l2.c
> +++ b/lib/libv4l2/libv4l2.c
> @@ -787,6 +787,8 @@ no_capture:
>  	if (index >= devices_used)
>  		devices_used = index + 1;
>  
> +	devices[index].map = NULL;
> +
>  	/* Note we always tell v4lconvert to optimize src fmt selection for
>  	   our default fps, the only exception is the app explicitly selecting
>  	   a frame rate using the S_PARM ioctl after a S_FMT */
> @@ -1056,12 +1058,39 @@ static int v4l2_s_fmt(int index, struct v4l2_format *dest_fmt)
>  	return 0;
>  }
>  
> +int v4l2_get_fd_for_control(int fd, unsigned long control)
> +{
> +	int index = v4l2_get_index(fd);
> +	struct v4l2_controls_map *map = devices[index].map;
> +	int lo = 0;
> +	int hi = map->num_controls;
> +
> +	while (lo < hi) {
> +		int i = (lo + hi) / 2;
> +		if (map->map[i].control == control) {
> +			return map->map[i].fd + fd;
> +		}
> +		if (map->map[i].control > control) {
> +			hi = i;
> +			continue;
> +		}
> +		if (map->map[i].control < control) {
> +			lo = i+1;
> +			continue;
> +		}
> +		printf("Bad: impossible condition in binary search\n");
> +		exit(1);
> +	}
> +	return fd;
> +}
> +
>  int v4l2_ioctl(int fd, unsigned long int request, ...)
>  {
>  	void *arg;
>  	va_list ap;
>  	int result, index, saved_err;
> -	int is_capture_request = 0, stream_needs_locking = 0;
> +	int is_capture_request = 0, stream_needs_locking = 0, 
> +	    is_subdev_request = 0;
>  
>  	va_start(ap, request);
>  	arg = va_arg(ap, void *);
> @@ -1076,18 +1105,20 @@ int v4l2_ioctl(int fd, unsigned long int request, ...)
>  	   ioctl, causing it to get sign extended, depending upon this behavior */
>  	request = (unsigned int)request;
>  
> +	/* FIXME */
>  	if (devices[index].convert == NULL)
>  		goto no_capture_request;
>  
>  	/* Is this a capture request and do we need to take the stream lock? */
>  	switch (request) {
> -	case VIDIOC_QUERYCAP:
>  	case VIDIOC_QUERYCTRL:
>  	case VIDIOC_G_CTRL:
>  	case VIDIOC_S_CTRL:
>  	case VIDIOC_G_EXT_CTRLS:
> -	case VIDIOC_TRY_EXT_CTRLS:
>  	case VIDIOC_S_EXT_CTRLS:
> +		is_subdev_request = 1;
> +	case VIDIOC_QUERYCAP:
> +	case VIDIOC_TRY_EXT_CTRLS:
>  	case VIDIOC_ENUM_FRAMESIZES:
>  	case VIDIOC_ENUM_FRAMEINTERVALS:
>  		is_capture_request = 1;
> @@ -1151,10 +1182,15 @@ int v4l2_ioctl(int fd, unsigned long int request, ...)
>  	}
>  
>  	if (!is_capture_request) {
> +	  int sub_fd;
>  no_capture_request:
> +		  sub_fd = fd;
> +		if (is_subdev_request) {
> +		  sub_fd = v4l2_get_fd_for_control(index, ((struct v4l2_queryctrl *) arg)->id);
> +		}
>  		result = devices[index].dev_ops->ioctl(
>  				devices[index].dev_ops_priv,
> -				fd, request, arg);
> +				sub_fd, request, arg);
>  		saved_err = errno;
>  		v4l2_log_ioctl(request, arg, result);
>  		errno = saved_err;
> @@ -1782,3 +1818,28 @@ int v4l2_get_control(int fd, int cid)
>  			(qctrl.maximum - qctrl.minimum) / 2) /
>  		(qctrl.maximum - qctrl.minimum);
>  }
> +
> +
> +int v4l2_open_pipeline(struct v4l2_controls_map *map, int v4l2_flags)
> +{
> +	int index;
> +	int i;
> +
> +	for (i=0; i<map->num_controls; i++) {
> +	  printf("%lx %d\n", map->map[i].control, map->map[i].fd);
> +	  if (map->map[i].fd <= 0) {
> +	    printf("Bad fd in map\n");
> +	    return -1;
> +	  }
> +	  if (i>=1 && map->map[i].control <= map->map[i-1].control) {
> +	    printf("Not sorted\n");
> +	    return -1;
> +	  }
> +	}
> +
> +	v4l2_fd_open(map->main_fd, v4l2_flags);
> +	index = v4l2_get_index(map->main_fd);
> +	devices[index].map = map;
> +	return 0;
> +}
> +
> diff --git a/lib/libv4lconvert/control/libv4lcontrol.c b/lib/libv4lconvert/control/libv4lcontrol.c
> index 1e784ed..1963e7e 100644
> --- a/lib/libv4lconvert/control/libv4lcontrol.c
> +++ b/lib/libv4lconvert/control/libv4lcontrol.c
> @@ -865,6 +865,7 @@ int v4lcontrol_vidioc_queryctrl(struct v4lcontrol_data *data, void *arg)
>  	struct v4l2_queryctrl *ctrl = arg;
>  	int retval;
>  	uint32_t orig_id = ctrl->id;
> +	int fd;
>  
>  	/* if we have an exact match return it */
>  	for (i = 0; i < V4LCONTROL_COUNT; i++)
> @@ -874,8 +875,9 @@ int v4lcontrol_vidioc_queryctrl(struct v4lcontrol_data *data, void *arg)
>  			return 0;
>  		}
>  
> +	fd = v4l2_get_fd_for_control(data->fd, ctrl->id);
>  	/* find out what the kernel driver would respond. */
> -	retval = data->dev_ops->ioctl(data->dev_ops_priv, data->fd,
> +	retval = data->dev_ops->ioctl(data->dev_ops_priv, fd,
>  			VIDIOC_QUERYCTRL, arg);
>  
>  	if ((data->priv_flags & V4LCONTROL_SUPPORTS_NEXT_CTRL) &&
> @@ -905,6 +907,7 @@ int v4lcontrol_vidioc_g_ctrl(struct v4lcontrol_data *data, void *arg)
>  {
>  	int i;
>  	struct v4l2_control *ctrl = arg;
> +	int fd;
>  
>  	for (i = 0; i < V4LCONTROL_COUNT; i++)
>  		if ((data->controls & (1 << i)) &&
> @@ -913,7 +916,8 @@ int v4lcontrol_vidioc_g_ctrl(struct v4lcontrol_data *data, void *arg)
>  			return 0;
>  		}
>  
> -	return data->dev_ops->ioctl(data->dev_ops_priv, data->fd,
> +	fd = v4l2_get_fd_for_control(data->fd, ctrl->id);
> +	return data->dev_ops->ioctl(data->dev_ops_priv, fd,
>  			VIDIOC_G_CTRL, arg);
>  }
>  
> @@ -996,6 +1000,7 @@ int v4lcontrol_vidioc_s_ctrl(struct v4lcontrol_data *data, void *arg)
>  {
>  	int i;
>  	struct v4l2_control *ctrl = arg;
> +	int fd;
>  
>  	for (i = 0; i < V4LCONTROL_COUNT; i++)
>  		if ((data->controls & (1 << i)) &&
> @@ -1010,7 +1015,8 @@ int v4lcontrol_vidioc_s_ctrl(struct v4lcontrol_data *data, void *arg)
>  			return 0;
>  		}
>  
> -	return data->dev_ops->ioctl(data->dev_ops_priv, data->fd,
> +	fd = v4l2_get_fd_for_control(data->fd, ctrl->id);
> +	return data->dev_ops->ioctl(data->dev_ops_priv, fd,
>  			VIDIOC_S_CTRL, arg);
>  }
>  
> 
> 
