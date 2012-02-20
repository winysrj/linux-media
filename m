Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43246 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab2BTTmk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Feb 2012 14:42:40 -0500
Received: by bkcjm19 with SMTP id jm19so4818640bkc.19
        for <linux-media@vger.kernel.org>; Mon, 20 Feb 2012 11:42:38 -0800 (PST)
Message-ID: <4F42A22D.4010704@uni-bielefeld.de>
Date: Mon, 20 Feb 2012 20:42:37 +0100
From: Robert Abel <abel@uni-bielefeld.de>
Reply-To: abel@uni-bielefeld.de
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Gregor Jasny <gjasny@googlemail.com>
Subject: Re: [PATCH][libv4l] Bytes per Line (was: [libv4l] Bytes per Line)
References: <4F3BD50A.3010608@uni-bielefeld.de> <4F3C31F9.8070000@googlemail.com>
In-Reply-To: <4F3C31F9.8070000@googlemail.com>
Content-Type: multipart/mixed;
 boundary="------------090008090609090202090708"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090008090609090202090708
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Gregor,

On 15.02.2012 23:30, Gregor Jasny wrote:
> As far as I understand the V4L2 spec the bytesperline != width is no
> optional feature. If post your patches here I'll review them and add
> them to the development tree.
I understand the spec in the same way. I just thought it might have been
an agreed-on optimization for speed or something.

Anyway, the patch for bayer => rgb as well as bayer => yuv is attached.
Basically, every time where width was assumed to be the offset to the
neighboring pixel below, now step is used.

Regards,

Robert

--------------090008090609090202090708
Content-Type: text/plain;
 name="0001-fix_bayer_stepsize.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-fix_bayer_stepsize.patch"

