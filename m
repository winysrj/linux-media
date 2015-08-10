Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:37920 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750826AbbHJJei (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2015 05:34:38 -0400
Message-ID: <55C87013.1020907@xs4all.nl>
Date: Mon, 10 Aug 2015 11:34:11 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCHv3 10/13] hackrf: add support for transmitter
References: <1438308650-2702-1-git-send-email-crope@iki.fi> <1438308650-2702-11-git-send-email-crope@iki.fi>
In-Reply-To: <1438308650-2702-11-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some comments below:

On 07/31/2015 04:10 AM, Antti Palosaari wrote:
> HackRF SDR device has both receiver and transmitter. There is limitation
> that receiver and transmitter cannot be used at the same time
> (half-duplex operation). That patch implements transmitter support to
> existing receiver only driver.
> 
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/usb/hackrf/hackrf.c | 894 ++++++++++++++++++++++++++------------
>  1 file changed, 627 insertions(+), 267 deletions(-)
> 
> diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
> index 5bd291b..f4b5606 100644
> --- a/drivers/media/usb/hackrf/hackrf.c
> +++ b/drivers/media/usb/hackrf/hackrf.c

<snip>

> @@ -748,15 +925,11 @@ static int hackrf_s_fmt_sdr_cap(struct file *file, void *priv,
>  		struct v4l2_format *f)
>  {
>  	struct hackrf_dev *dev = video_drvdata(file);
> -	struct vb2_queue *q = &dev->vb_queue;
>  	int i;
>  
>  	dev_dbg(dev->dev, "pixelformat fourcc %4.4s\n",
>  			(char *)&f->fmt.sdr.pixelformat);
>  
> -	if (vb2_is_busy(q))
> -		return -EBUSY;
> -

Why is this removed?

>  	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
>  	for (i = 0; i < NUM_FORMATS; i++) {
>  		if (f->fmt.sdr.pixelformat == formats[i].pixelformat) {
> @@ -856,17 +1029,64 @@ static int hackrf_g_tuner(struct file *file, void *priv, struct v4l2_tuner *v)
>  
>  	if (v->index == 0) {
>  		strlcpy(v->name, "HackRF ADC", sizeof(v->name));
> -		v->type = V4L2_TUNER_ADC;
> +		v->type = V4L2_TUNER_SDR;
>  		v->capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS;
> -		v->rangelow  = bands_adc[0].rangelow;
> -		v->rangehigh = bands_adc[0].rangehigh;
> +		v->rangelow  = bands_adc_dac[0].rangelow;
> +		v->rangehigh = bands_adc_dac[0].rangehigh;
>  		ret = 0;
>  	} else if (v->index == 1) {
> -		strlcpy(v->name, "HackRF RF", sizeof(v->name));
> +		strlcpy(v->name, "HackRF RF RX", sizeof(v->name));

This seems unnecessary. You're calling g_tuner, so it is obvious that it is RX.
I'd keep the name as "HackRF RF".

>  		v->type = V4L2_TUNER_RF;
>  		v->capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS;
> -		v->rangelow  = bands_rf[0].rangelow;
> -		v->rangehigh = bands_rf[0].rangehigh;
> +		v->rangelow  = bands_rx_tx[0].rangelow;
> +		v->rangehigh = bands_rx_tx[0].rangehigh;
> +		ret = 0;
> +	} else {
> +		ret = -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +
> +static int hackrf_s_modulator(struct file *file, void *fh,
> +		       const struct v4l2_modulator *a)
> +{
> +	struct hackrf_dev *dev = video_drvdata(file);
> +	int ret;
> +
> +	dev_dbg(dev->dev, "index=%d\n", a->index);
> +
> +	if (a->index == 0)
> +		ret = 0;
> +	else if (a->index == 1)
> +		ret = 0;
> +	else
> +		ret = -EINVAL;
> +
> +	return ret;

I'd just write:

	return a->index > 1 ? -EINVAL : 0;

More to the point, why implement this at all? At the moment s_modulator is meaningless
since there is nothing to set.

> +}
> +
> +static int hackrf_g_modulator(struct file *file, void *fh,
> +			      struct v4l2_modulator *a)
> +{
> +	struct hackrf_dev *dev = video_drvdata(file);
> +	int ret;
> +
> +	dev_dbg(dev->dev, "index=%d\n", a->index);
> +
> +	if (a->index == 0) {
> +		strlcpy(a->name, "HackRF DAC", sizeof(a->name));
> +		a->type = V4L2_TUNER_SDR;
> +		a->capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS;
> +		a->rangelow  = bands_adc_dac[0].rangelow;
> +		a->rangehigh = bands_adc_dac[0].rangehigh;
> +		ret = 0;
> +	} else if (a->index == 1) {
> +		strlcpy(a->name, "HackRF RF TX", sizeof(a->name));

Same as with g_tuner: I'd drop the "TX" part in the name.

> +		a->type = V4L2_TUNER_RF;
> +		a->capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS;
> +		a->rangelow  = bands_rx_tx[0].rangelow;
> +		a->rangehigh = bands_rx_tx[0].rangehigh;
>  		ret = 0;
>  	} else {
>  		ret = -EINVAL;

<snip>

> @@ -969,6 +1213,11 @@ static const struct v4l2_ioctl_ops hackrf_ioctl_ops = {
>  	.vidioc_enum_fmt_sdr_cap  = hackrf_enum_fmt_sdr_cap,
>  	.vidioc_try_fmt_sdr_cap   = hackrf_try_fmt_sdr_cap,
>  
> +	.vidioc_s_fmt_sdr_out     = hackrf_s_fmt_sdr_cap,
> +	.vidioc_g_fmt_sdr_out     = hackrf_g_fmt_sdr_cap,
> +	.vidioc_enum_fmt_sdr_out  = hackrf_enum_fmt_sdr_cap,
> +	.vidioc_try_fmt_sdr_out   = hackrf_try_fmt_sdr_cap,
> +

Since hackrf_*_fmt_sdr_cap is used for both capture and output I suggest that
those functions are renamed to hackrf_*_fmt_sdr(), dropping the "_cap" part.

>  	.vidioc_reqbufs           = vb2_ioctl_reqbufs,
>  	.vidioc_create_bufs       = vb2_ioctl_create_bufs,
>  	.vidioc_prepare_buf       = vb2_ioctl_prepare_buf,
> @@ -982,6 +1231,9 @@ static const struct v4l2_ioctl_ops hackrf_ioctl_ops = {
>  	.vidioc_s_tuner           = hackrf_s_tuner,
>  	.vidioc_g_tuner           = hackrf_g_tuner,
>  
> +	.vidioc_s_modulator       = hackrf_s_modulator,
> +	.vidioc_g_modulator       = hackrf_g_modulator,
> +
>  	.vidioc_s_frequency       = hackrf_s_frequency,
>  	.vidioc_g_frequency       = hackrf_g_frequency,
>  	.vidioc_enum_freq_bands   = hackrf_enum_freq_bands,
> @@ -996,6 +1248,7 @@ static const struct v4l2_file_operations hackrf_fops = {
>  	.open                     = v4l2_fh_open,
>  	.release                  = vb2_fop_release,
>  	.read                     = vb2_fop_read,
> +	.write                    = vb2_fop_write,
>  	.poll                     = vb2_fop_poll,
>  	.mmap                     = vb2_fop_mmap,
>  	.unlocked_ioctl           = video_ioctl2,

<snip>

> @@ -1089,85 +1393,141 @@ static int hackrf_probe(struct usb_interface *intf,
>  				buf, BUF_SIZE);
>  	if (ret) {
>  		dev_err(dev->dev, "Could not detect board\n");
> -		goto err_free_mem;
> +		goto err_kfree;
>  	}
>  
>  	buf[BUF_SIZE - 1] = '\0';
> -
>  	dev_info(dev->dev, "Board ID: %02x\n", u8tmp);
>  	dev_info(dev->dev, "Firmware version: %s\n", buf);
>  
> -	/* Init videobuf2 queue structure */
> -	dev->vb_queue.type = V4L2_BUF_TYPE_SDR_CAPTURE;
> -	dev->vb_queue.io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
> -	dev->vb_queue.drv_priv = dev;
> -	dev->vb_queue.buf_struct_size = sizeof(struct hackrf_frame_buf);
> -	dev->vb_queue.ops = &hackrf_vb2_ops;
> -	dev->vb_queue.mem_ops = &vb2_vmalloc_memops;
> -	dev->vb_queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> -	ret = vb2_queue_init(&dev->vb_queue);
> +	/* Init vb2 queue structure for receiver */
> +	dev->rx_vb2_queue.type = V4L2_BUF_TYPE_SDR_CAPTURE;
> +	dev->rx_vb2_queue.io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;

I suggest that you add VB2_DMABUF here and for tx_vb2_queue.io_modes.

I see no reason to leave that out.

Also add .vidioc_expbuf = vb2_ioctl_expbuf to the ioctl ops.

> +	dev->rx_vb2_queue.ops = &hackrf_vb2_ops;
> +	dev->rx_vb2_queue.mem_ops = &vb2_vmalloc_memops;
> +	dev->rx_vb2_queue.drv_priv = dev;
> +	dev->rx_vb2_queue.buf_struct_size = sizeof(struct hackrf_buffer);
> +	dev->rx_vb2_queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	ret = vb2_queue_init(&dev->rx_vb2_queue);
> +	if (ret) {
> +		dev_err(dev->dev, "Could not initialize rx vb2 queue\n");
> +		goto err_kfree;
> +	}
> +
> +	/* Init vb2 queue structure for transmitter */
> +	dev->tx_vb2_queue.type = V4L2_BUF_TYPE_SDR_OUTPUT;
> +	dev->tx_vb2_queue.io_modes = VB2_MMAP | VB2_USERPTR | VB2_WRITE;
> +	dev->tx_vb2_queue.ops = &hackrf_vb2_ops;
> +	dev->tx_vb2_queue.mem_ops = &vb2_vmalloc_memops;
> +	dev->tx_vb2_queue.drv_priv = dev;
> +	dev->tx_vb2_queue.buf_struct_size = sizeof(struct hackrf_buffer);
> +	dev->tx_vb2_queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	ret = vb2_queue_init(&dev->tx_vb2_queue);
>  	if (ret) {
> -		dev_err(dev->dev, "Could not initialize vb2 queue\n");
> -		goto err_free_mem;
> +		dev_err(dev->dev, "Could not initialize tx vb2 queue\n");
> +		goto err_kfree;
>  	}
>  
> -	/* Init video_device structure */
> -	dev->vdev = hackrf_template;
> -	dev->vdev.queue = &dev->vb_queue;
> -	dev->vdev.queue->lock = &dev->vb_queue_lock;
> -	video_set_drvdata(&dev->vdev, dev);
> +	/* Register controls for receiver */
> +	v4l2_ctrl_handler_init(&dev->rx_ctrl_handler, 5);
> +	dev->rx_bandwidth_auto = v4l2_ctrl_new_std(&dev->rx_ctrl_handler,
> +		&hackrf_ctrl_ops_rx, V4L2_CID_RF_TUNER_BANDWIDTH_AUTO,
> +		0, 1, 0, 1);
> +	dev->rx_bandwidth = v4l2_ctrl_new_std(&dev->rx_ctrl_handler,
> +		&hackrf_ctrl_ops_rx, V4L2_CID_RF_TUNER_BANDWIDTH,
> +		1750000, 28000000, 50000, 1750000);
> +	v4l2_ctrl_auto_cluster(2, &dev->rx_bandwidth_auto, 0, false);
> +	dev->rx_rf_gain = v4l2_ctrl_new_std(&dev->rx_ctrl_handler,
> +		&hackrf_ctrl_ops_rx, V4L2_CID_RF_TUNER_RF_GAIN, 0, 12, 12, 0);
> +	dev->rx_lna_gain = v4l2_ctrl_new_std(&dev->rx_ctrl_handler,
> +		&hackrf_ctrl_ops_rx, V4L2_CID_RF_TUNER_LNA_GAIN, 0, 40, 8, 0);
> +	dev->rx_if_gain = v4l2_ctrl_new_std(&dev->rx_ctrl_handler,
> +		&hackrf_ctrl_ops_rx, V4L2_CID_RF_TUNER_IF_GAIN, 0, 62, 2, 0);
> +	if (dev->rx_ctrl_handler.error) {
> +		ret = dev->rx_ctrl_handler.error;
> +		dev_err(dev->dev, "Could not initialize controls\n");
> +		goto err_v4l2_ctrl_handler_free_rx;
> +	}
> +	v4l2_ctrl_handler_setup(&dev->rx_ctrl_handler);
> +
> +	/* Register controls for transmitter */
> +	v4l2_ctrl_handler_init(&dev->tx_ctrl_handler, 4);
> +	dev->tx_bandwidth_auto = v4l2_ctrl_new_std(&dev->tx_ctrl_handler,
> +		&hackrf_ctrl_ops_tx, V4L2_CID_RF_TUNER_BANDWIDTH_AUTO,
> +		0, 1, 0, 1);
> +	dev->tx_bandwidth = v4l2_ctrl_new_std(&dev->tx_ctrl_handler,
> +		&hackrf_ctrl_ops_tx, V4L2_CID_RF_TUNER_BANDWIDTH,
> +		1750000, 28000000, 50000, 1750000);
> +	v4l2_ctrl_auto_cluster(2, &dev->tx_bandwidth_auto, 0, false);
> +	dev->tx_lna_gain = v4l2_ctrl_new_std(&dev->tx_ctrl_handler,
> +		&hackrf_ctrl_ops_tx, V4L2_CID_RF_TUNER_LNA_GAIN, 0, 47, 1, 0);
> +	dev->tx_rf_gain = v4l2_ctrl_new_std(&dev->tx_ctrl_handler,
> +		&hackrf_ctrl_ops_tx, V4L2_CID_RF_TUNER_RF_GAIN, 0, 15, 15, 0);
> +	if (dev->tx_ctrl_handler.error) {
> +		ret = dev->tx_ctrl_handler.error;
> +		dev_err(dev->dev, "Could not initialize controls\n");
> +		goto err_v4l2_ctrl_handler_free_tx;
> +	}
> +	v4l2_ctrl_handler_setup(&dev->tx_ctrl_handler);
>  
>  	/* Register the v4l2_device structure */
>  	dev->v4l2_dev.release = hackrf_video_release;
>  	ret = v4l2_device_register(&intf->dev, &dev->v4l2_dev);
>  	if (ret) {
>  		dev_err(dev->dev, "Failed to register v4l2-device (%d)\n", ret);
> -		goto err_free_mem;
> +		goto err_v4l2_ctrl_handler_free_tx;
>  	}
>  
> -	/* Register controls */
> -	v4l2_ctrl_handler_init(&dev->hdl, 5);
> -	dev->bandwidth_auto = v4l2_ctrl_new_std(&dev->hdl, &hackrf_ctrl_ops,
> -			V4L2_CID_RF_TUNER_BANDWIDTH_AUTO, 0, 1, 1, 1);
> -	dev->bandwidth = v4l2_ctrl_new_std(&dev->hdl, &hackrf_ctrl_ops,
> -			V4L2_CID_RF_TUNER_BANDWIDTH,
> -			1750000, 28000000, 50000, 1750000);
> -	v4l2_ctrl_auto_cluster(2, &dev->bandwidth_auto, 0, false);
> -	dev->rf_gain = v4l2_ctrl_new_std(&dev->hdl, &hackrf_ctrl_ops,
> -			V4L2_CID_RF_TUNER_RF_GAIN, 0, 12, 12, 0);
> -	dev->lna_gain = v4l2_ctrl_new_std(&dev->hdl, &hackrf_ctrl_ops,
> -			V4L2_CID_RF_TUNER_LNA_GAIN, 0, 40, 8, 0);
> -	dev->if_gain = v4l2_ctrl_new_std(&dev->hdl, &hackrf_ctrl_ops,
> -			V4L2_CID_RF_TUNER_IF_GAIN, 0, 62, 2, 0);
> -	if (dev->hdl.error) {
> -		ret = dev->hdl.error;
> -		dev_err(dev->dev, "Could not initialize controls\n");
> -		goto err_free_controls;
> +	/* Init video_device structure for receiver */
> +	dev->rx_vdev = hackrf_template;
> +	dev->rx_vdev.queue = &dev->rx_vb2_queue;
> +	dev->rx_vdev.queue->lock = &dev->vb_queue_lock;
> +	dev->rx_vdev.v4l2_dev = &dev->v4l2_dev;
> +	dev->rx_vdev.ctrl_handler = &dev->rx_ctrl_handler;
> +	dev->rx_vdev.lock = &dev->v4l2_lock;
> +	dev->rx_vdev.vfl_dir = VFL_DIR_RX;
> +	video_set_drvdata(&dev->rx_vdev, dev);
> +	ret = video_register_device(&dev->rx_vdev, VFL_TYPE_SDR, -1);
> +	if (ret) {
> +		dev_err(dev->dev,
> +			"Failed to register as video device (%d)\n", ret);
> +		goto err_v4l2_device_unregister;
>  	}
> -
> -	v4l2_ctrl_handler_setup(&dev->hdl);
> -
> -	dev->v4l2_dev.ctrl_handler = &dev->hdl;
> -	dev->vdev.v4l2_dev = &dev->v4l2_dev;
> -	dev->vdev.lock = &dev->v4l2_lock;
> -
> -	ret = video_register_device(&dev->vdev, VFL_TYPE_SDR, -1);
> +	dev_info(dev->dev, "Registered as %s\n",
> +		 video_device_node_name(&dev->rx_vdev));
> +
> +	/* Init video_device structure for transmitter */
> +	dev->tx_vdev = hackrf_template;
> +	dev->tx_vdev.queue = &dev->tx_vb2_queue;
> +	dev->tx_vdev.queue->lock = &dev->vb_queue_lock;
> +	dev->tx_vdev.v4l2_dev = &dev->v4l2_dev;
> +	dev->tx_vdev.ctrl_handler = &dev->tx_ctrl_handler;
> +	dev->tx_vdev.lock = &dev->v4l2_lock;
> +	dev->tx_vdev.vfl_dir = VFL_DIR_TX;
> +	video_set_drvdata(&dev->tx_vdev, dev);
> +	ret = video_register_device(&dev->tx_vdev, VFL_TYPE_SDR, -1);
>  	if (ret) {
> -		dev_err(dev->dev, "Failed to register as video device (%d)\n",
> -				ret);
> -		goto err_unregister_v4l2_dev;
> +		dev_err(dev->dev,
> +			"Failed to register as video device (%d)\n", ret);
> +		goto err_video_unregister_device_rx;
>  	}
>  	dev_info(dev->dev, "Registered as %s\n",
> -			video_device_node_name(&dev->vdev));
> +		 video_device_node_name(&dev->tx_vdev));
> +
>  	dev_notice(dev->dev, "SDR API is still slightly experimental and functionality changes may follow\n");
>  	return 0;
> -
> -err_free_controls:
> -	v4l2_ctrl_handler_free(&dev->hdl);
> -err_unregister_v4l2_dev:
> +err_video_unregister_device_rx:
> +	video_unregister_device(&dev->rx_vdev);
> +err_v4l2_device_unregister:
>  	v4l2_device_unregister(&dev->v4l2_dev);
> -err_free_mem:
> +err_v4l2_ctrl_handler_free_tx:
> +	v4l2_ctrl_handler_free(&dev->tx_ctrl_handler);
> +err_v4l2_ctrl_handler_free_rx:
> +	v4l2_ctrl_handler_free(&dev->rx_ctrl_handler);
> +err_kfree:
>  	kfree(dev);
> +err:
> +	dev_dbg(dev->dev, "failed=%d\n", ret);
>  	return ret;
>  }
>  
> 

Regards,

	Hans
