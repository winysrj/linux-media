Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBK39ZuP026922
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 22:09:35 -0500
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.191])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBK392H5011435
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 22:09:21 -0500
Received: by nf-out-0910.google.com with SMTP id d3so179692nfc.21
	for <video4linux-list@redhat.com>; Fri, 19 Dec 2008 19:09:21 -0800 (PST)
From: Alexey Klimov <klimov.linux@gmail.com>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Content-Type: text/plain
Date: Sat, 20 Dec 2008 06:09:37 +0300
Message-Id: <1229742577.10297.117.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: [review patch 5/5] dsbr100: increase driver version
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

Due to a lot of patches for dsbr100 last time we should update version
of driver.

---
diff -r e24e791ebb4f linux/drivers/media/radio/dsbr100.c
--- a/linux/drivers/media/radio/dsbr100.c	Sat Dec 20 04:53:56 2008 +0300
+++ b/linux/drivers/media/radio/dsbr100.c	Sat Dec 20 05:06:08 2008 +0300
@@ -32,6 +32,10 @@
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 
  History:
+
+ Version 0.44:
+	Add suspend/resume functions, fix unplug of device,
+	a lot of cleanups and fixes by Alexey Klimov <klimov.linux@gmail.com>
 
  Version 0.43:
 	Oliver Neukum: avoided DMA coherency issue
@@ -94,8 +98,8 @@
  */
 #include <linux/version.h>	/* for KERNEL_VERSION MACRO	*/
 
-#define DRIVER_VERSION "v0.43"
-#define RADIO_VERSION KERNEL_VERSION(0, 4, 3)
+#define DRIVER_VERSION "v0.44"
+#define RADIO_VERSION KERNEL_VERSION(0, 4, 4)
 
 static struct v4l2_queryctrl radio_qctrl[] = {
 	{



-- 
Best regards, Klimov Alexey

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
