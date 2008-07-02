Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m62LKpNN007461
	for <video4linux-list@redhat.com>; Wed, 2 Jul 2008 17:20:51 -0400
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m62LKKnX011935
	for <video4linux-list@redhat.com>; Wed, 2 Jul 2008 17:20:23 -0400
Message-ID: <486BF294.7060500@hhs.nl>
Date: Wed, 02 Jul 2008 23:26:44 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
Content-Type: multipart/mixed; boundary="------------040205070903040908010707"
Cc: video4linux-list@redhat.com
Subject: PATCH: gspca-mercurial fix sonixb driver
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
--------------040205070903040908010707
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi All,

This patch makes the sonixb gspca driver actually work (tested with
a sweex sn9c102 with tas5110 sensor).

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>

Regards,

Hans

--------------040205070903040908010707
Content-Type: text/x-patch;
 name="gspca-fix-sonixb.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gspca-fix-sonixb.patch"

This patch makes the sonixb gspca driver actually work (tested with
a sweex sn9c102 with tas5110 sensor).

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>
--- gspca-2bbb47f61a95/linux/drivers/media/video/gspca/sonixb.c.dbg	2008-07-02 11:14:56.000000000 +0200
+++ gspca-2bbb47f61a95/linux/drivers/media/video/gspca/sonixb.c	2008-07-02 23:07:41.000000000 +0200
@@ -344,13 +344,17 @@ static void reg_w(struct usb_device *dev
 			  const __u8 *buffer,
 			  __u16 len)
 {
+	__u8 tmpbuf[0x1f];
+
+	memcpy(tmpbuf, buffer, len);
+
 	usb_control_msg(dev,
 			usb_sndctrlpipe(dev, 0),
 			0x08,			/* request */
 			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_INTERFACE,
 			value,
 			0,			/* index */
-			(__u8 *) buffer, len,
+			tmpbuf, len,
 			500);
 }
 
@@ -769,8 +773,8 @@ static void sd_pkt_scan(struct gspca_dev
 							LAST_PACKET,
 							frame,
 							data, 0);
-				data += 12;
-				len -= 12;
+				data += p + 12;
+				len -= p + 12;
 				gspca_frame_add(gspca_dev, FIRST_PACKET,
 						frame, data, len);
 				return;

--------------040205070903040908010707
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------040205070903040908010707--
