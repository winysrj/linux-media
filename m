Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38359 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756101AbbIUQBM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2015 12:01:12 -0400
From: Luis de Bethencourt <luisbg@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	linux-media@vger.kernel.org,
	Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: [PATCH] [media] cx25821, cx88, tm6000: use SNDRV_DEFAULT_ENABLE_PNP
Date: Mon, 21 Sep 2015 17:00:41 +0100
Message-Id: <1442851241-31278-1-git-send-email-luisbg@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of manually initializing the bool array enable, use the
SNDRV_DEFAULT_ENABLE_PNP macro. As most drivers do.

Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
---

Hi,

I don't see any good reason to use = 1 instead of = SNDRV_DEFAULT_ENABLE_PNP.
Semantically it is the same, and I don't find a purpose to explicitely set the
first element of the array separately.

The proposed patch makes these drivers consistent with the rest and more
readable. In a related note, maybe the dummy driver in sound/drivers/dummy.c
should be updated as well.

I can split this below fix into a patch per driver if that's better.

Thanks,
Luis

 drivers/media/pci/cx25821/cx25821-alsa.c | 2 +-
 drivers/media/pci/cx88/cx88-alsa.c       | 2 +-
 drivers/media/usb/tm6000/tm6000-alsa.c   | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-alsa.c b/drivers/media/pci/cx25821/cx25821-alsa.c
index 24f964b..b602eba 100644
--- a/drivers/media/pci/cx25821/cx25821-alsa.c
+++ b/drivers/media/pci/cx25821/cx25821-alsa.c
@@ -102,7 +102,7 @@ struct cx25821_audio_dev {
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static bool enable[SNDRV_CARDS] = { 1, [1 ... (SNDRV_CARDS - 1)] = 1 };
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
 
 module_param_array(enable, bool, NULL, 0444);
 MODULE_PARM_DESC(enable, "Enable cx25821 soundcard. default enabled.");
diff --git a/drivers/media/pci/cx88/cx88-alsa.c b/drivers/media/pci/cx88/cx88-alsa.c
index 7f8dc60..57ddf8a 100644
--- a/drivers/media/pci/cx88/cx88-alsa.c
+++ b/drivers/media/pci/cx88/cx88-alsa.c
@@ -101,7 +101,7 @@ typedef struct cx88_audio_dev snd_cx88_card_t;
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static const char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static bool enable[SNDRV_CARDS] = {1, [1 ... (SNDRV_CARDS - 1)] = 1};
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
 
 module_param_array(enable, bool, NULL, 0444);
 MODULE_PARM_DESC(enable, "Enable cx88x soundcard. default enabled.");
diff --git a/drivers/media/usb/tm6000/tm6000-alsa.c b/drivers/media/usb/tm6000/tm6000-alsa.c
index 74e5697..e21c7aa 100644
--- a/drivers/media/usb/tm6000/tm6000-alsa.c
+++ b/drivers/media/usb/tm6000/tm6000-alsa.c
@@ -42,7 +42,7 @@
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 
-static bool enable[SNDRV_CARDS] = {1, [1 ... (SNDRV_CARDS - 1)] = 1};
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
 
 module_param_array(enable, bool, NULL, 0444);
 MODULE_PARM_DESC(enable, "Enable tm6000x soundcard. default enabled.");
-- 
2.4.6

