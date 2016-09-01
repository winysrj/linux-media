Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:50797 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757188AbcIAVXy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Sep 2016 17:23:54 -0400
Date: Thu, 1 Sep 2016 22:23:51 +0100
From: Sean Young <sean@mess.org>
To: Andi Shyti <andi.shyti@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andi Shyti <andi@etezian.org>
Subject: Re: [PATCH v2 1/7] [media] rc-main: assign driver type during
 allocation
Message-ID: <20160901212351.GB22198@gofer.mess.org>
References: <20160901171629.15422-1-andi.shyti@samsung.com>
 <20160901171629.15422-2-andi.shyti@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160901171629.15422-2-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 02, 2016 at 02:16:23AM +0900, Andi Shyti wrote:
> The driver type can be assigned immediately when an RC device
> requests to the framework to allocate the device.
> 
> This is an 'enum rc_driver_type' data type and specifies whether
> the device is a raw receiver or scancode receiver. The type will
> be given as parameter to the rc_allocate_device device.
> 
> Change accordingly all the drivers calling rc_allocate_device()
> so that the device type is specified during the rc device
> allocation. Whenever the device type is not specified, it will be
> set as RC_DRIVER_SCANCODE which was the default '0' value.
> 
> Suggested-by: Sean Young <sean@mess.org>
> Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
> ---

...

> diff --git a/drivers/media/pci/cx88/cx88-input.c b/drivers/media/pci/cx88/cx88-input.c
> index 3f1342c..e52bf69 100644
> --- a/drivers/media/pci/cx88/cx88-input.c
> +++ b/drivers/media/pci/cx88/cx88-input.c
> @@ -271,7 +271,7 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
>  				 */
>  
>  	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
> -	dev = rc_allocate_device();
> +	dev = rc_allocate_device(RC_DRIVER_IR_RAW);
>  	if (!ir || !dev)
>  		goto err_out_free;
>  

If ir->sampling = 0 then it should be RC_DRIVER_SCANCODE.


> @@ -481,7 +481,6 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
>  	dev->scancode_mask = hardware_mask;
>  
>  	if (ir->sampling) {
> -		dev->driver_type = RC_DRIVER_IR_RAW;
>  		dev->timeout = 10 * 1000 * 1000; /* 10 ms */
>  	} else {
>  		dev->driver_type = RC_DRIVER_SCANCODE;

That assignment shouldn't really be there any more.


> diff --git a/drivers/media/pci/saa7134/saa7134-input.c b/drivers/media/pci/saa7134/saa7134-input.c
> index c8042c3..e9d4a47 100644
> --- a/drivers/media/pci/saa7134/saa7134-input.c
> +++ b/drivers/media/pci/saa7134/saa7134-input.c
> @@ -849,7 +849,7 @@ int saa7134_input_init1(struct saa7134_dev *dev)
>  	}
>  
>  	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
> -	rc = rc_allocate_device();
> +	rc = rc_allocate_device(RC_DRIVER_SCANCODE);
>  	if (!ir || !rc) {
>  		err = -ENOMEM;
>  		goto err_out_free;

This is not correct, I'm afraid. If you look at the code you can see that
if raw_decode is true, then it should be RC_DRIVER_IR_RAW.


Sean
