Return-path: <mchehab@pedra>
Received: from smtp24.services.sfr.fr ([93.17.128.82]:15913 "EHLO
	smtp24.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab0HWKuJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Aug 2010 06:50:09 -0400
Received: from filter.sfr.fr (localhost [127.0.0.1])
	by msfrf2409.sfr.fr (SMTP Server) with ESMTP id E3724700008B
	for <linux-media@vger.kernel.org>; Mon, 23 Aug 2010 12:50:01 +0200 (CEST)
Received: from smtp-in.softsystem.co.uk (117.131.200-77.rev.gaoland.net [77.200.131.117])
	by msfrf2409.sfr.fr (SMTP Server) with SMTP id 0C274700008A
	for <linux-media@vger.kernel.org>; Mon, 23 Aug 2010 12:49:58 +0200 (CEST)
Received: FROM [192.168.1.62] (gagarin [192.168.1.62])
	BY smtp-in.softsystem.co.uk [77.200.131.117] (SoftMail 1.0.5, www.softsystem.co.uk) WITH ESMTP
	FOR <linux-media@vger.kernel.org>; Mon, 23 Aug 2010 12:49:58 +0200
Subject: [PATCH] cx88: convert core->tvaudio into an enum
From: lawrence rust <lawrence@softsystem.co.uk>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Aug 2010 12:49:58 +0200
Message-ID: <1282560598.1400.34.camel@gagarin>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Using an enum and removing the default case from switch statements accessing
the value enables the compiler to emit a warning (enabled with -Wall) when an
audio mode is not handled.

This highlights an omission in the function cx88_dsp_detect_stereo_sap()
(in cx88-dsp.c) not handling WW_EIAJ and WW_M.

Signed-off-by: Lawrence Rust <lawrence@softsystem.co.uk>
---
 drivers/media/video/cx88/cx88-core.c    |    2 +-
 drivers/media/video/cx88/cx88-dsp.c     |   17 +++++++++++++-
 drivers/media/video/cx88/cx88-tvaudio.c |   37 ++++++++++++++++++++++++++----
 drivers/media/video/cx88/cx88.h         |   28 ++++++++++++-----------
 4 files changed, 64 insertions(+), 20 deletions(-)

diff --git a/drivers/media/video/cx88/cx88-core.c b/drivers/media/video/cx88/cx88-core.c
index 8b21457..b0cf307 100644
--- a/drivers/media/video/cx88/cx88-core.c
+++ b/drivers/media/video/cx88/cx88-core.c
@@ -879,7 +879,7 @@ static int set_tvaudio(struct cx88_core *core)
 	} else {
 		printk("%s/0: tvaudio support needs work for this tv norm [%s], sorry\n",
 		       core->name, v4l2_norm_to_name(core->tvnorm));
-		core->tvaudio = 0;
+		core->tvaudio = WW_NONE;
 		return 0;
 	}
 
diff --git a/drivers/media/video/cx88/cx88-dsp.c b/drivers/media/video/cx88/cx88-dsp.c
index a94e00a..e1d6eef 100644
--- a/drivers/media/video/cx88/cx88-dsp.c
+++ b/drivers/media/video/cx88/cx88-dsp.c
@@ -175,7 +175,13 @@ static s32 detect_a2_a2m_eiaj(struct cx88_core *core, s16 x[], u32 N)
 		stereo_freq = FREQ_EIAJ_STEREO;
 		dual_freq = FREQ_EIAJ_DUAL;
 		break;
-	default:
+	case WW_NONE:
+	case WW_BTSC:
+	case WW_I:
+	case WW_L:
+	case WW_I2SPT:
+	case WW_FM:
+	case WW_I2SADC:
 		printk(KERN_WARNING "%s/0: unsupported audio mode %d for %s\n",
 		       core->name, core->tvaudio, __func__);
 		return UNSET;
@@ -292,11 +298,20 @@ s32 cx88_dsp_detect_stereo_sap(struct cx88_core *core)
 	switch (core->tvaudio) {
 	case WW_BG:
 	case WW_DK:
+	case WW_EIAJ:
+	case WW_M:
 		ret = detect_a2_a2m_eiaj(core, samples, N);
 		break;
 	case WW_BTSC:
 		ret = detect_btsc(core, samples, N);
 		break;
+	case WW_NONE:
+	case WW_I:
+	case WW_L:
+	case WW_I2SPT:
+	case WW_FM:
+	case WW_I2SADC:
+		break;
 	}
 
 	kfree(samples);
diff --git a/drivers/media/video/cx88/cx88-tvaudio.c b/drivers/media/video/cx88/cx88-tvaudio.c
index 2396315..db63547 100644
--- a/drivers/media/video/cx88/cx88-tvaudio.c
+++ b/drivers/media/video/cx88/cx88-tvaudio.c
@@ -360,7 +360,15 @@ static void set_audio_standard_NICAM(struct cx88_core *core, u32 mode)
 		set_audio_registers(core, nicam_bgdki_common);
 		set_audio_registers(core, nicam_i);
 		break;
