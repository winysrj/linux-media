Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f51.google.com ([209.85.192.51]:34546 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108AbbHMTh4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Aug 2015 15:37:56 -0400
Received: by qgeg42 with SMTP id g42so38593139qge.1
        for <linux-media@vger.kernel.org>; Thu, 13 Aug 2015 12:37:55 -0700 (PDT)
Date: Thu, 13 Aug 2015 16:37:51 -0300
From: Nicolas Sugino <nsugino@3way.com.ar>
To: mchehab@osg.samsung.com, awalls@md.metrocast.net,
	linux-media@vger.kernel.org
Subject: [PATCH] ivtv-alsa: Add index to specify device number
Message-ID: <20150813193748.GA17225@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When using multiple capture cards, it migth be necessary to identify a specific device with an ALSA one. If not, the order of the ALSA devices might have no relation to the id of the radio or video device.

Signed-off-by: Nicolas Sugino <nsugino@3way.com.ar>
---
 drivers/media/pci/ivtv/ivtv-alsa-main.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/ivtv/ivtv-alsa-main.c b/drivers/media/pci/ivtv/ivtv-alsa-main.c
index 41fa215..034908c 100644
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
@@ -146,7 +151,7 @@ static int snd_ivtv_init(struct v4l2_device *v4l2_dev)
 
 	/* (2) Create a card instance */
 	ret = snd_card_new(&itv->pdev->dev,
-			   SNDRV_DEFAULT_IDX1, /* use first available id */
+			   index[itv->instance] == -1 ? SNDRV_DEFAULT_IDX1 : index[itv->instance], /* use first available id if not specified otherwise*/
 			   SNDRV_DEFAULT_STR1, /* xid from end of shortname*/
 			   THIS_MODULE, 0, &sc);
 	if (ret) {
@@ -196,6 +201,9 @@ static int snd_ivtv_init(struct v4l2_device *v4l2_dev)
 		goto err_exit_free;
 	}
 
+	IVTV_ALSA_INFO("%s:: Instance %d registered ALSA card %d\n",
+			 __func__, itv->instance, index[itv->instance]);
+
 	return 0;
 
 err_exit_free:
-- 
2.1.4

