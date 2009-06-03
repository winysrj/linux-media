Return-path: <linux-media-owner@vger.kernel.org>
Received: from belle.abrahamsson.com ([194.187.61.10]:4933 "EHLO
	belle.abrahamsson.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbZFCScT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Jun 2009 14:32:19 -0400
From: "Sverker Abrahamsson" <sverker@abrahamsson.com>
To: "'Trent Piepho'" <xyzzy@speakeasy.org>
Cc: "'Jose Diaz'" <xt4mhz@gmail.com>, <linux-media@vger.kernel.org>
References: <!&!AAAAAAAAAAAYAAAAAAAAAN5fehIZv/BBsQLx9nhfoL3ihQAAEAAAAKI1En61O+tDoEZgbOaYLvMBAAAAAA==@abrahamsson.com> <Pine.LNX.4.58.0905141315060.7837@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0905141315060.7837@shell2.speakeasy.net>
Subject: RE: Sound capture with Osprey 230
Date: Wed, 3 Jun 2009 20:02:17 +0200
Message-ID: <!&!AAAAAAAAAAAYAAAAAAAAAN5fehIZv/BBsQLx9nhfoL3ihQAAEAAAAKAjJeyyHNpLpQTWrIR9M9IBAAAAAA==@abrahamsson.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: sv
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Trent

> -----Original Message-----
> From: Trent Piepho [mailto:xyzzy@speakeasy.org]
> Sent: den 14 maj 2009 22:37
> To: Sverker Abrahamsson
> Cc: 'Jose Diaz'; linux-media@vger.kernel.org
> Subject: Re: Sound capture with Osprey 230
> 
> On Mon, 11 May 2009, Sverker Abrahamsson wrote:
> > Hi all,
> > I've been using Osprey 230 cards for AV capture for several years,
> earlier
> > with a modified version of Viewcast's driver but it was never very
> stable.
> > When doing a new setup I therefore wanted to get the Alsa driver to
> work. I
> > found that there were two trees in the repository in regards to these
> cards,
> > http://linuxtv.org/hg/~mchehab/osprey and
> http://linuxtv.org/hg/~tap/osprey.
> > It seems that mchehab tree is the patches that Viewcast submitted
> which does
> > not address the necessary changes for ALSA driver while tap tree does
> but
> > for Osprey 440 and older kernels.
> 
> Mauro's tree with viewcast's patches is even older than mine, wrt
> kernel
> support.
> 
> > I've therefore ported the changes from tap to the main tree and added
> > support for detecting Osprey 210/220/230 plus a minor fix to support
> > specifying digital_rate as module parameter. It might also work for
> Osprey
> > 240 (which is PCI-e variant of 230) but I don't have any such card so
> I
> > haven't been able to test.
> 
> Instead of modifying my patch, it would be better if you could provide
> a
> patch on top of it that adds support for your new card.

The reason why I didn't do that was your tree is almost two years old and
didn't compile on a 2.6.27 kernel. It was far less work to take the
significant parts of your driver and port them over to the main tree.

> > The only question mark I have is that the current implementation use
> the
> > depreciated interfaces from bttv-if.c to find which bttv driver
> corresponds
> > to this audio driver and adds a function to get the bttv core. It is
> > suggested to use the routines in bttv-gpio.c instead but I don't find
> an
> > obvious replacement for bttv_get_pcidev nor how to get bttv_core.
> 
> The interface in bttv-if.c has been "deprecated" for years now, yet no
> one
> has come up with something to replace it with.  I think Gerd was
> getting a
> bit ahead of himself when he declared it obsolete.

The function I use is the one you added to get a reference to the bttv
structure. For gpio operations it would be possible to use the new
interface, only that those functions aren't exported so that other drivers
can call them.
 
> > I see two alternatives:
> > 1. Implement snd-87x module as a subdevice to bttv. Is this correct
> as the
> > video and audio devices are two separate pci devices?
> 
> The audio and video devices aren't just separate pci devices, they are
> also
> two unrelated devices to the linux device model.  The driver model
> doesn't
> have any means to call one a subdevice of the other.
> 
> Somehow, there needs to be a means for the audio driver to find the
> video
> driver so that it can get access to the gpio lines and the i2c bus.
> But,
> this is only necessary for the osprey cards.  The audio driver for
> other
> cards doesn't need gpios or i2c.  So, it would be nice to allow just
> the
> audio driver with no video to be loaded.

While I partly agree with you that it would be a nicer solution to be able
to use the audio driver separately I don't see the need in reality. The
video chip is there, to have it's driver loaded to be able to use the audio
capture is a small drawback, if any. Only if someone needed that
functionality badly enough to do the work to implement it would happen, but
it would require substantial rewrite of the base driver with the potential
to create problems for other cards.
 
> The problem with my implementation is that after the audio bttv driver
> gets
> a pointer to the video driver's core, the video driver could go away
> and
> leave the audio driver with a dangling pointer.  That's one of the
> reasons
> I haven't merged my osprey code.  The other is that I have cards with
> bttv
> audio to test with.
 
No, the video driver can't be unloaded without the audio driver have been
unloaded before as the latter is depending on the former

/Sverker
 
 

__________ Information fran ESET NOD32 Antivirus, version av
virussignaturdatabas 4127 (20090603) __________

Meddelandet har kontrollerats av ESET NOD32 Antivirus.

http://www.esetscandinavia.com
 

