Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:40349 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754081AbaDCXez (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Apr 2014 19:34:55 -0400
Subject: [PATCH 43/49] rc-core: fix various sparse warnings
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Fri, 04 Apr 2014 01:34:53 +0200
Message-ID: <20140403233453.27099.14425.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
References: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix various sparse warnings under drivers/media/rc/*.c, mostly
by making functions static.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/fintek-cir.c  |    4 ++--
 drivers/media/rc/imon.c        |    8 ++++----
 drivers/media/rc/ite-cir.c     |    4 ++--
 drivers/media/rc/nuvoton-cir.c |    4 ++--
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/media/rc/fintek-cir.c b/drivers/media/rc/fintek-cir.c
index ce2db15..dd49c28 100644
--- a/drivers/media/rc/fintek-cir.c
+++ b/drivers/media/rc/fintek-cir.c
@@ -685,12 +685,12 @@ static struct pnp_driver fintek_driver = {
 	.shutdown	= fintek_shutdown,
 };
 
-static int fintek_init(void)
+static int __init fintek_init(void)
 {
 	return pnp_register_driver(&fintek_driver);
 }
 
-static void fintek_exit(void)
+static void __exit fintek_exit(void)
 {
 	pnp_unregister_driver(&fintek_driver);
 }
diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 1aa2ac0..287edf6 100644
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
@@ -825,7 +825,7 @@ static struct attribute_group imon_rf_attr_group = {
  * than 32 bytes are provided spaces will be appended to
  * generate a full screen.
  */
-static ssize_t vfd_write(struct file *file, const char *buf,
+static ssize_t vfd_write(struct file *file, const char __user *buf,
 			 size_t n_bytes, loff_t *pos)
 {
 	int i;
@@ -912,7 +912,7 @@ exit:
  * display whatever diacritics you need, and so on), but it's also
  * a lot more complicated than most LCDs...
  */
-static ssize_t lcd_write(struct file *file, const char *buf,
+static ssize_t lcd_write(struct file *file, const char __user *buf,
 			 size_t n_bytes, loff_t *pos)
 {
 	int retval = 0;
diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index 795fbc6..2755e06 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -1703,12 +1703,12 @@ static struct pnp_driver ite_driver = {
 	.shutdown	= ite_shutdown,
 };
 
-static int ite_init(void)
+static int __init ite_init(void)
 {
 	return pnp_register_driver(&ite_driver);
 }
 
-static void ite_exit(void)
+static void __exit ite_exit(void)
 {
 	pnp_unregister_driver(&ite_driver);
 }
diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index a8c9b5f..9e63ee6 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -1231,12 +1231,12 @@ static struct pnp_driver nvt_driver = {
 	.shutdown	= nvt_shutdown,
 };
 
-static int nvt_init(void)
+static int __init nvt_init(void)
 {
 	return pnp_register_driver(&nvt_driver);
 }
 
-static void nvt_exit(void)
+static void __exit nvt_exit(void)
 {
 	pnp_unregister_driver(&nvt_driver);
 }

