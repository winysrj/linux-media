Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:39712 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432AbZJFGwU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Oct 2009 02:52:20 -0400
Date: Tue, 6 Oct 2009 08:51:38 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Hans de Goede <hdegoede@redhat.com>
Cc: V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] libv4l - spca561: Have static decoding tables
Message-ID: <20091006085138.43085ca8@tele>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/WfAQ02gM91VxWOf.cWLgkOB"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/WfAQ02gM91VxWOf.cWLgkOB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello Hans,

Searching the image encoding type of a new (but old!) webcam and tracing
some decoding functions, I was surprised to see a move of constant
tables to the stack in internal_spca561_decode.

Best regards.

--=20
Ken ar c'henta=F1	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

--MP_/WfAQ02gM91VxWOf.cWLgkOB
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=libv4l-spca561.patch

libv4l - spca561: Have static decoding tables

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>

diff -r fbecc4a86361 v4l2-apps/libv4l/libv4lconvert/spca561-decompress.c
--- a/v4l2-apps/libv4l/libv4lconvert/spca561-decompress.c	Mon Oct 05 10:41:30 2009 +0200
+++ b/v4l2-apps/libv4l/libv4lconvert/spca561-decompress.c	Tue Oct 06 08:37:30 2009 +0200
@@ -308,7 +308,7 @@
 	static int accum[8 * 8 * 8];
 	static int i_hits[8 * 8 * 8];
 
-	const int nbits_A[] =
+	static const int nbits_A[] =
 	    { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
 		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
 		    1, 1,
@@ -336,7 +336,7 @@
 		3, 3, 3, 3, 3,
 		3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
 	};
-	const int tab_A[] =
+	static const int tab_A[] =
 	    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 		    0, 0,
@@ -371,7 +371,7 @@
 		1
 	};
 
-	const int nbits_B[] =
+	static const int nbits_B[] =
 	    { 0, 8, 7, 7, 6, 6, 6, 6, 5, 5, 5, 5, 5, 5, 5, 5, 4, 4, 4, 4,
 		4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 3, 3, 3, 3, 3, 3, 3, 3,
 		    3, 3,
@@ -399,7 +399,7 @@
 		1, 1, 1, 1, 1,
 		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
 	};
-	const int tab_B[] =
+	static const int tab_B[] =
 	    { 0xff, -4, 3, 3, -3, -3, -3, -3, 2, 2, 2, 2, 2, 2, 2, 2, -2,
 		-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
 		    1, 1,
@@ -434,7 +434,7 @@
 		0, 0, 0, 0, 0, 0, 0,
 	};
 
-	const int nbits_C[] =
+	static const int nbits_C[] =
 	    { 0, 0, 8, 8, 7, 7, 7, 7, 6, 6, 6, 6, 6, 6, 6, 6, 5, 5, 5, 5,
 		5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 4, 4, 4, 4, 4, 4, 4, 4,
 		    4, 4,
@@ -462,7 +462,7 @@
 		2, 2, 2, 2, 2,
 		2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
 	};
-	const int tab_C[] =
+	static const int tab_C[] =
 	    { 0xff, 0xfe, 6, -7, 5, 5, -6, -6, 4, 4, 4, 4, -5, -5, -5, -5,
 		3, 3, 3, 3, 3, 3, 3, 3, -4, -4, -4, -4, -4, -4, -4, -4, 2,
 		    2, 2, 2,
@@ -498,7 +498,7 @@
 		    -1,
 	};
 
-	const int nbits_D[] =
+	static const int nbits_D[] =
 	    { 0, 0, 0, 0, 8, 8, 8, 8, 7, 7, 7, 7, 7, 7, 7, 7, 6, 6, 6, 6,
 		6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 5, 5, 5, 5, 5, 5, 5, 5,
 		    5, 5,
@@ -526,7 +526,7 @@
 		3, 3, 3, 3, 3,
 		3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
 	};
-	const int tab_D[] =
+	static const int tab_D[] =
 	    { 0xff, 0xfe, 0xfd, 0xfc, 10, -11, 11, -12, 8, 8, -9, -9, 9, 9,
 		-10, -10, 6, 6, 6, 6, -7, -7, -7, -7, 7, 7, 7, 7, -8, -8,
 		    -8, -8,
@@ -564,7 +564,7 @@
 	};
 
 	/* a_curve[19 + i] = ... [-19..19] => [-160..160] */
-	const int a_curve[] =
+	static const int a_curve[] =
 	    { -160, -144, -128, -112, -98, -88, -80, -72, -64, -56, -48,
 		-40, -32, -24, -18, -12, -8, -5, -2, 0, 2, 5, 8, 12, 18,
 		    24, 32,
@@ -572,7 +572,7 @@
 		72, 80, 88, 98, 112, 128, 144, 160
 	};
 	/* clamp0_255[256 + i] = min(max(i,255),0) */
-	const unsigned char clamp0_255[] =
+	static const unsigned char clamp0_255[] =
 	    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 		    0, 0,
@@ -681,14 +681,14 @@
 		255
 	};
 	/* abs_clamp15[19 + i] = min(abs(i), 15) */
-	const int abs_clamp15[] =
+	static const int abs_clamp15[] =
 	    { 15, 15, 15, 15, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3,
 		2, 1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
 		    15, 15,
 		15
 	};
 	/* diff_encoding[256 + i] = ... */
-	const int diff_encoding[] =
+	static const int diff_encoding[] =
 	    { 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
 		7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
 		    7, 7,

--MP_/WfAQ02gM91VxWOf.cWLgkOB--
