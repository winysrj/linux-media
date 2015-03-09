Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:56623 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754020AbbCIPpy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 11:45:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 06/29] vivid: add new checkboard patterns
Date: Mon,  9 Mar 2015 16:44:28 +0100
Message-Id: <1425915891-1017-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
References: <1425915891-1017-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add a 2x2 checker patterns and 1x1 and 2x2 red/blue checker patterns.

Useful for testing 4:2:2 and 4:2:0 formats.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-tpg.c | 26 +++++++++++++++++++++++---
 drivers/media/platform/vivid/vivid-tpg.h |  3 +++
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index 8fa2150..e2af384 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -35,7 +35,10 @@ const char * const tpg_pattern_strings[] = {
 	"100% Green",
 	"100% Blue",
 	"16x16 Checkers",
+	"2x2 Checkers",
 	"1x1 Checkers",
+	"2x2 Red/Green Checkers",
+	"1x1 Red/Green Checkers",
 	"Alternating Hor Lines",
 	"Alternating Vert Lines",
 	"One Pixel Wide Cross",
@@ -744,11 +747,14 @@ static void gen_twopix(struct tpg_data *tpg,
 }
 
 /* Return how many pattern lines are used by the current pattern. */
-static unsigned tpg_get_pat_lines(struct tpg_data *tpg)
+static unsigned tpg_get_pat_lines(const struct tpg_data *tpg)
 {
 	switch (tpg->pattern) {
 	case TPG_PAT_CHECKERS_16X16:
+	case TPG_PAT_CHECKERS_2X2:
 	case TPG_PAT_CHECKERS_1X1:
+	case TPG_PAT_COLOR_CHECKERS_2X2:
+	case TPG_PAT_COLOR_CHECKERS_1X1:
 	case TPG_PAT_ALTERNATING_HLINES:
 	case TPG_PAT_CROSS_1_PIXEL:
 	case TPG_PAT_CROSS_2_PIXELS:
@@ -763,14 +769,18 @@ static unsigned tpg_get_pat_lines(struct tpg_data *tpg)
 }
 
 /* Which pattern line should be used for the given frame line. */
-static unsigned tpg_get_pat_line(struct tpg_data *tpg, unsigned line)
+static unsigned tpg_get_pat_line(const struct tpg_data *tpg, unsigned line)
 {
 	switch (tpg->pattern) {
 	case TPG_PAT_CHECKERS_16X16:
 		return (line >> 4) & 1;
 	case TPG_PAT_CHECKERS_1X1:
+	case TPG_PAT_COLOR_CHECKERS_1X1:
 	case TPG_PAT_ALTERNATING_HLINES:
 		return line & 1;
+	case TPG_PAT_CHECKERS_2X2:
+	case TPG_PAT_COLOR_CHECKERS_2X2:
+		return (line & 2) >> 1;
 	case TPG_PAT_100_COLORSQUARES:
 	case TPG_PAT_100_HCOLORBAR:
 		return (line * 8) / tpg->src_height;
@@ -789,7 +799,8 @@ static unsigned tpg_get_pat_line(struct tpg_data *tpg, unsigned line)
  * Which color should be used for the given pattern line and X coordinate.
  * Note: x is in the range 0 to 2 * tpg->src_width.
  */
-static enum tpg_color tpg_get_color(struct tpg_data *tpg, unsigned pat_line, unsigned x)
+static enum tpg_color tpg_get_color(const struct tpg_data *tpg,
+				    unsigned pat_line, unsigned x)
 {
 	/* Maximum number of bars are TPG_COLOR_MAX - otherwise, the input print code
 	   should be modified */
@@ -836,6 +847,15 @@ static enum tpg_color tpg_get_color(struct tpg_data *tpg, unsigned pat_line, uns
 	case TPG_PAT_CHECKERS_1X1:
 		return ((x & 1) ^ (pat_line & 1)) ?
 			TPG_COLOR_100_WHITE : TPG_COLOR_100_BLACK;
+	case TPG_PAT_COLOR_CHECKERS_1X1:
+		return ((x & 1) ^ (pat_line & 1)) ?
+			TPG_COLOR_100_RED : TPG_COLOR_100_BLUE;
+	case TPG_PAT_CHECKERS_2X2:
+		return (((x >> 1) & 1) ^ (pat_line & 1)) ?
+			TPG_COLOR_100_WHITE : TPG_COLOR_100_BLACK;
+	case TPG_PAT_COLOR_CHECKERS_2X2:
+		return (((x >> 1) & 1) ^ (pat_line & 1)) ?
+			TPG_COLOR_100_RED : TPG_COLOR_100_BLUE;
 	case TPG_PAT_ALTERNATING_HLINES:
 		return pat_line ? TPG_COLOR_100_WHITE : TPG_COLOR_100_BLACK;
 	case TPG_PAT_ALTERNATING_VLINES:
diff --git a/drivers/media/platform/vivid/vivid-tpg.h b/drivers/media/platform/vivid/vivid-tpg.h
index 8100425..e796a54 100644
--- a/drivers/media/platform/vivid/vivid-tpg.h
+++ b/drivers/media/platform/vivid/vivid-tpg.h
@@ -41,7 +41,10 @@ enum tpg_pattern {
 	TPG_PAT_GREEN,
 	TPG_PAT_BLUE,
 	TPG_PAT_CHECKERS_16X16,
+	TPG_PAT_CHECKERS_2X2,
 	TPG_PAT_CHECKERS_1X1,
+	TPG_PAT_COLOR_CHECKERS_2X2,
+	TPG_PAT_COLOR_CHECKERS_1X1,
 	TPG_PAT_ALTERNATING_HLINES,
 	TPG_PAT_ALTERNATING_VLINES,
 	TPG_PAT_CROSS_1_PIXEL,
-- 
2.1.4

