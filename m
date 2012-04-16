Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:20065 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774Ab2DPN7C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Apr 2012 09:59:02 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M2K007VVS5MPD10@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 16 Apr 2012 14:58:34 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2K001QXS68RG@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 16 Apr 2012 14:58:56 +0100 (BST)
Date: Mon, 16 Apr 2012 15:58:51 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCHv2 4/8] v4l: s5p-tv: hdmi: parametrize DV timings
In-reply-to: <1334584735-12439-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	mchehab@redhat.com, hverkuil@xs4all.nl, sachin.kamat@linaro.org,
	u.kleine-koenig@pengutronix.de
Message-id: <1334584735-12439-5-git-send-email-t.stanislaws@samsung.com>
References: <1334584735-12439-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes timings configuration in HDMI register.  It adds support for
numerous new presets including interlaces ones.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-tv/hdmi_drv.c  |  460 ++++++++++++++------------------
 drivers/media/video/s5p-tv/regs-hdmi.h |    1 +
 2 files changed, 207 insertions(+), 254 deletions(-)

diff --git a/drivers/media/video/s5p-tv/hdmi_drv.c b/drivers/media/video/s5p-tv/hdmi_drv.c
index 4865d25..eefb903 100644
--- a/drivers/media/video/s5p-tv/hdmi_drv.c
+++ b/drivers/media/video/s5p-tv/hdmi_drv.c
@@ -42,7 +42,23 @@ MODULE_DESCRIPTION("Samsung HDMI");
 MODULE_LICENSE("GPL");
 
 /* default preset configured on probe */
