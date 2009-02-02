Return-path: <linux-media-owner@vger.kernel.org>
Received: from pne-smtpout1-sn1.fre.skanova.net ([81.228.11.98]:52172 "EHLO
	pne-smtpout1-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753331AbZBBUXg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Feb 2009 15:23:36 -0500
Received: from [192.168.0.100] (90.224.104.93) by pne-smtpout1-sn1.fre.skanova.net (7.3.129)
        id 47A9795005DE05EF for linux-media@vger.kernel.org; Mon, 2 Feb 2009 20:14:27 +0100
Message-ID: <49874612.1000109@gmail.com>
Date: Mon, 02 Feb 2009 20:14:26 +0100
From: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH]Add green balance v4l2 ctrl support
Content-Type: multipart/mixed;
 boundary="------------020300050706030608020704"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020300050706030608020704
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,

The m5602 gspca driver has two sensors offering the possiblity to
control the green balance. This patch adds a v4l2 ctrl for this.

Regards,
Erik

Signed-off-by: Erik Andrén <erik.andren@gmail.com>

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmHRhEACgkQN7qBt+4UG0FAKACgsnXERjLdZL/D+2Ze3KkC6GJc
PowAnAkr/0+IT2jB00qCUuqS7OhBmhtG
=UfNN
-----END PGP SIGNATURE-----

--------------020300050706030608020704
Content-Type: text/x-diff;
 name="Add_green_balance.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="Add_green_balance.diff"

diff -r 24361cfb8615 linux/include/linux/videodev2.h
--- a/linux/include/linux/videodev2.h	Wed Jan 28 16:55:17 2009 +0100
+++ b/linux/include/linux/videodev2.h	Wed Jan 28 17:11:39 2009 +0100
@@ -879,8 +879,10 @@
 #define V4L2_CID_BACKLIGHT_COMPENSATION 	(V4L2_CID_BASE+28)
 #define V4L2_CID_CHROMA_AGC                     (V4L2_CID_BASE+29)
 #define V4L2_CID_COLOR_KILLER                   (V4L2_CID_BASE+30)
+
+#define V4L2_CID_GREEN_BALANCE			(V4L2_CID_BASE+31)
 /* last CID + 1 */
-#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+31)
+#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+32)
 
 /*  MPEG-class control IDs defined by V4L2 */
 #define V4L2_CID_MPEG_BASE 			(V4L2_CTRL_CLASS_MPEG | 0x900)

--------------020300050706030608020704--
