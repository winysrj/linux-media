Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:52458 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757505Ab2INK6O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 06:58:14 -0400
Received: from cobaltpc1.cisco.com (dhcp-10-54-92-107.cisco.com [10.54.92.107])
	by ams-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id q8EAvqBs013688
	for <linux-media@vger.kernel.org>; Fri, 14 Sep 2012 10:57:58 GMT
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFCv3 API PATCH 23/31] v4l2: make vidioc_s_audio const.
Date: Fri, 14 Sep 2012 12:57:38 +0200
Message-Id: <3eec2617089f694cc08becfd937c28cbc7c9116c.1347619766.git.hans.verkuil@cisco.com>
In-Reply-To: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com>
References: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <7447a305817a5e6c63f089c2e1e948533f1d57ea.1347619765.git.hans.verkuil@cisco.com>
References: <7447a305817a5e6c63f089c2e1e948533f1d57ea.1347619765.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Write-only ioctls should have a const argument in the ioctl op.

Do this conversion for vidioc_s_audio.

Adding const for write-only ioctls was decided during the 2012 Media Workshop.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/bt8xx/bttv-driver.c         |    4 ++--
 drivers/media/pci/cx18/cx18-ioctl.c           |    2 +-
 drivers/media/pci/cx23885/cx23885-video.c     |    2 +-
 drivers/media/pci/ivtv/ivtv-ioctl.c           |    2 +-
 drivers/media/pci/saa7134/saa7134-video.c     |    4 ++--
 drivers/media/pci/saa7146/mxb.c               |    2 +-
 drivers/media/pci/ttpci/av7110_v4l.c          |    2 +-
 drivers/media/radio/radio-miropcm20.c         |    2 +-
 drivers/media/radio/radio-sf16fmi.c           |    2 +-
 drivers/media/radio/radio-tea5764.c           |    2 +-
 drivers/media/radio/radio-timb.c              |    2 +-
 drivers/media/radio/radio-wl1273.c            |    2 +-
 drivers/media/radio/wl128x/fmdrv_v4l2.c       |    2 +-
 drivers/media/usb/au0828/au0828-video.c       |    2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c     |    4 ++--
 drivers/media/usb/em28xx/em28xx-video.c       |    4 ++--
 drivers/media/usb/hdpvr/hdpvr-video.c         |    2 +-
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c      |    2 +-
 drivers/media/usb/tlg2300/pd-radio.c          |    2 +-
 drivers/media/usb/tlg2300/pd-video.c          |    2 +-
 drivers/media/usb/tm6000/tm6000-video.c       |    2 +-
 drivers/media/usb/usbvision/usbvision-video.c |    2 +-
 include/media/v4l2-ioctl.h                    |    2 +-
 23 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 26bf309..31b2826 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -3076,7 +3076,7 @@ static int bttv_g_audio(struct file *file, void *priv, struct v4l2_audio *a)
 	return 0;
 }
 
-static int bttv_s_audio(struct file *file, void *priv, struct v4l2_audio *a)
+static int bttv_s_audio(struct file *file, void *priv, const struct v4l2_audio *a)
 {
 	if (unlikely(a->index))
 		return -EINVAL;
@@ -3480,7 +3480,7 @@ static int radio_s_tuner(struct file *file, void *priv,
 }
 
 static int radio_s_audio(struct file *file, void *priv,
-					struct v4l2_audio *a)
+					const struct v4l2_audio *a)
 {
 	if (unlikely(a->index))
 		return -EINVAL;
diff --git a/drivers/media/pci/cx18/cx18-ioctl.c b/drivers/media/pci/cx18/cx18-ioctl.c
index 51675bc..ffc00ef 100644
--- a/drivers/media/pci/cx18/cx18-ioctl.c
+++ b/drivers/media/pci/cx18/cx18-ioctl.c
@@ -492,7 +492,7 @@ static int cx18_g_audio(struct file *file, void *fh, struct v4l2_audio *vin)
 	return cx18_get_audio_input(cx, vin->index, vin);
 }
 
