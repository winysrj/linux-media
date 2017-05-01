Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:41388 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752535AbdEAQJx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 May 2017 12:09:53 -0400
Subject: [PATCH 0/7] rc: don't poke around in rc_dev internals
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Mon, 01 May 2017 18:09:51 +0200
Message-ID: <149365487447.13489.15793446874818182829.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following patch series fixes up various drivers which go
poking around in struct rc_dev for no good reason.

---

David Härdeman (7):
      rc-core: ati_remote - leave the internals of rc_dev alone
      rc-core: img-ir - leave the internals of rc_dev alone
      rc-core: img-nec-decoder - leave the internals of rc_dev alone
      rc-core: sanyo - leave the internals of rc_dev alone
      rc-core: ir-raw - leave the internals of rc_dev alone
      rc-core: cx231xx - leave the internals of rc_dev alone
      rc-core: tm6000 - leave the internals of rc_dev alone


 drivers/media/rc/ati_remote.c             |    3 ---
 drivers/media/rc/img-ir/img-ir-hw.c       |    4 ----
 drivers/media/rc/ir-nec-decoder.c         |   10 +++-------
 drivers/media/rc/ir-sanyo-decoder.c       |   10 +++-------
 drivers/media/rc/rc-ir-raw.c              |    4 +---
 drivers/media/usb/cx231xx/cx231xx-input.c |    5 ++---
 drivers/media/usb/tm6000/tm6000-input.c   |    4 ----
 7 files changed, 9 insertions(+), 31 deletions(-)

--
David Härdeman
