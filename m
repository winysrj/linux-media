Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:42858 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259Ab1CJQY7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2011 11:24:59 -0500
Date: Thu, 10 Mar 2011 09:24:57 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Daniel Drake <dsd@laptop.org>, dilinger@queued.net
Cc: mchehab@infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] via-camera: Fix OLPC serial check
Message-ID: <20110310092457.2e748f72@bike.lwn.net>
In-Reply-To: <20110303190331.E8ED79D401D@zog.reactivated.net>
References: <20110303190331.E8ED79D401D@zog.reactivated.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

[Trying to bash my inbox into reasonable shape, sorry for the slow
response...]

On Thu,  3 Mar 2011 19:03:31 +0000 (GMT)
Daniel Drake <dsd@laptop.org> wrote:

> The code that checks the OLPC serial port is never built at the moment,
> because CONFIG_OLPC_XO_1_5 doesn't exist and probably won't be added.
> 
> Fix it so that it gets compiled in, only executes on OLPC laptops, and
> move the check into the probe routine.
> 
> The compiler is smart enough to eliminate this code when CONFIG_OLPC=n
> (due to machine_is_olpc() always returning false).

Getting rid of the nonexistent config option is clearly the right thing to
do.  I only wonder about moving the check to viacam_probe().  The nice
thing about having things fail in viacam_init() is that, if the camera is
not usable, the module will not load at all.  By the time you get to
viacam_probe(), the module is there but not will be useful for anything.

Did the check need to move for some reason?  If so, a one-of-these-days
nice feature might be to allow changing override_serial at run time.

Regardless, the behavior change only affects OLPC folks using the serial
line, so I'm OK with it.

	Acked-by: Jonathan Corbet <corbet@lwn.net>

Thanks,

jon

