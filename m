Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39468 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760025AbZLOLuR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2009 06:50:17 -0500
Date: Tue, 15 Dec 2009 12:50:11 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Jon Smirl <jonsmirl@gmail.com>,
	hermann pitton <hermann-pitton@arcor.de>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com,
	kraxel@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
	IR  system?
Message-ID: <20091215115011.GB1385@ucw.cz>
References: <BEJgSGGXqgB@lirc> <9e4733910912041628g5bedc9d2jbee3b0861aeb5511@mail.gmail.com> <1260070593.3236.6.camel@pc07.localdom.local> <20091206065512.GA14651@core.coreip.homeip.net> <4B1B99A5.2080903@redhat.com> <m3638k6lju.fsf@intrepid.localdomain> <9e4733910912060952h4aad49dake8e8486acb6566bc@mail.gmail.com> <m3skbn6dv1.fsf@intrepid.localdomain> <20091207184153.GD998@core.coreip.homeip.net> <4B24DABA.9040007@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B24DABA.9040007@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> > This sounds like "merge first, think later"...
> > 
> > The question is why we need to merge lirc interface right now, before we
> > agreed on the sybsystem architecture? Noone _in kernel_ user lirc-dev
> > yet and, looking at the way things are shaping, no drivers will be
> > _directly_ using it after it is complete. So, even if we merge it right
> > away, the code will have to be restructured and reworked. Unfortunately,
> > just merging what Jarod posted, will introduce sysfs hierarchy which
> > is userspace interface as well (although we not as good maintaining it
> > at times) and will add more constraints on us.
> > 
> > That is why I think we should go the other way around - introduce the
> > core which receivers could plug into and decoder framework and once it
> > is ready register lirc-dev as one of the available decoders.
> > 
> 
> I've committed already some IR restruct code on my linux-next -git tree:
> 
> http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-next.git
> 
> The code there basically moves the input/evdev registering code and 
> scancode/keycode management code into a separate ir-core module.
> 
> To make my life easy, I've moved the code temporarily into drivers/media/IR.
> This way, it helps me to move V4L specific code outside ir-core and to later
> use it for DVB. After having it done, probably the better is to move it to
> be under /drivers or /drivers/input.

Well, -next is for stuff to be merged into 2.6.34. You are quite an
optimist.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
