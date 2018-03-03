Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:41381 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751907AbeCCOhc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 3 Mar 2018 09:37:32 -0500
Date: Sat, 3 Mar 2018 11:37:26 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: tomoki.sekiyama@gmail.com
Cc: elfring@users.sourceforge.net, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] media: siano: Fix coherent memory allocation failure
 on arm64
Message-ID: <20180303113726.28c48296@vento.lan>
In-Reply-To: <20180303122017.32669-1-tomoki.sekiyama@gmail.com>
References: <20180303122017.32669-1-tomoki.sekiyama@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomoki,

Em Sat,  3 Mar 2018 21:20:17 +0900
tomoki.sekiyama@gmail.com escreveu:

> From: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>
> 
> On some architectures such as arm64, siano chip based TV-tuner
> USB devices are not recognized correctly due to coherent memory
> allocation failure with the following error:
> 
> [  663.556135] usbcore: deregistering interface driver smsusb
> [  683.624809] smsusb:smsusb_probe: board id=18, interface number 0
> [  683.633530] smsusb:smsusb_init_device: smscore_register_device(...) failed, rc -12
> [  683.641501] smsusb:smsusb_probe: Device initialized with return code -12
> [  683.652978] smsusb: probe of 1-1:1.0 failed with error -12
> 
> This is caused by dma_alloc_coherent(NULL, ...) returning NULL in
> smscoreapi.c.
> 
> To fix this error, usb_alloc_coherent() must be used for DMA
> memory allocation for USB devices in such architectures.

Actually, I was thinking on taking a different approach, for all media
USB devices: to let USB core to do the DMA mapping itself, and
not use coherent memory. E. g. something like the approach taken
on this patch:
	https://patchwork.linuxtv.org/patch/47592/

That should give an additional performance improvements to the driver
when used on non-x86 hardware.

> 
> v2: non-usb `device' is also be passed to dma_alloc_coherent()
> 
> Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>
> ---
>  drivers/media/common/siano/smscoreapi.c | 36 ++++++++++++++++++++++++---------
>  drivers/media/common/siano/smscoreapi.h |  2 ++
>  drivers/media/usb/siano/smsusb.c        |  1 +
>  3 files changed, 29 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
> index c5c827e11b64..34622b562963 100644
> --- a/drivers/media/common/siano/smscoreapi.c
> +++ b/drivers/media/common/siano/smscoreapi.c
> @@ -690,17 +690,24 @@ int smscore_register_device(struct smsdevice_params_t *params,
>  
>  	/* alloc common buffer */
>  	dev->common_buffer_size = params->buffer_size * params->num_buffers;
> -	dev->common_buffer = dma_alloc_coherent(NULL, dev->common_buffer_size,
> -						&dev->common_buffer_phys,
> -						GFP_KERNEL | GFP_DMA);
> -	if (!dev->common_buffer) {
> +	if (params->usb_device)
> +		buffer = usb_alloc_coherent(params->usb_device,
> +					    dev->common_buffer_size,
> +					    GFP_KERNEL | GFP_DMA,
> +					    &dev->common_buffer_phys);
> +	else
> +		buffer = dma_alloc_coherent(params->device,
> +					    dev->common_buffer_size,
> +					    &dev->common_buffer_phys,
> +					    GFP_KERNEL | GFP_DMA);
> +	if (!buffer) {
>  		smscore_unregister_device(dev);
>  		return -ENOMEM;
>  	}
> +	dev->common_buffer = buffer;
>  
>  	/* prepare dma buffers */
> -	for (buffer = dev->common_buffer;
> -	     dev->num_buffers < params->num_buffers;
> +	for (; dev->num_buffers < params->num_buffers;
>  	     dev->num_buffers++, buffer += params->buffer_size) {
>  		struct smscore_buffer_t *cb;
>  
> @@ -720,6 +727,7 @@ int smscore_register_device(struct smsdevice_params_t *params,
>  	dev->board_id = SMS_BOARD_UNKNOWN;
>  	dev->context = params->context;
>  	dev->device = params->device;
> +	dev->usb_device = params->usb_device;
>  	dev->setmode_handler = params->setmode_handler;
>  	dev->detectmode_handler = params->detectmode_handler;
>  	dev->sendrequest_handler = params->sendrequest_handler;
> @@ -1231,10 +1239,18 @@ void smscore_unregister_device(struct smscore_device_t *coredev)
>  
>  	pr_debug("freed %d buffers\n", num_buffers);
>  
> -	if (coredev->common_buffer)
> -		dma_free_coherent(NULL, coredev->common_buffer_size,
> -			coredev->common_buffer, coredev->common_buffer_phys);
> -
> +	if (coredev->common_buffer) {
> +		if (coredev->usb_device)
> +			usb_free_coherent(coredev->usb_device,
> +					  coredev->common_buffer_size,
> +					  coredev->common_buffer,
> +					  coredev->common_buffer_phys);
> +		else
> +			dma_free_coherent(coredev->device,
> +					  coredev->common_buffer_size,
> +					  coredev->common_buffer,
> +					  coredev->common_buffer_phys);
> +	}
>  	kfree(coredev->fw_buf);
>  
>  	list_del(&coredev->entry);
> diff --git a/drivers/media/common/siano/smscoreapi.h b/drivers/media/common/siano/smscoreapi.h
> index 4cc39e4a8318..134c69f7ea7b 100644
> --- a/drivers/media/common/siano/smscoreapi.h
> +++ b/drivers/media/common/siano/smscoreapi.h
> @@ -134,6 +134,7 @@ struct smscore_buffer_t {
>  
>  struct smsdevice_params_t {
>  	struct device	*device;
> +	struct usb_device	*usb_device;
>  
>  	int				buffer_size;
>  	int				num_buffers;
> @@ -176,6 +177,7 @@ struct smscore_device_t {
>  
>  	void *context;
>  	struct device *device;
> +	struct usb_device *usb_device;
>  
>  	char devpath[32];
>  	unsigned long device_flags;
> diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
> index f13e4b01b5a5..3c605a573ce4 100644
> --- a/drivers/media/usb/siano/smsusb.c
> +++ b/drivers/media/usb/siano/smsusb.c
> @@ -446,6 +446,7 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
>  		dev->in_ep, dev->out_ep);
>  
>  	params.device = &dev->udev->dev;
> +	params.usb_device = dev->udev;
>  	params.buffer_size = dev->buffer_size;
>  	params.num_buffers = MAX_BUFFERS;
>  	params.sendrequest_handler = smsusb_sendrequest;



Thanks,
Mauro
