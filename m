Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:41661 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753092AbeBGBtJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Feb 2018 20:49:09 -0500
Received: by mail-pg0-f68.google.com with SMTP id 141so1879706pgd.8
        for <linux-media@vger.kernel.org>; Tue, 06 Feb 2018 17:49:09 -0800 (PST)
From: Alexandre Courbot <acourbot@chromium.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [RFCv3 13/17] videodev2.h: add request_fd field to v4l2_ext_controls
Date: Wed,  7 Feb 2018 10:48:17 +0900
Message-Id: <20180207014821.164536-14-acourbot@chromium.org>
In-Reply-To: <20180207014821.164536-1-acourbot@chromium.org>
References: <20180207014821.164536-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow to specify a request to be used with the S_EXT_CTRLS and
G_EXT_CTRLS operations.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 include/uapi/linux/videodev2.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 4fd46ae8fad5..91cfe0cbd5c5 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1592,7 +1592,8 @@ struct v4l2_ext_controls {
 	};
 	__u32 count;
 	__u32 error_idx;
-	__u32 reserved[2];
+	__s32 request_fd;
+	__u32 reserved[1];
 	struct v4l2_ext_control *controls;
 };
 
-- 
2.16.0.rc1.238.g530d649a79-goog
