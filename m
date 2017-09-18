Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:38702 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750710AbdIRECy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 00:02:54 -0400
From: Jacob Chen <jacob-chen@iotwrt.com>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mchehab@kernel.org,
        hansverk@cisco.com, Jacob Chen <jacob-chen@iotwrt.com>
Subject: [PATCH] media: i2c: tc358743: fix spelling mistake
Date: Mon, 18 Sep 2017 12:00:51 +0800
Message-Id: <1505707251-18947-1-git-send-email-jacob-chen@iotwrt.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It should be "LP-11".

Signed-off-by: Jacob Chen <jacob-chen@iotwrt.com>
---
 drivers/media/i2c/tc358743.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index e6f5c36..c208c30 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1488,7 +1488,7 @@ static int tc358743_s_stream(struct v4l2_subdev *sd, int enable)
 {
 	enable_stream(sd, enable);
 	if (!enable) {
-		/* Put all lanes in PL-11 state (STOPSTATE) */
+		/* Put all lanes in LP-11 state (STOPSTATE) */
 		tc358743_set_csi(sd);
 	}
 
-- 
2.7.4
