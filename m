Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:52559 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063AbbGTTQ2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 15:16:28 -0400
Subject: [PATCH 0/7] rc-core: Revert encoding patchset
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Mon, 20 Jul 2015 21:16:26 +0200
Message-ID: <20150720191238.24633.85293.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current code is not mature enough, the API should allow a single
protocol to be specified. Also, the current code contains heuristics
that will depend on module load order.

The issues were discussed in this thread:
https://www.mail-archive.com/linux-media@vger.kernel.org/msg86998.html

And Antti agreed at the end of the thread:
https://www.mail-archive.com/linux-media@vger.kernel.org/msg86998.html

This needs to go in upstream before 4.2 is released.

Signed-off-by: David Härdeman <david@hardeman.nu>

---

David Härdeman (7):
      Revert "[media] rc: nuvoton-cir: Add support for writing wakeup samples via sysfs filter callback"
      Revert "[media] rc: rc-loopback: Add loopback of filter scancodes"
      Revert "[media] rc: rc-core: Add support for encode_wakeup drivers"
      Revert "[media] rc: ir-rc6-decoder: Add encode capability"
      Revert "[media] rc: ir-rc5-decoder: Add encode capability"
      Revert "[media] rc: rc-ir-raw: Add Manchester encoder (phase encoder) helper"
      Revert "[media] rc: rc-ir-raw: Add scancode encoder callback"


 drivers/media/rc/ir-rc5-decoder.c |  116 -------------------------------
 drivers/media/rc/ir-rc6-decoder.c |  122 --------------------------------
 drivers/media/rc/nuvoton-cir.c    |  127 ----------------------------------
 drivers/media/rc/nuvoton-cir.h    |    1 
 drivers/media/rc/rc-core-priv.h   |   36 ----------
 drivers/media/rc/rc-ir-raw.c      |  139 -------------------------------------
 drivers/media/rc/rc-loopback.c    |   36 ----------
 drivers/media/rc/rc-main.c        |    7 --
 include/media/rc-core.h           |    7 --
 9 files changed, 1 insertion(+), 590 deletions(-)

--
David Härdeman
