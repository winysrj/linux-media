Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1787 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab3HSOou (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Aug 2013 10:44:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: marbugge@cisco.com, matrandg@cisco.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 16/20] v4l2-dv-timings: rename v4l2_dv_valid_timings to v4l2_valid_dv_timings
Date: Mon, 19 Aug 2013 16:44:25 +0200
Message-Id: <1376923469-30694-17-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1376923469-30694-1-git-send-email-hverkuil@xs4all.nl>
References: <1376923469-30694-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

All other functions follow the v4l2_<foo>_dv_timings pattern, do the same for
this function.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/ad9389b.c               |  2 +-
 drivers/media/i2c/ths8200.c               |  2 +-
 drivers/media/v4l2-core/v4l2-dv-timings.c | 10 +++++-----
 include/media/v4l2-dv-timings.h           |  4 ++--
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/i2c/ad9389b.c b/drivers/media/i2c/ad9389b.c
index bb74fb6..fc60851 100644
--- a/drivers/media/i2c/ad9389b.c
+++ b/drivers/media/i2c/ad9389b.c
@@ -648,7 +648,7 @@ static int ad9389b_s_dv_timings(struct v4l2_subdev *sd,
 	v4l2_dbg(1, debug, sd, "%s:\n", __func__);
 
 	/* quick sanity check */
-	if (!v4l2_dv_valid_timings(timings, &ad9389b_timings_cap))
+	if (!v4l2_valid_dv_timings(timings, &ad9389b_timings_cap))
 		return -EINVAL;
 
 	/* Fill the optional fields .standards and .flags in struct v4l2_dv_timings
diff --git a/drivers/media/i2c/ths8200.c b/drivers/media/i2c/ths8200.c
index 580bd1b..6abf0fb 100644
--- a/drivers/media/i2c/ths8200.c
+++ b/drivers/media/i2c/ths8200.c
@@ -378,7 +378,7 @@ static int ths8200_s_dv_timings(struct v4l2_subdev *sd,
 
 	v4l2_dbg(1, debug, sd, "%s:\n", __func__);
 
-	if (!v4l2_dv_valid_timings(timings, &ths8200_timings_cap))
+	if (!v4l2_valid_dv_timings(timings, &ths8200_timings_cap))
 		return -EINVAL;
 
 	if (!v4l2_find_dv_timings_cap(timings, &ths8200_timings_cap, 10)) {
diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index f515997..a77f201 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -131,7 +131,7 @@ const struct v4l2_dv_timings v4l2_dv_timings_presets[] = {
 };
 EXPORT_SYMBOL_GPL(v4l2_dv_timings_presets);
 
-bool v4l2_dv_valid_timings(const struct v4l2_dv_timings *t,
+bool v4l2_valid_dv_timings(const struct v4l2_dv_timings *t,
 			   const struct v4l2_dv_timings_cap *dvcap)
 {
 	const struct v4l2_bt_timings *bt = &t->bt;
@@ -153,7 +153,7 @@ bool v4l2_dv_valid_timings(const struct v4l2_dv_timings *t,
 		return false;
 	return true;
 }
-EXPORT_SYMBOL_GPL(v4l2_dv_valid_timings);
+EXPORT_SYMBOL_GPL(v4l2_valid_dv_timings);
 
 int v4l2_enum_dv_timings_cap(struct v4l2_enum_dv_timings *t,
 			     const struct v4l2_dv_timings_cap *cap)
@@ -162,7 +162,7 @@ int v4l2_enum_dv_timings_cap(struct v4l2_enum_dv_timings *t,
 
 	memset(t->reserved, 0, sizeof(t->reserved));
 	for (i = idx = 0; v4l2_dv_timings_presets[i].bt.width; i++) {
-		if (v4l2_dv_valid_timings(v4l2_dv_timings_presets + i, cap) &&
+		if (v4l2_valid_dv_timings(v4l2_dv_timings_presets + i, cap) &&
 		    idx++ == t->index) {
 			t->timings = v4l2_dv_timings_presets[i];
 			return 0;
@@ -178,11 +178,11 @@ bool v4l2_find_dv_timings_cap(struct v4l2_dv_timings *t,
 {
 	int i;
 
-	if (!v4l2_dv_valid_timings(t, cap))
+	if (!v4l2_valid_dv_timings(t, cap))
 		return false;
 
 	for (i = 0; i < v4l2_dv_timings_presets[i].bt.width; i++) {
-		if (v4l2_dv_valid_timings(v4l2_dv_timings_presets + i, cap) &&
+		if (v4l2_valid_dv_timings(v4l2_dv_timings_presets + i, cap) &&
 		    v4l2_match_dv_timings(t, v4l2_dv_timings_presets + i, pclock_delta)) {
 			*t = v4l2_dv_timings_presets[i];
 			return true;
diff --git a/include/media/v4l2-dv-timings.h b/include/media/v4l2-dv-timings.h
index 0fe310b..bd59df8 100644
--- a/include/media/v4l2-dv-timings.h
+++ b/include/media/v4l2-dv-timings.h
@@ -27,14 +27,14 @@
  */
 extern const struct v4l2_dv_timings v4l2_dv_timings_presets[];
 
-/** v4l2_dv_valid_timings() - are these timings valid?
+/** v4l2_valid_dv_timings() - are these timings valid?
   * @t:	  the v4l2_dv_timings struct.
   * @cap: the v4l2_dv_timings_cap capabilities.
   *
   * Returns true if the given dv_timings struct is supported by the
   * hardware capabilities, returns false otherwise.
   */
-bool v4l2_dv_valid_timings(const struct v4l2_dv_timings *t,
+bool v4l2_valid_dv_timings(const struct v4l2_dv_timings *t,
 			   const struct v4l2_dv_timings_cap *cap);
 
 /** v4l2_enum_dv_timings_cap() - Helper function to enumerate possible DV timings based on capabilities
-- 
1.8.3.2

