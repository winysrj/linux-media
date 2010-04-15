Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:52174 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757799Ab0DOVq3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Apr 2010 17:46:29 -0400
Subject: [PATCH 6/8] ir-core: fix double spinlock init in
	drivers/media/IR/rc-map.c
To: mchehab@redhat.com
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, linux-input@vger.kernel.org
Date: Thu, 15 Apr 2010 23:46:25 +0200
Message-ID: <20100415214625.14142.66208.stgit@localhost.localdomain>
In-Reply-To: <20100415214520.14142.56114.stgit@localhost.localdomain>
References: <20100415214520.14142.56114.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix a double initialization of the same spinlock in drivers/media/IR/rc-map.c.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/IR/ir-sysfs.c |    2 --
 drivers/media/IR/rc-map.c   |    5 -----
 2 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/media/IR/ir-sysfs.c b/drivers/media/IR/ir-sysfs.c
index dfd45fa..876baae 100644
--- a/drivers/media/IR/ir-sysfs.c
+++ b/drivers/media/IR/ir-sysfs.c
@@ -294,8 +294,6 @@ static int __init ir_core_init(void)
 
 	/* Initialize/load the decoders/keymap code that will be used */
 	ir_raw_init();
-	rc_map_init();
-
 
 	return 0;
 }
diff --git a/drivers/media/IR/rc-map.c b/drivers/media/IR/rc-map.c
index 1a3f4b1..caf6a27 100644
--- a/drivers/media/IR/rc-map.c
+++ b/drivers/media/IR/rc-map.c
@@ -81,8 +81,3 @@ void ir_unregister_map(struct rc_keymap *map)
 }
 EXPORT_SYMBOL_GPL(ir_unregister_map);
 
-void rc_map_init(void)
-{
-	spin_lock_init(&rc_map_lock);
-
-}

