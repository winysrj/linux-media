Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47765 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029AbZATXCL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2009 18:02:11 -0500
Date: Tue, 20 Jan 2009 21:01:41 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Devin Heitmueller" <devin.heitmueller@gmail.com>
Cc: "matthieu castet" <castet.matthieu@free.fr>,
	linux-media@vger.kernel.org
Subject: Re: haupauge remote keycode for av7110_loadkeys
Message-ID: <20090120210141.3e8962e4@caramujo.chehab.org>
In-Reply-To: <412bdbff0901201436i363cd9d8r7d6cd4f37150e6c2@mail.gmail.com>
References: <4974E428.7020702@free.fr>
	<20090119185326.29da37da@caramujo.chehab.org>
	<4976295E.2070509@free.fr>
	<412bdbff0901201150w2a8a66b4r50670eccc3d8340a@mail.gmail.com>
	<20090120201830.2945fba5@caramujo.chehab.org>
	<412bdbff0901201436i363cd9d8r7d6cd4f37150e6c2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 20 Jan 2009 17:36:02 -0500
"Devin Heitmueller" <devin.heitmueller@gmail.com> wrote:

> On Tue, Jan 20, 2009 at 5:18 PM, Mauro Carvalho Chehab
> <mchehab@infradead.org> wrote:
> >> Your assessment of the current situation is correct. Yes, it's a
> >> pretty annoying situation.  It does have the upside that we
> >> automatically provide the right keycodes for whatever remote comes by
> >> default with a particular product, but obviously it is a mess if you
> >> want to use some different remote and if your remote wasn't supported,
> >> adding support requires a kernel recompile.
> >
> > No. Replacing the keycodes is as easy as adding something like this on your
> > rc.local, or adding an equivalent udev rule:
> >
> > ./v4l2-apps/util/keycode /dev/input/event3 ./v4l2-apps/util/keycodes/avertv_303
> >
> > This will replace the keys of the input device (assumed above that the event
> > device is event3) by the keys at avertv_303 file.
> >
> > The in-kernel tables are just the default ones for that device.
> 
> I guess the thing I disagree with is the notion that what you have
> described is "easy".
> 
> * It requires keymaps being maintained both in-kernel and out-of-kernel
> * It doesn't let you select a different in-kernel keymap unless you
> translate it to a file that can be passed to the keycode utility

make keycode gets all in-kernel tables and converts them into files used by
keycode program. So, all in-kernel tables are got (from almost all devices).

> * It doesn't work with all drivers (like the dib0700)

Unfortunately, dib0700 doesn't properly implement the input interface.

> * The interactions with lircd is inconsistent across drivers.

I've stopped using LIRC a long time ago. It used to be hard to configure, and
to produce huge dumps of errors, if the device got disconnected by removing the
module or the usb stick. Not sure what changed on lirc since then.

I agree that the IR tables need some adjustments to make they more consistent.
For example, IMO, it is a really bad idea to map any IR key into KEY_POWER,
since, if you press it wanting to stop your video app, it will, instead, power
down the machine. KEY_POWER2 is better, since it can be handled only at the
video apps.

Cheers,
Mauro
