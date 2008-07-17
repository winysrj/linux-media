Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6HFKbUC013087
	for <video4linux-list@redhat.com>; Thu, 17 Jul 2008 11:20:37 -0400
Received: from ti-out-0910.google.com (ti-out-0910.google.com [209.85.142.185])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6HFKM8Z019890
	for <video4linux-list@redhat.com>; Thu, 17 Jul 2008 11:20:23 -0400
Received: by ti-out-0910.google.com with SMTP id 24so3592896tim.7
	for <video4linux-list@redhat.com>; Thu, 17 Jul 2008 08:20:21 -0700 (PDT)
From: Kyuma Ohta <whatisthis.sowhat@gmail.com>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="=-682TPPIcspAw5D2NTCcu"
Date: Fri, 18 Jul 2008 00:20:14 +0900
Message-Id: <1216308014.1146.22.camel@melchior>
Mime-Version: 1.0
Cc: Video4Linux ML <video4linux-list@redhat.com>,
	ivtv-devel ML <ivtv-devel@ivtvdriver.org>
Subject: [PATCH AVAIL.]ivtv:Crash  2.6.26 with KUROTOSIKOU CX23416-STVLP
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


--=-682TPPIcspAw5D2NTCcu
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,
I'm testing 2.6.26/amd64 with Athlon64 x2 Box with
KUROTOSIKOU CX23416-STVLP,always crash ivtv driver
when loading upd64083 driver.
I checked crash dump,this issue cause of loading 
upd64083.ko with i2c_probed_new_device().
So,I fixed ivtv-i2c.c of 2.6.26 vanilla,and
fixed *pretty* differnce memory allocation,structure
of upd64083.c.
I'm running patched 2.6.26 vanilla with below attached
patches over 24hrs,and over 10hrs recording from ivtv,
not happend anything;-)
Please apply below to 2.6.26.x..

Best regards, 
Ohta.

E-Mail: whatisthis.sowhat@gmail.com (Public)
Home Page: http://d.hatena.ne.jp/artane/ 
  (Sorry,not maintaining,and written in Japanese only...)
Twitter: Artanejp (Mainly Japanese)
ICQ: 366538955
KEYID: 6B79F95F
FINGERPRINT:
9AB3 8569 6033 FDBE 352B  CB6D DBFA B9E2 6B79 F95F



--=-682TPPIcspAw5D2NTCcu
Content-Disposition: attachment; filename=2.6.26-ivtv-cards-fix-includes.patch
Content-Type: text/x-patch; name=2.6.26-ivtv-cards-fix-includes.patch;
	charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

diff -urN a/drivers/media/video/ivtv/ivtv-cards.c b/drivers/media/video/ivtv/ivtv-cards.c
--- a/drivers/media/video/ivtv/ivtv-cards.c	2008-07-14 06:51:29.000000000 +0900
+++ b/drivers/media/video/ivtv/ivtv-cards.c	2008-07-15 23:00:41.286531980 +0900
@@ -28,6 +28,7 @@
 #include <media/cs53l32a.h>
 #include <media/cx25840.h>
 #include <media/upd64031a.h>
+#include <media/upd64083.h> // Fix 20080715 K.Ohta
 
 #define MSP_TUNER  MSP_INPUT(MSP_IN_SCART1, MSP_IN_TUNER1, \
 				MSP_DSP_IN_TUNER, MSP_DSP_IN_TUNER)

--=-682TPPIcspAw5D2NTCcu
Content-Disposition: attachment;
	filename=2.6.26-ivtv-i2c-fix-probing-upd64083.patch
Content-Type: text/x-patch; name=2.6.26-ivtv-i2c-fix-probing-upd64083.patch;
	charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

