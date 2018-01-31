Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:46928 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752569AbeAaK0l (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Jan 2018 05:26:41 -0500
Received: by mail-pf0-f194.google.com with SMTP id y5so12141491pff.13
        for <linux-media@vger.kernel.org>; Wed, 31 Jan 2018 02:26:40 -0800 (PST)
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
Subject: [RFCv2 13/17] videodev2.h: add request_fd field to v4l2_ext_controls
Date: Wed, 31 Jan 2018 19:26:21 +0900
Message-Id: <20180131102625.208021-4-acourbot@chromium.org>
In-Reply-To: <20180131102625.208021-1-acourbot@chromium.org>
References: <20180131102625.208021-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow to specify a request to be used with the S_EXT_CTRLS and
G_EXT_CTRLS operations.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 include/uapi/linux/videodev2.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 89bd716c66a6..0aeb8861908a 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1585,7 +1585,8 @@ struct v4l2_ext_controls {
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
