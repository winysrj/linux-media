Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:45796 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754503AbbFEQJn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Jun 2015 12:09:43 -0400
Message-ID: <5571C9BB.60608@xs4all.nl>
Date: Fri, 05 Jun 2015 18:09:31 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH] vivid: move PRINTSTR to separate functions
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 84cb7be43cec12868e94163c99fdc34c0297c3b8 broke vivid-tpg (uninitialized variable p).

This patch takes a different approach: four different functions are created, one for
each PRINTSTR version.

In order to avoid the 'the frame size of 1308 bytes is larger than 1024 bytes' warning I
had to mark those functions with 'noinline'. For whatever reason gcc seems to inline this
aggressively and it is doing weird things with the stack.

I tried to read the assembly code, but I couldn't see what exactly it was doing on the stack.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/platform/vivid/vivid-tpg.c b/drivers/media/platform/vivid/vivid-tpg.c
index c86c8ff..32ebf0d 100644
--- a/drivers/media/platform/vivid/vivid-tpg.c
+++ b/drivers/media/platform/vivid/vivid-tpg.c
@@ -1462,40 +1462,10 @@ static void tpg_precalculate_line(struct tpg_data *tpg)
 /* need this to do rgb24 rendering */
 typedef struct { u16 __; u8 _; } __packed x24;
 
-void tpg_gen_text(const struct tpg_data *tpg, u8 *basep[TPG_MAX_PLANES][2],
-		  int y, int x, char *text)
-{
-	int line;
-	unsigned step = V4L2_FIELD_HAS_T_OR_B(tpg->field) ? 2 : 1;
-	unsigned div = step;
-	unsigned first = 0;
-	unsigned len = strlen(text);
-	unsigned p;
-
-	if (font8x16 == NULL || basep == NULL)
-		return;
-
-	/* Checks if it is possible to show string */
-	if (y + 16 >= tpg->compose.height || x + 8 >= tpg->compose.width)
-		return;
-
-	if (len > (tpg->compose.width - x) / 8)
-		len = (tpg->compose.width - x) / 8;
-	if (tpg->vflip)
-		y = tpg->compose.height - y - 16;
-	if (tpg->hflip)
-		x = tpg->compose.width - x - 8;
-	y += tpg->compose.top;
-	x += tpg->compose.left;
-	if (tpg->field == V4L2_FIELD_BOTTOM)
-		first = 1;
-	else if (tpg->field == V4L2_FIELD_SEQ_TB || tpg->field == V4L2_FIELD_SEQ_BT)
-		div = 2;
-
-	/* Print text */
-#define PRINTSTR(PIXTYPE) for (p = 0; p < tpg->planes; p++) {	\
-	unsigned vdiv = tpg->vdownsampling[p];	\
-	unsigned hdiv = tpg->hdownsampling[p];	\
+#define PRINTSTR(PIXTYPE) do {	\
+	unsigned vdiv = tpg->vdownsampling[p]; \
+	unsigned hdiv = tpg->hdownsampling[p]; \
+	int line;	\
 	PIXTYPE fg;	\
 	PIXTYPE bg;	\
 	memcpy(&fg, tpg->textfg[p], sizeof(PIXTYPE));	\
@@ -1546,19 +1516,83 @@ void tpg_gen_text(const struct tpg_data *tpg, u8 *basep[TPG_MAX_PLANES][2],
 	}	\
 } while (0)
 
-	switch (tpg->twopixelsize[p]) {
-	case 2:
-		PRINTSTR(u8);
-		break;
-	case 4:
-		PRINTSTR(u16);
-		break;
-	case 6:
-		PRINTSTR(x24);
-		break;
-	case 8:
-		PRINTSTR(u32);
-		break;
+static noinline void tpg_print_str_2(const struct tpg_data *tpg, u8 *basep[TPG_MAX_PLANES][2],
+			unsigned p, unsigned first, unsigned div, unsigned step,
+			int y, int x, char *text, unsigned len)
+{
+	PRINTSTR(u8);
+}
+
+static noinline void tpg_print_str_4(const struct tpg_data *tpg, u8 *basep[TPG_MAX_PLANES][2],
+			unsigned p, unsigned first, unsigned div, unsigned step,
+			int y, int x, char *text, unsigned len)
+{
+	PRINTSTR(u16);
+}
+
+static noinline void tpg_print_str_6(const struct tpg_data *tpg, u8 *basep[TPG_MAX_PLANES][2],
+			unsigned p, unsigned first, unsigned div, unsigned step,
+			int y, int x, char *text, unsigned len)
+{
+	PRINTSTR(x24);
+}
+
+static noinline void tpg_print_str_8(const struct tpg_data *tpg, u8 *basep[TPG_MAX_PLANES][2],
+			unsigned p, unsigned first, unsigned div, unsigned step,
+			int y, int x, char *text, unsigned len)
+{
+	PRINTSTR(u32);
+}
+
+void tpg_gen_text(const struct tpg_data *tpg, u8 *basep[TPG_MAX_PLANES][2],
+		  int y, int x, char *text)
+{
+	unsigned step = V4L2_FIELD_HAS_T_OR_B(tpg->field) ? 2 : 1;
+	unsigned div = step;
+	unsigned first = 0;
+	unsigned len = strlen(text);
+	unsigned p;
+
+	if (font8x16 == NULL || basep == NULL)
+		return;
+
+	/* Checks if it is possible to show string */
+	if (y + 16 >= tpg->compose.height || x + 8 >= tpg->compose.width)
+		return;
+
+	if (len > (tpg->compose.width - x) / 8)
+		len = (tpg->compose.width - x) / 8;
+	if (tpg->vflip)
+		y = tpg->compose.height - y - 16;
+	if (tpg->hflip)
+		x = tpg->compose.width - x - 8;
+	y += tpg->compose.top;
+	x += tpg->compose.left;
+	if (tpg->field == V4L2_FIELD_BOTTOM)
+		first = 1;
+	else if (tpg->field == V4L2_FIELD_SEQ_TB || tpg->field == V4L2_FIELD_SEQ_BT)
+		div = 2;
+
+	for (p = 0; p < tpg->planes; p++) {
+		/* Print text */
+		switch (tpg->twopixelsize[p]) {
+		case 2:
+			tpg_print_str_2(tpg, basep, p, first, div, step, y, x,
+					text, len);
+			break;
+		case 4:
+			tpg_print_str_4(tpg, basep, p, first, div, step, y, x,
+					text, len);
+			break;
+		case 6:
+			tpg_print_str_6(tpg, basep, p, first, div, step, y, x,
+					text, len);
+			break;
+		case 8:
+			tpg_print_str_8(tpg, basep, p, first, div, step, y, x,
+					text, len);
+			break;
+		}
 	}
 }
 
