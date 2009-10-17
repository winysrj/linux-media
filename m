Return-path: <linux-media-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:36128 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbZJQGjj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Oct 2009 02:39:39 -0400
Date: Sat, 17 Oct 2009 08:39:41 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH 6/14] drivers/media/video: Move dereference after NULL test
Message-ID: <Pine.LNX.4.64.0910170839070.9213@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Julia Lawall <julia@diku.dk>

In quickcam_messenger.c, if the NULL test on uvd is needed, then the
dereference should be after the NULL test.

In vpif_display.c, std_info is initialized to the address of a structure
field.  This seems unlikely to be NULL.  If it could somehow be NULL, then
the assignment should be moved after the NULL test.  Alternatively, perhaps
the NULL test is intended to test std_info->stdid rather than std_info?

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
 drivers/media/video/davinci/vpif_display.c        |    2 --
 drivers/media/video/saa7134/saa7134-alsa.c        |    2 --
 drivers/media/video/usbvideo/quickcam_messenger.c |    3 ++-
 3 files changed, 2 insertions(+), 5 deletions(-)

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
diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index c015da8..7500411 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -383,8 +383,6 @@ static int vpif_get_std_info(struct channel_obj *ch)
 	int index;
 
 	std_info->stdid = vid_ch->stdid;
-	if (!std_info)
-		return -1;
 
 	for (index = 0; index < ARRAY_SIZE(ch_params); index++) {
 		config = &ch_params[index];
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
