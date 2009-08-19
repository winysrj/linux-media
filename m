Return-path: <linux-media-owner@vger.kernel.org>
Received: from jim.sh ([75.150.123.25]:54961 "EHLO psychosis.jim.sh"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173AbZHSVrO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2009 17:47:14 -0400
From: Jim Paris <jim@jtan.com>
To: stable@kernel.org
Cc: linux-media@vger.kernel.org, Jim Paris <jim@jtan.com>
Subject: [PATCH] gspca - ov534: Fix ov772x
Date: Wed, 19 Aug 2009 17:46:18 -0400
Message-Id: <1250718378-25759-1-git-send-email-jim@jtan.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The scan of the image packets of the sensor ov772x was broken when
the sensor ov965x was added.

[ Based on upstream c874f3aa, modified slightly for v2.6.30.5 ]

Signed-off-by: Jim Paris <jim@jtan.com>
Acked-by: Jean-Francois Moine <moinejf@free.fr>
---

Hi,

Commit 84fbdf87ab8eaa4eaefb317a7eb437cd4d3d0ebf:
  "V4L/DVB (11105): gspca - ov534: Adjust the packet scan function"
broke the gspca ov534 driver for the Playstation Eye in 2.6.30.

Commit c874f3aa7e66158dccb2b9f3cfc46c65af6c223d:
  "V4L/DVB (11973): gspca - ov534: Do the ov772x work again."
fixed it for 2.6.31.

c874f3aa depends on earlier patches, so this is a functionally
equivalent version for 2.6.30.x.  With this patch, the Playstation Eye
camera works again.

Please consider for 2.6.30.6.

Thanks,
-jim


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

