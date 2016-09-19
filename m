Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58777 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751033AbcISRch (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 13:32:37 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Nick Dyer <nick@shmanahar.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-doc@vger.kernel.org,
        Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] [media] videodev2.h.rst.exceptions: fix warnings
Date: Mon, 19 Sep 2016 14:32:05 -0300
Message-Id: <69c7fd363abd3b5ea05fb4c5a89ab06b0b4c3383.1474306315.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changeset ab6343956f9c ("[media] V4L2: Add documentation for SDI timings
and related flags") added documentation for new V4L2 defines, but
it forgot to update videodev2.h.rst.exceptions to point to where
the documentation for those new values will be inside the book,
causing those warnings:

    Documentation/output/videodev2.h.rst:6: WARNING: undefined label: v4l2-dv-bt-std-sdi (if the link has no caption the label must precede a section header)
    Documentation/output/videodev2.h.rst:6: WARNING: undefined label: v4l2-dv-fl-first-field-extra-line (if the link has no caption the label must precede a section header)
    Documentation/output/videodev2.h.rst:6: WARNING: undefined label: v4l2-in-st-no-v-lock (if the link has no caption the label must precede a section header)
    Documentation/output/videodev2.h.rst:6: WARNING: undefined label: v4l2-in-st-no-std-lock (if the link has no caption the label must precede a section header)

Fixes: ab6343956f9c ("[media] V4L2: Add documentation for SDI timings and related flags")

Cc: Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/videodev2.h.rst.exceptions | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/media/videodev2.h.rst.exceptions b/Documentation/media/videodev2.h.rst.exceptions
index 3828a2983acb..1d3f27d922b2 100644
--- a/Documentation/media/videodev2.h.rst.exceptions
+++ b/Documentation/media/videodev2.h.rst.exceptions
@@ -268,12 +268,14 @@ replace define V4L2_DV_BT_STD_CEA861 dv-bt-standards
 replace define V4L2_DV_BT_STD_DMT dv-bt-standards
 replace define V4L2_DV_BT_STD_CVT dv-bt-standards
 replace define V4L2_DV_BT_STD_GTF dv-bt-standards
+replace define V4L2_DV_BT_STD_SDI dv-bt-standards
 
 replace define V4L2_DV_FL_REDUCED_BLANKING dv-bt-standards
 replace define V4L2_DV_FL_CAN_REDUCE_FPS dv-bt-standards
 replace define V4L2_DV_FL_REDUCED_FPS dv-bt-standards
 replace define V4L2_DV_FL_HALF_LINE dv-bt-standards
 replace define V4L2_DV_FL_IS_CE_VIDEO dv-bt-standards
+replace define V4L2_DV_FL_FIRST_FIELD_EXTRA_LINE dv-bt-standards
 
 replace define V4L2_DV_BT_656_1120 dv-timing-types
 
@@ -301,6 +303,8 @@ replace define V4L2_IN_ST_NO_CARRIER input-status
 replace define V4L2_IN_ST_MACROVISION input-status
 replace define V4L2_IN_ST_NO_ACCESS input-status
 replace define V4L2_IN_ST_VTR input-status
+replace define V4L2_IN_ST_NO_V_LOCK input-status
+replace define V4L2_IN_ST_NO_STD_LOCK input-status
 
 replace define V4L2_IN_CAP_DV_TIMINGS input-capabilities
 replace define V4L2_IN_CAP_STD input-capabilities
-- 
2.7.4

