Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:54716 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab3CFUwN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2013 15:52:13 -0500
Subject: [PATCH 0/3] rc-core fixes
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@redhat.com, sean@mess.org
Date: Wed, 06 Mar 2013 21:52:00 +0100
Message-ID: <20130306205057.12635.59234.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Three minor patches for rc-core...(against the for_v3.9 branch)

---

David Härdeman (3):
      rc-core: don't treat dev->rc_map.rc_type as a bitmap
      rc-core: rename ir_input_class to rc_class
      rc-core: initialize rc-core earlier if built-in


 drivers/media/i2c/ir-kbd-i2c.c        |    1 +
 drivers/media/rc/ir-jvc-decoder.c     |    2 +
 drivers/media/rc/ir-lirc-codec.c      |    2 +
 drivers/media/rc/ir-mce_kbd-decoder.c |    2 +
 drivers/media/rc/ir-nec-decoder.c     |    2 +
 drivers/media/rc/ir-raw.c             |    2 +
 drivers/media/rc/ir-rc5-decoder.c     |    6 ++--
 drivers/media/rc/ir-rc5-sz-decoder.c  |    2 +
 drivers/media/rc/ir-rc6-decoder.c     |    2 +
 drivers/media/rc/ir-sanyo-decoder.c   |    2 +
 drivers/media/rc/ir-sony-decoder.c    |    8 +++---
 drivers/media/rc/rc-core-priv.h       |    1 -
 drivers/media/rc/rc-main.c            |   46 ++++++++++++---------------------
 include/media/rc-core.h               |    2 +
 14 files changed, 35 insertions(+), 45 deletions(-)

-- 
David Härdeman

