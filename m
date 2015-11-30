Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:40652 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753276AbbK3U1l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Nov 2015 15:27:41 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, dheitmueller@kernellabs.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 07/11] cx25840: fix cx25840_s_stream for cx2388x and cx231xx
Date: Mon, 30 Nov 2015 21:27:17 +0100
Message-Id: <1448915241-415-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1448915241-415-1-git-send-email-hverkuil@xs4all.nl>
References: <1448915241-415-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

For those two devices the code wrote to addresses 0x115/6, but on
those devices those addresses have nothing to do with power controls.
So clearly this never worked. Rather than writing to bogus addresses,
just do nothing for the cx2388x and cx231xx.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/cx25840/cx25840-core.c | 37 ++++++++++++++++----------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
index d8b5343..a8b1a03 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.c
+++ b/drivers/media/i2c/cx25840/cx25840-core.c
@@ -1716,26 +1716,27 @@ static int cx25840_s_stream(struct v4l2_subdev *sd, int enable)
 
 	v4l_dbg(1, cx25840_debug, client, "%s video output\n",
 			enable ? "enable" : "disable");
+
+	/*
+	 * It's not clear what should be done for these devices.
+	 * The original code used the same addresses as for the cx25840, but
+	 * those addresses do something else entirely on the cx2388x and
+	 * cx231xx. Since it never did anything in the first place, just do
+	 * nothing.
+	 */
+	if (is_cx2388x(state) || is_cx231xx(state))
+		return 0;
+
 	if (enable) {
-		if (is_cx2388x(state) || is_cx231xx(state)) {
-			v = cx25840_read(client, 0x421) | 0x0b;
-			cx25840_write(client, 0x421, v);
-		} else {
-			v = cx25840_read(client, 0x115) | 0x0c;
-			cx25840_write(client, 0x115, v);
-			v = cx25840_read(client, 0x116) | 0x04;
-			cx25840_write(client, 0x116, v);
-		}
+		v = cx25840_read(client, 0x115) | 0x0c;
+		cx25840_write(client, 0x115, v);
+		v = cx25840_read(client, 0x116) | 0x04;
+		cx25840_write(client, 0x116, v);
 	} else {
-		if (is_cx2388x(state) || is_cx231xx(state)) {
-			v = cx25840_read(client, 0x421) & ~(0x0b);
-			cx25840_write(client, 0x421, v);
-		} else {
-			v = cx25840_read(client, 0x115) & ~(0x0c);
-			cx25840_write(client, 0x115, v);
-			v = cx25840_read(client, 0x116) & ~(0x04);
-			cx25840_write(client, 0x116, v);
-		}
+		v = cx25840_read(client, 0x115) & ~(0x0c);
+		cx25840_write(client, 0x115, v);
+		v = cx25840_read(client, 0x116) & ~(0x04);
+		cx25840_write(client, 0x116, v);
 	}
 	return 0;
 }
-- 
2.6.2

