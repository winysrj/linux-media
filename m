Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9RFEEYj008831
	for <video4linux-list@redhat.com>; Mon, 27 Oct 2008 11:14:14 -0400
Received: from lxorguk.ukuu.org.uk (earthlight.etchedpixels.co.uk
	[81.2.110.250])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9RFDeB7023509
	for <video4linux-list@redhat.com>; Mon, 27 Oct 2008 11:13:40 -0400
Date: Mon, 27 Oct 2008 15:13:47 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: mchehab@infradead.org, video4linux-list@redhat.com
Message-ID: <20081027151347.47a26642@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: 
Subject: [PATCH] rationalise addresses to one common one
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

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/media/radio/radio-aimslab.c b/drivers/media/radio/radio-aimslab.c
index 9305e95..dd6d3df 100644
--- a/drivers/media/radio/radio-aimslab.c
+++ b/drivers/media/radio/radio-aimslab.c
@@ -1,7 +1,7 @@
 /* radiotrack (radioreveal) driver for Linux radio support
  * (c) 1997 M. Kirkwood
  * Converted to V4L2 API by Mauro Carvalho Chehab <mchehab@infradead.org>
- * Converted to new API by Alan Cox <Alan.Cox@linux.org>
+ * Converted to new API by Alan Cox <alan@lxorguk.ukuu.org.uk>
  * Various bugfixes and enhancements by Russell Kroll <rkroll@exploits.org>
  *
  * History:
diff --git a/drivers/media/radio/radio-cadet.c b/drivers/media/radio/radio-cadet.c
index 0490a1f..bfd37f3 100644
--- a/drivers/media/radio/radio-cadet.c
+++ b/drivers/media/radio/radio-cadet.c
@@ -23,7 +23,7 @@
  * 2002-01-17	Adam Belay <ambx1@neo.rr.com>
  *		Updated to latest pnp code
  *
- * 2003-01-31	Alan Cox <alan@redhat.com>
+ * 2003-01-31	Alan Cox <alan@lxorguk.ukuu.org.uk>
  *		Cleaned up locking, delay code, general odds and ends
  *
  * 2006-07-30	Hans J. Koch <koch@hjk-az.de>
diff --git a/drivers/media/radio/radio-gemtek.c b/drivers/media/radio/radio-gemtek.c
index d131a5d..e13118d 100644
--- a/drivers/media/radio/radio-gemtek.c
+++ b/drivers/media/radio/radio-gemtek.c
@@ -8,7 +8,7 @@
  *    RadioTrack II driver for Linux radio support (C) 1998 Ben Pfaff
  *
  *    Based on RadioTrack I/RadioReveal (C) 1997 M. Kirkwood
- *    Converted to new API by Alan Cox <Alan.Cox@linux.org>
+ *    Converted to new API by Alan Cox <alan@lxorguk.ukuu.org.uk>
  *    Various bugfixes and enhancements by Russell Kroll <rkroll@exploits.org>
  *
  * TODO: Allow for more than one of these foolish entities :-)
diff --git a/drivers/media/radio/radio-rtrack2.c b/drivers/media/radio/radio-rtrack2.c
index a670797..7704f24 100644
--- a/drivers/media/radio/radio-rtrack2.c
+++ b/drivers/media/radio/radio-rtrack2.c
@@ -1,7 +1,7 @@
 /* RadioTrack II driver for Linux radio support (C) 1998 Ben Pfaff
  *
  * Based on RadioTrack I/RadioReveal (C) 1997 M. Kirkwood
- * Converted to new API by Alan Cox <Alan.Cox@linux.org>
+ * Converted to new API by Alan Cox <alan@lxorguk.ukuu.org.uk>
  * Various bugfixes and enhancements by Russell Kroll <rkroll@exploits.org>
  *
  * TODO: Allow for more than one of these foolish entities :-)
diff --git a/drivers/media/radio/radio-sf16fmi.c b/drivers/media/radio/radio-sf16fmi.c
index 329c90b..834d436 100644
--- a/drivers/media/radio/radio-sf16fmi.c
+++ b/drivers/media/radio/radio-sf16fmi.c
@@ -3,7 +3,7 @@
  * (c) 1997 M. Kirkwood
  * (c) 1998 Petr Vandrovec, vandrove@vc.cvut.cz
  *
- * Fitted to new interface by Alan Cox <alan.cox@linux.org>
+ * Fitted to new interface by Alan Cox <alan@lxorguk.ukuu.org.uk>
  * Made working and cleaned up functions <mikael.hedin@irf.se>
  * Support for ISAPnP by Ladislav Michl <ladis@psi.cz>
  *
diff --git a/drivers/media/video/cpia2/cpia2_core.c b/drivers/media/video/cpia2/cpia2_core.c
index 7e791b6..1cc0df8 100644
--- a/drivers/media/video/cpia2/cpia2_core.c
+++ b/drivers/media/video/cpia2/cpia2_core.c
@@ -25,7 +25,7 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  *
  *  Stripped of 2.4 stuff ready for main kernel submit by
- *		Alan Cox <alan@redhat.com>
+ *		Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  ****************************************************************************/
 
