Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:42968 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933259AbcHDJaG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Aug 2016 05:30:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 7/7] pixfmt-007.rst: fix copy-and-paste error in SMPTE-240M doc
Date: Thu,  4 Aug 2016 11:28:21 +0200
Message-Id: <1470302901-29281-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1470302901-29281-1-git-send-email-hverkuil@xs4all.nl>
References: <1470302901-29281-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Instead of referring to Y', Cb and Cr, it referred to Yc', Cbc and
Crc, which were accidentally copied from the BT.2020 constant luminance
text.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/v4l/pixfmt-007.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/v4l/pixfmt-007.rst b/Documentation/media/uapi/v4l/pixfmt-007.rst
index 6ca475a..2513cf3 100644
--- a/Documentation/media/uapi/v4l/pixfmt-007.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-007.rst
@@ -685,7 +685,7 @@ the following ``V4L2_YCBCR_ENC_SMPTE240M`` encoding:
 
     Cr = 0.5R' - 0.4451G' - 0.0549B'
 
-Yc' is clamped to the range [0…1] and Cbc and Crc are clamped to the
+Y' is clamped to the range [0…1] and Cb and Cr are clamped to the
 range [-0.5…0.5]. The Y'CbCr quantization is limited range.
 
 
-- 
2.8.1

