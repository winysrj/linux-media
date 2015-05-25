Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:33082 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019AbbEYMEX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2015 08:04:23 -0400
From: Florian Echtler <floe@butterbrot.org>
To: hans.verkuil@cisco.com, mchehab@osg.samsung.com
Cc: linux-media@vger.kernel.org, modin@yuri.at,
	Florian Echtler <floe@butterbrot.org>
Subject: [PATCHv2 1/4] reduce poll interval to allow full 60 FPS framerate
Date: Mon, 25 May 2015 14:04:13 +0200
Message-Id: <1432555456-20292-2-git-send-email-floe@butterbrot.org>
In-Reply-To: <1432555456-20292-1-git-send-email-floe@butterbrot.org>
References: <1432555456-20292-1-git-send-email-floe@butterbrot.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The SUR40 hardware can deliver images at up to 60 FPS; at full USB2 bandwidth,
one raw frame will take about 11 ms to transmit. If the poll interval is above
5 ms, fully handling one frame will take longer than 16 ms and the overall 
frame rate will drop below 60 FPS. To get the full frame rate without blocking
all the time and still allowing for a bit of timing jitter, we reduce the poll
interval to 4 ms.

Signed-off-by: Martin Kaltenbrunner <modin@yuri.at>
Signed-off-by: Florian Echtler <floe@butterbrot.org>
---
 drivers/input/touchscreen/sur40.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
index a24eba5..e707b8d 100644
--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -125,7 +125,7 @@ struct sur40_image_header {
 #define VIDEO_PACKET_SIZE  16384
 
 /* polling interval (ms) */
-#define POLL_INTERVAL 10
+#define POLL_INTERVAL 4
 
 /* maximum number of contacts FIXME: this is a guess? */
 #define MAX_CONTACTS 64
-- 
1.9.1

