Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:48633 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371AbcGANWX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Jul 2016 09:22:23 -0400
Date: Fri, 1 Jul 2016 14:22:19 +0100
From: Sean Young <sean@mess.org>
To: Andi Shyti <andi.shyti@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Andi Shyti <andi@etezian.org>
Subject: Re: [PATCH] [media] rc: ir-spi: add support for IR LEDs connected
 with SPI
Message-ID: <20160701132219.GA3752@gofer.mess.org>
References: <1467362022-12704-1-git-send-email-andi.shyti@samsung.com>
 <CGME20160701094505epcas1p469fb8084bd5195cdab5555a9f3368682@epcas1p4.samsung.com>
 <20160701094458.GA8933@gofer.mess.org>
 <20160701123035.GA12029@samsunx.samsung>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160701123035.GA12029@samsunx.samsung>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 01, 2016 at 09:30:35PM +0900, Andi Shyti wrote:
> Hi Sean,
> 
> > > The ir-spi is a simple device driver which supports the
> > > connection between an IR LED and the MOSI line of an SPI device.
> > > 
> > > The driver, indeed, uses the SPI framework to stream the raw data
> > > provided by userspace through a character device. The chardev is
> > > handled by the LIRC framework and its functionality basically
> > > provides:
> > > 
> > >  - raw write: data to be sent to the SPI and then streamed to the
> > >    MOSI line;
> > >  - set frequency: sets the frequency whith which the data should
> > >    be sent;
> > >  - set length: sets the data length. This information is
> > >    optional, if the length is set, then userspace should send raw
> > >    data only with that length; while if the length is set to '0',
> > >    then the driver will figure out himself the length of the data
> > >    based on the length of the data written on the character
> > >    device.
> > >    The latter is not recommended, though, as the driver, at
> > >    any write, allocates and deallocates a buffer where the data
> > >    from userspace are stored.
> > > 
> > > The driver provides three feedback commands:
> > > 
> > >  - get length: reads the length set and (as mentioned), if the
> > >    length is '0' it will be calculated at any write
> > >  - get frequency: the driver reports the frequency. If userpace
> > >    doesn't set the frequency, the driver will use a default value
> > >    of 38000Hz.
> > 
> > This interface is not compatible with other lirc devices; there is no
> > way of determining whether this is a regular lirc device or this new
> > flavour you've invented.
> 
> except of the set length and get length which I'm using a bit
> freely because I am dealing with devices that exchange always the
> same amount of data, so that I don't need (in my case) to
> pre-allocate or overallocate or runtime allocate. I don't
> understand what else I invented :)

Other than the LIRC_{GET,SET}_LENGTH it might very well be compatible;
you're reusing LIRC_GET_LENGTH for a different purpose.

Is the kmalloc() really that costly that it needs to be avoided for
each transmit?

> This is a simple driver which is driving an LED connected through
> SPI and userspace writes raw data in it (LIRC_CAN_SEND_RAW).

And some odd ioctl.

> > Also I don't see what justifies this new interface. This can be 
> > implemented in rc-core in less lines of code and it will be entirely 
> > compatible with existing user-space.
> 
> Also here I'm getting a bit confused. When I started writing
> this, I didn't even know of the existence of a remote controlling
> framework, but then I run across this:
> 
> "LIRC is a package that allows you to decode and send infra-red
> signals of many (but not all) commonly used remote controls. "
> 
> taken from lirc.org: my case is exactly falling into this
> description.
> 
> Am I missing anything?

See drivers/staging/media/lirc/TODO: "All drivers should either be 
ported to ir-core, or dropped entirely".  ir-core has since been renamed 
to rc-core; it is uses for non-IR purposes like cec.

lirc exists as the user-space ABI but not it is not the preferred 
framework for kernel space.

There is one problem here. rc-core does not provide very well for
transmit-only hardware, so rc-core needs some modifications. This is
what I suggest to make it work:

1. in include/media/rc-core.h add a new entry to the enum rc_driver_type
   called "RC_DRIVER_IR_RAW_TX_ONLY" (or something like that).
2. rc_allocate_device() needs an argument "enum rc_driver_type"; in the
   case it would not allocate an input device. All drivers needs to
   pass in this argument.
3. rc_register_device() and rc_unregister_device() should not execute
   anything with to do with input devices or key maps for tx only
   devices.
4. ir_lirc_register() should not set the LIRC_CAN_REC_MODE2 feature
   or allocate an input buffer in the case of TX only device.

With these changes all you need to do in ir-spi is:

	struct rc_dev *rc = rc_allocate_device(RC_DRIVER_IR_RAW_TX_ONLY);
	strcpy(rc->name, "IR SPI");
        rc->s_tx_carrier = ir_spi_set_tx_carrier; // write function
        rc->tx_ir = ir_spi_tx; // write function
        rc->driver_name = "ir-spi";

	rc_register_driver(rc);


I'm happy to help. 


Sean
