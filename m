Return-path: <linux-media-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:39059 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1731379AbeGMUfK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Jul 2018 16:35:10 -0400
Date: Fri, 13 Jul 2018 16:12:18 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        <linux-usb@vger.kernel.org>, <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH RFC] usb: add usb_fill_iso_urb()
In-Reply-To: <20180712223527.5nmxndignujo7smt@linutronix.de>
Message-ID: <Pine.LNX.4.44L0.1807131606150.10216-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 13 Jul 2018, Sebastian Andrzej Siewior wrote:

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
> this is required since it is the return value.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---


> --- a/include/linux/usb.h
> +++ b/include/linux/usb.h
> @@ -1697,6 +1697,59 @@ static inline void usb_fill_int_urb(struct urb *urb,
>  	urb->start_frame = -1;
>  }
>  
> +/**
> + * usb_fill_iso_urb - macro to help initialize an isochronous urb
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
> + * Initializes an isochronous urb with the proper information needed to submit
> + * it to a device.
> + *
> + * Note that isochronous endpoints use a logarithmic encoding of the endpoint
> + * interval, and express polling intervals in microframes (eight per
> + * millisecond) rather than in frames (one per millisecond).

Full-speed devices express polling intervals in frames (1 per ms); 
high-speed and SuperSpeed devices express polling intervals in 
microframes (8 per ms).

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

This initialization of the iso_frame_desc[] elements assumes that all
the packets are the same size.  The kerneldoc should mention that this
is just an assumption; if it is wrong then the driver code will need to
rewrite the elements after calling this function.

One possibility is to allow the caller to set packets to 0; in that 
case you could avoid setting either urb->number_of_packets or the 
iso_frame_desc[] elements.

Alan Stern
