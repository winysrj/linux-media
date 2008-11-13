Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mADHRYjd029855
	for <video4linux-list@redhat.com>; Thu, 13 Nov 2008 12:27:34 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mADHQS1n027034
	for <video4linux-list@redhat.com>; Thu, 13 Nov 2008 12:26:28 -0500
Date: Thu, 13 Nov 2008 15:26:22 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Mike Isely <isely@isely.net>
Message-ID: <20081113152622.6f6b7092@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Video <video4linux-list@redhat.com>, Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH] missdetection on pvrusb2
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

Hi Mike,

There's a report on kernelops.org about an issue with pvrusb2 and tvaudio.

I'm currently working on fixing some issues there, but it seems that tvaudio is
sometimes being miss-detected. So, it seems a good idea to blacklist the driver
in the cases that we're sure it can't be there.

If ok for you, I'll apply this one on my tree.

Cheers,
Mauro.

--

tvaudio: fix a missdetection with pvrusb2 driver

As reported on [1], tvaudio is called for pvrusb2, but, according with 
Michael Krufky, there's no pvrusb2 device needing tvaudio. So, the 
better is to exclude it from being probed at tvaudio.

[1] http://article.gmane.org/gmane.linux.kernel/723516

diff -r f33ef5bce695 linux/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c
--- a/linux/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c	Thu Nov 13 15:07:54 2008 -0200
+++ b/linux/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c	Thu Nov 13 15:14:44 2008 -0200
@@ -1018,7 +1018,7 @@
 static struct i2c_adapter pvr2_i2c_adap_template = {
 	.owner         = THIS_MODULE,
 	.class	   = I2C_CLASS_TV_ANALOG,
-	.id            = I2C_HW_B_BT848,
+	.id            = I2C_HW_B_PVRUSB2,
 	.client_register = pvr2_i2c_attach_inform,
 	.client_unregister = pvr2_i2c_detach_inform,
 };
diff -r f33ef5bce695 linux/drivers/media/video/tvaudio.c
--- a/linux/drivers/media/video/tvaudio.c	Thu Nov 13 15:07:54 2008 -0200
+++ b/linux/drivers/media/video/tvaudio.c	Thu Nov 13 15:14:44 2008 -0200
@@ -1865,9 +1865,10 @@
 
 static int chip_legacy_probe(struct i2c_adapter *adap)
 {
-	/* don't attach on saa7146 based cards,
-	   because dedicated drivers are used */
-	if ((adap->id == I2C_HW_SAA7146))
+	/* don't attach on saa7146 or pvrusb2 based cards,
+	   because other drivers are used */
+	if ((adap->id == I2C_HW_SAA7146) ||
+	    (adap->id == I2C_HW_B_PVRUSB2))
 		return 0;
 	if (adap->class & I2C_CLASS_TV_ANALOG)
 		return 1;
diff -r f33ef5bce695 linux/include/linux/i2c-id.h
--- a/linux/include/linux/i2c-id.h	Thu Nov 13 15:07:54 2008 -0200
+++ b/linux/include/linux/i2c-id.h	Thu Nov 13 15:14:44 2008 -0200
@@ -110,6 +110,7 @@
 #define I2C_HW_B_INTELFB	0x010021 /* intel framebuffer driver */
 #define I2C_HW_B_CX23885	0x010022 /* conexant 23885 based tv cards (bus1) */
 #define I2C_HW_B_AU0828		0x010023 /* auvitek au0828 usb bridge */
+#define I2C_HW_B_PVRUSB2	0x010024 /* pvrusb2 video boards */
 
 /* --- PCF 8584 based algorithms					*/
 #define I2C_HW_P_ELEK		0x020002 /* Elektor ISA Bus inteface card */

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
