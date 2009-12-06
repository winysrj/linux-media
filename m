Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:53474 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756650AbZLFR0h (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Dec 2009 12:26:37 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Andy Walls <awalls@radix.net>
Cc: Jon Smirl <jonsmirl@gmail.com>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, kraxel@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR  system?
References: <20091204220708.GD25669@core.coreip.homeip.net> <BEJgSGGXqgB@lirc>
	<9e4733910912041628g5bedc9d2jbee3b0861aeb5511@mail.gmail.com>
	<1259977687.27969.18.camel@localhost>
	<9e4733910912041945g14732dcfgbb2ef6437ef62bb6@mail.gmail.com>
	<1260066624.3105.33.camel@palomino.walls.org>
Date: Sun, 06 Dec 2009 18:26:40 +0100
In-Reply-To: <1260066624.3105.33.camel@palomino.walls.org> (Andy Walls's
	message of "Sat, 05 Dec 2009 21:30:24 -0500")
Message-ID: <m3aaxw6mjz.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls <awalls@radix.net> writes:

> Yes, I agree.  I do not know what percentage of current Linux users are
> technical vs non-technical, so I cannot gauge the current improtance.
>
> I can see the trend line though: as time goes by, the percentage of all
> linux users that have a technical bent will only get smaller.

This IMHO shouldn't matter. If users can configure their keymaps for
e.g. games with a graphical utility (and  they easily can), they can do
the same with their remotes, at least with these using common sane
protocols. The only thing needed is a good GUI utility. Ergo - it's not
a kernel issue.

The "default bundled", or PnP, won't work well in comparison to a GUI
utility, I wouldn't worry about it too much (though adding it to udev
and co is trivial and we should do it - even if not PnP but asking first
about the actual remote used).
-- 
Krzysztof Halasa
