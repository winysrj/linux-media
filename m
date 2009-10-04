Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:58361 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757869AbZJDUKQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Oct 2009 16:10:16 -0400
Subject: Re: [REVIEW] ivtv, ir-kbd-i2c: Explicit IR support for the AVerTV
 M116  for newer kernels
From: Andy Walls <awalls@radix.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>,
	Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org,
	Oldrich Jedlicka <oldium.pro@seznam.cz>, hverkuil@xs4all.nl
In-Reply-To: <20091004105429.234acbc1@hyperion.delvare>
References: <1254584660.3169.25.camel@palomino.walls.org>
	 <20091004105429.234acbc1@hyperion.delvare>
Content-Type: text/plain
Date: Sun, 04 Oct 2009 16:11:32 -0400
Message-Id: <1254687092.3148.108.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-10-04 at 10:54 +0200, Jean Delvare wrote:
> Hi Andy,
> 
> On Sat, 03 Oct 2009 11:44:20 -0400, Andy Walls wrote:
> > Aleksandr and Jean,

> > Change 01/03 actually fixes a problem I inadvertantly let slip by for
> > ivtv in newer kernels, because I missed it in my initial review.  In
> > ivtv, we should really only do IR chip probing after all other known I2C
> > devices on a card are registered.
> 
> Conceptually this sounds totally right, indeed. I think this could even
> be improved, by skipping IR device probing altogether if a known IR
> device has already instantiated. Something like:
> 
> #define IVTV_HW_IR_ANY	(IVTV_HW_EM78P153S_IR_RX_AVER)

Yes, I was planning on defining something like this in the long run.


> 	/* probe for legacy IR controllers that aren't in card definitions */
> 	if (!(ivtv->card->hw_all & IVTV_HW_IR_ANY))
> 		ivtv_i2c_new_ir_legacy(itv);

But I hadn't thought about doing that: good idea.

