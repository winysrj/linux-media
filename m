Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:37730 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751963AbZDFDaL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2009 23:30:11 -0400
Subject: Re: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding
	model
From: hermann pitton <hermann-pitton@arcor.de>
To: Mike Isely <isely@pobox.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Andy Walls <awalls@radix.net>,
	Jean Delvare <khali@linux-fr.org>, Janne Grunau <j@jannau.net>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	LMML <linux-media@vger.kernel.org>,
	Jarod Wilson <jarod@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0904052104010.2076@cnc.isely.net>
References: <20090404142427.6e81f316@hyperion.delvare>
	 <Pine.LNX.4.64.0904041045380.32720@cnc.isely.net>
	 <20090405010539.187e6268@hyperion.delvare>
	 <200904050746.47451.hverkuil@xs4all.nl> <20090405143748.GC10556@aniel>
	 <1238953174.3337.12.camel@morgan.walls.org> <20090405183154.GE10556@aniel>
	 <1238957897.3337.50.camel@morgan.walls.org>
	 <20090405222250.64ed67ae@hyperion.delvare>
	 <1238966523.6627.63.camel@pc07.localdom.local>
	 <1238968804.4647.22.camel@morgan.walls.org>
	 <20090405225102.531a2075@pedra.chehab.org>
	 <Pine.LNX.4.64.0904052104010.2076@cnc.isely.net>
Content-Type: text/plain
Date: Mon, 06 Apr 2009 05:26:40 +0200
Message-Id: <1238988400.3722.11.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Sonntag, den 05.04.2009, 21:52 -0500 schrieb Mike Isely:
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
> 
> 
> > 
> > 
> > > 2. Sending raw IR samples to user space: user space applications can
> > > then decode or match an unknown or non-standard IR remote protocol in
> > > user space software.  Timing information to go along with the sample
> > > data probably needs to be preserved.   I'm assuming the input interface
> > > currently doesn't support that.
> > 
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
> 
> Yet in this case with IR, there already exists a subsystem that does 
> *more* than ir-kbd-i2c.c, AND it does all the crazy configuration / 
> control in userspace - and yet you argue that ir-kbd-i2c.c should be 
> preferred?  Purely because lirc is not in-tree?  Well heck, lirc should 
> be in-tree.  Let's help them get there and forget ever having to deal 
> with IR again ourselves.  Let them do it.
> 
> 
> > 
> > > That's all the Gerd mentioned.
> > > 
> > > 
> > > One more nice feature to have, that I'm not sure how easily the input
> > > system could support:
> > > 
> > > 3. specifying remote control code to key/button translations with a
> > > configuration file instead of recompiling a module.
> > 
> > The input and the current drivers that use input already supports this feature.
> > You just need to load a new code table to replace the existing one.
> > 
> > See v4l2-apps/util/keytable.c to see how easy is to change a key code. It
> > contains a complete code to fully replace a key code table. Also, the Makefile
> > there will extract the current keytables for the in-kernel drivers.
> > 
> > Btw, with only 12 lines, you can create a keycode replace "hello world!":
> > 
> > #include <fcntl.h>		/* due to O_RDONLY */
> > #include <stdio.h>		/* open() */
> > #include <linux/input.h>	/* input ioctls and keycode macros */
> > #include <sys/ioctl.h>		/* ioctl() */
> > void main(void)
> > {
> > 	int codes[2];
> > 	int fd = open("/dev/video0", O_RDONLY);	/* Hmm.. in real apps, we should check for errors */
> > 	codes[0] = 10;				/* Scan code */
> > 	codes[1] = KEY_UP;			/* Key code */
> > 	ioctl(fd, EVIOCSKEYCODE, codes);	/* hello world! */
> > }
> 
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
> 
> 2. Your example above is opening the video device endpoint and issuing 
> ioctl()s that are not part of V4L.  That is supposed to work?!?
> 
> 3. A given IR remote may be described by much more than what 'scan 
> codes' it produces.  I don't know a lot about IR, but looking at the 
> typical lirc definition for a remote, there's obvious timing and 
> protocol parameters as well.  Just being able to swap scan codes around 
> is not always going to be enough.
> 
> 4. I imagine that the input event framework in the kernel has a means 
> for programmatic mapping of scan codes to key codes, but looking at 
> ir-kbd-i2c.c, it appears to only be selecting from among a very small 
> set of kernel-compiled translation tables.  I must be missing something 
> here.
> 
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
> 
>   -Mike
> 

ir_kbd_i2c is much older than Gerd. It comes from bttv.

lirc was unusable on 2.6.x. I do confirm that.

If you like to have some more on the ways, the just merged dvb did state
the whole in kernel i2c is crap, likely with some good reasons.

Mike, I'm too old now to start on it again, but feel free to give us
more insight.

Cheers,
Hermann




