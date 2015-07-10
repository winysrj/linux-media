Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:59083 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753870AbbGJI3o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jul 2015 04:29:44 -0400
From: Fabien Dessenne <fabien.dessenne@st.com>
To: <linux-media@vger.kernel.org>
CC: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	<hugues.fruchet@st.com>, <kernel@stlinux.com>
Subject: [PATCH 2/2] [media] bdisp: add debug info for RGB24 format
Date: Fri, 10 Jul 2015 10:29:37 +0200
Message-ID: <1436516977-28157-1-git-send-email-fabien.dessenne@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add this missing debug information

Signed-off-by: Fabien Dessenne <fabien.dessenne@st.com>
---
 drivers/media/platform/sti/bdisp/bdisp-debug.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/platform/sti/bdisp/bdisp-debug.c b/drivers/media/platform/sti/bdisp/bdisp-debug.c
index 18282a0..79c5635 100644
--- a/drivers/media/platform/sti/bdisp/bdisp-debug.c
+++ b/drivers/media/platform/sti/bdisp/bdisp-debug.c
@@ -116,6 +116,9 @@ static void bdisp_dbg_dump_tty(struct seq_file *s, u32 val)
 	case BDISP_RGB565:
 		seq_puts(s, "RGB565 - ");
 		break;
+	case BDISP_RGB888:
+		seq_puts(s, "RGB888 - ");
+		break;
 	case BDISP_XRGB8888:
 		seq_puts(s, "xRGB888 - ");
 		break;
@@ -185,6 +188,9 @@ static void bdisp_dbg_dump_sty(struct seq_file *s,
 	case BDISP_RGB565:
 		seq_puts(s, "RGB565 - ");
 		break;
+	case BDISP_RGB888:
+		seq_puts(s, "RGB888 - ");
+		break;
 	case BDISP_XRGB8888:
 		seq_puts(s, "xRGB888 - ");
 		break;
@@ -420,6 +426,8 @@ static const char *bdisp_fmt_to_str(struct bdisp_frame frame)
 			return "NV12";
 	case V4L2_PIX_FMT_RGB565:
 		return "RGB16";
+	case V4L2_PIX_FMT_RGB24:
+		return "RGB24";
 	case V4L2_PIX_FMT_XBGR32:
 		return "XRGB";
 	case V4L2_PIX_FMT_ABGR32:
-- 
1.9.1

