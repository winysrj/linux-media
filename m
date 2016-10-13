Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:58181 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752508AbcJMVjE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Oct 2016 17:39:04 -0400
Date: Thu, 13 Oct 2016 22:38:24 +0100
From: Sean Young <sean@mess.org>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 12/18] [media] RedRat3: Move a variable assignment in
 redrat3_init_rc_dev()
Message-ID: <20161013213824.GA23361@gofer.mess.org>
References: <566ABCD9.1060404@users.sourceforge.net>
 <81cef537-4ad0-3a74-8bde-94707dcd03f4@users.sourceforge.net>
 <b51ed26a-4a89-4e58-9fcc-3f4b4fa0987f@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b51ed26a-4a89-4e58-9fcc-3f4b4fa0987f@users.sourceforge.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 13, 2016 at 06:39:23PM +0200, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Thu, 13 Oct 2016 14:50:05 +0200
> 
> Move the assignment for the local variable "prod" behind the source code
> for a memory allocation by this function.

The redrat3 driver shouldn't be adding the usb vendor/product id to the
device name. A better patch would be to remove those from the snprintf
completely and to away with the local variable.

Sean

> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/media/rc/redrat3.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
> index b23a8bb..002030f 100644
> --- a/drivers/media/rc/redrat3.c
> +++ b/drivers/media/rc/redrat3.c
> @@ -856,12 +856,13 @@ static struct rc_dev *redrat3_init_rc_dev(struct redrat3_dev *rr3)
>  {
>  	struct rc_dev *rc;
>  	int ret;
> -	u16 prod = le16_to_cpu(rr3->udev->descriptor.idProduct);
> +	u16 prod;
>  
>  	rc = rc_allocate_device();
>  	if (!rc)
>  		goto out;
>  
> +	prod = le16_to_cpu(rr3->udev->descriptor.idProduct);
>  	snprintf(rr3->name, sizeof(rr3->name), "RedRat3%s "
>  		 "Infrared Remote Transceiver (%04x:%04x)",
>  		 prod == USB_RR3IIUSB_PRODUCT_ID ? "-II" : "",
> -- 
> 2.10.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
