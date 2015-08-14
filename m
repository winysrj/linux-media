Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f52.google.com ([209.85.192.52]:36435 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbbHNRgP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Aug 2015 13:36:15 -0400
Received: by qgdd90 with SMTP id d90so55966304qgd.3
        for <linux-media@vger.kernel.org>; Fri, 14 Aug 2015 10:36:14 -0700 (PDT)
Date: Fri, 14 Aug 2015 14:36:11 -0300
From: Nicolas Sugino <nsugino@3way.com.ar>
To: awalls@md.metrocast.net, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, linux-media@vger.kernel.org
Subject: [PATCH v2] ivtv-alsa: Add index to specify device number
Message-ID: <20150814173607.GA8003@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When using multiple capture cards, it migth be necessary to identify a specific device with an ALSA one. If not, the order of the ALSA devices might have no relation to the id of the radio or video device.

Signed-off-by: Nicolas Sugino <nsugino@3way.com.ar>

---
Changelog:
v2:
	Shortened line size
	Fixed logging
---
 drivers/media/pci/ivtv/ivtv-alsa-main.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/ivtv/ivtv-alsa-main.c b/drivers/media/pci/ivtv/ivtv-alsa-main.c
index 41fa215..8a86b61 100644
--- a/drivers/media/pci/ivtv/ivtv-alsa-main.c
+++ b/drivers/media/pci/ivtv/ivtv-alsa-main.c
@@ -41,6 +41,7 @@
 #include "ivtv-alsa-pcm.h"
 
 int ivtv_alsa_debug;
+static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;
 
 #define IVTV_DEBUG_ALSA_INFO(fmt, arg...) \
 	do { \
@@ -54,6 +55,10 @@ MODULE_PARM_DESC(debug,
 		 "\t\t\t  1/0x0001: warning\n"
 		 "\t\t\t  2/0x0002: info\n");
 
+module_param_array(index, int, NULL, 0444);
+MODULE_PARM_DESC(index,
+		 "Index value for IVTV ALSA capture interface(s).\n");
+
 MODULE_AUTHOR("Andy Walls");
 MODULE_DESCRIPTION("CX23415/CX23416 ALSA Interface");
 MODULE_SUPPORTED_DEVICE("CX23415/CX23416 MPEG2 encoder");
@@ -137,7 +142,7 @@ static int snd_ivtv_init(struct v4l2_device *v4l2_dev)
 	struct ivtv *itv = to_ivtv(v4l2_dev);
 	struct snd_card *sc = NULL;
 	struct snd_ivtv_card *itvsc;
-	int ret;
+	int ret, idx;
 
 	/* Numbrs steps from "Writing an ALSA Driver" by Takashi Iwai */
 
@@ -145,8 +150,10 @@ static int snd_ivtv_init(struct v4l2_device *v4l2_dev)
 	/* This is a no-op for us.  We'll use the itv->instance */
 
 	/* (2) Create a card instance */
+	/* use first available id if not specified otherwise*/
+	idx = index[itv->instance] == -1 ? SNDRV_DEFAULT_IDX1 : index[itv->instance];
 	ret = snd_card_new(&itv->pdev->dev,
-			   SNDRV_DEFAULT_IDX1, /* use first available id */
+			   idx,
 			   SNDRV_DEFAULT_STR1, /* xid from end of shortname*/
 			   THIS_MODULE, 0, &sc);
 	if (ret) {
@@ -196,6 +203,9 @@ static int snd_ivtv_init(struct v4l2_device *v4l2_dev)
 		goto err_exit_free;
 	}
 
+	IVTV_ALSA_INFO("%s: Instance %d registered as ALSA card %d\n",
+			 __func__, itv->instance, sc->number);
+
 	return 0;
 
 err_exit_free:
-- 
2.1.4

