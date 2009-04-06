Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53169 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713AbZDFKp1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Apr 2009 06:45:27 -0400
Date: Mon, 6 Apr 2009 07:45:02 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Uri Shkolnik <urishk@yahoo.com>
Cc: Andy Walls <awalls@radix.net>,
	hermann pitton <hermann-pitton@arcor.de>,
	Jean Delvare <khali@linux-fr.org>, Janne Grunau <j@jannau.net>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mike Isely <isely@pobox.com>, isely@isely.net,
	LMML <linux-media@vger.kernel.org>,
	Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding
 model
Message-ID: <20090406074502.2cbd368e@pedra.chehab.org>
In-Reply-To: <446692.77537.qm@web110810.mail.gq1.yahoo.com>
References: <446692.77537.qm@web110810.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 5 Apr 2009 22:35:25 -0700 (PDT)
Uri Shkolnik <urishk@yahoo.com> wrote:

> 
> 
> 
> --- On Mon, 4/6/09, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> 
> > From: Mauro Carvalho Chehab <mchehab@infradead.org>
> > Subject: Re: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding model
> > To: "Andy Walls" <awalls@radix.net>
> > Cc: "hermann pitton" <hermann-pitton@arcor.de>, "Jean Delvare" <khali@linux-fr.org>, "Janne Grunau" <j@jannau.net>, "Hans Verkuil" <hverkuil@xs4all.nl>, "Mike Isely" <isely@pobox.com>, isely@isely.net, "LMML" <linux-media@vger.kernel.org>, "Jarod Wilson" <jarod@redhat.com>
> > Date: Monday, April 6, 2009, 4:51 AM
> > On Sun, 05 Apr 2009 18:00:04 -0400
> > Andy Walls <awalls@radix.net>
> > wrote:
> > 
> > > On Sun, 2009-04-05 at 23:22 +0200, hermann pitton
> > wrote:
> > > > Am Sonntag, den 05.04.2009, 22:22 +0200 schrieb
> > Jean Delvare:
> > > > > On Sun, 05 Apr 2009 14:58:17 -0400, Andy
> > Walls wrote:
> > > 
> > > 
> > > > What can not be translated to the input system I
> > would like to know.
> > > > Andy seems to have closer looked into that.
> > > 
> > > 1. IR blasting: sending IR codes to transmit out to a
> > cable convertor
> > > box, DTV to analog convertor box, or similar devices
> > to change channels
> > > before recording starts.  An input interface
> > doesn't work well for
> > > output.
> > 
> > On my understanding, IR output is a separate issue. AFAIK,
> > only a very few ivtv
> > devices support IR output. I'm not sure how this is
> > currently implemented.
> > 
> > 
> > > 2. Sending raw IR samples to user space: user space
> > applications can
> > > then decode or match an unknown or non-standard IR
> > remote protocol in
> > > user space software.  Timing information to go
> > along with the sample
> > > data probably needs to be
> > preserved.   I'm assuming the input
> > interface
> > > currently doesn't support that.
> > 
> > If the driver processes correctly the IR samples, I don't
> > see why you would
> > need to pass the raw protocols to userspace. Maybe we need
> > to add some ioctls
> > at the API to allow certain controls, like, for example,
> > ask kernel to decode
> > IR using RC4 instead or RC5, on devices that supports more
> > than one IR protocol.
> > 
> > > That's all the Gerd mentioned.
> > > 
> > > 
> > > One more nice feature to have, that I'm not sure how
> > easily the input
> > > system could support:
> > > 
> > > 3. specifying remote control code to key/button
> > translations with a
> > > configuration file instead of recompiling a module.
> > 
> > The input and the current drivers that use input already
> > supports this feature.
> > You just need to load a new code table to replace the
> > existing one.
> > 
> > See v4l2-apps/util/keytable.c to see how easy is to change
> > a key code. It
> > contains a complete code to fully replace a key code table.
> > Also, the Makefile
> > there will extract the current keytables for the in-kernel
> > drivers.
> > 
> > Btw, with only 12 lines, you can create a keycode replace
> > "hello world!":
> > 
> > #include <fcntl.h>   
> >     /* due to O_RDONLY */
> > #include <stdio.h>   
> >     /* open() */
> > #include <linux/input.h>    /* input
> > ioctls and keycode macros */
> > #include <sys/ioctl.h>   
> >     /* ioctl() */
> > void main(void)
> > {
> >     int codes[2];
> >     int fd = open("/dev/video0",
> > O_RDONLY);    /* Hmm.. in real apps, we
> > should check for errors */
> >     codes[0] = 10;   
> >             /*
> > Scan code */
> >     codes[1] = KEY_UP;   
> >         /* Key code */
> >     ioctl(fd, EVIOCSKEYCODE,
> > codes);    /* hello world! */
> > }
> > 
> > Cheers,
> > Mauro
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> 
> Hi,
> 
> ir-kbd-i2c is a confusing name and wrong architecture if all are truly combined together.
> 
> Why to combine interface driver (I2C) with logical implementation (RC5 samples to input device codes)?
> 
> There are many IR hardware devices which are not I2C based. Lately I added a patch (http://patchwork.kernel.org/patch/16406/) which uses such IR device.
> 
> There should be a complete separation between I2C interface driver with RC5 (and/or RCMM) data output, to the ir-kbd (RC5/kbd, RCMM/kbd) module, which should only convert RC5 sample to system events (either input device/keyboard, or IOCTL events sent through the DVB characters devices to user space).
> 
> If the code will stay combined (ir-kbd-i2c) than for other than I2C interface drivers, we'll have to add a duplicated (redundant) logical layer to handle the RC5 to system events layer (which already exist at the ir-kbd-i2c).

This module is just for i2c devices. Non-i2c devices are handled together with
bridge drivers. Common routines like RC5 and pulse distande decoding are at
ir-functions.c, as part of ir-common.

There's no RC5 decoding functions there. What it has is some get_key routines
that gets the data from the i2c packet and properly fills the event fields.

It should be noticed that ir-kbd-i2c is that people never cared to create one
ir-i2c-foo module for each different I2C chip. It is common to use the same
chips on different devices (for example, ks007 is used on several ones).

Since ir-kbd-i2c implements support for several different chips inside the same
module, some code is needed to identify what chip is being used. That part is messy:
it basically relies on what i2c address were found, and what bridge is using
it. 

The original implementation were to identify the IR type inside ir-kbd-i2c,
based on the i2c address and on the bridge driver. Of course conflicts arose
with this method.

So, a more modern implementation is to let this to be done by the bridge
driver, via i2c attach callback. This is much more reliable, since we can use
the proper routines that are specific for that board model.

An i2c cleanup that can be done after applying Jean's patches is to move all
get-key functions to ir-functions.c and let the module be just the i2c glue for
IR, getting rid of the original implementation. I'm not sure if this will be an
easy task, since we'll need to know what device models use each get_key_foo
functions.

Cheers,
Mauro
