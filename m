Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:58974 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750812AbbGQOQx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jul 2015 10:16:53 -0400
Message-ID: <55A90E16.5040104@xs4all.nl>
Date: Fri, 17 Jul 2015 16:15:50 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCHv2 8/9] hackrf: add support for transmitter
References: <1437030298-20944-1-git-send-email-crope@iki.fi> <1437030298-20944-9-git-send-email-crope@iki.fi>
In-Reply-To: <1437030298-20944-9-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/16/2015 09:04 AM, Antti Palosaari wrote:
> HackRF SDR device has both receiver and transmitter. There is limitation
> that receiver and transmitter cannot be used at the same time
> (half-duplex operation). That patch implements transmitter support to
> existing receiver only driver.
> 
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/usb/hackrf/hackrf.c | 787 +++++++++++++++++++++++++++-----------
>  1 file changed, 572 insertions(+), 215 deletions(-)
> 
> diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
> index 5bd291b..97de9cb6 100644
> --- a/drivers/media/usb/hackrf/hackrf.c
> +++ b/drivers/media/usb/hackrf/hackrf.c
> @@ -731,15 +889,19 @@ static int hackrf_querycap(struct file *file, void *fh,
>  		struct v4l2_capability *cap)
>  {
>  	struct hackrf_dev *dev = video_drvdata(file);
> +	struct video_device *vdev = video_devdata(file);
>  
>  	dev_dbg(dev->dev, "\n");
>  
> +	if (vdev->vfl_dir == VFL_DIR_RX)
> +		cap->device_caps = V4L2_CAP_SDR_CAPTURE | V4L2_CAP_TUNER;
> +	else
> +		cap->device_caps = V4L2_CAP_SDR_OUTPUT | V4L2_CAP_MODULATOR;
> +	cap->device_caps |= V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;

The capabilities are those of the whole device, so you should OR this with
V4L2_CAP_SDR_CAPTURE | V4L2_CAP_SDR_OUTPUT |
V4L2_CAP_TUNER | V4L2_CAP_MODULATOR

>  	strlcpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
> -	strlcpy(cap->card, dev->vdev.name, sizeof(cap->card));
> +	strlcpy(cap->card, dev->rx_vdev.name, sizeof(cap->card));
>  	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
> -	cap->device_caps = V4L2_CAP_SDR_CAPTURE | V4L2_CAP_STREAMING |
> -			V4L2_CAP_READWRITE | V4L2_CAP_TUNER;
> -	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
>  
>  	return 0;
>  }

Regards,

	Hans
