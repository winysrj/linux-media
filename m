Return-path: <linux-media-owner@vger.kernel.org>
Received: from msa103.auone-net.jp ([61.117.18.163]:36271 "EHLO
	msa103.auone-net.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab0AVHyt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jan 2010 02:54:49 -0500
Date: Fri, 22 Jan 2010 16:54:46 +0900
From: Kusanagi Kouichi <slash@ac.auone-net.jp>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] cx25840: Fix composite detection.
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Message-Id: <20100122075447.B553714C03D@msa103.auone-net.jp>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If CX25840_VIN1_CH1 and the like is used, input is not detected as composite.
Their value is 0x800000XX and CX25840_COMPONENT_ON is 0x80000200. So

   739			else if ((vid_input & CX25840_COMPONENT_ON) == 0)

this condition never be true.

Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
---
 drivers/media/video/cx25840/cx25840-core.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/cx25840/cx25840-core.c b/drivers/media/video/cx25840/cx25840-core.c
index 385ecd5..764c811 100644
--- a/drivers/media/video/cx25840/cx25840-core.c
+++ b/drivers/media/video/cx25840/cx25840-core.c
@@ -734,10 +734,8 @@ static int set_input(struct i2c_client *client, enum cx25840_video_input vid_inp
 		v4l_dbg(1, cx25840_debug, client, "vid_input 0x%x\n",
 			vid_input);
 		reg = vid_input & 0xff;
-		if ((vid_input & CX25840_SVIDEO_ON) == CX25840_SVIDEO_ON)
-			is_composite = 0;
-		else if ((vid_input & CX25840_COMPONENT_ON) == 0)
-			is_composite = 1;
+		is_composite = !is_component &&
+			((vid_input & CX25840_SVIDEO_ON) != CX25840_SVIDEO_ON);
 
 		v4l_dbg(1, cx25840_debug, client, "mux cfg 0x%x comp=%d\n",
 			reg, is_composite);
-- 
1.6.6

