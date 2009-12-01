Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f192.google.com ([209.85.221.192]:42716 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbZLAT13 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Dec 2009 14:27:29 -0500
MIME-Version: 1.0
In-Reply-To: <4B1567D8.7080007@redhat.com>
References: <9e4733910912010708u1064e2c6mbc08a01293c3e7fd@mail.gmail.com>
	 <1259682428.18599.10.camel@maxim-laptop>
	 <9e4733910912010816q32e829a2uce180bfda69ef86d@mail.gmail.com>
	 <4B154C54.5090906@redhat.com>
	 <829197380912010909m59cb1078q5bd2e00af0368aaf@mail.gmail.com>
	 <4B155288.1060509@redhat.com>
	 <20091201175400.GA19259@core.coreip.homeip.net>
	 <4B1567D8.7080007@redhat.com>
Date: Tue, 1 Dec 2009 14:27:35 -0500
Message-ID: <9e4733910912011127r4a40b75epf712006c47fe9061@mail.gmail.com>
Subject: Re: [RFC v2] Another approach to IR
From: Jon Smirl <jonsmirl@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com, khc@pm.waw.pl,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, lirc-list@lists.sourceforge.net,
	superm1@ubuntu.com, Christoph Bartelmus <lirc@bartelmus.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 1, 2009 at 2:00 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Due to the lack of an API for it, each driver has their own way to handle the
> protocols, but basically, on almost all drivers, even supporting different protocols,
> the driver limits the usage of just the protocol provided by the shipped remote.
>
> To solve this, we really need to extend evdev API to do 3 things: enumberate the
> supported protocols, get the current protocol(s), and select the protocol(s) that
> will be used by a newer table.

evdev capabilities bits can support enumerating the supported
protocols. I'm not sure if you can write those bits back into evdev to
turn a feature off/on. If not its something that could be added to
evdev.

I agree that there is no consistency in the existing driver implementations.

-- 
Jon Smirl
jonsmirl@gmail.com