-#define HDMI_DEFAULT_PRESET V4L2_DV_1080P60
+#define HDMI_DEFAULT_PRESET V4L2_DV_480P59_94
+
+struct hdmi_pulse {
+	u32 beg;
+	u32 end;
+};
+
+struct hdmi_timings {
+	struct hdmi_pulse hact;
+	u32 hsyn_pol; /* 0 - high, 1 - low */
+	struct hdmi_pulse hsyn;
+	u32 interlaced;
+	struct hdmi_pulse vact[2];
+	u32 vsyn_pol; /* 0 - high, 1 - low */
+	u32 vsyn_off;
+	struct hdmi_pulse vsyn[2];
+};
 
 struct hdmi_resources {
 	struct clk *hdmi;
@@ -70,64 +86,13 @@ struct hdmi_device {
 	/** subdev of MHL interface */
 	struct v4l2_subdev *mhl_sd;
 	/** configuration of current graphic mode */
-	const struct hdmi_preset_conf *cur_conf;
+	const struct hdmi_timings *cur_conf;
 	/** current preset */
 	u32 cur_preset;
 	/** other resources */
 	struct hdmi_resources res;
 };
 
-struct hdmi_tg_regs {
-	u8 cmd;
-	u8 h_fsz_l;
-	u8 h_fsz_h;
-	u8 hact_st_l;
-	u8 hact_st_h;
-	u8 hact_sz_l;
-	u8 hact_sz_h;
-	u8 v_fsz_l;
-	u8 v_fsz_h;
-	u8 vsync_l;
-	u8 vsync_h;
-	u8 vsync2_l;
-	u8 vsync2_h;
-	u8 vact_st_l;
-	u8 vact_st_h;
-	u8 vact_sz_l;
-	u8 vact_sz_h;
-	u8 field_chg_l;
-	u8 field_chg_h;
-	u8 vact_st2_l;
-	u8 vact_st2_h;
-	u8 vsync_top_hdmi_l;
-	u8 vsync_top_hdmi_h;
-	u8 vsync_bot_hdmi_l;
-	u8 vsync_bot_hdmi_h;
-	u8 field_top_hdmi_l;
-	u8 field_top_hdmi_h;
-	u8 field_bot_hdmi_l;
-	u8 field_bot_hdmi_h;
-};
-
-struct hdmi_core_regs {
-	u8 h_blank[2];
-	u8 v_blank[3];
-	u8 h_v_line[3];
-	u8 vsync_pol[1];
-	u8 int_pro_mode[1];
-	u8 v_blank_f[3];
-	u8 h_sync_gen[3];
-	u8 v_sync_gen1[3];
-	u8 v_sync_gen2[3];
-	u8 v_sync_gen3[3];
-};
-
-struct hdmi_preset_conf {
-	struct hdmi_core_regs core;
-	struct hdmi_tg_regs tg;
-	struct v4l2_mbus_framefmt mbus_fmt;
-};
-
 static struct platform_device_id hdmi_driver_types[] = {
 	{
 		.name		= "s5pv210-hdmi",
@@ -165,6 +130,21 @@ void hdmi_writeb(struct hdmi_device *hdev, u32 reg_id, u8 value)
 	writeb(value, hdev->regs + reg_id);
 }
 
+static inline
+void hdmi_writebn(struct hdmi_device *hdev, u32 reg_id, int n, u32 value)
+{
+	switch (n) {
+	default:
+		writeb(value >> 24, hdev->regs + reg_id + 12);
+	case 3:
+		writeb(value >> 16, hdev->regs + reg_id + 8);
+	case 2:
+		writeb(value >>  8, hdev->regs + reg_id + 4);
+	case 1:
+		writeb(value >>  0, hdev->regs + reg_id + 0);
+	}
+}
+
 static inline u32 hdmi_read(struct hdmi_device *hdev, u32 reg_id)
 {
 	return readl(hdev->regs + reg_id);
@@ -211,72 +191,63 @@ static void hdmi_reg_init(struct hdmi_device *hdev)
 }
 
 static void hdmi_timing_apply(struct hdmi_device *hdev,
-	const struct hdmi_preset_conf *conf)
+	const struct hdmi_timings *t)
 {
-	const struct hdmi_core_regs *core = &conf->core;
-	const struct hdmi_tg_regs *tg = &conf->tg;
-
 	/* setting core registers */
-	hdmi_writeb(hdev, HDMI_H_BLANK_0, core->h_blank[0]);
-	hdmi_writeb(hdev, HDMI_H_BLANK_1, core->h_blank[1]);
-	hdmi_writeb(hdev, HDMI_V_BLANK_0, core->v_blank[0]);
-	hdmi_writeb(hdev, HDMI_V_BLANK_1, core->v_blank[1]);
-	hdmi_writeb(hdev, HDMI_V_BLANK_2, core->v_blank[2]);
-	hdmi_writeb(hdev, HDMI_H_V_LINE_0, core->h_v_line[0]);
-	hdmi_writeb(hdev, HDMI_H_V_LINE_1, core->h_v_line[1]);
-	hdmi_writeb(hdev, HDMI_H_V_LINE_2, core->h_v_line[2]);
-	hdmi_writeb(hdev, HDMI_VSYNC_POL, core->vsync_pol[0]);
-	hdmi_writeb(hdev, HDMI_INT_PRO_MODE, core->int_pro_mode[0]);
-	hdmi_writeb(hdev, HDMI_V_BLANK_F_0, core->v_blank_f[0]);
-	hdmi_writeb(hdev, HDMI_V_BLANK_F_1, core->v_blank_f[1]);
-	hdmi_writeb(hdev, HDMI_V_BLANK_F_2, core->v_blank_f[2]);
-	hdmi_writeb(hdev, HDMI_H_SYNC_GEN_0, core->h_sync_gen[0]);
-	hdmi_writeb(hdev, HDMI_H_SYNC_GEN_1, core->h_sync_gen[1]);
-	hdmi_writeb(hdev, HDMI_H_SYNC_GEN_2, core->h_sync_gen[2]);
-	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_1_0, core->v_sync_gen1[0]);
-	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_1_1, core->v_sync_gen1[1]);
-	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_1_2, core->v_sync_gen1[2]);
-	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_2_0, core->v_sync_gen2[0]);
-	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_2_1, core->v_sync_gen2[1]);
-	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_2_2, core->v_sync_gen2[2]);
-	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_3_0, core->v_sync_gen3[0]);
-	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_3_1, core->v_sync_gen3[1]);
-	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_3_2, core->v_sync_gen3[2]);
+	hdmi_writebn(hdev, HDMI_H_BLANK_0, 2, t->hact.beg);
+	hdmi_writebn(hdev, HDMI_H_SYNC_GEN_0, 3,
+		(t->hsyn_pol << 20) | (t->hsyn.end << 10) | t->hsyn.beg);
+	hdmi_writeb(hdev, HDMI_VSYNC_POL, t->vsyn_pol);
+	hdmi_writebn(hdev, HDMI_V_BLANK_0, 3,
+		(t->vact[0].beg << 11) | t->vact[0].end);
+	hdmi_writebn(hdev, HDMI_V_SYNC_GEN_1_0, 3,
+		(t->vsyn[0].beg << 12) | t->vsyn[0].end);
+	if (t->interlaced) {
+		u32 vsyn_trans = t->hsyn.beg + t->vsyn_off;
+
+		hdmi_writeb(hdev, HDMI_INT_PRO_MODE, 1);
+		hdmi_writebn(hdev, HDMI_H_V_LINE_0, 3,
+			(t->hact.end << 12) | t->vact[1].end);
+		hdmi_writebn(hdev, HDMI_V_BLANK_F_0, 3,
+			(t->vact[1].end << 11) | t->vact[1].beg);
+		hdmi_writebn(hdev, HDMI_V_SYNC_GEN_2_0, 3,
+			(t->vsyn[1].beg << 12) | t->vsyn[1].end);
+		hdmi_writebn(hdev, HDMI_V_SYNC_GEN_3_0, 3,
+			(vsyn_trans << 12) | vsyn_trans);
+	} else {
+		hdmi_writeb(hdev, HDMI_INT_PRO_MODE, 0);
+		hdmi_writebn(hdev, HDMI_H_V_LINE_0, 3,
+			(t->hact.end << 12) | t->vact[0].end);
+	}
+
 	/* Timing generator registers */
