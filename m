Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50083 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798AbaFNQQ1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jun 2014 12:16:27 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	stable@vger.kernel.org
Subject: [PATCH 3/3] sound: Update au0828 quirks table
Date: Sat, 14 Jun 2014 13:16:11 -0300
Message-Id: <1402762571-6316-4-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1402762571-6316-1-git-send-email-m.chehab@samsung.com>
References: <1402762571-6316-1-git-send-email-m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The au0828 quirks table is currently not in sync with the au0828
media driver.

Syncronize it, as all the au0828 devices with analog TV need the
same quirks.

Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 sound/usb/quirks-table.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 30add0bfee8e..3f882d996981 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2769,14 +2769,22 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 }
 
 AU0828_DEVICE(0x2040, 0x7200, "Hauppauge", "HVR-950Q"),
+AU0828_DEVICE(0x2040, 0x7240, "Hauppauge", "HVR-850"),
 AU0828_DEVICE(0x2040, 0x7210, "Hauppauge", "HVR-950Q"),
 AU0828_DEVICE(0x2040, 0x7217, "Hauppauge", "HVR-950Q"),
 AU0828_DEVICE(0x2040, 0x721b, "Hauppauge", "HVR-950Q"),
 AU0828_DEVICE(0x2040, 0x721e, "Hauppauge", "HVR-950Q"),
 AU0828_DEVICE(0x2040, 0x721f, "Hauppauge", "HVR-950Q"),
-AU0828_DEVICE(0x2040, 0x7240, "Hauppauge", "HVR-850"),
 AU0828_DEVICE(0x2040, 0x7280, "Hauppauge", "HVR-950Q"),
 AU0828_DEVICE(0x0fd9, 0x0008, "Hauppauge", "HVR-950Q"),
+AU0828_DEVICE(0x2040, 0x7201, "Hauppauge", "HVR-950Q-MXL"),
+AU0828_DEVICE(0x2040, 0x7211, "Hauppauge", "HVR-950Q-MXL"),
+AU0828_DEVICE(0x2040, 0x7281, "Hauppauge", "HVR-950Q-MXL"),
+AU0828_DEVICE(0x05e1, 0x0480, "Hauppauge", "Woodbury"),
+AU0828_DEVICE(0x2040, 0x8200, "Hauppauge", "Woodbury"),
+AU0828_DEVICE(0x2040, 0x7260, "Hauppauge", "HVR-950Q"),
+AU0828_DEVICE(0x2040, 0x7213, "Hauppauge", "HVR-950Q"),
+AU0828_DEVICE(0x2040, 0x7270, "Hauppauge", "HVR-950Q"),
 
 /* Digidesign Mbox */
 {
-- 
1.9.3

