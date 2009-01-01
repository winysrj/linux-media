Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n018Ml6S013504
	for <video4linux-list@redhat.com>; Thu, 1 Jan 2009 03:22:47 -0500
Received: from ey-out-2122.google.com (ey-out-2122.google.com [74.125.78.24])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n018MWqV025732
	for <video4linux-list@redhat.com>; Thu, 1 Jan 2009 03:22:32 -0500
Received: by ey-out-2122.google.com with SMTP id 4so561460eyf.39
	for <video4linux-list@redhat.com>; Thu, 01 Jan 2009 00:22:31 -0800 (PST)
From: Alexey Klimov <klimov.linux@gmail.com>
To: Jean-Francois Moine <moinejf@free.fr>
Content-Type: text/plain
Date: Thu, 01 Jan 2009 11:22:30 +0300
Message-Id: <1230798150.5124.29.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: [PATCH] gspca: return ret instead of -1 in sd_mod_init
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

With this patch sd_mod_init will return ret variable in all gspca
modules if error occurs.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

---
diff -r 713c9693b912 linux/drivers/media/video/gspca/conex.c
--- a/linux/drivers/media/video/gspca/conex.c	Thu Jan 01 11:07:09 2009 +0300
+++ b/linux/drivers/media/video/gspca/conex.c	Thu Jan 01 11:20:00 2009 +0300
@@ -1031,7 +1031,7 @@
 	int ret;
 	ret = usb_register(&sd_driver);
 	if (ret < 0)
-		return -1;
+		return ret;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
 }
diff -r 713c9693b912 linux/drivers/media/video/gspca/etoms.c
--- a/linux/drivers/media/video/gspca/etoms.c	Thu Jan 01 11:07:09 2009 +0300
+++ b/linux/drivers/media/video/gspca/etoms.c	Thu Jan 01 11:20:00 2009 +0300
@@ -936,7 +936,7 @@
 	int ret;
 	ret = usb_register(&sd_driver);
 	if (ret < 0)
-		return -1;
+		return ret;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
 }
diff -r 713c9693b912 linux/drivers/media/video/gspca/finepix.c
--- a/linux/drivers/media/video/gspca/finepix.c	Thu Jan 01 11:07:09 2009 +0300
+++ b/linux/drivers/media/video/gspca/finepix.c	Thu Jan 01 11:20:00 2009 +0300
@@ -457,7 +457,7 @@
 	int ret;
 	ret = usb_register(&sd_driver);
 	if (ret < 0)
-		return -1;
+		return ret;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
 }
diff -r 713c9693b912 linux/drivers/media/video/gspca/m5602/m5602_core.c
--- a/linux/drivers/media/video/gspca/m5602/m5602_core.c	Thu Jan 01 11:07:09 2009 +0300
+++ b/linux/drivers/media/video/gspca/m5602/m5602_core.c	Thu Jan 01 11:20:00 2009 +0300
@@ -376,7 +376,7 @@
 	int ret;
 	ret = usb_register(&sd_driver);
 	if (ret < 0)
-		return -1;
+		return ret;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
 }
diff -r 713c9693b912 linux/drivers/media/video/gspca/mars.c
--- a/linux/drivers/media/video/gspca/mars.c	Thu Jan 01 11:07:09 2009 +0300
+++ b/linux/drivers/media/video/gspca/mars.c	Thu Jan 01 11:20:00 2009 +0300
@@ -423,7 +423,7 @@
 	int ret;
 	ret = usb_register(&sd_driver);
 	if (ret < 0)
-		return -1;
+		return ret;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
 }
diff -r 713c9693b912 linux/drivers/media/video/gspca/ov519.c
--- a/linux/drivers/media/video/gspca/ov519.c	Thu Jan 01 11:07:09 2009 +0300
+++ b/linux/drivers/media/video/gspca/ov519.c	Thu Jan 01 11:20:00 2009 +0300
@@ -2204,7 +2204,7 @@
 	int ret;
 	ret = usb_register(&sd_driver);
 	if (ret < 0)
-		return -1;
+		return ret;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
 }
diff -r 713c9693b912 linux/drivers/media/video/gspca/ov534.c
--- a/linux/drivers/media/video/gspca/ov534.c	Thu Jan 01 11:07:09 2009 +0300
+++ b/linux/drivers/media/video/gspca/ov534.c	Thu Jan 01 11:20:00 2009 +0300
@@ -587,7 +587,7 @@
 	int ret;
 	ret = usb_register(&sd_driver);
 	if (ret < 0)
