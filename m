Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:50748 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660Ab1CVAsQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2011 20:48:16 -0400
Message-ID: <4D87F1C6.3040209@infradead.org>
Date: Mon, 21 Mar 2011 21:48:06 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: Daniel Drake <dsd@laptop.org>, dilinger@queued.net,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] via-camera: Fix OLPC serial check
References: <20110303190331.E8ED79D401D@zog.reactivated.net> <20110310092457.2e748f72@bike.lwn.net>
In-Reply-To: <20110310092457.2e748f72@bike.lwn.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 10-03-2011 13:24, Jonathan Corbet escreveu:
> [Trying to bash my inbox into reasonable shape, sorry for the slow
> response...]
> 
> On Thu,  3 Mar 2011 19:03:31 +0000 (GMT)
> Daniel Drake <dsd@laptop.org> wrote:
> 
>> The code that checks the OLPC serial port is never built at the moment,
>> because CONFIG_OLPC_XO_1_5 doesn't exist and probably won't be added.
>>
>> Fix it so that it gets compiled in, only executes on OLPC laptops, and
>> move the check into the probe routine.
>>
>> The compiler is smart enough to eliminate this code when CONFIG_OLPC=n
>> (due to machine_is_olpc() always returning false).
> 
> Getting rid of the nonexistent config option is clearly the right thing to
> do.  I only wonder about moving the check to viacam_probe().  The nice
> thing about having things fail in viacam_init() is that, if the camera is
> not usable, the module will not load at all.  By the time you get to
> viacam_probe(), the module is there but not will be useful for anything.
> 
> Did the check need to move for some reason?  If so, a one-of-these-days
> nice feature might be to allow changing override_serial at run time.
> 
> Regardless, the behavior change only affects OLPC folks using the serial
> line, so I'm OK with it.
> 
> 	Acked-by: Jonathan Corbet <corbet@lwn.net>

Weird, patchwork didn't catch the acked-by:
	https://patchwork.kernel.org/patch/607461/

Perhaps it only does the right thing if the ack is not indented?

As reference, I'm enclosing what patchwork provides when clicking at the
mbox download hyperlink.

Anyway, manually added.

Thanks!
Mauro

---

>From patchwork Thu Mar  3 19:03:31 2011
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: via-camera: Fix OLPC serial check
Date: Thu, 03 Mar 2011 19:03:31 -0000
From: Daniel Drake <dsd@laptop.org>
X-Patchwork-Id: 607461
Message-Id: <20110303190331.E8ED79D401D@zog.reactivated.net>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org

The code that checks the OLPC serial port is never built at the moment,
because CONFIG_OLPC_XO_1_5 doesn't exist and probably won't be added.

Fix it so that it gets compiled in, only executes on OLPC laptops, and
move the check into the probe routine.

The compiler is smart enough to eliminate this code when CONFIG_OLPC=n
(due to machine_is_olpc() always returning false).

Signed-off-by: Daniel Drake <dsd@laptop.org>

---
drivers/media/video/via-camera.c |   83 +++++++++++++++++---------------------
 1 files changed, 37 insertions(+), 46 deletions(-)

<diff snipped>
