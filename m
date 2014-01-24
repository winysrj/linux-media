Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:41020 "EHLO
	aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbaAXORe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jan 2014 09:17:34 -0500
From: Martin Bugge <marbugge@cisco.com>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Mats Randgaard <matrandg@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/4] [media] adv7842: pixelclock read-out
Date: Fri, 24 Jan 2014 14:50:04 +0100
Message-Id: <1390571406-11215-3-git-send-email-marbugge@cisco.com>
In-Reply-To: <1390571406-11215-1-git-send-email-marbugge@cisco.com>
References: <1390571406-11215-1-git-send-email-marbugge@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Incorrect registers used for pixelclock read-out.
Same registers as for adv7604 which actually gave an almost
correct read-out, even they are not documented for adv7842.
Corrected deep-color pixel-clock correction.

Cc: Mats Randgaard <matrandg@cisco.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Martin Bugge <marbugge@cisco.com>
---
 drivers/media/i2c/adv7842.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index f7a4d79..3aa1a7c 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -1449,12 +1449,11 @@ static int adv7842_query_dv_timings(struct v4l2_subdev *sd,
 
 		bt->width = (hdmi_read(sd, 0x07) & 0x0f) * 256 + hdmi_read(sd, 0x08);
 		bt->height = (hdmi_read(sd, 0x09) & 0x0f) * 256 + hdmi_read(sd, 0x0a);
-		freq = (hdmi_read(sd, 0x06) * 1000000) +
-		       ((hdmi_read(sd, 0x3b) & 0x30) >> 4) * 250000;
-
+		freq = ((hdmi_read(sd, 0x51) << 1) + (hdmi_read(sd, 0x52) >> 7)) * 1000000;
+		freq += ((hdmi_read(sd, 0x52) & 0x7f) * 7813);
 		if (is_hdmi(sd)) {
 			/* adjust for deep color mode */
-			freq = freq * 8 / (((hdmi_read(sd, 0x0b) & 0xc0) >> 5) + 8);
+			freq = freq * 8 / (((hdmi_read(sd, 0x0b) & 0xc0) >> 6) * 2 + 8);
 		}
 		bt->pixelclock = freq;
 		bt->hfrontporch = (hdmi_read(sd, 0x20) & 0x03) * 256 +
-- 
1.8.1.4

