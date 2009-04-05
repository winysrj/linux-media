Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:40092 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755737AbZDEBwY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Apr 2009 21:52:24 -0400
Subject: Re: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding
	model
From: Andy Walls <awalls@radix.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mike Isely <isely@pobox.com>
In-Reply-To: <20090405005139.03ba18b5@hyperion.delvare>
References: <20090404142427.6e81f316@hyperion.delvare>
	 <20090404142837.3e12824c@hyperion.delvare>
	 <1238852529.2845.34.camel@morgan.walls.org>
	 <20090405005139.03ba18b5@hyperion.delvare>
Content-Type: text/plain
Date: Sat, 04 Apr 2009 21:50:08 -0400
Message-Id: <1238896208.2995.86.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-04-05 at 00:51 +0200, Jean Delvare wrote:
> Hi Andy,
> 
> On Sat, 04 Apr 2009 09:42:09 -0400, Andy Walls wrote:
> > On Sat, 2009-04-04 at 14:28 +0200, Jean Delvare wrote:
> > > Let card drivers probe for IR receiver devices and instantiate them if
> > > found. Ultimately it would be better if we could stop probing
> > > completely, but I suspect this won't be possible for all card types.
> > > 
> > > There's certainly room for cleanups. For example, some drivers are
> > > sharing I2C adapter IDs, so they also had to share the list of I2C
> > > addresses being probed for an IR receiver. Now that each driver
> > > explicitly says which addresses should be probed, maybe some addresses
> > > can be dropped from some drivers.
> > > 
> > > Also, the special cases in saa7134-i2c should probably be handled on a
> > > per-board basis. This would be more efficient and less risky than always
> > > probing extra addresses on all boards. I'll give it a try later.
> > > 
> > > Signed-off-by: Jean Delvare <khali@linux-fr.org>
> > > Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> > > Cc: Hans Verkuil <hverkuil@xs4all.nl>
> > > Cc: Andy Walls <awalls@radix.net>
> > > Cc: Mike Isely <isely@pobox.com>
> > > ---
> > >  linux/drivers/media/video/cx18/cx18-i2c.c            |   30 ++
> > >  linux/drivers/media/video/ivtv/ivtv-i2c.c            |   31 ++
> > >  linux/include/media/ir-kbd-i2c.h                     |    2 
> > >  17 files changed, 284 insertions(+), 196 deletions(-)
> > > 
> > 
> > > --- v4l-dvb.orig/linux/drivers/media/video/cx18/cx18-i2c.c	2009-04-04 10:53:15.000000000 +0200
> > > +++ v4l-dvb/linux/drivers/media/video/cx18/cx18-i2c.c	2009-04-04 10:58:36.000000000 +0200
> > > @@ -211,7 +211,32 @@ static struct i2c_algo_bit_data cx18_i2c
> > >  	.timeout	= CX18_ALGO_BIT_TIMEOUT*HZ /* jiffies */
> > >  };
> > >  
> > > -/* init + register i2c algo-bit adapter */
> > > +static void init_cx18_i2c_ir(struct cx18 *cx)
> > > +{
> > > +	struct i2c_board_info info;
> > > +	/* The external IR receiver is at i2c address 0x34 (0x35 for
> > > +	   reads).  Future Hauppauge cards will have an internal
> > > +	   receiver at 0x30 (0x31 for reads).  In theory, both can be
> > > +	   fitted, and Hauppauge suggest an external overrides an
> > > +	   internal.
> > > +
> > > +	   That's why we probe 0x1a (~0x34) first. CB
> > > +	*/
> > > +	const unsigned short addr_list[] = {
> > > +		0x1a, 0x18, 0x64, 0x30,
> > > +		I2C_CLIENT_END
> > > +	};
> > 
> > 
> > I think this is way out of date for cx18 based boards.  The only IR chip
> > I know of so far is the Zilog Z8F0811 sitting at 7 bit addresses
> > 0x70-0x74.  I guess 0x71 is the proper address for Rx.  I'll let you
> > know when I test.
> 
> This address list comes from the ir-kbd-i2c driver. The cx18 driver
> happens to use the same I2C adapter ID as the ivtv driver
> (I2C_HW_B_CX2341X) and this is what the ir-kbd-i2c driver used to
> decide which addresses to probe. As I don't know anything about the
> hardware, I had to keep the new code compatible with the old one and
> keep probing the same addresses.

This is the i2cdetect output from my HVR-1600 - the only cx18 based card
known or reported to have an IR chip:

[root@morgan ~]# i2cdetect -l
i2c-0	smbus     	SMBus PIIX4 adapter at 0b00     	SMBus adapter
i2c-1	i2c       	ivtv i2c driver #0              	I2C adapter
i2c-2	i2c       	cx18 i2c driver #0-0            	I2C adapter
i2c-3	i2c       	cx18 i2c driver #0-1            	I2C adapter
[root@morgan ~]# i2cdetect 2
WARNING! This program can confuse your I2C bus, cause data loss and worse!
I will probe file /dev/i2c-2.
I will probe address range 0x03-0x77.
Continue? [Y/n] y
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          -- -- -- -- -- -- -- -- -- -- -- -- -- 
10: -- -- -- -- -- -- -- -- -- 19 -- -- -- -- -- -- 
20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
40: -- -- -- -- -- -- -- -- -- -- -- -- UU -- -- -- 
50: 50 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
60: -- -- -- 63 -- -- -- -- -- -- -- -- -- -- -- -- 
70: 70 71 72 73 -- -- -- --                         
[root@morgan ~]# i2cdetect 3
WARNING! This program can confuse your I2C bus, cause data loss and worse!
I will probe file /dev/i2c-3.
I will probe address range 0x03-0x77.
Continue? [Y/n] y
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          -- -- -- -- -- -- -- -- -- -- -- -- -- 
10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
50: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
60: -- UU -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
70: -- -- -- -- -- -- -- --                         

The Zilog is at 0x70-0x73.  The standard IR Tx and RX addresses are 0x70
and 0x71


> Now, if you tell me that this list doesn't make sense for cx18 boards,
> we can change it.

I owe you the right address to probe.  I think it is 0x71, but I want to
double check.


>  As addresses 0x70-0x74 were not probed so far on cx18
> boards, I guess that IR support never worked for cx18 (at least not with
> ir-kbd-i2c)?

No, the lirc_i2c, lirc_pvr150, and lirc_zilog come in via the i2c
subsystem.



>  Does ir-kbd-i2c support the Zilog Z8F0811 at all?
> 
> If IR on the cx18 is not supported (by the ir-kbd-i2c driver) then I
> can simplify my patch set and omit the cx18 entirely.

The HVR-1600 could have been supported by ir-kbd-i2c.

It's submission was redirected slightly here:

http://lkml.org/lkml/2009/2/3/118

And deferred here:

http://www.spinics.net/lists/linux-media/msg03883.html

until your changes were done.

> > > +	memset(&info, 0, sizeof(struct i2c_board_info));
> > > +	strlcpy(info.type, "ir-kbd", I2C_NAME_SIZE);
> > > +
> > > +	/* The IR receiver device can be on either I2C bus */
> > > +	if (i2c_new_probed_device(&cx->i2c_adap[0], &info, addr_list))
> > > +		return;
> > > +	i2c_new_probed_device(&cx->i2c_adap[1], &info, addr_list);
> > > +}
> > > +
> > > +/* init + register i2c adapters + instantiate IR receiver */
> > >  int init_cx18_i2c(struct cx18 *cx)
> > >  {
> > >  	int i, err;
> > > @@ -279,6 +304,9 @@ int init_cx18_i2c(struct cx18 *cx)
> > >  	err = i2c_bit_add_bus(&cx->i2c_adap[1]);
> > >  	if (err)
> > >  		goto err_del_bus_0;
> > > +
> > > +	/* Instantiate the IR receiver device, if present */
> > > +	init_cx18_i2c_ir(cx);
> > >  	return 0;
> > 
> > I have an I2C related question.  If the cx18 or ivtv driver autoloads
> > "ir-kbd-i2c" and registers an I2C client on the bus, does that preclude
> > lirc_i2c, lirc_pvr150 or lirc_zilog from using the device?  LIRC users
> > may notice, if it does.
> 
> I don't know anything about lirc_i2c, lirc_pvr150 or lirc_zilog. I tend
> to ignore all the code that is neither in the Linux kernel tree nor in
> the v4l-dvb tree.

lirc_pvr150 has always been out of kernel and likely always will be.
lirc_i2c and lirc_zilog, the stripped down version of lirc_pvr150, was
submitted by Janne and Jarrod:

http://lkml.org/lkml/2008/9/9/19

I do not know if it any of the lirc drivers made it in.  There were lots
of comments.  

>  If you want me to answer this question, you'll have
> to tell me what exactly these drivers are doing as far as I2C is
> concerned. Do they instantiate I2C clients? Or do they do raw I2C
> transfers? Do they check for address business before they do? On what
> basis do they attach to I2C devices?

Let me point you to the lirc_i2c.c file and I think you'll understand it
faster than I could explain it. Here it is in Jarrod's patch submission:

http://lkml.org/lkml/2008/9/9/3

Essentially, it 

1. loads a bunch of bridge chip modules
2. creates and adds I2C driver
3. for every adapter that tries to "attach" the driver
	a. checks the i2c hw id
	b. probes a list of possible addresses based on the id



> Please note that my conversion doesn't actually change anything to the
> autoloading of the ir-kbd-i2c driver. The bridge drivers which were
> loading ir-kbd-i2c (saa7134, cx23885, em28xx and cx88) still are. Those
> which were not, still aren't. The ir-kbd-i2c driver doesn't include a
> MODULE_ALIAS call as most I2C drivers do, to prevent udev from loading
> this driver automatically.
> 
> What my conversion changes is that an "ir-kbd" I2C device may be
> instantiated if a probe is successful. This will make the address in
> question show as busy (except to i2c-dev which only considers an
> address as busy when a driver is bound to the device.) But that's about
> it.

OK.  I didn't quite grok if the "ir-kbd" in i2c_new_probed_device() call
would load the driver module or not.  Tying up the address and making it
unavailable for lirc modules is my concern.


> > If that is the case, then we probably shouldn't autoload the ir-kbd
> > module after the CX23418 i2c adapters are initialized.  
> > 
> > I'm not sure what's the best solution:
> > 
> > 1. A module option to the cx18 driver to tell it to call
> > init_cx18_i2c_ir() from cx18_probe() or not? (Easiest solution)
> 
> Sounds perfectly sensible. I seem to remember that Hans Verkuil told me
> he wanted something like this for ivtv. As a matter of fact, the
> saa7134, em28xx and cx231xx already have such a module parameter
> (disable_ir). Implementing the same for bttv, cx88, cx18, ivtv or any
> other driver should be fairly trivial.

Yes it's the most expedient thing to do.


> > 2. Some involved programmatic way for IR device modules to query bridge
> > drivers about what IR devices they may have, and on which I2C bus, and
> > at what addresses to probe, and whether a driver/module has already
> > claimed that device? (Gold plated solution)
> 
> I'd rather name this the over-engineered solution. It's really looking
> at the situation by the wrong end (that is, with the legacy i2c binding
> model still in mind.) Bridge drivers know which IR receivers can be
> present and at which address, it is up to them to instantiate the
> appropriate I2C devices on the bus, possibly with platform data to help
> the I2C drivers (be they ir-kbd-i2c, lirc or whatever.) This is exactly
> what my code does.
> 
> The fact that the same IR chip can be handled by 2 or more I2C drivers
> is a bad idea to start with. Why the hell did we do that in the first
> place? 

Accident of history?  IR receive vs. IR blast/transmit?  Why do we have
ir-kbd-i2c.c trying to handle a laundry list of devices (somewhat like
tvaudio)?

User space apps such as MythTV and mplayer have specific support for
LIRC.  I guess LIRC's user space components abstract away a lot of the
differences of various IR transmitters, receivers and remote controls to
make things easier for application writers.  Someone with an
infradead.org email address can probably speak to LIRC's strengths and
weaknesses better than I.


I was wondering why we had ir-kbd-i2c. :)  Mark Lord did say, in one of
his posts to get the HVR-1600 support in ir-kbd-i2c, he didn't want the
LIRC bloat for what he needed.
  

