Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:19584 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbbLNHuD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Dec 2015 02:50:03 -0500
From: Tuukka Toivonen <tuukka.toivonen@intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [yavta PATCH v2] Return proper error code if STREAMON fails
Date: Mon, 14 Dec 2015 09:49:57 +0200
Message-ID: <1737708.1znbc4YfP6@ttoivone-desk1>
In-Reply-To: <181264909.M62ZDuucnX@ttoivone-desk1>
References: <207011196.fyjkdD1C8L@ttoivone-desk1> <2149558.6ozUHQXHtS@avalon> <181264909.M62ZDuucnX@ttoivone-desk1>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Return the error code if video_enable() and VIDIOC_STREAMON
fails.

Signed-off-by: Tuukka Toivonen <tuukka.toivonen@intel.com>
---
 yavta.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/yavta.c b/yavta.c
index b627725..3d80d3c 100644
--- a/yavta.c
+++ b/yavta.c
@@ -1708,7 +1708,9 @@ static int video_do_capture(struct device *dev, unsigned int nframes,
 	}
 
 	/* Stop streaming. */
-	video_enable(dev, 0);
+	ret = video_enable(dev, 0);
+	if (ret < 0)
+		return ret;
 
 	if (nframes == 0) {
 		printf("No frames captured.\n");
-- 
1.9.1

