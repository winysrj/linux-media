Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932417Ab0DPV2C (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Apr 2010 17:28:02 -0400
Date: Fri, 16 Apr 2010 17:27:58 -0400
From: Jarod Wilson <jarod@redhat.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH 1/3] ir-core: make ir_g_keycode_from_table a public function
Message-ID: <20100416212758.GB2427@redhat.com>
References: <20100416212622.GA6888@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100416212622.GA6888@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The imon driver I've previously submitted and have been porting to
use ir-core needs to use ir_g_keycode_from_table, as ir_keydown is
not sufficient, due to these things having really oddball hardware
decoders in them. This just moves the function declaration from
ir-core-priv.h over to ir-core.h.

Signed-off-by: Jarod Wilson <jarod@redhat.com>

---
 drivers/media/IR/ir-core-priv.h |    7 -------
 include/media/ir-core.h         |    1 +
 2 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/media/IR/ir-core-priv.h b/drivers/media/IR/ir-core-priv.h
index ef7f543..d79d91e 100644
--- a/drivers/media/IR/ir-core-priv.h
+++ b/drivers/media/IR/ir-core-priv.h
@@ -57,13 +57,6 @@ struct ir_raw_event_ctrl {
 #define TO_US(duration)		((int)TO_UNITS(duration, 1000))
 
 /*
- * Routines from ir-keytable.c to be used internally on ir-core and decoders
- */
-
-u32 ir_g_keycode_from_table(struct input_dev *input_dev,
-			    u32 scancode);
-
-/*
  * Routines from ir-sysfs.c - Meant to be called only internally inside
  * ir-core
  */
diff --git a/include/media/ir-core.h b/include/media/ir-core.h
index ab3bd30..51e8eb3 100644
--- a/include/media/ir-core.h
+++ b/include/media/ir-core.h
@@ -124,6 +124,7 @@ void ir_input_unregister(struct input_dev *input_dev);
 
 void ir_repeat(struct input_dev *dev);
 void ir_keydown(struct input_dev *dev, int scancode, u8 toggle);
+u32 ir_g_keycode_from_table(struct input_dev *input_dev, u32 scancode);
 
 /* From ir-raw-event.c */
 

-- 
Jarod Wilson
jarod@redhat.com

