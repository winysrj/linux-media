Return-path: <mchehab@pedra>
Received: from smtp5-g21.free.fr ([212.27.42.5]:43054 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539Ab1EVIQF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 May 2011 04:16:05 -0400
Received: from tele (unknown [82.245.201.222])
	by smtp5-g21.free.fr (Postfix) with ESMTP id F197AD4821B
	for <linux-media@vger.kernel.org>; Sun, 22 May 2011 10:15:58 +0200 (CEST)
Date: Sun, 22 May 2011 10:16:34 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: [PATCH FOR 2.6.39] gspca - ov519: Fix a regression for ovfx2
 webcams
Message-ID: <20110522101634.33e10357@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

By git commit c42cedbb658b, the bulk transfer size was changed to a lower
value for resolutions != 1600x1200, but the image extraction routine still
worked with the previous value, giving bad truncated images.

Signed-off-by: Jean-François Moine <moinejf@free.fr>
---
 drivers/media/video/gspca/ov519.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/gspca/ov519.c b/drivers/media/video/gspca/ov519.c
index 36a46fc..5ac2f3c 100644
--- a/drivers/media/video/gspca/ov519.c
+++ b/drivers/media/video/gspca/ov519.c
@@ -4478,7 +4478,7 @@ static void ovfx2_pkt_scan(struct gspca_dev *gspca_dev,
 	gspca_frame_add(gspca_dev, INTER_PACKET, data, len);
 
 	/* A short read signals EOF */
-	if (len < OVFX2_BULK_SIZE) {
+	if (len < gspca_dev->cam.bulk_size) {
 		/* If the frame is short, and it is one of the first ones
 		   the sensor and bridge are still syncing, so drop it. */
 		if (sd->first_frame) {
-- 
1.7.5.1
