Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:56352 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752676AbbFHJ1E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Jun 2015 05:27:04 -0400
Message-ID: <55755FE2.4070302@xs4all.nl>
Date: Mon, 08 Jun 2015 11:26:58 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 8/9] hackrf: add support for transmitter
References: <1433592188-31748-1-git-send-email-crope@iki.fi> <1433592188-31748-8-git-send-email-crope@iki.fi>
In-Reply-To: <1433592188-31748-8-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

I've got one comment:

On 06/06/2015 02:03 PM, Antti Palosaari wrote:
> HackRF SDR device has both receiver and transmitter. There is limitation
> that receiver and transmitter cannot be used at the same time
> (half-duplex operation). That patch implements transmitter support to
> existing receiver only driver.
> 
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/usb/hackrf/hackrf.c | 855 ++++++++++++++++++++++++++++----------
>  1 file changed, 640 insertions(+), 215 deletions(-)
> 
> diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
> index 5bd291b..6ad6937 100644
> --- a/drivers/media/usb/hackrf/hackrf.c
> +++ b/drivers/media/usb/hackrf/hackrf.c
> +/*
> + * TODO: That blocks whole transmitter device open when receiver is opened and
> + * the other way around, even only streaming is not allowed. Better solution
> + * needed...

Exactly. Why not use a similar approach as for video:

Return EBUSY when the applications tries to call:

S_FREQUENCY, S_MODULATOR, S_TUNER or REQBUFS/CREATE_BUFS and the other
vb2 queue is marked 'busy'. The check for REQBUFS/CREATE_BUFS can be done
in hackrf_queue_setup.

You should always be able to open a device node in V4L2.

Regards,

	Hans

> + */
> +static int hackrf_v4l2_open(struct file *file)
> +{
> +	struct hackrf_dev *dev = video_drvdata(file);
> +	struct video_device *vdev = video_devdata(file);
> +	int ret;
> +
> +	dev_dbg(dev->dev, "\n");
> +
> +	if (mutex_lock_interruptible(&dev->v4l2_open_release_mutex))
> +		return -ERESTARTSYS;
> +
> +	if (vdev->vfl_dir == VFL_DIR_RX) {
> +		if (test_bit(TX_V4L2_DEV_OPEN, &dev->flags)) {
> +			ret = -EBUSY;
> +			goto err_mutex_unlock;
> +		}
> +	} else {
> +		if (test_bit(RX_V4L2_DEV_OPEN, &dev->flags)) {
> +			ret = -EBUSY;
> +			goto err_mutex_unlock;
> +		}
> +	}
> +
> +	ret = v4l2_fh_open(file);
> +	if (ret)
> +		goto err_mutex_unlock;
> +
> +	dev->users++;
> +
> +	if (vdev->vfl_dir == VFL_DIR_RX)
> +		set_bit(RX_V4L2_DEV_OPEN, &dev->flags);
> +	else
> +		set_bit(TX_V4L2_DEV_OPEN, &dev->flags);
> +
> +	mutex_unlock(&dev->v4l2_open_release_mutex);
> +
> +	return 0;
> +err_mutex_unlock:
> +	mutex_unlock(&dev->v4l2_open_release_mutex);
> +	return ret;
> +}