diff -urN a/drivers/media/video/ivtv/ivtv-i2c.c b/drivers/media/video/ivtv/ivtv-i2c.c
--- a/drivers/media/video/ivtv/ivtv-i2c.c	2008-07-14 06:51:29.000000000 +0900
+++ b/drivers/media/video/ivtv/ivtv-i2c.c	2008-07-16 20:57:47.196653657 +0900
@@ -177,10 +177,9 @@
 	}
 
 	if (id != I2C_DRIVERID_TUNER) {
-		if (id == I2C_DRIVERID_UPD64031A ||
-		    id == I2C_DRIVERID_UPD64083) {
+		if (id == I2C_DRIVERID_UPD64031A ) { // Apply only upd64031a 20080716
 			unsigned short addrs[2] = { info.addr, I2C_CLIENT_END };
-
+		   
 			c = i2c_new_probed_device(&itv->i2c_adap, &info, addrs);
 		} else
 			c = i2c_new_device(&itv->i2c_adap, &info);

--=-682TPPIcspAw5D2NTCcu
Content-Disposition: attachment; filename=2.6.26-upd64083-fix-allocation.patch
Content-Type: text/x-patch; name=2.6.26-upd64083-fix-allocation.patch;
	charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

diff -urN a/drivers/media/video/upd64083.c b/drivers/media/video/upd64083.c
--- a/drivers/media/video/upd64083.c	2008-07-14 06:51:29.000000000 +0900
+++ b/drivers/media/video/upd64083.c	2008-07-16 20:54:05.702773275 +0900
@@ -51,9 +51,9 @@
 };
 
 struct upd64083_state {
+   	u8 regs[TOT_REGS];
 	u8 mode;
 	u8 ext_y_adc;
-	u8 regs[TOT_REGS];
 };
 
 /* Initial values when used in combination with the
@@ -178,20 +178,19 @@
 	struct upd64083_state *state;
 	int i;
 
-	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
+        if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
 		return -EIO;
-
 	v4l_info(client, "chip found @ 0x%x (%s)\n",
 			client->addr << 1, client->adapter->name);
 
-	state = kmalloc(sizeof(struct upd64083_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct upd64083_state), GFP_KERNEL); // Fix 20080716
 	if (state == NULL)
 		return -ENOMEM;
 	i2c_set_clientdata(client, state);
 	/* Initially assume that a ghost reduction chip is present */
 	state->mode = 0;  /* YCS mode */
 	state->ext_y_adc = (1 << 5);
-	memcpy(state->regs, upd64083_init, TOT_REGS);
+	memcpy(state->regs, upd64083_init, sizeof(state->regs)); // Fix 20080716
 	for (i = 0; i < TOT_REGS; i++)
 		upd64083_write(client, i, state->regs[i]);
 	return 0;
@@ -217,5 +216,6 @@
 	.command = upd64083_command,
 	.probe = upd64083_probe,
 	.remove = upd64083_remove,
+        .legacy_class = I2C_CLASS_TV_ANALOG | I2C_CLASS_TV_DIGITAL , // Add 20080716
 	.id_table = upd64083_id,
 };

--=-682TPPIcspAw5D2NTCcu
Content-Disposition: attachment; filename=2.6.26-upd64031a-fix-allocation.patch
Content-Type: text/x-patch; name=2.6.26-upd64031a-fix-allocation.patch;
	charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

diff -urN a/drivers/media/video/upd64031a.c b/drivers/media/video/upd64031a.c
--- a/drivers/media/video/upd64031a.c	2008-07-14 06:51:29.000000000 +0900
+++ b/drivers/media/video/upd64031a.c	2008-07-16 20:55:44.692759552 +0900
@@ -207,7 +207,7 @@
 	v4l_info(client, "chip found @ 0x%x (%s)\n",
 			client->addr << 1, client->adapter->name);
 
-	state = kmalloc(sizeof(struct upd64031a_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct upd64031a_state), GFP_KERNEL); // Fix 20080716
 	if (state == NULL)
 		return -ENOMEM;
 	i2c_set_clientdata(client, state);
@@ -239,6 +239,7 @@
 	.driverid = I2C_DRIVERID_UPD64031A,
 	.command = upd64031a_command,
 	.probe = upd64031a_probe,
-	.remove = upd64031a_remove,
+       .legacy_class = I2C_CLASS_TV_ANALOG | I2C_CLASS_TV_DIGITAL , // Add 20080716
+       .remove = upd64031a_remove,
 	.id_table = upd64031a_id,
 };

--=-682TPPIcspAw5D2NTCcu
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--=-682TPPIcspAw5D2NTCcu--