> Comments on the code itself:
> 
> Patch #1:
> 
> > --- a/linux/drivers/media/video/ivtv/ivtv-i2c.c	Sat Sep 26 13:45:03 2009 -0300
> > +++ b/linux/drivers/media/video/ivtv/ivtv-i2c.c	Sat Oct 03 10:28:55 2009 -0400
> > @@ -153,6 +153,45 @@
> >  	"gpio",
> >  };
> >  
> > +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 30)
> > +/* Instantiate the IR receiver device using probing -- undesirable */
> > +int ivtv_i2c_new_ir_legacy(struct ivtv *itv)
> > +{
> > +	struct i2c_board_info info;
> > +	/*
> > +	 * The external IR receiver is at i2c address 0x34.
> > +	 * The internal IR receiver is at i2c address 0x30.
> > +	 *
> > +	 * In theory, both can be fitted, and Hauppauge suggests an external
> > +	 * overrides an internal.  That's why we probe 0x1a (~0x34) first. CB
> > +	 *
> > +	 * Some of these addresses we probe may collide with other i2c address
> > +	 * allocations, so this function must be called after all other i2c
> > +	 * devices we care about are registered.
> > +	 */
> > +	const unsigned short addr_list[] = {
> > +		0x1a,	/* Hauppauge IR external - collides with WM8739 */
> > +		0x18,	/* Hauppauge IR internal */
> > +		0x71,	/* Hauppauge IR (PVR150) */
> > +		0x64,	/* Pixelview IR */
> > +		0x30,	/* KNC ONE IR */
> > +		0x6b,	/* Adaptec IR */
> > +		I2C_CLIENT_END
> > +	};
> > +
> > +	memset(&info, 0, sizeof(struct i2c_board_info));
> > +	strlcpy(info.type, "ir_video", I2C_NAME_SIZE);
> > +	return i2c_new_probed_device(&itv->i2c_adap, &info, addr_list) == NULL
> > +								       ? -1 : 0;
> 
> Why don't you just return the i2c client instead? This is less work,
> and you don't use the returned value currently anyway.

I can, but I have no real use for that value either.  What you see here
was a variation of something I did in the cx18 driver.

Honestly I'd like to wrap all these i2C IR controller's into a
v4l2_subdev upon detection and start treating them that way.  (I have
not thought through the step to get there though.)  Ultimately I'd like
access to any type of IR controller device within the bridge drivers to
be through a v4l2_subdev.  Then the bridge drivers can present a more
uniform interface to IR controllers to other modules via a v4l2_device
interface.  Big plans, little time...


> > +}
> > +#else
> > +int ivtv_i2c_new_ir_legacy(struct ivtv *itv)
> > +{
> > +	/* ir-kbd-i2c does the legacy I2C IR controller probe for old kernels*/
> 
> Missing space before end of comment.

80 character limit.  Still readable.  But it's moot since I move the
comment in a later change where I have more characters on a line, so I
can fix it.  (I wonder if I did fix it...?)


> > +	return -1;
> > +}
> > +#endif
> > +
> >  int ivtv_i2c_register(struct ivtv *itv, unsigned idx)
> >  {
> >  	struct v4l2_subdev *sd;


> Patch #2:
> 
> > # HG changeset patch
> > # User Andy Walls <awalls@radix.net>
> > # Date 1254583380 14400
> > # Node ID 0127ed2ea55b215cc17660a698a19ac990117a46
> > # Parent  3d243437f04695220d92a0e906f287968e56d328
> > ivtv: Add explicit IR controller initialization for the AVerTV M116
> > 
> > From: Andy Walls <awalls@radix.net>
> > 
> > Priority: normal
> > 
> > Signed-off-by: Andy Walls <awalls@radix.net>
> > 
> > --- a/linux/drivers/media/video/ivtv/ivtv-cards.c	Sat Oct 03 10:28:55 2009 -0400
> > +++ b/linux/drivers/media/video/ivtv/ivtv-cards.c	Sat Oct 03 11:23:00 2009 -0400
> > @@ -955,7 +955,8 @@
> >  	.hw_video = IVTV_HW_CX25840,
> >  	.hw_audio = IVTV_HW_CX25840,
> >  	.hw_audio_ctrl = IVTV_HW_CX25840,
> > -	.hw_all = IVTV_HW_CX25840 | IVTV_HW_TUNER | IVTV_HW_WM8739,
> > +	.hw_all = IVTV_HW_CX25840 | IVTV_HW_TUNER | IVTV_HW_WM8739 |
> > +		  IVTV_HW_EM78P153S_IR_RX_AVER,
> >  	.video_inputs = {
> >  		{ IVTV_CARD_INPUT_VID_TUNER,  0, CX25840_COMPOSITE2 },
> >  		{ IVTV_CARD_INPUT_SVIDEO1,    1, CX25840_SVIDEO3    },
> > --- a/linux/drivers/media/video/ivtv/ivtv-cards.h	Sat Oct 03 10:28:55 2009 -0400
> > +++ b/linux/drivers/media/video/ivtv/ivtv-cards.h	Sat Oct 03 11:23:00 2009 -0400
> > @@ -87,23 +87,24 @@
> >  #define IVTV_PCI_ID_GOTVIEW1		0xffac
> >  #define IVTV_PCI_ID_GOTVIEW2 		0xffad
> >  
> > -/* hardware flags, no gaps allowed, IVTV_HW_GPIO must always be last */
> > -#define IVTV_HW_CX25840   (1 << 0)
> > -#define IVTV_HW_SAA7115   (1 << 1)
> > -#define IVTV_HW_SAA7127   (1 << 2)
> > -#define IVTV_HW_MSP34XX   (1 << 3)
> > -#define IVTV_HW_TUNER     (1 << 4)
> > -#define IVTV_HW_WM8775    (1 << 5)
> > -#define IVTV_HW_CS53L32A  (1 << 6)
> > -#define IVTV_HW_TVEEPROM  (1 << 7)
> > -#define IVTV_HW_SAA7114   (1 << 8)
> > -#define IVTV_HW_UPD64031A (1 << 9)
> > -#define IVTV_HW_UPD6408X  (1 << 10)
> > -#define IVTV_HW_SAA717X   (1 << 11)
> > -#define IVTV_HW_WM8739    (1 << 12)
> > -#define IVTV_HW_VP27SMPX  (1 << 13)
> > -#define IVTV_HW_M52790    (1 << 14)
> > -#define IVTV_HW_GPIO      (1 << 15)
> > +/* hardware flags, no gaps allowed */
> > +#define IVTV_HW_CX25840			(1 << 0)
> > +#define IVTV_HW_SAA7115			(1 << 1)
> > +#define IVTV_HW_SAA7127			(1 << 2)
> > +#define IVTV_HW_MSP34XX			(1 << 3)
> > +#define IVTV_HW_TUNER			(1 << 4)
> > +#define IVTV_HW_WM8775			(1 << 5)
> > +#define IVTV_HW_CS53L32A		(1 << 6)
> > +#define IVTV_HW_TVEEPROM		(1 << 7)
> > +#define IVTV_HW_SAA7114			(1 << 8)
> > +#define IVTV_HW_UPD64031A		(1 << 9)
> > +#define IVTV_HW_UPD6408X		(1 << 10)
> > +#define IVTV_HW_SAA717X			(1 << 11)
> > +#define IVTV_HW_WM8739			(1 << 12)
> > +#define IVTV_HW_VP27SMPX		(1 << 13)
> > +#define IVTV_HW_M52790			(1 << 14)
> > +#define IVTV_HW_GPIO			(1 << 15)
> > +#define IVTV_HW_EM78P153S_IR_RX_AVER	(1 << 16)
> >  
> >  #define IVTV_HW_SAA711X   (IVTV_HW_SAA7115 | IVTV_HW_SAA7114)
> >  
> > --- a/linux/drivers/media/video/ivtv/ivtv-i2c.c	Sat Oct 03 10:28:55 2009 -0400
> > +++ b/linux/drivers/media/video/ivtv/ivtv-i2c.c	Sat Oct 03 11:23:00 2009 -0400
> > @@ -63,6 +63,9 @@
> >  #include "ivtv-cards.h"
> >  #include "ivtv-gpio.h"
> >  #include "ivtv-i2c.h"
> > +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 30)
> > +#include <media/ir-kbd-i2c.h>
> > +#endif
> >  
> >  /* i2c implementation for cx23415/6 chip, ivtv project.
> >   * Author: Kevin Thayer (nufan_wfk at yahoo.com)
> > @@ -88,6 +91,7 @@
> >  #define IVTV_UPD64083_I2C_ADDR 		0x5c
> >  #define IVTV_VP27SMPX_I2C_ADDR      	0x5b
> >  #define IVTV_M52790_I2C_ADDR      	0x48
> > +#define IVTV_EM78P153S_IR_RX_I2C_ADDR	0x40
> >  
> >  /* This array should match the IVTV_HW_ defines */
> >  static const u8 hw_addrs[] = {
> > @@ -106,7 +110,8 @@
> >  	IVTV_WM8739_I2C_ADDR,
> >  	IVTV_VP27SMPX_I2C_ADDR,
> >  	IVTV_M52790_I2C_ADDR,
> > -	0 		/* IVTV_HW_GPIO dummy driver ID */
> > +	0,				/* IVTV_HW_GPIO dummy driver ID */
> > +	IVTV_EM78P153S_IR_RX_I2C_ADDR	/* IVTV_HW_EM78P153S_IR_RX_AVER */
> >  };
> 
> I suspect Hans put the GPIO at the end on purpose, I'm not sure why you
> want to change this? It makes your patch slightly larger.

I hate relying on implcit ordering and implicit positional markers.  I
checked the reasons why GPIO had to be last, and there was only one
reason left in the ivtv code: a redundant sanity check on the compiled
in arrays when starting up the ivtv modules.

Previously, I believe there were other reasons why it had to be last,
but Hans' changes over time have gradually phased out those requirements
if I am remembering things correctly.



> >  
> >  /* This array should match the IVTV_HW_ defines */
> > @@ -126,7 +131,8 @@
> >  	"wm8739",
> >  	"vp27smpx",
> >  	"m52790",
> > -	NULL
> > +	NULL,
> > +	NULL		/* IVTV_HW_EM78P153S_IR_RX_AVER */
> >  };
> >  
> >  /* This array should match the IVTV_HW_ defines */
> > @@ -151,9 +157,38 @@
> >  	"vp27smpx",
> >  	"m52790",
> >  	"gpio",
> > +	"ir_rx_em78p153s_aver",
> 
> This exceeds the maximum length for I2C client names (19 chars max.) So
> your patch won't work. I could make the name field slightly larger (say
> 23 chars) if really needed, but I'd rather have you simply use shorter
> names.

