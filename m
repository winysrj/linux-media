Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:47604 "EHLO
        bin-mail-out-05.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751938AbeCZWJ7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 18:09:59 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v3] i2c: adv748x: afe: fix sparse warning
Date: Tue, 27 Mar 2018 00:09:51 +0200
Message-Id: <20180326220951.9262-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes the following sparse warning:

drivers/media/i2c/adv748x/adv748x-afe.c:294:34:    expected unsigned int [usertype] *signal
drivers/media/i2c/adv748x/adv748x-afe.c:294:34:    got int *<noident>
drivers/media/i2c/adv748x/adv748x-afe.c:294:34: warning: incorrect type in argument 2 (different signedness)

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

---

* Changes since v2
- Add review tag from Kieran.
- Send to correct mail address for linux-media so it shows up in
  patchwork.

* Changes since v1
- Use u32 instead of unsigned int as suggested by Geert.
---
 drivers/media/i2c/adv748x/adv748x-afe.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-afe.c b/drivers/media/i2c/adv748x/adv748x-afe.c
index 5188178588c9067d..61514bae7e5ceb42 100644
--- a/drivers/media/i2c/adv748x/adv748x-afe.c
+++ b/drivers/media/i2c/adv748x/adv748x-afe.c
@@ -275,7 +275,8 @@ static int adv748x_afe_s_stream(struct v4l2_subdev *sd, int enable)
 {
 	struct adv748x_afe *afe = adv748x_sd_to_afe(sd);
 	struct adv748x_state *state = adv748x_afe_to_state(afe);
-	int ret, signal = V4L2_IN_ST_NO_SIGNAL;
+	u32 signal = V4L2_IN_ST_NO_SIGNAL;
+	int ret;
 
 	mutex_lock(&state->mutex);
 
-- 
2.16.2
