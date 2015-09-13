Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:59800 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754638AbbIMTQr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2015 15:16:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/4] videodev2.h: add SMPTE 2084 transfer function define
Date: Sun, 13 Sep 2015 21:15:18 +0200
Message-Id: <1442171721-13058-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1442171721-13058-1-git-send-email-hverkuil@xs4all.nl>
References: <1442171721-13058-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

CEA-861.3 adds support for the SMPTE 2084 Electro-Optical Transfer Function
as can be used in HDR displays. Add a defined for this in videodev2.h.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/videodev2.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 4900e15..80314ad 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -269,6 +269,7 @@ enum v4l2_xfer_func {
 	V4L2_XFER_FUNC_SMPTE240M   = 4,
 	V4L2_XFER_FUNC_NONE        = 5,
 	V4L2_XFER_FUNC_DCI_P3      = 6,
+	V4L2_XFER_FUNC_SMPTE2084   = 7,
 };
 
 /*
-- 
2.1.4

