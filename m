Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m647qstk011584
	for <video4linux-list@redhat.com>; Fri, 4 Jul 2008 03:52:54 -0400
Received: from frosty.hhs.nl (frosty.hhs.nl [145.52.2.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m647qgsX011997
	for <video4linux-list@redhat.com>; Fri, 4 Jul 2008 03:52:42 -0400
Received: from exim (helo=frosty) by frosty.hhs.nl with local-smtp (Exim 4.62)
	(envelope-from <j.w.r.degoede@hhs.nl>) id 1KEg5x-00083q-K1
	for video4linux-list@redhat.com; Fri, 04 Jul 2008 09:52:41 +0200
Message-ID: <486DD6A6.7020209@hhs.nl>
Date: Fri, 04 Jul 2008 09:52:06 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
Content-Type: multipart/mixed; boundary="------------070900010205040601080900"
Cc: video4linux-list@redhat.com
Subject: PATCH: gspca-add-driver-get_buf_size-method.patch saved
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
--------------070900010205040601080900
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi All,

This patch adds a get_buff_size op to the driver desc struct, and modifies
gspca_get_buff_size to call this (if defined) instead of calculating the
buff_size itself.

This is needed for the pac207 with decoding removed, as the pac207 does
line by line compression prefixing each line with a header indicating wether
or not it is compressed, and only does compression when needed to meet
bandwidth constraints. In half resolution mode, when there are no
bandwidth constraints, the imagesize is actually larger (due to the line
headers) then the raw bayer, so in this case gspca_get_buff_size does the
wrong thing. The best solution in special cases like this is to allow the
driver to provide its own get_buff_size, overriding gspca_get_buff_size's
normal calculations.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans

--------------070900010205040601080900
Content-Type: text/plain;
 name="gspca-add-driver-get_buf_size-method.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="gspca-add-driver-get_buf_size-method.patch"

This patch adds a get_buff_size op to the driver desc struct, and modifies
gspca_get_buff_size to call this (if defined) instead of calculating the
buff_size itself.

This is needed for the pac207 with decoding removed, as the pac207 does
line by line compression prefixing each line with a header indicating wether
or not it is compressed, and only does compression when needed to meet
bandwidth constraints. In half resolution mode, when there are no
bandwidth constraints, the imagesize is actually larger (due to the line
headers) then the raw bayer, so in this case gspca_get_buff_size does the
wrong thing. The best solution in special cases like this is to allow the
driver to provide its own get_buff_size, overriding gspca_get_buff_size's
normal calculations.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

diff -r b8dc1b84f3c5 linux/drivers/media/video/gspca/gspca.c
--- a/linux/drivers/media/video/gspca/gspca.c	Fri Jul 04 09:36:32 2008 +0200
+++ b/linux/drivers/media/video/gspca/gspca.c	Fri Jul 04 09:44:31 2008 +0200
@@ -400,6 +400,9 @@
 static int gspca_get_buff_size(struct gspca_dev *gspca_dev, int mode)
 {
 	unsigned int size;
+
+	if (gspca_dev->sd_desc->get_buff_size)
+		return gspca_dev->sd_desc->get_buff_size(gspca_dev, mode);
 
 	size =  gspca_dev->cam.cam_mode[mode].width *
 		gspca_dev->cam.cam_mode[mode].height *
diff -r b8dc1b84f3c5 linux/drivers/media/video/gspca/gspca.h
--- a/linux/drivers/media/video/gspca/gspca.h	Fri Jul 04 09:36:32 2008 +0200
+++ b/linux/drivers/media/video/gspca/gspca.h	Fri Jul 04 09:44:31 2008 +0200
@@ -100,6 +100,7 @@
 				struct gspca_frame *frame,
 				__u8 *data,
 				int len);
+typedef int (*cam_get_buff_size_op) (struct gspca_dev *gspca_dev, int mode);
 
 struct ctrl {
 	struct v4l2_queryctrl qctrl;
@@ -126,6 +127,7 @@
 	cam_jpg_op get_jcomp;
 	cam_jpg_op set_jcomp;
 	cam_qmnu_op querymenu;
+	cam_get_buff_size_op get_buff_size; /* optional */
 };
 
 /* packet types when moving from iso buf to frame buf */

--------------070900010205040601080900
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------070900010205040601080900--
