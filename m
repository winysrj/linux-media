Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59048 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756336AbcJNUWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 16:22:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 04/57] [media] cx25840: don't break long lines
Date: Fri, 14 Oct 2016 17:19:52 -0300
Message-Id: <fc31387c77cd27e0ca1284f349b6dbe58c2d3263.1476475771.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols checkpatch warnings, several strings
were broken into multiple lines. This is not considered
a good practice anymore, as it makes harder to grep for
strings at the source code. So, join those continuation
lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/i2c/cx25840/cx25840-core.c | 11 +++--------
 drivers/media/i2c/cx25840/cx25840-ir.c   |  6 ++----
 2 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
index 142ae28803bb..0dcf450052ac 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.c
+++ b/drivers/media/i2c/cx25840/cx25840-core.c
@@ -873,10 +873,7 @@ void cx25840_std_setup(struct i2c_client *client)
 					"Chroma sub-carrier freq = %d.%06d MHz\n",
 					fsc / 1000000, fsc % 1000000);
 
-			v4l_dbg(1, cx25840_debug, client, "hblank %i, hactive %i, "
-				"vblank %i, vactive %i, vblank656 %i, src_dec %i, "
-				"burst 0x%02x, luma_lpf %i, uv_lpf %i, comb 0x%02x, "
-				"sc 0x%06x\n",
+			v4l_dbg(1, cx25840_debug, client, "hblank %i, hactive %i, vblank %i, vactive %i, vblank656 %i, src_dec %i, burst 0x%02x, luma_lpf %i, uv_lpf %i, comb 0x%02x, sc 0x%06x\n",
 				hblank, hactive, vblank, vactive, vblank656,
 				src_decimation, burst, luma_lpf, uv_lpf, comb, sc);
 		}
@@ -5169,11 +5166,9 @@ static int cx25840_probe(struct i2c_client *client,
 		id = CX2310X_AV;
 	} else if ((device_id & 0xff) == (device_id >> 8)) {
 		v4l_err(client,
-			"likely a confused/unresponsive cx2388[578] A/V decoder"
-			" found @ 0x%x (%s)\n",
+			"likely a confused/unresponsive cx2388[578] A/V decoder found @ 0x%x (%s)\n",
 			client->addr << 1, client->adapter->name);
-		v4l_err(client, "A method to reset it from the cx25840 driver"
-			" software is not known at this time\n");
+		v4l_err(client, "A method to reset it from the cx25840 driver software is not known at this time\n");
 		return -ENODEV;
 	} else {
 		v4l_dbg(1, cx25840_debug, client, "cx25840 not found\n");
diff --git a/drivers/media/i2c/cx25840/cx25840-ir.c b/drivers/media/i2c/cx25840/cx25840-ir.c
index 4b782012cadc..291f7d0a1c5c 100644
--- a/drivers/media/i2c/cx25840/cx25840-ir.c
+++ b/drivers/media/i2c/cx25840/cx25840-ir.c
@@ -1113,8 +1113,7 @@ int cx25840_ir_log_status(struct v4l2_subdev *sd)
 			j = 0;
 			break;
 		}
-		v4l2_info(sd, "\tNext carrier edge window:          16 clocks "
-			  "-%1d/+%1d, %u to %u Hz\n", i, j,
+		v4l2_info(sd, "\tNext carrier edge window:          16 clocks -%1d/+%1d, %u to %u Hz\n", i, j,
 			  clock_divider_to_freq(rxclk, 16 + j),
 			  clock_divider_to_freq(rxclk, 16 - i));
 	}
@@ -1124,8 +1123,7 @@ int cx25840_ir_log_status(struct v4l2_subdev *sd)
 	v4l2_info(sd, "\tLow pass filter:                   %s\n",
 		  filtr ? "enabled" : "disabled");
 	if (filtr)
-		v4l2_info(sd, "\tMin acceptable pulse width (LPF):  %u us, "
-			  "%u ns\n",
+		v4l2_info(sd, "\tMin acceptable pulse width (LPF):  %u us, %u ns\n",
 			  lpf_count_to_us(filtr),
 			  lpf_count_to_ns(filtr));
 	v4l2_info(sd, "\tPulse width timer timed-out:       %s\n",
-- 
2.7.4


