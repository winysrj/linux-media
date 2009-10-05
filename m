Return-path: <linux-media-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:52072 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754939AbZJEVZD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Oct 2009 17:25:03 -0400
Date: Mon, 5 Oct 2009 23:24:22 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andy Walls <awalls@radix.net>
Cc: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>,
	Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org,
	Oldrich Jedlicka <oldium.pro@seznam.cz>, hverkuil@xs4all.nl
Subject: Re: [REVIEW] ivtv, ir-kbd-i2c: Explicit IR support for the AVerTV
 M116  for newer kernels
Message-ID: <20091005232422.37859b83@hyperion.delvare>
In-Reply-To: <1254687092.3148.108.camel@palomino.walls.org>
References: <1254584660.3169.25.camel@palomino.walls.org>
 <20091004105429.234acbc1@hyperion.delvare>
 <1254687092.3148.108.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

On Sun, 04 Oct 2009 16:11:32 -0400, Andy Walls wrote:
> On Sun, 2009-10-04 at 10:54 +0200, Jean Delvare wrote:
> > On Sat, 03 Oct 2009 11:44:20 -0400, Andy Walls wrote:
> > >  /* This array should match the IVTV_HW_ defines */
> > > @@ -126,7 +131,8 @@
> > >  	"wm8739",
> > >  	"vp27smpx",
> > >  	"m52790",
> > > -	NULL
> > > +	NULL,
> > > +	NULL		/* IVTV_HW_EM78P153S_IR_RX_AVER */
> > >  };
> > >  
> > >  /* This array should match the IVTV_HW_ defines */
> > > @@ -151,9 +157,38 @@
> > >  	"vp27smpx",
> > >  	"m52790",
> > >  	"gpio",
> > > +	"ir_rx_em78p153s_aver",
> > 
> > This exceeds the maximum length for I2C client names (19 chars max.) So
> > your patch won't work. I could make the name field slightly larger (say
> > 23 chars) if really needed, but I'd rather have you simply use shorter
> > names.
> 
> I'll use shorter names.  I was trying to be maintain some uniqueness.
> The bridge driver has the knowledge of the exact chip and nothing else
> does unless the bridge exposes it somehow.  It seemed like a good way to
> expose the knowledge.

The knowledge is already exposed through the platform data attached to
the instantiated i2c device (.ir_codes, .internal_get_key_func, .type
and .name). The i2c client name isn't used by the ir-kbd-i2c driver to
do anything useful.

