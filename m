Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:33333 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758230AbZLGSeS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Dec 2009 13:34:18 -0500
Date: Mon, 7 Dec 2009 10:34:15 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jonsmirl@gmail.com, khc@pm.waw.pl,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
	IR  system?
Message-ID: <20091207183415.GC998@core.coreip.homeip.net>
References: <A6D5FF84-2DB8-4543-ACCB-287305CA0739@wilsonet.com> <4B17AA6A.9060702@redhat.com> <20091203175531.GB776@core.coreip.homeip.net> <20091203163328.613699e5@pedra> <20091204100642.GD22570@core.coreip.homeip.net> <20091204121234.5144836b@pedra> <20091206070929.GB14651@core.coreip.homeip.net> <4B1B8F83.5080009@redhat.com> <20091207074818.GA24958@core.coreip.homeip.net> <4B1D2072.4020003@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1D2072.4020003@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 07, 2009 at 01:34:10PM -0200, Mauro Carvalho Chehab wrote:
>  
> > Scancodes in input system never been real scancodes. Even if you look
> > into atkbd it uses some synthetic data composed out of real scancodes
> > sent to the keyboard, and noone cares. If you are unsatisfied with
> > mapping you fire up evtest, press the key, take whatever the driver
> > [mis]represents as a scancode and use it to load the new definition. And
> > you don't care at all whether the thing that driver calls cancode makes
> > any sense to the hardware device.
> 
> We used a mis-represented scancode, but this proofed to be a broken design
> along the time.
> 
> For users, whatever the scancode "cookie" means, the same IR device should
> provide the same "cookie" no matter what IR receiver is used, since the same
> IR may be found on different devices, or the user can simply buy a new card
> and opt to use their old IR (there are very good reasons for that, since
> several new devices are now coming with small IR's that has half of the
> keys of the ones available at the older models).

OK, this is a fair point. We need to keep the "scancodes" stable across
receivers.

However I am not sure if the "index" approach is the best - it will not
work well if driver decides to implement the keymap using data structure
different from array, let's say linked list or a hash table. Lists by
their nature do not have a stable index and even if we were to generate
one "on fly" we could not rely on it for subsequent EVIOSKEYCODE: some
other program may cause insertion or deletion of an element making the
artificial index refer to another entry in the map.

While extending scancode size is pretty straightforward (well, almost
;) ) I am not sure what is the best way to enumerate keymap for a given
device.

-- 
Dmitry
