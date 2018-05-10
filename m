Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.horus.com ([78.46.148.228]:51571 "EHLO mail.horus.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757094AbeEJLBi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 May 2018 07:01:38 -0400
Date: Thu, 10 May 2018 13:01:35 +0200
From: Matthias Reichl <hias@horus.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 7/7] media: rc: mceusb: allow the timeout to be
 configurable
Message-ID: <20180510110134.eaqsbsh7xlugs7uh@camel2.lan>
References: <cover.1523221902.git.sean@mess.org>
 <02b5dac3b27169c6e6a4a070a2569b33fef47bbe.1523221902.git.sean@mess.org>
 <20180417191457.fhgsdega2kjqw3t2@camel2.lan>
 <20180418112428.zk3lmdxoqv46weph@gofer.mess.org>
 <20180418174229.jurjnyqbtkyctjvb@camel2.lan>
 <20180419221723.s6kx7nip6ue2d43o@camel2.lan>
 <20180421131852.2zrn7qp3ir4kyqvf@camel2.lan>
 <20180421174121.xcztgoaw2pspj3zv@camel2.lan>
 <20180507155455.tvp3unvvk4a5kn6d@camel2.lan>
 <20180509214442.wcusgrvxpygqbe62@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180509214442.wcusgrvxpygqbe62@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean!

On Wed, May 09, 2018 at 10:44:42PM +0100, Sean Young wrote:
> Hi Hias,
> 
> On Mon, May 07, 2018 at 05:54:55PM +0200, Matthias Reichl wrote:
> > Hi Sean!
> > 
> > [ I trimmed the Cc list, as this is mceusb specific ]
> > 
> > On Sat, Apr 21, 2018 at 07:41:21PM +0200, Matthias Reichl wrote:
> > > On Sat, Apr 21, 2018 at 03:18:52PM +0200, Matthias Reichl wrote:
> > > > Another bug report came in, button press results in multiple
> > > > key down/up events
> > > > https://forum.kodi.tv/showthread.php?tid=298461&pid=2727837#pid2727837
> > > > (and following posts).
> > 
> > The original reporter gave up before I could get enough info
> > to understand what's going on, but now another user with an identical
> > receiver and the same problems showed up and I could get debug logs.
> > 
> > FYI: I've uploaded the full dmesg here if you need more info
> > or I snipped off too much:
> > http://www.horus.com/~hias/tmp/mceusb-settimeout-issue.txt
> > 
> > Here's the info about the IR receiver:
> > [    2.208684] usb 1-1.3: New USB device found, idVendor=1784, idProduct=0011
> > [    2.208699] usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> > [    2.208708] usb 1-1.3: Product: eHome Infrared Transceiver
> > [    2.208716] usb 1-1.3: Manufacturer: Topseed Technology Corp.
> > [    2.208724] usb 1-1.3: SerialNumber: EID0137AG-8-0000104054
> > 
> > With timeout configuration in the mceusb driver disabled everything
> > works fine. But with timeout configuration enabled spurious "keyup"
> > events show up during a button press and sometimes also a spurious
> > "ghost" keypress several seconds after the original button press.
> > 
> > Here's the ir-keytable -t output to illustrate the behaviour:
> > 
> > 80.385585: event type EV_MSC(0x04): scancode = 0x800f0422
> > 80.385585: event type EV_KEY(0x01) key_down: KEY_OK(0x0160)
> > 80.385585: event type EV_SYN(0x00).
> > 80.492469: event type EV_MSC(0x04): scancode = 0x800f0422
> > 80.492469: event type EV_SYN(0x00).
> > 80.633371: event type EV_KEY(0x01) key_up: KEY_OK(0x0160)
> > 80.633371: event type EV_SYN(0x00).
> > 80.642478: event type EV_MSC(0x04): scancode = 0x800f0422
> > 80.642478: event type EV_KEY(0x01) key_down: KEY_OK(0x0160)
> > 80.642478: event type EV_SYN(0x00).
> > 80.783375: event type EV_KEY(0x01) key_up: KEY_OK(0x0160)
> > 80.783375: event type EV_SYN(0x00).
> > 84.318011: event type EV_MSC(0x04): scancode = 0x800f0422
> > 84.318011: event type EV_KEY(0x01) key_down: KEY_OK(0x0160)
> > 84.318011: event type EV_SYN(0x00).
> > 84.460049: event type EV_KEY(0x01) key_up: KEY_OK(0x0160)
> > 84.460049: event type EV_SYN(0x00).
> > 
> > >From the kernel log the first 2 scancodes are perfectly fine,
> > we get the timeout space in chunks, followed by the "End of raw IR data"
> > message and the scancode is properly decoded. Then about 45ms later
> > the pulses of the following IR message come in.
> > 
> > Snippet from end of second scancode:
> > 
> > [   80.505896] mceusb 1-1.3:1.0: rx data: 81 7f (length=2)
> 
> I've been staring at these logs for days now. :)

