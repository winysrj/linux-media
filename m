Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:53852 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757176AbZKCEOR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Nov 2009 23:14:17 -0500
Message-ID: <4AEFAE1A.2010600@freemail.hu>
Date: Tue, 03 Nov 2009 05:14:18 +0100
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: V4L Mailing List <linux-media@vger.kernel.org>,
	Franck Bourdonnec <fbourdonnec@chez.com>,
	Jean-Francois Moine <moinejf@free.fr>
Subject: [PATCH] pixfmt-test: fix VIDIOC_G_STD call for webcams
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Webcams may return -1 and errno=EINVAL when there is no standard which
they support. Handle this case in pixfmt-test.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r 43878f8dbfb0 v4l2-apps/test/pixfmt-test.c
--- a/v4l2-apps/test/pixfmt-test.c	Sun Nov 01 07:17:46 2009 -0200
+++ b/v4l2-apps/test/pixfmt-test.c	Tue Nov 03 05:10:52 2009 +0100
@@ -1741,8 +1741,10 @@
 		/* Errors ignored. */
 	}

+	/* Webcams may not support any standard at all, see
+	   http://v4l2spec.bytesex.org/spec/x448.htm for details */
 	if (-1 == xioctl (dev_fd, VIDIOC_G_STD, &std_id))
-		errno_exit ("VIDIOC_G_STD");
+		std_id = 0;
 }

 static void
