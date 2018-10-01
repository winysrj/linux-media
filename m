Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:52214 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728804AbeJAQRB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 Oct 2018 12:17:01 -0400
Subject: Re: [PATCH v2 1/6] media: video-i2c: avoid accessing released memory
 area when removing driver
To: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org
Cc: Matt Ranostay <matt.ranostay@konsulko.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1537720492-31201-1-git-send-email-akinobu.mita@gmail.com>
 <1537720492-31201-2-git-send-email-akinobu.mita@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <faa8cdeb-d824-f2ef-9d87-53d1af3ec468@xs4all.nl>
Date: Mon, 1 Oct 2018 11:40:00 +0200
MIME-Version: 1.0
In-Reply-To: <1537720492-31201-2-git-send-email-akinobu.mita@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/23/2018 06:34 PM, Akinobu Mita wrote:
> The video_i2c_data is allocated by kzalloc and released by the video
> device's release callback.  The release callback is called when
> video_unregister_device() is called, but it will still be accessed after
> calling video_unregister_device().
> 
> Fix the use after free by allocating video_i2c_data by devm_kzalloc() with
> i2c_client->dev so that it will automatically be released when the i2c
> driver is removed.

Hmm. The patch is right, but the explanation isn't. The core problem is
that vdev.release was set to video_i2c_release, but that should only be
used if struct video_device was kzalloc'ed. But in this case it is embedded
in a larger struct, and then vdev.release should always be set to
video_device_release_empty.

That was the real reason for the invalid access.

Regards,

	Hans

> 
> Fixes: 5cebaac60974 ("media: video-i2c: add video-i2c driver")
> Cc: Matt Ranostay <matt.ranostay@konsulko.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Hans Verkuil <hansverk@cisco.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Acked-by: Matt Ranostay <matt.ranostay@konsulko.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
> * v2
> - Update commit log to clarify the use after free
> - Add Acked-by tag
> 
>  drivers/media/i2c/video-i2c.c | 18 +++++-------------
>  1 file changed, 5 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/media/i2c/video-i2c.c b/drivers/media/i2c/video-i2c.c
> index 06d29d8..b7a2af9 100644
> --- a/drivers/media/i2c/video-i2c.c
> +++ b/drivers/media/i2c/video-i2c.c
> @@ -508,20 +508,15 @@ static const struct v4l2_ioctl_ops video_i2c_ioctl_ops = {
>  	.vidioc_streamoff		= vb2_ioctl_streamoff,
>  };
>  
> -static void video_i2c_release(struct video_device *vdev)
> -{
> -	kfree(video_get_drvdata(vdev));
> -}
> -
>  static int video_i2c_probe(struct i2c_client *client,
>  			     const struct i2c_device_id *id)
>  {
>  	struct video_i2c_data *data;
>  	struct v4l2_device *v4l2_dev;
>  	struct vb2_queue *queue;
> -	int ret = -ENODEV;
> +	int ret;
>  
> -	data = kzalloc(sizeof(*data), GFP_KERNEL);
> +	data = devm_kzalloc(&client->dev, sizeof(*data), GFP_KERNEL);
>  	if (!data)
>  		return -ENOMEM;
>  
> @@ -530,7 +525,7 @@ static int video_i2c_probe(struct i2c_client *client,
>  	else if (id)
>  		data->chip = &video_i2c_chip[id->driver_data];
>  	else
> -		goto error_free_device;
> +		return -ENODEV;
>  
>  	data->client = client;
>  	v4l2_dev = &data->v4l2_dev;
> @@ -538,7 +533,7 @@ static int video_i2c_probe(struct i2c_client *client,
>  
>  	ret = v4l2_device_register(&client->dev, v4l2_dev);
>  	if (ret < 0)
> -		goto error_free_device;
> +		return ret;
>  
>  	mutex_init(&data->lock);
>  	mutex_init(&data->queue_lock);
> @@ -568,7 +563,7 @@ static int video_i2c_probe(struct i2c_client *client,
>  	data->vdev.fops = &video_i2c_fops;
>  	data->vdev.lock = &data->lock;
>  	data->vdev.ioctl_ops = &video_i2c_ioctl_ops;
> -	data->vdev.release = video_i2c_release;
> +	data->vdev.release = video_device_release_empty;
>  	data->vdev.device_caps = V4L2_CAP_VIDEO_CAPTURE |
>  				 V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
>  
> @@ -597,9 +592,6 @@ static int video_i2c_probe(struct i2c_client *client,
>  	mutex_destroy(&data->lock);
>  	mutex_destroy(&data->queue_lock);
>  
> -error_free_device:
> -	kfree(data);
> -
>  	return ret;
>  }
>  
> 
