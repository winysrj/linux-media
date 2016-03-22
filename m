Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:56025 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173AbcCVTok (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2016 15:44:40 -0400
Subject: Re: [PATCH] [media] au0828: Fix dev_state handling
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <38900ee74344a75967907fe99b201f517535d557.1458652539.git.mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?Q?Rafael_Louren=c3=a7o_de_Lima_Chehab?=
	<chehabrafael@gmail.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Geunyoung Kim <nenggun.kim@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Junghak Sung <jh1009.sung@samsung.com>,
	Inki Dae <inki.dae@samsung.com>, stable@vger.kernel.org,
	Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <56F1A0A5.7070403@osg.samsung.com>
Date: Tue, 22 Mar 2016 13:44:37 -0600
MIME-Version: 1.0
In-Reply-To: <38900ee74344a75967907fe99b201f517535d557.1458652539.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/22/2016 07:16 AM, Mauro Carvalho Chehab wrote:
> The au0828 dev_state is actually a bit mask. It should not be
> checking with "==" but, instead, with a logic and. There are some
> places where it was doing it wrong.
> 
> Fix that by replacing the dev_state set/clear/test with the
> bitops.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---
> Shuah,
> 
> Please test.

Looks good. Tested running bind/unbind au0828 loop for 1000 times.
Didn't see any problems and the v4l2_querycap() problem has been
fixed with this patch.

After the above test, ran bind/unbind snd_usb_audio 1000 times.
Didn't see any problems. Generated media graph and the graph
looks good.

Reviewed-by: Shuah Khan <shuahkh@osg.samsung.com>
Tested-by: Shuah Khan <shuahkh@osg.samsung.com>

thanks,
-- Shuah
> 
> I'm testing it here too.
> 
>  drivers/media/usb/au0828/au0828-core.c  |  2 +-
>  drivers/media/usb/au0828/au0828-input.c |  4 +--
>  drivers/media/usb/au0828/au0828-video.c | 63 ++++++++++++++++-----------------
>  drivers/media/usb/au0828/au0828.h       |  9 ++---
>  4 files changed, 39 insertions(+), 39 deletions(-)
> 
> diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
> index 060904ed8f20..85c13ca5178f 100644
> --- a/drivers/media/usb/au0828/au0828-core.c
> +++ b/drivers/media/usb/au0828/au0828-core.c
> @@ -184,7 +184,7 @@ static void au0828_usb_disconnect(struct usb_interface *interface)
>  	   Set the status so poll routines can check and avoid
>  	   access after disconnect.
>  	*/
> -	dev->dev_state = DEV_DISCONNECTED;
> +	set_bit(DEV_DISCONNECTED, &dev->dev_state);
>  
>  	au0828_rc_unregister(dev);
>  	/* Digital TV */
> diff --git a/drivers/media/usb/au0828/au0828-input.c b/drivers/media/usb/au0828/au0828-input.c
> index b0f067971979..3d6687f0407d 100644
> --- a/drivers/media/usb/au0828/au0828-input.c
> +++ b/drivers/media/usb/au0828/au0828-input.c
> @@ -130,7 +130,7 @@ static int au0828_get_key_au8522(struct au0828_rc *ir)
>  	bool first = true;
>  
>  	/* do nothing if device is disconnected */
> -	if (ir->dev->dev_state == DEV_DISCONNECTED)
> +	if (test_bit(DEV_DISCONNECTED, &ir->dev->dev_state))
>  		return 0;
>  
>  	/* Check IR int */
> @@ -260,7 +260,7 @@ static void au0828_rc_stop(struct rc_dev *rc)
>  	cancel_delayed_work_sync(&ir->work);
>  
>  	/* do nothing if device is disconnected */
> -	if (ir->dev->dev_state != DEV_DISCONNECTED) {
> +	if (!test_bit(DEV_DISCONNECTED, &ir->dev->dev_state)) {
>  		/* Disable IR */
>  		au8522_rc_clear(ir, 0xe0, 1 << 4);
>  	}
> diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
> index 88dcc6e0e178..32d7db96479c 100644
> --- a/drivers/media/usb/au0828/au0828-video.c
> +++ b/drivers/media/usb/au0828/au0828-video.c
> @@ -106,14 +106,13 @@ static inline void print_err_status(struct au0828_dev *dev,
>  
>  static int check_dev(struct au0828_dev *dev)
>  {
> -	if (dev->dev_state & DEV_DISCONNECTED) {
> +	if (test_bit(DEV_DISCONNECTED, &dev->dev_state)) {
>  		pr_info("v4l2 ioctl: device not present\n");
>  		return -ENODEV;
>  	}
>  
> -	if (dev->dev_state & DEV_MISCONFIGURED) {
> -		pr_info("v4l2 ioctl: device is misconfigured; "
> -		       "close and open it again\n");
> +	if (test_bit(DEV_MISCONFIGURED, &dev->dev_state)) {
> +		pr_info("v4l2 ioctl: device is misconfigured; close and open it again\n");
>  		return -EIO;
>  	}
>  	return 0;
> @@ -521,8 +520,8 @@ static inline int au0828_isoc_copy(struct au0828_dev *dev, struct urb *urb)
>  	if (!dev)
>  		return 0;
>  
> -	if ((dev->dev_state & DEV_DISCONNECTED) ||
> -	    (dev->dev_state & DEV_MISCONFIGURED))
> +	if (test_bit(DEV_DISCONNECTED, &dev->dev_state) ||
> +	    test_bit(DEV_MISCONFIGURED, &dev->dev_state))
>  		return 0;
>  
>  	if (urb->status < 0) {
> @@ -824,10 +823,10 @@ static int au0828_stream_interrupt(struct au0828_dev *dev)
>  	int ret = 0;
>  
>  	dev->stream_state = STREAM_INTERRUPT;
> -	if (dev->dev_state == DEV_DISCONNECTED)
> +	if (test_bit(DEV_DISCONNECTED, &dev->dev_state))
>  		return -ENODEV;
>  	else if (ret) {
> -		dev->dev_state = DEV_MISCONFIGURED;
> +		set_bit(DEV_MISCONFIGURED, &dev->dev_state);
>  		dprintk(1, "%s device is misconfigured!\n", __func__);
>  		return ret;
>  	}
> @@ -1026,7 +1025,7 @@ static int au0828_v4l2_open(struct file *filp)
>  	int ret;
>  
>  	dprintk(1,
> -		"%s called std_set %d dev_state %d stream users %d users %d\n",
> +		"%s called std_set %d dev_state %ld stream users %d users %d\n",
>  		__func__, dev->std_set_in_tuner_core, dev->dev_state,
>  		dev->streaming_users, dev->users);
>  
> @@ -1045,7 +1044,7 @@ static int au0828_v4l2_open(struct file *filp)
>  		au0828_analog_stream_enable(dev);
>  		au0828_analog_stream_reset(dev);
>  		dev->stream_state = STREAM_OFF;
> -		dev->dev_state |= DEV_INITIALIZED;
> +		set_bit(DEV_INITIALIZED, &dev->dev_state);
>  	}
>  	dev->users++;
>  	mutex_unlock(&dev->lock);
> @@ -1059,7 +1058,7 @@ static int au0828_v4l2_close(struct file *filp)
>  	struct video_device *vdev = video_devdata(filp);
>  
>  	dprintk(1,
> -		"%s called std_set %d dev_state %d stream users %d users %d\n",
> +		"%s called std_set %d dev_state %ld stream users %d users %d\n",
>  		__func__, dev->std_set_in_tuner_core, dev->dev_state,
>  		dev->streaming_users, dev->users);
>  
> @@ -1075,7 +1074,7 @@ static int au0828_v4l2_close(struct file *filp)
>  		del_timer_sync(&dev->vbi_timeout);
>  	}
>  
> -	if (dev->dev_state & DEV_DISCONNECTED)
> +	if (test_bit(DEV_DISCONNECTED, &dev->dev_state))
>  		goto end;
>  
>  	if (dev->users == 1) {
> @@ -1135,7 +1134,7 @@ static void au0828_init_tuner(struct au0828_dev *dev)
>  		.type = V4L2_TUNER_ANALOG_TV,
>  	};
>  
> -	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
> +	dprintk(1, "%s called std_set %d dev_state %ld\n", __func__,
>  		dev->std_set_in_tuner_core, dev->dev_state);
>  
>  	if (dev->std_set_in_tuner_core)
> @@ -1207,7 +1206,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
>  	struct video_device *vdev = video_devdata(file);
>  	struct au0828_dev *dev = video_drvdata(file);
>  
> -	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
> +	dprintk(1, "%s called std_set %d dev_state %ld\n", __func__,
>  		dev->std_set_in_tuner_core, dev->dev_state);
>  
>  	strlcpy(cap->driver, "au0828", sizeof(cap->driver));
> @@ -1250,7 +1249,7 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
>  {
>  	struct au0828_dev *dev = video_drvdata(file);
>  
> -	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
> +	dprintk(1, "%s called std_set %d dev_state %ld\n", __func__,
>  		dev->std_set_in_tuner_core, dev->dev_state);
>  
>  	f->fmt.pix.width = dev->width;
> @@ -1269,7 +1268,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
>  {
>  	struct au0828_dev *dev = video_drvdata(file);
>  
> -	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
> +	dprintk(1, "%s called std_set %d dev_state %ld\n", __func__,
>  		dev->std_set_in_tuner_core, dev->dev_state);
>  
>  	return au0828_set_format(dev, VIDIOC_TRY_FMT, f);
> @@ -1281,7 +1280,7 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
>  	struct au0828_dev *dev = video_drvdata(file);
>  	int rc;
>  
> -	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
> +	dprintk(1, "%s called std_set %d dev_state %ld\n", __func__,
>  		dev->std_set_in_tuner_core, dev->dev_state);
>  
>  	rc = check_dev(dev);
> @@ -1303,7 +1302,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id norm)
>  {
>  	struct au0828_dev *dev = video_drvdata(file);
>  
> -	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
> +	dprintk(1, "%s called std_set %d dev_state %ld\n", __func__,
>  		dev->std_set_in_tuner_core, dev->dev_state);
>  
>  	if (norm == dev->std)
> @@ -1335,7 +1334,7 @@ static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *norm)
>  {
>  	struct au0828_dev *dev = video_drvdata(file);
>  
> -	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
> +	dprintk(1, "%s called std_set %d dev_state %ld\n", __func__,
>  		dev->std_set_in_tuner_core, dev->dev_state);
>  
>  	*norm = dev->std;
> @@ -1357,7 +1356,7 @@ static int vidioc_enum_input(struct file *file, void *priv,
>  		[AU0828_VMUX_DVB] = "DVB",
>  	};
>  
> -	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
> +	dprintk(1, "%s called std_set %d dev_state %ld\n", __func__,
>  		dev->std_set_in_tuner_core, dev->dev_state);
>  
>  	tmp = input->index;
> @@ -1387,7 +1386,7 @@ static int vidioc_g_input(struct file *file, void *priv, unsigned int *i)
>  {
>  	struct au0828_dev *dev = video_drvdata(file);
>  
> -	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
> +	dprintk(1, "%s called std_set %d dev_state %ld\n", __func__,
>  		dev->std_set_in_tuner_core, dev->dev_state);
>  
>  	*i = dev->ctrl_input;
> @@ -1398,7 +1397,7 @@ static void au0828_s_input(struct au0828_dev *dev, int index)
>  {
>  	int i;
>  
> -	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
> +	dprintk(1, "%s called std_set %d dev_state %ld\n", __func__,
>  		dev->std_set_in_tuner_core, dev->dev_state);
>  
>  	switch (AUVI_INPUT(index).type) {
> @@ -1496,7 +1495,7 @@ static int vidioc_g_audio(struct file *file, void *priv, struct v4l2_audio *a)
>  {
>  	struct au0828_dev *dev = video_drvdata(file);
>  
> -	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
> +	dprintk(1, "%s called std_set %d dev_state %ld\n", __func__,
>  		dev->std_set_in_tuner_core, dev->dev_state);
>  
>  	a->index = dev->ctrl_ainput;
> @@ -1516,7 +1515,7 @@ static int vidioc_s_audio(struct file *file, void *priv, const struct v4l2_audio
>  	if (a->index != dev->ctrl_ainput)
>  		return -EINVAL;
>  
> -	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
> +	dprintk(1, "%s called std_set %d dev_state %ld\n", __func__,
>  		dev->std_set_in_tuner_core, dev->dev_state);
>  	return 0;
>  }
> @@ -1534,7 +1533,7 @@ static int vidioc_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
>  	if (ret)
>  		return ret;
>  
> -	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
> +	dprintk(1, "%s called std_set %d dev_state %ld\n", __func__,
>  		dev->std_set_in_tuner_core, dev->dev_state);
>  
>  	strcpy(t->name, "Auvitek tuner");
> @@ -1554,7 +1553,7 @@ static int vidioc_s_tuner(struct file *file, void *priv,
>  	if (t->index != 0)
>  		return -EINVAL;
>  
> -	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
> +	dprintk(1, "%s called std_set %d dev_state %ld\n", __func__,
>  		dev->std_set_in_tuner_core, dev->dev_state);
>  
>  	au0828_init_tuner(dev);
> @@ -1576,7 +1575,7 @@ static int vidioc_g_frequency(struct file *file, void *priv,
>  
>  	if (freq->tuner != 0)
>  		return -EINVAL;
> -	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
> +	dprintk(1, "%s called std_set %d dev_state %ld\n", __func__,
>  		dev->std_set_in_tuner_core, dev->dev_state);
>  	freq->frequency = dev->ctrl_freq;
>  	return 0;
> @@ -1591,7 +1590,7 @@ static int vidioc_s_frequency(struct file *file, void *priv,
>  	if (freq->tuner != 0)
>  		return -EINVAL;
>  
> -	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
> +	dprintk(1, "%s called std_set %d dev_state %ld\n", __func__,
>  		dev->std_set_in_tuner_core, dev->dev_state);
>  
>  	au0828_init_tuner(dev);
> @@ -1617,7 +1616,7 @@ static int vidioc_g_fmt_vbi_cap(struct file *file, void *priv,
>  {
>  	struct au0828_dev *dev = video_drvdata(file);
>  
> -	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
> +	dprintk(1, "%s called std_set %d dev_state %ld\n", __func__,
>  		dev->std_set_in_tuner_core, dev->dev_state);
>  
>  	format->fmt.vbi.samples_per_line = dev->vbi_width;
> @@ -1643,7 +1642,7 @@ static int vidioc_cropcap(struct file *file, void *priv,
>  	if (cc->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>  		return -EINVAL;
>  
> -	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
> +	dprintk(1, "%s called std_set %d dev_state %ld\n", __func__,
>  		dev->std_set_in_tuner_core, dev->dev_state);
>  
>  	cc->bounds.left = 0;
> @@ -1665,7 +1664,7 @@ static int vidioc_g_register(struct file *file, void *priv,
>  {
>  	struct au0828_dev *dev = video_drvdata(file);
>  
> -	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
> +	dprintk(1, "%s called std_set %d dev_state %ld\n", __func__,
>  		dev->std_set_in_tuner_core, dev->dev_state);
>  
>  	reg->val = au0828_read(dev, reg->reg);
> @@ -1678,7 +1677,7 @@ static int vidioc_s_register(struct file *file, void *priv,
>  {
>  	struct au0828_dev *dev = video_drvdata(file);
>  
> -	dprintk(1, "%s called std_set %d dev_state %d\n", __func__,
> +	dprintk(1, "%s called std_set %d dev_state %ld\n", __func__,
>  		dev->std_set_in_tuner_core, dev->dev_state);
>  
>  	return au0828_writereg(dev, reg->reg, reg->val);
> diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
> index ff7f8510fb77..87f32846f1c0 100644
> --- a/drivers/media/usb/au0828/au0828.h
> +++ b/drivers/media/usb/au0828/au0828.h
> @@ -21,6 +21,7 @@
>  
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>  
> +#include <linux/bitops.h>
>  #include <linux/usb.h>
>  #include <linux/i2c.h>
>  #include <linux/i2c-algo-bit.h>
> @@ -121,9 +122,9 @@ enum au0828_stream_state {
>  
>  /* device state */
>  enum au0828_dev_state {
> -	DEV_INITIALIZED = 0x01,
> -	DEV_DISCONNECTED = 0x02,
> -	DEV_MISCONFIGURED = 0x04
> +	DEV_INITIALIZED = 0,
> +	DEV_DISCONNECTED = 1,
> +	DEV_MISCONFIGURED = 2
>  };
>  
>  struct au0828_dev;
> @@ -247,7 +248,7 @@ struct au0828_dev {
>  	int input_type;
>  	int std_set_in_tuner_core;
>  	unsigned int ctrl_input;
> -	enum au0828_dev_state dev_state;
> +	long unsigned int dev_state; /* defined at enum au0828_dev_state */;
>  	enum au0828_stream_state stream_state;
>  	wait_queue_head_t open;
>  
> 


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
