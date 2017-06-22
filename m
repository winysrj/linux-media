Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:52761 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752743AbdFVTXw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Jun 2017 15:23:52 -0400
Subject: [PATCH 0/2] rc-core: consistent rc_repeat() usage
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Thu, 22 Jun 2017 21:23:49 +0200
Message-ID: <149815927618.22167.7035029052539207589.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These two patches are a reworked version of these two patches:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg112170.html
http://www.mail-archive.com/linux-media@vger.kernel.org/msg112163.html

The first patch changes the NEC and Sanyo decoders as discussed in those
threads, moving the keydown check into rc_repeat() where the proper
locking is done.

The second patch I'd consider optional, it removes the input events for
repeat messages which I consider to be rather pointless.

---

David Härdeman (2):
      rc-core: consistent use of rc_repeat()
      rc-main: remove input events for repeat messages


 drivers/media/rc/ir-nec-decoder.c   |   10 +++-------
 drivers/media/rc/ir-sanyo-decoder.c |   10 +++-------
 drivers/media/rc/rc-main.c          |   13 ++++---------
 3 files changed, 10 insertions(+), 23 deletions(-)

--
David Härdeman
