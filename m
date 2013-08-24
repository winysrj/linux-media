Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55897 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799Ab3HXOSo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Aug 2013 10:18:44 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH] [media] sound/pci/Kconfig: select RADIO_ADAPTERS if needed
Date: Sat, 24 Aug 2013 08:18:02 -0300
Message-Id: <1377343082-17425-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by kbuild test robot <fengguang.wu@intel.com>:
	warning: (SND_ES1968_RADIO && SND_FM801_TEA575X_BOOL) selects RADIO_TEA575X which has unmet direct dependencies (MEDIA_SUPPORT && RADIO_ADAPTERS && VIDEO_V4L2)

That happens because a radio driver is selected, without selecting the
RADIO_ADAPTERS menu.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 sound/pci/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/pci/Kconfig b/sound/pci/Kconfig
index 9df80ef..46ed9e8 100644
--- a/sound/pci/Kconfig
+++ b/sound/pci/Kconfig
@@ -539,7 +539,9 @@ config SND_ES1968_RADIO
 	depends on SND_ES1968
 	depends on MEDIA_RADIO_SUPPORT
 	depends on VIDEO_V4L2=y || VIDEO_V4L2=SND_ES1968
+	select RADIO_ADAPTERS
 	select RADIO_TEA575X
+
 	help
 	  Say Y here to include support for TEA5757 radio tuner integrated on
 	  some MediaForte cards (e.g. SF64-PCE2).
@@ -561,6 +563,7 @@ config SND_FM801_TEA575X_BOOL
 	depends on SND_FM801
 	depends on MEDIA_RADIO_SUPPORT
 	depends on VIDEO_V4L2=y || VIDEO_V4L2=SND_FM801
+	select RADIO_ADAPTERS
 	select RADIO_TEA575X
 	help
 	  Say Y here to include support for soundcards based on the ForteMedia
-- 
1.8.3.1

