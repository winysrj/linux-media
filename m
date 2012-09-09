Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42876 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173Ab2IISf0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Sep 2012 14:35:26 -0400
Received: by eekc1 with SMTP id c1so651506eek.19
        for <linux-media@vger.kernel.org>; Sun, 09 Sep 2012 11:35:25 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: hdegoede@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 1/3] libv4lconvert: fix format of the error messages concerning jpeg frame size mismatch
Date: Sun,  9 Sep 2012 20:36:06 +0200
Message-Id: <1347215768-9843-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 lib/libv4lconvert/jpeg.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/libv4lconvert/jpeg.c b/lib/libv4lconvert/jpeg.c
index e088a90..aa9cace 100644
--- a/lib/libv4lconvert/jpeg.c
+++ b/lib/libv4lconvert/jpeg.c
@@ -56,7 +56,7 @@ int v4lconvert_decode_jpeg_tinyjpeg(struct v4lconvert_data *data,
 	}
 
 	if (header_width != width || header_height != height) {
-		V4LCONVERT_ERR("unexpected width / height in JPEG header"
+		V4LCONVERT_ERR("unexpected width / height in JPEG header: "
 			       "expected: %ux%u, header: %ux%u\n",
 			       width, height, header_width, header_height);
 		errno = EIO;
@@ -288,7 +288,7 @@ int v4lconvert_decode_jpeg_libjpeg(struct v4lconvert_data *data,
 
 	if (data->cinfo.image_width  != width ||
 	    data->cinfo.image_height != height) {
-		V4LCONVERT_ERR("unexpected width / height in JPEG header"
+		V4LCONVERT_ERR("unexpected width / height in JPEG header: "
 			       "expected: %ux%u, header: %ux%u\n", width,
 			       height, data->cinfo.image_width,
 			       data->cinfo.image_height);
-- 
1.7.7

