Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:53091 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932933AbdDFHTH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Apr 2017 03:19:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 1/2] serio.h: add SERIO_RAINSHADOW_CEC ID
Date: Thu,  6 Apr 2017 09:18:55 +0200
Message-Id: <20170406071856.17404-2-hverkuil@xs4all.nl>
In-Reply-To: <20170406071856.17404-1-hverkuil@xs4all.nl>
References: <20170406071856.17404-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add a new serio ID for the RainShadow Tech USB HDMI CEC adapter.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 include/uapi/linux/serio.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/serio.h b/include/uapi/linux/serio.h
index ccd0ccd00f47..ac217c6f0151 100644
--- a/include/uapi/linux/serio.h
+++ b/include/uapi/linux/serio.h
@@ -80,5 +80,6 @@
 #define SERIO_WACOM_IV	0x3e
 #define SERIO_EGALAX	0x3f
 #define SERIO_PULSE8_CEC	0x40
+#define SERIO_RAINSHADOW_CEC	0x41
 
 #endif /* _UAPI_SERIO_H */
-- 
2.11.0
