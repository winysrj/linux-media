Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47396 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651Ab0JNCoo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Oct 2010 22:44:44 -0400
Subject: Re: [PATCH 0/8 V5] Many fixes for in-kernel decoding and for the
 ENE driver
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: lirc-list@lists.sourceforge.net
Cc: Jarod Wilson <jarod@wilsonet.com>,
	David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	mchehab@infradead.org, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org
In-Reply-To: <1283808373-27876-1-git-send-email-maximlevitsky@gmail.com>
References: <1283808373-27876-1-git-send-email-maximlevitsky@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Oct 2010 04:36:30 +0200
Message-ID: <1287023790.11191.4.camel@maxim-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 2010-09-07 at 00:26 +0300, Maxim Levitsky wrote:
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
> 

Any update?
Should I resent these (didn't change anything I think).
What about other work that conflicts with this?
What are the plans for (very close) merge window?

Best regards,
	Maxim Levitsky


