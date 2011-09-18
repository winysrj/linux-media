Return-path: <linux-media-owner@vger.kernel.org>
Received: from fallback1.mail.ru ([94.100.176.18]:43159 "EHLO
	fallback1.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab1IRPgn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Sep 2011 11:36:43 -0400
Received: from smtp14.mail.ru (smtp14.mail.ru [94.100.176.91])
	by fallback1.mail.ru (mPOP.Fallback_MX) with ESMTP id 4E29547ABA9B
	for <linux-media@vger.kernel.org>; Sun, 18 Sep 2011 19:19:16 +0400 (MSD)
Message-ID: <4E760BCA.6080900@list.ru>
Date: Sun, 18 Sep 2011 19:18:34 +0400
From: Stas Sergeev <stsp@list.ru>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org,
	"Nickolay V. Shmyrev" <nshmyrev@yandex.ru>,
	Lennart Poettering <lpoetter@redhat.com>,
	ALSA devel <alsa-devel@alsa-project.org>
Subject: Re: [patch][saa7134] do not change mute state for capturing audio
References: <4E19D2F7.6060803@list.ru> <4E22AF12.4020600@list.ru> <4E22CCC0.8030803@infradead.org> <4E24BEB8.4060501@redhat.com> <4E257FF5.4040401@infradead.org> <4E258B60.6010007@list.ru> <4E25906D.3020200@infradead.org> <4E259B0C.90107@list.ru> <4E25A26A.2000204@infradead.org> <4E25A7C2.3050609@list.ru> <4E25C7AE.5020503@infradead.org> <4E25CF35.7000802@list.ru> <4E25DB37.8020609@infradead.org> <4E25FDE4.7040805@list.ru> <4E262772.9060509@infradead.org> <4E266799.8030706@list.ru> <4E26AEC0.5000405@infradead.org> <4E26B1E7.2080107@list.ru> <4E26B29B.4010109@infradead.org> <4E292BED.60108@list.ru> <4E296D00.9040608@infradead.org> <4E296F6C.9080107@list.ru> <4E2971D4.1060109@infradead.org> <4E29738F.7040605@list.ru> <4E297505.7090307@infradead.org> <4E29E02A.1020402@list.ru> <4E2A23C7.3040209@infradead.org> <4E2A7BF0.8080606@list.ru> <4E2AC742.8020407@infradead.org> <4E2ACAAD.4050602@list.ru> <4E2AE40F.7030108@infradead.org> <4E2C5A35.9030404@list.ru> <4E2C6638.2040707@infrade
 ad.org>
In-Reply-To: <4E2C6638.2040707@infradead.org>
Content-Type: multipart/mixed;
 boundary="------------080905040006020600030205"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080905040006020600030205
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Mauro, I've finally found the time (and an energy)
to go look into the automute breakage.
With the attached automute fix I no longer have
any problems with pulseaudio.
I also attached the patch that introduces an "std"
option to limit the scan list, resulting in a faster scan.
It is completely unrelated to the automute one, it is
here just in case.
What do you think?


--------------080905040006020600030205
Content-Type: text/x-patch;
 name="0001-saa7134-fix-automute.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-saa7134-fix-automute.patch"

>From ccdfa126e98b5484f4a08de591ac8d89f775251c Mon Sep 17 00:00:00 2001
From: Stas Sergeev <stsp@users.sourceforge.net>
Date: Sun, 18 Sep 2011 19:06:21 +0400
Subject: [PATCH 1/2] saa7134: fix automute

---
 drivers/media/video/saa7134/saa7134-tvaudio.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/saa7134/saa7134-tvaudio.c b/drivers/media/video/saa7134/saa7134-tvaudio.c
index 57e646b..62a6287 100644
--- a/drivers/media/video/saa7134/saa7134-tvaudio.c
+++ b/drivers/media/video/saa7134/saa7134-tvaudio.c
@@ -332,7 +332,7 @@ static int tvaudio_checkcarrier(struct saa7134_dev *dev, struct mainscan *scan)
 {
 	__s32 left,right,value;
 
-	if (audio_debug > 1) {
+	if (audio_debug > 1 && (dev->tvnorm->id & scan->std)) {
 		int i;
 		dprintk("debug %d:",scan->carr);
 		for (i = -150; i <= 150; i += 30) {
@@ -546,6 +546,7 @@ static int tvaudio_thread(void *data)
 				dev->tvnorm->name, carrier/1000, carrier%1000,
 				max1, max2);
 			dev->last_carrier = carrier;
+			dev->automute = !(dev->thread.scan1 > 1);
 
 		} else if (0 != dev->last_carrier) {
 			/* no carrier -- try last detected one as fallback */
@@ -553,6 +554,7 @@ static int tvaudio_thread(void *data)
 			dprintk("audio carrier scan failed, "
 				"using %d.%03d MHz [last detected]\n",
 				carrier/1000, carrier%1000);
+			dev->automute = 1;
 
 		} else {
 			/* no carrier + no fallback -- use default */
@@ -560,9 +562,9 @@ static int tvaudio_thread(void *data)
 			dprintk("audio carrier scan failed, "
 				"using %d.%03d MHz [default]\n",
 				carrier/1000, carrier%1000);
+			dev->automute = 1;
 		}
 		tvaudio_setcarrier(dev,carrier,carrier);
-		dev->automute = 0;
 		saa_andorb(SAA7134_STEREO_DAC_OUTPUT_SELECT, 0x30, 0x00);
 		saa7134_tvaudio_setmute(dev);
 		/* find the exact tv audio norm */
@@ -1020,6 +1022,7 @@ int saa7134_tvaudio_init2(struct saa7134_dev *dev)
 	}
 
 	dev->thread.thread = NULL;
+	dev->thread.scan1 = dev->thread.scan2 = 0;
 	if (my_thread) {
 		saa7134_tvaudio_init(dev);
 		/* start tvaudio thread */
-- 
1.7.6


--------------080905040006020600030205
Content-Type: text/x-patch;
 name="0002-saa7134-introduce-std-module-parameter-to-force-vide.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-saa7134-introduce-std-module-parameter-to-force-vide.pa";
 filename*1="tch"

>From 70709f12f7161c98cb7ebae104b520dc30c6bd53 Mon Sep 17 00:00:00 2001
From: Stas Sergeev <stsp@users.sourceforge.net>
Date: Sun, 18 Sep 2011 19:13:05 +0400
Subject: [PATCH 2/2] saa7134: introduce "std" module parameter to force video
 std

---
 drivers/media/video/saa7134/saa7134-video.c |   39 ++++++++++++++++++++++++--
 drivers/media/video/saa7134/saa7134.h       |    1 +
 2 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/saa7134/saa7134-video.c b/drivers/media/video/saa7134/saa7134-video.c
index 776ba2d..04ac7de 100644
--- a/drivers/media/video/saa7134/saa7134-video.c
+++ b/drivers/media/video/saa7134/saa7134-video.c
@@ -40,12 +40,15 @@ static unsigned int noninterlaced; /* 0 */
 static unsigned int gbufsize      = 720*576*4;
 static unsigned int gbufsize_max  = 720*576*4;
 static char secam[] = "--";
+static char std[16] = "--";
 module_param(video_debug, int, 0644);
 MODULE_PARM_DESC(video_debug,"enable debug messages [video]");
 module_param(gbuffers, int, 0444);
 MODULE_PARM_DESC(gbuffers,"number of capture buffers, range 2-32");
 module_param(noninterlaced, int, 0644);
 MODULE_PARM_DESC(noninterlaced,"capture non interlaced video");
+module_param_string(std, std, sizeof(std), 0644);
+MODULE_PARM_DESC(secam, "force TV standard, either PAL, SECAM or NTSC");
 module_param_string(secam, secam, sizeof(secam), 0644);
 MODULE_PARM_DESC(secam, "force SECAM variant, either DK,L or Lc");
 
@@ -1847,14 +1850,20 @@ int saa7134_s_std_internal(struct saa7134_dev *dev, struct saa7134_fh *fh, v4l2_
 		return -EBUSY;
 	}
 
-	for (i = 0; i < TVNORMS; i++)
+	for (i = 0; i < TVNORMS; i++) {
+		if (!tvnorms[i].enabled)
+			continue;
 		if (*id == tvnorms[i].id)
 			break;
+	}
 
 	if (i == TVNORMS)
-		for (i = 0; i < TVNORMS; i++)
+		for (i = 0; i < TVNORMS; i++) {
+			if (!tvnorms[i].enabled)
+				continue;
 			if (*id & tvnorms[i].id)
 				break;
+		}
 	if (i == TVNORMS)
 		return -EINVAL;
 
@@ -1871,6 +1880,8 @@ int saa7134_s_std_internal(struct saa7134_dev *dev, struct saa7134_fh *fh, v4l2_
 				fixup = V4L2_STD_SECAM;
 		}
 		for (i = 0; i < TVNORMS; i++) {
+			if (!tvnorms[i].enabled)
+				continue;
 			if (fixup == tvnorms[i].id)
 				break;
 		}
@@ -2579,8 +2590,30 @@ int saa7134_videoport_init(struct saa7134_dev *dev)
 
 int saa7134_video_init2(struct saa7134_dev *dev)
 {
+	int i, idx = -1;
+	for (i = 0; i < TVNORMS; i++) {
+		int enable = (std[0] == '-' || strncasecmp(std,
+				tvnorms[i].name, strlen(std)) == 0);
+
+		if (secam[0] != '-') {
+			char buf[16] = "SECAM";
+			if (strncasecmp(buf, tvnorms[i].name,
+					strlen(buf)) == 0) {
+				strcat(buf, "-");
+				strcat(buf, secam);
+				if (strncasecmp(buf, tvnorms[i].name,
+						strlen(buf)) != 0)
+					enable = 0;
+			}
+		}
+		tvnorms[i].enabled = enable;
+		if (enable && idx == -1)
+			idx = i;
+	}
+	if (idx == -1)
+		return -EINVAL;
 	/* init video hw */
-	set_tvnorm(dev,&tvnorms[0]);
+	set_tvnorm(dev,&tvnorms[idx]);
 	video_mux(dev,0);
 	saa7134_tvaudio_setmute(dev);
 	saa7134_tvaudio_setvolume(dev,dev->ctl_volume);
diff --git a/drivers/media/video/saa7134/saa7134.h b/drivers/media/video/saa7134/saa7134.h
index 28eb103..a0eddce 100644
--- a/drivers/media/video/saa7134/saa7134.h
+++ b/drivers/media/video/saa7134/saa7134.h
@@ -77,6 +77,7 @@ enum saa7134_video_out {
 struct saa7134_tvnorm {
 	char          *name;
 	v4l2_std_id   id;
+	int enabled;
 
 	/* video decoder */
 	unsigned int  sync_control;
-- 
1.7.6


--------------080905040006020600030205--
