Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:59426 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752715AbcLONCP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 08:02:15 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input <linux-input@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/2] serio.h: add SERIO_RAINSHADOW_CEC ID
Date: Thu, 15 Dec 2016 14:02:06 +0100
Message-Id: <20161215130207.12913-2-hverkuil@xs4all.nl>
In-Reply-To: <20161215130207.12913-1-hverkuil@xs4all.nl>
References: <20161215130207.12913-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add a new serio ID for the RainShadow Tech USB HDMI CEC adapter.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/serio.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/serio.h b/include/uapi/linux/serio.h
index f2447a8..f42e919 100644
--- a/include/uapi/linux/serio.h
+++ b/include/uapi/linux/serio.h
@@ -79,5 +79,6 @@
 #define SERIO_WACOM_IV	0x3e
 #define SERIO_EGALAX	0x3f
 #define SERIO_PULSE8_CEC	0x40
+#define SERIO_RAINSHADOW_CEC	0x41
 
 #endif /* _UAPI_SERIO_H */
-- 
2.10.2