-	default:
+	case WW_NONE:
+	case WW_BTSC:
+	case WW_BG:
+	case WW_DK:
+	case WW_EIAJ:
+	case WW_I2SPT:
+	case WW_FM:
+	case WW_I2SADC:
+	case WW_M:
 		dprintk("%s PAL-BGDK NICAM (status: known-good)\n", __func__);
 		set_audio_registers(core, nicam_bgdki_common);
 		set_audio_registers(core, nicam_default);
@@ -621,7 +629,13 @@ static void set_audio_standard_A2(struct cx88_core *core, u32 mode)
 		dprintk("%s AM-L (status: devel)\n", __func__);
 		set_audio_registers(core, am_l);
 		break;
-	default:
+	case WW_NONE:
+	case WW_BTSC:
+	case WW_EIAJ:
+	case WW_I2SPT:
+	case WW_FM:
+	case WW_I2SADC:
+	case WW_M:
 		dprintk("%s Warning: wrong value\n", __func__);
 		return;
 		break;
@@ -779,7 +793,7 @@ void cx88_set_tvaudio(struct cx88_core *core)
 		set_audio_finish(core, EN_I2SIN_ENABLE);
 		break;
 	case WW_NONE:
-	default:
+	case WW_I2SPT:
 		printk("%s/0: unknown tv audio mode [%d]\n",
 		       core->name, core->tvaudio);
 		break;
@@ -840,7 +854,12 @@ void cx88_get_stereo(struct cx88_core *core, struct v4l2_tuner *t)
 			break;
 		}
 		break;
-	default:
+	case WW_NONE:
+	case WW_I:
+	case WW_L:
+	case WW_I2SPT:
+	case WW_FM:
+	case WW_I2SADC:
 		/* nothing */
 		break;
 	}
@@ -945,6 +964,9 @@ void cx88_set_stereo(struct cx88_core *core, u32 mode, int manual)
 		}
 		break;
 	case WW_I2SADC:
+	case WW_NONE:
+	case WW_EIAJ:
+	case WW_I2SPT:
 		/* DO NOTHING */
 		break;
 	}
@@ -1000,7 +1022,12 @@ int cx88_audio_thread(void *data)
 			/* automatically switch to best available mode */
 			cx88_set_stereo(core, mode, 0);
 			break;
-		default:
+		case WW_NONE:
+		case WW_BTSC:
+		case WW_EIAJ:
+		case WW_I2SPT:
+		case WW_FM:
+		case WW_I2SADC:
 hw_autodetect:
 			/* stereo autodetection is supported by hardware so
 			   we don't need to do it manually. Do nothing. */
diff --git a/drivers/media/video/cx88/cx88.h b/drivers/media/video/cx88/cx88.h
index a77fe3f..a4b5dde 100644
--- a/drivers/media/video/cx88/cx88.h
+++ b/drivers/media/video/cx88/cx88.h
@@ -281,6 +281,20 @@ struct cx88_subid {
 	u32     card;
 };
 
+enum cx88_tvaudio {
+	WW_NONE = 1,
+	WW_BTSC,
+	WW_BG,
+	WW_DK,
+	WW_I,
+	WW_L,
+	WW_EIAJ,
+	WW_I2SPT,
+	WW_FM,
+	WW_I2SADC,
+	WW_M
+};
+
 #define INPUT(nr) (core->board.input[nr])
 
 /* ----------------------------------------------------------- */
@@ -352,7 +366,7 @@ struct cx88_core {
 	/* state info */
 	struct task_struct         *kthread;
 	v4l2_std_id                tvnorm;
-	u32                        tvaudio;
+	enum cx88_tvaudio          tvaudio;
 	u32                        audiomode_manual;
 	u32                        audiomode_current;
 	u32                        input;
@@ -652,18 +666,6 @@ extern void cx88_setup_xc3028(struct cx88_core *core, struct xc2028_ctrl *ctl);
 /* ----------------------------------------------------------- */
 /* cx88-tvaudio.c                                              */
 
-#define WW_NONE		 1
-#define WW_BTSC		 2
-#define WW_BG		 3
-#define WW_DK		 4
-#define WW_I		 5
-#define WW_L		 6
-#define WW_EIAJ		 7
-#define WW_I2SPT	 8
-#define WW_FM		 9
-#define WW_I2SADC	 10
-#define WW_M		 11
-
 void cx88_set_tvaudio(struct cx88_core *core);
 void cx88_newstation(struct cx88_core *core);
 void cx88_get_stereo(struct cx88_core *core, struct v4l2_tuner *t);
-- 
1.7.0.4




