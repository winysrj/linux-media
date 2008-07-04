Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m640ZAkd010578
	for <video4linux-list@redhat.com>; Thu, 3 Jul 2008 20:35:10 -0400
Received: from mailrelay012.isp.belgacom.be (mailrelay012.isp.belgacom.be
	[195.238.6.179])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m640Yx7C019884
	for <video4linux-list@redhat.com>; Thu, 3 Jul 2008 20:34:59 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Fri, 4 Jul 2008 02:34:59 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807040234.59514.laurent.pinchart@skynet.be>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] uvcvideo: Fix a buffer overflow in format descriptor parsing
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

Thanks to Oliver Neukum for catching and reporting this bug.

Signed-off-by: Laurent Pinchart <laurent.pinchart@skynet.be>
---
 drivers/media/video/uvc/uvc_driver.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_driver.c b/drivers/media/video/uvc/uvc_driver.c
index 60ced58..86bb16d 100644
--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -298,7 +298,8 @@ static int uvc_parse_format(struct uvc_device *dev,
 	switch (buffer[2]) {
 	case VS_FORMAT_UNCOMPRESSED:
 	case VS_FORMAT_FRAME_BASED:
-		if (buflen < 27) {
+		n = buffer[2] == VS_FORMAT_UNCOMPRESSED ? 27 : 28;
+		if (buflen < n) {
 			uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming"
 			       "interface %d FORMAT error\n",
 			       dev->udev->devnum,
-- 
1.5.4.5

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
