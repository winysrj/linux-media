Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.horus.com ([78.46.148.228]:51570 "EHLO mail.horus.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750949AbeEMLeR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 May 2018 07:34:17 -0400
Date: Sun, 13 May 2018 13:34:14 +0200
From: Matthias Reichl <hias@horus.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 7/7] media: rc: mceusb: allow the timeout to be
 configurable
Message-ID: <20180513113414.l3y5ztpuscv5yy4m@camel2.lan>
References: <02b5dac3b27169c6e6a4a070a2569b33fef47bbe.1523221902.git.sean@mess.org>
 <20180417191457.fhgsdega2kjqw3t2@camel2.lan>
 <20180418112428.zk3lmdxoqv46weph@gofer.mess.org>
 <20180418174229.jurjnyqbtkyctjvb@camel2.lan>
 <20180419221723.s6kx7nip6ue2d43o@camel2.lan>
 <20180421131852.2zrn7qp3ir4kyqvf@camel2.lan>
 <20180421174121.xcztgoaw2pspj3zv@camel2.lan>
 <20180507155455.tvp3unvvk4a5kn6d@camel2.lan>
 <20180509214442.wcusgrvxpygqbe62@gofer.mess.org>
 <20180510110134.eaqsbsh7xlugs7uh@camel2.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180510110134.eaqsbsh7xlugs7uh@camel2.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,

On Thu, May 10, 2018 at 01:01:34PM +0200, Matthias Reichl wrote:
> On Wed, May 09, 2018 at 10:44:42PM +0100, Sean Young wrote:
> > On Mon, May 07, 2018 at 05:54:55PM +0200, Matthias Reichl wrote:
> > > The original reporter gave up before I could get enough info
> > > to understand what's going on, but now another user with an identical
> > > receiver and the same problems showed up and I could get debug logs.
> > > 
> > > FYI: I've uploaded the full dmesg here if you need more info
> > > or I snipped off too much:
> > > http://www.horus.com/~hias/tmp/mceusb-settimeout-issue.txt
> > > 
> > > Here's the info about the IR receiver:
> > > [    2.208684] usb 1-1.3: New USB device found, idVendor=1784, idProduct=0011
> > > [    2.208699] usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> > > [    2.208708] usb 1-1.3: Product: eHome Infrared Transceiver
> > > [    2.208716] usb 1-1.3: Manufacturer: Topseed Technology Corp.
> > > [    2.208724] usb 1-1.3: SerialNumber: EID0137AG-8-0000104054
> >
> > I think that is correct. For this mceusb device, we should add a quirk
> > which disables the setting of a timeout.
> > 
> > I do wonder if this could work in a slightly different way. Since the
> > device sends out space information before the timeout (every ~6ms), rather
> > than relying on setting a timeout on the device, we could rely on a 
> > software timeout handler. It would not be able to set timeouts > 100ms
> > but we're mostly not interested in that anyway.
> 
> Ah, this is a very good idea!
> 
> I had thought about a quirk to use that device in the old, fixed 100ms,
> timeout mode but if we can do <= 100ms in software it's a far
> better and elegant solution.
> 
> The patch looks fine to me, I'll add it to our builds and see if
> I can get some feedback on it.

The user with the Topseed remote reported back, your patch fixed
the issue - thanks a lot!

so long,

Hias

> > Here is a patch which hopefully solves it.
> > 
> > Thank you!
> > 
> > Sean
> > 
> > >>From 075e1567851ebe3e9d36b30f436c9468fd8772a8 Mon Sep 17 00:00:00 2001
> > From: Sean Young <sean@mess.org>
> > Date: Wed, 9 May 2018 11:11:28 +0100
> > Subject: [PATCH] media: mceusb: MCE_CMD_SETIRTIMEOUT cause strange behaviour
> >  on device
> > 
> > If the IR timeout is set on vid 1784 pid 0011, the device starts
> > behaving strangely.
> > 
> > Reported-by: Matthias Reichl <hias@horus.com>
> > Signed-off-by: Sean Young <sean@mess.org>
> > ---
> >  drivers/media/rc/mceusb.c | 22 +++++++++++++++++++---
> >  1 file changed, 19 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
> > index 5c0bf61fae26..1619b748469b 100644
> > --- a/drivers/media/rc/mceusb.c
> > +++ b/drivers/media/rc/mceusb.c
> > @@ -181,6 +181,7 @@ enum mceusb_model_type {
> >  	MCE_GEN2 = 0,		/* Most boards */
> >  	MCE_GEN1,
> >  	MCE_GEN3,
> > +	MCE_GEN3_BROKEN_IRTIMEOUT,
> >  	MCE_GEN2_TX_INV,
> >  	MCE_GEN2_TX_INV_RX_GOOD,
> >  	POLARIS_EVK,
> > @@ -199,6 +200,7 @@ struct mceusb_model {
> >  	u32 mce_gen3:1;
> >  	u32 tx_mask_normal:1;
> >  	u32 no_tx:1;
> > +	u32 broken_irtimeout:1;
> >  	/*
> >  	 * 2nd IR receiver (short-range, wideband) for learning mode:
> >  	 *     0, absent 2nd receiver (rx2)
> > @@ -242,6 +244,12 @@ static const struct mceusb_model mceusb_model[] = {
> >  		.tx_mask_normal = 1,
> >  		.rx2 = 2,
> >  	},
> > +	[MCE_GEN3_BROKEN_IRTIMEOUT] = {
> > +		.mce_gen3 = 1,
> > +		.tx_mask_normal = 1,
> > +		.rx2 = 2,
> > +		.broken_irtimeout = 1
> > +	},
> >  	[POLARIS_EVK] = {
> >  		/*
> >  		 * In fact, the EVK is shipped without
> > @@ -352,7 +360,7 @@ static const struct usb_device_id mceusb_dev_table[] = {
> >  	  .driver_info = MCE_GEN2_TX_INV },
> >  	/* Topseed eHome Infrared Transceiver */
> >  	{ USB_DEVICE(VENDOR_TOPSEED, 0x0011),
> > -	  .driver_info = MCE_GEN3 },
> > +	  .driver_info = MCE_GEN3_BROKEN_IRTIMEOUT },
> >  	/* Ricavision internal Infrared Transceiver */
> >  	{ USB_DEVICE(VENDOR_RICAVISION, 0x0010) },
> >  	/* Itron ione Libra Q-11 */
> > @@ -1441,8 +1449,16 @@ static struct rc_dev *mceusb_init_rc_dev(struct mceusb_dev *ir)
> >  	rc->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
> >  	rc->min_timeout = US_TO_NS(MCE_TIME_UNIT);
> >  	rc->timeout = MS_TO_NS(100);
> > -	rc->max_timeout = 10 * IR_DEFAULT_TIMEOUT;
> > -	rc->s_timeout = mceusb_set_timeout;
> > +	if (!mceusb_model[ir->model].broken_irtimeout) {
> > +		rc->s_timeout = mceusb_set_timeout;
> > +		rc->max_timeout = 10 * IR_DEFAULT_TIMEOUT;
> > +	} else {
> > +		/*
> > +		 * If we can't set the timeout using CMD_SETIRTIMEOUT, we can
> > +		 * rely on software timeouts for timeouts < 100ms.
> > +		 */
> > +		rc->max_timeout = rc->timeout;
> > +	}
> >  	if (!ir->flags.no_tx) {
> >  		rc->s_tx_mask = mceusb_set_tx_mask;
> >  		rc->s_tx_carrier = mceusb_set_tx_carrier;
> > -- 
> > 2.14.3
> > 
