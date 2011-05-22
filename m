Return-path: <mchehab@pedra>
Received: from smtp5-g21.free.fr ([212.27.42.5]:46544 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450Ab1EVISe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 May 2011 04:18:34 -0400
Received: from tele (unknown [82.245.201.222])
	by smtp5-g21.free.fr (Postfix) with ESMTP id 02CA3D4824C
	for <linux-media@vger.kernel.org>; Sun, 22 May 2011 10:18:28 +0200 (CEST)
Date: Sun, 22 May 2011 10:19:04 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: [PATCH FOR 2.6.39] gspca - ov519: Change the ovfx2 bulk transfer
 size
Message-ID: <20110522101904.5d12af63@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The 'normal' bulk transfer size did not work for 800x600.
By git commit c42cedbb658b, this 'normal' size was used for 1600x1200 only.
It will now be used back again for all resolutions but 800x600.

Signed-off-by: Jean-François Moine <moinejf@free.fr>
---
 drivers/media/video/gspca/ov519.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/gspca/ov519.c b/drivers/media/video/gspca/ov519.c
index 5ac2f3c..caf438a 100644
--- a/drivers/media/video/gspca/ov519.c
+++ b/drivers/media/video/gspca/ov519.c
@@ -609,7 +609,7 @@ static const struct v4l2_pix_format ovfx2_ov3610_mode[] = {
  * buffers, there are some pretty strict real time constraints for
  * isochronous transfer for larger frame sizes).
  */
-/*jfm: this value works well for 1600x1200, but not 800x600 - see isoc_init */
+/*jfm: this value does not work for 800x600 - see isoc_init */
 #define OVFX2_BULK_SIZE (13 * 4096)
 
 /* I2C registers */
@@ -3511,7 +3511,7 @@ static int sd_isoc_init(struct gspca_dev *gspca_dev)
 
 	switch (sd->bridge) {
 	case BRIDGE_OVFX2:
-		if (gspca_dev->width == 1600)
+		if (gspca_dev->width != 800)
 			gspca_dev->cam.bulk_size = OVFX2_BULK_SIZE;
 		else
 			gspca_dev->cam.bulk_size = 7 * 4096;
-- 
1.7.5.1
