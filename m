Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:51771 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751200AbdBCP0h (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Feb 2017 10:26:37 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input <linux-input@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 1/2] serio.h: add SERIO_RAINSHADOW_CEC ID
Date: Fri,  3 Feb 2017 16:26:32 +0100
Message-Id: <20170203152633.33323-2-hverkuil@xs4all.nl>
In-Reply-To: <20170203152633.33323-1-hverkuil@xs4all.nl>
References: <20170203152633.33323-1-hverkuil@xs4all.nl>
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

