Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:34440 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933275AbbEOM3c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2015 08:29:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/6] videodev2.h: add COLORSPACE_RAW
Date: Fri, 15 May 2015 14:29:07 +0200
Message-Id: <1431692950-17453-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1431692950-17453-1-git-send-email-hverkuil@xs4all.nl>
References: <1431692950-17453-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

V4L2_COLORSPACE_RAW is added for raw image formats where the picture
is minimally processed and is in the internal colorspace of the sensor.

This is typically used in digital cameras where the image processing is
done later.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/videodev2.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 7810376..3837030 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -226,6 +226,9 @@ enum v4l2_colorspace {
 
 	/* BT.2020 colorspace, used for UHDTV. */
 	V4L2_COLORSPACE_BT2020        = 10,
+
+	/* Raw colorspace: for RAW unprocessed images */
+	V4L2_COLORSPACE_RAW           = 11,
 };
 
 enum v4l2_ycbcr_encoding {
-- 
2.1.4