I'll use shorter names.  I was trying to be maintain some uniqueness.
The bridge driver has the knowledge of the exact chip and nothing else
does unless the bridge exposes it somehow.  It seemed like a good way to
expose the knowledge.


> >  };
> >  
> >  #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 30)
> > +static const struct IR_i2c_init_data em78p153s_aver_ir_init_data = {
> > +	.ir_codes = &ir_codes_avermedia_cardbus_table,
> > +	.internal_get_key_func = IR_KBD_GET_KEY_AVERMEDIA_CARDBUS,
> > +	.type = IR_TYPE_OTHER,
> > +	.name = "ivtv-CX23416 EM78P153S AVerMedia",
> > +};
> > +
> > +static int ivtv_i2c_new_ir(struct i2c_adapter *adap, u32 hw, const char *type,
> > +			   u8 addr)
> > +{
> > +	struct i2c_board_info info;
> > +	unsigned short addr_list[2] = { addr, I2C_CLIENT_END };
> > +
> > +	memset(&info, 0, sizeof(struct i2c_board_info));
> > +	strlcpy(info.type, type, I2C_NAME_SIZE);
> > +
> > +	/* Our default information for ir-kbd-i2c.c to use */
> > +	switch (hw) {
> > +	case IVTV_HW_EM78P153S_IR_RX_AVER:
> > +		info.platform_data = (void *) &em78p153s_aver_ir_init_data;
> 
> Useless cast. You never need to cast to void *.

The compiler gripes because the "const" gets discarded; Mauro asked me
to fix it in cx18 previously.  I could have cast it to the proper type,
but then it wouldn't have fit in 80 columns.

(void *) wasn't "useless", it kept gcc, checkpatch, Mauro and me happy.
Now I guess I'll have to break the assignment to be over two lines. :(



> > +		break;
> > +	default:
> > +		break;
> 
> Useless statement.

True.


> > +	}
> > +
> > +	return i2c_new_probed_device(adap, &info, addr_list) == NULL ? -1 : 0;
> 
> I don't really get why you use i2c_new_probed_device() instead of the
> cheaper i2c_new_device(). Are you not 100% certain that the IR device
> is present on this model?

I cut and paste from cx18 for the HVR-1600.  There the IR controller may
be present or not depending on HVR-1600 vs HVR-1600MCE so probing made
sense.

I have no idea about the AverTV M116.

I know the PVR-150 vs. PVR-150MCE supported by ivtv has the same
situation as the HVR-1600 under cx18.  Eventually I'll use this function
for the PVR-150 models as well.



> > +}
> > +
> >  /* Instantiate the IR receiver device using probing -- undesirable */
> >  int ivtv_i2c_new_ir_legacy(struct ivtv *itv)
> >  {
> > @@ -185,9 +220,15 @@
> >  								       ? -1 : 0;
> >  }
> >  #else
> > +/* ir-kbd-i2c does the legacy I2C IR controller probe for old kernels*/
> 
> Missing space at end of comment.

