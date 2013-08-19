Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1068 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab3HSOou (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Aug 2013 10:44:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: marbugge@cisco.com, matrandg@cisco.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 17/20] v4l2-dv-timings: add callback to handle exceptions
Date: Mon, 19 Aug 2013 16:44:26 +0200
Message-Id: <1376923469-30694-18-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1376923469-30694-1-git-send-email-hverkuil@xs4all.nl>
References: <1376923469-30694-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

In most cases the v4l2_bt_timings_cap struct has all the information
necessary to determine valid timings, but occasionally there are exceptions.

Add a callback function to be able to test for those exceptions.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/ad9389b.c               |  7 ++++---
 drivers/media/i2c/ths8200.c               |  9 +++++---
 drivers/media/v4l2-core/v4l2-dv-timings.c | 25 +++++++++++++++--------
 include/media/v4l2-dv-timings.h           | 34 +++++++++++++++++++++++++------
 4 files changed, 55 insertions(+), 20 deletions(-)

diff --git a/drivers/media/i2c/ad9389b.c b/drivers/media/i2c/ad9389b.c
index fc60851..8369786 100644
--- a/drivers/media/i2c/ad9389b.c
+++ b/drivers/media/i2c/ad9389b.c
@@ -648,12 +648,12 @@ static int ad9389b_s_dv_timings(struct v4l2_subdev *sd,
 	v4l2_dbg(1, debug, sd, "%s:\n", __func__);
 
 	/* quick sanity check */
-	if (!v4l2_valid_dv_timings(timings, &ad9389b_timings_cap))
+	if (!v4l2_valid_dv_timings(timings, &ad9389b_timings_cap, NULL, NULL))
 		return -EINVAL;
 
 	/* Fill the optional fields .standards and .flags in struct v4l2_dv_timings
 	   if the format is one of the CEA or DMT timings. */
-	v4l2_find_dv_timings_cap(timings, &ad9389b_timings_cap, 0);
+	v4l2_find_dv_timings_cap(timings, &ad9389b_timings_cap, 0, NULL, NULL);
 
 	timings->bt.flags &= ~V4L2_DV_FL_REDUCED_FPS;
 
@@ -691,7 +691,8 @@ static int ad9389b_g_dv_timings(struct v4l2_subdev *sd,
 static int ad9389b_enum_dv_timings(struct v4l2_subdev *sd,
 			struct v4l2_enum_dv_timings *timings)
 {
-	return v4l2_enum_dv_timings_cap(timings, &ad9389b_timings_cap);
+	return v4l2_enum_dv_timings_cap(timings, &ad9389b_timings_cap,
+			NULL, NULL);
 }
 
 static int ad9389b_dv_timings_cap(struct v4l2_subdev *sd,
diff --git a/drivers/media/i2c/ths8200.c b/drivers/media/i2c/ths8200.c
index 6abf0fb..a58a8f6 100644
--- a/drivers/media/i2c/ths8200.c
+++ b/drivers/media/i2c/ths8200.c
@@ -378,10 +378,12 @@ static int ths8200_s_dv_timings(struct v4l2_subdev *sd,
 
 	v4l2_dbg(1, debug, sd, "%s:\n", __func__);
 
-	if (!v4l2_valid_dv_timings(timings, &ths8200_timings_cap))
+	if (!v4l2_valid_dv_timings(timings, &ths8200_timings_cap,
+				NULL, NULL))
 		return -EINVAL;
 
-	if (!v4l2_find_dv_timings_cap(timings, &ths8200_timings_cap, 10)) {
+	if (!v4l2_find_dv_timings_cap(timings, &ths8200_timings_cap, 10,
+				NULL, NULL)) {
 		v4l2_dbg(1, debug, sd, "Unsupported format\n");
 		return -EINVAL;
 	}
@@ -411,7 +413,8 @@ static int ths8200_g_dv_timings(struct v4l2_subdev *sd,
 static int ths8200_enum_dv_timings(struct v4l2_subdev *sd,
 				   struct v4l2_enum_dv_timings *timings)
 {
-	return v4l2_enum_dv_timings_cap(timings, &ths8200_timings_cap);
+	return v4l2_enum_dv_timings_cap(timings, &ths8200_timings_cap,
+			NULL, NULL);
 }
 
 static int ths8200_dv_timings_cap(struct v4l2_subdev *sd,
diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index a77f201..ee52b9f4 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -132,7 +132,9 @@ const struct v4l2_dv_timings v4l2_dv_timings_presets[] = {
 EXPORT_SYMBOL_GPL(v4l2_dv_timings_presets);
 
 bool v4l2_valid_dv_timings(const struct v4l2_dv_timings *t,
-			   const struct v4l2_dv_timings_cap *dvcap)
+			   const struct v4l2_dv_timings_cap *dvcap,
+			   v4l2_check_dv_timings_fnc fnc,
+			   void *fnc_handle)
 {
 	const struct v4l2_bt_timings *bt = &t->bt;
 	const struct v4l2_bt_timings_cap *cap = &dvcap->bt;
@@ -151,18 +153,21 @@ bool v4l2_valid_dv_timings(const struct v4l2_dv_timings *t,
 	    (bt->interlaced && !(caps & V4L2_DV_BT_CAP_INTERLACED)) ||
 	    (!bt->interlaced && !(caps & V4L2_DV_BT_CAP_PROGRESSIVE)))
 		return false;
-	return true;
+	return fnc == NULL || fnc(t, fnc_handle);
 }
 EXPORT_SYMBOL_GPL(v4l2_valid_dv_timings);
 
 int v4l2_enum_dv_timings_cap(struct v4l2_enum_dv_timings *t,
-			     const struct v4l2_dv_timings_cap *cap)
+			     const struct v4l2_dv_timings_cap *cap,
+			     v4l2_check_dv_timings_fnc fnc,
+			     void *fnc_handle)
 {
 	u32 i, idx;
 
 	memset(t->reserved, 0, sizeof(t->reserved));
 	for (i = idx = 0; v4l2_dv_timings_presets[i].bt.width; i++) {
-		if (v4l2_valid_dv_timings(v4l2_dv_timings_presets + i, cap) &&
+		if (v4l2_valid_dv_timings(v4l2_dv_timings_presets + i, cap,
+					  fnc, fnc_handle) &&
 		    idx++ == t->index) {
 			t->timings = v4l2_dv_timings_presets[i];
 			return 0;
@@ -174,16 +179,20 @@ EXPORT_SYMBOL_GPL(v4l2_enum_dv_timings_cap);
 
 bool v4l2_find_dv_timings_cap(struct v4l2_dv_timings *t,
 			      const struct v4l2_dv_timings_cap *cap,
-			      unsigned pclock_delta)
+			      unsigned pclock_delta,
+			      v4l2_check_dv_timings_fnc fnc,
+			      void *fnc_handle)
 {
 	int i;
 
-	if (!v4l2_valid_dv_timings(t, cap))
+	if (!v4l2_valid_dv_timings(t, cap, fnc, fnc_handle))
 		return false;
 
 	for (i = 0; i < v4l2_dv_timings_presets[i].bt.width; i++) {
-		if (v4l2_valid_dv_timings(v4l2_dv_timings_presets + i, cap) &&
-		    v4l2_match_dv_timings(t, v4l2_dv_timings_presets + i, pclock_delta)) {
+		if (v4l2_valid_dv_timings(v4l2_dv_timings_presets + i, cap,
+					  fnc, fnc_handle) &&
+		    v4l2_match_dv_timings(t, v4l2_dv_timings_presets + i,
+					  pclock_delta)) {
 			*t = v4l2_dv_timings_presets[i];
 			return true;
 		}
diff --git a/include/media/v4l2-dv-timings.h b/include/media/v4l2-dv-timings.h
index bd59df8..4becc67 100644
--- a/include/media/v4l2-dv-timings.h
+++ b/include/media/v4l2-dv-timings.h
@@ -27,46 +27,68 @@
  */
 extern const struct v4l2_dv_timings v4l2_dv_timings_presets[];
 
+/** v4l2_check_dv_timings_fnc - timings check callback
+ * @t: the v4l2_dv_timings struct.
+ * @handle: a handle from the driver.
+ *
+ * Returns true if the given timings are valid.
+ */
+typedef bool v4l2_check_dv_timings_fnc(const struct v4l2_dv_timings *t, void *handle);
+
 /** v4l2_valid_dv_timings() - are these timings valid?
   * @t:	  the v4l2_dv_timings struct.
   * @cap: the v4l2_dv_timings_cap capabilities.
+  * @fnc: callback to check if this timing is OK. May be NULL.
+  * @fnc_handle: a handle that is passed on to @fnc.
   *
   * Returns true if the given dv_timings struct is supported by the
-  * hardware capabilities, returns false otherwise.
+  * hardware capabilities and the callback function (if non-NULL), returns
+  * false otherwise.
   */
 bool v4l2_valid_dv_timings(const struct v4l2_dv_timings *t,
-			   const struct v4l2_dv_timings_cap *cap);
+			   const struct v4l2_dv_timings_cap *cap,
+			   v4l2_check_dv_timings_fnc fnc,
+			   void *fnc_handle);
 
 /** v4l2_enum_dv_timings_cap() - Helper function to enumerate possible DV timings based on capabilities
   * @t:	  the v4l2_enum_dv_timings struct.
   * @cap: the v4l2_dv_timings_cap capabilities.
+  * @fnc: callback to check if this timing is OK. May be NULL.
+  * @fnc_handle: a handle that is passed on to @fnc.
   *
   * This enumerates dv_timings using the full list of possible CEA-861 and DMT
   * timings, filtering out any timings that are not supported based on the
-  * hardware capabilities.
+  * hardware capabilities and the callback function (if non-NULL).
   *
   * If a valid timing for the given index is found, it will fill in @t and
   * return 0, otherwise it returns -EINVAL.
   */
 int v4l2_enum_dv_timings_cap(struct v4l2_enum_dv_timings *t,
-			     const struct v4l2_dv_timings_cap *cap);
+			     const struct v4l2_dv_timings_cap *cap,
+			     v4l2_check_dv_timings_fnc fnc,
+			     void *fnc_handle);
 
 /** v4l2_find_dv_timings_cap() - Find the closest timings struct
   * @t:	  the v4l2_enum_dv_timings struct.
   * @cap: the v4l2_dv_timings_cap capabilities.
   * @pclock_delta: maximum delta between t->pixelclock and the timing struct
   *		under consideration.
+  * @fnc: callback to check if a given timings struct is OK. May be NULL.
+  * @fnc_handle: a handle that is passed on to @fnc.
   *
   * This function tries to map the given timings to an entry in the
   * full list of possible CEA-861 and DMT timings, filtering out any timings
-  * that are not supported based on the hardware capabilities.
+  * that are not supported based on the hardware capabilities and the callback
+  * function (if non-NULL).
   *
   * On success it will fill in @t with the found timings and it returns true.
   * On failure it will return false.
   */
 bool v4l2_find_dv_timings_cap(struct v4l2_dv_timings *t,
 			      const struct v4l2_dv_timings_cap *cap,
-			      unsigned pclock_delta);
+			      unsigned pclock_delta,
+			      v4l2_check_dv_timings_fnc fnc,
+			      void *fnc_handle);
 
 /** v4l2_match_dv_timings() - do two timings match?
   * @measured:	  the measured timings data.
-- 
1.8.3.2

