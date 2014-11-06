Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:39789 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbaKFNVR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Nov 2014 08:21:17 -0500
Date: Thu, 6 Nov 2014 13:21:13 +0000
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Jarod Wilson <jwilson@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>,
	linux-media@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: staging: media: lirc: lirc_zilog.c: replace custom print macros
 with dev_* and pr_*
Message-ID: <20141106132113.GA1367@gofer.mess.org>
References: <20141031130600.GA16310@mwanda>
 <20141031142644.GA4166@localhost.localdomain>
 <20141031143541.GM6890@mwanda>
 <20141106124629.GA898@gofer.mess.org>
 <20141106110549.1812acc7@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141106110549.1812acc7@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 06, 2014 at 11:05:49AM -0200, Mauro Carvalho Chehab wrote:
> Hi Sean,
> 
> Em Thu, 06 Nov 2014 12:46:29 +0000
> Sean Young <sean@mess.org> escreveu:
> 
> > On Fri, Oct 31, 2014 at 05:35:41PM +0300, Dan Carpenter wrote:
> > > On Fri, Oct 31, 2014 at 04:26:45PM +0200, Aya Mahfouz wrote:
> > > > On Fri, Oct 31, 2014 at 04:06:00PM +0300, Dan Carpenter wrote:
> > > > > drivers/staging/media/lirc/lirc_zilog.c
> > > > >   1333  /* Close the IR device */
> > > > >   1334  static int close(struct inode *node, struct file *filep)
> > > > >   1335  {
> > > > >   1336          /* find our IR struct */
> > > > >   1337          struct IR *ir = filep->private_data;
> > > > >   1338  
> > > > >   1339          if (ir == NULL) {
> > > > >                     ^^^^^^^^^^
> > > > >   1340                  dev_err(ir->l.dev, "close: no private_data attached to the file!\n");
> > > > >                                 ^^^^^^^^^
> > > > > 
> > > > > I suggest you just delete the error message.  Can "ir" actually be NULL
> > > > > here anyway?
> > > > >
> > > > 
> > > > Since I'm a newbie and this is not my code, I prefer to use pr_err().
> > > 
> > > This driver doesn't belong to anyone.  Go ahead and take ownership.  The
> > > message is fairly worthless and no one will miss it.
> > 
> > Speaking of ownership, what this driver really needs is to be ported to 
> > rc-core. In order to do this it'll need to be able to send raw IR rather
> > key codes; I've been peering at the firmware but it neither looks like
> > zilog z8 opcodes nor space/pulse information.
> 
> Actually, I think that all features provided by this driver were already
> migrated into the ir-kbd-i2c (drivers/media/i2c/ir-kbd-i2c.c) driver.

All the features for the IR receiver are implemented (very nicely) in
ir-kbd-i2c (the ir_rx_z8f0811_haup and ir_rx_z8f0811_hdpvr i2c drivers).

However the IR emitter (i2c driver ir_tx_z8f0811_haup and 
ir_tx_z8f0811_hdpvr) are not implemented there. I wanted to port the 
IR emitter but the driver can only send specific rc5 (IIRC) keycodes, not
raw IR. So I cannot port it.

> Andy and Jarod worked on this conversion, but we decided, on that time,
> to keep lirc_zilog for a while (can't remember why).
> 
> Andy/Jarod,
> 
> What's the status of the ir-kbd-i2c with regards to Zilog z8 support?

Transmitter side.

> > Does anyone have any contacts at Hauppauge who could help with this?
> 
> Probably, it won't be easy to get someone there that worked on it,
> as this device is too old.
> 
> Anyway, if are there anything still pending, I may be able to get
> some contacts at the vendor.

That would be great, I have hardware and I'm happy to re-write the
driver.

Thanks

Sean
