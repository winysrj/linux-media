Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:40379 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab2HYVrc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Aug 2012 17:47:32 -0400
Subject: [PATCH 8/8] rc-core: initialize rc-core earlier if built-in
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: jwilson@redhat.com, mchehab@redhat.com, sean@mess.org
Date: Sat, 25 Aug 2012 23:47:29 +0200
Message-ID: <20120825214729.22603.49937.stgit@localhost.localdomain>
In-Reply-To: <20120825214520.22603.37194.stgit@localhost.localdomain>
References: <20120825214520.22603.37194.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

rc-core is a subsystem so it should be registered earlier if built into the
kernel.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index ec7311f..8134bd8 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1327,7 +1327,7 @@ static void __exit rc_core_exit(void)
 	rc_map_unregister(&empty_map);
 }
 
-module_init(rc_core_init);
+subsys_initcall(rc_core_init);
 module_exit(rc_core_exit);
 
 int rc_core_debug;    /* ir_debug level (0,1,2) */

