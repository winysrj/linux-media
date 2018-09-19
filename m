Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:14507 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731025AbeISQMv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Sep 2018 12:12:51 -0400
Date: Wed, 19 Sep 2018 13:35:31 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH 1/5] media: video-i2c: avoid accessing released memory
 area when removing driver
Message-ID: <20180919103531.k5yhvngj6gdgdnq2@paasikivi.fi.intel.com>
References: <1537200191-17956-1-git-send-email-akinobu.mita@gmail.com>
 <1537200191-17956-2-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1537200191-17956-2-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mita-san,

On Tue, Sep 18, 2018 at 01:03:07AM +0900, Akinobu Mita wrote:
> The struct video_i2c_data is released when video_unregister_device() is
> called, but it will still be accessed after calling
> video_unregister_device().
> 
> Use devm_kzalloc() and let the memory be automatically released on driver
> detach.
> 
> Fixes: 5cebaac60974 ("media: video-i2c: add video-i2c driver")
> Cc: Matt Ranostay <matt.ranostay@konsulko.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Hans Verkuil <hansverk@cisco.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
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

This is actually correct: it ensures that that the device data stays in
place as long as the device is being accessed. Allocating device data with
devm_kzalloc() no longer guarantees that, and is not the right thing to do
for that reason.

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

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
