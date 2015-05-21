Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:48935 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754119AbbEUMhQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 08:37:16 -0400
From: Florian Echtler <floe@butterbrot.org>
To: hans.verkuil@cisco.com, mchehab@osg.samsung.com,
	linux-media@vger.kernel.org
Cc: modin@yuri.at, Florian Echtler <floe@butterbrot.org>
Subject: [PATCH 1/4] reduce poll interval to allow full 60 FPS framerate
Date: Thu, 21 May 2015 14:29:39 +0200
Message-Id: <1432211382-5155-2-git-send-email-floe@butterbrot.org>
In-Reply-To: <1432211382-5155-1-git-send-email-floe@butterbrot.org>
References: <1432211382-5155-1-git-send-email-floe@butterbrot.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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