diff -Naur a/lib/libv4lconvert/bayer.c b/lib/libv4lconvert/bayer.c
--- a/lib/libv4lconvert/bayer.c	2012-02-15 11:03:46.792279638 +0100
+++ b/lib/libv4lconvert/bayer.c	2012-02-20 20:17:36.741026768 +0100
@@ -44,7 +44,7 @@
 /* inspired by OpenCV's Bayer decoding */
 static void v4lconvert_border_bayer_line_to_bgr24(
 		const unsigned char *bayer, const unsigned char *adjacent_bayer,
-		unsigned char *bgr, int width, int start_with_green, int blue_line)
+		unsigned char *bgr, int width, const int start_with_green, const int blue_line)
 {
 	int t0, t1;
 
@@ -164,11 +164,11 @@
 
 /* From libdc1394, which on turn was based on OpenCV's Bayer decoding */
 static void bayer_to_rgbbgr24(const unsigned char *bayer,
-		unsigned char *bgr, int width, int height, unsigned int pixfmt,
+		unsigned char *bgr, int width, int height, const unsigned int step, unsigned int pixfmt,
 		int start_with_green, int blue_line)
 {
 	/* render the first line */
-	v4lconvert_border_bayer_line_to_bgr24(bayer, bayer + width, bgr, width,
+	v4lconvert_border_bayer_line_to_bgr24(bayer, bayer + step, bgr, width,
 			start_with_green, blue_line);
 	bgr += width * 3;
 
@@ -179,139 +179,141 @@
 		const unsigned char *bayer_end = bayer + (width - 2);
 
 		if (start_with_green) {
-			/* OpenCV has a bug in the next line, which was
-			   t0 = (bayer[0] + bayer[width * 2] + 1) >> 1; */
-			t0 = (bayer[1] + bayer[width * 2 + 1] + 1) >> 1;
+
+			t0 = (bayer[1] + bayer[step * 2 + 1] + 1) >> 1;
 			/* Write first pixel */
-			t1 = (bayer[0] + bayer[width * 2] + bayer[width + 1] + 1) / 3;
+			t1 = (bayer[0] + bayer[step * 2] + bayer[step + 1] + 1) / 3;
 			if (blue_line) {
 				*bgr++ = t0;
 				*bgr++ = t1;
-				*bgr++ = bayer[width];
+				*bgr++ = bayer[step];
 			} else {
-				*bgr++ = bayer[width];
+				*bgr++ = bayer[step];
 				*bgr++ = t1;
 				*bgr++ = t0;
 			}
 
 			/* Write second pixel */
-			t1 = (bayer[width] + bayer[width + 2] + 1) >> 1;
+			t1 = (bayer[step] + bayer[step + 2] + 1) >> 1;
 			if (blue_line) {
 				*bgr++ = t0;
-				*bgr++ = bayer[width + 1];
+				*bgr++ = bayer[step + 1];
 				*bgr++ = t1;
 			} else {
 				*bgr++ = t1;
-				*bgr++ = bayer[width + 1];
+				*bgr++ = bayer[step + 1];
 				*bgr++ = t0;
 			}
 			bayer++;
 		} else {
 			/* Write first pixel */
-			t0 = (bayer[0] + bayer[width * 2] + 1) >> 1;
+			t0 = (bayer[0] + bayer[step * 2] + 1) >> 1;
 			if (blue_line) {
 				*bgr++ = t0;
-				*bgr++ = bayer[width];
-				*bgr++ = bayer[width + 1];
+				*bgr++ = bayer[step];
+				*bgr++ = bayer[step + 1];
 			} else {
-				*bgr++ = bayer[width + 1];
-				*bgr++ = bayer[width];
+				*bgr++ = bayer[step + 1];
+				*bgr++ = bayer[step];
 				*bgr++ = t0;
 			}
 		}
 
 		if (blue_line) {
 			for (; bayer <= bayer_end - 2; bayer += 2) {
-				t0 = (bayer[0] + bayer[2] + bayer[width * 2] +
-					bayer[width * 2 + 2] + 2) >> 2;
-				t1 = (bayer[1] + bayer[width] + bayer[width + 2] +
-					bayer[width * 2 + 1] + 2) >> 2;
+				t0 = (bayer[0] + bayer[2] + bayer[step * 2] +
+					bayer[step * 2 + 2] + 2) >> 2;
+				t1 = (bayer[1] + bayer[step] + bayer[step + 2] +
+					bayer[step * 2 + 1] + 2) >> 2;
 				*bgr++ = t0;
 				*bgr++ = t1;
-				*bgr++ = bayer[width + 1];
+				*bgr++ = bayer[step + 1];
 
-				t0 = (bayer[2] + bayer[width * 2 + 2] + 1) >> 1;
-				t1 = (bayer[width + 1] + bayer[width + 3] + 1) >> 1;
+				t0 = (bayer[2] + bayer[step * 2 + 2] + 1) >> 1;
+				t1 = (bayer[step + 1] + bayer[step + 3] + 1) >> 1;
 				*bgr++ = t0;
-				*bgr++ = bayer[width + 2];
+				*bgr++ = bayer[step + 2];
 				*bgr++ = t1;
 			}
 		} else {
 			for (; bayer <= bayer_end - 2; bayer += 2) {
-				t0 = (bayer[0] + bayer[2] + bayer[width * 2] +
-					bayer[width * 2 + 2] + 2) >> 2;
-				t1 = (bayer[1] + bayer[width] + bayer[width + 2] +
-					bayer[width * 2 + 1] + 2) >> 2;
-				*bgr++ = bayer[width + 1];
+				t0 = (bayer[0] + bayer[2] + bayer[step * 2] +
+					bayer[step * 2 + 2] + 2) >> 2;
+				t1 = (bayer[1] + bayer[step] + bayer[step + 2] +
+					bayer[step * 2 + 1] + 2) >> 2;
+				*bgr++ = bayer[step + 1];
 				*bgr++ = t1;
 				*bgr++ = t0;
 
-				t0 = (bayer[2] + bayer[width * 2 + 2] + 1) >> 1;
-				t1 = (bayer[width + 1] + bayer[width + 3] + 1) >> 1;
+				t0 = (bayer[2] + bayer[step * 2 + 2] + 1) >> 1;
+				t1 = (bayer[step + 1] + bayer[step + 3] + 1) >> 1;
 				*bgr++ = t1;
-				*bgr++ = bayer[width + 2];
+				*bgr++ = bayer[step + 2];
 				*bgr++ = t0;
 			}
 		}
 
 		if (bayer < bayer_end) {
 			/* write second to last pixel */
-			t0 = (bayer[0] + bayer[2] + bayer[width * 2] +
-				bayer[width * 2 + 2] + 2) >> 2;
-			t1 = (bayer[1] + bayer[width] + bayer[width + 2] +
-				bayer[width * 2 + 1] + 2) >> 2;
+			t0 = (bayer[0] + bayer[2] + bayer[step * 2] +
+				bayer[step * 2 + 2] + 2) >> 2;
+			t1 = (bayer[1] + bayer[step] + bayer[step + 2] +
+				bayer[step * 2 + 1] + 2) >> 2;
 			if (blue_line) {
 				*bgr++ = t0;
 				*bgr++ = t1;
-				*bgr++ = bayer[width + 1];
+				*bgr++ = bayer[step + 1];
 			} else {
-				*bgr++ = bayer[width + 1];
+				*bgr++ = bayer[step + 1];
 				*bgr++ = t1;
 				*bgr++ = t0;
 			}
 			/* write last pixel */
-			t0 = (bayer[2] + bayer[width * 2 + 2] + 1) >> 1;
+			t0 = (bayer[2] + bayer[step * 2 + 2] + 1) >> 1;
 			if (blue_line) {
 				*bgr++ = t0;
-				*bgr++ = bayer[width + 2];
-				*bgr++ = bayer[width + 1];
+				*bgr++ = bayer[step + 2];
+				*bgr++ = bayer[step + 1];
 			} else {
-				*bgr++ = bayer[width + 1];
-				*bgr++ = bayer[width + 2];
+				*bgr++ = bayer[step + 1];
+				*bgr++ = bayer[step + 2];
 				*bgr++ = t0;
 			}
+
 			bayer++;
+
 		} else {
 			/* write last pixel */
-			t0 = (bayer[0] + bayer[width * 2] + 1) >> 1;
-			t1 = (bayer[1] + bayer[width * 2 + 1] + bayer[width] + 1) / 3;
+			t0 = (bayer[0] + bayer[step * 2] + 1) >> 1;
+			t1 = (bayer[1] + bayer[step * 2 + 1] + bayer[step] + 1) / 3;
 			if (blue_line) {
 				*bgr++ = t0;
 				*bgr++ = t1;
-				*bgr++ = bayer[width + 1];
+				*bgr++ = bayer[step + 1];
 			} else {
-				*bgr++ = bayer[width + 1];
+				*bgr++ = bayer[step + 1];
 				*bgr++ = t1;
 				*bgr++ = t0;
 			}
+
 		}
 
-		/* skip 2 border pixels */
-		bayer += 2;
+		/* skip 2 border pixels and padding */
+		bayer += (step - width) + 2;
 
 		blue_line = !blue_line;
 		start_with_green = !start_with_green;
 	}
 
 	/* render the last line */
-	v4lconvert_border_bayer_line_to_bgr24(bayer + width, bayer, bgr, width,
+	v4lconvert_border_bayer_line_to_bgr24(bayer + step, bayer, bgr, width,
 			!start_with_green, !blue_line);
 }
 
 void v4lconvert_bayer_to_rgb24(const unsigned char *bayer,
-		unsigned char *bgr, int width, int height, unsigned int pixfmt)
+		unsigned char *bgr, int width, int height, const unsigned int step, unsigned int pixfmt)
 {
-	bayer_to_rgbbgr24(bayer, bgr, width, height, pixfmt,
+	bayer_to_rgbbgr24(bayer, bgr, width, height, step, pixfmt,
 			pixfmt == V4L2_PIX_FMT_SGBRG8		/* start with green */
 			|| pixfmt == V4L2_PIX_FMT_SGRBG8,
 			pixfmt != V4L2_PIX_FMT_SBGGR8		/* blue line */
@@ -319,9 +321,9 @@
 }
 
 void v4lconvert_bayer_to_bgr24(const unsigned char *bayer,
-		unsigned char *bgr, int width, int height, unsigned int pixfmt)
+		unsigned char *bgr, int width, int height, const unsigned int step, unsigned int pixfmt)
 {
-	bayer_to_rgbbgr24(bayer, bgr, width, height, pixfmt,
+	bayer_to_rgbbgr24(bayer, bgr, width, height, step, pixfmt,
 			pixfmt == V4L2_PIX_FMT_SGBRG8		/* start with green */
 			|| pixfmt == V4L2_PIX_FMT_SGRBG8,
 			pixfmt == V4L2_PIX_FMT_SBGGR8		/* blue line */
@@ -428,7 +430,7 @@
 }
 
 void v4lconvert_bayer_to_yuv420(const unsigned char *bayer, unsigned char *yuv,
-		int width, int height, unsigned int src_pixfmt, int yvu)
+		int width, int height, const unsigned int step, unsigned int src_pixfmt, int yvu)
 {
 	int blue_line = 0, start_with_green = 0, x, y;
 	unsigned char *ydst = yuv;
@@ -451,12 +453,12 @@
 
 				b  = bayer[x];
 				g  = bayer[x + 1];
-				g += bayer[x + width];
-				r  = bayer[x + width + 1];
+				g += bayer[x + step];
+				r  = bayer[x + step + 1];
 				*udst++ = (-4878 * r - 4789 * g + 14456 * b + 4210688) >> 15;
 				*vdst++ = (14456 * r - 6052 * g -  2351 * b + 4210688) >> 15;
 			}
-			bayer += 2 * width;
+			bayer += 2 * step;
 		}
 		blue_line = 1;
 		break;
@@ -468,12 +470,12 @@
 
 				r  = bayer[x];
 				g  = bayer[x + 1];
-				g += bayer[x + width];
-				b  = bayer[x + width + 1];
+				g += bayer[x + step];
+				b  = bayer[x + step + 1];
 				*udst++ = (-4878 * r - 4789 * g + 14456 * b + 4210688) >> 15;
 				*vdst++ = (14456 * r - 6052 * g -  2351 * b + 4210688) >> 15;
 			}
-			bayer += 2 * width;
+			bayer += 2 * step;
 		}
 		break;
 
