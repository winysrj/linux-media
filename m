Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:48304 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226AbZBDQq4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Feb 2009 11:46:56 -0500
Date: Wed, 4 Feb 2009 17:40:08 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Adam Baker <linux@baker-net.org.uk>
Cc: kilgota@banach.math.auburn.edu,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] Make sure gspca cleans up USB resources during
 disconnect
Message-ID: <20090204174008.31846f22@free.fr>
In-Reply-To: <200902032313.17538.linux@baker-net.org.uk>
References: <200902032313.17538.linux@baker-net.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 3 Feb 2009 23:13:17 +0000
Adam Baker <linux@baker-net.org.uk> wrote:

> If a device using the gspca framework is unplugged while it is still
> streaming then the call that is used to free the URBs that have been
> allocated occurs after the pointer it uses becomes invalid at the end
> of gspca_disconnect. Make another cleanup call in gspca_disconnect
> while the pointer is still valid (multiple calls are OK as
> destroy_urbs checks for pointers already being NULL.
> 
> Signed-off-by: Adam Baker <linux@baker-net.org.uk>
> 
> ---
> diff -r 4d0827823ebc linux/drivers/media/video/gspca/gspca.c
> --- a/linux/drivers/media/video/gspca/gspca.c	Tue Feb 03
> 10:42:28 2009 +0100 +++
> b/linux/drivers/media/video/gspca/gspca.c	Tue Feb 03 23:07:34
> 2009 +0000 @@ -434,6 +434,7 @@ static void destroy_urbs(struct
> gspca_de if (urb == NULL) break;
>  
> +		BUG_ON(!gspca_dev->dev);

No: this function is called on close after disconnect. when the pointer
is NULL.

>  		gspca_dev->urb[i] = NULL;
>  		if (gspca_dev->present)
>  			usb_kill_urb(urb);
> @@ -1953,8 +1954,12 @@ void gspca_disconnect(struct usb_interfa
>  {
>  	struct gspca_dev *gspca_dev = usb_get_intfdata(intf);
>  
> +	mutex_lock(&gspca_dev->usb_lock);
>  	gspca_dev->present = 0;
> +	mutex_unlock(&gspca_dev->usb_lock);

I do not see what is the use of the lock...

> +	destroy_urbs(gspca_dev);
> +	gspca_dev->dev = NULL;

As I understand, the usb device is freed at disconnection time after
the call to the (struct usb_driver *)->disconnect() function. I did not
know that and I could not find yet how! So, this is OK for me.

>  	usb_set_intfdata(intf, NULL);
>  
>  	/* release the device */

Now, as the pointer to the usb_driver may be NULL, I have to check if an
(other) oops may occur elsewhere...

Thank you.

-- 
Ken ar c'hentan	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
