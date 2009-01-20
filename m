Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36817 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389AbZATWS6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2009 17:18:58 -0500
Date: Tue, 20 Jan 2009 20:18:30 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Devin Heitmueller" <devin.heitmueller@gmail.com>
Cc: "matthieu castet" <castet.matthieu@free.fr>,
	linux-media@vger.kernel.org
Subject: Re: haupauge remote keycode for av7110_loadkeys
Message-ID: <20090120201830.2945fba5@caramujo.chehab.org>
In-Reply-To: <412bdbff0901201150w2a8a66b4r50670eccc3d8340a@mail.gmail.com>
References: <4974E428.7020702@free.fr>
	<20090119185326.29da37da@caramujo.chehab.org>
	<4976295E.2070509@free.fr>
	<412bdbff0901201150w2a8a66b4r50670eccc3d8340a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 20 Jan 2009 14:50:26 -0500
"Devin Heitmueller" <devin.heitmueller@gmail.com> wrote:

> On Tue, Jan 20, 2009 at 2:43 PM, matthieu castet
> <castet.matthieu@free.fr> wrote:
> > Hi,
> >
> > Mauro Carvalho Chehab wrote:
> >>
> >> On Mon, 19 Jan 2009 21:35:52 +0100
> >> matthieu castet <castet.matthieu@free.fr> wrote:
> >>
> >>
> >> Matthieu,
> >>
> >> You can replace the ir-kbd-i2c keys using the standard input ioctls for
> >> it.
> >> Take a look at v4l2-apps/util/keycode app. It allows you to read and
> >> replace
> >> any IR keycodes on the driver that properly implements the event support
> >> (including ir-kbd-i2c).
> >
> > great I wasn't aware of this.
> > But this doesn't seem very friendly : all remote keycodes are in kernel.
> > If you want to change the remote, you have to do/provide the keycode for
> > your remote even if it is already in kernel.
> >
> > Matthieu
> 
> Matthieu,
> 
> Your assessment of the current situation is correct. Yes, it's a
> pretty annoying situation.  It does have the upside that we
> automatically provide the right keycodes for whatever remote comes by
> default with a particular product, but obviously it is a mess if you
> want to use some different remote and if your remote wasn't supported,
> adding support requires a kernel recompile.

No. Replacing the keycodes is as easy as adding something like this on your
rc.local, or adding an equivalent udev rule:

./v4l2-apps/util/keycode /dev/input/event3 ./v4l2-apps/util/keycodes/avertv_303 

This will replace the keys of the input device (assumed above that the event
device is event3) by the keys at avertv_303 file.

The in-kernel tables are just the default ones for that device.

Cheers,
Mauro
