Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:47716 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752863AbbCIPrI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 11:47:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 14/29] vivid-tpg: add hor/vert downsampling support to tpg_gen_text
Date: Mon,  9 Mar 2015 16:44:36 +0100
Message-Id: <1425915891-1017-15-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
References: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This will just skip lines/pixels since color fidelity is not quite
as important here as it is with the test patterns themselves.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-tpg.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index 9001b9a..f03289f 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -1183,24 +1183,37 @@ void tpg_gen_text(struct tpg_data *tpg, u8 *basep[TPG_MAX_PLANES][2],
 		div = 2;
 
 	for (p = 0; p < tpg->planes; p++) {
-		/* Print stream time */
+		unsigned vdiv = tpg->vdownsampling[p];
+		unsigned hdiv = tpg->hdownsampling[p];
+
+		/* Print text */
 #define PRINTSTR(PIXTYPE) do {	\
 	PIXTYPE fg;	\
 	PIXTYPE bg;	\
 	memcpy(&fg, tpg->textfg[p], sizeof(PIXTYPE));	\
 	memcpy(&bg, tpg->textbg[p], sizeof(PIXTYPE));	\
 	\
-	for (line = first; line < 16; line += step) {	\
+	for (line = first; line < 16; line += vdiv * step) {	\
 		int l = tpg->vflip ? 15 - line : line; \
-		PIXTYPE *pos = (PIXTYPE *)(basep[p][line & 1] + \
-			       ((y * step + l) / div) * tpg->bytesperline[p] + \
-			       x * sizeof(PIXTYPE));	\
+		PIXTYPE *pos = (PIXTYPE *)(basep[p][(line / vdiv) & 1] + \
+			       ((y * step + l) / (vdiv * div)) * tpg->bytesperline[p] + \
+			       (x / hdiv) * sizeof(PIXTYPE));	\
 		unsigned s;	\
 	\
 		for (s = 0; s < len; s++) {	\
 			u8 chr = font8x16[text[s] * 16 + line];	\
 	\
-			if (tpg->hflip) { \
+			if (hdiv == 2 && tpg->hflip) { \
+				pos[3] = (chr & (0x01 << 6) ? fg : bg);	\
+				pos[2] = (chr & (0x01 << 4) ? fg : bg);	\
+				pos[1] = (chr & (0x01 << 2) ? fg : bg);	\
+				pos[0] = (chr & (0x01 << 0) ? fg : bg);	\
+			} else if (hdiv == 2) { \
+				pos[0] = (chr & (0x01 << 7) ? fg : bg);	\
+				pos[1] = (chr & (0x01 << 5) ? fg : bg);	\
+				pos[2] = (chr & (0x01 << 3) ? fg : bg);	\
+				pos[3] = (chr & (0x01 << 1) ? fg : bg);	\
+			} else if (tpg->hflip) { \
 				pos[7] = (chr & (0x01 << 7) ? fg : bg);	\
 				pos[6] = (chr & (0x01 << 6) ? fg : bg);	\
 				pos[5] = (chr & (0x01 << 5) ? fg : bg);	\
@@ -1220,7 +1233,7 @@ void tpg_gen_text(struct tpg_data *tpg, u8 *basep[TPG_MAX_PLANES][2],
 				pos[7] = (chr & (0x01 << 0) ? fg : bg);	\
 			} \
 	\
-			pos += tpg->hflip ? -8 : 8;	\
+			pos += (tpg->hflip ? -8 : 8) / hdiv;	\
 		}	\
 	}	\
 } while (0)
-- 
2.1.4

