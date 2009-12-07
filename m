Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:55849 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758444AbZLGSl6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Dec 2009 13:41:58 -0500
Date: Mon, 7 Dec 2009 10:41:53 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Jon Smirl <jonsmirl@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	hermann pitton <hermann-pitton@arcor.de>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com,
	kraxel@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
	IR  system?
Message-ID: <20091207184153.GD998@core.coreip.homeip.net>
References: <20091204220708.GD25669@core.coreip.homeip.net> <BEJgSGGXqgB@lirc> <9e4733910912041628g5bedc9d2jbee3b0861aeb5511@mail.gmail.com> <1260070593.3236.6.camel@pc07.localdom.local> <20091206065512.GA14651@core.coreip.homeip.net> <4B1B99A5.2080903@redhat.com> <m3638k6lju.fsf@intrepid.localdomain> <9e4733910912060952h4aad49dake8e8486acb6566bc@mail.gmail.com> <m3skbn6dv1.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3skbn6dv1.fsf@intrepid.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Dec 06, 2009 at 09:34:26PM +0100, Krzysztof Halasa wrote:
> Jon Smirl <jonsmirl@gmail.com> writes:
> 
> >> Once again: how about agreement about the LIRC interface
> >> (kernel-userspace) and merging the actual LIRC code first? In-kernel
> >> decoding can wait a bit, it doesn't change any kernel-user interface.
> >
> > I'd like to see a semi-complete design for an in-kernel IR system
> > before anything is merged from any source.
> 
> This is a way to nowhere, there is no logical dependency between LIRC
> and input layer IR.
> 
> There is only one thing which needs attention before/when merging LIRC:
> the LIRC user-kernel interface. In-kernel "IR system" is irrelevant and,
> actually, making a correct IR core design without the LIRC merged can be
> only harder.

This sounds like "merge first, think later"...

The question is why we need to merge lirc interface right now, before we
agreed on the sybsystem architecture? Noone _in kernel_ user lirc-dev
yet and, looking at the way things are shaping, no drivers will be
_directly_ using it after it is complete. So, even if we merge it right
away, the code will have to be restructured and reworked. Unfortunately,
just merging what Jarod posted, will introduce sysfs hierarchy which
is userspace interface as well (although we not as good maintaining it
at times) and will add more constraints on us.

That is why I think we should go the other way around - introduce the
core which receivers could plug into and decoder framework and once it
is ready register lirc-dev as one of the available decoders.

-- 
Dmitry
