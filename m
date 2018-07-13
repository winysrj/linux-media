Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:35826 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731564AbeGMIOC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Jul 2018 04:14:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org, tglx@linutronix.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH RFC] usb: add usb_fill_iso_urb()
Date: Fri, 13 Jul 2018 11:01:02 +0300
Message-ID: <23211374.K0HmdtcaYO@avalon>
In-Reply-To: <20180712223527.5nmxndignujo7smt@linutronix.de>
References: <20180620164945.xb24m7wlbtb6cys5@linutronix.de> <Pine.LNX.4.44L0.1806201322260.1758-100000@iolanthe.rowland.org> <20180712223527.5nmxndignujo7smt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sebastian,

Thank you for the patch.

On Friday, 13 July 2018 01:35:27 EEST Sebastian Andrzej Siewior wrote:
> Provide usb_fill_iso_urb() for the initialisation of isochronous URBs.
> We already have one of this helpers for control, bulk and interruptible
> URB types. This helps to keep the initialisation of the URB members in
> one place.
> Update the documentation by adding this to the available init functions
> and remove the suggestion to use the `_int_' helper which might provide
> wrong encoding for the `interval' member.
> 
> This looks like it would cover most users nicely. The sound subsystem
> initialises the ->iso_frame_desc[].offset + length member (often) at a
> different location and I'm not sure ->interval will work always as
> expected. So we might need to overwrite those two in worst case.
> 
> Some users also initialise ->iso_frame_desc[].actual_length but I don't

s/I don't/I don't think/ ?

> this is required since it is the return value.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  Documentation/driver-api/usb/URB.rst | 12 +++----
>  include/linux/usb.h                  | 53 ++++++++++++++++++++++++++++
>  2 files changed, 59 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/driver-api/usb/URB.rst
> b/Documentation/driver-api/usb/URB.rst index 61a54da9fce9..20030b781519
> 100644
> --- a/Documentation/driver-api/usb/URB.rst
> +++ b/Documentation/driver-api/usb/URB.rst
> @@ -116,11 +116,11 @@ What has to be filled in?
> 
>  Depending on the type of transaction, there are some inline functions
>  defined in ``linux/usb.h`` to simplify the initialization, such as
> -:c:func:`usb_fill_control_urb`, :c:func:`usb_fill_bulk_urb` and
> -:c:func:`usb_fill_int_urb`.  In general, they need the usb device pointer,
> -the pipe (usual format from usb.h), the transfer buffer, the desired
> transfer -length, the completion handler, and its context. Take a look at
> the some -existing drivers to see how they're used.
> +:c:func:`usb_fill_control_urb`, :c:func:`usb_fill_bulk_urb`,
> +:c:func:`usb_fill_int_urb` and :c:func:`usb_fill_iso_urb`.  In general,
> they +need the usb device pointer, the pipe (usual format from usb.h), the
> transfer +buffer, the desired transfer length, the completion handler, and
> its context. +Take a look at the some existing drivers to see how they're
> used.
> 
>  Flags:
> 
> @@ -243,7 +243,7 @@ Besides the fields present on a bulk transfer, for ISO,
> you also also have to set ``urb->interval`` to say how often to make
> transfers; it's often one per frame (which is once every microframe for
> highspeed devices). The actual interval used will be a power of two that's
> no bigger than what -you specify. You can use the
> :c:func:`usb_fill_int_urb` macro to fill +you specify. You can use the
> :c:func:`usb_fill_iso_urb` macro to fill most ISO transfer fields.
> 
>  For ISO transfers you also have to fill a
> :c:type:`usb_iso_packet_descriptor` diff --git a/include/linux/usb.h
> b/include/linux/usb.h
> index 4cdd515a4385..74a3339041d6 100644
> --- a/include/linux/usb.h
> +++ b/include/linux/usb.h
> @@ -1697,6 +1697,59 @@ static inline void usb_fill_int_urb(struct urb *urb,
>  	urb->start_frame = -1;
>  }
> 
> +/**
> + * usb_fill_iso_urb - macro to help initialize an isochronous urb

Strictly speaking this isn't a macro, so I'd write "initializes an isochronous 
urb"

> + * @urb: pointer to the urb to initialize.
> + * @dev: pointer to the struct usb_device for this urb.
> + * @pipe: the endpoint pipe
> + * @transfer_buffer: pointer to the transfer buffer
> + * @buffer_length: length of the transfer buffer
> + * @complete_fn: pointer to the usb_complete_t function
> + * @context: what to set the urb context to.
> + * @interval: what to set the urb interval to, encoded like
> + *	the endpoint descriptor's bInterval value.
> + * @packets: number of ISO packets.
> + * @packet_size: size of each ISO packet.
> + *
> + * Initializes an isochronous urb with the proper information needed to
> submit
> + * it to a device.
> + *
> + * Note that isochronous endpoints use a logarithmic encoding of the
> endpoint
> + * interval, and express polling intervals in microframes (eight per
> + * millisecond) rather than in frames (one per millisecond).
> + */
> +static inline void usb_fill_iso_urb(struct urb *urb,
> +				    struct usb_device *dev,
> +				    unsigned int pipe,
> +				    void *transfer_buffer,
> +				    int buffer_length,
> +				    usb_complete_t complete_fn,
> +				    void *context,
> +				    int interval,
> +				    unsigned int packets,
> +				    unsigned int packet_size)
> +{
> +	unsigned int i;
> +
> +	urb->dev = dev;
> +	urb->pipe = pipe;
> +	urb->transfer_buffer = transfer_buffer;
> +	urb->transfer_buffer_length = buffer_length;
> +	urb->complete = complete_fn;
> +	urb->context = context;
> +
> +	interval = clamp(interval, 1, 16);
> +	urb->interval = 1 << (interval - 1);
> +	urb->start_frame = -1;
> +
> +	urb->number_of_packets = packets;
> +
> +	for (i = 0; i < packets; i++) {
> +		urb->iso_frame_desc[i].offset = packet_size * i;
> +		urb->iso_frame_desc[i].length = packet_size;
> +	}
> +}

I think this should be moved to a .c file as the function is growing big, but 
that's true of the other URB helpers as well, so it can be done later in a 
separate patch.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>  extern void usb_init_urb(struct urb *urb);
>  extern struct urb *usb_alloc_urb(int iso_packets, gfp_t mem_flags);
>  extern void usb_free_urb(struct urb *urb);

-- 
Regards,

Laurent Pinchart
