Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:44280 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933148Ab2EWJy4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 05:54:56 -0400
Subject: [PATCH 36/43] rc-core: fix various sparse warnings
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@redhat.com, jarod@redhat.com
Date: Wed, 23 May 2012 11:45:09 +0200
Message-ID: <20120523094509.14474.57920.stgit@felix.hardeman.nu>
In-Reply-To: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
References: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix various sparse warnings under drivers/media/rc/*.c, mostly
by making functions static.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/ene_ir.c      |    2 +-
 drivers/media/rc/fintek-cir.c  |    4 ++--
 drivers/media/rc/imon.c        |    8 ++++----
 drivers/media/rc/ite-cir.c     |    4 ++--
 drivers/media/rc/nuvoton-cir.c |    4 ++--
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index eb107e8..2c2cfd5 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -329,7 +329,7 @@ static int ene_rx_get_sample_reg(struct ene_device *dev)
 }
 
 /* Sense current received carrier */
-void ene_rx_sense_carrier(struct ene_device *dev)
+static void ene_rx_sense_carrier(struct ene_device *dev)
 {
 	DEFINE_IR_RAW_EVENT(ev);
 
diff --git a/drivers/media/rc/fintek-cir.c b/drivers/media/rc/fintek-cir.c
index 01e6ef8..ac949ae 100644
--- a/drivers/media/rc/fintek-cir.c
+++ b/drivers/media/rc/fintek-cir.c
@@ -675,12 +675,12 @@ static struct pnp_driver fintek_driver = {
 	.shutdown	= fintek_shutdown,
 };
 
-int fintek_init(void)
+static int __init fintek_init(void)
 {
 	return pnp_register_driver(&fintek_driver);
 }
 
-void fintek_exit(void)
+static void __exit fintek_exit(void)
 {
 	pnp_unregister_driver(&fintek_driver);
 }
diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index d98778b..8573977 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -78,11 +78,11 @@ static int display_open(struct inode *inode, struct file *file);
 static int display_close(struct inode *inode, struct file *file);
 
 /* VFD write operation */
-static ssize_t vfd_write(struct file *file, const char *buf,
+static ssize_t vfd_write(struct file *file, const char __user *buf,
 			 size_t n_bytes, loff_t *pos);
 
 /* LCD file_operations override function prototypes */
-static ssize_t lcd_write(struct file *file, const char *buf,
+static ssize_t lcd_write(struct file *file, const char __user *buf,
 			 size_t n_bytes, loff_t *pos);
 
 /*** G L O B A L S ***/
@@ -818,7 +818,7 @@ static struct attribute_group imon_rf_attr_group = {
  * than 32 bytes are provided spaces will be appended to
  * generate a full screen.
  */
-static ssize_t vfd_write(struct file *file, const char *buf,
+static ssize_t vfd_write(struct file *file, const char __user *buf,
 			 size_t n_bytes, loff_t *pos)
 {
 	int i;
@@ -905,7 +905,7 @@ exit:
  * display whatever diacritics you need, and so on), but it's also
  * a lot more complicated than most LCDs...
  */
-static ssize_t lcd_write(struct file *file, const char *buf,
+static ssize_t lcd_write(struct file *file, const char __user *buf,
 			 size_t n_bytes, loff_t *pos)
 {
 	int retval = 0;
diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index 6721767..44759db 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -1705,12 +1705,12 @@ static struct pnp_driver ite_driver = {
 	.shutdown	= ite_shutdown,
 };
 
-int ite_init(void)
+static int __init ite_init(void)
 {
 	return pnp_register_driver(&ite_driver);
 }
 
-void ite_exit(void)
+static void __exit ite_exit(void)
 {
 	pnp_unregister_driver(&ite_driver);
 }
diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 0548db4..915074e 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -1223,12 +1223,12 @@ static struct pnp_driver nvt_driver = {
 	.shutdown	= nvt_shutdown,
 };
 
-int nvt_init(void)
+static int __init nvt_init(void)
 {
 	return pnp_register_driver(&nvt_driver);
 }
 
-void nvt_exit(void)
+static void __exit nvt_exit(void)
 {
 	pnp_unregister_driver(&nvt_driver);
 }

