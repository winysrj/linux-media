Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:53006 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755886Ab3BQNks (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Feb 2013 08:40:48 -0500
Received: by mail-ee0-f54.google.com with SMTP id c41so2360353eek.27
        for <linux-media@vger.kernel.org>; Sun, 17 Feb 2013 05:40:47 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 2/2] bttv: move fini_bttv_i2c() from bttv-input.c to bttv-i2c.c
Date: Sun, 17 Feb 2013 14:41:29 +0100
Message-Id: <1361108489-3623-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Like init_bttv_i2c(), fini_bttv_i2c() belongs to bttv-i2c.c.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/pci/bt8xx/bttv-i2c.c   |    8 ++++++++
 drivers/media/pci/bt8xx/bttv-input.c |    8 --------
 drivers/media/pci/bt8xx/bttvp.h      |    5 ++++-
 3 Dateien geändert, 12 Zeilen hinzugefügt(+), 9 Zeilen entfernt(-)

diff --git a/drivers/media/pci/bt8xx/bttv-i2c.c b/drivers/media/pci/bt8xx/bttv-i2c.c
index c63c643..b7c52dc 100644
--- a/drivers/media/pci/bt8xx/bttv-i2c.c
+++ b/drivers/media/pci/bt8xx/bttv-i2c.c
@@ -394,3 +394,11 @@ int init_bttv_i2c(struct bttv *btv)
 
 	return btv->i2c_rc;
 }
+
+int fini_bttv_i2c(struct bttv *btv)
+{
+	if (0 != btv->i2c_rc)
+		return 0;
+
+	return i2c_del_adapter(&btv->c.i2c_adap);
+}
diff --git a/drivers/media/pci/bt8xx/bttv-input.c b/drivers/media/pci/bt8xx/bttv-input.c
index 01c7121..f368213 100644
--- a/drivers/media/pci/bt8xx/bttv-input.c
+++ b/drivers/media/pci/bt8xx/bttv-input.c
@@ -415,14 +415,6 @@ void init_bttv_i2c_ir(struct bttv *btv)
 #endif
 }
 
-int fini_bttv_i2c(struct bttv *btv)
-{
-	if (0 != btv->i2c_rc)
-		return 0;
-
-	return i2c_del_adapter(&btv->c.i2c_adap);
-}
-
 int bttv_input_init(struct bttv *btv)
 {
 	struct bttv_ir *ir;
diff --git a/drivers/media/pci/bt8xx/bttvp.h b/drivers/media/pci/bt8xx/bttvp.h
index 3aacb87..0903547 100644
--- a/drivers/media/pci/bt8xx/bttvp.h
+++ b/drivers/media/pci/bt8xx/bttvp.h
@@ -300,6 +300,10 @@ extern int no_overlay;
 /* bttv-input.c                                               */
 
 extern void init_bttv_i2c_ir(struct bttv *btv);
+
+/* ---------------------------------------------------------- */
+/* bttv-i2c.c                                                 */
+extern int init_bttv_i2c(struct bttv *btv);
 extern int fini_bttv_i2c(struct bttv *btv);
 
 /* ---------------------------------------------------------- */
@@ -310,7 +314,6 @@ extern unsigned int bttv_verbose;
 extern unsigned int bttv_debug;
 extern unsigned int bttv_gpio;
 extern void bttv_gpio_tracking(struct bttv *btv, char *comment);
-extern int init_bttv_i2c(struct bttv *btv);
 
 #define dprintk(fmt, ...)			\
 do {						\
-- 
1.7.10.4

