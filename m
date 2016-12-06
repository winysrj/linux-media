Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:3963 "EHLO
        aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751388AbcLFKer (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2016 05:34:47 -0500
From: matrandg@cisco.com
To: linux-media@vger.kernel.org
Cc: Mats Randgaard <matrandg@cisco.com>
Subject: [PATCH 2/3] tc358743: Disable HDCP with "manual HDCP authentication" bit
Date: Tue,  6 Dec 2016 11:24:28 +0100
Message-Id: <1481019869-20093-2-git-send-email-matrandg@cisco.com>
In-Reply-To: <1481019869-20093-1-git-send-email-matrandg@cisco.com>
References: <1481019869-20093-1-git-send-email-matrandg@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mats Randgaard <matrandg@cisco.com>

Originally Toshiba told us that the only way to disable HDCP was to
set the receiver in repeater mode, that would make the authentication
fail because of missing software support. It has worked fine with all
the sources we and our customers has used, until it was reported
problems with Apple MacBook (Retina, 12-inch, Early 2015)
(https://support.apple.com/kb/SP712?locale=en_US&viewlocale=en_US)
with Apple A1612 USB type-C multiport adapter
(http://www.apple.com/shop/product/MJ1K2AM/A/usb-c-digital-av-multiport-adapter)

Finally Toshiba came up with a hidden bit that is named "Manual HDCP
authentication". In this patch the original "repeater mode" concept is
removed, and the new bit is set instead.

With his patch HDCP is disabled when connected to the Apple MacBook
and all other sources we have tested so far. The Apple MacBook is
constantly trying to authenticate, but fails and continues to transmit
unencrypted video.

Signed-off-by: Mats Randgaard <matrandg@cisco.com>
---
 drivers/media/i2c/tc358743.c      | 32 ++++++++++++--------------------
 drivers/media/i2c/tc358743_regs.h |  1 +
 2 files changed, 13 insertions(+), 20 deletions(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index a35aaf8..257969a 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -368,29 +368,21 @@ static void tc358743_set_hdmi_hdcp(struct v4l2_subdev *sd, bool enable)
 	v4l2_dbg(2, debug, sd, "%s: %s\n", __func__, enable ?
 				"enable" : "disable");
 
-	i2c_wr8_and_or(sd, HDCP_REG1,
-			~(MASK_AUTH_UNAUTH_SEL | MASK_AUTH_UNAUTH),
-			MASK_AUTH_UNAUTH_SEL_16_FRAMES | MASK_AUTH_UNAUTH_AUTO);
+	if (enable) {
+		i2c_wr8_and_or(sd, HDCP_REG3, ~KEY_RD_CMD, KEY_RD_CMD);
 
-	i2c_wr8_and_or(sd, HDCP_REG2, ~MASK_AUTO_P3_RESET,
-			SET_AUTO_P3_RESET_FRAMES(0x0f));
+		i2c_wr8_and_or(sd, HDCP_MODE, ~MASK_MANUAL_AUTHENTICATION, 0);
 
-	/* HDCP is disabled by configuring the receiver as HDCP repeater. The
-	 * repeater mode require software support to work, so HDCP
-	 * authentication will fail.
-	 */
-	i2c_wr8_and_or(sd, HDCP_REG3, ~KEY_RD_CMD, enable ? KEY_RD_CMD : 0);
-	i2c_wr8_and_or(sd, HDCP_MODE, ~(MASK_AUTO_CLR | MASK_MODE_RST_TN),
-			enable ?  (MASK_AUTO_CLR | MASK_MODE_RST_TN) : 0);
+		i2c_wr8_and_or(sd, HDCP_REG1, 0xff,
+				MASK_AUTH_UNAUTH_SEL_16_FRAMES |
+				MASK_AUTH_UNAUTH_AUTO);
 
-	/* Apple MacBook Pro gen.8 has a bug that makes it freeze every fifth
-	 * second when HDCP is disabled, but the MAX_EXCED bit is handled
-	 * correctly and HDCP is disabled on the HDMI output.
-	 */
-	i2c_wr8_and_or(sd, BSTATUS1, ~MASK_MAX_EXCED,
-			enable ? 0 : MASK_MAX_EXCED);
-	i2c_wr8_and_or(sd, BCAPS, ~(MASK_REPEATER | MASK_READY),
-			enable ? 0 : MASK_REPEATER | MASK_READY);
+		i2c_wr8_and_or(sd, HDCP_REG2, ~MASK_AUTO_P3_RESET,
+				SET_AUTO_P3_RESET_FRAMES(0x0f));
+	} else {
+		i2c_wr8_and_or(sd, HDCP_MODE, ~MASK_MANUAL_AUTHENTICATION,
+				MASK_MANUAL_AUTHENTICATION);
+	}
 }
 
 static void tc358743_disable_edid(struct v4l2_subdev *sd)
diff --git a/drivers/media/i2c/tc358743_regs.h b/drivers/media/i2c/tc358743_regs.h
index 81f1db5..657ef50 100644
--- a/drivers/media/i2c/tc358743_regs.h
+++ b/drivers/media/i2c/tc358743_regs.h
@@ -420,6 +420,7 @@
 #define MASK_MODE_RST_TN                      0x20
 #define MASK_LINE_REKEY                       0x10
 #define MASK_AUTO_CLR                         0x04
+#define MASK_MANUAL_AUTHENTICATION            0x02 /* Not in REF_01 */
 
 #define HDCP_REG1                             0x8563 /* Not in REF_01 */
 #define MASK_AUTH_UNAUTH_SEL                  0x70
-- 
2.7.4

