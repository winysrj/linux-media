Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:57196 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933253AbcHDJaG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Aug 2016 05:30:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 6/7] pixfmt-007.rst: fix a messed up note in the DCI-P3 doc
Date: Thu,  4 Aug 2016 11:28:20 +0200
Message-Id: <1470302901-29281-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1470302901-29281-1-git-send-email-hverkuil@xs4all.nl>
References: <1470302901-29281-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The text of the note included text that shouldn't have been part
of the note. Move that out of the note into the proper place.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/v4l/pixfmt-007.rst | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/media/uapi/v4l/pixfmt-007.rst b/Documentation/media/uapi/v4l/pixfmt-007.rst
index 0f9ce74..6ca475a 100644
--- a/Documentation/media/uapi/v4l/pixfmt-007.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-007.rst
@@ -532,13 +532,13 @@ Colorspace DCI-P3 (V4L2_COLORSPACE_DCI_P3)
 The :ref:`smpte431` standard defines the colorspace used by cinema
 projectors that use the DCI-P3 colorspace. The default transfer function
 is ``V4L2_XFER_FUNC_DCI_P3``. The default Y'CbCr encoding is
-``V4L2_YCBCR_ENC_709``.
+``V4L2_YCBCR_ENC_709``. The default Y'CbCr quantization is limited range.
 
-.. note:: Note that this colorspace does not specify a
+.. note:: Note that this colorspace standard does not specify a
    Y'CbCr encoding since it is not meant to be encoded to Y'CbCr. So this
-   default Y'CbCr encoding was picked because it is the HDTV encoding. The
-   default Y'CbCr quantization is limited range. The chromaticities of the
-   primary colors and the white reference are:
+   default Y'CbCr encoding was picked because it is the HDTV encoding.
+
+The chromaticities of the primary colors and the white reference are:
 
 
 
-- 
2.8.1

