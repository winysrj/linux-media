Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750926AbdIKW06 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 18:26:58 -0400
From: Kieran Bingham <kbingham@kernel.org>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        mchehab@kernel.org
Cc: niklas.soderlund@ragnatech.se, Simon Yuan <simon.yuan@navico.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH] media: i2c: adv748x: Map v4l2_std_id to the internal reg value
Date: Mon, 11 Sep 2017 23:26:53 +0100
Message-Id: <1505168813-13529-1-git-send-email-kbingham@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Simon Yuan <simon.yuan@navico.com>

The video standard was not mapped to the corresponding value of the
internal video standard in adv748x_afe_querystd, causing the wrong
video standard to be selected.

Fixes: 3e89586a64df ("media: i2c: adv748x: add adv748x driver")
Signed-off-by: Simon Yuan <simon.yuan@navico.com>
[Kieran: Obtain the std from the afe->curr_norm]
Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

---
Simon,

I've added your implicit Signed-off-by tag as part of resubmitting this
patch. Please confirm your agreement to this!

 drivers/media/i2c/adv748x/adv748x-afe.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-afe.c b/drivers/media/i2c/adv748x/adv748x-afe.c
index 134d981d69d3..5188178588c9 100644
--- a/drivers/media/i2c/adv748x/adv748x-afe.c
+++ b/drivers/media/i2c/adv748x/adv748x-afe.c
@@ -217,6 +217,7 @@ static int adv748x_afe_querystd(struct v4l2_subdev *sd, v4l2_std_id *std)
 {
 	struct adv748x_afe *afe = adv748x_sd_to_afe(sd);
 	struct adv748x_state *state = adv748x_afe_to_state(afe);
+	int afe_std;
 	int ret;
 
 	mutex_lock(&state->mutex);
@@ -235,8 +236,12 @@ static int adv748x_afe_querystd(struct v4l2_subdev *sd, v4l2_std_id *std)
 	/* Read detected standard */
 	ret = adv748x_afe_status(afe, NULL, std);
 
+	afe_std = adv748x_afe_std(afe->curr_norm);
+	if (afe_std < 0)
+		goto unlock;
+
 	/* Restore original state */
-	adv748x_afe_set_video_standard(state, afe->curr_norm);
+	adv748x_afe_set_video_standard(state, afe_std);
 
 unlock:
 	mutex_unlock(&state->mutex);
-- 
2.7.4
