Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52375 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaEKUq2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 May 2014 16:46:28 -0400
Received: by mail-ee0-f46.google.com with SMTP id t10so4048175eei.33
        for <linux-media@vger.kernel.org>; Sun, 11 May 2014 13:46:27 -0700 (PDT)
Message-ID: <536FE1B8.2090603@googlemail.com>
Date: Sun, 11 May 2014 22:46:48 +0200
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, m.chehab@samsung.com
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 03/19] em28xx: start moving em28xx-v4l specific data to
 its own struct
References: <1395689605-2705-1-git-send-email-fschaefer.oss@googlemail.com> <1395689605-2705-4-git-send-email-fschaefer.oss@googlemail.com> <536C9D1F.7040804@xs4all.nl>
In-Reply-To: <536C9D1F.7040804@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 09.05.2014 11:17, schrieb Hans Verkuil:
> Some comments for future improvements:
>
> On 03/24/2014 08:33 PM, Frank Schäfer wrote:
>> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
>> ---
>>  drivers/media/usb/em28xx/em28xx-camera.c |   4 +-
>>  drivers/media/usb/em28xx/em28xx-video.c  | 160 +++++++++++++++++++++----------
>>  drivers/media/usb/em28xx/em28xx.h        |   8 +-
>>  3 files changed, 116 insertions(+), 56 deletions(-)
>>
>> diff --git a/drivers/media/usb/em28xx/em28xx-camera.c b/drivers/media/usb/em28xx/em28xx-camera.c
>> index 505e050..daebef3 100644
>> --- a/drivers/media/usb/em28xx/em28xx-camera.c
>> +++ b/drivers/media/usb/em28xx/em28xx-camera.c
>> @@ -365,7 +365,7 @@ int em28xx_init_camera(struct em28xx *dev)
>>  		dev->sensor_xtal = 4300000;
>>  		pdata.xtal = dev->sensor_xtal;
>>  		if (NULL ==
>> -		    v4l2_i2c_new_subdev_board(&dev->v4l2_dev, adap,
>> +		    v4l2_i2c_new_subdev_board(&dev->v4l2->v4l2_dev, adap,
>>  					      &mt9v011_info, NULL)) {
>>  			ret = -ENODEV;
>>  			break;
>> @@ -422,7 +422,7 @@ int em28xx_init_camera(struct em28xx *dev)
>>  		dev->sensor_yres = 480;
>>  
>>  		subdev =
>> -		     v4l2_i2c_new_subdev_board(&dev->v4l2_dev, adap,
>> +		     v4l2_i2c_new_subdev_board(&dev->v4l2->v4l2_dev, adap,
>>  					       &ov2640_info, NULL);
>>  		if (NULL == subdev) {
>>  			ret = -ENODEV;
>> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
>> index 45ad471..89947db 100644
>> --- a/drivers/media/usb/em28xx/em28xx-video.c
>> +++ b/drivers/media/usb/em28xx/em28xx-video.c
>> @@ -189,10 +189,11 @@ static int em28xx_vbi_supported(struct em28xx *dev)
>>   */
>>  static void em28xx_wake_i2c(struct em28xx *dev)
>>  {
>> -	v4l2_device_call_all(&dev->v4l2_dev, 0, core,  reset, 0);
>> -	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_routing,
>> +	struct v4l2_device *v4l2_dev = &dev->v4l2->v4l2_dev;
>> +	v4l2_device_call_all(v4l2_dev, 0, core,  reset, 0);
>> +	v4l2_device_call_all(v4l2_dev, 0, video, s_routing,
>>  			INPUT(dev->ctl_input)->vmux, 0, 0);
>> -	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 0);
>> +	v4l2_device_call_all(v4l2_dev, 0, video, s_stream, 0);
>>  }
>>  
>>  static int em28xx_colorlevels_set_default(struct em28xx *dev)
>> @@ -952,7 +953,8 @@ int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
>>  			f.type = V4L2_TUNER_RADIO;
>>  		else
>>  			f.type = V4L2_TUNER_ANALOG_TV;
>> -		v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_frequency, &f);
>> +		v4l2_device_call_all(&dev->v4l2->v4l2_dev,
>> +				     0, tuner, s_frequency, &f);
>>  	}
>>  
>>  	dev->streaming_users++;
>> @@ -1083,6 +1085,7 @@ static int em28xx_vb2_setup(struct em28xx *dev)
>>  
>>  static void video_mux(struct em28xx *dev, int index)
>>  {
>> +	struct v4l2_device *v4l2_dev = &dev->v4l2->v4l2_dev;
>>  	dev->ctl_input = index;
>>  	dev->ctl_ainput = INPUT(index)->amux;
>>  	dev->ctl_aoutput = INPUT(index)->aout;
>> @@ -1090,21 +1093,21 @@ static void video_mux(struct em28xx *dev, int index)
>>  	if (!dev->ctl_aoutput)
>>  		dev->ctl_aoutput = EM28XX_AOUT_MASTER;
>>  
>> -	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_routing,
>> +	v4l2_device_call_all(v4l2_dev, 0, video, s_routing,
>>  			INPUT(index)->vmux, 0, 0);
>>  
>>  	if (dev->board.has_msp34xx) {
>>  		if (dev->i2s_speed) {
>> -			v4l2_device_call_all(&dev->v4l2_dev, 0, audio,
>> +			v4l2_device_call_all(v4l2_dev, 0, audio,
>>  				s_i2s_clock_freq, dev->i2s_speed);
>>  		}
>>  		/* Note: this is msp3400 specific */
>> -		v4l2_device_call_all(&dev->v4l2_dev, 0, audio, s_routing,
>> +		v4l2_device_call_all(v4l2_dev, 0, audio, s_routing,
>>  			 dev->ctl_ainput, MSP_OUTPUT(MSP_SC_IN_DSP_SCART1), 0);
>>  	}
>>  
>>  	if (dev->board.adecoder != EM28XX_NOADECODER) {
>> -		v4l2_device_call_all(&dev->v4l2_dev, 0, audio, s_routing,
>> +		v4l2_device_call_all(v4l2_dev, 0, audio, s_routing,
>>  			dev->ctl_ainput, dev->ctl_aoutput, 0);
>>  	}
>>  
>> @@ -1344,7 +1347,7 @@ static int vidioc_querystd(struct file *file, void *priv, v4l2_std_id *norm)
>>  	struct em28xx_fh   *fh  = priv;
>>  	struct em28xx      *dev = fh->dev;
>>  
>> -	v4l2_device_call_all(&dev->v4l2_dev, 0, video, querystd, norm);
>> +	v4l2_device_call_all(&dev->v4l2->v4l2_dev, 0, video, querystd, norm);
>>  
>>  	return 0;
>>  }
>> @@ -1374,7 +1377,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id norm)
>>  	size_to_scale(dev, dev->width, dev->height, &dev->hscale, &dev->vscale);
>>  
>>  	em28xx_resolution_set(dev);
>> -	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std, dev->norm);
>> +	v4l2_device_call_all(&dev->v4l2->v4l2_dev, 0, core, s_std, dev->norm);
>>  
>>  	return 0;
>>  }
>> @@ -1388,7 +1391,7 @@ static int vidioc_g_parm(struct file *file, void *priv,
>>  
>>  	p->parm.capture.readbuffers = EM28XX_MIN_BUF;
>>  	if (dev->board.is_webcam)
>> -		rc = v4l2_device_call_until_err(&dev->v4l2_dev, 0,
>> +		rc = v4l2_device_call_until_err(&dev->v4l2->v4l2_dev, 0,
>>  						video, g_parm, p);
>>  	else
>>  		v4l2_video_std_frame_period(dev->norm,
>> @@ -1404,7 +1407,8 @@ static int vidioc_s_parm(struct file *file, void *priv,
>>  	struct em28xx      *dev = fh->dev;
>>  
>>  	p->parm.capture.readbuffers = EM28XX_MIN_BUF;
>> -	return v4l2_device_call_until_err(&dev->v4l2_dev, 0, video, s_parm, p);
>> +	return v4l2_device_call_until_err(&dev->v4l2->v4l2_dev,
>> +					  0, video, s_parm, p);
>>  }
>>  
>>  static const char *iname[] = {
>> @@ -1543,7 +1547,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
>>  
>>  	strcpy(t->name, "Tuner");
>>  
>> -	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, g_tuner, t);
>> +	v4l2_device_call_all(&dev->v4l2->v4l2_dev, 0, tuner, g_tuner, t);
>>  	return 0;
>>  }
>>  
>> @@ -1556,7 +1560,7 @@ static int vidioc_s_tuner(struct file *file, void *priv,
>>  	if (0 != t->index)
>>  		return -EINVAL;
>>  
>> -	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_tuner, t);
>> +	v4l2_device_call_all(&dev->v4l2->v4l2_dev, 0, tuner, s_tuner, t);
>>  	return 0;
>>  }
>>  
>> @@ -1576,15 +1580,16 @@ static int vidioc_g_frequency(struct file *file, void *priv,
>>  static int vidioc_s_frequency(struct file *file, void *priv,
>>  				const struct v4l2_frequency *f)
>>  {
>> -	struct v4l2_frequency new_freq = *f;
>> -	struct em28xx_fh      *fh  = priv;
>> -	struct em28xx         *dev = fh->dev;
>> +	struct v4l2_frequency  new_freq = *f;
>> +	struct em28xx_fh          *fh   = priv;
>> +	struct em28xx             *dev  = fh->dev;
>> +	struct em28xx_v4l2        *v4l2 = dev->v4l2;
>>  
>>  	if (0 != f->tuner)
>>  		return -EINVAL;
>>  
>> -	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_frequency, f);
>> -	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, g_frequency, &new_freq);
>> +	v4l2_device_call_all(&v4l2->v4l2_dev, 0, tuner, s_frequency, f);
>> +	v4l2_device_call_all(&v4l2->v4l2_dev, 0, tuner, g_frequency, &new_freq);
>>  	dev->ctl_freq = new_freq.frequency;
>>  
>>  	return 0;
>> @@ -1602,7 +1607,8 @@ static int vidioc_g_chip_info(struct file *file, void *priv,
>>  	if (chip->match.addr == 1)
>>  		strlcpy(chip->name, "ac97", sizeof(chip->name));
>>  	else
>> -		strlcpy(chip->name, dev->v4l2_dev.name, sizeof(chip->name));
>> +		strlcpy(chip->name,
>> +			dev->v4l2->v4l2_dev.name, sizeof(chip->name));
>>  	return 0;
>>  }
>>  
>> @@ -1814,7 +1820,7 @@ static int radio_g_tuner(struct file *file, void *priv,
>>  
>>  	strcpy(t->name, "Radio");
>>  
>> -	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, g_tuner, t);
>> +	v4l2_device_call_all(&dev->v4l2->v4l2_dev, 0, tuner, g_tuner, t);
>>  
>>  	return 0;
>>  }
>> @@ -1827,12 +1833,26 @@ static int radio_s_tuner(struct file *file, void *priv,
>>  	if (0 != t->index)
>>  		return -EINVAL;
>>  
>> -	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_tuner, t);
>> +	v4l2_device_call_all(&dev->v4l2->v4l2_dev, 0, tuner, s_tuner, t);
>>  
>>  	return 0;
>>  }
>>  
>>  /*
>> + * em28xx_free_v4l2() - Free struct em28xx_v4l2
>> + *
>> + * @ref: struct kref for struct em28xx_v4l2
>> + *
>> + * Called when all users of struct em28xx_v4l2 are gone
>> + */
>> +void em28xx_free_v4l2(struct kref *ref)
>> +{
>> +	struct em28xx_v4l2 *v4l2 = container_of(ref, struct em28xx_v4l2, ref);
>> +
>> +	kfree(v4l2);
>> +}
>> +
>> +/*
>>   * em28xx_v4l2_open()
>>   * inits the device and starts isoc transfer
>>   */
>> @@ -1840,6 +1860,7 @@ static int em28xx_v4l2_open(struct file *filp)
>>  {
>>  	struct video_device *vdev = video_devdata(filp);
>>  	struct em28xx *dev = video_drvdata(filp);
>> +	struct em28xx_v4l2 *v4l2 = dev->v4l2;
>>  	enum v4l2_buf_type fh_type = 0;
>>  	struct em28xx_fh *fh;
>>  
>> @@ -1888,10 +1909,11 @@ static int em28xx_v4l2_open(struct file *filp)
>>  
>>  	if (vdev->vfl_type == VFL_TYPE_RADIO) {
>>  		em28xx_videodbg("video_open: setting radio device\n");
>> -		v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_radio);
>> +		v4l2_device_call_all(&v4l2->v4l2_dev, 0, tuner, s_radio);
>>  	}
>>  
>>  	kref_get(&dev->ref);
>> +	kref_get(&v4l2->ref);
> I never like these kref things. Especially for usb devices I strongly recommend
> using the release() callback from v4l2_device instead: this callback will only
> be called once all references to video_device nodes have been closed. In other
> words, only once all filehandles to /dev/videoX (and radio, vbi etc) are closed
> will the release callback be called.
>
> As such it is a perfect place to put the final cleanup, and there is no more need
> to mess around with krefs.

