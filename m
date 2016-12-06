Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-4.cisco.com ([173.38.203.54]:30066 "EHLO
        aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751388AbcLFKen (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2016 05:34:43 -0500
From: matrandg@cisco.com
To: linux-media@vger.kernel.org
Cc: Mats Randgaard <matrandg@cisco.com>
Subject: [PATCH 3/3] tc358743: ctrl_detect_tx_5v should always be updated
Date: Tue,  6 Dec 2016 11:24:29 +0100
Message-Id: <1481019869-20093-3-git-send-email-matrandg@cisco.com>
In-Reply-To: <1481019869-20093-1-git-send-email-matrandg@cisco.com>
References: <1481019869-20093-1-git-send-email-matrandg@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mats Randgaard <matrandg@cisco.com>

The control for +5V Power detection must also be updated when the EDID is
not present.

Signed-off-by: Mats Randgaard <matrandg@cisco.com>
---
 drivers/media/i2c/tc358743.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 257969a..f569a05 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -404,6 +404,7 @@ static void tc358743_enable_edid(struct v4l2_subdev *sd)
 
 	if (state->edid_blocks_written == 0) {
 		v4l2_dbg(2, debug, sd, "%s: no EDID -> no hotplug\n", __func__);
+		tc358743_s_ctrl_detect_tx_5v(sd);
 		return;
 	}
 
-- 
2.7.4

