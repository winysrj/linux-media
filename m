Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235Ab2ETBVc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 19 May 2012 21:21:32 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Ondrej Zary <linux@rainbow-software.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 3/6] snd_tea575x: Report correct frequency range for EU/US versus JA models
Date: Sun, 20 May 2012 03:25:28 +0200
Message-Id: <1337477131-21578-4-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1337477131-21578-1-git-send-email-hdegoede@redhat.com>
References: <1337477131-21578-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

My EU/US 5757 cannot tune below approx 86 Mhz, that is below that it
does not even generate the standard not tuned to anything radio noise anymore,
so clearly the 5757 cannot tune to the Japanese frequencies. This patch
assumes that likewise the 5759 cannot tune to the EU/US frequencies.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
CC: Ondrej Zary <linux@rainbow-software.org>
---
 sound/i2c/other/tea575x-tuner.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/i2c/other/tea575x-tuner.c b/sound/i2c/other/tea575x-tuner.c
index da49dd4..ddc08a8 100644
--- a/sound/i2c/other/tea575x-tuner.c
+++ b/sound/i2c/other/tea575x-tuner.c
@@ -37,8 +37,8 @@ MODULE_AUTHOR("Jaroslav Kysela <perex@perex.cz>");
 MODULE_DESCRIPTION("Routines for control of TEA5757/5759 Philips AM/FM radio tuner chips");
 MODULE_LICENSE("GPL");
 
-#define FREQ_LO		 (76U * 16000)
-#define FREQ_HI		(108U * 16000)
+#define FREQ_LO		((tea->tea5759 ? 760 :  875) * 1600U)
+#define FREQ_HI		((tea->tea5759 ? 910 : 1080) * 1600U)
 
 /*
  * definitions
-- 
1.7.10

