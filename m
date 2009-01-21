Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:51096 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753518AbZAUAjG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2009 19:39:06 -0500
Subject: Re: haupauge remote keycode for av7110_loadkeys
From: hermann pitton <hermann-pitton@arcor.de>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	matthieu castet <castet.matthieu@free.fr>,
	linux-media@vger.kernel.org
In-Reply-To: <412bdbff0901201520g685ea242x3eb732e800e8186e@mail.gmail.com>
References: <4974E428.7020702@free.fr>
	 <20090119185326.29da37da@caramujo.chehab.org> <4976295E.2070509@free.fr>
	 <412bdbff0901201150w2a8a66b4r50670eccc3d8340a@mail.gmail.com>
	 <20090120201830.2945fba5@caramujo.chehab.org>
	 <412bdbff0901201436i363cd9d8r7d6cd4f37150e6c2@mail.gmail.com>
	 <20090120210141.3e8962e4@caramujo.chehab.org>
	 <412bdbff0901201520g685ea242x3eb732e800e8186e@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 21 Jan 2009 01:39:15 +0100
Message-Id: <1232498355.6225.9.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Dienstag, den 20.01.2009, 18:20 -0500 schrieb Devin Heitmueller:
> On Tue, Jan 20, 2009 at 6:01 PM, Mauro Carvalho Chehab
> <mchehab@infradead.org> wrote:
> >> * It doesn't work with all drivers (like the dib0700)
> >
> > Unfortunately, dib0700 doesn't properly implement the input interface.
> 
> This is something I wanted to rework but had not gotten around to it yet.
> 
> >> * The interactions with lircd is inconsistent across drivers.
> >
> > I've stopped using LIRC a long time ago. It used to be hard to configure, and
> > to produce huge dumps of errors, if the device got disconnected by removing the
> > module or the usb stick. Not sure what changed on lirc since then.
> 
> You may not be using lircd, but I am quite confident that others do,
> based on the traffic on the ML.  In fact, some use lircd to work
> around their devices not working with dib0700, so any change to make
> dib0700 more consistent with some of the other devices will likely
> result in breakage for those users.
> 
> > I agree that the IR tables need some adjustments to make they more consistent.
> > For example, IMO, it is a really bad idea to map any IR key into KEY_POWER,
> > since, if you press it wanting to stop your video app, it will, instead, power
> > down the machine. KEY_POWER2 is better, since it can be handled only at the
> > video apps.
> 
> Does this approach handle things like keymaps that are not for RC5
> based remote controls?  Also, how does this approach allow for telling
> the IR receiver what format to capture in (NEC/RC5/RC6)?
> 
> Admittedly I don't know the answers to these questions myself, which
> is why both the dib0700 and em28xx drivers only support RC5, even
> though both chips support other formats (the dib0700 supports RC5/RC6
> and the em28xx supports NEC/RC5/RC6).  If we had a consistent scheme
> for specifying what format a keymap is in, I could make sure the chip
> is in the correct mode (I have all the relevant information for both
> chips).
> 
> The real question lies in where to draw the line between what should
> be done in userland versus what should be done in the kernel?  At one
> end of the spectrum, you could argue that the kernel should really be
> representing the devices as RC5/RC6 receivers, and all the translation
> to keycodes should be done in userland by something such as lircd, and
> on the other end of the spectrum is that everything should be in
> kernel and there should never be a need for lircd and there should
> just be an API for loading any lirc keymap into the kernel.
> 
> The whole topic is a *huge* source of confusion for most people,
> including the developers, given that the approach varies by device and
> the variety of ways people workaround the condition of "my remote
> doesn't work", some of which involve the use of lircd.
> 

that is right.

But some must at least hack a remote at all.

I had hard times to realize that there are remotes without dedicated
remote chips/controllers only triggering an IRQ, which just was only
quite recently in a state for that driver to have a chance to implement
it specifically.

Without it lircd doesn't exist either in such cases.

Cheers,
Hermann


 

