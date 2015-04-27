Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:37246 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752622AbbD0HaG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Apr 2015 03:30:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 1/5] s5c73m3/s5k5baf/s5k6aa: fix compiler warnings
Date: Mon, 27 Apr 2015 09:29:51 +0200
Message-Id: <1430119795-16527-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1430119795-16527-1-git-send-email-hverkuil@xs4all.nl>
References: <1430119795-16527-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Fix these compiler warnings that appeared after switching to gcc-5.1.0:

drivers/media/i2c/s5k5baf.c: In function 's5k5baf_set_power':
drivers/media/i2c/s5k5baf.c:1057:10: warning: logical not is only applied to the left hand side of comparison [-Wlogical-not-parentheses]
  if (!on != state->power)
          ^
drivers/media/i2c/s5k6aa.c: In function 's5k6aa_set_power':
drivers/media/i2c/s5k6aa.c:878:10: warning: logical not is only applied to the left hand side of comparison [-Wlogical-not-parentheses]
  if (!on == s5k6aa->power) {
          ^
drivers/media/i2c/s5c73m3/s5c73m3-core.c: In function 's5c73m3_oif_set_power':
drivers/media/i2c/s5c73m3/s5c73m3-core.c:1456:17: warning: logical not is only applied to the left hand side of comparison [-Wlogical-not-parentheses]
  } else if (!on == state->power) {
                 ^

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Kamil Debski <k.debski@samsung.com>
---
 drivers/media/i2c/s5c73m3/s5c73m3-core.c | 2 +-
 drivers/media/i2c/s5k5baf.c              | 2 +-
 drivers/media/i2c/s5k6aa.c               | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index 08b234b..53c5ea8 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -1453,7 +1453,7 @@ static int s5c73m3_oif_set_power(struct v4l2_subdev *sd, int on)
 			state->apply_fiv = 1;
 			state->apply_fmt = 1;
 		}
-	} else if (!on == state->power) {
+	} else if (state->power == !on) {
 		ret = s5c73m3_set_af_softlanding(state);
 		if (!ret)
 			ret = __s5c73m3_power_off(state);
diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
index 297ef04..bee73de 100644
--- a/drivers/media/i2c/s5k5baf.c
+++ b/drivers/media/i2c/s5k5baf.c
@@ -1054,7 +1054,7 @@ static int s5k5baf_set_power(struct v4l2_subdev *sd, int on)
 
 	mutex_lock(&state->lock);
 
-	if (!on != state->power)
+	if (state->power != !on)
 		goto out;
 
 	if (on) {
diff --git a/drivers/media/i2c/s5k6aa.c b/drivers/media/i2c/s5k6aa.c
index de803a1..d0ad6a2 100644
--- a/drivers/media/i2c/s5k6aa.c
+++ b/drivers/media/i2c/s5k6aa.c
@@ -875,7 +875,7 @@ static int s5k6aa_set_power(struct v4l2_subdev *sd, int on)
 
 	mutex_lock(&s5k6aa->lock);
 
-	if (!on == s5k6aa->power) {
+	if (s5k6aa->power == !on) {
 		if (on) {
 			ret = __s5k6aa_power_on(s5k6aa);
 			if (!ret)
-- 
2.1.4