@@ -484,12 +486,12 @@
 
 				g  = bayer[x];
 				b  = bayer[x + 1];
-				r  = bayer[x + width];
-				g += bayer[x + width + 1];
+				r  = bayer[x + step];
+				g += bayer[x + step + 1];
 				*udst++ = (-4878 * r - 4789 * g + 14456 * b + 4210688) >> 15;
 				*vdst++ = (14456 * r - 6052 * g -  2351 * b + 4210688) >> 15;
 			}
-			bayer += 2 * width;
+			bayer += 2 * step;
 		}
 		blue_line = 1;
 		start_with_green = 1;
@@ -502,21 +504,22 @@
 
 				g  = bayer[x];
 				r  = bayer[x + 1];
-				b  = bayer[x + width];
-				g += bayer[x + width + 1];
+				b  = bayer[x + step];
+				g += bayer[x + step + 1];
 				*udst++ = (-4878 * r - 4789 * g + 14456 * b + 4210688) >> 15;
 				*vdst++ = (14456 * r - 6052 * g -  2351 * b + 4210688) >> 15;
 			}
-			bayer += 2 * width;
+			bayer += 2 * step;
 		}
 		start_with_green = 1;
 		break;
 	}
 
-	bayer -= width * height;
+	/* Point bayer back to start of frame */
+	bayer -= step * height;
 
 	/* render the first line */
