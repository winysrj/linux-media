Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:51310 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751476AbdJ3Jnf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Oct 2017 05:43:35 -0400
Subject: Re: [PATCH] media: usb: s2255drv: update to firmware loading
To: dean@sensoray.com, linux-media@vger.kernel.org
Cc: linux-dev@sensoray.com
References: <505a133e73cbe64e723d9c55a3b03991@sensoray.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <6150e164-e97d-eafa-cea0-8932bc7e0675@xs4all.nl>
Date: Mon, 30 Oct 2017 10:43:30 +0100
MIME-Version: 1.0
In-Reply-To: <505a133e73cbe64e723d9c55a3b03991@sensoray.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/30/2017 12:15 AM, dean@sensoray.com wrote:
>      fixes intermittent soft reboot issue with firmware load
>      increases wait time of reset, as required by HW
> 
> Signed-off-by: Dean Anderson <dean@sensoray.com>
> 
> ---
>   drivers/media/usb/s2255/s2255drv.c | 13 ++++++-------
>   1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/usb/s2255/s2255drv.c 
> b/drivers/media/usb/s2255/s2255drv.c
> index b2f239c..8a8e314 100644
> --- a/drivers/media/usb/s2255/s2255drv.c
> +++ b/drivers/media/usb/s2255/s2255drv.c
> @@ -350,7 +350,7 @@ static void s2255_fillbuff(struct s2255_vc *vc, 
> struct s2255_buffer *buf,
>   			   int jpgsize);

Please repost: lines are wrapped around so this patch won't apply.

Thanks!

	Hans

>   static int s2255_set_mode(struct s2255_vc *vc, struct s2255_mode 
> *mode);
>   static int s2255_board_shutdown(struct s2255_dev *dev);
> -static void s2255_fwload_start(struct s2255_dev *dev, int reset);
> +static void s2255_fwload_start(struct s2255_dev *dev);
>   static void s2255_destroy(struct s2255_dev *dev);
>   static long s2255_vendor_req(struct s2255_dev *dev, unsigned char req,
>   			     u16 index, u16 value, void *buf,
> @@ -476,7 +476,7 @@ static void planar422p_to_yuv_packed(const unsigned 
> char *in,
>   static void s2255_reset_dsppower(struct s2255_dev *dev)
>   {
>   	s2255_vendor_req(dev, 0x40, 0x0000, 0x0001, NULL, 0, 1);
> -	msleep(20);
> +	msleep(50);
>   	s2255_vendor_req(dev, 0x50, 0x0000, 0x0000, NULL, 0, 1);
>   	msleep(600);
>   	s2255_vendor_req(dev, 0x10, 0x0000, 0x0000, NULL, 0, 1);
> @@ -1449,7 +1449,7 @@ static int s2255_open(struct file *file)
>   	case S2255_FW_FAILED:
>   		s2255_dev_err(&dev->udev->dev,
>   			"firmware load failed. retrying.\n");
> -		s2255_fwload_start(dev, 1);
> +		s2255_fwload_start(dev);
>   		wait_event_timeout(dev->fw_data->wait_fw,
>   				   ((atomic_read(&dev->fw_data->fw_state)
>   				     == S2255_FW_SUCCESS) ||
> @@ -2208,10 +2208,9 @@ static void s2255_stop_readpipe(struct s2255_dev 
> *dev)
>   	return;
>   }
> 
> -static void s2255_fwload_start(struct s2255_dev *dev, int reset)
> +static void s2255_fwload_start(struct s2255_dev *dev)
>   {
> -	if (reset)
> -		s2255_reset_dsppower(dev);
> +	s2255_reset_dsppower(dev);
>   	dev->fw_data->fw_size = dev->fw_data->fw->size;
>   	atomic_set(&dev->fw_data->fw_state, S2255_FW_NOTLOADED);
>   	memcpy(dev->fw_data->pfw_data,
> @@ -2336,7 +2335,7 @@ static int s2255_probe(struct usb_interface 
> *interface,
>   	retval = s2255_board_init(dev);
>   	if (retval)
>   		goto errorBOARDINIT;
> -	s2255_fwload_start(dev, 0);
> +	s2255_fwload_start(dev);
>   	/* loads v4l specific */
>   	retval = s2255_probe_v4l(dev);
>   	if (retval)
> 
