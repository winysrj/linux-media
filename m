Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39869 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbZDFMcI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Apr 2009 08:32:08 -0400
Date: Mon, 6 Apr 2009 09:31:42 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Mike Isely <isely@pobox.com>
Cc: isely@isely.net, Andy Walls <awalls@radix.net>,
	hermann pitton <hermann-pitton@arcor.de>,
	Jean Delvare <khali@linux-fr.org>, Janne Grunau <j@jannau.net>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	LMML <linux-media@vger.kernel.org>,
	Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding
 model
Message-ID: <20090406093142.6ac946be@pedra.chehab.org>
In-Reply-To: <Pine.LNX.4.64.0904052104010.2076@cnc.isely.net>
References: <20090404142427.6e81f316@hyperion.delvare>
	<Pine.LNX.4.64.0904041045380.32720@cnc.isely.net>
	<20090405010539.187e6268@hyperion.delvare>
	<200904050746.47451.hverkuil@xs4all.nl>
	<20090405143748.GC10556@aniel>
	<1238953174.3337.12.camel@morgan.walls.org>
	<20090405183154.GE10556@aniel>
	<1238957897.3337.50.camel@morgan.walls.org>
	<20090405222250.64ed67ae@hyperion.delvare>
	<1238966523.6627.63.camel@pc07.localdom.local>
	<1238968804.4647.22.camel@morgan.walls.org>
	<20090405225102.531a2075@pedra.chehab.org>
	<Pine.LNX.4.64.0904052104010.2076@cnc.isely.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 5 Apr 2009 21:52:31 -0500 (CDT)
Mike Isely <isely@isely.net> wrote:

> On Sun, 5 Apr 2009, Mauro Carvalho Chehab wrote:
> 
> > On Sun, 05 Apr 2009 18:00:04 -0400
> > Andy Walls <awalls@radix.net> wrote:
> > 
> > > On Sun, 2009-04-05 at 23:22 +0200, hermann pitton wrote:
> > > > Am Sonntag, den 05.04.2009, 22:22 +0200 schrieb Jean Delvare:
> > > > > On Sun, 05 Apr 2009 14:58:17 -0400, Andy Walls wrote:
> > > 
> > > 
> > > > What can not be translated to the input system I would like to know.
> > > > Andy seems to have closer looked into that.
> > > 
> > > 1. IR blasting: sending IR codes to transmit out to a cable convertor
> > > box, DTV to analog convertor box, or similar devices to change channels
> > > before recording starts.  An input interface doesn't work well for
> > > output.
> > 
> > On my understanding, IR output is a separate issue. AFAIK, only a very few ivtv
> > devices support IR output. I'm not sure how this is currently implemented.
> 
> For the pvrusb2 driver, MCE style 24xxx devices (2nd generation 24xxx) 
> and HVR-1950 devices have IR blasting capabilities.  At the moment, 
> people have gotten this to work on the 24xxx model with the appropriate 
> lirc driver.  In theory it should be doable for HVR-1950 as well (and 
> the pvrusb2 does what is needed to make it possible) but I don't think 
> anyone has succeeded there yet.
> 
> Sure IR output as a concept and interface is a separate issue.  But it 
> can be implemented in the same chip (which is the case in the two 
> examples I list above).  So the issue is not separate; it must be dealt 
> with as a whole.  Two drivers implementing different features but trying 
> to share one chip is just not fun.

Yes, this should be considered by the same driver, but perhaps not using the
same userspace API. I'm not sure if event interface allows such usage.

> > If the driver processes correctly the IR samples, I don't see why you would
> > need to pass the raw protocols to userspace. Maybe we need to add some ioctls
> > at the API to allow certain controls, like, for example, ask kernel to decode
> > IR using RC4 instead or RC5, on devices that supports more than one IR protocol.
> 
> Ugh.  Why should v4l-dvb get into this business when it's already solved 
> somewhere else?  In userspace even.
> 
> I see in so many other places people arguing for V4L functionality that 
> needs to be kicked out of the kernel and put into userspace.  For 
> example, there's all that silliness over pixel formats that I'm soon 
> going to have to deal with...

Removing kernel functionality breaks compatibility with legacy applications.


> Yet in this case with IR, there already exists a subsystem that does 
> *more* than ir-kbd-i2c.c, AND it does all the crazy configuration / 
> control in userspace - and yet you argue that ir-kbd-i2c.c should be 
> preferred?  Purely because lirc is not in-tree?  

Setting up lirc to work it is a way more complex that just plugging a
device and having IR working. For all my usages here, I prefer to just load a
different IR table than having to deal with lirc configuration stuff.

It should be users option to use lirc or just rely on the existing IR support.

> Well heck, lirc should be in-tree.  Let's help them get there and forget ever having to deal 
> with IR again ourselves.  Let them do it.

I agree that we should help with this. IMO, the proper way for lirc drivers for
media devices is that they should include linux-media oh the discussions about
the inclusion of those drivers, in a way that just one driver would be used,
and that the event interface will keep working by default, as currently.

