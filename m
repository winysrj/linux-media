Return-path: <linux-media-owner@vger.kernel.org>
Received: from mk-outboundfilter-1.mail.uk.tiscali.com ([212.74.114.37]:26863
	"EHLO mk-outboundfilter-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756198AbZBDWHs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Feb 2009 17:07:48 -0500
From: Adam Baker <linux@baker-net.org.uk>
To: "Jean-Francois Moine" <moinejf@free.fr>
Subject: Re: [PATCH] Make sure gspca cleans up USB resources during disconnect
Date: Wed, 4 Feb 2009 22:07:44 +0000
Cc: kilgota@banach.math.auburn.edu,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-media@vger.kernel.org
References: <200902032313.17538.linux@baker-net.org.uk> <20090204174008.31846f22@free.fr>
In-Reply-To: <20090204174008.31846f22@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902042207.44867.linux@baker-net.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 04 February 2009, Jean-Francois Moine wrote:
> On Tue, 3 Feb 2009 23:13:17 +0000
>
> Adam Baker <linux@baker-net.org.uk> wrote:
> > If a device using the gspca framework is unplugged while it is still
> > streaming then the call that is used to free the URBs that have been
> > allocated occurs after the pointer it uses becomes invalid at the end
> > of gspca_disconnect. Make another cleanup call in gspca_disconnect
> > while the pointer is still valid (multiple calls are OK as
> > destroy_urbs checks for pointers already being NULL.
> >
> > Signed-off-by: Adam Baker <linux@baker-net.org.uk>
> >
> > ---
> > diff -r 4d0827823ebc linux/drivers/media/video/gspca/gspca.c
> > --- a/linux/drivers/media/video/gspca/gspca.c	Tue Feb 03
> > 10:42:28 2009 +0100 +++
> > b/linux/drivers/media/video/gspca/gspca.c	Tue Feb 03 23:07:34
> > 2009 +0000 @@ -434,6 +434,7 @@ static void destroy_urbs(struct
> > gspca_de if (urb == NULL) break;
> >
> > +		BUG_ON(!gspca_dev->dev);
>
> No: this function is called on close after disconnect. when the pointer
> is NULL.

But at that time urb should be NULL so we don't get to the BUG_ON. If we urb 
is not NULL but gspca_dev->dv is then something has gone wrong and it is 
impossible to clean up properly.

>
> >  		gspca_dev->urb[i] = NULL;
> >  		if (gspca_dev->present)
> >  			usb_kill_urb(urb);
> > @@ -1953,8 +1954,12 @@ void gspca_disconnect(struct usb_interfa
> >  {
> >  	struct gspca_dev *gspca_dev = usb_get_intfdata(intf);
> >
> > +	mutex_lock(&gspca_dev->usb_lock);
> >  	gspca_dev->present = 0;
> > +	mutex_unlock(&gspca_dev->usb_lock);
>
> I do not see what is the use of the lock...

It ensure that if elsewhere there is the code sequence
mutex_lock
if (!dev->present)
	goto cleanup;
use usb or urb
mutex_unlock

then if it finds dev->present set it knows that the urb and usb pointers will 
remain valid pointers (even if they refer to a disconnected device) until the 
code has finished using them. 

>
> > +	destroy_urbs(gspca_dev);
> > +	gspca_dev->dev = NULL;
>
> As I understand, the usb device is freed at disconnection time after
> the call to the (struct usb_driver *)->disconnect() function. I did not
> know that and I could not find yet how! So, this is OK for me.
>
> >  	usb_set_intfdata(intf, NULL);
> >
> >  	/* release the device */
>
> Now, as the pointer to the usb_driver may be NULL, I have to check if an
> (other) oops may occur elsewhere...
>

As I said, I believe that is possible with the finepix driver and the sequence 
I quoted above with checking gspca_dev->present with usb_lock held is the fix 
but I'm not confident of fixing that completely without access to the 
hardware, especially as you can't do that in the completion handler. It 
shouldn't introduce a regression though as before you would be attempting to 
access freed memory and now you have a NULL pointer instead so such code was 
already buggy.

I have tested pulling the cable out during streaming after making this change 
on both sq905 and pac207 so whilst I can't say for certain they are OK 

Having thought about it a bit more I suspect that you should also now remove 
the if (gspca_dev->present) check on usb_kill_urb as it is possible there may 
be urbs still awaiting completion when disconnect happens.

> Thank you.

Thank You - If it wasn't for your work on gspca I'd still be using a buggy old 
driver that had no chance of making it to main line.

Adam

