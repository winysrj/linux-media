Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:39744 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064AbZBDBAw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2009 20:00:52 -0500
Date: Tue, 3 Feb 2009 19:12:44 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Adam Baker <linux@baker-net.org.uk>
cc: Jean-Francois Moine <moinejf@free.fr>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] Make sure gspca cleans up USB resources during
 disconnect
In-Reply-To: <200902032313.17538.linux@baker-net.org.uk>
Message-ID: <alpine.LNX.2.00.0902031859230.2512@banach.math.auburn.edu>
References: <200902032313.17538.linux@baker-net.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Tue, 3 Feb 2009, Adam Baker wrote:

> If a device using the gspca framework is unplugged while it is still streaming
> then the call that is used to free the URBs that have been allocated occurs
> after the pointer it uses becomes invalid at the end of gspca_disconnect.
> Make another cleanup call in gspca_disconnect while the pointer is still
> valid (multiple calls are OK as destroy_urbs checks for pointers already
> being NULL.
>
> Signed-off-by: Adam Baker <linux@baker-net.org.uk>
>
> ---
> diff -r 4d0827823ebc linux/drivers/media/video/gspca/gspca.c
> --- a/linux/drivers/media/video/gspca/gspca.c	Tue Feb 03 10:42:28 2009 +0100
> +++ b/linux/drivers/media/video/gspca/gspca.c	Tue Feb 03 23:07:34 2009 +0000
> @@ -434,6 +434,7 @@ static void destroy_urbs(struct gspca_de
> 		if (urb == NULL)
> 			break;
>
> +		BUG_ON(!gspca_dev->dev);
> 		gspca_dev->urb[i] = NULL;
> 		if (gspca_dev->present)
> 			usb_kill_urb(urb);
> @@ -1953,8 +1954,12 @@ void gspca_disconnect(struct usb_interfa
> {
> 	struct gspca_dev *gspca_dev = usb_get_intfdata(intf);
>
> +	mutex_lock(&gspca_dev->usb_lock);
> 	gspca_dev->present = 0;
> +	mutex_unlock(&gspca_dev->usb_lock);
>
> +	destroy_urbs(gspca_dev);
> +	gspca_dev->dev = NULL;
> 	usb_set_intfdata(intf, NULL);
>
> 	/* release the device */
>

Again, this solves the problem completely on the Pentium 4 Dual Core 
machine. Again, on the K8 machine there is the error message

libv4l2: error dequeuing buf: Resource temporarily unavailable

which, I strongly suspect, has nothing at all to do with the issue at 
hand.

I have at this point switched over to

create_singlethread_workqueue(MODULE_NAME)

on both boxes now. I think that your patch would run with this or without 
it. So the question is, whether singlethread is in fact better, or not. 
Me, I would tend to think it really makes no difference at all, because 
that was not what the problem was.

So, the next question is whether this patch gets accepted or not. It 
appears to solve *our* problem. Clearly, the big question is whether it 
could break something else.

Theodore Kilgore
