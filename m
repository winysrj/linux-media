Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:48292 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1754268AbeFTQVe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 12:21:34 -0400
Date: Wed, 20 Jun 2018 12:21:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        <linux-usb@vger.kernel.org>, <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] USB: note that usb_fill_int_urb() can be used used for
 ISOC urbs.
In-Reply-To: <20180620160200.vxdq4o2azkftpfqs@linutronix.de>
Message-ID: <Pine.LNX.4.44L0.1806201217150.1758-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 20 Jun 2018, Sebastian Andrzej Siewior wrote:

> On 2018-06-20 11:35:05 [-0400], Alan Stern wrote:
> > > diff --git a/include/linux/usb.h b/include/linux/usb.h
> > > index 4cdd515a4385..c3a8bd586121 100644
> > > --- a/include/linux/usb.h
> > > +++ b/include/linux/usb.h
> > > @@ -1657,7 +1657,8 @@ static inline void usb_fill_bulk_urb(struct urb *urb,
> > >   *	the endpoint descriptor's bInterval value.
> > >   *
> > >   * Initializes a interrupt urb with the proper information needed to submit
> > > - * it to a device.
> > > + * it to a device. This function can also be used to initialize an isochronous
> > > + * urb.
> > 
> > No, no!  This function can _help_ initialize an isochronous URB, but
> > that's all.  It would be better to create an explicit 
> > usb_fill_isoc_urb() routine, and even that would have to be incomplete.
> 
> Yes, incomplete. I read incomplete as some additional fields have to be
> set which are not set yet. But for FS you write…

There's also the cognitive dissonance of using a routine named 
"usb_fill_int_urb" to initialize an isochronous URB.  That should set 
off alarm bells in the mind of anyone reading the code, no matter what 
the documentation says.

> > There are two problems with using usb_fill_int_urb() to initialize an 
> > isochronous URB:
> > 
> > 	The calculation of the interval value is wrong for full-speed
> > 	devices.
> 
> Why wrong?

Because the interval value in the FS endpoint descriptor uses a
logarithmic encoding, whereas the value stored in the URB uses a linear
encoding.  Simply copying one value to the other will store an
incorrect number, except in the lucky cases where the interval is
either 1 or 2.

Alan Stern

> > 	The routine does not set urb->number_of_packets or
> > 	urb->iso_frame_desc[].
> 
> Yes.
> 
> > Alan Stern
> 
> Sebastian