-		return -1;
+		return ret;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
 }
diff -r 713c9693b912 linux/drivers/media/video/gspca/pac207.c
--- a/linux/drivers/media/video/gspca/pac207.c	Thu Jan 01 11:07:09 2009 +0300
+++ b/linux/drivers/media/video/gspca/pac207.c	Thu Jan 01 11:20:00 2009 +0300
@@ -567,7 +567,7 @@
 	int ret;
 	ret = usb_register(&sd_driver);
 	if (ret < 0)
-		return -1;
+		return ret;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
 }
diff -r 713c9693b912 linux/drivers/media/video/gspca/pac7311.c
--- a/linux/drivers/media/video/gspca/pac7311.c	Thu Jan 01 11:07:09 2009 +0300
+++ b/linux/drivers/media/video/gspca/pac7311.c	Thu Jan 01 11:20:00 2009 +0300
@@ -1113,7 +1113,7 @@
 	int ret;
 	ret = usb_register(&sd_driver);
 	if (ret < 0)
-		return -1;
+		return ret;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
 }
diff -r 713c9693b912 linux/drivers/media/video/gspca/sonixb.c
--- a/linux/drivers/media/video/gspca/sonixb.c	Thu Jan 01 11:07:09 2009 +0300
+++ b/linux/drivers/media/video/gspca/sonixb.c	Thu Jan 01 11:20:00 2009 +0300
@@ -1304,7 +1304,7 @@
 	int ret;
 	ret = usb_register(&sd_driver);
 	if (ret < 0)
-		return -1;
+		return ret;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
 }
diff -r 713c9693b912 linux/drivers/media/video/gspca/sonixj.c
--- a/linux/drivers/media/video/gspca/sonixj.c	Thu Jan 01 11:07:09 2009 +0300
+++ b/linux/drivers/media/video/gspca/sonixj.c	Thu Jan 01 11:20:00 2009 +0300
@@ -1812,7 +1812,7 @@
 	int ret;
 	ret = usb_register(&sd_driver);
 	if (ret < 0)
-		return -1;
+		return ret;
 	info("registered");
 	return 0;
 }
diff -r 713c9693b912 linux/drivers/media/video/gspca/spca500.c
--- a/linux/drivers/media/video/gspca/spca500.c	Thu Jan 01 11:07:09 2009 +0300
+++ b/linux/drivers/media/video/gspca/spca500.c	Thu Jan 01 11:20:00 2009 +0300
@@ -1112,7 +1112,7 @@
 	int ret;
 	ret = usb_register(&sd_driver);
 	if (ret < 0)
-		return -1;
+		return ret;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
 }
diff -r 713c9693b912 linux/drivers/media/video/gspca/spca501.c
--- a/linux/drivers/media/video/gspca/spca501.c	Thu Jan 01 11:07:09 2009 +0300
+++ b/linux/drivers/media/video/gspca/spca501.c	Thu Jan 01 11:20:01 2009 +0300
@@ -2261,7 +2261,7 @@
 	int ret;
 	ret = usb_register(&sd_driver);
 	if (ret < 0)
-		return -1;
+		return ret;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
 }
diff -r 713c9693b912 linux/drivers/media/video/gspca/spca505.c
--- a/linux/drivers/media/video/gspca/spca505.c	Thu Jan 01 11:07:09 2009 +0300
+++ b/linux/drivers/media/video/gspca/spca505.c	Thu Jan 01 11:20:01 2009 +0300
@@ -934,7 +934,7 @@
 	int ret;
 	ret = usb_register(&sd_driver);
 	if (ret < 0)
-		return -1;
+		return ret;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
 }
diff -r 713c9693b912 linux/drivers/media/video/gspca/spca506.c
--- a/linux/drivers/media/video/gspca/spca506.c	Thu Jan 01 11:07:09 2009 +0300
+++ b/linux/drivers/media/video/gspca/spca506.c	Thu Jan 01 11:20:01 2009 +0300
@@ -774,7 +774,7 @@
 	int ret;
 	ret = usb_register(&sd_driver);
 	if (ret < 0)
-		return -1;
+		return ret;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
 }
diff -r 713c9693b912 linux/drivers/media/video/gspca/spca508.c
--- a/linux/drivers/media/video/gspca/spca508.c	Thu Jan 01 11:07:09 2009 +0300
+++ b/linux/drivers/media/video/gspca/spca508.c	Thu Jan 01 11:20:01 2009 +0300
@@ -1706,7 +1706,7 @@
 	int ret;
 	ret = usb_register(&sd_driver);
 	if (ret < 0)
