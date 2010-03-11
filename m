Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40538 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757330Ab0CKWC0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Mar 2010 17:02:26 -0500
Message-Id: <201003112202.o2BM2HpB013125@imap1.linux-foundation.org>
Subject: [patch 2/5] drivers/media/video: move dereference after NULL test
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, akpm@linux-foundation.org,
	julia@diku.dk
From: akpm@linux-foundation.org
Date: Thu, 11 Mar 2010 14:02:17 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/davinci/vpif_display.c        |    2 --
 drivers/media/video/saa7134/saa7134-alsa.c        |    2 --
 drivers/media/video/usbvideo/quickcam_messenger.c |    3 ++-
 3 files changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/media/video/davinci/vpif_display.c~drivers-media-video-move-dereference-after-null-test drivers/media/video/davinci/vpif_display.c
--- a/drivers/media/video/davinci/vpif_display.c~drivers-media-video-move-dereference-after-null-test
+++ a/drivers/media/video/davinci/vpif_display.c
@@ -383,8 +383,6 @@ static int vpif_get_std_info(struct chan
 	int index;
 
 	std_info->stdid = vid_ch->stdid;
-	if (!std_info)
-		return -1;
 
 	for (index = 0; index < ARRAY_SIZE(ch_params); index++) {
 		config = &ch_params[index];
diff -puN drivers/media/video/saa7134/saa7134-alsa.c~drivers-media-video-move-dereference-after-null-test drivers/media/video/saa7134/saa7134-alsa.c
--- a/drivers/media/video/saa7134/saa7134-alsa.c~drivers-media-video-move-dereference-after-null-test
+++ a/drivers/media/video/saa7134/saa7134-alsa.c
@@ -1011,8 +1011,6 @@ static int snd_card_saa7134_new_mixer(sn
 	unsigned int idx;
 	int err, addr;
 
-	if (snd_BUG_ON(!chip))
-		return -EINVAL;
 	strcpy(card->mixername, "SAA7134 Mixer");
 
 	for (idx = 0; idx < ARRAY_SIZE(snd_saa7134_volume_controls); idx++) {
diff -puN drivers/media/video/usbvideo/quickcam_messenger.c~drivers-media-video-move-dereference-after-null-test drivers/media/video/usbvideo/quickcam_messenger.c
--- a/drivers/media/video/usbvideo/quickcam_messenger.c~drivers-media-video-move-dereference-after-null-test
+++ a/drivers/media/video/usbvideo/quickcam_messenger.c
@@ -692,12 +692,13 @@ static int qcm_start_data(struct uvd *uv
 
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
_
