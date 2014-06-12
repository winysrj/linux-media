Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1109 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755795AbaFLLyf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 07:54:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	sakari.ailus@iki.fi, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv4 PATCH 01/34] v4l2-ctrls: increase internal min/max/step/def to 64 bit
Date: Thu, 12 Jun 2014 13:52:33 +0200
Message-Id: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
In-Reply-To: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
References: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

While VIDIOC_QUERYCTRL is limited to 32 bit min/max/step/def values
for controls, the upcoming VIDIOC_QUERY_EXT_CTRL isn't. So increase
the internal representation to 64 bits in preparation.

Because of these changes the msi3101 driver has been modified slightly
to fix a formatting issue (%d becomes %lld), vivi had to be modified
as well to cope with the new 64-bit min/max values and the PIXEL_RATE
control in a few sensor drivers required proper min/max/def values.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/i2c/mt9v032.c                      |  2 +-
 drivers/media/i2c/smiapp/smiapp-core.c           |  4 +-
 drivers/media/platform/vivi.c                    |  5 +-
 drivers/media/v4l2-core/v4l2-common.c            |  6 +-
 drivers/media/v4l2-core/v4l2-ctrls.c             | 93 +++++++++++++++---------
 drivers/staging/media/msi3101/msi001.c           |  2 +-
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c |  4 +-
 include/media/v4l2-ctrls.h                       | 42 +++++------
 8 files changed, 93 insertions(+), 65 deletions(-)

diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
index 40172b8..65e6e1a 100644
--- a/drivers/media/i2c/mt9v032.c
+++ b/drivers/media/i2c/mt9v032.c
@@ -931,7 +931,7 @@ static int mt9v032_probe(struct i2c_client *client,
 
 	mt9v032->pixel_rate =
 		v4l2_ctrl_new_std(&mt9v032->ctrls, &mt9v032_ctrl_ops,
-				  V4L2_CID_PIXEL_RATE, 0, 0, 1, 0);
+				  V4L2_CID_PIXEL_RATE, 1, INT_MAX, 1, 1);
 
 	if (pdata && pdata->link_freqs) {
 		unsigned int def = 0;
diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 06fb032..0e82756 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -533,7 +533,7 @@ static int smiapp_init_controls(struct smiapp_sensor *sensor)
 
 	sensor->pixel_rate_parray = v4l2_ctrl_new_std(
 		&sensor->pixel_array->ctrl_handler, &smiapp_ctrl_ops,
-		V4L2_CID_PIXEL_RATE, 0, 0, 1, 0);
+		V4L2_CID_PIXEL_RATE, 1, INT_MAX, 1, 1);
 
 	if (sensor->pixel_array->ctrl_handler.error) {
 		dev_err(&client->dev,
@@ -562,7 +562,7 @@ static int smiapp_init_controls(struct smiapp_sensor *sensor)
 
 	sensor->pixel_rate_csi = v4l2_ctrl_new_std(
 		&sensor->src->ctrl_handler, &smiapp_ctrl_ops,
-		V4L2_CID_PIXEL_RATE, 0, 0, 1, 0);
+		V4L2_CID_PIXEL_RATE, 1, INT_MAX, 1, 1);
 
 	if (sensor->src->ctrl_handler.error) {
 		dev_err(&client->dev,
diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
index d00bf3d..2fa05e1 100644
--- a/drivers/media/platform/vivi.c
+++ b/drivers/media/platform/vivi.c
@@ -1236,7 +1236,7 @@ static const struct v4l2_ctrl_config vivi_ctrl_int32 = {
 	.id = VIVI_CID_CUSTOM_BASE + 2,
 	.name = "Integer 32 Bits",
 	.type = V4L2_CTRL_TYPE_INTEGER,
-	.min = 0x80000000,
+	.min = -0x80000000LL,
 	.max = 0x7fffffff,
 	.step = 1,
 };
@@ -1246,6 +1246,9 @@ static const struct v4l2_ctrl_config vivi_ctrl_int64 = {
 	.id = VIVI_CID_CUSTOM_BASE + 3,
 	.name = "Integer 64 Bits",
 	.type = V4L2_CTRL_TYPE_INTEGER64,
+	.min = LLONG_MIN,
+	.max = LLONG_MAX,
+	.step = 1,
 };
 
 static const char * const vivi_ctrl_menu_strings[] = {
diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index 433d6d7..ccaa38f 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -111,9 +111,13 @@ int v4l2_ctrl_check(struct v4l2_ext_control *ctrl, struct v4l2_queryctrl *qctrl,
 EXPORT_SYMBOL(v4l2_ctrl_check);
 
 /* Fill in a struct v4l2_queryctrl */
-int v4l2_ctrl_query_fill(struct v4l2_queryctrl *qctrl, s32 min, s32 max, s32 step, s32 def)
+int v4l2_ctrl_query_fill(struct v4l2_queryctrl *qctrl, s32 _min, s32 _max, s32 _step, s32 _def)
 {
 	const char *name;
+	s64 min = _min;
+	s64 max = _max;
+	u64 step = _step;
+	s64 def = _def;
 
 	v4l2_ctrl_fill(qctrl->id, &name, &qctrl->type,
 		       &min, &max, &step, &def, &qctrl->flags);
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 55c6832..e132fa2 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -877,7 +877,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 EXPORT_SYMBOL(v4l2_ctrl_get_name);
 
 void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
-		    s32 *min, s32 *max, s32 *step, s32 *def, u32 *flags)
+		    s64 *min, s64 *max, u64 *step, s64 *def, u32 *flags)
 {
 	*name = v4l2_ctrl_get_name(id);
 	*flags = 0;
@@ -1041,14 +1041,23 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 		*type = V4L2_CTRL_TYPE_INTEGER;
 		*flags |= V4L2_CTRL_FLAG_READ_ONLY;
 		break;
-	case V4L2_CID_MPEG_VIDEO_DEC_FRAME:
 	case V4L2_CID_MPEG_VIDEO_DEC_PTS:
-		*flags |= V4L2_CTRL_FLAG_VOLATILE;
-		/* Fall through */
+		*type = V4L2_CTRL_TYPE_INTEGER64;
+		*flags |= V4L2_CTRL_FLAG_VOLATILE | V4L2_CTRL_FLAG_READ_ONLY;
+		*min = *def = 0;
+		*max = 0x1ffffffffLL;
+		*step = 1;
+		break;
+	case V4L2_CID_MPEG_VIDEO_DEC_FRAME:
+		*type = V4L2_CTRL_TYPE_INTEGER64;
+		*flags |= V4L2_CTRL_FLAG_VOLATILE | V4L2_CTRL_FLAG_READ_ONLY;
+		*min = *def = 0;
+		*max = 0x7fffffffffffffffLL;
+		*step = 1;
+		break;
 	case V4L2_CID_PIXEL_RATE:
 		*type = V4L2_CTRL_TYPE_INTEGER64;
 		*flags |= V4L2_CTRL_FLAG_READ_ONLY;
-		*min = *max = *step = *def = 0;
 		break;
 	default:
 		*type = V4L2_CTRL_TYPE_INTEGER;
@@ -1352,7 +1361,7 @@ static int cluster_changed(struct v4l2_ctrl *master)
 
 /* Control range checking */
 static int check_range(enum v4l2_ctrl_type type,
-		s32 min, s32 max, u32 step, s32 def)
+		s64 min, s64 max, u64 step, s64 def)
 {
 	switch (type) {
 	case V4L2_CTRL_TYPE_BOOLEAN:
@@ -1360,7 +1369,8 @@ static int check_range(enum v4l2_ctrl_type type,
 			return -ERANGE;
 		/* fall through */
 	case V4L2_CTRL_TYPE_INTEGER:
-		if (step <= 0 || min > max || def < min || def > max)
+	case V4L2_CTRL_TYPE_INTEGER64:
+		if (step == 0 || min > max || def < min || def > max)
 			return -ERANGE;
 		return 0;
 	case V4L2_CTRL_TYPE_BITMASK:
@@ -1385,23 +1395,30 @@ static int check_range(enum v4l2_ctrl_type type,
 	}
 }
 
+/* Round towards the closest legal value */
+#define ROUND_TO_RANGE(val, offset_type, ctrl)			\
+({								\
+	offset_type offset;					\
+	val += (ctrl)->step / 2;				\
+	val = clamp_t(typeof(val), val,				\
+		      (ctrl)->minimum, (ctrl)->maximum);	\
+	offset = (val) - (ctrl)->minimum;			\
+	offset = (ctrl)->step * (offset / (ctrl)->step);	\
+	val = (ctrl)->minimum + offset;				\
+	0;							\
+})
+
 /* Validate a new control */
 static int validate_new(const struct v4l2_ctrl *ctrl,
 			struct v4l2_ext_control *c)
 {
 	size_t len;
-	u32 offset;
-	s32 val;
 
 	switch (ctrl->type) {
 	case V4L2_CTRL_TYPE_INTEGER:
-		/* Round towards the closest legal value */
-		val = c->value + ctrl->step / 2;
-		val = clamp(val, ctrl->minimum, ctrl->maximum);
-		offset = val - ctrl->minimum;
-		offset = ctrl->step * (offset / ctrl->step);
-		c->value = ctrl->minimum + offset;
-		return 0;
+		return ROUND_TO_RANGE(*(s32 *)&c->value, u32, ctrl);
+	case V4L2_CTRL_TYPE_INTEGER64:
+		return ROUND_TO_RANGE(*(s64 *)&c->value64, u64, ctrl);
 
 	case V4L2_CTRL_TYPE_BOOLEAN:
 		c->value = !!c->value;
@@ -1427,9 +1444,6 @@ static int validate_new(const struct v4l2_ctrl *ctrl,
 		c->value = 0;
 		return 0;
 
-	case V4L2_CTRL_TYPE_INTEGER64:
-		return 0;
-
 	case V4L2_CTRL_TYPE_STRING:
 		len = strlen(c->string);
 		if (len < ctrl->minimum)
@@ -1653,7 +1667,7 @@ unlock:
 static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 			const struct v4l2_ctrl_ops *ops,
 			u32 id, const char *name, enum v4l2_ctrl_type type,
-			s32 min, s32 max, u32 step, s32 def,
+			s64 min, s64 max, u64 step, s64 def,
 			u32 flags, const char * const *qmenu,
 			const s64 *qmenu_int, void *priv)
 {
@@ -1738,10 +1752,10 @@ struct v4l2_ctrl *v4l2_ctrl_new_custom(struct v4l2_ctrl_handler *hdl,
 	const s64 *qmenu_int = cfg->qmenu_int;
 	enum v4l2_ctrl_type type = cfg->type;
 	u32 flags = cfg->flags;
-	s32 min = cfg->min;
-	s32 max = cfg->max;
-	u32 step = cfg->step;
-	s32 def = cfg->def;
+	s64 min = cfg->min;
+	s64 max = cfg->max;
+	u64 step = cfg->step;
+	s64 def = cfg->def;
 
 	if (name == NULL)
 		v4l2_ctrl_fill(cfg->id, &name, &type, &min, &max, &step,
@@ -1774,7 +1788,7 @@ EXPORT_SYMBOL(v4l2_ctrl_new_custom);
 /* Helper function for standard non-menu controls */
 struct v4l2_ctrl *v4l2_ctrl_new_std(struct v4l2_ctrl_handler *hdl,
 			const struct v4l2_ctrl_ops *ops,
-			u32 id, s32 min, s32 max, u32 step, s32 def)
+			u32 id, s64 min, s64 max, u64 step, s64 def)
 {
 	const char *name;
 	enum v4l2_ctrl_type type;
@@ -1794,15 +1808,17 @@ EXPORT_SYMBOL(v4l2_ctrl_new_std);
 /* Helper function for standard menu controls */
 struct v4l2_ctrl *v4l2_ctrl_new_std_menu(struct v4l2_ctrl_handler *hdl,
 			const struct v4l2_ctrl_ops *ops,
-			u32 id, s32 max, s32 mask, s32 def)
+			u32 id, u8 _max, u64 mask, u8 _def)
 {
 	const char * const *qmenu = NULL;
 	const s64 *qmenu_int = NULL;
 	unsigned int qmenu_int_len = 0;
 	const char *name;
 	enum v4l2_ctrl_type type;
-	s32 min;
-	s32 step;
+	s64 min;
+	s64 max = _max;
+	s64 def = _def;
+	u64 step;
 	u32 flags;
 
 	v4l2_ctrl_fill(id, &name, &type, &min, &max, &step, &def, &flags);
@@ -1823,14 +1839,16 @@ EXPORT_SYMBOL(v4l2_ctrl_new_std_menu);
 
 /* Helper function for standard menu controls with driver defined menu */
 struct v4l2_ctrl *v4l2_ctrl_new_std_menu_items(struct v4l2_ctrl_handler *hdl,
-			const struct v4l2_ctrl_ops *ops, u32 id, s32 max,
-			s32 mask, s32 def, const char * const *qmenu)
+			const struct v4l2_ctrl_ops *ops, u32 id, u8 _max,
+			u64 mask, u8 _def, const char * const *qmenu)
 {
 	enum v4l2_ctrl_type type;
 	const char *name;
 	u32 flags;
-	s32 step;
-	s32 min;
+	u64 step;
+	s64 min;
+	s64 max = _max;
+	s64 def = _def;
 
 	/* v4l2_ctrl_new_std_menu_items() should only be called for
 	 * standard controls without a standard menu.
@@ -1854,12 +1872,14 @@ EXPORT_SYMBOL(v4l2_ctrl_new_std_menu_items);
 /* Helper function for standard integer menu controls */
 struct v4l2_ctrl *v4l2_ctrl_new_int_menu(struct v4l2_ctrl_handler *hdl,
 			const struct v4l2_ctrl_ops *ops,
-			u32 id, s32 max, s32 def, const s64 *qmenu_int)
+			u32 id, u8 _max, u8 _def, const s64 *qmenu_int)
 {
 	const char *name;
 	enum v4l2_ctrl_type type;
-	s32 min;
-	s32 step;
+	s64 min;
+	u64 step;
+	s64 max = _max;
+	s64 def = _def;
 	u32 flags;
 
 	v4l2_ctrl_fill(id, &name, &type, &min, &max, &step, &def, &flags);
@@ -2887,13 +2907,14 @@ void v4l2_ctrl_notify(struct v4l2_ctrl *ctrl, v4l2_ctrl_notify_fnc notify, void
 EXPORT_SYMBOL(v4l2_ctrl_notify);
 
 int v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
-			s32 min, s32 max, u32 step, s32 def)
+			s64 min, s64 max, u64 step, s64 def)
 {
 	int ret = check_range(ctrl->type, min, max, step, def);
 	struct v4l2_ext_control c;
 
 	switch (ctrl->type) {
 	case V4L2_CTRL_TYPE_INTEGER:
+	case V4L2_CTRL_TYPE_INTEGER64:
 	case V4L2_CTRL_TYPE_BOOLEAN:
 	case V4L2_CTRL_TYPE_MENU:
 	case V4L2_CTRL_TYPE_INTEGER_MENU:
diff --git a/drivers/staging/media/msi3101/msi001.c b/drivers/staging/media/msi3101/msi001.c
index bd0b93c..ee99e37 100644
--- a/drivers/staging/media/msi3101/msi001.c
+++ b/drivers/staging/media/msi3101/msi001.c
@@ -381,7 +381,7 @@ static int msi001_s_ctrl(struct v4l2_ctrl *ctrl)
 
 	int ret;
 	dev_dbg(&s->spi->dev,
-			"%s: id=%d name=%s val=%d min=%d max=%d step=%d\n",
+			"%s: id=%d name=%s val=%d min=%lld max=%lld step=%lld\n",
 			__func__, ctrl->id, ctrl->name, ctrl->val,
 			ctrl->minimum, ctrl->maximum, ctrl->step);
 
diff --git a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
index 093df6b..640d899 100644
--- a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
+++ b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
@@ -1317,7 +1317,7 @@ static int rtl2832_sdr_s_ctrl(struct v4l2_ctrl *ctrl)
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 	dev_dbg(&s->udev->dev,
-			"%s: id=%d name=%s val=%d min=%d max=%d step=%d\n",
+			"%s: id=%d name=%s val=%d min=%lld max=%lld step=%lld\n",
 			__func__, ctrl->id, ctrl->name, ctrl->val,
 			ctrl->minimum, ctrl->maximum, ctrl->step);
 
@@ -1329,7 +1329,7 @@ static int rtl2832_sdr_s_ctrl(struct v4l2_ctrl *ctrl)
 			/* Round towards the closest legal value */
 			s32 val = s->f_adc + s->bandwidth->step / 2;
 			u32 offset;
-			val = clamp(val, s->bandwidth->minimum, s->bandwidth->maximum);
+			val = clamp_t(s32, val, s->bandwidth->minimum, s->bandwidth->maximum);
 			offset = val - s->bandwidth->minimum;
 			offset = s->bandwidth->step * (offset / s->bandwidth->step);
 			s->bandwidth->val = s->bandwidth->minimum + offset;
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 16f7f26..a2e8f03 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -131,10 +131,10 @@ struct v4l2_ctrl {
 	u32 id;
 	const char *name;
 	enum v4l2_ctrl_type type;
-	s32 minimum, maximum, default_value;
+	s64 minimum, maximum, default_value;
 	union {
-		u32 step;
-		u32 menu_skip_mask;
+		u64 step;
+		u64 menu_skip_mask;
 	};
 	union {
 		const char * const *qmenu;
@@ -216,9 +216,9 @@ struct v4l2_ctrl_handler {
   * @menu_skip_mask: The control's skip mask for menu controls. This makes it
   *		easy to skip menu items that are not valid. If bit X is set,
   *		then menu item X is skipped. Of course, this only works for
-  *		menus with <= 32 menu items. There are no menus that come
+  *		menus with <= 64 menu items. There are no menus that come
   *		close to that number, so this is OK. Should we ever need more,
-  *		then this will have to be extended to a u64 or a bit array.
+  *		then this will have to be extended to a bit array.
   * @qmenu:	A const char * array for all menu items. Array entries that are
   *		empty strings ("") correspond to non-existing menu items (this
   *		is in addition to the menu_skip_mask above). The last entry
@@ -231,12 +231,12 @@ struct v4l2_ctrl_config {
 	u32 id;
 	const char *name;
 	enum v4l2_ctrl_type type;
-	s32 min;
-	s32 max;
-	u32 step;
-	s32 def;
+	s64 min;
+	s64 max;
+	u64 step;
+	s64 def;
 	u32 flags;
-	u32 menu_skip_mask;
+	u64 menu_skip_mask;
 	const char * const *qmenu;
 	const s64 *qmenu_int;
 	unsigned int is_private:1;
@@ -257,7 +257,7 @@ struct v4l2_ctrl_config {
   * control framework this function will no longer be exported.
   */
 void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
-		    s32 *min, s32 *max, s32 *step, s32 *def, u32 *flags);
+		    s64 *min, s64 *max, u64 *step, s64 *def, u32 *flags);
 
 
 /** v4l2_ctrl_handler_init_class() - Initialize the control handler.
@@ -362,7 +362,7 @@ struct v4l2_ctrl *v4l2_ctrl_new_custom(struct v4l2_ctrl_handler *hdl,
   */
 struct v4l2_ctrl *v4l2_ctrl_new_std(struct v4l2_ctrl_handler *hdl,
 			const struct v4l2_ctrl_ops *ops,
-			u32 id, s32 min, s32 max, u32 step, s32 def);
+			u32 id, s64 min, s64 max, u64 step, s64 def);
 
 /** v4l2_ctrl_new_std_menu() - Allocate and initialize a new standard V4L2 menu control.
   * @hdl:	The control handler.
@@ -372,9 +372,9 @@ struct v4l2_ctrl *v4l2_ctrl_new_std(struct v4l2_ctrl_handler *hdl,
   * @mask: 	The control's skip mask for menu controls. This makes it
   *		easy to skip menu items that are not valid. If bit X is set,
   *		then menu item X is skipped. Of course, this only works for
-  *		menus with <= 32 menu items. There are no menus that come
+  *		menus with <= 64 menu items. There are no menus that come
   *		close to that number, so this is OK. Should we ever need more,
-  *		then this will have to be extended to a u64 or a bit array.
+  *		then this will have to be extended to a bit array.
   * @def: 	The control's default value.
   *
   * Same as v4l2_ctrl_new_std(), but @min is set to 0 and the @mask value
@@ -384,7 +384,7 @@ struct v4l2_ctrl *v4l2_ctrl_new_std(struct v4l2_ctrl_handler *hdl,
   */
 struct v4l2_ctrl *v4l2_ctrl_new_std_menu(struct v4l2_ctrl_handler *hdl,
 			const struct v4l2_ctrl_ops *ops,
-			u32 id, s32 max, s32 mask, s32 def);
+			u32 id, u8 max, u64 mask, u8 def);
 
 /** v4l2_ctrl_new_std_menu_items() - Create a new standard V4L2 menu control
   * with driver specific menu.
@@ -395,9 +395,9 @@ struct v4l2_ctrl *v4l2_ctrl_new_std_menu(struct v4l2_ctrl_handler *hdl,
   * @mask:	The control's skip mask for menu controls. This makes it
   *		easy to skip menu items that are not valid. If bit X is set,
   *		then menu item X is skipped. Of course, this only works for
-  *		menus with <= 32 menu items. There are no menus that come
+  *		menus with <= 64 menu items. There are no menus that come
   *		close to that number, so this is OK. Should we ever need more,
-  *		then this will have to be extended to a u64 or a bit array.
+  *		then this will have to be extended to a bit array.
   * @def:	The control's default value.
   * @qmenu:	The new menu.
   *
@@ -406,8 +406,8 @@ struct v4l2_ctrl *v4l2_ctrl_new_std_menu(struct v4l2_ctrl_handler *hdl,
   *
   */
 struct v4l2_ctrl *v4l2_ctrl_new_std_menu_items(struct v4l2_ctrl_handler *hdl,
-			const struct v4l2_ctrl_ops *ops, u32 id, s32 max,
-			s32 mask, s32 def, const char * const *qmenu);
+			const struct v4l2_ctrl_ops *ops, u32 id, u8 max,
+			u64 mask, u8 def, const char * const *qmenu);
 
 /** v4l2_ctrl_new_int_menu() - Create a new standard V4L2 integer menu control.
   * @hdl:	The control handler.
@@ -424,7 +424,7 @@ struct v4l2_ctrl *v4l2_ctrl_new_std_menu_items(struct v4l2_ctrl_handler *hdl,
   */
 struct v4l2_ctrl *v4l2_ctrl_new_int_menu(struct v4l2_ctrl_handler *hdl,
 			const struct v4l2_ctrl_ops *ops,
-			u32 id, s32 max, s32 def, const s64 *qmenu_int);
+			u32 id, u8 max, u8 def, const s64 *qmenu_int);
 
 /** v4l2_ctrl_add_ctrl() - Add a control from another handler to this handler.
   * @hdl:	The control handler.
@@ -560,7 +560,7 @@ void v4l2_ctrl_grab(struct v4l2_ctrl *ctrl, bool grabbed);
   * take the lock itself.
   */
 int v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
-			s32 min, s32 max, u32 step, s32 def);
+			s64 min, s64 max, u64 step, s64 def);
 
 /** v4l2_ctrl_lock() - Helper function to lock the handler
   * associated with the control.
-- 
2.0.0.rc0

