Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:38170 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727530AbeHIAJM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Aug 2018 20:09:12 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org, tglx@linutronix.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH v2] usb: add usb_fill_iso_urb()
Date: Thu, 09 Aug 2018 00:48:19 +0300
Message-ID: <25147045.lgE5vyKaS2@avalon>
In-Reply-To: <20180808213348.ipppuapqaasrkhxv@linutronix.de>
References: <20180808213348.ipppuapqaasrkhxv@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sebastian,

Thank you for the patch.

On Thursday, 9 August 2018 00:33:49 EEST Sebastian Andrzej Siewior wrote:
> Provide usb_fill_iso_urb() for the initialisation of isochronous URBs.
> We already have one of this helpers for control, bulk and interruptible
> URB types. This helps to keep the initialisation of the URB members in
> one place.
> Update the documentation by adding this to the available init functions
> and remove the suggestion to use the `_int_' helper which might provide
> wrong encoding for the `interval' member.
>=20
> This looks like it would cover most users nicely. The sound subsystem
> initialises the ->iso_frame_desc[].offset + length member at a different
> location and I'm not sure ->interval will work as expected.
>=20
> Some users also initialise ->iso_frame_desc[].actual_length but I don't
> think that this is required since it is the return value.
>=20
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
> RFC =E2=80=A6 v2:
> 	- rephrased the interval description as per Alan Stern.
> 	- packets and packet_size can be 0 so the initialisation of
> 	  those members will be skipped. Suggested by Alan Stern, came
> 	  handy while converting drivers.
> 	- Updated wording as suggested by Laurent Pinchart.
>=20
>  Documentation/driver-api/usb/URB.rst | 12 +++---
>  include/linux/usb.h                  | 60 ++++++++++++++++++++++++++++
>  2 files changed, 66 insertions(+), 6 deletions(-)
>=20
> diff --git a/Documentation/driver-api/usb/URB.rst
> b/Documentation/driver-api/usb/URB.rst index 61a54da9fce9..20030b781519
> 100644
> --- a/Documentation/driver-api/usb/URB.rst
> +++ b/Documentation/driver-api/usb/URB.rst
> @@ -116,11 +116,11 @@ What has to be filled in?
>=20
>  Depending on the type of transaction, there are some inline functions
>  defined in ``linux/usb.h`` to simplify the initialization, such as
> -:c:func:`usb_fill_control_urb`, :c:func:`usb_fill_bulk_urb` and
> -:c:func:`usb_fill_int_urb`.  In general, they need the usb device pointe=
r,
> -the pipe (usual format from usb.h), the transfer buffer, the desired
> transfer -length, the completion handler, and its context. Take a look at
> the some -existing drivers to see how they're used.
> +:c:func:`usb_fill_control_urb`, :c:func:`usb_fill_bulk_urb`,
> +:c:func:`usb_fill_int_urb` and :c:func:`usb_fill_iso_urb`.  In general,
> they +need the usb device pointer, the pipe (usual format from usb.h), the
> transfer +buffer, the desired transfer length, the completion handler, and
> its context. +Take a look at the some existing drivers to see how they're
> used.
>=20
>  Flags:
>=20
> @@ -243,7 +243,7 @@ Besides the fields present on a bulk transfer, for IS=
O,
> you also also have to set ``urb->interval`` to say how often to make
> transfers; it's often one per frame (which is once every microframe for
> highspeed devices). The actual interval used will be a power of two that's
> no bigger than what -you specify. You can use the
> :c:func:`usb_fill_int_urb` macro to fill +you specify. You can use the
> :c:func:`usb_fill_iso_urb` macro to fill most ISO transfer fields.
>=20
>  For ISO transfers you also have to fill a
> :c:type:`usb_iso_packet_descriptor` diff --git a/include/linux/usb.h
> b/include/linux/usb.h
> index 4cdd515a4385..ec1200d53ac5 100644
> --- a/include/linux/usb.h
> +++ b/include/linux/usb.h
> @@ -1697,6 +1697,66 @@ static inline void usb_fill_int_urb(struct urb *ur=
b,
>  	urb->start_frame =3D -1;
>  }
>=20
> +/**
> + * usb_fill_iso_urb - initializes an isochronous urb
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
> + * Full-speed devices express polling intervals in frames (1 per ms);
> + * high-speed and SuperSpeed devices express polling intervals in
> + * microframes (8 per ms).
> + *
> + * The arguments @packets is to initialize number_of_packets member of
> struct
> + * usb. If @packets and @packet_size is non zero then the iso_frame_desc
> array
> + * will be initialized and each packet will have the same size.
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
> +	urb->dev =3D dev;
> +	urb->pipe =3D pipe;
> +	urb->transfer_buffer =3D transfer_buffer;
> +	urb->transfer_buffer_length =3D buffer_length;
> +	urb->complete =3D complete_fn;
> +	urb->context =3D context;
> +
> +	interval =3D clamp(interval, 1, 16);
> +	urb->interval =3D 1 << (interval - 1);
> +	urb->start_frame =3D -1;
> +
> +	if (packets)
> +		urb->number_of_packets =3D packets;

Do some drivers initialize number_of_packets before calling usb_fill_iso_ur=
b()=20
(or rather usb_fill_int_urb() in the existing code) ? If not, you could ass=
ign=20
the field unconditionally, it would just be overwritten by drivers later.

> +	if (packet_size) {
> +		for (i =3D 0; i < packets; i++) {
> +			urb->iso_frame_desc[i].offset =3D packet_size * i;
> +			urb->iso_frame_desc[i].length =3D packet_size;
> +		}
> +	}

Same question here. Additionally, do you see use cases for calling this wit=
h=20
packets > 0 && packet_size =3D=3D 0 ? If not the for loop wouldn't iterate =
at all,=20
so the outer check wouldn't be needed.

With or without changes to the above, depending on the use cases,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> +}
> +
>  extern void usb_init_urb(struct urb *urb);
>  extern struct urb *usb_alloc_urb(int iso_packets, gfp_t mem_flags);
>  extern void usb_free_urb(struct urb *urb);

=2D-=20
Regards,

Laurent Pinchart
