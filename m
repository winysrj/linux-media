Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:47756 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1754419AbeFTPfH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 11:35:07 -0400
Date: Wed, 20 Jun 2018 11:35:05 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        <linux-usb@vger.kernel.org>, <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] USB: note that usb_fill_int_urb() can be used used for
 ISOC urbs.
In-Reply-To: <20180620152007.xapqkv4ww2hnmvkq@linutronix.de>
Message-ID: <Pine.LNX.4.44L0.1806201127290.1758-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 20 Jun 2018, Sebastian Andrzej Siewior wrote:

> Laurent suggested that the kerneldoc documentation could state that
> usb_fill_int_urb() can also be used for the initialisation of an
> isochronous urb. The USB documentation in
> Documentation/driver-api/usb/URB.rst already mentions this, some drivers
> do so and there is no explicit usb_fill_iso_urb().
> 
> Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
> On 2018-06-20 17:14:53 [+0300], Laurent Pinchart wrote:
> > > So you simply asking that the kerneldoc of usb_fill_int_urb() is
> > > extended to mention isoc, too?
> > 
> > That would be nice I think.
> 
> here it is.
> 
>  include/linux/usb.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/usb.h b/include/linux/usb.h
> index 4cdd515a4385..c3a8bd586121 100644
> --- a/include/linux/usb.h
> +++ b/include/linux/usb.h
> @@ -1657,7 +1657,8 @@ static inline void usb_fill_bulk_urb(struct urb *urb,
>   *	the endpoint descriptor's bInterval value.
>   *
>   * Initializes a interrupt urb with the proper information needed to submit
> - * it to a device.
> + * it to a device. This function can also be used to initialize an isochronous
> + * urb.

No, no!  This function can _help_ initialize an isochronous URB, but
that's all.  It would be better to create an explicit 
usb_fill_isoc_urb() routine, and even that would have to be incomplete.

There are two problems with using usb_fill_int_urb() to initialize an 
isochronous URB:

	The calculation of the interval value is wrong for full-speed
	devices.

	The routine does not set urb->number_of_packets or
	urb->iso_frame_desc[].

Alan Stern

>   *
>   * Note that High Speed and SuperSpeed(+) interrupt endpoints use a logarithmic
>   * encoding of the endpoint interval, and express polling intervals in
> 