-static int cx18_s_audio(struct file *file, void *fh, struct v4l2_audio *vout)
+static int cx18_s_audio(struct file *file, void *fh, const struct v4l2_audio *vout)
 {
 	struct cx18 *cx = fh2id(fh)->cx;
 
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index 22f8e7f..8c4a9a5 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -1426,7 +1426,7 @@ static int vidioc_g_audinput(struct file *file, void *priv,
 }
 
 static int vidioc_s_audinput(struct file *file, void *priv,
-	struct v4l2_audio *i)
+	const struct v4l2_audio *i)
 {
 	struct cx23885_dev *dev = ((struct cx23885_fh *)priv)->dev;
 	if (i->index >= 2)
diff --git a/drivers/media/pci/ivtv/ivtv-ioctl.c b/drivers/media/pci/ivtv/ivtv-ioctl.c
index 966abb4..99e35dd 100644
--- a/drivers/media/pci/ivtv/ivtv-ioctl.c
+++ b/drivers/media/pci/ivtv/ivtv-ioctl.c
@@ -784,7 +784,7 @@ static int ivtv_g_audio(struct file *file, void *fh, struct v4l2_audio *vin)
 	return ivtv_get_audio_input(itv, vin->index, vin);
 }
 
-static int ivtv_s_audio(struct file *file, void *fh, struct v4l2_audio *vout)
+static int ivtv_s_audio(struct file *file, void *fh, const struct v4l2_audio *vout)
 {
 	struct ivtv *itv = fh2id(fh)->itv;
 
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index bac4386..135bfd8 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -2089,7 +2089,7 @@ static int saa7134_g_audio(struct file *file, void *priv, struct v4l2_audio *a)
 	return 0;
 }
 
-static int saa7134_s_audio(struct file *file, void *priv, struct v4l2_audio *a)
+static int saa7134_s_audio(struct file *file, void *priv, const struct v4l2_audio *a)
 {
 	return 0;
 }
@@ -2373,7 +2373,7 @@ static int radio_g_audio(struct file *file, void *priv,
 }
 
 static int radio_s_audio(struct file *file, void *priv,
-					struct v4l2_audio *a)
+					const struct v4l2_audio *a)
 {
 	return 0;
 }
diff --git a/drivers/media/pci/saa7146/mxb.c b/drivers/media/pci/saa7146/mxb.c
index b520a45..91369da 100644
--- a/drivers/media/pci/saa7146/mxb.c
+++ b/drivers/media/pci/saa7146/mxb.c
@@ -646,7 +646,7 @@ static int vidioc_g_audio(struct file *file, void *fh, struct v4l2_audio *a)
 	return 0;
 }
 
-static int vidioc_s_audio(struct file *file, void *fh, struct v4l2_audio *a)
+static int vidioc_s_audio(struct file *file, void *fh, const struct v4l2_audio *a)
 {
 	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
 	struct mxb *mxb = (struct mxb *)dev->ext_priv;
diff --git a/drivers/media/pci/ttpci/av7110_v4l.c b/drivers/media/pci/ttpci/av7110_v4l.c
index 1b2d151..730e906 100644
--- a/drivers/media/pci/ttpci/av7110_v4l.c
+++ b/drivers/media/pci/ttpci/av7110_v4l.c
@@ -526,7 +526,7 @@ static int vidioc_g_audio(struct file *file, void *fh, struct v4l2_audio *a)
 	return 0;
 }
 
-static int vidioc_s_audio(struct file *file, void *fh, struct v4l2_audio *a)
+static int vidioc_s_audio(struct file *file, void *fh, const struct v4l2_audio *a)
 {
 	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
 	struct av7110 *av7110 = (struct av7110 *)dev->ext_priv;
diff --git a/drivers/media/radio/radio-miropcm20.c b/drivers/media/radio/radio-miropcm20.c
index 87c1ee1..11f76ed 100644
--- a/drivers/media/radio/radio-miropcm20.c
+++ b/drivers/media/radio/radio-miropcm20.c
@@ -197,7 +197,7 @@ static int vidioc_g_audio(struct file *file, void *priv,
 }
 
 static int vidioc_s_audio(struct file *file, void *priv,
-				struct v4l2_audio *a)
+				const struct v4l2_audio *a)
 {
 	return a->index ? -EINVAL : 0;
 }