> I just looked at this.  I freely admit I haven't noticed this before, 
> but having looked at it now, and having examined ir-kbd-i2c.c, I still 
> don't see the whole picture here:
> 
> 1. The switch statement in ir-kbd-i2c.c:ir_attach() is apparently 
> implicitly trying to assume a particular type of remote based on the I2C 
> address of the IR receiver it's talking to.  Yuck.  That's really not 
> right at all.  The IR receiver used does not automatically mean which 
> remote is used.  What if the vendor switches remotes?  That's happened 
> with the PVR-USB2 hardware in the past (based on photos I've seen).  
> Who's to say the next remote to be supplied is compatible?

This is the legacy model, kept there only due to the fact that we don't really
know with 100% sure what boards were using those functions. For the new model,
you should take a look on a bridge driver, like, for example, on em28xx-cards:

void em28xx_set_ir(struct em28xx *dev, struct IR_i2c *ir)
{
        if (disable_ir) {
                ir->get_key = NULL;
                return ;
        }

        /* detect & configure */
        switch (dev->model) {
        case (EM2800_BOARD_UNKNOWN):
                break;
        case (EM2820_BOARD_UNKNOWN):
                break;
        case (EM2800_BOARD_TERRATEC_CINERGY_200):
        case (EM2820_BOARD_TERRATEC_CINERGY_250):
                ir->ir_codes = ir_codes_em_terratec;
                ir->get_key = em28xx_get_key_terratec;
                snprintf(ir->c.name, sizeof(ir->c.name),
                         "i2c IR (EM28XX Terratec)");
                break;
...

This function is called just after binding the IR, by i2c callback. It properly
fills the IR tables, get_key and IR names based on each different board model.

> 
> 2. Your example above is opening the video device endpoint and issuing 
> ioctl()s that are not part of V4L.  That is supposed to work?!?

I did a typo there. In fact, opens the proper /dev/event interface. The code
is the same kind of code that allows userspace to change from US keymapping to
a local keymapping.

It should be easy to call an userspace app from udev, after a device
connection, if the user wants to have a different IR keycode table for his
device.

> 3. A given IR remote may be described by much more than what 'scan 
> codes' it produces.  I don't know a lot about IR, but looking at the 
> typical lirc definition for a remote, there's obvious timing and 
> protocol parameters as well.  Just being able to swap scan codes around 
> is not always going to be enough.

The IR in-kernel implementation has the proper timing and protocol definitions
for each device. Having something else to take care with will just cause troubles.

For example, I have two saa713x devices with different IR chips. On both, the
IR protocol handling is done inside the chip. On one device, if you press a key
and keep it pressed, it will produce just one scan code. So, that device has no
way to support IR repetition. The other one produces scan codes to indicate a
key press and a key release events.

If you try to handle those cases outside kernel, you'll need to have a complex
setup environment for users to specify or to detect such issues. However, if
this is done on kernel, you can just use the proper event api to handle such
differences.

There is just one issue here that it is not addressed currently: if your device
comes with an IR with, for example pulse distance protocol, but you bought a
RC5 IR and wants to use it with your device, you would need to say to the
driver (and maybe to the hardware) to use a different protocol for decoding.

On some cases where the IR decoding is done via software, if you get the raw
data, you can change the protocol easily. However, on other cases, this can be
done only if you program the device with a different setup.

> 4. I imagine that the input event framework in the kernel has a means 
> for programmatic mapping of scan codes to key codes, but looking at 
> ir-kbd-i2c.c, it appears to only be selecting from among a very small 
> set of kernel-compiled translation tables.  I must be missing something 
> here.

It sets the default key tables. In fact, on most cases, the setting of the key
tables is done at the bridge driver. The ones inside ir-kbd-i2c are the
exceptions. Patches are welcome to remove those by adding such setup at the
bridge drivers, but extra care should be done to be sure that we won't break
any IR support.

> In an earlier post (from Andy?) some history was dug up about 
> ir-kbd-i2c.c.  From what I understand, the only reason ir-kbd-i2c.c came 
> into existence was because lirc was late in supporting 2.6.x series 
> kernels and Gerd needed *something* to allow IR to work.  So he created 
> this module, knowing full well that it didn't cover all possible cases.  
> Rather it covered the common cases he cared about.  That was a while 
> ago.  And we need to do all the cases - or at least not mess up what 
> already exists elsewhere that does handle the "uncommon" cases.  The 
> lirc drivers do work in 2.6.  And apparently they were on the scene 
> before ir-kbd-i2c.c, just unfortunately not in-tree.  The lirc drivers 
> really need to get into the kernel.  From where I'm sitting the long 
> term goal should be to get lirc into the kernel.

The ir-kbd-i2c is just the top of the iceberg. It covers the minority of
devices where IR is implemented via an i2c chip. Most devices are
connected via GPIO.

Also, after Gerd stopping work on it, several improvements and changes on the
original driver, including moving the setup process to the bridge drivers.

It should be noticed that there are 4 types of IRs:

1) IR chips connected via GPIO;

2) Simpler ones that just connect the IR sensor directly on some GPIO port
capable of generating interrupts. This kind of setup is very common on saa7134
driver. It should be noticed that a bad implementation here will lead to
machine hangups, due to IRQ troubles;

3) IR chips connected via I2C;

4) bridge chips with IR decoding capabilities. For example, em28xx has RC5
decoding internally.

On several cases, the IR chip is a low-cost generic processor or ASIC, with
some IR decoding software programmed there (read-only, AFAIK).

I haven't look on lirc implementation lately, but I think that lirc can
effectively change the decoding protocol only on the case (2) where the IR raw
data is sent directly via a GPIO port. On the other cases, the IR chip will
handle the protocol. 

So, if you have an IR chip and you want to change the protocol, you'll need to
send commands via the bridge driver to set it differently. It is risky to let
an external driver to do this, since this may cause troubles to the device
driver, as the developers won't generally count that another driver is poking
around with setup commands.

Cheers,
Mauro
