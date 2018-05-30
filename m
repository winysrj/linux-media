Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:43520 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751474AbeE3PHK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 11:07:10 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 3/3] media: videodev2: get rid of VIDIOC_RESERVED
Date: Wed, 30 May 2018 12:07:05 -0300
Message-Id: <292157c1593c2ea4f5bc6e22c69cf2950914f1d4.1527692791.git.mchehab+samsung@kernel.org>
In-Reply-To: <a0ab10ef59a28f8c8b35f4f647b55ac79d0c96d6.1527692791.git.mchehab+samsung@kernel.org>
References: <a0ab10ef59a28f8c8b35f4f647b55ac79d0c96d6.1527692791.git.mchehab+samsung@kernel.org>
In-Reply-To: <a0ab10ef59a28f8c8b35f4f647b55ac79d0c96d6.1527692791.git.mchehab+samsung@kernel.org>
References: <a0ab10ef59a28f8c8b35f4f647b55ac79d0c96d6.1527692791.git.mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While this ioctl is there at least since Kernel 2.6.12-rc2, it
was never used by any upstream driver.

Get rid of it.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 Documentation/media/videodev2.h.rst.exceptions | 1 -
 include/uapi/linux/videodev2.h                 | 1 -
 2 files changed, 2 deletions(-)

diff --git a/Documentation/media/videodev2.h.rst.exceptions b/Documentation/media/videodev2.h.rst.exceptions
index a5cb0a8686ac..ca9f0edc579e 100644
--- a/Documentation/media/videodev2.h.rst.exceptions
+++ b/Documentation/media/videodev2.h.rst.exceptions
@@ -517,7 +517,6 @@ ignore define V4L2_CTRL_WHICH_DEF_VAL
 ignore define V4L2_OUT_CAP_CUSTOM_TIMINGS
 ignore define V4L2_CID_MAX_CTRLS
 
-ignore ioctl VIDIOC_RESERVED
 ignore define BASE_VIDIOC_PRIVATE
 
 # Associate ioctls with their counterparts
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 600877be5c22..d0c5fb38677c 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -2310,7 +2310,6 @@ struct v4l2_create_buffers {
  *
  */
 #define VIDIOC_QUERYCAP		 _IOR('V',  0, struct v4l2_capability)
-#define VIDIOC_RESERVED		  _IO('V',  1)
 #define VIDIOC_ENUM_FMT         _IOWR('V',  2, struct v4l2_fmtdesc)
 #define VIDIOC_G_FMT		_IOWR('V',  4, struct v4l2_format)
 #define VIDIOC_S_FMT		_IOWR('V',  5, struct v4l2_format)
-- 
2.17.0