The v4l2 submodule data struct can not be cleared before 1) the
submodule is unloaded/unregistered AND 2) all users of all device nodes
are gone.
Using a kref is much easier (and also safer) than dealing with
non-trivial case checks in em28xx_v4l2_fini() and the v4l2_device
release() callbacks.

What we could do is to call kref_get() only one time at the first open()
of a device node and kref_put() only at the last close().
But it seems that this would just complicate the code without any real
benefit.


>>  	dev->users++;
> The same for these user counters. You can use v4l2_fh_is_singular_file() to check
> if the file open is the first file. However, this function assumes that v4l2_fh_add
> has been called first.
>
> So for this driver it might be easier if we add a v4l2_fh_is_empty() to v4l2-fh.c
> so we can call this before v4l2_fh_add.
>
> For that matter, you can almost certainly remove struct em28xx_fh altogether.
> The type field of that struct can be determined by vdev->vfl_type and 'dev' can be
> obtained via video_get_drvdata().

Yes, fields "dev" and "type" can definitly be removed from struct em28xx_fh.
Then struct v4l2_fh fh is the last member, but I didn't have the time
yet to take a deeper look at it.
At a first glance its usage seems to be incomplete/broken.
There are no v4l2_fh_del() and v4l2_fh_exit() calls and I wonder who
deallocates the structs memory !?

Regards,
Frank

>
> Regards,
>
> 	Hans
>
>>  
>>  	mutex_unlock(&dev->lock);

