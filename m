Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43878 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941737AbcIHMEY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:24 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 26/47] [media] v4l2-subdev.h: fix a doc nitpick warning
Date: Thu,  8 Sep 2016 09:03:48 -0300
Message-Id: <18cfb8763f893b8d241bea2c0f9e17f25e5f6b54.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

One markup tag is wrong here.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/v4l2-subdev.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 6e1d044e3ee8..2c1e328ccb1d 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -226,7 +226,7 @@ struct v4l2_subdev_core_ops {
  *
  * @g_tuner: callback for %VIDIOC_G_TUNER ioctl handler code.
  *
- * @s_tuner: callback for %VIDIOC_S_TUNER ioctl handler code. &vt->type must be
+ * @s_tuner: callback for %VIDIOC_S_TUNER ioctl handler code. @vt->type must be
  *	     filled in. Normally done by video_ioctl2 or the
  *	     bridge driver.
  *
-- 
2.7.4


