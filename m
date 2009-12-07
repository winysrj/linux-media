Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:55363 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758846AbZLGUIy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Dec 2009 15:08:54 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jon Smirl <jonsmirl@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	hermann pitton <hermann-pitton@arcor.de>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com,
	kraxel@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR  system?
References: <20091204220708.GD25669@core.coreip.homeip.net> <BEJgSGGXqgB@lirc>
	<9e4733910912041628g5bedc9d2jbee3b0861aeb5511@mail.gmail.com>
	<1260070593.3236.6.camel@pc07.localdom.local>
	<20091206065512.GA14651@core.coreip.homeip.net>
	<4B1B99A5.2080903@redhat.com> <m3638k6lju.fsf@intrepid.localdomain>
	<9e4733910912060952h4aad49dake8e8486acb6566bc@mail.gmail.com>
	<m3skbn6dv1.fsf@intrepid.localdomain>
	<20091207184153.GD998@core.coreip.homeip.net>
Date: Mon, 07 Dec 2009 21:08:57 +0100
In-Reply-To: <20091207184153.GD998@core.coreip.homeip.net> (Dmitry Torokhov's
	message of "Mon, 7 Dec 2009 10:41:53 -0800")
Message-ID: <m3my1u35t2.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dmitry Torokhov <dmitry.torokhov@gmail.com> writes:

>> There is only one thing which needs attention before/when merging LIRC:
>> the LIRC user-kernel interface. In-kernel "IR system" is irrelevant and,
>> actually, making a correct IR core design without the LIRC merged can be
>> only harder.
>
> This sounds like "merge first, think later"...

I'd say "merge the sane agreed and stable things first and think later
about improvements".

> The question is why we need to merge lirc interface right now, before we
> agreed on the sybsystem architecture?

Because we need the features and we can't improve something which is
outside the kernel. What "subsystem architecture" do you want to
discuss? Unrelated (input layer) interface?

Those are simple things. The only part which needs to be stable is the
(in this case LIRC) kernel-user interface.

> Noone _in kernel_ user lirc-dev
> yet and, looking at the way things are shaping, no drivers will be
> _directly_ using it after it is complete. So, even if we merge it right
> away, the code will have to be restructured and reworked.

Sure. We do this constantly to every part of the kernel.

> Unfortunately,
> just merging what Jarod posted, will introduce sysfs hierarchy which
> is userspace interface as well (although we not as good maintaining it
> at times) and will add more constraints on us.

Then perhaps it should be skipped, leaving only the things udev needs to
create /dev/ entries. They don't have to be particularly stable.
Perhaps it should go to the staging first. We can't work with the code
outside the kernel, staging has not such limitation.

> That is why I think we should go the other way around - introduce the
> core which receivers could plug into and decoder framework and once it
> is ready register lirc-dev as one of the available decoders.

That means all the work has to be kept and then merged "atomically",
it seems there is a lack of manpower for this.
-- 
Krzysztof Halasa