-	v4lconvert_border_bayer_line_to_y(bayer, bayer + width, ydst, width,
+	v4lconvert_border_bayer_line_to_y(bayer, bayer + step, ydst, width,
 			start_with_green, blue_line);
 	ydst += width;
 
@@ -527,104 +530,104 @@
 		const unsigned char *bayer_end = bayer + (width - 2);
 
 		if (start_with_green) {
-			t0 = bayer[1] + bayer[width * 2 + 1];
+			t0 = bayer[1] + bayer[step * 2 + 1];
 			/* Write first pixel */
-			t1 = bayer[0] + bayer[width * 2] + bayer[width + 1];
+			t1 = bayer[0] + bayer[step * 2] + bayer[step + 1];
 			if (blue_line)
-				*ydst++ = (8453 * bayer[width] + 5516 * t1 +
+				*ydst++ = (8453 * bayer[step] + 5516 * t1 +
 						1661 * t0 + 524288) >> 15;
 			else
 				*ydst++ = (4226 * t0 + 5516 * t1 +
-						3223 * bayer[width] + 524288) >> 15;
+						3223 * bayer[step] + 524288) >> 15;
 
 			/* Write second pixel */
-			t1 = bayer[width] + bayer[width + 2];
+			t1 = bayer[step] + bayer[step + 2];
 			if (blue_line)
-				*ydst++ = (4226 * t1 + 16594 * bayer[width + 1] +
+				*ydst++ = (4226 * t1 + 16594 * bayer[step + 1] +
 						1611 * t0 + 524288) >> 15;
 			else
-				*ydst++ = (4226 * t0 + 16594 * bayer[width + 1] +
+				*ydst++ = (4226 * t0 + 16594 * bayer[step + 1] +
 						1611 * t1 + 524288) >> 15;
 			bayer++;
 		} else {
 			/* Write first pixel */
-			t0 = bayer[0] + bayer[width * 2];
+			t0 = bayer[0] + bayer[step * 2];
 			if (blue_line) {
-				*ydst++ = (8453 * bayer[width + 1] + 16594 * bayer[width] +
+				*ydst++ = (8453 * bayer[step + 1] + 16594 * bayer[step] +
 						1661 * t0 + 524288) >> 15;
 			} else {
-				*ydst++ = (4226 * t0 + 16594 * bayer[width] +
-						3223 * bayer[width + 1] + 524288) >> 15;
+				*ydst++ = (4226 * t0 + 16594 * bayer[step] +
+						3223 * bayer[step + 1] + 524288) >> 15;
 			}
 		}
 
 		if (blue_line) {
 			for (; bayer <= bayer_end - 2; bayer += 2) {
-				t0 = bayer[0] + bayer[2] + bayer[width * 2] + bayer[width * 2 + 2];
-				t1 = bayer[1] + bayer[width] + bayer[width + 2] + bayer[width * 2 + 1];
-				*ydst++ = (8453 * bayer[width + 1] + 4148 * t1 +
+				t0 = bayer[0] + bayer[2] + bayer[step * 2] + bayer[step * 2 + 2];
+				t1 = bayer[1] + bayer[step] + bayer[step + 2] + bayer[step * 2 + 1];
+				*ydst++ = (8453 * bayer[step + 1] + 4148 * t1 +
 						806 * t0 + 524288) >> 15;
 
-				t0 = bayer[2] + bayer[width * 2 + 2];
-				t1 = bayer[width + 1] + bayer[width + 3];
-				*ydst++ = (4226 * t1 + 16594 * bayer[width + 2] +
+				t0 = bayer[2] + bayer[step * 2 + 2];
+				t1 = bayer[step + 1] + bayer[step + 3];
+				*ydst++ = (4226 * t1 + 16594 * bayer[step + 2] +
 						1611 * t0 + 524288) >> 15;
 			}
 		} else {
 			for (; bayer <= bayer_end - 2; bayer += 2) {
-				t0 = bayer[0] + bayer[2] + bayer[width * 2] + bayer[width * 2 + 2];
-				t1 = bayer[1] + bayer[width] + bayer[width + 2] + bayer[width * 2 + 1];
+				t0 = bayer[0] + bayer[2] + bayer[step * 2] + bayer[step * 2 + 2];
+				t1 = bayer[1] + bayer[step] + bayer[step + 2] + bayer[step * 2 + 1];
 				*ydst++ = (2113 * t0 + 4148 * t1 +
-						3223 * bayer[width + 1] + 524288) >> 15;
+						3223 * bayer[step + 1] + 524288) >> 15;
 
-				t0 = bayer[2] + bayer[width * 2 + 2];
-				t1 = bayer[width + 1] + bayer[width + 3];
-				*ydst++ = (4226 * t0 + 16594 * bayer[width + 2] +
+				t0 = bayer[2] + bayer[step * 2 + 2];
+				t1 = bayer[step + 1] + bayer[step + 3];
+				*ydst++ = (4226 * t0 + 16594 * bayer[step + 2] +
 						1611 * t1 + 524288) >> 15;
 			}
 		}
 
 		if (bayer < bayer_end) {
 			/* Write second to last pixel */
-			t0 = bayer[0] + bayer[2] + bayer[width * 2] + bayer[width * 2 + 2];
-			t1 = bayer[1] + bayer[width] + bayer[width + 2] + bayer[width * 2 + 1];
+			t0 = bayer[0] + bayer[2] + bayer[step * 2] + bayer[step * 2 + 2];
+			t1 = bayer[1] + bayer[step] + bayer[step + 2] + bayer[step * 2 + 1];
 			if (blue_line)
-				*ydst++ = (8453 * bayer[width + 1] + 4148 * t1 +
+				*ydst++ = (8453 * bayer[step + 1] + 4148 * t1 +
 						806 * t0 + 524288) >> 15;
 			else
 				*ydst++ = (2113 * t0 + 4148 * t1 +
-						3223 * bayer[width + 1] + 524288) >> 15;
+						3223 * bayer[step + 1] + 524288) >> 15;
 
 			/* write last pixel */
-			t0 = bayer[2] + bayer[width * 2 + 2];
+			t0 = bayer[2] + bayer[step * 2 + 2];
 			if (blue_line) {
-				*ydst++ = (8453 * bayer[width + 1] + 16594 * bayer[width + 2] +
+				*ydst++ = (8453 * bayer[step + 1] + 16594 * bayer[step + 2] +
 						1661 * t0 + 524288) >> 15;
 			} else {
-				*ydst++ = (4226 * t0 + 16594 * bayer[width + 2] +
-						3223 * bayer[width + 1] + 524288) >> 15;
+				*ydst++ = (4226 * t0 + 16594 * bayer[step + 2] +
+						3223 * bayer[step + 1] + 524288) >> 15;
 			}
 			bayer++;
 		} else {
 			/* write last pixel */
-			t0 = bayer[0] + bayer[width * 2];
-			t1 = bayer[1] + bayer[width * 2 + 1] + bayer[width];
+			t0 = bayer[0] + bayer[step * 2];
+			t1 = bayer[1] + bayer[step * 2 + 1] + bayer[step];
 			if (blue_line)
-				*ydst++ = (8453 * bayer[width + 1] + 5516 * t1 +
+				*ydst++ = (8453 * bayer[step + 1] + 5516 * t1 +
 						1661 * t0 + 524288) >> 15;
 			else
 				*ydst++ = (4226 * t0 + 5516 * t1 +
-						3223 * bayer[width + 1] + 524288) >> 15;
+						3223 * bayer[step + 1] + 524288) >> 15;
 		}
 
-		/* skip 2 border pixels */
-		bayer += 2;
+		/* skip 2 border pixels and padding */
+		bayer += (step - width) + 2;
 
 		blue_line = !blue_line;
 		start_with_green = !start_with_green;
 	}
 
 	/* render the last line */
-	v4lconvert_border_bayer_line_to_y(bayer + width, bayer, ydst, width,
+	v4lconvert_border_bayer_line_to_y(bayer + step, bayer, ydst, width,
 			!start_with_green, !blue_line);
 }
diff -Naur a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lconvert.c
--- a/lib/libv4lconvert/libv4lconvert.c	2012-02-15 11:03:46.792279638 +0100
+++ b/lib/libv4lconvert/libv4lconvert.c	2012-02-16 11:41:45.301387267 +0100
@@ -629,6 +629,7 @@
 	unsigned int src_pix_fmt = fmt->fmt.pix.pixelformat;
 	unsigned int width  = fmt->fmt.pix.width;
 	unsigned int height = fmt->fmt.pix.height;
+	unsigned int bytesperline = fmt->fmt.pix.bytesperline;
 
 	switch (src_pix_fmt) {
 	/* JPG and variants */
@@ -858,16 +859,16 @@
 	case V4L2_PIX_FMT_SRGGB8:
 		switch (dest_pix_fmt) {
 		case V4L2_PIX_FMT_RGB24:
-			v4lconvert_bayer_to_rgb24(src, dest, width, height, src_pix_fmt);
+			v4lconvert_bayer_to_rgb24(src, dest, width, height, bytesperline, src_pix_fmt);
 			break;
 		case V4L2_PIX_FMT_BGR24:
-			v4lconvert_bayer_to_bgr24(src, dest, width, height, src_pix_fmt);
+			v4lconvert_bayer_to_bgr24(src, dest, width, height, bytesperline, src_pix_fmt);
 			break;
 		case V4L2_PIX_FMT_YUV420:
-			v4lconvert_bayer_to_yuv420(src, dest, width, height, src_pix_fmt, 0);
+			v4lconvert_bayer_to_yuv420(src, dest, width, height, bytesperline, src_pix_fmt, 0);
 			break;
 		case V4L2_PIX_FMT_YVU420:
-			v4lconvert_bayer_to_yuv420(src, dest, width, height, src_pix_fmt, 1);
+			v4lconvert_bayer_to_yuv420(src, dest, width, height, bytesperline, src_pix_fmt, 1);
 			break;
 		}
 		if (src_size < (width * height)) {
diff -Naur a/lib/libv4lconvert/libv4lconvert-priv.h b/lib/libv4lconvert/libv4lconvert-priv.h
--- a/lib/libv4lconvert/libv4lconvert-priv.h	2012-02-15 11:03:46.792279638 +0100
+++ b/lib/libv4lconvert/libv4lconvert-priv.h	2012-02-16 11:42:50.081054833 +0100
@@ -230,13 +230,13 @@
 		int width, int height);
 
 void v4lconvert_bayer_to_rgb24(const unsigned char *bayer,
-		unsigned char *rgb, int width, int height, unsigned int pixfmt);
+		unsigned char *rgb, int width, int height, const unsigned int step, unsigned int pixfmt);
 
 void v4lconvert_bayer_to_bgr24(const unsigned char *bayer,
-		unsigned char *rgb, int width, int height, unsigned int pixfmt);
+		unsigned char *rgb, int width, int height, const unsigned int step, unsigned int pixfmt);
 
 void v4lconvert_bayer_to_yuv420(const unsigned char *bayer, unsigned char *yuv,
-		int width, int height, unsigned int src_pixfmt, int yvu);
+		int width, int height, const unsigned int step, unsigned int src_pixfmt, int yvu);
 
 void v4lconvert_hm12_to_rgb24(const unsigned char *src,
 		unsigned char *dst, int width, int height);

--------------090008090609090202090708--