diff --git a/drivers/media/radio/radio-sf16fmi.c b/drivers/media/radio/radio-sf16fmi.c
index 8185d5f..227dcdb 100644
--- a/drivers/media/radio/radio-sf16fmi.c
+++ b/drivers/media/radio/radio-sf16fmi.c
@@ -239,7 +239,7 @@ static int vidioc_g_audio(struct file *file, void *priv,
 }
 
 static int vidioc_s_audio(struct file *file, void *priv,
-					struct v4l2_audio *a)
+					const struct v4l2_audio *a)
 {
 	return a->index ? -EINVAL : 0;
 }
diff --git a/drivers/media/radio/radio-tea5764.c b/drivers/media/radio/radio-tea5764.c
index 6b1fae3..efb05aa 100644
--- a/drivers/media/radio/radio-tea5764.c
+++ b/drivers/media/radio/radio-tea5764.c
@@ -448,7 +448,7 @@ static int vidioc_g_audio(struct file *file, void *priv,
 }
 
 static int vidioc_s_audio(struct file *file, void *priv,
-			   struct v4l2_audio *a)
+			   const struct v4l2_audio *a)
 {
 	if (a->index != 0)
 		return -EINVAL;
diff --git a/drivers/media/radio/radio-timb.c b/drivers/media/radio/radio-timb.c
index 09fc560..5cf0777 100644
--- a/drivers/media/radio/radio-timb.c
+++ b/drivers/media/radio/radio-timb.c
@@ -85,7 +85,7 @@ static int timbradio_vidioc_g_audio(struct file *file, void *priv,
 }
 
 static int timbradio_vidioc_s_audio(struct file *file, void *priv,
-	struct v4l2_audio *a)
+	const struct v4l2_audio *a)
 {
 	return a->index ? -EINVAL : 0;
 }
diff --git a/drivers/media/radio/radio-wl1273.c b/drivers/media/radio/radio-wl1273.c
index 71968a6..2d93354 100644
--- a/drivers/media/radio/radio-wl1273.c
+++ b/drivers/media/radio/radio-wl1273.c
@@ -1479,7 +1479,7 @@ static int wl1273_fm_vidioc_g_audio(struct file *file, void *priv,
 }
 
 static int wl1273_fm_vidioc_s_audio(struct file *file, void *priv,
-				    struct v4l2_audio *audio)
+				    const struct v4l2_audio *audio)
 {
 	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
 
diff --git a/drivers/media/radio/wl128x/fmdrv_v4l2.c b/drivers/media/radio/wl128x/fmdrv_v4l2.c
index f816ea6..09585a9 100644
--- a/drivers/media/radio/wl128x/fmdrv_v4l2.c
+++ b/drivers/media/radio/wl128x/fmdrv_v4l2.c
@@ -258,7 +258,7 @@ static int fm_v4l2_vidioc_g_audio(struct file *file, void *priv,
 }
 
 static int fm_v4l2_vidioc_s_audio(struct file *file, void *priv,
-		struct v4l2_audio *audio)
+		const struct v4l2_audio *audio)
 {
 	if (audio->index != 0)
 		return -EINVAL;
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index fa0fa9a..8705855 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -1465,7 +1465,7 @@ static int vidioc_g_audio(struct file *file, void *priv, struct v4l2_audio *a)
 	return 0;
 }
 
-static int vidioc_s_audio(struct file *file, void *priv, struct v4l2_audio *a)
+static int vidioc_s_audio(struct file *file, void *priv, const struct v4l2_audio *a)
 {
 	struct au0828_fh *fh = priv;
 	struct au0828_dev *dev = fh->dev;
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 790b28d..fedf785 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -1253,7 +1253,7 @@ static int vidioc_g_audio(struct file *file, void *priv, struct v4l2_audio *a)
 	return 0;
 }
 
-static int vidioc_s_audio(struct file *file, void *priv, struct v4l2_audio *a)
+static int vidioc_s_audio(struct file *file, void *priv, const struct v4l2_audio *a)
 {
 	struct cx231xx_fh *fh = priv;
 	struct cx231xx *dev = fh->dev;
@@ -2096,7 +2096,7 @@ static int radio_s_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
 	return 0;
 }
 
-static int radio_s_audio(struct file *file, void *fh, struct v4l2_audio *a)
+static int radio_s_audio(struct file *file, void *fh, const struct v4l2_audio *a)
 {
 	return 0;
 }
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 78d6ebd..1e553d3 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1352,7 +1352,7 @@ static int vidioc_g_audio(struct file *file, void *priv, struct v4l2_audio *a)
 	return 0;
 }
 
