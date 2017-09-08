Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:54493
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751654AbdIHLIS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Sep 2017 07:08:18 -0400
Date: Fri, 8 Sep 2017 08:08:06 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-i2c@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH v4 3/6] i2c: add docs to clarify DMA handling
Message-ID: <20170908080756.7d8d81d7@vento.lan>
In-Reply-To: <20170908085640.42wzzgd2s2roikyd@ninjato>
References: <20170817141449.23958-1-wsa+renesas@sang-engineering.com>
        <20170817141449.23958-4-wsa+renesas@sang-engineering.com>
        <20170827083748.248e2430@vento.lan>
        <20170908085640.42wzzgd2s2roikyd@ninjato>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 8 Sep 2017 10:56:40 +0200
Wolfram Sang <wsa@the-dreams.de> escreveu:

> Hi Mauro,
> 
> thanks for your comments. Much appreciated!
> 
> > There are also a couple of things here that Sphinx would complain.
> > So, it could be worth to rename it to *.rst, while you're writing
> > it, and see what:
> > 	make htmldocs
> > will complain and how it will look in html.  
> 
> OK, I'll check that.

Ok.

> > > +Given that I2C is a low-speed bus where largely small messages are transferred,
> > > +it is not considered a prime user of DMA access. At this time of writing, only
> > > +10% of I2C bus master drivers have DMA support implemented.  
> > 
> > Are you sure about that? I'd say that, on media, at least half of the
> > drivers use DMA for I2C bus access, as the I2C bus is on a remote
> > board that talks with CPU via USB, using DMA, and all communication
> > with USB should be DMA-safe.  
> 
> Well, the DMA-safe requirement comes then from the USB subsystem,
> doesn't it?

Yes, but the statistics that 10% of I2C bus master drivers
are DMA-safe is not true, if you take those into account ;-)

Perhaps you could write it as (or something similar):

	At this time of writing, only +10% of I2C bus master
	drivers for non-remote boards have DMA support implemented.  


> Or do you really use DMA on the remote board to transfer
> data via I2C to an I2C client?
> 
> > I guess what you really wanted to say on most of this section is
> > about SoC (and other CPUs) where the I2C bus master is is at the
> > mainboard, and not on some peripheral.  
> 
> I might be biased to that, yes. So, it is good talking about it.
> 
> > > And the vast
> > > +majority of transactions are so small that setting up DMA for it will likely
> > > +add more overhead than a plain PIO transfer.
> > > +
> > > +Therefore, it is *not* mandatory that the buffer of an I2C message is DMA safe.  
> > 
> > Again, that may not be true on media boards. The code that implements the
> > I2C transfers there, on most boards, have to be DMA safe, as it won't
> > otherwise send/receive commands from the chips that are after the USB
> > bridge.  
> 
> That still sounds to me like the DMA-safe requirement comes from USB
> (which is fine, of course.). In any case, a sentence like "Other
> subsystem you might use for bridging I2C might impose other DMA
> requirements" sounds like to nice to have.

Agreed.

> 
> > > +Drivers wishing to implement DMA can use helper functions from the I2C core.
> > > +One gives you a DMA-safe buffer for a given i2c_msg as long as a certain
> > > +threshold is met.
> > > +
> > > +	dma_buf = i2c_get_dma_safe_msg_buf(msg, threshold_in_byte);  
> > 
> > I'm concerned about the new bits added by this call. Right now,
> > USB drivers just use kalloc() for transfer buffers used to send and
> > receive URB control messages for both setting the main device and
> > for I2C messages. Before this changeset, buffers allocated this
> > way are DMA save and have been working for years.  
> 
> Can you give me a pointer to a driver doing this? I glimpsed around in
> drivers/media/usb and found that most drivers are having their i2c_msg
> buffers on the stack. Which is clearly not DMA-safe.

The way it is implemented depends on the driver, and usually envolves
double-buffering, e. g., on some place of the driver, a buffer that
may not be DMA-save is copied into a DMA safe buffer. 

On most cases, like on this driver:
	drivers/media/usb/dvb-usb-v2/az6007.c

The i2c_xfer logic (or the read/write functions) is the one responsible
for double-buffering.

In this specific example, the DVB usbv2 core allocates the device's "state"
struct using kmalloc (it uses .size_of_priv field to know the size of
the "state" buffer).

On struct az6007_device_state, there is a "data" buffer with 4096 bytes.

At the i2c transfer function, it retrieves and use it:

	struct az6007_device_state *st = d_to_priv(d)
...
	ret = __az6007_read(d->udev, req, value, index, st->data, length);
...
	ret =  __az6007_write(d->udev, req, value, index, st->data, length);


In the past, on lots of drivers, the i2c_xfer logic just used to assume
that the I2C client driver allocated a DMA-safe buffer, as it just used to
pass whatever buffer it receives directly to USB core. We did an effort to
change it, as it can be messy, but I'm not sure if this is solved everywhere.

The __az6007_read() and __az6007_write() indirectly do DMA (for most USB
host drivers), when they call usb_control_msg().

> 
> > When you add some flags that would make the I2C subsystem aware
> > that a buffer is now DMA safe, I guess you could be breaking
> > those drivers, as a DMA safe buffer will now be considered as
> > DMA-unsafe.  
> 
> Well, this flag is only relevant for i2c master drivers wishing to do
> DMA. So, grepping in the above directory
> 
> 	grep dma $(grep -rl i2c_add_adapter *)

The usage of I2C at the media subsystem predates the I2C subsystem.
at V4L2 drivers, a great effort was done to port it to fully use the
I2C subsystem when it was added upstream, but there were some problems
a the initial implementation of the i2c subsystem that prevented its
usage for the DVB drivers. By the time such restrictions got removed,
it was too late, as there were already a large amount of drivers relying
on i2c "low level" functions.

So, almost all DVB drivers don't use i2c_add_adapter(). Instead, the
I2C clients just call directly the I2C transfer functions:

	drivers/media/dvb-frontends/au8522_common.c:    ret = i2c_transfer(state->i2c, msg, 2);

> only gives one driver which is irrelevant because the i2c master it
> registers is not doing any DMA?

Even on the drivers that use i2c_add_adapter(), the usage of DMA can't
be get by the above grep, as the DMA usage is actually at drivers/usb.

For example, the em28xx driver uses i2c_add_adapter():

$ git grep i2c_add_adapter drivers/media/usb/em28xx/
drivers/media/usb/em28xx/em28xx-i2c.c:  retval = i2c_add_adapter(&dev->i2c_adap[bus]);
drivers/media/usb/em28xx/em28xx-i2c.c:                  "%s: i2c_add_adapter failed! retval [%d]\n",

And the actual data transfer happens via usb_control_msg():

$ git grep usb_control_msg drivers/media/usb/em28xx/
drivers/media/usb/em28xx/em28xx-core.c: ret = usb_control_msg(udev, pipe, req,
drivers/media/usb/em28xx/em28xx-core.c: ret = usb_control_msg(udev, pipe, req,

If you modify your grep function, you'll see that usb_control_msg()
is DMA-dependent. Try:

	$ grep dma $(grep -rl usb_control_msg) drivers/usb/core/

> Am I missing something? We are clearly not aligned yet...
> 
> Regards,
> 
>    Wolfram
> 

Thanks,
Mauro