diff --git a/drivers/media/video/cpia2/cpia2_usb.c b/drivers/media/video/cpia2/cpia2_usb.c
index 73511a5..dc5b07a 100644
--- a/drivers/media/video/cpia2/cpia2_usb.c
+++ b/drivers/media/video/cpia2/cpia2_usb.c
@@ -25,7 +25,7 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  *
  *  Stripped of 2.4 stuff ready for main kernel submit by
- *		Alan Cox <alan@redhat.com>
+ *		Alan Cox <alan@lxorguk.ukuu.org.uk>
  ****************************************************************************/
 
 #include <linux/kernel.h>
diff --git a/drivers/media/video/cpia2/cpia2_v4l.c b/drivers/media/video/cpia2/cpia2_v4l.c
index 1c6bd63..d9de2e8 100644
--- a/drivers/media/video/cpia2/cpia2_v4l.c
+++ b/drivers/media/video/cpia2/cpia2_v4l.c
@@ -26,7 +26,7 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  *
  *  Stripped of 2.4 stuff ready for main kernel submit by
- *		Alan Cox <alan@redhat.com>
+ *		Alan Cox <alan@lxorguk.ukuu.org.uk>
  ****************************************************************************/
 
 #include <linux/version.h>
diff --git a/drivers/media/video/pms.c b/drivers/media/video/pms.c
index 9948078..8062d00 100644
--- a/drivers/media/video/pms.c
+++ b/drivers/media/video/pms.c
@@ -10,8 +10,8 @@
  *	14478 Potsdam, Germany
  *
  *	Most of this code is directly derived from his userspace driver.
- *	His driver works so send any reports to alan@redhat.com unless the
- *	userspace driver also doesn't work for you...
+ *	His driver works so send any reports to alan@lxorguk.ukuu.org.uk
+ *	unless the userspace driver also doesn't work for you...
  *
  *      Changes:
  *      08/07/2003        Daniele Bellucci <bellucda@tiscali.it>
diff --git a/drivers/media/video/saa5246a.c b/drivers/media/video/saa5246a.c
index 4a21b8a..9d45826 100644
--- a/drivers/media/video/saa5246a.c
+++ b/drivers/media/video/saa5246a.c
@@ -15,7 +15,7 @@
  * <richard.guenther@student.uni-tuebingen.de>
  *
  * with changes by
- * Alan Cox <Alan.Cox@linux.org>
+ * Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  * and
  *
diff --git a/drivers/media/video/saa5249.c b/drivers/media/video/saa5249.c
index 3bb959c..1594773 100644
--- a/drivers/media/video/saa5249.c
+++ b/drivers/media/video/saa5249.c
@@ -8,7 +8,7 @@
  *	you can add arbitary multiple teletext devices to Linux video4linux
  *	now (well 32 anyway).
  *
- *	Alan Cox <Alan.Cox@linux.org>
+ *	Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
  *	The original driver was heavily modified to match the i2c interface
  *	It was truncated to use the WinTV boards, too.
diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
index 846763d..fdc8871 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -28,7 +28,7 @@
  *		as published by the Free Software Foundation; either version
  *		2 of the License, or (at your option) any later version.
  *
- * Author:	Alan Cox, <alan@redhat.com>
+ * Author:	Alan Cox, <alan@lxorguk.ukuu.org.uk>
  *
  * Fixes:
  */
diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index ccd6566..ead6d18 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -9,7 +9,7 @@
  *	as published by the Free Software Foundation; either version
  *	2 of the License, or (at your option) any later version.
  *
- * Authors:	Alan Cox, <alan@redhat.com> (version 1)
+ * Authors:	Alan Cox, <alan@lxorguk.ukuu.org.uk> (version 1)
  *              Mauro Carvalho Chehab <mchehab@infradead.org> (version 2)
  *
  * Fixes:	20000516  Claudio Matsuoka <claudio@conectiva.com>
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 710e1a4..eef5814 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -8,7 +8,7 @@
  * as published by the Free Software Foundation; either version
  * 2 of the License, or (at your option) any later version.
  *
- * Authors:	Alan Cox, <alan@redhat.com> (version 1)
+ * Authors:	Alan Cox, <alan@lxorguk.ukuu.org.uk> (version 1)
  *              Mauro Carvalho Chehab <mchehab@infradead.org> (version 2)
  */
 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
