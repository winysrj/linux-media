Return-path: <mchehab@gaivota>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57693 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310Ab0IFV0V (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Sep 2010 17:26:21 -0400
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: lirc-list@lists.sourceforge.net
Cc: Jarod Wilson <jarod@wilsonet.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	mchehab@infradead.org, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: [PATCH 0/8 V5] Many fixes for in-kernel decoding and for the ENE driver
Date: Tue,  7 Sep 2010 00:26:05 +0300
Message-Id: <1283808373-27876-1-git-send-email-maximlevitsky@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi,

Here is full overview of my patches:

Patch #1 fixes races in ir thread.
It fixes the case when ktherad_stop waits forever for the thread.
This happens on module unload and therefore it never finishes.
Sorry for introducing this bug.

Patch #2, fixes a crash on my module load.
It happens because ir core initializes the input device a bit early,
therefore it could be accessed while still not set up.

Patch #3 fixes a small typo in lirc code that makes it impossible to use tx duty cycle setting.

Patch #4 fixes a problem seen on my system that results in stuck down forever key.

Patch #5 adds few keys to MCE keymap that were found on laptop of an user I tested this driver with

Patch #6, is a combined update ti my driver. It contains lot of refactoring thanks to docs I have now,
and lot of fixes, and supports latest version of firmware (and I have 4 users asking for that)
It is quite huge, but it would be a tedios job to break it up. This can't introduce regressions
because the ene_ir was never released. In addition to that it was tested by me and another two users.

Patch #7 the really only patch that touches drivers I don't have does touch the ir-core.
It is quite small, and it adds a proper solution to dilema about what to do with huge space between keypresses.
Now this space is just truncated by the driver with timeout flag.
The lirc codec then ensures that right sample is send to the lircd.
Please review and test it.

Patch #8 is very simple. It just builds on top of patch #7 and adds carrier reports to ene driver.


Best regards,
	Maxim Levitsky





