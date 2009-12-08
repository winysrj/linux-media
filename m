Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:36444 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756050AbZLHP3n (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Dec 2009 10:29:43 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jon Smirl <jonsmirl@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	hermann pitton <hermann-pitton@arcor.de>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com,
	kraxel@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR 	system?
References: <20091204220708.GD25669@core.coreip.homeip.net> <BEJgSGGXqgB@lirc>
	<9e4733910912041628g5bedc9d2jbee3b0861aeb5511@mail.gmail.com>
	<1260070593.3236.6.camel@pc07.localdom.local>
	<20091206065512.GA14651@core.coreip.homeip.net>
	<4B1B99A5.2080903@redhat.com> <m3638k6lju.fsf@intrepid.localdomain>
	<9e4733910912060952h4aad49dake8e8486acb6566bc@mail.gmail.com>
	<m3skbn6dv1.fsf@intrepid.localdomain>
	<9e4733910912061323x22c618ccyf6edcee5b021cbe3@mail.gmail.com>
	<4B1D934E.7030103@redhat.com> <m3hbs1vain.fsf@intrepid.localdomain>
	<4B1E5DA3.7000206@redhat.com>
Date: Tue, 08 Dec 2009 16:29:46 +0100
In-Reply-To: <4B1E5DA3.7000206@redhat.com> (Mauro Carvalho Chehab's message of
	"Tue, 08 Dec 2009 12:07:31 -0200")
Message-ID: <m3y6ldscut.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab <mchehab@redhat.com> writes:

> If you use a kfifo to store the event (space_or_mark, timestamp), 
> the IRQ handler can return immediately, and a separate kernel thread 
> can do the decode without needing to touch at the IRQ.

But the decoding itself is a really simple thing, why complicate it?
There is no need for the kernel thread if the handler is fast (and it
is).

Userspace is obviously different.
-- 
Krzysztof Halasa
