Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:56623 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754281AbbCIPqu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 11:46:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 12/29] vivid-tpg: precalculate downsampled lines
Date: Mon,  9 Mar 2015 16:44:34 +0100
Message-Id: <1425915891-1017-13-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
References: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

When dealing with vertical downsampling two successive lines have to be
averaged. In the case of the test pattern generator that only happens
if the two lines are using different patterns. So precalculate the average
between two pattern lines: one of pattern P and one of pattern P + 1.

That way there is no need to do any on-the-fly downsampling: it's all done
in the precalculate phase.

This patch also implements horizontal downsampling in the precalculate phase.
The only thing that needs to be done is to half the width since the actual
downsampling happens when two pixels at a time are generated.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-tpg.c | 40 ++++++++++++++++++++++++++++++--
 drivers/media/platform/vivid/vivid-tpg.h |  1 +
 2 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index 9f47387..d7531d3 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -128,6 +128,11 @@ int tpg_alloc(struct tpg_data *tpg, unsigned max_w)
 			tpg->lines[pat][plane] = vzalloc(max_w * 2 * pixelsz);
 			if (!tpg->lines[pat][plane])
 				return -ENOMEM;
+			if (plane == 0)
+				continue;
+			tpg->downsampled_lines[pat][plane] = vzalloc(max_w * 2 * pixelsz);
+			if (!tpg->downsampled_lines[pat][plane])
+				return -ENOMEM;
 		}
 	}
 	for (plane = 0; plane < TPG_MAX_PLANES; plane++) {
@@ -155,6 +160,10 @@ void tpg_free(struct tpg_data *tpg)
 		for (plane = 0; plane < TPG_MAX_PLANES; plane++) {
 			vfree(tpg->lines[pat][plane]);
 			tpg->lines[pat][plane] = NULL;
+			if (plane == 0)
+				continue;
+			vfree(tpg->downsampled_lines[pat][plane]);
+			tpg->downsampled_lines[pat][plane] = NULL;
 		}
 	for (plane = 0; plane < TPG_MAX_PLANES; plane++) {
 		vfree(tpg->contrast_line[plane]);
@@ -1029,12 +1038,39 @@ static void tpg_precalculate_line(struct tpg_data *tpg)
 			gen_twopix(tpg, pix, tpg->hflip ? color1 : color2, 1);
 			for (p = 0; p < tpg->planes; p++) {
 				unsigned twopixsize = tpg->twopixelsize[p];
-				u8 *pos = tpg->lines[pat][p] + x * twopixsize / 2;
+				unsigned hdiv = tpg->hdownsampling[p];
+				u8 *pos = tpg->lines[pat][p] +
+						(x / hdiv) * twopixsize / 2;
+
+				memcpy(pos, pix[p], twopixsize / hdiv);
+			}
+		}
+	}
+
+	if (tpg->vdownsampling[tpg->planes - 1] > 1) {
+		unsigned pat_lines = tpg_get_pat_lines(tpg);
+
+		for (pat = 0; pat < pat_lines; pat++) {
+			unsigned next_pat = (pat + 1) % pat_lines;
+
+			for (p = 1; p < tpg->planes; p++) {
+				unsigned twopixsize = tpg->twopixelsize[p];
+				unsigned hdiv = tpg->hdownsampling[p];
 
-				memcpy(pos, pix[p], twopixsize);
+				for (x = 0; x < tpg->scaled_width * 2; x += 2) {
+					unsigned offset = (x / hdiv) * twopixsize / 2;
+					u8 *pos1 = tpg->lines[pat][p] + offset;
+					u8 *pos2 = tpg->lines[next_pat][p] + offset;
+					u8 *dest = tpg->downsampled_lines[pat][p] + offset;
+					unsigned i;
+
+					for (i = 0; i < twopixsize / hdiv; i++, dest++, pos1++, pos2++)
+						*dest = ((u16)*pos1 + (u16)*pos2) / 2;
+				}
 			}
 		}
 	}
+
 	for (x = 0; x < tpg->scaled_width; x += 2) {
 		u8 pix[TPG_MAX_PLANES][8];
 
diff --git a/drivers/media/platform/vivid/vivid-tpg.h b/drivers/media/platform/vivid/vivid-tpg.h
index cec5bb4..5a53eb9 100644
--- a/drivers/media/platform/vivid/vivid-tpg.h
+++ b/drivers/media/platform/vivid/vivid-tpg.h
@@ -175,6 +175,7 @@ struct tpg_data {
 	/* Used to store TPG_MAX_PAT_LINES lines, each with up to two planes */
 	unsigned			max_line_width;
 	u8				*lines[TPG_MAX_PAT_LINES][TPG_MAX_PLANES];
+	u8				*downsampled_lines[TPG_MAX_PAT_LINES][TPG_MAX_PLANES];
 	u8				*random_line[TPG_MAX_PLANES];
 	u8				*contrast_line[TPG_MAX_PLANES];
 	u8				*black_line[TPG_MAX_PLANES];
-- 
2.1.4