> If you want a clean solution to the problem, it clearly starts
> with getting rid of this mess and having each IR receiver chip on I2C
> supported by exactly one I2C driver and make sure the driver in
> question is in the Linux kernel tree. Spending time on any other "clean
> solution" is wasting time IMHO.

Makes sense to me.


> 
> Still, note that it is totally possible to have several I2C drivers
> support the same device. The new model supports this, just like the old
> model did. I2C devices are instantiated by bridge drivers, which give
> them a _name_. Several I2C drivers are allowed to support that chip
> name, and the first one loaded will get to bind to the device. The
> "ir-i2c" devices created by cx18, ivtv etc. can be requested by other
> drivers than ir-kbd-i2c if you want to do that.

Yes.  OK.  That's the part I didn't understand.

So a hypothetical kernel ir-haup-zilog-i2c.ko module would look for
devices with a name of "haup-zilog-ir", right?  And the i2c adapter #
and address can be used to differentiate different instances of the chip
with the same name, so names don't have to be unique?  Am I correct in
my understanding?


>  This will require some
> changes to lirc_i2c and friends, but at this point changes to these are
> very needed anyway.

Yes, it looks like LIRC's kernel space components that use I2C may get
broken with upcoming I2C subsystem changes.


> I hope I managed to clarify the situation a bit.

A bit.  I'm not totally clear, but once I play with it a little, I'll
probably get it.

Regards,
Andy