-	hdmi_writeb(hdev, HDMI_TG_H_FSZ_L, tg->h_fsz_l);
-	hdmi_writeb(hdev, HDMI_TG_H_FSZ_H, tg->h_fsz_h);
-	hdmi_writeb(hdev, HDMI_TG_HACT_ST_L, tg->hact_st_l);
-	hdmi_writeb(hdev, HDMI_TG_HACT_ST_H, tg->hact_st_h);
-	hdmi_writeb(hdev, HDMI_TG_HACT_SZ_L, tg->hact_sz_l);
-	hdmi_writeb(hdev, HDMI_TG_HACT_SZ_H, tg->hact_sz_h);
-	hdmi_writeb(hdev, HDMI_TG_V_FSZ_L, tg->v_fsz_l);
-	hdmi_writeb(hdev, HDMI_TG_V_FSZ_H, tg->v_fsz_h);
-	hdmi_writeb(hdev, HDMI_TG_VSYNC_L, tg->vsync_l);
-	hdmi_writeb(hdev, HDMI_TG_VSYNC_H, tg->vsync_h);
-	hdmi_writeb(hdev, HDMI_TG_VSYNC2_L, tg->vsync2_l);
-	hdmi_writeb(hdev, HDMI_TG_VSYNC2_H, tg->vsync2_h);
-	hdmi_writeb(hdev, HDMI_TG_VACT_ST_L, tg->vact_st_l);
-	hdmi_writeb(hdev, HDMI_TG_VACT_ST_H, tg->vact_st_h);
-	hdmi_writeb(hdev, HDMI_TG_VACT_SZ_L, tg->vact_sz_l);
-	hdmi_writeb(hdev, HDMI_TG_VACT_SZ_H, tg->vact_sz_h);
-	hdmi_writeb(hdev, HDMI_TG_FIELD_CHG_L, tg->field_chg_l);
-	hdmi_writeb(hdev, HDMI_TG_FIELD_CHG_H, tg->field_chg_h);
-	hdmi_writeb(hdev, HDMI_TG_VACT_ST2_L, tg->vact_st2_l);
-	hdmi_writeb(hdev, HDMI_TG_VACT_ST2_H, tg->vact_st2_h);
-	hdmi_writeb(hdev, HDMI_TG_VSYNC_TOP_HDMI_L, tg->vsync_top_hdmi_l);
-	hdmi_writeb(hdev, HDMI_TG_VSYNC_TOP_HDMI_H, tg->vsync_top_hdmi_h);
-	hdmi_writeb(hdev, HDMI_TG_VSYNC_BOT_HDMI_L, tg->vsync_bot_hdmi_l);
-	hdmi_writeb(hdev, HDMI_TG_VSYNC_BOT_HDMI_H, tg->vsync_bot_hdmi_h);
-	hdmi_writeb(hdev, HDMI_TG_FIELD_TOP_HDMI_L, tg->field_top_hdmi_l);
-	hdmi_writeb(hdev, HDMI_TG_FIELD_TOP_HDMI_H, tg->field_top_hdmi_h);
-	hdmi_writeb(hdev, HDMI_TG_FIELD_BOT_HDMI_L, tg->field_bot_hdmi_l);
-	hdmi_writeb(hdev, HDMI_TG_FIELD_BOT_HDMI_H, tg->field_bot_hdmi_h);
+	hdmi_writebn(hdev, HDMI_TG_H_FSZ_L, 2, t->hact.end);
+	hdmi_writebn(hdev, HDMI_TG_HACT_ST_L, 2, t->hact.beg);
+	hdmi_writebn(hdev, HDMI_TG_HACT_SZ_L, 2, t->hact.end - t->hact.beg);
+	hdmi_writebn(hdev, HDMI_TG_VSYNC_L, 2, t->vsyn[0].beg);
+	hdmi_writebn(hdev, HDMI_TG_VACT_ST_L, 2, t->vact[0].beg);
+	hdmi_writebn(hdev, HDMI_TG_VACT_SZ_L, 2,
+		t->vact[0].end - t->vact[0].beg);
+	hdmi_writebn(hdev, HDMI_TG_VSYNC_TOP_HDMI_L, 2, t->vsyn[0].beg);
+	hdmi_writebn(hdev, HDMI_TG_FIELD_TOP_HDMI_L, 2, t->vsyn[0].beg);
+	if (t->interlaced) {
+		hdmi_write_mask(hdev, HDMI_TG_CMD, ~0, HDMI_TG_FIELD_EN);
+		hdmi_writebn(hdev, HDMI_TG_V_FSZ_L, 2, t->vact[1].end);
+		hdmi_writebn(hdev, HDMI_TG_VSYNC2_L, 2, t->vsyn[1].beg);
+		hdmi_writebn(hdev, HDMI_TG_FIELD_CHG_L, 2, t->vact[0].end);
+		hdmi_writebn(hdev, HDMI_TG_VACT_ST2_L, 2, t->vact[1].beg);
+		hdmi_writebn(hdev, HDMI_TG_VSYNC_BOT_HDMI_L, 2, t->vsyn[1].beg);
+		hdmi_writebn(hdev, HDMI_TG_FIELD_BOT_HDMI_L, 2, t->vsyn[1].beg);
+	} else {
+		hdmi_write_mask(hdev, HDMI_TG_CMD, 0, HDMI_TG_FIELD_EN);
+		hdmi_writebn(hdev, HDMI_TG_V_FSZ_L, 2, t->vact[0].end);
+	}
 }
 
 static int hdmi_conf_apply(struct hdmi_device *hdmi_dev)
 {
 	struct device *dev = hdmi_dev->dev;
-	const struct hdmi_preset_conf *conf = hdmi_dev->cur_conf;
+	const struct hdmi_timings *conf = hdmi_dev->cur_conf;
 	struct v4l2_dv_preset preset;
 	int ret;
 
@@ -398,156 +369,126 @@ static void hdmi_dumpregs(struct hdmi_device *hdev, char *prefix)
 #undef DUMPREG
 }
 