-		return -1;
+		return ret;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
 }
diff -r 713c9693b912 linux/drivers/media/video/gspca/spca561.c
--- a/linux/drivers/media/video/gspca/spca561.c	Thu Jan 01 11:07:09 2009 +0300
+++ b/linux/drivers/media/video/gspca/spca561.c	Thu Jan 01 11:20:01 2009 +0300
@@ -1206,7 +1206,7 @@
 	int ret;
 	ret = usb_register(&sd_driver);
 	if (ret < 0)
-		return -1;
+		return ret;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
 }
diff -r 713c9693b912 linux/drivers/media/video/gspca/stk014.c
--- a/linux/drivers/media/video/gspca/stk014.c	Thu Jan 01 11:07:09 2009 +0300
+++ b/linux/drivers/media/video/gspca/stk014.c	Thu Jan 01 11:20:01 2009 +0300
@@ -563,7 +563,7 @@
 	int ret;
 	ret = usb_register(&sd_driver);
 	if (ret < 0)
-		return -1;
+		return ret;
 	info("registered");
 	return 0;
 }
diff -r 713c9693b912 linux/drivers/media/video/gspca/stv06xx/stv06xx.c
--- a/linux/drivers/media/video/gspca/stv06xx/stv06xx.c	Thu Jan 01 11:07:09 2009 +0300
+++ b/linux/drivers/media/video/gspca/stv06xx/stv06xx.c	Thu Jan 01 11:20:01 2009 +0300
@@ -503,7 +503,7 @@
 	int ret;
 	ret = usb_register(&sd_driver);
 	if (ret < 0)
-		return -1;
+		return ret;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
 }
diff -r 713c9693b912 linux/drivers/media/video/gspca/sunplus.c
--- a/linux/drivers/media/video/gspca/sunplus.c	Thu Jan 01 11:07:09 2009 +0300
+++ b/linux/drivers/media/video/gspca/sunplus.c	Thu Jan 01 11:20:01 2009 +0300
@@ -1498,7 +1498,7 @@
 	int ret;
 	ret = usb_register(&sd_driver);
 	if (ret < 0)
-		return -1;
+		return ret;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
 }
diff -r 713c9693b912 linux/drivers/media/video/gspca/t613.c
--- a/linux/drivers/media/video/gspca/t613.c	Thu Jan 01 11:07:09 2009 +0300
+++ b/linux/drivers/media/video/gspca/t613.c	Thu Jan 01 11:20:01 2009 +0300
@@ -1178,7 +1178,7 @@
 	int ret;
 	ret = usb_register(&sd_driver);
 	if (ret < 0)
-		return -1;
+		return ret;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
 }
diff -r 713c9693b912 linux/drivers/media/video/gspca/tv8532.c
--- a/linux/drivers/media/video/gspca/tv8532.c	Thu Jan 01 11:07:09 2009 +0300
+++ b/linux/drivers/media/video/gspca/tv8532.c	Thu Jan 01 11:20:01 2009 +0300
@@ -581,7 +581,7 @@
 	int ret;
 	ret = usb_register(&sd_driver);
 	if (ret < 0)
-		return -1;
+		return ret;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
 }
diff -r 713c9693b912 linux/drivers/media/video/gspca/vc032x.c
--- a/linux/drivers/media/video/gspca/vc032x.c	Thu Jan 01 11:07:09 2009 +0300
+++ b/linux/drivers/media/video/gspca/vc032x.c	Thu Jan 01 11:20:01 2009 +0300
@@ -2488,7 +2488,7 @@
 	int ret;
 	ret = usb_register(&sd_driver);
 	if (ret < 0)
-		return -1;
+		return ret;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
 }
diff -r 713c9693b912 linux/drivers/media/video/gspca/zc3xx.c
--- a/linux/drivers/media/video/gspca/zc3xx.c	Thu Jan 01 11:07:09 2009 +0300
+++ b/linux/drivers/media/video/gspca/zc3xx.c	Thu Jan 01 11:20:01 2009 +0300
@@ -7611,7 +7611,7 @@
 	int ret;
 	ret = usb_register(&sd_driver);
 	if (ret < 0)
-		return -1;
+		return ret;
 	PDEBUG(D_PROBE, "registered");
 	return 0;
 }


-- 
Best regards, Klimov Alexey

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
