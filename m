Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:39109 "EHLO
        bin-vsp-out-01.atm.binero.net" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S967159AbeBNKg5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Feb 2018 05:36:57 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v2] videodev2.h: add helper to validate colorspace
Date: Wed, 14 Feb 2018 11:36:43 +0100
Message-Id: <20180214103643.8245-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no way for drivers to validate a colorspace value, which could
be provided by user-space by VIDIOC_S_FMT for example. Add a helper to
validate that the colorspace value is part of enum v4l2_colorspace.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 include/uapi/linux/videodev2.h | 4 ++++
 1 file changed, 4 insertions(+)

Hi,

I hope this is the correct header to add this helper to. I think it's
since if it's in uapi not only can v4l2 drivers use it but tools like
v4l-compliance gets access to it and can be updated to use this instead
of the hard-coded check of just < 0xff as it was last time I checked.

* Changes since v1
- Cast colorspace to u32 as suggested by Sakari and only check the upper 
  boundary to address a potential issue brought up by Laurent if the 
  data type tested is u32 which is not uncommon:

    enum.c:30:16: warning: comparison of unsigned expression >= 0 is always true
    [-Wtype-limits]
      return V4L2_COLORSPACE_IS_VALID(colorspace);

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 9827189651801e12..1f27c0f4187cbded 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -238,6 +238,10 @@ enum v4l2_colorspace {
 	V4L2_COLORSPACE_DCI_P3        = 12,
 };
 
+/* Determine if a colorspace is defined in enum v4l2_colorspace */
+#define V4L2_COLORSPACE_IS_VALID(colorspace)		\
+	((u32)(colorspace) <= V4L2_COLORSPACE_DCI_P3)
+
 /*
  * Determine how COLORSPACE_DEFAULT should map to a proper colorspace.
  * This depends on whether this is a SDTV image (use SMPTE 170M), an
-- 
2.16.1