-static const struct hdmi_preset_conf hdmi_conf_480p = {
-	.core = {
-		.h_blank = {0x8a, 0x00},
-		.v_blank = {0x0d, 0x6a, 0x01},
-		.h_v_line = {0x0d, 0xa2, 0x35},
-		.vsync_pol = {0x01},
-		.int_pro_mode = {0x00},
-		.v_blank_f = {0x00, 0x00, 0x00},
-		.h_sync_gen = {0x0e, 0x30, 0x11},
-		.v_sync_gen1 = {0x0f, 0x90, 0x00},
-		/* other don't care */
-	},
-	.tg = {
-		0x00, /* cmd */
-		0x5a, 0x03, /* h_fsz */
-		0x8a, 0x00, 0xd0, 0x02, /* hact */
-		0x0d, 0x02, /* v_fsz */
-		0x01, 0x00, 0x33, 0x02, /* vsync */
-		0x2d, 0x00, 0xe0, 0x01, /* vact */
-		0x33, 0x02, /* field_chg */
-		0x49, 0x02, /* vact_st2 */
-		0x01, 0x00, 0x33, 0x02, /* vsync top/bot */
-		0x01, 0x00, 0x33, 0x02, /* field top/bot */
-	},
-	.mbus_fmt = {
-		.width = 720,
-		.height = 480,
-		.code = V4L2_MBUS_FMT_FIXED, /* means RGB888 */
-		.field = V4L2_FIELD_NONE,
-		.colorspace = V4L2_COLORSPACE_SRGB,
-	},
+static const struct hdmi_timings hdmi_timings_480p = {
+	.hact = { .beg = 138, .end = 858 },
+	.hsyn_pol = 1,
+	.hsyn = { .beg = 16, .end = 16 + 62 },
+	.interlaced = 0,
+	.vact[0] = { .beg = 42 + 3, .end = 522 + 3 },
+	.vsyn_pol = 1,
+	.vsyn[0] = { .beg = 6 + 3, .end = 12 + 3},
+};
+
+static const struct hdmi_timings hdmi_timings_576p50 = {
+	.hact = { .beg = 144, .end = 864 },
+	.hsyn_pol = 1,
+	.hsyn = { .beg = 12, .end = 12 + 64 },
+	.interlaced = 0,
+	.vact[0] = { .beg = 44 + 5, .end = 620 + 5 },
+	.vsyn_pol = 1,
+	.vsyn[0] = { .beg = 0 + 5, .end = 5 + 5},
+};
+
+static const struct hdmi_timings hdmi_timings_720p60 = {
+	.hact = { .beg = 370, .end = 1650 },
+	.hsyn_pol = 0,
+	.hsyn = { .beg = 110, .end = 110 + 40 },
+	.interlaced = 0,
+	.vact[0] = { .beg = 25 + 5, .end = 745 + 5 },
+	.vsyn_pol = 0,
+	.vsyn[0] = { .beg = 0 + 5, .end = 5 + 5},
+};
+
+static const struct hdmi_timings hdmi_timings_720p50 = {
+	.hact = { .beg = 700, .end = 1980 },
+	.hsyn_pol = 0,
+	.hsyn = { .beg = 440, .end = 440 + 40 },
+	.interlaced = 0,
+	.vact[0] = { .beg = 25 + 5, .end = 745 + 5 },
+	.vsyn_pol = 0,
+	.vsyn[0] = { .beg = 0 + 5, .end = 5 + 5},
+};
+
+static const struct hdmi_timings hdmi_timings_1080p24 = {
+	.hact = { .beg = 830, .end = 2750 },
+	.hsyn_pol = 0,
+	.hsyn = { .beg = 638, .end = 638 + 44 },
+	.interlaced = 0,
+	.vact[0] = { .beg = 41 + 4, .end = 1121 + 4 },
+	.vsyn_pol = 0,
+	.vsyn[0] = { .beg = 0 + 4, .end = 5 + 4},
+};
+
+static const struct hdmi_timings hdmi_timings_1080p60 = {
+	.hact = { .beg = 280, .end = 2200 },
+	.hsyn_pol = 0,
+	.hsyn = { .beg = 88, .end = 88 + 44 },
+	.interlaced = 0,
+	.vact[0] = { .beg = 41 + 4, .end = 1121 + 4 },
+	.vsyn_pol = 0,
+	.vsyn[0] = { .beg = 0 + 4, .end = 5 + 4},
 };
 
-static const struct hdmi_preset_conf hdmi_conf_720p60 = {
-	.core = {
-		.h_blank = {0x72, 0x01},
-		.v_blank = {0xee, 0xf2, 0x00},
-		.h_v_line = {0xee, 0x22, 0x67},
-		.vsync_pol = {0x00},
-		.int_pro_mode = {0x00},
-		.v_blank_f = {0x00, 0x00, 0x00}, /* don't care */
-		.h_sync_gen = {0x6c, 0x50, 0x02},
-		.v_sync_gen1 = {0x0a, 0x50, 0x00},
-		/* other don't care */
-	},
-	.tg = {
-		0x00, /* cmd */
-		0x72, 0x06, /* h_fsz */
-		0x72, 0x01, 0x00, 0x05, /* hact */
-		0xee, 0x02, /* v_fsz */
-		0x01, 0x00, 0x33, 0x02, /* vsync */
-		0x1e, 0x00, 0xd0, 0x02, /* vact */
-		0x33, 0x02, /* field_chg */
-		0x49, 0x02, /* vact_st2 */
-		0x01, 0x00, 0x33, 0x02, /* vsync top/bot */
-		0x01, 0x00, 0x33, 0x02, /* field top/bot */
-	},
-	.mbus_fmt = {
-		.width = 1280,
-		.height = 720,
-		.code = V4L2_MBUS_FMT_FIXED, /* means RGB888 */
-		.field = V4L2_FIELD_NONE,
-		.colorspace = V4L2_COLORSPACE_SRGB,
-	},
+static const struct hdmi_timings hdmi_timings_1080i60 = {
+	.hact = { .beg = 280, .end = 2200 },
+	.hsyn_pol = 0,
+	.hsyn = { .beg = 88, .end = 88 + 44 },
+	.interlaced = 1,
+	.vact[0] = { .beg = 20 + 2, .end = 560 + 2 },
+	.vact[1] = { .beg = 583 + 2, .end = 1123 + 2 },
+	.vsyn_pol = 0,
+	.vsyn_off = 1100,
+	.vsyn[0] = { .beg = 0 + 2, .end = 5 + 2},
+	.vsyn[1] = { .beg = 562 + 2, .end = 567 + 2},
 };
 
-static const struct hdmi_preset_conf hdmi_conf_1080p50 = {
-	.core = {
-		.h_blank = {0xd0, 0x02},
-		.v_blank = {0x65, 0x6c, 0x01},
-		.h_v_line = {0x65, 0x04, 0xa5},
-		.vsync_pol = {0x00},
-		.int_pro_mode = {0x00},
-		.v_blank_f = {0x00, 0x00, 0x00}, /* don't care */
-		.h_sync_gen = {0x0e, 0xea, 0x08},
-		.v_sync_gen1 = {0x09, 0x40, 0x00},
-		/* other don't care */
-	},
-	.tg = {
-		0x00, /* cmd */
-		0x98, 0x08, /* h_fsz */
-		0x18, 0x01, 0x80, 0x07, /* hact */
-		0x65, 0x04, /* v_fsz */
-		0x01, 0x00, 0x33, 0x02, /* vsync */
-		0x2d, 0x00, 0x38, 0x04, /* vact */
-		0x33, 0x02, /* field_chg */
-		0x49, 0x02, /* vact_st2 */
-		0x01, 0x00, 0x33, 0x02, /* vsync top/bot */
-		0x01, 0x00, 0x33, 0x02, /* field top/bot */
-	},
-	.mbus_fmt = {
-		.width = 1920,
-		.height = 1080,
-		.code = V4L2_MBUS_FMT_FIXED, /* means RGB888 */
-		.field = V4L2_FIELD_NONE,
-		.colorspace = V4L2_COLORSPACE_SRGB,
-	},
+static const struct hdmi_timings hdmi_timings_1080i50 = {
+	.hact = { .beg = 720, .end = 2640 },
+	.hsyn_pol = 0,
+	.hsyn = { .beg = 528, .end = 528 + 44 },
+	.interlaced = 1,
+	.vact[0] = { .beg = 20 + 2, .end = 560 + 2 },
+	.vact[1] = { .beg = 583 + 2, .end = 1123 + 2 },
+	.vsyn_pol = 0,
+	.vsyn_off = 1320,
+	.vsyn[0] = { .beg = 0 + 2, .end = 5 + 2},
+	.vsyn[1] = { .beg = 562 + 2, .end = 567 + 2},
 };
 
-static const struct hdmi_preset_conf hdmi_conf_1080p60 = {
-	.core = {
-		.h_blank = {0x18, 0x01},
-		.v_blank = {0x65, 0x6c, 0x01},
-		.h_v_line = {0x65, 0x84, 0x89},
-		.vsync_pol = {0x00},
-		.int_pro_mode = {0x00},
-		.v_blank_f = {0x00, 0x00, 0x00}, /* don't care */
-		.h_sync_gen = {0x56, 0x08, 0x02},
-		.v_sync_gen1 = {0x09, 0x40, 0x00},
-		/* other don't care */
-	},
-	.tg = {
-		0x00, /* cmd */
-		0x98, 0x08, /* h_fsz */
-		0x18, 0x01, 0x80, 0x07, /* hact */
-		0x65, 0x04, /* v_fsz */
-		0x01, 0x00, 0x33, 0x02, /* vsync */
-		0x2d, 0x00, 0x38, 0x04, /* vact */
-		0x33, 0x02, /* field_chg */
-		0x48, 0x02, /* vact_st2 */
-		0x01, 0x00, 0x01, 0x00, /* vsync top/bot */
-		0x01, 0x00, 0x33, 0x02, /* field top/bot */
-	},
-	.mbus_fmt = {
-		.width = 1920,
-		.height = 1080,
-		.code = V4L2_MBUS_FMT_FIXED, /* means RGB888 */
-		.field = V4L2_FIELD_NONE,
-		.colorspace = V4L2_COLORSPACE_SRGB,
-	},
+static const struct hdmi_timings hdmi_timings_1080p50 = {
+	.hact = { .beg = 720, .end = 2640 },
+	.hsyn_pol = 0,
+	.hsyn = { .beg = 528, .end = 528 + 44 },
+	.interlaced = 0,
+	.vact[0] = { .beg = 41 + 4, .end = 1121 + 4 },
+	.vsyn_pol = 0,
+	.vsyn[0] = { .beg = 0 + 4, .end = 5 + 4},
 };
 
 static const struct {
 	u32 preset;
-	const struct hdmi_preset_conf *conf;
-} hdmi_conf[] = {
-	{ V4L2_DV_480P59_94, &hdmi_conf_480p },
-	{ V4L2_DV_720P59_94, &hdmi_conf_720p60 },
-	{ V4L2_DV_1080P50, &hdmi_conf_1080p50 },
-	{ V4L2_DV_1080P30, &hdmi_conf_1080p60 },
-	{ V4L2_DV_1080P60, &hdmi_conf_1080p60 },
+	const struct hdmi_timings *timings;
+} hdmi_timings[] = {
+	{ V4L2_DV_480P59_94, &hdmi_timings_480p },
+	{ V4L2_DV_576P50, &hdmi_timings_576p50 },
+	{ V4L2_DV_720P50, &hdmi_timings_720p50 },
+	{ V4L2_DV_720P59_94, &hdmi_timings_720p60 },
+	{ V4L2_DV_720P60, &hdmi_timings_720p60 },
+	{ V4L2_DV_1080P24, &hdmi_timings_1080p24 },
+	{ V4L2_DV_1080P30, &hdmi_timings_1080p60 },
+	{ V4L2_DV_1080P50, &hdmi_timings_1080p50 },
+	{ V4L2_DV_1080I50, &hdmi_timings_1080i50 },
+	{ V4L2_DV_1080I60, &hdmi_timings_1080i60 },
+	{ V4L2_DV_1080P60, &hdmi_timings_1080p60 },
 };
 
-static const struct hdmi_preset_conf *hdmi_preset2conf(u32 preset)
+static const struct hdmi_timings *hdmi_preset2timings(u32 preset)
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(hdmi_conf); ++i)
-		if (hdmi_conf[i].preset == preset)
-			return  hdmi_conf[i].conf;
+	for (i = 0; i < ARRAY_SIZE(hdmi_timings); ++i)
+		if (hdmi_timings[i].preset == preset)
+			return  hdmi_timings[i].timings;
 	return NULL;
 }
 
@@ -671,9 +612,9 @@ static int hdmi_s_dv_preset(struct v4l2_subdev *sd,
 {
 	struct hdmi_device *hdev = sd_to_hdmi_dev(sd);
 	struct device *dev = hdev->dev;
-	const struct hdmi_preset_conf *conf;
+	const struct hdmi_timings *conf;
 
-	conf = hdmi_preset2conf(preset->preset);
+	conf = hdmi_preset2timings(preset->preset);
 	if (conf == NULL) {
 		dev_err(dev, "preset (%u) not supported\n", preset->preset);
 		return -EINVAL;
@@ -695,21 +636,32 @@ static int hdmi_g_mbus_fmt(struct v4l2_subdev *sd,
 	  struct v4l2_mbus_framefmt *fmt)
 {
 	struct hdmi_device *hdev = sd_to_hdmi_dev(sd);
-	struct device *dev = hdev->dev;
+	const struct hdmi_timings *t = hdev->cur_conf;
 
-	dev_dbg(dev, "%s\n", __func__);
+	dev_dbg(hdev->dev, "%s\n", __func__);
 	if (!hdev->cur_conf)
 		return -EINVAL;
-	*fmt = hdev->cur_conf->mbus_fmt;
+	memset(fmt, 0, sizeof *fmt);
+	fmt->width = t->hact.end - t->hact.beg;
+	fmt->height = t->vact[0].end - t->vact[0].beg;
+	fmt->code = V4L2_MBUS_FMT_FIXED; /* means RGB888 */
+	fmt->colorspace = V4L2_COLORSPACE_SRGB;
+	if (t->interlaced) {
+		fmt->field = V4L2_FIELD_INTERLACED;
+		fmt->height *= 2;
+	} else {
+		fmt->field = V4L2_FIELD_NONE;
+	}
 	return 0;
 }
 
 static int hdmi_enum_dv_presets(struct v4l2_subdev *sd,
 	struct v4l2_dv_enum_preset *preset)
 {
-	if (preset->index >= ARRAY_SIZE(hdmi_conf))
+	if (preset->index >= ARRAY_SIZE(hdmi_timings))
 		return -EINVAL;
-	return v4l_fill_dv_preset_info(hdmi_conf[preset->index].preset, preset);
+	return v4l_fill_dv_preset_info(hdmi_timings[preset->index].preset,
+		preset);
 }
 
 static const struct v4l2_subdev_core_ops hdmi_sd_core_ops = {
@@ -993,7 +945,7 @@ static int __devinit hdmi_probe(struct platform_device *pdev)
 	strlcpy(sd->name, "s5p-hdmi", sizeof sd->name);
 	hdmi_dev->cur_preset = HDMI_DEFAULT_PRESET;
 	/* FIXME: missing fail preset is not supported */
-	hdmi_dev->cur_conf = hdmi_preset2conf(hdmi_dev->cur_preset);
+	hdmi_dev->cur_conf = hdmi_preset2timings(hdmi_dev->cur_preset);
 
 	/* storing subdev for call that have only access to struct device */
 	dev_set_drvdata(dev, sd);
diff --git a/drivers/media/video/s5p-tv/regs-hdmi.h b/drivers/media/video/s5p-tv/regs-hdmi.h
index 33247d1..a889d1f 100644
--- a/drivers/media/video/s5p-tv/regs-hdmi.h
+++ b/drivers/media/video/s5p-tv/regs-hdmi.h
@@ -140,6 +140,7 @@
 #define HDMI_MODE_MASK			(3 << 0)
 
 /* HDMI_TG_CMD */
+#define HDMI_TG_FIELD_EN		(1 << 1)
 #define HDMI_TG_EN			(1 << 0)
 
 #endif /* SAMSUNG_REGS_HDMI_H */
-- 
1.7.5.4

