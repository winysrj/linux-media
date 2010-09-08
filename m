Return-path: <mchehab@pedra>
Received: from bombadil.infradead.org ([18.85.46.34]:42631 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080Ab0IHVyA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Sep 2010 17:54:00 -0400
Message-ID: <4C8805FA.3060102@infradead.org>
Date: Wed, 08 Sep 2010 18:54:02 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 0/8 V5] Many fixes for in-kernel decoding and for the
 ENE driver
References: <1283808373-27876-1-git-send-email-maximlevitsky@gmail.com>
In-Reply-To: <1283808373-27876-1-git-send-email-maximlevitsky@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Em 06-09-2010 18:26, Maxim Levitsky escreveu:
> Hi,
> 
> Here is full overview of my patches:
> 
> Patch #1 fixes races in ir thread.
> It fixes the case when ktherad_stop waits forever for the thread.
> This happens on module unload and therefore it never finishes.
> Sorry for introducing this bug.
> 
> Patch #2, fixes a crash on my module load.
> It happens because ir core initializes the input device a bit early,
> therefore it could be accessed while still not set up.
> 
> Patch #3 fixes a small typo in lirc code that makes it impossible to use tx duty cycle setting.
> 
> Patch #4 fixes a problem seen on my system that results in stuck down forever key.
> 
> Patch #5 adds few keys to MCE keymap that were found on laptop of an user I tested this driver with
> 
> Patch #6, is a combined update ti my driver. It contains lot of refactoring thanks to docs I have now,
> and lot of fixes, and supports latest version of firmware (and I have 4 users asking for that)
> It is quite huge, but it would be a tedios job to break it up. This can't introduce regressions
> because the ene_ir was never released. In addition to that it was tested by me and another two users.
> 
> Patch #7 the really only patch that touches drivers I don't have does touch the ir-core.
> It is quite small, and it adds a proper solution to dilema about what to do with huge space between keypresses.
> Now this space is just truncated by the driver with timeout flag.
> The lirc codec then ensures that right sample is send to the lircd.
> Please review and test it.
> 
> Patch #8 is very simple. It just builds on top of patch #7 and adds carrier reports to ene driver.

For now, I've applied patches 3, 4 and 5, as it is nice to have Jarod's review also.

Cheers,
Mauro
