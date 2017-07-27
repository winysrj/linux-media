Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:37187 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751125AbdG0Jam (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Jul 2017 05:30:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH 2/3] media/doc: improve bt.2020 documentation
Date: Thu, 27 Jul 2017 11:30:31 +0200
Message-Id: <20170727093032.12663-3-hverkuil@xs4all.nl>
In-Reply-To: <20170727093032.12663-1-hverkuil@xs4all.nl>
References: <20170727093032.12663-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

Add a note stating that bt.2020 is often used in combination with the
smpte 2084 transfer function.

Also use the right references to the documentation of that transfer
function.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 Documentation/media/uapi/v4l/colorspaces-defs.rst    | 2 +-
 Documentation/media/uapi/v4l/colorspaces-details.rst | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/v4l/colorspaces-defs.rst b/Documentation/media/uapi/v4l/colorspaces-defs.rst
index 7ae7dcf73f63..e67ed1e0b3fa 100644
--- a/Documentation/media/uapi/v4l/colorspaces-defs.rst
+++ b/Documentation/media/uapi/v4l/colorspaces-defs.rst
@@ -97,7 +97,7 @@ whole range, 0-255, dividing the angular value by 1.41. The enum
     * - ``V4L2_XFER_FUNC_DCI_P3``
       - Use the DCI-P3 transfer function.
     * - ``V4L2_XFER_FUNC_SMPTE2084``
-      - Use the SMPTE 2084 transfer function.
+      - Use the SMPTE 2084 transfer function. See :ref:`xf-smpte-2084`.
 
 
 
diff --git a/Documentation/media/uapi/v4l/colorspaces-details.rst b/Documentation/media/uapi/v4l/colorspaces-details.rst
index 128b2acbe824..47d7d1915284 100644
--- a/Documentation/media/uapi/v4l/colorspaces-details.rst
+++ b/Documentation/media/uapi/v4l/colorspaces-details.rst
@@ -418,6 +418,11 @@ Inverse Transfer function:
 
     L = \left( \frac{L' + 0.099}{1.099}\right) ^{\frac{1}{0.45} }\text{, for } L' \ge 0.081
 
+Please note that while Rec. 709 is defined as the default transfer function
+by the :ref:`itu2020` standard, in practice this colorspace is often used
+with the :ref:`xf-smpte-2084`. In particular Ultra HD Blu-ray discs use
+this combination.
+
 The luminance (Y') and color difference (Cb and Cr) are obtained with
 the following ``V4L2_YCBCR_ENC_BT2020`` encoding:
 
-- 
2.13.1
