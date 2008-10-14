Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9ECmKnT028257
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 08:48:20 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.234])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9ECmAqa005783
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 08:48:10 -0400
Received: by rv-out-0506.google.com with SMTP id f6so2182462rvb.51
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 05:48:09 -0700 (PDT)
From: Magnus Damm <magnus.damm@gmail.com>
To: video4linux-list@redhat.com
Date: Tue, 14 Oct 2008 21:46:59 +0900
Message-Id: <20081014124659.5194.45071.sendpatchset@rx1.opensource.se>
In-Reply-To: <20081014124651.5194.93168.sendpatchset@rx1.opensource.se>
References: <20081014124651.5194.93168.sendpatchset@rx1.opensource.se>
Cc: v4l-dvb-maintainer@linuxtv.org, mchehab@infradead.org
Subject: [PATCH 01/05] video: Precalculate vivi yuv values
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

From: Magnus Damm <damm@igel.co.jp>

This patch improves the color space conversion code in vivi.c to 
directly draw with precalculated YUV values as palette instead of
drawing with YUV that is calculated from RGB for every two pixels.
This way we eliminate the need for 9 multiplications every two pixels.

A side effect of this patch is that the time counter is changed from
green text on black background to white text on black background.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 drivers/media/video/vivi.c |  117 +++++++++++++++++++++-----------------------
 1 file changed, 58 insertions(+), 59 deletions(-)