I'll fix it.

> > +static int ivtv_i2c_new_ir(struct i2c_adapter *adap, u32 hw, const char *type,
> > +			   u8 addr)
> > +{
> > +	return -1;
> > +}
> > +
> >  int ivtv_i2c_new_ir_legacy(struct ivtv *itv)
> >  {
> > -	/* ir-kbd-i2c does the legacy I2C IR controller probe for old kernels*/
> >  	return -1;
> >  }
> >  #endif
> > @@ -221,8 +262,15 @@
> >  			sd->grp_id = 1 << idx;
> >  		return sd ? 0 : -1;
> >  	}
> > +
> > +	if (hw & IVTV_HW_EM78P153S_IR_RX_AVER)
> 
> Maybe use IVTV_HW_IR_ANY as I defined earlier? Otherwise you'll have to
> modify the code with each new remote control you add.

Good idea.



> > +		return ivtv_i2c_new_ir(adap, hw, type, hw_addrs[idx]);
> > +
> > +	/* Is it not an I2C device or one we do not wish to register? */
> >  	if (!hw_addrs[idx])
> >  		return -1;
> > +
> > +	/* It's an I2C device other than an analog tuner or IR chip */
> >  	if (hw == IVTV_HW_UPD64031A || hw == IVTV_HW_UPD6408X) {
> >  		sd = v4l2_i2c_new_subdev(&itv->v4l2_dev,
> >  				adap, mod, type, 0, I2C_ADDRS(hw_addrs[idx]));
> 
> Patch #3.
> 
> > --- a/linux/drivers/media/video/ir-kbd-i2c.c	Sat Oct 03 11:23:00 2009 -0400
> > +++ b/linux/drivers/media/video/ir-kbd-i2c.c	Sat Oct 03 11:27:19 2009 -0400
> > @@ -730,6 +730,7 @@
> >  	{ "ir_video", 0 },
> >  	/* IR device specific entries should be added here */
> >  	{ "ir_rx_z8f0811_haup", 0 },
> > +	{ "ir_rx_em78p153s_aver", 0 },
> >  	{ }
> >  };
> >  
> 
> I think we need to discuss this. I don't really see the point of adding
> new entries if the ir-kbd-i2c driver doesn't do anything about it. This
> makes device probing slower with no benefit. As long as you pass device
> information with all the details, the ir-kbd-i2c driver won't care
> about the device name.

