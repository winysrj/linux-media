Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:39976 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756979Ab3EWIlz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 May 2013 04:41:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Leonid Kegulskiy <leo@lumanate.com>
Subject: Re: [PATCH] [media] hdpvr: Disable IR receiver by default.
Date: Thu, 23 May 2013 10:41:38 +0200
Cc: Jeff Hansen <x@jeffhansen.com>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <1368506659-13722-1-git-send-email-x@jeffhansen.com>
In-Reply-To: <1368506659-13722-1-git-send-email-x@jeffhansen.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201305231041.38871.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue 14 May 2013 06:44:19 Jeff Hansen wrote:
> All of the firmwares I've tested, including 0x1e, will inevitably crash
> before recording for even 10 minutes. There must be a race condition of
> IR RX vs. video-encoding in the firmware, because if you disable IR receiver
> polling, then the firmware is stable again. I'd guess that most people don't
> use this feature anyway, so we might as well disable it by default, and
> warn them that it might be unstable until Hauppauge fixes it in a future
> firmware.

Leonid, have you ever seen this? Can you verify that this happens for you
as well?

Regards,

	Hans

> 
> Signed-off-by: Jeff Hansen <x@jeffhansen.com>
> ---
>  drivers/media/usb/hdpvr/hdpvr-core.c |   16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/usb/hdpvr/hdpvr-core.c b/drivers/media/usb/hdpvr/hdpvr-core.c
> index 8247c19..3e80202 100644
> --- a/drivers/media/usb/hdpvr/hdpvr-core.c
> +++ b/drivers/media/usb/hdpvr/hdpvr-core.c
> @@ -53,6 +53,10 @@ static bool boost_audio;
>  module_param(boost_audio, bool, S_IRUGO|S_IWUSR);
>  MODULE_PARM_DESC(boost_audio, "boost the audio signal");
>  
> +int ir_rx_enable;
> +module_param(ir_rx_enable, int, S_IRUGO|S_IWUSR);
> +MODULE_PARM_DESC(ir_rx_enable, "Enable HDPVR IR receiver (firmware may be unstable)");
> +
>  
>  /* table of devices that work with this driver */
>  static struct usb_device_id hdpvr_table[] = {
> @@ -394,11 +398,13 @@ static int hdpvr_probe(struct usb_interface *interface,
>  		goto error;
>  	}
>  
> -	client = hdpvr_register_ir_rx_i2c(dev);
> -	if (!client) {
> -		v4l2_err(&dev->v4l2_dev, "i2c IR RX device register failed\n");
> -		retval = -ENODEV;
> -		goto reg_fail;
> +	if (ir_rx_enable) {
> +		client = hdpvr_register_ir_rx_i2c(dev);
> +		if (!client) {
> +			v4l2_err(&dev->v4l2_dev, "i2c IR RX device register failed\n");
> +			retval = -ENODEV;
> +			goto reg_fail;
> +		}
>  	}
>  
>  	client = hdpvr_register_ir_tx_i2c(dev);
> 
