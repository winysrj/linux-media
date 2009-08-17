Return-path: <linux-media-owner@vger.kernel.org>
Received: from jim.sh ([75.150.123.25]:60612 "EHLO psychosis.jim.sh"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961AbZHQRzu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Aug 2009 13:55:50 -0400
Date: Mon, 17 Aug 2009 13:47:44 -0400
From: Jim Paris <jim@jtan.com>
To: linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: ov534 + ov772x (playstation eye) broken in 2.6.30
Message-ID: <20090817174744.GA11933@psychosis.jim.sh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Commit 84fbdf87ab8eaa4eaefb317a7eb437cd4d3d0ebf:
  "V4L/DVB (11105): gspca - ov534: Adjust the packet scan function"
broke the gspca ov534 driver for the Playstation Eye in 2.6.30.

Commit c874f3aa7e66158dccb2b9f3cfc46c65af6c223d:
  "V4L/DVB (11973): gspca - ov534: Do the ov772x work again."
fixes it for 2.6.31, but this leaves 2.6.30 users out in the cold.

I'd like to submit the fix to the -stable team in hopes that it can
get included in 2.6.30.6.  Unfortunately 84fbdf87 depends on earlier
patches.  The below patch is similar to 84fbdf87 but applies to
2.6.30.5.  Does this look acceptable?

-jim

>From 8dc9e3749ccb3f500fb8597454561ce18bf39cec Mon Sep 17 00:00:00 2001
From: Jim Paris <jim@jtan.com>
Date: Mon, 17 Aug 2009 13:45:00 -0400
Subject: [PATCH] gspca - ov534: Fix ov772x

The scan of the image packets of the sensor ov772x was broken when
the sensor ov965x was added.

[ Based on upstream 84fbdf87, reworked for v2.6.30.5 ]

Signed-off-by: Jim Paris <jim@jtan.com>
---
 drivers/media/video/gspca/ov534.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/gspca/ov534.c b/drivers/media/video/gspca/ov534.c
index 19e0bc6..504f849 100644
--- a/drivers/media/video/gspca/ov534.c
+++ b/drivers/media/video/gspca/ov534.c
@@ -832,9 +832,11 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev, struct gspca_frame *frame,
 	__u32 this_pts;
 	u16 this_fid;
 	int remaining_len = len;
+	int payload_len;
 
+	payload_len = (sd->sensor == SENSOR_OV772X) ? 2048 : 2040;
 	do {
-		len = min(remaining_len, 2040);		/*fixme: was 2048*/
+		len = min(remaining_len, payload_len);
 
 		/* Payloads are prefixed with a UVC-style header.  We
 		   consider a frame to start when the FID toggles, or the PTS
-- 
1.5.6.5