I though a matching name was required for ir-kbd-i2c to bind to the IR
controller deivce.  I personally don't like the "ir_video" name as it is
a bit too generic, but then again I don't know whwre that name is
visible outside the kernel.  My plan was to have rather specific names,
so LIRC in the future could know automatically how to handle some of
these devices without the user trying to guess what an "ir_video" device
was as that name supplied no information to LIRC or the user.


> So the question is, where are we going with the ir-kbd-i2c driver? Are
> we happy with the current model where bridge drivers pass IR device
> information?

I think I would prever the brdige driver pass a v4l2_device object and
then provide an internal API for ir-kbd-i2c to query.  (See below).

Maybe even better would for ir-kbd-i2c to iterate over all v4l_device
objects in the system calling an interal IR API asking for information
about any IR device that is a child of that v4l_device.


>  Or do we want to move to a model where they just pass a
> device name and ir-kbd-i2c maps names to device information? In the
> latter case, it makes sense to have many i2c_device_id entries in
> ir-kbd-i2c, but in the former case it doesn't.
> 
> I guess the answer depends in part on how common IR devices and remote
> controls are across adapters. If the same IR device is used on many
> adapters then it makes some sense to move the definitions into
> ir-kbd-i2c.

That would be the case for the Z8F0811 loaded with firmware from
Zilog/Hauppauge.  I'm not sure of any other device with a lot of
commonality.  I would imagine that commonality would never cross vendor
lines.

>  But if devices are heavily adapter-dependent, and moving
> the definitions into ir-kbd-i2c doesn't allow for any code refactoring,
> then I don't quite see the point.

My decisions are based on thinking on a larger scope than just
ir-kbd-i2c:

1. More than just I2C connected IR devices, but also GPIO IR and IR
hardware like what is built into the CX2388x, CX2584x, and CX23418
chips.

2. More than just receivers, but also blasters.

3. More than just ir-kbd-i2c as an input solution; i.e. LIRC.  My
personal opinion is that ir-kbd-i2c and other v4l-dvb IR input handling
is a basic solutuion.  It "teaches the bear to dance", but I'd like to
"teach the bear to dance well".

4. More flexible selection and support of remotes.  I want to be able to
use any RC-5 remote with an adapter if necessary, not just the one that
came with the adapter.   Some of the I2C microcontrollers may not allow
this (maybe some do) due to the "address" in the RC-5 code.  GPIO and
CX2388x etc. IR controllers certainly can handle the possibility of
alternate remotes and alternate protocols like RC-6 Mode 6A used in MCE
remotes.  

5. I'd like to create a uniform interface for LIRC modules or any other
kernel modules to access bridge driver provided IR via an internal API
implemented in v4l2_device somehow.  (Just an idea with no real details
yet.)



So after mentally working my way through all that, I guess I would like
the details to move out of bridge drivers somewhat and into the modules
that handle IR input and output: ir-kbd-i2c and LIRC modules.  In that
case, the verbose names should give enough information for ir-kbd-i2c
and LIRC to do something sensible.  I think it is appropriate for the
bridge driver to provide hints about the default remote for a card.  I
would prefer ir-kbd-i2c and/or LIRC call an API accessable with a bridge
driver's v4l2_device to query for hints for the default remote or
additional information.

Right now the bridge drivers are essentially fixing the remote and
protocol used for a card.

Those are just my thoughts and ramblings.

Thanks very much for the review and comments.


Regards,
Andy

