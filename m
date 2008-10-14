Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9ED1vxu005303
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 09:01:57 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.233])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9ED1gXg014474
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 09:01:43 -0400
Received: by rv-out-0506.google.com with SMTP id f6so2187671rvb.51
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 06:01:42 -0700 (PDT)
From: Magnus Damm <magnus.damm@gmail.com>
To: video4linux-list@redhat.com
Date: Tue, 14 Oct 2008 22:00:33 +0900
Message-Id: <20081014130033.5242.16772.sendpatchset@rx1.opensource.se>
Cc: v4l-dvb-maintainer@linuxtv.org, mchehab@infradead.org
Subject: [PATCH] video: add byte swap to sh_mobile_ceu driver
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

From: Magnus Damm <damm@igel.co.jp>

Extend the sh_mobile_ceu driver to enable byte swap. This way bytes
are stored in memory in incoming byte order.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 drivers/media/video/sh_mobile_ceu_camera.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- 0021/drivers/media/video/sh_mobile_ceu_camera.c
+++ work/drivers/media/video/sh_mobile_ceu_camera.c	2008-10-14 15:46:26.000000000 +0900
@@ -406,10 +406,10 @@ static int sh_mobile_ceu_set_bus_param(s
 	 * D7, D6, D5, D4, D3, D2, D1, D0 (D7 written to lowest byte)
 	 *
 	 * The lowest three bits of CDOCR allows us to do swapping,
-	 * right now we swap the data bytes to the following order:
-	 * D1, D0, D3, D2, D5, D4, D7, D6
+	 * using 7 we swap the data bytes to match the incoming order:
+	 * D0, D1, D2, D3, D4, D5, D6, D7
 	 */
-	ceu_write(pcdev, CDOCR, 0x00000016);
+	ceu_write(pcdev, CDOCR, 0x00000017);
 
 	ceu_write(pcdev, CDWDR, cdwdr_width);
 	ceu_write(pcdev, CFWCR, 0); /* keep "datafetch firewall" disabled */

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
