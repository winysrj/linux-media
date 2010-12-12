Return-path: <mchehab@gaivota>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4790 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab0LLRcK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Dec 2010 12:32:10 -0500
Received: from localhost.localdomain (159.80-203-19.nextgentel.com [80.203.19.159])
	(authenticated bits=0)
	by smtp-vbr5.xs4all.nl (8.13.8/8.13.8) with ESMTP id oBCHW1MN002236
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 12 Dec 2010 18:32:08 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFC/PATCH 15/19] v4l2-ctrls: use const char * const * for the menu arrays
Date: Sun, 12 Dec 2010 18:31:57 +0100
Message-Id: <865c22aacba93942a6b8461ceec2cd15a3951216.1292174822.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1292174822.git.hverkuil@xs4all.nl>
References: <cover.1292174822.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1292174822.git.hverkuil@xs4all.nl>
References: <cover.1292174822.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This prevents checkpatch warnings generated when defining
'static const char *foo[]' arrays. It makes sense to use
const char * const * anyway since the pointers in the array
are indeed const.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/cx2341x.c                      |    8 ++--
 drivers/media/video/pvrusb2/pvrusb2-ctrl.c         |    6 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h |    2 +-
 drivers/media/video/v4l2-common.c                  |    6 +-
 drivers/media/video/v4l2-ctrls.c                   |   46 ++++++++++----------
 include/media/cx2341x.h                            |    2 +-
 include/media/v4l2-common.h                        |    6 +-
 include/media/v4l2-ctrls.h                         |    4 +-
 8 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/drivers/media/video/cx2341x.c b/drivers/media/video/cx2341x.c
index e5c3c8d..103ef6b 100644
--- a/drivers/media/video/cx2341x.c
+++ b/drivers/media/video/cx2341x.c
@@ -853,9 +853,9 @@ int cx2341x_ctrl_query(const struct cx2341x_mpeg_params *params,
 }
 EXPORT_SYMBOL(cx2341x_ctrl_query);
 
