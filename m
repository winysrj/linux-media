Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:48630 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbZDFBvd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Apr 2009 21:51:33 -0400
Date: Sun, 5 Apr 2009 22:51:02 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Andy Walls <awalls@radix.net>
Cc: hermann pitton <hermann-pitton@arcor.de>,
	Jean Delvare <khali@linux-fr.org>, Janne Grunau <j@jannau.net>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mike Isely <isely@pobox.com>, isely@isely.net,
	LMML <linux-media@vger.kernel.org>,
	Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding
 model
Message-ID: <20090405225102.531a2075@pedra.chehab.org>
In-Reply-To: <1238968804.4647.22.camel@morgan.walls.org>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 05 Apr 2009 18:00:04 -0400
Andy Walls <awalls@radix.net> wrote:

> On Sun, 2009-04-05 at 23:22 +0200, hermann pitton wrote:
> > Am Sonntag, den 05.04.2009, 22:22 +0200 schrieb Jean Delvare:
> > > On Sun, 05 Apr 2009 14:58:17 -0400, Andy Walls wrote:
> 
> 
> > What can not be translated to the input system I would like to know.
> > Andy seems to have closer looked into that.
> 
> 1. IR blasting: sending IR codes to transmit out to a cable convertor
> box, DTV to analog convertor box, or similar devices to change channels
> before recording starts.  An input interface doesn't work well for
> output.

On my understanding, IR output is a separate issue. AFAIK, only a very few ivtv
devices support IR output. I'm not sure how this is currently implemented.


> 2. Sending raw IR samples to user space: user space applications can
> then decode or match an unknown or non-standard IR remote protocol in
> user space software.  Timing information to go along with the sample
> data probably needs to be preserved.   I'm assuming the input interface
> currently doesn't support that.

If the driver processes correctly the IR samples, I don't see why you would
need to pass the raw protocols to userspace. Maybe we need to add some ioctls
at the API to allow certain controls, like, for example, ask kernel to decode
IR using RC4 instead or RC5, on devices that supports more than one IR protocol.

> That's all the Gerd mentioned.
> 
> 
> One more nice feature to have, that I'm not sure how easily the input
> system could support:
> 
> 3. specifying remote control code to key/button translations with a
> configuration file instead of recompiling a module.

The input and the current drivers that use input already supports this feature.
You just need to load a new code table to replace the existing one.

See v4l2-apps/util/keytable.c to see how easy is to change a key code. It
contains a complete code to fully replace a key code table. Also, the Makefile
there will extract the current keytables for the in-kernel drivers.

Btw, with only 12 lines, you can create a keycode replace "hello world!":

#include <fcntl.h>		/* due to O_RDONLY */
#include <stdio.h>		/* open() */
#include <linux/input.h>	/* input ioctls and keycode macros */
#include <sys/ioctl.h>		/* ioctl() */
void main(void)
{
	int codes[2];
	int fd = open("/dev/video0", O_RDONLY);	/* Hmm.. in real apps, we should check for errors */
	codes[0] = 10;				/* Scan code */
	codes[1] = KEY_UP;			/* Key code */
	ioctl(fd, EVIOCSKEYCODE, codes);	/* hello world! */
}

Cheers,
Mauro
