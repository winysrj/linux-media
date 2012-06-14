Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756028Ab2FNNm6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 09:42:58 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: hverkuil@xs4all.nl, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 3/4] radio-si470x: Lower hardware freq seek signal treshold
Date: Thu, 14 Jun 2012 15:43:13 +0200
Message-Id: <1339681394-11348-3-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1339681394-11348-1-git-send-email-hdegoede@redhat.com>
References: <1339681394-11348-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The previous value made hardware freq seek not work for me, despite having
good reception of almost all Dutch radio stations.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/radio/si470x/radio-si470x-common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-common.c b/drivers/media/radio/si470x/radio-si470x-common.c
index 9f8b675..84ab3d57 100644
--- a/drivers/media/radio/si470x/radio-si470x-common.c
+++ b/drivers/media/radio/si470x/radio-si470x-common.c
@@ -359,7 +359,7 @@ int si470x_start(struct si470x_device *radio)
 
 	/* sysconfig 2 */
 	radio->registers[SYSCONFIG2] =
-		(0x3f  << 8) |				/* SEEKTH */
+		(0x1f  << 8) |				/* SEEKTH */
 		((band  << 6) & SYSCONFIG2_BAND)  |	/* BAND */
 		((space << 4) & SYSCONFIG2_SPACE) |	/* SPACE */
 		15;					/* VOLUME (max) */
-- 
1.7.10.2

