Return-path: <linux-media-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:54344 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973Ab0CLG3F (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Mar 2010 01:29:05 -0500
Date: Fri, 12 Mar 2010 07:28:59 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"mchehab@infradead.org" <mchehab@infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: [patch 2/5] drivers/media/video: move dereference after NULL
 test
In-Reply-To: <A69FA2915331DC488A831521EAE36FE4016A5A3F25@dlee06.ent.ti.com>
Message-ID: <Pine.LNX.4.64.1003120728380.1009@ask.diku.dk>
References: <201003112202.o2BM2HpB013125@imap1.linux-foundation.org>
 <A69FA2915331DC488A831521EAE36FE4016A5A3F25@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Oops, my mistake.  I will fix that.

julia


On Thu, 11 Mar 2010, Karicheri, Muralidharan wrote:

> 
> >-----Original Message-----
> >From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> >owner@vger.kernel.org] On Behalf Of akpm@linux-foundation.org
> >Sent: Thursday, March 11, 2010 5:02 PM
> >To: mchehab@infradead.org
> >Cc: linux-media@vger.kernel.org; akpm@linux-foundation.org; julia@diku.dk
> >Subject: [patch 2/5] drivers/media/video: move dereference after NULL test
> >
> >From: Julia Lawall <julia@diku.dk>
> >
> >In quickcam_messenger.c, if the NULL test on uvd is needed, then the
> >dereference should be after the NULL test.
> >
> >In vpif_display.c, std_info is initialized to the address of a structure
> >field.  This seems unlikely to be NULL.  If it could somehow be NULL, then
> >the assignment should be moved after the NULL test.  Alternatively, perhaps
> >the NULL test is intended to test std_info->stdid rather than std_info?
> >
> >In saa7134-alsa.c, the function is only called from one place, where the
> >chip argument has already been dereferenced.  On the other hand, if it
> >should be kept, then card should be initialized after it.
> >
> >A simplified version of the semantic match that detects this problem is as
> >follows (http://coccinelle.lip6.fr/):
> >
> >// <smpl>
> >@match exists@
> >expression x, E;
> >identifier fld;
> >@@
> >
> >* x->fld
> >  ... when != \(x = E\|&x\)
> >* x == NULL
> >// </smpl>
> >
> >Signed-off-by: Julia Lawall <julia@diku.dk>
> >Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> >Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >---
> >
> > drivers/media/video/davinci/vpif_display.c        |    2 --
> > drivers/media/video/saa7134/saa7134-alsa.c        |    2 --
> > drivers/media/video/usbvideo/quickcam_messenger.c |    3 ++-
> > 3 files changed, 2 insertions(+), 5 deletions(-)
> >
> >diff -puN drivers/media/video/davinci/vpif_display.c~drivers-media-video-
> >move-dereference-after-null-test drivers/media/video/davinci/vpif_display.c
> >--- a/drivers/media/video/davinci/vpif_display.c~drivers-media-video-move-
> >dereference-after-null-test
> >+++ a/drivers/media/video/davinci/vpif_display.c
> >@@ -383,8 +383,6 @@ static int vpif_get_std_info(struct chan
> > 	int index;
> >
> > 	std_info->stdid = vid_ch->stdid;
> >-	if (!std_info)
> >-		return -1;
> 
> Please change it as 
> 
> if (!std_info->stdid)
> 	return -1;
> 
> Murali	
> >
> > 	for (index = 0; index < ARRAY_SIZE(ch_params); index++) {
> > 		config = &ch_params[index];
> >diff -puN drivers/media/video/saa7134/saa7134-alsa.c~drivers-media-video-
> >move-dereference-after-null-test drivers/media/video/saa7134/saa7134-alsa.c
> >--- a/drivers/media/video/saa7134/saa7134-alsa.c~drivers-media-video-move-
> >dereference-after-null-test
> >+++ a/drivers/media/video/saa7134/saa7134-alsa.c
> >@@ -1011,8 +1011,6 @@ static int snd_card_saa7134_new_mixer(sn
> > 	unsigned int idx;
> > 	int err, addr;
> >
> >-	if (snd_BUG_ON(!chip))
> >-		return -EINVAL;
> > 	strcpy(card->mixername, "SAA7134 Mixer");
> >
> > 	for (idx = 0; idx < ARRAY_SIZE(snd_saa7134_volume_controls); idx++) {
> >diff -puN drivers/media/video/usbvideo/quickcam_messenger.c~drivers-media-
> >video-move-dereference-after-null-test
> >drivers/media/video/usbvideo/quickcam_messenger.c
> >--- a/drivers/media/video/usbvideo/quickcam_messenger.c~drivers-media-
> >video-move-dereference-after-null-test
> >+++ a/drivers/media/video/usbvideo/quickcam_messenger.c
> >@@ -692,12 +692,13 @@ static int qcm_start_data(struct uvd *uv
> >
> > static void qcm_stop_data(struct uvd *uvd)
> > {
> >-	struct qcm *cam = (struct qcm *) uvd->user_data;
> >+	struct qcm *cam;
> > 	int i, j;
> > 	int ret;
> >
> > 	if ((uvd == NULL) || (!uvd->streaming) || (uvd->dev == NULL))
> > 		return;
> >+	cam = (struct qcm *) uvd->user_data;
> >
> > 	ret = qcm_camera_off(uvd);
> > 	if (ret)
> >_
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-media" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
