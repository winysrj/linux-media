Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:59880 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934169AbbEOM33 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2015 08:29:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/6] videodev2.h: add COLORSPACE_DEFAULT
Date: Fri, 15 May 2015 14:29:05 +0200
Message-Id: <1431692950-17453-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1431692950-17453-1-git-send-email-hverkuil@xs4all.nl>
References: <1431692950-17453-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

V4L2_COLORSPACE_DEFAULT is added so we have a specific define for
the default case where applications do not set it but leave it to 0.
In that case the driver will set the colorspace based on what it
captures.

This is already used, but we never had a define for the value 0.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/videodev2.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 0f5a467..7810376 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -178,6 +178,12 @@ enum v4l2_memory {
 
 /* see also http://vektor.theorem.ca/graphics/ycbcr/ */
 enum v4l2_colorspace {
+	/*
+	 * Default colorspace, i.e. let the driver figure it out.
+	 * Can only be used with video capture.
+	 */
+	V4L2_COLORSPACE_DEFAULT       = 0,
+
 	/* SMPTE 170M: used for broadcast NTSC/PAL SDTV */
 	V4L2_COLORSPACE_SMPTE170M     = 1,
 
-- 
2.1.4

