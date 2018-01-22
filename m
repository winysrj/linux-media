Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:38585 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751167AbeAVMb3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Jan 2018 07:31:29 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 9/9] vidioc-g-parm.rst: also allow _MPLANE buffer types
Date: Mon, 22 Jan 2018 13:31:25 +0100
Message-Id: <20180122123125.24709-10-hverkuil@xs4all.nl>
In-Reply-To: <20180122123125.24709-1-hverkuil@xs4all.nl>
References: <20180122123125.24709-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The specification mentions that type can be V4L2_BUF_TYPE_VIDEO_CAPTURE,
but the v4l2 core implementation also allows the _MPLANE variant.

Document this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/v4l/vidioc-g-parm.rst | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/media/uapi/v4l/vidioc-g-parm.rst b/Documentation/media/uapi/v4l/vidioc-g-parm.rst
index 616a5ea3f8fa..e831fa5512f0 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-parm.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-parm.rst
@@ -66,7 +66,7 @@ union holding separate parameters for input and output devices.
       -
       - The buffer (stream) type, same as struct
 	:c:type:`v4l2_format` ``type``, set by the
-	application. See :c:type:`v4l2_buf_type`
+	application. See :c:type:`v4l2_buf_type`.
     * - union
       - ``parm``
       -
@@ -75,12 +75,13 @@ union holding separate parameters for input and output devices.
       - struct :c:type:`v4l2_captureparm`
       - ``capture``
       - Parameters for capture devices, used when ``type`` is
-	``V4L2_BUF_TYPE_VIDEO_CAPTURE``.
+	``V4L2_BUF_TYPE_VIDEO_CAPTURE`` or
+	``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE``.
     * -
       - struct :c:type:`v4l2_outputparm`
       - ``output``
       - Parameters for output devices, used when ``type`` is
-	``V4L2_BUF_TYPE_VIDEO_OUTPUT``.
+	``V4L2_BUF_TYPE_VIDEO_OUTPUT`` or ``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE``.
     * -
       - __u8
       - ``raw_data``\ [200]
-- 
2.15.1
