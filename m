Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40953 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727806AbeKJBGy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Nov 2018 20:06:54 -0500
From: Ricardo Ribalda Delgado <ricardo@ribalda.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo@ribalda.com>
Subject: [PATCH] media: doc-rst: Fix broken references
Date: Fri,  9 Nov 2018 16:25:41 +0100
Message-Id: <20181109152541.8972-1-ricardo@ribalda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Documentation and code was linking the old documentation at:
http://v4l2spec.bytesex.org/spec/x1904.htm

Signed-off-by: Ricardo Ribalda Delgado <ricardo@ribalda.com>
---
 Documentation/media/v4l-drivers/sh_mobile_ceu_camera.rst | 2 +-
 drivers/media/platform/sh_vou.c                          | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/media/v4l-drivers/sh_mobile_ceu_camera.rst b/Documentation/media/v4l-drivers/sh_mobile_ceu_camera.rst
index e40ffea7708c..9b1e1c5a23f0 100644
--- a/Documentation/media/v4l-drivers/sh_mobile_ceu_camera.rst
+++ b/Documentation/media/v4l-drivers/sh_mobile_ceu_camera.rst
@@ -114,7 +114,7 @@ window:
 S_CROP
 ------
 
-The API at http://v4l2spec.bytesex.org/spec/x1904.htm says:
+The :ref:`V4L2 crop API <crop-scale>` says:
 
 "...specification does not define an origin or units. However by convention
 drivers should horizontally count unscaled samples relative to 0H."
diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index cee58b125548..5799aa4b9323 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -1007,7 +1007,7 @@ static int sh_vou_s_selection(struct file *file, void *fh,
 
 	/*
 	 * No down-scaling. According to the API, current call has precedence:
-	 * http://v4l2spec.bytesex.org/spec/x1904.htm#AEN1954 paragraph two.
+	 * https://linuxtv.org/downloads/v4l-dvb-apis/uapi/v4l/crop.html#cropping-structures
 	 */
 	vou_adjust_input(&geo, vou_dev->std);
 
-- 
2.19.1
