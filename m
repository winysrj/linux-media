Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:46318 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756887AbcGJNLd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2016 09:11:33 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: lars@opdenkamp.eu, Hans Verkuil <hans.verkuil@cisco.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 2/5] serio.h: add new define for the Pulse-Eight USB-CEC Adapter
Date: Sun, 10 Jul 2016 15:11:18 +0200
Message-Id: <1468156281-25731-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1468156281-25731-1-git-send-email-hverkuil@xs4all.nl>
References: <1468156281-25731-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This is for the new pulse8-cec staging driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 include/uapi/linux/serio.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/serio.h b/include/uapi/linux/serio.h
index c2ea169..f2447a8 100644
--- a/include/uapi/linux/serio.h
+++ b/include/uapi/linux/serio.h
@@ -78,5 +78,6 @@
 #define SERIO_TSC40	0x3d
 #define SERIO_WACOM_IV	0x3e
 #define SERIO_EGALAX	0x3f
+#define SERIO_PULSE8_CEC	0x40
 
 #endif /* _UAPI_SERIO_H */
-- 
2.8.1

