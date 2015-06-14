Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:34019 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbbFNR3q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jun 2015 13:29:46 -0400
From: Yoshihiro Kaneko <ykaneko0929@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Damian Hobson-Garcia <dhobsong@igel.co.jp>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: [PATCH/RFC] v4l: vsp1: Change pixel count at scale-up setting
Date: Mon, 15 Jun 2015 02:29:14 +0900
Message-Id: <1434302954-31273-1-git-send-email-ykaneko0929@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Atsushi Akatsuka <atsushi.akatsuka.vb@hitachi.com>

This commit sets AMD bit of VI6_UDSn_CTRL register,
and modifies scaling formula to fit AMD bit.

Signed-off-by: Atsushi Akatsuka <atsushi.akatsuka.vb@hitachi.com>
Signed-off-by: Hiroki Negishi <hiroki.negishi.zr@hitachi-solutions.com>
Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
---

This patch is based on the master branch of linuxtv.org/media_tree.git.

 drivers/media/platform/vsp1/vsp1_uds.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index ccc8243..e7a046d 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -64,10 +64,10 @@ static unsigned int uds_output_size(unsigned int input, unsigned int ratio)
 		mp = ratio / 4096;
 		mp = mp < 4 ? 1 : (mp < 8 ? 2 : 4);
 
-		return (input - 1) / mp * mp * 4096 / ratio + 1;
+		return input / mp * mp * 4096 / ratio;
 	} else {
 		/* Up-scaling */
-		return (input - 1) * 4096 / ratio + 1;
+		return input * 4096 / ratio;
 	}
 }
 
@@ -145,7 +145,8 @@ static int uds_s_stream(struct v4l2_subdev *subdev, int enable)
 
 	vsp1_uds_write(uds, VI6_UDS_CTRL,
 		       (uds->scale_alpha ? VI6_UDS_CTRL_AON : 0) |
-		       (multitap ? VI6_UDS_CTRL_BC : 0));
+		       (multitap ? VI6_UDS_CTRL_BC : 0) |
+		       VI6_UDS_CTRL_AMD);
 
 	vsp1_uds_write(uds, VI6_UDS_PASS_BWIDTH,
 		       (uds_passband_width(hscale)
-- 
1.9.1

