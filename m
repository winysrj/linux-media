Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6ILtOOp000717
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 17:55:24 -0400
Received: from mailrelay001.isp.belgacom.be (mailrelay001.isp.belgacom.be
	[195.238.6.51])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6ILtBgX030234
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 17:55:14 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Fri, 18 Jul 2008 23:55:08 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807182355.08725.laurent.pinchart@skynet.be>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] uvcvideo: Make the auto-exposure menu control V4L2
	compliant.
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

V4L2 and UVC enumerate the auto-exposure settings in a different order. This
patch fixes the auto-exposure menu declaration to match the V4L2 spec.

Signed-off-by: Laurent Pinchart <laurent.pinchart@skynet.be>
---
 drivers/media/video/uvc/uvc_ctrl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_ctrl.c 
b/drivers/media/video/uvc/uvc_ctrl.c
index 0a446f0..91ff899 100644
--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -195,8 +195,8 @@ static struct uvc_menu_info 
power_line_frequency_controls[] = {
 };
 
 static struct uvc_menu_info exposure_auto_controls[] = {
-	{ 1, "Manual Mode" },
 	{ 2, "Auto Mode" },
+	{ 1, "Manual Mode" },
 	{ 4, "Shutter Priority Mode" },
 	{ 8, "Aperture Priority Mode" },
 };
-- 
1.5.4.5

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
