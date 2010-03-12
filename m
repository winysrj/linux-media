Return-path: <linux-media-owner@vger.kernel.org>
Received: from mgw1.diku.dk ([130.225.96.91]:52935 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756908Ab0CLJPi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Mar 2010 04:15:38 -0500
Date: Fri, 12 Mar 2010 10:15:32 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"mchehab@infradead.org" <mchehab@infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: [patch 2/5] drivers/media/video: move dereference after NULL
 test
In-Reply-To: <Pine.LNX.4.64.1003120728380.1009@ask.diku.dk>
Message-ID: <Pine.LNX.4.64.1003121014270.3043@ask.diku.dk>
References: <201003112202.o2BM2HpB013125@imap1.linux-foundation.org>
 <A69FA2915331DC488A831521EAE36FE4016A5A3F25@dlee06.ent.ti.com>
 <Pine.LNX.4.64.1003120728380.1009@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Julia Lawall <julia@diku.dk>

In quickcam_messenger.c, if the NULL test on uvd is needed, then the
dereference should be after the NULL test.

In vpif_display.c, std_info is initialized to the address of a structure
field.  This seems unlikely to be NULL.  Test std_info->stdid instead.

In saa7134-alsa.c, the function is only called from one place, where the
chip argument has already been dereferenced.  On the other hand, if it
should be kept, then card should be initialized after it.

A simplified version of the semantic match that detects this problem is as
follows (http://coccinelle.lip6.fr/):

// <smpl>
@match exists@
expression x, E;
identifier fld;
@@

* x->fld
  ... when != \(x = E\|&x\)
* x == NULL
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/media/video/davinci/vpif_display.c        |    2 +-
 drivers/media/video/saa7134/saa7134-alsa.c        |    2 --
 drivers/media/video/usbvideo/quickcam_messenger.c |    3 ++-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/usbvideo/quickcam_messenger.c b/drivers/media/video/usbvideo/quickcam_messenger.c
index 803d3e4..f0043d0 100644
--- a/drivers/media/video/usbvideo/quickcam_messenger.c
+++ b/drivers/media/video/usbvideo/quickcam_messenger.c
@@ -692,12 +692,13 @@ static int qcm_start_data(struct uvd *uvd)
 
 static void qcm_stop_data(struct uvd *uvd)
 {
-	struct qcm *cam = (struct qcm *) uvd->user_data;
+	struct qcm *cam;
 	int i, j;
 	int ret;
 
 	if ((uvd == NULL) || (!uvd->streaming) || (uvd->dev == NULL))
 		return;
+	cam = (struct qcm *) uvd->user_data;
 
 	ret = qcm_camera_off(uvd);
 	if (ret)
diff --git a/drivers/media/video/saa7134/saa7134-alsa.c b/drivers/media/video/saa7134/saa7134-alsa.c
index d48c450..d3bd82a 100644
--- a/drivers/media/video/saa7134/saa7134-alsa.c
+++ b/drivers/media/video/saa7134/saa7134-alsa.c
@@ -1011,8 +1011,6 @@ static int snd_card_saa7134_new_mixer(snd_card_saa7134_t * chip)
 	unsigned int idx;
 	int err, addr;
 
-	if (snd_BUG_ON(!chip))
-		return -EINVAL;
 	strcpy(card->mixername, "SAA7134 Mixer");
 
 	for (idx = 0; idx < ARRAY_SIZE(snd_saa7134_volume_controls); idx++) {
diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index dfddef7..b2dce78 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -383,7 +383,7 @@ static int vpif_get_std_info(struct channel_obj *ch)
 	int index;
 
 	std_info->stdid = vid_ch->stdid;
-	if (!std_info)
+	if (!std_info->stdid)
 		return -1;
 
 	for (index = 0; index < ARRAY_SIZE(ch_params); index++) {
