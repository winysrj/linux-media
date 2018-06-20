Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:60760 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754177AbeFTQCD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 12:02:03 -0400
Date: Wed, 20 Jun 2018 18:02:00 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org, tglx@linutronix.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] USB: note that usb_fill_int_urb() can be used used for
 ISOC urbs.
Message-ID: <20180620160200.vxdq4o2azkftpfqs@linutronix.de>
References: <20180620152007.xapqkv4ww2hnmvkq@linutronix.de>
 <Pine.LNX.4.44L0.1806201127290.1758-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <Pine.LNX.4.44L0.1806201127290.1758-100000@iolanthe.rowland.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2018-06-20 11:35:05 [-0400], Alan Stern wrote:
> > diff --git a/include/linux/usb.h b/include/linux/usb.h
> > index 4cdd515a4385..c3a8bd586121 100644
> > --- a/include/linux/usb.h
> > +++ b/include/linux/usb.h
> > @@ -1657,7 +1657,8 @@ static inline void usb_fill_bulk_urb(struct urb *urb,
> >   *	the endpoint descriptor's bInterval value.
> >   *
> >   * Initializes a interrupt urb with the proper information needed to submit
> > - * it to a device.
> > + * it to a device. This function can also be used to initialize an isochronous
> > + * urb.
> 
> No, no!  This function can _help_ initialize an isochronous URB, but
> that's all.  It would be better to create an explicit 
> usb_fill_isoc_urb() routine, and even that would have to be incomplete.

Yes, incomplete. I read incomplete as some additional fields have to be
set which are not set yet. But for FS you write…

> There are two problems with using usb_fill_int_urb() to initialize an 
> isochronous URB:
> 
> 	The calculation of the interval value is wrong for full-speed
> 	devices.

Why wrong?

> 	The routine does not set urb->number_of_packets or
> 	urb->iso_frame_desc[].

Yes.

> Alan Stern

Sebastian
