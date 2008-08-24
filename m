Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7O6rJ47027621
	for <video4linux-list@redhat.com>; Sun, 24 Aug 2008 02:53:20 -0400
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7O6r8Rh010019
	for <video4linux-list@redhat.com>; Sun, 24 Aug 2008 02:53:08 -0400
Message-ID: <48B107DE.2060006@hhs.nl>
Date: Sun, 24 Aug 2008 09:03:58 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
Content-Type: multipart/mixed; boundary="------------030901030607010907080508"
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: PATCH: gspca-ctrl-fixes.patch
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
--------------030901030607010907080508
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

While working on the Pixart 73xx controls code I noticed your new disabled 
controls code (nice) and I've taken a look at that. This patch contains 2 fixes:

-Fix reversed check in control enumeration
-Report -EINVAL (as documented in the v4l spec) when an application tries to
  set/get a disabled control, this protects subdrivers against having their
  ctrl set/get methods called for disabled controls so they don't have to check
  for this themselves.

The first fix is not tested (I dunno of a program which actually uses this), 
but upon reading the code, and stepping through it in my mind, the old code 
seems wrong, and the new code after this patch seems right.

Regards,

Hans

--------------030901030607010907080508
Content-Type: text/plain;
 name="gspca-ctrl-fixes.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gspca-ctrl-fixes.patch"

-Fix reversed check in control enumeration
-Report -EINVAL (as documented in the v4l spec) when an application tries to
 set/get a disabled control, this protects subdrivers against having their
 ctrl set/get methods called for disabled controls so they don't have to check
 for this themselves.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>
diff -r 9c27eaf44d47 linux/drivers/media/video/gspca/gspca.c
--- a/linux/drivers/media/video/gspca/gspca.c	Sat Aug 23 12:56:49 2008 +0200
+++ b/linux/drivers/media/video/gspca/gspca.c	Sun Aug 24 08:58:44 2008 +0200
@@ -876,7 +876,7 @@
 		id &= V4L2_CTRL_ID_MASK;
 		id++;
 		for (i = 0; i < gspca_dev->sd_desc->nctrls; i++) {
-			if (id < gspca_dev->sd_desc->ctrls[i].qctrl.id)
+			if (gspca_dev->sd_desc->ctrls[i].qctrl.id < id)
 				continue;
 			if (ix < 0) {
 				ix = i;
@@ -915,6 +915,8 @@
 	     i++, ctrls++) {
 		if (ctrl->id != ctrls->qctrl.id)
 			continue;
+		if (gspca_dev->ctrl_dis & (1 << i))
+			return -EINVAL;
 		if (ctrl->value < ctrls->qctrl.minimum
 		    || ctrl->value > ctrls->qctrl.maximum)
 			return -ERANGE;
@@ -941,6 +943,8 @@
 	     i++, ctrls++) {
 		if (ctrl->id != ctrls->qctrl.id)
 			continue;
+		if (gspca_dev->ctrl_dis & (1 << i))
+			return -EINVAL;
 		if (mutex_lock_interruptible(&gspca_dev->usb_lock))
 			return -ERESTARTSYS;
 		ret = ctrls->get(gspca_dev, &ctrl->value);

--------------030901030607010907080508
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------030901030607010907080508--
