Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:34451 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbbCOOdv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2015 10:33:51 -0400
From: Yoshihiro Kaneko <ykaneko0929@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: [PATCH/RFC] v4l: vsp1: Change VSP1 LIF linebuffer FIFO
Date: Sun, 15 Mar 2015 23:33:38 +0900
Message-Id: <1426430018-3172-1-git-send-email-ykaneko0929@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Yoshifumi Hosoya <yoshifumi.hosoya.wj@renesas.com>

Change to VSPD hardware recommended value.
Purpose is highest pixel clock without underruns.
In the default R-Car Linux BSP config this value is
wrong and therefore there are many underruns.

Here are the original settings:
HBTH = 1300 (VSPD stops when 1300 pixels are buffered)
LBTH = 200 (VSPD resumes when buffer level has decreased
            below 200 pixels)

The display underruns can be eliminated
by applying the following settings:
HBTH = 1504
LBTH = 1248

Reported-by: Peter Fiedler <peter.fiedler@renesas.com>
Signed-off-by: Yoshifumi Hosoya <yoshifumi.hosoya.wj@renesas.com>
Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
---

This patch is based on the master branch of linuxtv.org/media_tree.git.

 drivers/media/platform/vsp1/vsp1_lif.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_lif.c b/drivers/media/platform/vsp1/vsp1_lif.c
index 17a6ca7..7d0f7eb 100644
--- a/drivers/media/platform/vsp1/vsp1_lif.c
+++ b/drivers/media/platform/vsp1/vsp1_lif.c
@@ -1,7 +1,7 @@
 /*
  * vsp1_lif.c  --  R-Car VSP1 LCD Controller Interface
  *
- * Copyright (C) 2013-2014 Renesas Electronics Corporation
+ * Copyright (C) 2013-2015 Renesas Electronics Corporation
  *
  * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
  *
@@ -44,9 +44,9 @@ static int lif_s_stream(struct v4l2_subdev *subdev, int enable)
 {
 	const struct v4l2_mbus_framefmt *format;
 	struct vsp1_lif *lif = to_lif(subdev);
-	unsigned int hbth = 1300;
-	unsigned int obth = 400;
-	unsigned int lbth = 200;
+	unsigned int hbth = 1536;
+	unsigned int obth = 128;
+	unsigned int lbth = 1520;
 
 	if (!enable) {
 		vsp1_lif_write(lif, VI6_LIF_CTRL, 0);
-- 
1.9.1

