Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756001Ab2GKPrD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jul 2012 11:47:03 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: hverkuil@xs4all.nl, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 3/5] radio-si470x: Fix band selection
Date: Wed, 11 Jul 2012 17:47:36 +0200
Message-Id: <1342021658-27821-4-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1342021658-27821-1-git-send-email-hdegoede@redhat.com>
References: <1342021658-27821-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The mask was wrong resulting in band 0 and 1 always ending up as band 0
in the register.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/radio/si470x/radio-si470x.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/radio/si470x/radio-si470x.h b/drivers/media/radio/si470x/radio-si470x.h
index b3b612f..11f14b6 100644
--- a/drivers/media/radio/si470x/radio-si470x.h
+++ b/drivers/media/radio/si470x/radio-si470x.h
@@ -87,7 +87,7 @@
 
 #define SYSCONFIG2		5	/* System Configuration 2 */
 #define SYSCONFIG2_SEEKTH	0xff00	/* bits 15..08: RSSI Seek Threshold */
-#define SYSCONFIG2_BAND		0x0080	/* bits 07..06: Band Select */
+#define SYSCONFIG2_BAND		0x00c0	/* bits 07..06: Band Select */
 #define SYSCONFIG2_SPACE	0x0030	/* bits 05..04: Channel Spacing */
 #define SYSCONFIG2_VOLUME	0x000f	/* bits 03..00: Volume */
 
-- 
1.7.10.4

