Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:34978 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753476AbeDCVQA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Apr 2018 17:16:00 -0400
From: Luca Ceresoli <luca@lucaceresoli.net>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org,
        Luca Ceresoli <luca@lucaceresoli.net>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 4/5] media: docs: selection: improve formatting
Date: Tue,  3 Apr 2018 23:15:45 +0200
Message-Id: <1522790146-16061-4-git-send-email-luca@lucaceresoli.net>
In-Reply-To: <1522790146-16061-1-git-send-email-luca@lucaceresoli.net>
References: <1522790146-16061-1-git-send-email-luca@lucaceresoli.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Split section "Comparison with old cropping API" in paragraphs for
easier reading and improve visible links text.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
---
 .../media/uapi/v4l/selection-api-vs-crop-api.rst   | 55 ++++++++++++----------
 1 file changed, 29 insertions(+), 26 deletions(-)

diff --git a/Documentation/media/uapi/v4l/selection-api-vs-crop-api.rst b/Documentation/media/uapi/v4l/selection-api-vs-crop-api.rst
index 2ad30a49184f..ba1064a244a0 100644
--- a/Documentation/media/uapi/v4l/selection-api-vs-crop-api.rst
+++ b/Documentation/media/uapi/v4l/selection-api-vs-crop-api.rst
@@ -6,31 +6,34 @@
 Comparison with old cropping API
 ********************************
 
-The selection API was introduced to cope with deficiencies of previous
-:ref:`API <crop>`, that was designed to control simple capture
-devices. Later the cropping API was adopted by video output drivers. The
-ioctls are used to select a part of the display were the video signal is
-inserted. It should be considered as an API abuse because the described
-operation is actually the composing. The selection API makes a clear
-distinction between composing and cropping operations by setting the
-appropriate targets. The V4L2 API lacks any support for composing to and
-cropping from an image inside a memory buffer. The application could
-configure a capture device to fill only a part of an image by abusing
-V4L2 API. Cropping a smaller image from a larger one is achieved by
-setting the field ``bytesperline`` at struct
-:c:type:`v4l2_pix_format`.
-Introducing an image offsets could be done by modifying field ``m_userptr``
-at struct
-:c:type:`v4l2_buffer` before calling
-:ref:`VIDIOC_QBUF`. Those operations should be avoided because they are not
-portable (endianness), and do not work for macroblock and Bayer formats
-and mmap buffers. The selection API deals with configuration of buffer
+The selection API was introduced to cope with deficiencies of the
+older :ref:`CROP API <crop>`, that was designed to control simple
+capture devices. Later the cropping API was adopted by video output
+drivers. The ioctls are used to select a part of the display were the
+video signal is inserted. It should be considered as an API abuse
+because the described operation is actually the composing. The
+selection API makes a clear distinction between composing and cropping
+operations by setting the appropriate targets.
+
+The V4L2 API lacks any support for composing to and cropping from an
+image inside a memory buffer. The application could configure a
+capture device to fill only a part of an image by abusing V4L2
+API. Cropping a smaller image from a larger one is achieved by setting
+the field ``bytesperline`` at struct :c:type:`v4l2_pix_format`.
+Introducing an image offsets could be done by modifying field
+``m_userptr`` at struct :c:type:`v4l2_buffer` before calling
+:ref:`VIDIOC_QBUF <VIDIOC_QBUF>`. Those operations should be avoided
+because they are not portable (endianness), and do not work for
+macroblock and Bayer formats and mmap buffers.
+
+The selection API deals with configuration of buffer
 cropping/composing in a clear, intuitive and portable way. Next, with
 the selection API the concepts of the padded target and constraints
-flags are introduced. Finally, struct :c:type:`v4l2_crop`
-and struct :c:type:`v4l2_cropcap` have no reserved
-fields. Therefore there is no way to extend their functionality. The new
-struct :c:type:`v4l2_selection` provides a lot of place
-for future extensions. Driver developers are encouraged to implement
-only selection API. The former cropping API would be simulated using the
-new one.
+flags are introduced. Finally, struct :c:type:`v4l2_crop` and struct
+:c:type:`v4l2_cropcap` have no reserved fields. Therefore there is no
+way to extend their functionality. The new struct
+:c:type:`v4l2_selection` provides a lot of place for future
+extensions.
+
+Driver developers are encouraged to implement only selection API. The
+former cropping API would be simulated using the new one.
-- 
2.7.4
