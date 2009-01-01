Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n017s6Rp008304
	for <video4linux-list@redhat.com>; Thu, 1 Jan 2009 02:54:06 -0500
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.186])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n017rpSm014000
	for <video4linux-list@redhat.com>; Thu, 1 Jan 2009 02:53:51 -0500
Received: by nf-out-0910.google.com with SMTP id d3so730266nfc.21
	for <video4linux-list@redhat.com>; Wed, 31 Dec 2008 23:53:49 -0800 (PST)
From: Alexey Klimov <klimov.linux@gmail.com>
To: Jean-Francois Moine <moinejf@free.fr>
Content-Type: text/plain
Date: Thu, 01 Jan 2009 10:53:48 +0300
Message-Id: <1230796428.5124.15.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: [PATCH] gspca: fix codingstyle in sd_mod_init
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hello, Jean-Francois
What do you think about this patch ?

Fix CodingStyle in sd_mod_init function in all gspca drivers.
Introduce int ret and check it value after call to usb_register().


Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

---
diff -r b9092fca16f0 linux/drivers/media/video/gspca/conex.c
--- a/linux/drivers/media/video/gspca/conex.c	Thu Jan 01 10:41:53 2009 +0300
+++ b/linux/drivers/media/video/gspca/conex.c	Thu Jan 01 10:45:02 2009 +0300
@@ -1028,7 +1028,9 @@
 /* -- module insert / remove -- */
 static int __init sd_mod_init(void)
 {
-	if (usb_register(&sd_driver) < 0)
+	int ret;
+	ret = usb_register(&sd_driver);
+	if (ret < 0)
 		return -1;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
diff -r b9092fca16f0 linux/drivers/media/video/gspca/etoms.c
--- a/linux/drivers/media/video/gspca/etoms.c	Thu Jan 01 10:41:53 2009 +0300
+++ b/linux/drivers/media/video/gspca/etoms.c	Thu Jan 01 10:45:02 2009 +0300
@@ -933,7 +933,9 @@
 /* -- module insert / remove -- */
 static int __init sd_mod_init(void)
 {
-	if (usb_register(&sd_driver) < 0)
+	int ret;
+	ret = usb_register(&sd_driver);
+	if (ret < 0)
 		return -1;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
diff -r b9092fca16f0 linux/drivers/media/video/gspca/finepix.c
--- a/linux/drivers/media/video/gspca/finepix.c	Thu Jan 01 10:41:53 2009 +0300
+++ b/linux/drivers/media/video/gspca/finepix.c	Thu Jan 01 10:45:02 2009 +0300
@@ -454,7 +454,9 @@
 /* -- module insert / remove -- */
 static int __init sd_mod_init(void)
 {
-	if (usb_register(&sd_driver) < 0)
+	int ret;
+	ret = usb_register(&sd_driver);
+	if (ret < 0)
 		return -1;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
diff -r b9092fca16f0 linux/drivers/media/video/gspca/m5602/m5602_core.c
--- a/linux/drivers/media/video/gspca/m5602/m5602_core.c	Thu Jan 01 10:41:53 2009 +0300
+++ b/linux/drivers/media/video/gspca/m5602/m5602_core.c	Thu Jan 01 10:45:02 2009 +0300
@@ -373,7 +373,9 @@
 /* -- module insert / remove -- */
 static int __init mod_m5602_init(void)
 {
-	if (usb_register(&sd_driver) < 0)
+	int ret;
+	ret = usb_register(&sd_driver);
+	if (ret < 0)
 		return -1;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
diff -r b9092fca16f0 linux/drivers/media/video/gspca/mars.c
--- a/linux/drivers/media/video/gspca/mars.c	Thu Jan 01 10:41:53 2009 +0300
+++ b/linux/drivers/media/video/gspca/mars.c	Thu Jan 01 10:45:02 2009 +0300
@@ -420,7 +420,9 @@
 /* -- module insert / remove -- */
 static int __init sd_mod_init(void)
 {
-	if (usb_register(&sd_driver) < 0)
+	int ret;
+	ret = usb_register(&sd_driver);
+	if (ret < 0)
 		return -1;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
diff -r b9092fca16f0 linux/drivers/media/video/gspca/ov519.c
--- a/linux/drivers/media/video/gspca/ov519.c	Thu Jan 01 10:41:53 2009 +0300
+++ b/linux/drivers/media/video/gspca/ov519.c	Thu Jan 01 10:45:02 2009 +0300
@@ -2201,7 +2201,9 @@
 /* -- module insert / remove -- */
 static int __init sd_mod_init(void)
 {
-	if (usb_register(&sd_driver) < 0)
+	int ret;
+	ret = usb_register(&sd_driver);
+	if (ret < 0)
 		return -1;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
diff -r b9092fca16f0 linux/drivers/media/video/gspca/ov534.c
--- a/linux/drivers/media/video/gspca/ov534.c	Thu Jan 01 10:41:53 2009 +0300
+++ b/linux/drivers/media/video/gspca/ov534.c	Thu Jan 01 10:45:02 2009 +0300
@@ -584,7 +584,9 @@
 /* -- module insert / remove -- */
 static int __init sd_mod_init(void)
 {
-	if (usb_register(&sd_driver) < 0)
+	int ret;
+	ret = usb_register(&sd_driver);
+	if (ret < 0)
 		return -1;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
diff -r b9092fca16f0 linux/drivers/media/video/gspca/pac207.c
--- a/linux/drivers/media/video/gspca/pac207.c	Thu Jan 01 10:41:53 2009 +0300
+++ b/linux/drivers/media/video/gspca/pac207.c	Thu Jan 01 10:45:02 2009 +0300
@@ -564,7 +564,9 @@
 /* -- module insert / remove -- */
 static int __init sd_mod_init(void)
 {
-	if (usb_register(&sd_driver) < 0)
+	int ret;
+	ret = usb_register(&sd_driver);
+	if (ret < 0)
 		return -1;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
diff -r b9092fca16f0 linux/drivers/media/video/gspca/pac7311.c
--- a/linux/drivers/media/video/gspca/pac7311.c	Thu Jan 01 10:41:53 2009 +0300
+++ b/linux/drivers/media/video/gspca/pac7311.c	Thu Jan 01 10:45:02 2009 +0300
@@ -1110,7 +1110,9 @@
 /* -- module insert / remove -- */
 static int __init sd_mod_init(void)
 {
-	if (usb_register(&sd_driver) < 0)
+	int ret;
+	ret = usb_register(&sd_driver);
+	if (ret < 0)
 		return -1;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
diff -r b9092fca16f0 linux/drivers/media/video/gspca/sonixb.c
--- a/linux/drivers/media/video/gspca/sonixb.c	Thu Jan 01 10:41:53 2009 +0300
+++ b/linux/drivers/media/video/gspca/sonixb.c	Thu Jan 01 10:45:02 2009 +0300
@@ -1301,7 +1301,9 @@
 /* -- module insert / remove -- */
 static int __init sd_mod_init(void)
 {
-	if (usb_register(&sd_driver) < 0)
+	int ret;
+	ret = usb_register(&sd_driver);
+	if (ret < 0)
 		return -1;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
diff -r b9092fca16f0 linux/drivers/media/video/gspca/sonixj.c
--- a/linux/drivers/media/video/gspca/sonixj.c	Thu Jan 01 10:41:53 2009 +0300
+++ b/linux/drivers/media/video/gspca/sonixj.c	Thu Jan 01 10:45:02 2009 +0300
@@ -1809,7 +1809,9 @@
 /* -- module insert / remove -- */
 static int __init sd_mod_init(void)
 {
-	if (usb_register(&sd_driver) < 0)
+	int ret;
+	ret = usb_register(&sd_driver);
+	if (ret < 0)
 		return -1;
 	info("registered");
 	return 0;
diff -r b9092fca16f0 linux/drivers/media/video/gspca/spca500.c
--- a/linux/drivers/media/video/gspca/spca500.c	Thu Jan 01 10:41:53 2009 +0300
+++ b/linux/drivers/media/video/gspca/spca500.c	Thu Jan 01 10:45:02 2009 +0300
@@ -1109,7 +1109,9 @@
 /* -- module insert / remove -- */
 static int __init sd_mod_init(void)
 {
-	if (usb_register(&sd_driver) < 0)
+	int ret;
+	ret = usb_register(&sd_driver);
+	if (ret < 0)
 		return -1;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
diff -r b9092fca16f0 linux/drivers/media/video/gspca/spca501.c
--- a/linux/drivers/media/video/gspca/spca501.c	Thu Jan 01 10:41:53 2009 +0300
+++ b/linux/drivers/media/video/gspca/spca501.c	Thu Jan 01 10:45:02 2009 +0300
@@ -2258,7 +2258,9 @@
 /* -- module insert / remove -- */
 static int __init sd_mod_init(void)
 {
-	if (usb_register(&sd_driver) < 0)
+	int ret;
+	ret = usb_register(&sd_driver);
+	if (ret < 0)
 		return -1;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
diff -r b9092fca16f0 linux/drivers/media/video/gspca/spca505.c
--- a/linux/drivers/media/video/gspca/spca505.c	Thu Jan 01 10:41:53 2009 +0300
+++ b/linux/drivers/media/video/gspca/spca505.c	Thu Jan 01 10:45:02 2009 +0300
@@ -931,7 +931,9 @@
 /* -- module insert / remove -- */
 static int __init sd_mod_init(void)
 {
-	if (usb_register(&sd_driver) < 0)
+	int ret;
+	ret = usb_register(&sd_driver);
+	if (ret < 0)
 		return -1;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
diff -r b9092fca16f0 linux/drivers/media/video/gspca/spca506.c
--- a/linux/drivers/media/video/gspca/spca506.c	Thu Jan 01 10:41:53 2009 +0300
+++ b/linux/drivers/media/video/gspca/spca506.c	Thu Jan 01 10:45:02 2009 +0300
@@ -771,7 +771,9 @@
 /* -- module insert / remove -- */
 static int __init sd_mod_init(void)
 {
-	if (usb_register(&sd_driver) < 0)
+	int ret;
+	ret = usb_register(&sd_driver);
+	if (ret < 0)
 		return -1;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
diff -r b9092fca16f0 linux/drivers/media/video/gspca/spca508.c
--- a/linux/drivers/media/video/gspca/spca508.c	Thu Jan 01 10:41:53 2009 +0300
+++ b/linux/drivers/media/video/gspca/spca508.c	Thu Jan 01 10:45:02 2009 +0300
@@ -1703,7 +1703,9 @@
 /* -- module insert / remove -- */
 static int __init sd_mod_init(void)
 {
-	if (usb_register(&sd_driver) < 0)
+	int ret;
+	ret = usb_register(&sd_driver);
+	if (ret < 0)
 		return -1;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
diff -r b9092fca16f0 linux/drivers/media/video/gspca/spca561.c
--- a/linux/drivers/media/video/gspca/spca561.c	Thu Jan 01 10:41:53 2009 +0300
+++ b/linux/drivers/media/video/gspca/spca561.c	Thu Jan 01 10:45:02 2009 +0300
@@ -1203,7 +1203,9 @@
 /* -- module insert / remove -- */
 static int __init sd_mod_init(void)
 {
-	if (usb_register(&sd_driver) < 0)
+	int ret;
+	ret = usb_register(&sd_driver);
+	if (ret < 0)
 		return -1;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
diff -r b9092fca16f0 linux/drivers/media/video/gspca/stk014.c
--- a/linux/drivers/media/video/gspca/stk014.c	Thu Jan 01 10:41:53 2009 +0300
+++ b/linux/drivers/media/video/gspca/stk014.c	Thu Jan 01 10:45:02 2009 +0300
@@ -560,7 +560,9 @@
 /* -- module insert / remove -- */
 static int __init sd_mod_init(void)
 {
-	if (usb_register(&sd_driver) < 0)
+	int ret;
+	ret = usb_register(&sd_driver);
+	if (ret < 0)
 		return -1;
 	info("registered");
 	return 0;
diff -r b9092fca16f0 linux/drivers/media/video/gspca/stv06xx/stv06xx.c
--- a/linux/drivers/media/video/gspca/stv06xx/stv06xx.c	Thu Jan 01 10:41:53 2009 +0300
+++ b/linux/drivers/media/video/gspca/stv06xx/stv06xx.c	Thu Jan 01 10:45:02 2009 +0300
@@ -500,7 +500,9 @@
 /* -- module insert / remove -- */
 static int __init sd_mod_init(void)
 {
-	if (usb_register(&sd_driver) < 0)
+	int ret;
+	ret = usb_register(&sd_driver);
+	if (ret < 0)
 		return -1;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
diff -r b9092fca16f0 linux/drivers/media/video/gspca/sunplus.c
--- a/linux/drivers/media/video/gspca/sunplus.c	Thu Jan 01 10:41:53 2009 +0300
+++ b/linux/drivers/media/video/gspca/sunplus.c	Thu Jan 01 10:45:02 2009 +0300
@@ -1495,7 +1495,9 @@
 /* -- module insert / remove -- */
 static int __init sd_mod_init(void)
 {
-	if (usb_register(&sd_driver) < 0)
+	int ret;
+	ret = usb_register(&sd_driver);
+	if (ret < 0)
 		return -1;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
diff -r b9092fca16f0 linux/drivers/media/video/gspca/t613.c
--- a/linux/drivers/media/video/gspca/t613.c	Thu Jan 01 10:41:53 2009 +0300
+++ b/linux/drivers/media/video/gspca/t613.c	Thu Jan 01 10:45:02 2009 +0300
@@ -1175,7 +1175,9 @@
 /* -- module insert / remove -- */
 static int __init sd_mod_init(void)
 {
-	if (usb_register(&sd_driver) < 0)
+	int ret;
+	ret = usb_register(&sd_driver);
+	if (ret < 0)
 		return -1;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
diff -r b9092fca16f0 linux/drivers/media/video/gspca/tv8532.c
--- a/linux/drivers/media/video/gspca/tv8532.c	Thu Jan 01 10:41:53 2009 +0300
+++ b/linux/drivers/media/video/gspca/tv8532.c	Thu Jan 01 10:45:02 2009 +0300
@@ -578,7 +578,9 @@
 /* -- module insert / remove -- */
 static int __init sd_mod_init(void)
 {
-	if (usb_register(&sd_driver) < 0)
+	int ret;
+	ret = usb_register(&sd_driver);
+	if (ret < 0)
 		return -1;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
diff -r b9092fca16f0 linux/drivers/media/video/gspca/vc032x.c
--- a/linux/drivers/media/video/gspca/vc032x.c	Thu Jan 01 10:41:53 2009 +0300
+++ b/linux/drivers/media/video/gspca/vc032x.c	Thu Jan 01 10:45:02 2009 +0300
@@ -2485,7 +2485,9 @@
 /* -- module insert / remove -- */
 static int __init sd_mod_init(void)
 {
-	if (usb_register(&sd_driver) < 0)
+	int ret;
+	ret = usb_register(&sd_driver);
+	if (ret < 0)
 		return -1;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
diff -r b9092fca16f0 linux/drivers/media/video/gspca/zc3xx.c
--- a/linux/drivers/media/video/gspca/zc3xx.c	Thu Jan 01 10:41:53 2009 +0300
+++ b/linux/drivers/media/video/gspca/zc3xx.c	Thu Jan 01 10:45:02 2009 +0300
@@ -7608,7 +7608,9 @@
 
 static int __init sd_mod_init(void)
 {
-	if (usb_register(&sd_driver) < 0)
+	int ret;
+	ret = usb_register(&sd_driver);
+	if (ret < 0)
 		return -1;
 	PDEBUG(D_PROBE, "registered");
 	return 0;


-- 
Best regards, Klimov Alexey

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