-static int vidioc_s_audio(struct file *file, void *priv, struct v4l2_audio *a)
+static int vidioc_s_audio(struct file *file, void *priv, const struct v4l2_audio *a)
 {
 	struct em28xx_fh   *fh  = priv;
 	struct em28xx      *dev = fh->dev;
@@ -2087,7 +2087,7 @@ static int radio_s_tuner(struct file *file, void *priv,
 }
 
 static int radio_s_audio(struct file *file, void *fh,
-			 struct v4l2_audio *a)
+			 const struct v4l2_audio *a)
 {
 	return 0;
 }
diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index 0e9e156..da6b779 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -677,7 +677,7 @@ static int vidioc_enumaudio(struct file *file, void *priv,
 }
 
 static int vidioc_s_audio(struct file *file, void *private_data,
-			  struct v4l2_audio *audio)
+			  const struct v4l2_audio *audio)
 {
 	struct hdpvr_fh *fh = file->private_data;
 	struct hdpvr_device *dev = fh->dev;
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
index f344aed..7a445b0 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
@@ -333,7 +333,7 @@ static int pvr2_g_audio(struct file *file, void *priv, struct v4l2_audio *vin)
 	return 0;
 }
 
-static int pvr2_s_audio(struct file *file, void *priv, struct v4l2_audio *vout)
+static int pvr2_s_audio(struct file *file, void *priv, const struct v4l2_audio *vout)
 {
 	if (vout->index)
 		return -EINVAL;
diff --git a/drivers/media/usb/tlg2300/pd-radio.c b/drivers/media/usb/tlg2300/pd-radio.c
index 4fad1df..25eeb16 100644
--- a/drivers/media/usb/tlg2300/pd-radio.c
+++ b/drivers/media/usb/tlg2300/pd-radio.c
@@ -348,7 +348,7 @@ static int vidioc_s_tuner(struct file *file, void *priv, struct v4l2_tuner *vt)
 {
 	return vt->index > 0 ? -EINVAL : 0;
 }
-static int vidioc_s_audio(struct file *file, void *priv, struct v4l2_audio *va)
+static int vidioc_s_audio(struct file *file, void *priv, const struct v4l2_audio *va)
 {
 	return (va->index != 0) ? -EINVAL : 0;
 }
diff --git a/drivers/media/usb/tlg2300/pd-video.c b/drivers/media/usb/tlg2300/pd-video.c
index bfbf9e5..1f448ac 100644
--- a/drivers/media/usb/tlg2300/pd-video.c
+++ b/drivers/media/usb/tlg2300/pd-video.c
@@ -1029,7 +1029,7 @@ static int vidioc_g_audio(struct file *file, void *fh, struct v4l2_audio *a)
 	return 0;
 }
 
-static int vidioc_s_audio(struct file *file, void *fh, struct v4l2_audio *a)
+static int vidioc_s_audio(struct file *file, void *fh, const struct v4l2_audio *a)
 {
 	return (0 == a->index) ? 0 : -EINVAL;
 }
diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index 45ed59c..4342cd4 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -1401,7 +1401,7 @@ static int radio_g_audio(struct file *file, void *priv,
 }
 
 static int radio_s_audio(struct file *file, void *priv,
-					struct v4l2_audio *a)
+					const struct v4l2_audio *a)
 {
 	return 0;
 }
diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index 8a43179..f67018e 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -684,7 +684,7 @@ static int vidioc_g_audio(struct file *file, void *priv, struct v4l2_audio *a)
 }
 
 static int vidioc_s_audio(struct file *file, void *fh,
-			  struct v4l2_audio *a)
+			  const struct v4l2_audio *a)
 {
 	if (a->index)
 		return -EINVAL;
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index 3eef4de..babbe09 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -167,7 +167,7 @@ struct v4l2_ioctl_ops {
 	int (*vidioc_g_audio)          (struct file *file, void *fh,
 					struct v4l2_audio *a);
 	int (*vidioc_s_audio)          (struct file *file, void *fh,
-					struct v4l2_audio *a);
+					const struct v4l2_audio *a);
 
 	/* Audio out ioctls */
 	int (*vidioc_enumaudout)       (struct file *file, void *fh,
-- 
1.7.10.4