You are not the only one :-)

> So here, 0x81 means one
> byte of IR data, which is 0x7f. For each byte of IR data, if the high 
> bit is set (so value >= 0x80) it is a pulse, else space. The remaining
> 7 bits denote the length of the pulse or space, times 50us. So here
> we have 127 * 50 = 6350us space.
> 
> > [   80.505902] mceusb 1-1.3:1.0: Raw IR data, 1 pulse/space samples
> > [   80.505907] mceusb 1-1.3:1.0: Storing space with duration 6350000
> > [   80.505911] mceusb 1-1.3:1.0: processed IR data
> > [   80.506894] mceusb 1-1.3:1.0: rx data: 81 05 (length=2)
> > [   80.506899] mceusb 1-1.3:1.0: Raw IR data, 1 pulse/space samples
> > [   80.506904] mceusb 1-1.3:1.0: Storing space with duration 250000
> 
> 5 * 50 us = 250us space
> 
> > [   80.506908] rc rc0: enter idle mode
> > [   80.506913] rc rc0: sample: (25650us space)
> > [   80.506918] mceusb 1-1.3:1.0: rx data: 80 (length=1)
> 
> So the 80 here is the byte which marks the timeout.

Yes. More specifically, it's the "IR Data End" message / command,
as mentioned on page 130 of the "Green Button" pdf.

