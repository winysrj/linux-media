Return-path: <linux-media-owner@vger.kernel.org>
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:6374 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab2CLKjO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Mar 2012 06:39:14 -0400
Date: Mon, 12 Mar 2012 11:04:50 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH] [media] dib0700: Fix memory leak during initialization
Message-ID: <20120312110450.6f052af0@endymion.delvare>
In-Reply-To: <4F589630.5020008@redhat.com>
References: <20120212111911.32f4c390@endymion.delvare>
	<4F589630.5020008@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thanks for your reply.

On Thu, 08 Mar 2012 08:21:20 -0300, Mauro Carvalho Chehab wrote:
> Em 12-02-2012 08:19, Jean Delvare escreveu:
> > Reported by kmemleak.
> > 
> > Signed-off-by: Jean Delvare <khali@linux-fr.org>
> > Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> > Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
> > ---
> > I am not familiar with the usb API, are we also supposed to call
> > usb_kill_urb() in the error case maybe?
> > 
> >  drivers/media/dvb/dvb-usb/dib0700_core.c |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > --- linux-3.3-rc3.orig/drivers/media/dvb/dvb-usb/dib0700_core.c	2012-01-20 14:06:38.000000000 +0100
> > +++ linux-3.3-rc3/drivers/media/dvb/dvb-usb/dib0700_core.c	2012-02-12 00:32:19.005334036 +0100
> > @@ -787,6 +787,8 @@ int dib0700_rc_setup(struct dvb_usb_devi
> >  	if (ret)
> >  		err("rc submit urb failed\n");
> >  
> > +	usb_free_urb(purb);
> > +
> >  	return ret;
> >  }
> 
> This patch doesn't sound right on my eyes, as you're freeing
> an URB that you've just submitted _before_ having it handled
> by the dib0700_rc_urb_completion() callback.

Oops, you're totally right. I don't know a thing about USB as you can
see :(

> Btw, it seems that there's a bug at the fist if there:
> 
> static void dib0700_rc_urb_completion(struct urb *purb)
> {
> 	struct dvb_usb_device *d = purb->context;
> 	struct dib0700_rc_response *poll_reply;
> 	u32 uninitialized_var(keycode);
> 	u8 toggle;
> 
> 	deb_info("%s()\n", __func__);
> 	if (d == NULL)
> 		return;
> 
> 	if (d->rc_dev == NULL) {
> 		/* This will occur if disable_rc_polling=1 */
> 		usb_free_urb(purb);
> 		return;
> 	}
> 
> ...
> 
> it should be, instead:
> 
> 	if (!d || !d->rc_dev) {
> 		/* This will occur if disable_rc_polling=1 */
> 		usb_free_urb(purb);
> 		return;
> 	}	

"!d" can't actually happen, so it doesn't matter. d is passed by
dib0700_rc_setup() when calling usb_fill_bulk_urb(), and
dib0700_rc_setup() starts with dereferencing d, if it was NULL we'd
crash right away. Hence d is never NULL in dib0700_rc_urb_completion().

So this "if (d == NULL)" is just paranoia and might as well be removed.

> That's said, clearly there's no condition to stop the DVB IR
> handling.

Indeed, as I read the code, unless disable_rc_polling=1 or a fatal
error occurs, dib0700_rc_urb_completion will loop over and over
endlessly. I guess it's what "RC polling" is all about. No surprise why
my DVB-T card sucks so much power...

> Probably, the right thing to do there is to add a function like:
> 
> int dib0700_disconnect(...) 
> {
> 	usb_unlink_urb(urb);
> 	usb_free_urb(urb);
> 
> 	dvb_usb_device_exit(...);
> }
> 
> and use such function for the usb_driver disconnect handling: 
> 
> static struct usb_driver dib0700_driver = {
> 	.name       = "dvb_usb_dib0700",
> 	.probe      = dib0700_probe,
> 	.disconnect = dib0700_disconnect,
> 	.id_table   = dib0700_usb_id_table,
> };

This would avoid a memory leak on module removal, right? Sure, we can
do that, but what surprises me is that I don't remember removing the
module when kmemleak reported the leak to me. Oh well, kmemleak is
pretty new, maybe that was a false positive after all.

But is it OK to free the same URB twice? Your code above does it
unconditionally, while it may have been freed already
(disable_rc_polling=1 or a fatal error occurred). As it seems that
usb_unlink_urb() will call the completion callback with an error
status, and dib0700_rc_urb_completion() will free the URB when that
happens, I suppose it is sufficient to call usb_unlink_urb() in the
diconnect function?

Thanks,
-- 
Jean Delvare
