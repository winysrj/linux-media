Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50033 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781Ab0H3Iwk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Aug 2010 04:52:40 -0400
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: lirc-list@lists.sourceforge.net
Cc: Jarod Wilson <jarod@wilsonet.com>, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Many fixes for in-kernel decoding + ENE driver
Date: Mon, 30 Aug 2010 11:52:20 +0300
Message-Id: <1283158348-7429-1-git-send-email-maximlevitsky@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi,

I did a lot of debug work on this, including a debug session with two users.
I was able to test and fix support for all features ene driver supports.

The patch #1 fixes a bug I introduced
The patch #2 fixes a nasty bug that crashes the system
The patch #3 fixes another small bug in my code
The patch #4 fixes a nasty but that appears as a stuck down forever key

The patch #5 adds a lot of bugfixes, refactoring and support for latest firmware
that without it driver dosn't work.
Driver is fully tested, and works.

in the patch #6 I finally decided to extend ir_raw_event, and encode additional
flags to it. This way I can signal the decoders about last space and yet not
show it up on lirc interface.
Timeout hangling is now moved in lirc bridge where it belongs.
While at it, I also added support for carrier report events,
and patch #6 adds that support to ene driver (tested too).

Best regards,
	Maxim Levitsky