> > [   80.506922] mceusb 1-1.3:1.0: End of raw IR data
> > [   80.506925] mceusb 1-1.3:1.0: processed IR data
> > [   80.506943] rc rc0: RC6 decode started at state 6 (25650us space)
> > [   80.506949] rc rc0: RC6 decode started at state 8 (25650us space)
> > [   80.506955] rc rc0: RC6(6A) proto 0x0013, scancode 0x800f0422 (toggle: 1)
> > [   80.506961] rc rc0: Media Center Ed. eHome Infrared Remote Transceiver (1784:0011): scancode 0x800f0422 keycode 0x160
> > [   80.552906] mceusb 1-1.3:1.0: rx data: 81 b5 (length=2)
> > [   80.552914] mceusb 1-1.3:1.0: Raw IR data, 1 pulse/space samples
> > [   80.552919] mceusb 1-1.3:1.0: Storing pulse with duration 2650000
> > [   80.552924] rc rc0: leave idle mode
> > 
> > But then, the end of the third scancode gets interesting. The
> > last chunk of the timeout space is missing and instead we get
> > a combined message with the remaining space and a zero-length
> > pulse just before the fourth IR message starts. Of course, this is
> > too late and the keyup timer had already expired:
> > 
> > [   80.612896] mceusb 1-1.3:1.0: rx data: 81 7f (length=2)
> > [   80.612903] mceusb 1-1.3:1.0: Raw IR data, 1 pulse/space samples
> > [   80.612908] mceusb 1-1.3:1.0: Storing space with duration 6350000
> > [   80.612912] mceusb 1-1.3:1.0: processed IR data
> > [   80.647880] rc rc0: keyup key 0x0160
> > [   80.656901] mceusb 1-1.3:1.0: rx data: 82 05 80 (length=3)
> 
> Here some is wrong. We have 2 bytes. The first one is 5 * 50 space, followed
> by 0x80. First thing to observe is that we are are expecting a timeout
> message here, but that would should be encoded as: 81 05 80 (so 1 byte
> message of pulse/space follow by a new message.
> 
> Since 80 is interpreted as pulse/space (not timeout marker) we end up
> with a pulse of length 0.
> 
> > [   80.656908] mceusb 1-1.3:1.0: Raw IR data, 2 pulse/space samples
> > [   80.656913] mceusb 1-1.3:1.0: Storing space with duration 250000
> > [   80.656918] rc rc0: enter idle mode
> > [   80.656923] rc rc0: sample: (25650us space)
> > [   80.656928] mceusb 1-1.3:1.0: Storing pulse with duration 0
> 
> See here pulse with duration 0. Which is invalid IR and really shouldn't
> be generated by the driver.
> 
> Now, we could add some code that if 0x80 is encountered in pulse/space
> irdata, then we see this as a timeout. However, ...
> 
> > [   80.656931] rc rc0: leave idle mode
> > [   80.656935] mceusb 1-1.3:1.0: processed IR data
> > [   80.656967] rc rc0: RC6 decode started at state 6 (25650us space)
> > [   80.656973] rc rc0: RC6 decode started at state 8 (25650us space)
> > [   80.656979] rc rc0: RC6(6A) proto 0x0013, scancode 0x800f0422 (toggle: 1)
> > [   80.656986] rc rc0: Media Center Ed. eHome Infrared Remote Transceiver (1784:0011): scancode 0x800f0422 keycode 0x160
> > [   80.656998] rc rc0: Media Center Ed. eHome Infrared Remote Transceiver (1784:0011): key down event, key 0x0160, protocol 0x0013, scancode 0x800f0422
> > [   80.659900] mceusb 1-1.3:1.0: rx data: 81 b6 (length=2)
> > [   80.659908] mceusb 1-1.3:1.0: Raw IR data, 1 pulse/space samples
> > [   80.659913] mceusb 1-1.3:1.0: Storing pulse with duration 2700000
> > [   80.659916] mceusb 1-1.3:1.0: processed IR data
> > 
> > A similar thing happened on the fourth IR message, a spurious pulse
> > picked up by the IR receiver about 4 seconds after the message seems
> > to have made it send out it's data and flush the decoder:
> > 
> > [   80.719899] mceusb 1-1.3:1.0: rx data: 81 7f (length=2)
> > [   80.719905] mceusb 1-1.3:1.0: Raw IR data, 1 pulse/space samples
> > [   80.719910] mceusb 1-1.3:1.0: Storing space with duration 6350000
> > [   80.719914] mceusb 1-1.3:1.0: processed IR data
> > [   80.797908] rc rc0: keyup key 0x0160
> > [   84.332919] mceusb 1-1.3:1.0: rx data: 83 05 80 81 (length=4)
> 
> This is looking very strange. We have 3 bytes; 250us space, timeout,
> and then 50us pulse. The 250us space and timeout are about 4 seconds
> late (the previous 4x6350us space were received much earlier, so the 
> remainder of space before the timeout should have been sent much sooner.

I don't think we should interpret 0x80 IR data as an IR data end /
timeout message. The binary value is the same, but we got it in
the context of an IR data message.

The "Green Button" pdf mentions durations have to be in the range
1-127. I haven't found a description how IR data with duration 0
should be handled, so I think we should treat IR data values 0x00
and 0x80 as illegal / undefined values.

We could add a check for duration 0 to mceusb_process_ir_data()
and then ignore such pluses/spaces, but I'm not sure if that could
cause any side effects so maybe better keep that code as is
and store pulses/space with duration 0.

> > [   84.332934] mceusb 1-1.3:1.0: Raw IR data, 3 pulse/space samples
> > [   84.332944] mceusb 1-1.3:1.0: Storing space with duration 250000
> > [   84.332954] rc rc0: enter idle mode
> > [   84.332964] rc rc0: sample: (25650us space)
> > [   84.332973] mceusb 1-1.3:1.0: Storing pulse with duration 0
> > [   84.332981] rc rc0: leave idle mode
> > [   84.332989] mceusb 1-1.3:1.0: Storing pulse with duration 50000
> > [   84.332997] mceusb 1-1.3:1.0: processed IR data
> > [   84.333046] rc rc0: RC6 decode started at state 6 (25650us space)
> > [   84.333057] rc rc0: RC6 decode started at state 8 (25650us space)
> > [   84.333068] rc rc0: RC6(6A) proto 0x0013, scancode 0x800f0422 (toggle: 1)
> > [   84.333080] rc rc0: Media Center Ed. eHome Infrared Remote Transceiver (1784:0011): scanco
> > de 0x800f0422 keycode 0x160
> > [   84.333098] rc rc0: Media Center Ed. eHome Infrared Remote Transceiver (1784:0011): key do
> > wn event, key 0x0160, protocol 0x0013, scancode 0x800f0422
> > [   84.339912] mceusb 1-1.3:1.0: rx data: 81 7f (length=2)
> > [   84.339925] mceusb 1-1.3:1.0: Raw IR data, 1 pulse/space samples
> > [   84.339934] mceusb 1-1.3:1.0: Storing space with duration 6350000
> > [   84.339944] rc rc0: sample: (00050us pulse)
> > [   84.339952] mceusb 1-1.3:1.0: processed IR data
> > [   84.339994] rc rc0: RC6 decode failed at state 0 (50us pulse)
> > [   84.345908] mceusb 1-1.3:1.0: rx data: 81 7f (length=2)
> > [   84.345918] mceusb 1-1.3:1.0: Raw IR data, 1 pulse/space samples
> > [   84.345927] mceusb 1-1.3:1.0: Storing space with duration 6350000
> > [   84.345935] mceusb 1-1.3:1.0: processed IR data
> > 
> > We have both rc-6 and NEC protocol enabled and the timeout is
> > therefore auto-configured to 25650us. I'm wondering if this could
> > have something to do with the odd behaviour as we'll get a very
> > short 250us space message from the IR receiver (in addition to
> > the 4 6350us spaces). Maybe this triggers some bug in the IR
> > receiver?
> 
> I think that is correct. For this mceusb device, we should add a quirk
> which disables the setting of a timeout.
> 
> I do wonder if this could work in a slightly different way. Since the
> device sends out space information before the timeout (every ~6ms), rather
> than relying on setting a timeout on the device, we could rely on a 
> software timeout handler. It would not be able to set timeouts > 100ms
> but we're mostly not interested in that anyway.

Ah, this is a very good idea!

I had thought about a quirk to use that device in the old, fixed 100ms,
timeout mode but if we can do <= 100ms in software it's a far
better and elegant solution.

The patch looks fine to me, I'll add it to our builds and see if
I can get some feedback on it.

so long & thanks a lot,

Hias

> > As we saw those issues on RPi, where USB has always been a bit
> > problematic, I wouldn't rule that out as a possible cause as well.
> > 
> > I've asked the reporter to test with various other timeout values,
> > this should hopefully provide some more info.
> > 
> > so long,
> > 
> > Hias
> 
> Here is a patch which hopefully solves it.
> 
> Thank you!
> 
> Sean
> 
> >>From 075e1567851ebe3e9d36b30f436c9468fd8772a8 Mon Sep 17 00:00:00 2001
> From: Sean Young <sean@mess.org>
> Date: Wed, 9 May 2018 11:11:28 +0100
> Subject: [PATCH] media: mceusb: MCE_CMD_SETIRTIMEOUT cause strange behaviour
>  on device
> 
> If the IR timeout is set on vid 1784 pid 0011, the device starts
> behaving strangely.
> 
> Reported-by: Matthias Reichl <hias@horus.com>
> Signed-off-by: Sean Young <sean@mess.org>
> ---
>  drivers/media/rc/mceusb.c | 22 +++++++++++++++++++---
>  1 file changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
> index 5c0bf61fae26..1619b748469b 100644
> --- a/drivers/media/rc/mceusb.c
> +++ b/drivers/media/rc/mceusb.c
> @@ -181,6 +181,7 @@ enum mceusb_model_type {
>  	MCE_GEN2 = 0,		/* Most boards */
>  	MCE_GEN1,
>  	MCE_GEN3,
> +	MCE_GEN3_BROKEN_IRTIMEOUT,
>  	MCE_GEN2_TX_INV,
>  	MCE_GEN2_TX_INV_RX_GOOD,
>  	POLARIS_EVK,
> @@ -199,6 +200,7 @@ struct mceusb_model {
>  	u32 mce_gen3:1;
>  	u32 tx_mask_normal:1;
>  	u32 no_tx:1;
> +	u32 broken_irtimeout:1;
>  	/*
>  	 * 2nd IR receiver (short-range, wideband) for learning mode:
>  	 *     0, absent 2nd receiver (rx2)
> @@ -242,6 +244,12 @@ static const struct mceusb_model mceusb_model[] = {
>  		.tx_mask_normal = 1,
>  		.rx2 = 2,
>  	},
> +	[MCE_GEN3_BROKEN_IRTIMEOUT] = {
> +		.mce_gen3 = 1,
> +		.tx_mask_normal = 1,
> +		.rx2 = 2,
> +		.broken_irtimeout = 1
> +	},
>  	[POLARIS_EVK] = {
>  		/*
>  		 * In fact, the EVK is shipped without
> @@ -352,7 +360,7 @@ static const struct usb_device_id mceusb_dev_table[] = {
>  	  .driver_info = MCE_GEN2_TX_INV },
>  	/* Topseed eHome Infrared Transceiver */
>  	{ USB_DEVICE(VENDOR_TOPSEED, 0x0011),
> -	  .driver_info = MCE_GEN3 },
> +	  .driver_info = MCE_GEN3_BROKEN_IRTIMEOUT },
>  	/* Ricavision internal Infrared Transceiver */
>  	{ USB_DEVICE(VENDOR_RICAVISION, 0x0010) },
>  	/* Itron ione Libra Q-11 */
> @@ -1441,8 +1449,16 @@ static struct rc_dev *mceusb_init_rc_dev(struct mceusb_dev *ir)
>  	rc->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
>  	rc->min_timeout = US_TO_NS(MCE_TIME_UNIT);
>  	rc->timeout = MS_TO_NS(100);
> -	rc->max_timeout = 10 * IR_DEFAULT_TIMEOUT;
> -	rc->s_timeout = mceusb_set_timeout;
> +	if (!mceusb_model[ir->model].broken_irtimeout) {
> +		rc->s_timeout = mceusb_set_timeout;
> +		rc->max_timeout = 10 * IR_DEFAULT_TIMEOUT;
> +	} else {
> +		/*
> +		 * If we can't set the timeout using CMD_SETIRTIMEOUT, we can
> +		 * rely on software timeouts for timeouts < 100ms.
> +		 */
> +		rc->max_timeout = rc->timeout;
> +	}
>  	if (!ir->flags.no_tx) {
>  		rc->s_tx_mask = mceusb_set_tx_mask;
>  		rc->s_tx_carrier = mceusb_set_tx_carrier;
> -- 
> 2.14.3
> 
