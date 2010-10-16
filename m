Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46315 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980Ab0JPXEP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Oct 2010 19:04:15 -0400
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: lirc-list@lists.sourceforge.net
Cc: Jarod Wilson <jarod@wilsonet.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	mchehab@infradead.org, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: [PATCH 0/3] Remaining patches in my queue for IR
Date: Sun, 17 Oct 2010 00:56:27 +0200
Message-Id: <1287269790-17605-1-git-send-email-maximlevitsky@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

This series is rebased on top of media_tree/staging/v2.6.37 only.
Really this time, sorry for cheating, last time :-)

The first patch like we agreed extends the raw packets.
It touches all drivers (except imon as it isn't a raw IR driver).
Code is compile tested with all drivers, 
and run tested with ENE and all receiver protocols
(except the streamzap rc5 flavour)
Since it also moves timeouts to lirc bridge, at least streazap driver
should have its timeout gap support removed. I am afraid to break the code
if I do so.

Other 2 patches are ENE specific, and don't touch anything else.

Please test other drivers.

Best regards,
	Maxim Levitsky

