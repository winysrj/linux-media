Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:46397 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbaAXODA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jan 2014 09:03:00 -0500
From: Martin Bugge <marbugge@cisco.com>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Mats Randgaard <matrandg@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/4] [media] adv7842: platform-data for Hotplug Active (HPA) manual/auto
Date: Fri, 24 Jan 2014 14:50:06 +0100
Message-Id: <1390571406-11215-5-git-send-email-marbugge@cisco.com>
In-Reply-To: <1390571406-11215-1-git-send-email-marbugge@cisco.com>
References: <1390571406-11215-1-git-send-email-marbugge@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This apply to HDMI-map register 0x69.
So far we have been using HPA manual mode.
This way we had control of HPA which could be
set after EDID had been programmed.

Using a Mac Mini with mini-displayport to DVI-D converter as source
caused the adv7842 to lock up and fail to detect any further signals.

After experimenting with different configurations it was found that
using the HPA auto mode and in addition letting RX-termination
be controlled by HPA prevented this error from occuring.

I was not able to re-create this problem on the adv7604.

Cc: Mats Randgaard <matrandg@cisco.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Martin Bugge <marbugge@cisco.com>
---
 drivers/media/i2c/adv7842.c | 12 +++++++++---
 include/media/adv7842.h     |  3 +++
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 209b175..e04fe3f 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -2693,9 +2693,15 @@ static int adv7842_core_init(struct v4l2_subdev *sd)
 	/* disable I2C access to internal EDID ram from HDMI DDC ports */
 	rep_write_and_or(sd, 0x77, 0xf3, 0x00);
 
-	hdmi_write(sd, 0x69, 0xa3); /* HPA manual */
-	/* HPA disable on port A and B */
-	io_write_and_or(sd, 0x20, 0xcf, 0x00);
+	if (pdata->hpa_auto) {
+		/* HPA auto, HPA 0.5s after Edid set and Cable detect */
+		hdmi_write(sd, 0x69, 0x5c);
+	} else {
+		/* HPA manual */
+		hdmi_write(sd, 0x69, 0xa3);
+		/* HPA disable on port A and B */
+		io_write_and_or(sd, 0x20, 0xcf, 0x00);
+	}
 
 	/* LLC */
 	io_write(sd, 0x19, 0x80 | pdata->llc_dll_phase);
diff --git a/include/media/adv7842.h b/include/media/adv7842.h
index 3932209..924cbb8 100644
--- a/include/media/adv7842.h
+++ b/include/media/adv7842.h
@@ -220,6 +220,9 @@ struct adv7842_platform_data {
 	unsigned sdp_free_run_cbar_en:1;
 	unsigned sdp_free_run_force:1;
 
+	/* HPA manual (0) or auto (1), affects HDMI register 0x69 */
+	unsigned hpa_auto:1;
+
 	struct adv7842_sdp_csc_coeff sdp_csc_coeff;
 
 	struct adv7842_sdp_io_sync_adjustment sdp_io_sync_625;
-- 
1.8.1.4

