Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6EKb7Xe005845
	for <video4linux-list@redhat.com>; Mon, 14 Jul 2008 16:37:07 -0400
Received: from smtp2.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6EKatBP009901
	for <video4linux-list@redhat.com>; Mon, 14 Jul 2008 16:36:56 -0400
Message-ID: <487BBAA3.5030804@hhs.nl>
Date: Mon, 14 Jul 2008 22:44:19 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
Content-Type: multipart/mixed; boundary="------------060509050109040209020401"
Cc: video4linux-list@redhat.com
Subject: PATCH: gspca-sonixb-fix-sif-cams.patch
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

This is a multi-part message in MIME format.
--------------060509050109040209020401
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

One of the sn9c103 + ov7660 patches has hardcoded the bridge registers 0x15
and 0x16 (H-size and V-size in units of 16 pixels) to 0x28 0x1e, which will
only work for 640x480 res sensors and not for 352x288 res sensors. This patch
restores the old behavior of reading these register from the per sensor bridge
init settings, and fixes the ov7660_3 init settings to correctly set these
registers to 0x28, 0x1e.

This fixes my 2 sn9c10x test cams:
0c45:6005 Microdia Sweex Mini WebCam    tas5110
0c45:6011 Microdia PC Camera (SN9C102)  ov6550

Which BTW can be set green on your cam test matrix :)

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans

--------------060509050109040209020401
Content-Type: text/x-patch;
 name="gspca-sonixb-fix-sif-cams.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gspca-sonixb-fix-sif-cams.patch"

One of the sn9c103 + ov7660 patches has hardcoded the bridge registers 0x15
and 0x16 (H-size and V-size in units of 16 pixels) to 0x28 0x1e, which will
only work for 640x480 res sensors and not for 352x288 res sensors. This patch
restores the old behavior of reading these register from the per sensor bridge
init settings, and fixes the ov7660_3 init settings to correctly set these
registers to 0x28, 0x1e.

This fixes my 2 sn9c10x test cams:
0c45:6005 Microdia Sweex Mini WebCam    tas5110
0c45:6011 Microdia PC Camera (SN9C102)  ov6550

Which BTW can be set green on your cam test matrix :)

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>  

diff -r fa6e3138e75c linux/drivers/media/video/gspca/sonixb.c
--- a/linux/drivers/media/video/gspca/sonixb.c	Mon Jul 14 18:53:03 2008 +0200
+++ b/linux/drivers/media/video/gspca/sonixb.c	Mon Jul 14 22:28:56 2008 +0200
@@ -270,7 +270,7 @@
 	0x44, 0x44, 0x00, 0x1a, 0x20, 0x20, 0x20, 0x80,	/* r01 .. r08 */
 	0x21, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x04,	/* r09 .. r10 */
 	0x00, 0x01, 0x01, 0x0a,				/* r11 .. r14 */
-	0x16, 0x12,			/* H & V sizes     r15 .. r16 */
+	0x28, 0x1e,			/* H & V sizes     r15 .. r16 */
 	0x68, 0x8f, MCK_INIT1,				/* r17 .. r19 */
 	0x1d, 0x10, 0x02, 0x03, 0x0f, 0x0c, 0x00,	/* r1a .. r20 */
 	0x10, 0x20, 0x30, 0x40, 0x50, 0x60, 0x70, 0x80, /* r21 .. r28 */
@@ -811,7 +811,6 @@
 	const __u8 *sn9c10x;
 	__u8 reg01, reg17;
 	__u8 reg17_19[3];
-	static const __u8 reg15[2] = { 0x28, 0x1e };
 
 	mode = gspca_dev->cam.cam_mode[(int) gspca_dev->curr_mode].priv;
 	switch (sd->sensor) {
@@ -931,8 +930,8 @@
 				sizeof tas5130_sensor_init);
 		break;
 	}
-	/* H_size V_size  0x28, 0x1e maybe 640x480 */
-	reg_w(gspca_dev, 0x15, reg15, 2);
+	/* H_size V_size 0x28, 0x1e -> 640x480. 0x16, 0x12 -> 352x288 */
+	reg_w(gspca_dev, 0x15, &sn9c10x[0x15 - 1], 2);
 	/* compression register */
 	reg_w(gspca_dev, 0x18, &reg17_19[1], 1);
 	if (sd->sensor != SENSOR_OV7630_3) {

--------------060509050109040209020401
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------060509050109040209020401--
