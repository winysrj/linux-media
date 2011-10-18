Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-out.inet.fi ([195.156.147.13]:44276 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677Ab1JRTn6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Oct 2011 15:43:58 -0400
Date: Tue, 18 Oct 2011 22:37:36 +0300
From: Timo Kokkonen <kaapeli@itanic.dy.fi>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH] saa7134.h: Suppress compiler warnings when
 CONFIG_VIDEO_SAA7134_RC is not set
Message-ID: <20111018193736.GA7519@itanic.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the said config optio is not set, the compiler will spill out many
warnings about statements with no effect, such as:

drivers/media/video/saa7134/saa7134-core.c: In function ‘saa7134_irq’:
drivers/media/video/saa7134/saa7134-core.c:569:7: warning: statement with no effect
drivers/media/video/saa7134/saa7134-core.c:588:7: warning: statement with no effect

Casting the zero to void will cure the warning.

Signed-off-by: Timo Kokkonen <kaapeli@itanic.dy.fi>
---
 drivers/media/video/saa7134/saa7134.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/saa7134/saa7134.h b/drivers/media/video/saa7134/saa7134.h
index bc8d6bb..9b55068 100644
--- a/drivers/media/video/saa7134/saa7134.h
+++ b/drivers/media/video/saa7134/saa7134.h
@@ -843,10 +843,10 @@ void saa7134_probe_i2c_ir(struct saa7134_dev *dev);
 int saa7134_ir_start(struct saa7134_dev *dev);
 void saa7134_ir_stop(struct saa7134_dev *dev);
 #else
-#define saa7134_input_init1(dev)	(0)
-#define saa7134_input_fini(dev)		(0)
-#define saa7134_input_irq(dev)		(0)
-#define saa7134_probe_i2c_ir(dev)	(0)
-#define saa7134_ir_start(dev)		(0)
-#define saa7134_ir_stop(dev)		(0)
+#define saa7134_input_init1(dev)	((void)0)
+#define saa7134_input_fini(dev)		((void)0)
+#define saa7134_input_irq(dev)		((void)0)
+#define saa7134_probe_i2c_ir(dev)	((void)0)
+#define saa7134_ir_start(dev)		((void)0)
+#define saa7134_ir_stop(dev)		((void)0)
 #endif
-- 
1.7.7