--- 0001/drivers/media/video/vivi.c
+++ work/drivers/media/video/vivi.c	2008-10-10 16:25:16.000000000 +0900
@@ -190,6 +190,7 @@ struct vivi_fh {
 	struct videobuf_queue      vb_vidq;
 
 	enum v4l2_buf_type         type;
+	unsigned char              bars[8][3];
 };
 
 /* ------------------------------------------------------------------
@@ -234,13 +235,41 @@ static u8 bars[8][3] = {
 #define TSTAMP_MAX_Y TSTAMP_MIN_Y+15
 #define TSTAMP_MIN_X 64
 
-static void gen_line(char *basep, int inipos, int wmax,
+static void gen_twopix(struct vivi_fh *fh, unsigned char *buf, int colorpos)
+{
+	unsigned char r_y, g_u, b_v;
+	unsigned char *p;
+	int color;
+
+	r_y = fh->bars[colorpos][0]; /* R or precalculated Y */
+	g_u = fh->bars[colorpos][1]; /* G or precalculated U */
+	b_v = fh->bars[colorpos][2]; /* B or precalculated V */
+
+	for (color = 0; color < 4; color++) {
+		p = buf + color;
+
+		switch (color) {
+		case 0:
+		case 2:
+			*p = r_y;
+			break;
+		case 1:
+			*p = g_u;
+			break;
+		case 3:
+			*p = b_v;
+			break;
+		}
+	}
+}
+
+static void gen_line(struct vivi_fh *fh, char *basep, int inipos, int wmax,
 		int hmax, int line, int count, char *timestr)
 {
-	int  w, i, j, y;
+	int  w, i, j;
 	int pos = inipos;
-	char *p, *s;
-	u8   chr, r, g, b, color;
+	char *s;
+	u8 chr;
 
 	/* We will just duplicate the second pixel at the packet */
 	wmax /= 2;
@@ -248,27 +277,9 @@ static void gen_line(char *basep, int in
 	/* Generate a standard color bar pattern */
 	for (w = 0; w < wmax; w++) {
 		int colorpos = ((w + count) * 8/(wmax + 1)) % 8;
-		r = bars[colorpos][0];
-		g = bars[colorpos][1];
-		b = bars[colorpos][2];
-
-		for (color = 0; color < 4; color++) {
-			p = basep + pos;
-
-			switch (color) {
-			case 0:
-			case 2:
-				*p = TO_Y(r, g, b);	/* Luma */
-				break;
-			case 1:
-				*p = TO_U(r, g, b);	/* Cb */
-				break;
-			case 3:
-				*p = TO_V(r, g, b);	/* Cr */
-				break;
-			}
-			pos++;
-		}
+
+		gen_twopix(fh, basep + pos, colorpos);
+		pos += 4; /* only 16 bpp supported for now */
 	}
 
 	/* Checks if it is possible to show timestamp */
@@ -283,38 +294,12 @@ static void gen_line(char *basep, int in
 		for (s = timestr; *s; s++) {
 			chr = rom8x16_bits[(*s-0x30)*16+line-TSTAMP_MIN_Y];
 			for (i = 0; i < 7; i++) {
-				if (chr & 1 << (7 - i)) {
-					/* Font color*/
-					r = 0;
-					g = 198;
-					b = 0;
-				} else {
-					/* Background color */
-					r = bars[BLACK][0];
-					g = bars[BLACK][1];
-					b = bars[BLACK][2];
-				}
-
 				pos = inipos + j * 2;
-				for (color = 0; color < 4; color++) {
-					p = basep + pos;
-
-					y = TO_Y(r, g, b);
-
-					switch (color) {
-					case 0:
-					case 2:
-						*p = TO_Y(r, g, b); /* Luma */
-						break;
-					case 1:
-						*p = TO_U(r, g, b); /* Cb */
-						break;
-					case 3:
-						*p = TO_V(r, g, b); /* Cr */
-						break;
-					}
-					pos++;
-				}
+				/* Draw white font on black background */
+				if (chr & 1 << (7 - i))
+					gen_twopix(fh, basep + pos, WHITE);
+				else
+					gen_twopix(fh, basep + pos, BLACK);
 				j++;
 			}
 		}
@@ -324,8 +309,9 @@ end:
 	return;
 }
 
-static void vivi_fillbuff(struct vivi_dev *dev, struct vivi_buffer *buf)
+static void vivi_fillbuff(struct vivi_fh *fh, struct vivi_buffer *buf)
 {
+	struct vivi_dev *dev = fh->dev;
 	int h , pos = 0;
 	int hmax  = buf->vb.height;
 	int wmax  = buf->vb.width;
@@ -341,7 +327,7 @@ static void vivi_fillbuff(struct vivi_de
 		return;
 
 	for (h = 0; h < hmax; h++) {
-		gen_line(tmpbuf, 0, wmax, hmax, h, dev->mv_count,
+		gen_line(fh, tmpbuf, 0, wmax, hmax, h, dev->mv_count,
 			 dev->timestr);
 		memcpy(vbuf + pos, tmpbuf, wmax * 2);
 		pos += wmax*2;
@@ -410,7 +396,7 @@ static void vivi_thread_tick(struct vivi
 	do_gettimeofday(&buf->vb.ts);
 
 	/* Fill buffer */
-	vivi_fillbuff(dev, buf);
+	vivi_fillbuff(fh, buf);
 	dprintk(dev, 1, "filled buffer %p\n", buf);
 
 	wake_up(&buf->vb.done);
@@ -714,6 +700,8 @@ static int vidioc_s_fmt_vid_cap(struct f
 {
 	struct vivi_fh  *fh = priv;
 	struct videobuf_queue *q = &fh->vb_vidq;
+	unsigned char r, g, b;
+	int k;
 
 	int ret = vidioc_try_fmt_vid_cap(file, fh, f);
 	if (ret < 0)
@@ -733,6 +721,17 @@ static int vidioc_s_fmt_vid_cap(struct f
 	fh->vb_vidq.field = f->fmt.pix.field;
 	fh->type          = f->type;
 
+	/* precalculate color bar values to speed up rendering */
+	for (k = 0; k < 8; k++) {
+		r = bars[k][0];
+		g = bars[k][1];
+		b = bars[k][2];
+
+		fh->bars[k][0] = TO_Y(r, g, b);	/* Luma */
+		fh->bars[k][1] = TO_U(r, g, b);	/* Cb */
+		fh->bars[k][2] = TO_V(r, g, b);	/* Cr */
+	}
+
 	ret = 0;
 out:
 	mutex_unlock(&q->vb_lock);

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
