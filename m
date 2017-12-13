Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:52782 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751870AbdLMJyH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Dec 2017 04:54:07 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: vidioc-g-dv-timings.rst: fix typo (frontporch -> backporch)
Message-ID: <1dfe9890-4637-cf20-3bb1-3497e1436248@xs4all.nl>
Date: Wed, 13 Dec 2017 10:54:04 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The description of V4L2_DV_FL_HALF_LINE mixed up frontporch with backporch.

It's the backporch that has different sizes for interlaced formats, the frontporch
remains constant.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/Documentation/media/uapi/v4l/	 b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
index 2696380626d4..1a034e825161 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
@@ -267,7 +267,7 @@ EBUSY
 	will also be cleared.
     * - ``V4L2_DV_FL_HALF_LINE``
       - Specific to interlaced formats: if set, then the vertical
-	frontporch of field 1 (aka the odd field) is really one half-line
+	backporch of field 1 (aka the odd field) is really one half-line
 	longer and the vertical backporch of field 2 (aka the even field)
 	is really one half-line shorter, so each field has exactly the
 	same number of half-lines. Whether half-lines can be detected or
