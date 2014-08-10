Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55295 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbaHJArh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Aug 2014 20:47:37 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Shuah Khan <shuah.kh@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH v2 03/18] [media] au0828: add au0828_rc_*() stubs for VIDEO_AU0828_RC disabled case
Date: Sat,  9 Aug 2014 21:47:09 -0300
Message-Id: <1407631644-11990-4-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1407631644-11990-1-git-send-email-m.chehab@samsung.com>
References: <1407631644-11990-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Shuah Khan <shuah.kh@samsung.com>

Define au0828_rc_*() stubs to avoid compile errors when
VIDEO_AU0828_RC is disabled and avoid the need to enclose
au0828_rc_*() in ifdef CONFIG_VIDEO_AU0828_RC in .c files.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/au0828/au0828.h | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index 96bec05d7dac..fd0916e20323 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -326,7 +326,14 @@ extern struct videobuf_queue_ops au0828_vbi_qops;
 	} while (0)
 
 /* au0828-input.c */
-int au0828_rc_register(struct au0828_dev *dev);
-void au0828_rc_unregister(struct au0828_dev *dev);
-int au0828_rc_suspend(struct au0828_dev *dev);
-int au0828_rc_resume(struct au0828_dev *dev);
+#ifdef CONFIG_VIDEO_AU0828_RC
+extern int au0828_rc_register(struct au0828_dev *dev);
+extern void au0828_rc_unregister(struct au0828_dev *dev);
+extern int au0828_rc_suspend(struct au0828_dev *dev);
+extern int au0828_rc_resume(struct au0828_dev *dev);
+#else
+static inline int au0828_rc_register(struct au0828_dev *dev) { return 0; }
+static inline void au0828_rc_unregister(struct au0828_dev *dev) { }
+static inline int au0828_rc_suspend(struct au0828_dev *dev) { return 0; }
+static inline int au0828_rc_resume(struct au0828_dev *dev) { return 0; }
+#endif
-- 
1.9.3

