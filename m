Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:54726 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803Ab3CFUw1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2013 15:52:27 -0500
Subject: [PATCH 3/3] rc-core: initialize rc-core earlier if built-in
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@redhat.com, sean@mess.org
Date: Wed, 06 Mar 2013 21:52:15 +0100
Message-ID: <20130306205215.12635.51117.stgit@zeus.hardeman.nu>
In-Reply-To: <20130306205057.12635.59234.stgit@zeus.hardeman.nu>
References: <20130306205057.12635.59234.stgit@zeus.hardeman.nu>
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
index c56650c..1cf382a 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1195,7 +1195,7 @@ static void __exit rc_core_exit(void)
 	rc_map_unregister(&empty_map);
 }
 
-module_init(rc_core_init);
+subsys_initcall(rc_core_init);
 module_exit(rc_core_exit);
 
 int rc_core_debug;    /* ir_debug level (0,1,2) */

