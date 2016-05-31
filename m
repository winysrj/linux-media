Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:51075 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756411AbcEaUPx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2016 16:15:53 -0400
From: Florian Echtler <floe@butterbrot.org>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: linux-input@vger.kernel.org, Florian Echtler <floe@butterbrot.org>,
	Martin Kaltenbrunner <modin@yuri.at>
Subject: [PATCH v2 2/3] sur40: lower poll interval to fix occasional FPS drops to ~56 FPS
Date: Tue, 31 May 2016 22:15:32 +0200
Message-Id: <1464725733-22119-2-git-send-email-floe@butterbrot.org>
In-Reply-To: <1464725733-22119-1-git-send-email-floe@butterbrot.org>
References: <1464725733-22119-1-git-send-email-floe@butterbrot.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The framerate sometimes drops below 60 Hz if the poll interval is too high.
Lowering it to the minimum of 1 ms fixes this.

Signed-off-by: Martin Kaltenbrunner <modin@yuri.at>
Signed-off-by: Florian Echtler <floe@butterbrot.org>
---
 drivers/input/touchscreen/sur40.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
index 4b1f703..64e588c 100644
--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -126,7 +126,7 @@ struct sur40_image_header {
 #define VIDEO_PACKET_SIZE  16384
 
 /* polling interval (ms) */
-#define POLL_INTERVAL 4
+#define POLL_INTERVAL 1
 
 /* maximum number of contacts FIXME: this is a guess? */
 #define MAX_CONTACTS 64
-- 
1.9.1

