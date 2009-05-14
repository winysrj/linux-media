Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:38452 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbZENUhL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2009 16:37:11 -0400
Date: Thu, 14 May 2009 13:37:10 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Sverker Abrahamsson <sverker@abrahamsson.com>
cc: 'Jose Diaz' <xt4mhz@gmail.com>, linux-media@vger.kernel.org
Subject: Re: Sound capture with Osprey 230
In-Reply-To: <!&!AAAAAAAAAAAYAAAAAAAAAN5fehIZv/BBsQLx9nhfoL3ihQAAEAAAAKI1En61O+tDoEZgbOaYLvMBAAAAAA==@abrahamsson.com>
Message-ID: <Pine.LNX.4.58.0905141315060.7837@shell2.speakeasy.net>
References: <!&!AAAAAAAAAAAYAAAAAAAAAN5fehIZv/BBsQLx9nhfoL3ihQAAEAAAAKI1En61O+tDoEZgbOaYLvMBAAAAAA==@abrahamsson.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 11 May 2009, Sverker Abrahamsson wrote:
> Hi all,
> I've been using Osprey 230 cards for AV capture for several years, earlier
> with a modified version of Viewcast's driver but it was never very stable.
> When doing a new setup I therefore wanted to get the Alsa driver to work. I
> found that there were two trees in the repository in regards to these cards,
> http://linuxtv.org/hg/~mchehab/osprey and http://linuxtv.org/hg/~tap/osprey.
> It seems that mchehab tree is the patches that Viewcast submitted which does
> not address the necessary changes for ALSA driver while tap tree does but
> for Osprey 440 and older kernels.

Mauro's tree with viewcast's patches is even older than mine, wrt kernel
support.

> I've therefore ported the changes from tap to the main tree and added
> support for detecting Osprey 210/220/230 plus a minor fix to support
> specifying digital_rate as module parameter. It might also work for Osprey
> 240 (which is PCI-e variant of 230) but I don't have any such card so I
> haven't been able to test.

Instead of modifying my patch, it would be better if you could provide a
patch on top of it that adds support for your new card.

> The only question mark I have is that the current implementation use the
> depreciated interfaces from bttv-if.c to find which bttv driver corresponds
> to this audio driver and adds a function to get the bttv core. It is
> suggested to use the routines in bttv-gpio.c instead but I don't find an
> obvious replacement for bttv_get_pcidev nor how to get bttv_core.

The interface in bttv-if.c has been "deprecated" for years now, yet no one
has come up with something to replace it with.  I think Gerd was getting a
bit ahead of himself when he declared it obsolete.

> I see two alternatives:
> 1. Implement snd-87x module as a subdevice to bttv. Is this correct as the
> video and audio devices are two separate pci devices?

The audio and video devices aren't just separate pci devices, they are also
two unrelated devices to the linux device model.  The driver model doesn't
have any means to call one a subdevice of the other.

Somehow, there needs to be a means for the audio driver to find the video
driver so that it can get access to the gpio lines and the i2c bus.  But,
this is only necessary for the osprey cards.  The audio driver for other
cards doesn't need gpios or i2c.  So, it would be nice to allow just the
audio driver with no video to be loaded.

The problem with my implementation is that after the audio bttv driver gets
a pointer to the video driver's core, the video driver could go away and
leave the audio driver with a dangling pointer.  That's one of the reasons
I haven't merged my osprey code.  The other is that I have cards with bttv
audio to test with.
