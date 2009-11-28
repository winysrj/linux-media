Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:57477 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120AbZK1RfB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2009 12:35:01 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	maximlevitsky@gmail.com, mchehab@redhat.com,
	stefanr@s5r6.in-berlin.de, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR  system?
References: <m3r5riy7py.fsf@intrepid.localdomain> <BDkdITRHqgB@lirc>
	<9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com>
Date: Sat, 28 Nov 2009 18:35:02 +0100
In-Reply-To: <9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com> (Jon
	Smirl's message of "Sat, 28 Nov 2009 12:06:48 -0500")
Message-ID: <m3aay6y2m1.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jon Smirl <jonsmirl@gmail.com> writes:

> There are two very basic things that we need to reach consensus on first.
>
> 1) Unification with mouse/keyboard in evdev - put IR on equal footing.
> 2) Specific tools (xmodmap, setkeycodes, etc or the LIRC ones) or
> generic tools (ls, mkdir, echo) for configuration

I think we can do this gradually:
1. Merging the lirc drivers. The only stable thing needed is lirc
   interface.
2. Changing IR input layer interface ("media" drivers and adding to lirc
   drivers).
-- 
Krzysztof Halasa
