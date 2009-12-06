Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:34232 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757824AbZLFUeX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Dec 2009 15:34:23 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
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
Date: Sun, 06 Dec 2009 21:34:26 +0100
In-Reply-To: <9e4733910912060952h4aad49dake8e8486acb6566bc@mail.gmail.com>
	(Jon Smirl's message of "Sun, 6 Dec 2009 12:52:11 -0500")
Message-ID: <m3skbn6dv1.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jon Smirl <jonsmirl@gmail.com> writes:

>> Once again: how about agreement about the LIRC interface
>> (kernel-userspace) and merging the actual LIRC code first? In-kernel
>> decoding can wait a bit, it doesn't change any kernel-user interface.
>
> I'd like to see a semi-complete design for an in-kernel IR system
> before anything is merged from any source.

This is a way to nowhere, there is no logical dependency between LIRC
and input layer IR.

There is only one thing which needs attention before/when merging LIRC:
the LIRC user-kernel interface. In-kernel "IR system" is irrelevant and,
actually, making a correct IR core design without the LIRC merged can be
only harder.
-- 
Krzysztof Halasa
