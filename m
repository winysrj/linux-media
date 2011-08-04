Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:55358 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab1HDHO0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2011 03:14:26 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 10/21] [staging] tm6000: Disable video interface in radio mode.
Date: Thu,  4 Aug 2011 09:14:08 +0200
Message-Id: <1312442059-23935-11-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
References: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Video data is useless in radio mode, so the corresponding interface can
be safely disabled. This should reduce the amount of isochronous traffic
noticeably.
---
 drivers/staging/tm6000/tm6000-core.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index 2117f8e..1f8abe3 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -264,9 +264,14 @@ int tm6000_init_analog_mode(struct tm6000_core *dev)
 	struct v4l2_frequency f;
 
 	if (dev->dev_type == TM6010) {
+		u8 active = TM6010_REQ07_RCC_ACTIVE_IF_AUDIO_ENABLE;
+
+		if (!dev->radio)
+			active |= TM6010_REQ07_RCC_ACTIVE_IF_VIDEO_ENABLE;
+
 		/* Enable video and audio */
 		tm6000_set_reg_mask(dev, TM6010_REQ07_RCC_ACTIVE_IF,
-							0x60, 0x60);
+							active, 0x60);
 		/* Disable TS input */
 		tm6000_set_reg_mask(dev, TM6010_REQ07_RC0_ACTIVE_VIDEO_SOURCE,
 							0x00, 0x40);
-- 
1.7.6

