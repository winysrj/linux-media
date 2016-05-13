Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:37634 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515AbcEMW1l (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 May 2016 18:27:41 -0400
From: Florian Echtler <floe@butterbrot.org>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, Florian Echtler <floe@butterbrot.org>,
	Martin Kaltenbrunner <modin@yuri.at>
Subject: [PATCH 2/3] lower poll interval to fix occasional FPS drops to ~56 FPS
Date: Fri, 13 May 2016 15:19:16 -0700
Message-Id: <1463177957-8240-2-git-send-email-floe@butterbrot.org>
In-Reply-To: <1463177957-8240-1-git-send-email-floe@butterbrot.org>
References: <1463177957-8240-1-git-send-email-floe@butterbrot.org>
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
index fcc5934..7b1052a1 100644
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

