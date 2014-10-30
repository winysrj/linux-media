Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46963 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759354AbaJ3L3H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Oct 2014 07:29:07 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
	Clemens Ladisch <clemens@ladisch.de>,
	Daniel Mack <zonque@gmail.com>,
	Eduard Gilmutdinov <edgilmutdinov@gmail.com>,
	Vlad Catoi <vladcatoi@gmail.com>, alsa-devel@alsa-project.org,
	stable@vger.kernel.org
Subject: [PATCH v2 2/2] [media] sound: Update au0828 quirks table
Date: Thu, 30 Oct 2014 09:28:12 -0200
Message-Id: <678fa12fb8e75c6dc1e781a02e3ddbbba7e1a904.1414668341.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414668341.git.mchehab@osg.samsung.com>
References: <cover.1414668341.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414668341.git.mchehab@osg.samsung.com>
References: <cover.1414668341.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The au0828 quirks table is currently not in sync with the au0828
media driver.

Syncronize it and put them on the same order as found at au0828
driver, as all the au0828 devices with analog TV need the
same quirks.

Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 8f3e2bf100eb..83bddbdb90e9 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2827,14 +2827,22 @@ YAMAHA_DEVICE(0x7010, "UB99"),
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

