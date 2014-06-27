Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4250 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbaF0NxP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jun 2014 09:53:15 -0400
Message-ID: <53AD772E.20104@xs4all.nl>
Date: Fri, 27 Jun 2014 15:52:46 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Shuah Khan <shuah.kh@samsung.com>, gregkh@linuxfoundation.org,
	m.chehab@samsung.com, olebowle@gmx.com, ttmesterr@gmail.com,
	dheitmueller@kernellabs.com, cb.xiong@samsung.com,
	yongjun_wei@trendmicro.com.cn, hans.verkuil@cisco.com,
	prabhakar.csengg@gmail.com, laurent.pinchart@ideasonboard.com,
	sakari.ailus@linux.intel.com, crope@iki.fi,
	wade_farnsworth@mentor.com, ricardo.ribalda@gmail.com
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 4/4] media: au0828 changes to use token devres for tuner
 access
References: <cover.1403652043.git.shuah.kh@samsung.com> <191ed75e7a6aafd9e2f85c642b08a963a9d1be1f.1403652043.git.shuah.kh@samsung.com>
In-Reply-To: <191ed75e7a6aafd9e2f85c642b08a963a9d1be1f.1403652043.git.shuah.kh@samsung.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah,

On 06/25/2014 01:57 AM, Shuah Khan wrote:
> au0828 is changed to use token devres as a large locking
> for exclusive access to tuner function. A new tuner_tkn
> field is added to struct au0828_dev. Tuner token is created
> from au0828 probe() and destroyed from disconnect().
>
> Two new routines au0828_create_token_resources() and
> au0828_destroy_token_resources() create and destroy the
> tuner token.
>
> au0828-dvb exports the tuner token to dvb-frontend when
> it registers the digital frontend using the tuner_tkn
> field in struct dvb_frontend.
>
> au0828-video exports the tuner token to v4l2-core when
> it registers the analog function using tuner_tkn field
> in struct video_device.
>
> Before this change:
>
> - digital tv app disrupts an active analog app when it
>    tries to use the tuner
>    e.g:  tvtime analog video stream stops when kaffeine starts
> - analog tv app disrupts another analog app when it tries to
>    use the tuner
>    e.g: tvtime audio glitches when xawtv starts and vice versa.
> - analog tv app disrupts an active digital app when it tries
>    to use the tuner
>    e.g: kaffeine digital stream stops when tvtime starts
> - digital tv app disrupts another digital tv app when it tries
>    to use the tuner
>    e.g: kaffeine digital stream stops when vlc starts and vice
>    versa
>
> After this change:
> - digital tv app detects tuner is busy without disrupting
>    the active app.
> - analog tv app detects tuner is busy without disrupting
>    the active analog app.
> - analog tv app detects tuner is busy without disrupting
>    the active digital app.
> - digital tv app detects tuner is busy without disrupting
>    the active digital app.
>
> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> ---
>   drivers/media/usb/au0828/au0828-core.c  |   42 +++++++++++++++++++++++++++++++
>   drivers/media/usb/au0828/au0828-dvb.c   |    1 +
>   drivers/media/usb/au0828/au0828-video.c |    4 +++
>   drivers/media/usb/au0828/au0828.h       |    4 +++
>   4 files changed, 51 insertions(+)
>
> diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
> index ab45a6f..df04a99 100644
> --- a/drivers/media/usb/au0828/au0828-core.c
> +++ b/drivers/media/usb/au0828/au0828-core.c
> @@ -125,6 +125,37 @@ static int recv_control_msg(struct au0828_dev *dev, u16 request, u32 value,
>   	return status;
>   }
>
> +/* interfaces to create and destroy token resources */
> +static int au0828_create_token_resources(struct au0828_dev *dev)
> +{
> +	int rc = 0, len;
> +	char buf[64];
> +
> +	/* create token devres for tuner */
> +	len = snprintf(buf, sizeof(buf),
> +		"tuner:%s-%s-%d",
> +		dev_name(&dev->usbdev->dev),
> +		dev->usbdev->bus->bus_name,
> +		dev->board.tuner_addr);
> +
> +	dev->tuner_tkn = devm_kzalloc(&dev->usbdev->dev, len + 1, GFP_KERNEL);
> +	if (!dev->tuner_tkn)
> +		return -ENOMEM;
> +
> +	strcpy(dev->tuner_tkn, buf);
> +	rc = devm_token_create(&dev->usbdev->dev, dev->tuner_tkn);
> +	if (rc)
> +		return rc;
> +
> +	pr_info("au0828_create_token_resources(): Tuner token created\n");
> +	return rc;
> +}
> +
> +static void au0828_destroy_token_resources(struct au0828_dev *dev)
> +{
> +	devm_token_destroy(&dev->usbdev->dev, dev->tuner_tkn);

I don't quite understand this. Isn't this a managed resource that will
be released automatically? So why release it explicitly?

> +}
> +
>   static void au0828_usb_release(struct au0828_dev *dev)
>   {
>   	/* I2C */
> @@ -154,6 +185,8 @@ static void au0828_usb_disconnect(struct usb_interface *interface)
>   	/* Digital TV */
>   	au0828_dvb_unregister(dev);
>
> +	au0828_destroy_token_resources(dev);
> +
>   	usb_set_intfdata(interface, NULL);
>   	mutex_lock(&dev->mutex);
>   	dev->usbdev = NULL;
> @@ -213,6 +246,13 @@ static int au0828_usb_probe(struct usb_interface *interface,
>   	dev->usbdev = usbdev;
>   	dev->boardnr = id->driver_info;
>
> +	/* create token resources */
> +	if (au0828_create_token_resources(dev)) {
> +		mutex_unlock(&dev->lock);
> +		kfree(dev);
> +		return -ENOMEM;
> +	}
> +
>   #ifdef CONFIG_VIDEO_AU0828_V4L2
>   	dev->v4l2_dev.release = au0828_usb_v4l2_release;
>
> @@ -221,6 +261,7 @@ static int au0828_usb_probe(struct usb_interface *interface,
>   	if (retval) {
>   		pr_err("%s() v4l2_device_register failed\n",
>   		       __func__);
> +		au0828_destroy_token_resources(dev);
>   		mutex_unlock(&dev->lock);
>   		kfree(dev);
>   		return retval;
> @@ -230,6 +271,7 @@ static int au0828_usb_probe(struct usb_interface *interface,
>   	if (retval) {
>   		pr_err("%s() v4l2_ctrl_handler_init failed\n",
>   		       __func__);
> +		au0828_destroy_token_resources(dev);
>   		mutex_unlock(&dev->lock);
>   		kfree(dev);
>   		return retval;
> diff --git a/drivers/media/usb/au0828/au0828-dvb.c b/drivers/media/usb/au0828/au0828-dvb.c
> index d8b5d94..1195d29 100755
> --- a/drivers/media/usb/au0828/au0828-dvb.c
> +++ b/drivers/media/usb/au0828/au0828-dvb.c
> @@ -412,6 +412,7 @@ static int dvb_register(struct au0828_dev *dev)
>   		goto fail_adapter;
>   	}
>   	dvb->adapter.priv = dev;
> +	dvb->frontend->tuner_tkn = dev->tuner_tkn;
>
>   	/* register frontend */
>   	result = dvb_register_frontend(&dvb->adapter, dvb->frontend);
> diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
> index 385894a..0b50bda 100644
> --- a/drivers/media/usb/au0828/au0828-video.c
> +++ b/drivers/media/usb/au0828/au0828-video.c
> @@ -2018,6 +2018,9 @@ int au0828_analog_register(struct au0828_dev *dev,
>   	dev->vdev->lock = &dev->lock;
>   	set_bit(V4L2_FL_USE_FH_PRIO, &dev->vdev->flags);
>   	strcpy(dev->vdev->name, "au0828a video");
> +	/* is there another way v4l2 core can get struct device ?? */
> +	dev->vdev->dev_parent = &dev->usbdev->dev;
> +	dev->vdev->tuner_tkn = dev->tuner_tkn;
>
>   	/* Setup the VBI device */
>   	*dev->vbi_dev = au0828_video_template;
> @@ -2025,6 +2028,7 @@ int au0828_analog_register(struct au0828_dev *dev,
>   	dev->vbi_dev->lock = &dev->lock;
>   	set_bit(V4L2_FL_USE_FH_PRIO, &dev->vbi_dev->flags);
>   	strcpy(dev->vbi_dev->name, "au0828a vbi");
> +	dev->vbi_dev->tuner_tkn = dev->tuner_tkn;
>
>   	/* Register the v4l2 device */
>   	video_set_drvdata(dev->vdev, dev);
> diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
> index 7112b9d..11bc933 100644
> --- a/drivers/media/usb/au0828/au0828.h
> +++ b/drivers/media/usb/au0828/au0828.h
> @@ -23,6 +23,7 @@
>   #include <linux/i2c.h>
>   #include <linux/i2c-algo-bit.h>
>   #include <media/tveeprom.h>
> +#include <linux/token_devres.h>
>
>   /* Analog */
>   #include <linux/videodev2.h>
> @@ -198,6 +199,9 @@ struct au0828_dev {
>   	struct au0828_board	board;
>   	u8			ctrlmsg[64];
>
> +	/* token resources */
> +	char *tuner_tkn; /* tuner token id */
> +
>   	/* I2C */
>   	struct i2c_adapter		i2c_adap;
>   	struct i2c_algorithm		i2c_algo;
>

DVB and V4L are in the same driver, so it is easy to share the same token, but how
should this work if snd-usb-audio needs this to coordinate with the media driver?

A more fundamental problem is that you take a mutex and just return and only unlock
it much, much later. I'm not sure what lockdep will make of that... However, why
would you do it like that? What you really need is struct kref (or something like
it) to keep track of the number of references to the token, and the token has to
have some sort of a mode as well. I.e., you can only switch mode if the refcount
is 0. This would allow multiple opens of video/vbi/radio nodes as long as that
will not change the tuner mode.

Not all that different really from this attempt of mine that I never finished:

http://git.linuxtv.org/cgit.cgi/hverkuil/media_tree.git/log/?h=tuner

Regards,

	Hans