-const char **cx2341x_ctrl_get_menu(const struct cx2341x_mpeg_params *p, u32 id)
+const char * const *cx2341x_ctrl_get_menu(const struct cx2341x_mpeg_params *p, u32 id)
 {
-	static const char *mpeg_stream_type_without_ts[] = {
+	static const char * const mpeg_stream_type_without_ts[] = {
 		"MPEG-2 Program Stream",
 		"",
 		"MPEG-1 System Stream",
@@ -952,7 +952,7 @@ int cx2341x_ext_ctrls(struct cx2341x_mpeg_params *params, int busy,
 	for (i = 0; i < ctrls->count; i++) {
 		struct v4l2_ext_control *ctrl = ctrls->controls + i;
 		struct v4l2_queryctrl qctrl;
-		const char **menu_items = NULL;
+		const char * const *menu_items = NULL;
 
 		qctrl.id = ctrl->id;
 		err = cx2341x_ctrl_query(params, &qctrl);
@@ -1135,7 +1135,7 @@ EXPORT_SYMBOL(cx2341x_update);
 
 static const char *cx2341x_menu_item(const struct cx2341x_mpeg_params *p, u32 id)
 {
-	const char **menu = cx2341x_ctrl_get_menu(p, id);
+	const char * const *menu = cx2341x_ctrl_get_menu(p, id);
 	struct v4l2_ext_control ctrl;
 
 	if (menu == NULL)
diff --git a/drivers/media/video/pvrusb2/pvrusb2-ctrl.c b/drivers/media/video/pvrusb2/pvrusb2-ctrl.c
index 55ea914..7d5a713 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-ctrl.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-ctrl.c
@@ -203,7 +203,7 @@ int pvr2_ctrl_get_valname(struct pvr2_ctrl *cptr,int val,
 	*blen = 0;
 	LOCK_TAKE(cptr->hdw->big_lock); do {
 		if (cptr->info->type == pvr2_ctl_enum) {
-			const char **names;
+			const char * const *names;
 			names = cptr->info->def.type_enum.value_names;
 			if (pvr2_ctrl_range_check(cptr,val) == 0) {
 				if (names[val]) {
@@ -367,7 +367,7 @@ static const char *boolNames[] = {
 
 static int parse_token(const char *ptr,unsigned int len,
 		       int *valptr,
-		       const char **names,unsigned int namecnt)
+		       const char * const *names, unsigned int namecnt)
 {
 	char buf[33];
 	unsigned int slen;
@@ -559,7 +559,7 @@ int pvr2_ctrl_value_to_sym_internal(struct pvr2_ctrl *cptr,
 		*len = scnprintf(buf,maxlen,"%s",val ? "true" : "false");
 		ret = 0;
 	} else if (cptr->info->type == pvr2_ctl_enum) {
-		const char **names;
+		const char * const *names;
 		names = cptr->info->def.type_enum.value_names;
 		if ((val >= 0) &&
 		    (val < cptr->info->def.type_enum.count)) {
diff --git a/drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h b/drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h
index cb4057b..ac94a8b 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h
+++ b/drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h
@@ -115,7 +115,7 @@ struct pvr2_ctl_info {
 		} type_int;
 		struct { /* enumerated control */
 			unsigned int count;       /* enum value count */
-			const char **value_names; /* symbol names */
+			const char * const *value_names; /* symbol names */
 		} type_enum;
 		struct { /* bitmask control */
 			unsigned int valid_bits; /* bits in use */
diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
index b5eb1f3..3f0871b 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -150,7 +150,7 @@ EXPORT_SYMBOL(v4l2_prio_check);
    struct v4l2_queryctrl and the available menu items. Note that
    menu_items may be NULL, in that case it is ignored. */
 int v4l2_ctrl_check(struct v4l2_ext_control *ctrl, struct v4l2_queryctrl *qctrl,
-		const char **menu_items)
+		const char * const *menu_items)
 {
 	if (qctrl->flags & V4L2_CTRL_FLAG_DISABLED)
 		return -EINVAL;
@@ -199,7 +199,7 @@ EXPORT_SYMBOL(v4l2_ctrl_query_fill);
    If menu_items is NULL, then the menu items are retrieved using
    v4l2_ctrl_get_menu. */
 int v4l2_ctrl_query_menu(struct v4l2_querymenu *qmenu, struct v4l2_queryctrl *qctrl,
-	       const char **menu_items)
+	       const char * const *menu_items)
 {
 	int i;
 
@@ -222,7 +222,7 @@ EXPORT_SYMBOL(v4l2_ctrl_query_menu);
    Use this if there are 'holes' in the list of valid menu items. */
 int v4l2_ctrl_query_menu_valid_items(struct v4l2_querymenu *qmenu, const u32 *ids)
 {
-	const char **menu_items = v4l2_ctrl_get_menu(qmenu->id);
+	const char * const *menu_items = v4l2_ctrl_get_menu(qmenu->id);
 
 	qmenu->reserved = 0;
 	if (menu_items == NULL || ids == NULL)
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 9d2502c..6c0fadc 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -38,15 +38,15 @@ struct ctrl_helper {
    the given control ID. The pointer array ends with a NULL pointer.
    An empty string signifies a menu entry that is invalid. This allows
    drivers to disable certain options if it is not supported. */
-const char **v4l2_ctrl_get_menu(u32 id)
+const char * const *v4l2_ctrl_get_menu(u32 id)
 {
-	static const char *mpeg_audio_sampling_freq[] = {
+	static const char * const mpeg_audio_sampling_freq[] = {
 		"44.1 kHz",
 		"48 kHz",
 		"32 kHz",
 		NULL
 	};
-	static const char *mpeg_audio_encoding[] = {
+	static const char * const mpeg_audio_encoding[] = {
 		"MPEG-1/2 Layer I",
 		"MPEG-1/2 Layer II",
 		"MPEG-1/2 Layer III",
@@ -54,7 +54,7 @@ const char **v4l2_ctrl_get_menu(u32 id)
 		"AC-3",
 		NULL
 	};
-	static const char *mpeg_audio_l1_bitrate[] = {
+	static const char * const mpeg_audio_l1_bitrate[] = {
 		"32 kbps",
 		"64 kbps",
 		"96 kbps",
@@ -71,7 +71,7 @@ const char **v4l2_ctrl_get_menu(u32 id)
 		"448 kbps",
 		NULL
 	};
-	static const char *mpeg_audio_l2_bitrate[] = {
+	static const char * const mpeg_audio_l2_bitrate[] = {
 		"32 kbps",
 		"48 kbps",
 		"56 kbps",
@@ -88,7 +88,7 @@ const char **v4l2_ctrl_get_menu(u32 id)
 		"384 kbps",
 		NULL
 	};
-	static const char *mpeg_audio_l3_bitrate[] = {
+	static const char * const mpeg_audio_l3_bitrate[] = {
 		"32 kbps",
 		"40 kbps",
 		"48 kbps",
@@ -105,7 +105,7 @@ const char **v4l2_ctrl_get_menu(u32 id)
 		"320 kbps",
 		NULL
 	};
-	static const char *mpeg_audio_ac3_bitrate[] = {
+	static const char * const mpeg_audio_ac3_bitrate[] = {
 		"32 kbps",
 		"40 kbps",
 		"48 kbps",
@@ -127,50 +127,50 @@ const char **v4l2_ctrl_get_menu(u32 id)
 		"640 kbps",
 		NULL
 	};
-	static const char *mpeg_audio_mode[] = {
+	static const char * const mpeg_audio_mode[] = {
 		"Stereo",
 		"Joint Stereo",
 		"Dual",
 		"Mono",
 		NULL
 	};
-	static const char *mpeg_audio_mode_extension[] = {
+	static const char * const mpeg_audio_mode_extension[] = {
 		"Bound 4",
 		"Bound 8",
 		"Bound 12",
 		"Bound 16",
 		NULL
 	};
-	static const char *mpeg_audio_emphasis[] = {
+	static const char * const mpeg_audio_emphasis[] = {
 		"No Emphasis",
 		"50/15 us",
 		"CCITT J17",
 		NULL
 	};
-	static const char *mpeg_audio_crc[] = {
+	static const char * const mpeg_audio_crc[] = {
 		"No CRC",
 		"16-bit CRC",
 		NULL
 	};
-	static const char *mpeg_video_encoding[] = {
+	static const char * const mpeg_video_encoding[] = {
 		"MPEG-1",
 		"MPEG-2",
 		"MPEG-4 AVC",
 		NULL
 	};
-	static const char *mpeg_video_aspect[] = {
+	static const char * const mpeg_video_aspect[] = {
 		"1x1",
 		"4x3",
 		"16x9",
 		"2.21x1",
 		NULL
 	};
-	static const char *mpeg_video_bitrate_mode[] = {
+	static const char * const mpeg_video_bitrate_mode[] = {
 		"Variable Bitrate",
 		"Constant Bitrate",
 		NULL
 	};
-	static const char *mpeg_stream_type[] = {
+	static const char * const mpeg_stream_type[] = {
 		"MPEG-2 Program Stream",
 		"MPEG-2 Transport Stream",
 		"MPEG-1 System Stream",
@@ -179,25 +179,25 @@ const char **v4l2_ctrl_get_menu(u32 id)
 		"MPEG-2 SVCD-compatible Stream",
 		NULL
 	};
-	static const char *mpeg_stream_vbi_fmt[] = {
+	static const char * const mpeg_stream_vbi_fmt[] = {
 		"No VBI",
 		"Private packet, IVTV format",
 		NULL
 	};
-	static const char *camera_power_line_frequency[] = {
+	static const char * const camera_power_line_frequency[] = {
 		"Disabled",
 		"50 Hz",
 		"60 Hz",
 		NULL
 	};
-	static const char *camera_exposure_auto[] = {
+	static const char * const camera_exposure_auto[] = {
 		"Auto Mode",
 		"Manual Mode",
 		"Shutter Priority Mode",
 		"Aperture Priority Mode",
 		NULL
 	};
-	static const char *colorfx[] = {
+	static const char * const colorfx[] = {
 		"None",
 		"Black & White",
 		"Sepia",
@@ -210,7 +210,7 @@ const char **v4l2_ctrl_get_menu(u32 id)
 		"Vivid",
 		NULL
 	};
-	static const char *tune_preemphasis[] = {
+	static const char * const tune_preemphasis[] = {
 		"No preemphasis",
 		"50 useconds",
 		"75 useconds",
@@ -952,7 +952,7 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 			const struct v4l2_ctrl_ops *ops,
 			u32 id, const char *name, enum v4l2_ctrl_type type,
 			s32 min, s32 max, u32 step, s32 def,
-			u32 flags, const char **qmenu, void *priv)
+			u32 flags, const char * const *qmenu, void *priv)
 {
 	struct v4l2_ctrl *ctrl;
 	unsigned sz_extra = 0;
@@ -1019,7 +1019,7 @@ struct v4l2_ctrl *v4l2_ctrl_new_custom(struct v4l2_ctrl_handler *hdl,
 	bool is_menu;
 	struct v4l2_ctrl *ctrl;
 	const char *name = cfg->name;
-	const char **qmenu = cfg->qmenu;
+	const char * const *qmenu = cfg->qmenu;
 	enum v4l2_ctrl_type type = cfg->type;
 	u32 flags = cfg->flags;
 	s32 min = cfg->min;
@@ -1075,7 +1075,7 @@ struct v4l2_ctrl *v4l2_ctrl_new_std_menu(struct v4l2_ctrl_handler *hdl,
 			const struct v4l2_ctrl_ops *ops,
 			u32 id, s32 max, s32 mask, s32 def)
 {
-	const char **qmenu = v4l2_ctrl_get_menu(id);
+	const char * const *qmenu = v4l2_ctrl_get_menu(id);
 	const char *name;
 	enum v4l2_ctrl_type type;
 	s32 min;
diff --git a/include/media/cx2341x.h b/include/media/cx2341x.h
index 8d08ebf..9635eeb 100644
--- a/include/media/cx2341x.h
+++ b/include/media/cx2341x.h
@@ -95,7 +95,7 @@ int cx2341x_update(void *priv, cx2341x_mbox_func func,
 		const struct cx2341x_mpeg_params *new);
 int cx2341x_ctrl_query(const struct cx2341x_mpeg_params *params,
 		struct v4l2_queryctrl *qctrl);
-const char **cx2341x_ctrl_get_menu(const struct cx2341x_mpeg_params *p, u32 id);
+const char * const *cx2341x_ctrl_get_menu(const struct cx2341x_mpeg_params *p, u32 id);
 int cx2341x_ext_ctrls(struct cx2341x_mpeg_params *params, int busy,
 		struct v4l2_ext_controls *ctrls, unsigned int cmd);
 void cx2341x_fill_defaults(struct cx2341x_mpeg_params *p);
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index 239125a..2d65b35 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -98,12 +98,12 @@ int v4l2_prio_check(struct v4l2_prio_state *global, enum v4l2_priority local);
 /* Control helper functions */
 
 int v4l2_ctrl_check(struct v4l2_ext_control *ctrl, struct v4l2_queryctrl *qctrl,
-		const char **menu_items);
+		const char * const *menu_items);
 const char *v4l2_ctrl_get_name(u32 id);
-const char **v4l2_ctrl_get_menu(u32 id);
+const char * const *v4l2_ctrl_get_menu(u32 id);
 int v4l2_ctrl_query_fill(struct v4l2_queryctrl *qctrl, s32 min, s32 max, s32 step, s32 def);
 int v4l2_ctrl_query_menu(struct v4l2_querymenu *qmenu,
-		struct v4l2_queryctrl *qctrl, const char **menu_items);
+		struct v4l2_queryctrl *qctrl, const char * const *menu_items);
 #define V4L2_CTRL_MENU_IDS_END (0xffffffff)
 int v4l2_ctrl_query_menu_valid_items(struct v4l2_querymenu *qmenu, const u32 *ids);
 
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 9b7bea9..d69ab4a 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -112,7 +112,7 @@ struct v4l2_ctrl {
 		u32 step;
 		u32 menu_skip_mask;
 	};
-	const char **qmenu;
+	const char * const *qmenu;
 	unsigned long flags;
 	union {
 		s32 val;
@@ -202,7 +202,7 @@ struct v4l2_ctrl_config {
 	s32 def;
 	u32 flags;
 	u32 menu_skip_mask;
-	const char **qmenu;
+	const char * const *qmenu;
 	unsigned int is_private:1;
 	unsigned int is_volatile:1;
 };
-- 
1.7.0.4