> > > +static int ivtv_i2c_new_ir(struct i2c_adapter *adap, u32 hw, const char *type,
> > > +			   u8 addr)
> > > +{
> > > +	struct i2c_board_info info;
> > > +	unsigned short addr_list[2] = { addr, I2C_CLIENT_END };
> > > +
> > > +	memset(&info, 0, sizeof(struct i2c_board_info));
> > > +	strlcpy(info.type, type, I2C_NAME_SIZE);
> > > +
> > > +	/* Our default information for ir-kbd-i2c.c to use */
> > > +	switch (hw) {
> > > +	case IVTV_HW_EM78P153S_IR_RX_AVER:
> > > +		info.platform_data = (void *) &em78p153s_aver_ir_init_data;
> > 
> > Useless cast. You never need to cast to void *.
> 
> The compiler gripes because the "const" gets discarded; Mauro asked me
> to fix it in cx18 previously.  I could have cast it to the proper type,
> but then it wouldn't have fit in 80 columns.
> 
> (void *) wasn't "useless", it kept gcc, checkpatch, Mauro and me happy.
> Now I guess I'll have to break the assignment to be over two lines. :(

Ah, good point, I had missed it. Well basically this means that you're
not supposed to pass const data structures as platform data. So maybe
you'd rather follow the approach used in the saa7134 and em28xx drivers.

> > > --- a/linux/drivers/media/video/ir-kbd-i2c.c	Sat Oct 03 11:23:00 2009 -0400
> > > +++ b/linux/drivers/media/video/ir-kbd-i2c.c	Sat Oct 03 11:27:19 2009 -0400
> > > @@ -730,6 +730,7 @@
> > >  	{ "ir_video", 0 },
> > >  	/* IR device specific entries should be added here */
> > >  	{ "ir_rx_z8f0811_haup", 0 },
> > > +	{ "ir_rx_em78p153s_aver", 0 },
> > >  	{ }
> > >  };
> > >  
> > 
> > I think we need to discuss this. I don't really see the point of adding
> > new entries if the ir-kbd-i2c driver doesn't do anything about it. This
> > makes device probing slower with no benefit. As long as you pass device
> > information with all the details, the ir-kbd-i2c driver won't care
> > about the device name.
> 
> I though a matching name was required for ir-kbd-i2c to bind to the IR
> controller deivce.  I personally don't like the "ir_video" name as it is
> a bit too generic, but then again I don't know whwre that name is
> visible outside the kernel.  My plan was to have rather specific names,
> so LIRC in the future could know automatically how to handle some of
> these devices without the user trying to guess what an "ir_video" device
> was as that name supplied no information to LIRC or the user.

The name is visible in sysfs as the client's name attribute. But no
user-space application should rely on this. If a user-space application
should use a name string, that should be the _input_ name and not the
i2c client name. For the simple reason that IR devices don't have to be
I2C devices.

The i2c device name is merely used for device-driver matching. For this
purpose, "ir_video" works just fine. As I said before, there is a point
in defining other names if it allows the ir-kbd-i2c driver to make
decisions by itself, or if you envision to move support for a specific
device to a separate driver as some point. If not then you're making
things more complex with zero benefit.

I'd like to add that, IMHO, LIRC shouldn't have to care about this at
all. The name should be purely informative. I have experimented in the
past with user-space trying to do device-specific handling based on a
name string. This is what we did in libsensors 2. This ended up being a
totally unmaintainable mess, where each new kernel had to be followed
by updated user-space. This was a pain and you really shouldn't go in
this direction. For libsensors 3, we've defined a clean sysfs
interface, which describes the functionality of each supported device,
so the library doesn't do any name-driver processing. Very easy to
maintain.

So if you want a piece of advice: either handle all device-specific
things in the kernel, or in user-space, but don't do half in the kernel
and half in user-space, because you will have a horrible interface
in-between.

> > So the question is, where are we going with the ir-kbd-i2c driver? Are
> > we happy with the current model where bridge drivers pass IR device
> > information?
> 
> I think I would prever the brdige driver pass a v4l2_device object and
> then provide an internal API for ir-kbd-i2c to query.  (See below).
> 
> Maybe even better would for ir-kbd-i2c to iterate over all v4l_device
> objects in the system calling an interal IR API asking for information
> about any IR device that is a child of that v4l_device.

I am not too familiar with the v4l2 internals so I can't really comment
on this.

> >  Or do we want to move to a model where they just pass a
> > device name and ir-kbd-i2c maps names to device information? In the
> > latter case, it makes sense to have many i2c_device_id entries in
> > ir-kbd-i2c, but in the former case it doesn't.
> > 
> > I guess the answer depends in part on how common IR devices and remote
> > controls are across adapters. If the same IR device is used on many
> > adapters then it makes some sense to move the definitions into
> > ir-kbd-i2c.
> 
> That would be the case for the Z8F0811 loaded with firmware from
> Zilog/Hauppauge.  I'm not sure of any other device with a lot of
> commonality.  I would imagine that commonality would never cross vendor
> lines.
> 
> >  But if devices are heavily adapter-dependent, and moving
> > the definitions into ir-kbd-i2c doesn't allow for any code refactoring,
> > then I don't quite see the point.
> 
> My decisions are based on thinking on a larger scope than just
> ir-kbd-i2c:
> 
> 1. More than just I2C connected IR devices, but also GPIO IR and IR
> hardware like what is built into the CX2388x, CX2584x, and CX23418
> chips.
> 
> 2. More than just receivers, but also blasters.
> 
> 3. More than just ir-kbd-i2c as an input solution; i.e. LIRC.  My
> personal opinion is that ir-kbd-i2c and other v4l-dvb IR input handling
> is a basic solutuion.  It "teaches the bear to dance", but I'd like to
> "teach the bear to dance well".
> 
> 4. More flexible selection and support of remotes.  I want to be able to
> use any RC-5 remote with an adapter if necessary, not just the one that
> came with the adapter.   Some of the I2C microcontrollers may not allow
> this (maybe some do) due to the "address" in the RC-5 code.  GPIO and
> CX2388x etc. IR controllers certainly can handle the possibility of
> alternate remotes and alternate protocols like RC-6 Mode 6A used in MCE
> remotes.  
> 
> 5. I'd like to create a uniform interface for LIRC modules or any other
> kernel modules to access bridge driver provided IR via an internal API
> implemented in v4l2_device somehow.  (Just an idea with no real details
> yet.)
> 
> 
> 
> So after mentally working my way through all that, I guess I would like
> the details to move out of bridge drivers somewhat and into the modules
> that handle IR input and output: ir-kbd-i2c and LIRC modules.  In that
> case, the verbose names should give enough information for ir-kbd-i2c
> and LIRC to do something sensible.  I think it is appropriate for the
> bridge driver to provide hints about the default remote for a card.  I
> would prefer ir-kbd-i2c and/or LIRC call an API accessable with a bridge
> driver's v4l2_device to query for hints for the default remote or
> additional information.

This all goes well beyond the point I was initially attempting to
discuss. But you certainly have a much better vision of this area than
I do.

-- 
Jean Delvare
