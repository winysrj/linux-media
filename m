Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:49455
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754664AbdHYJkP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Aug 2017 05:40:15 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Andy Walls <awalls@md.metrocast.net>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Anton Sviridenko <anton@corp.bluecherry.net>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Ismael Luceno <ismael@iodev.co.uk>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Antti Palosaari <crope@iki.fi>, Mike Isely <isely@pobox.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Antoine Jacquet <royale@zerezo.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Geliang Tang <geliangtang@gmail.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Pan Bian <bianpan2016@163.com>,
        Colin Ian King <colin.king@canonical.com>,
        Santosh Kumar Singh <kumar.san1093@gmail.com>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Sims <jonathan.625266@earthlink.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Joe Perches <joe@perches.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Lubomir Rintel <lkundrak@v3.sk>,
        Johan Hovold <johan@kernel.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        mjpeg-users@lists.sourceforge.net,
        linux-renesas-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 3/3] media: add V4L2_CAP_VDEV_CENTERED flag on vdev-centric drivers
Date: Fri, 25 Aug 2017 06:40:07 -0300
Message-Id: <e0dfe1dc52d5c91bc75ffdb011a6714494409761.1503653839.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1503653839.git.mchehab@s-opensource.com>
References: <cover.1503653839.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1503653839.git.mchehab@s-opensource.com>
References: <cover.1503653839.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Those devices are controlled via their V4L2 device. Add a
flag to indicate them as such.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/bt8xx/bttv-driver.c          |  4 +++-
 drivers/media/pci/cobalt/cobalt-v4l2.c         |  3 ++-
 drivers/media/pci/cx18/cx18-ioctl.c            |  4 ++--
 drivers/media/pci/cx23885/cx23885-417.c        |  2 +-
 drivers/media/pci/cx23885/cx23885-video.c      |  3 ++-
 drivers/media/pci/cx25821/cx25821-video.c      |  6 ++++--
 drivers/media/pci/cx88/cx88-video.c            |  3 ++-
 drivers/media/pci/dt3155/dt3155.c              |  3 ++-
 drivers/media/pci/ivtv/ivtv-ioctl.c            |  5 +++--
 drivers/media/pci/meye/meye.c                  |  2 +-
 drivers/media/pci/saa7134/saa7134-video.c      |  3 ++-
 drivers/media/pci/saa7164/saa7164-encoder.c    |  3 ++-
 drivers/media/pci/saa7164/saa7164-vbi.c        |  3 ++-
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c |  3 ++-
 drivers/media/pci/solo6x10/solo6x10-v4l2.c     |  3 ++-
 drivers/media/pci/sta2x11/sta2x11_vip.c        |  3 ++-
 drivers/media/pci/tw5864/tw5864-video.c        |  2 +-
 drivers/media/pci/tw68/tw68-video.c            |  3 ++-
 drivers/media/pci/tw686x/tw686x-video.c        |  2 +-
 drivers/media/pci/zoran/zoran_driver.c         |  3 ++-
 drivers/media/platform/rcar_drif.c             |  3 ++-
 drivers/media/platform/vivid/vivid-core.c      |  2 +-
 drivers/media/usb/airspy/airspy.c              |  3 ++-
 drivers/media/usb/au0828/au0828-video.c        |  3 ++-
 drivers/media/usb/cpia2/cpia2_v4l.c            |  5 +++--
 drivers/media/usb/cx231xx/cx231xx-video.c      |  5 +++--
 drivers/media/usb/em28xx/em28xx-video.c        | 11 +++++++----
 drivers/media/usb/go7007/go7007-v4l2.c         |  2 +-
 drivers/media/usb/gspca/gspca.c                |  3 ++-
 drivers/media/usb/hackrf/hackrf.c              |  8 +++++---
 drivers/media/usb/hdpvr/hdpvr-video.c          |  2 +-
 drivers/media/usb/msi2500/msi2500.c            |  3 ++-
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c       |  6 ++++--
 drivers/media/usb/pwc/pwc-v4l.c                |  2 +-
 drivers/media/usb/s2255/s2255drv.c             |  2 +-
 drivers/media/usb/stk1160/stk1160-v4l.c        |  3 ++-
 drivers/media/usb/stkwebcam/stk-webcam.c       |  3 ++-
 drivers/media/usb/tm6000/tm6000-video.c        |  5 +++--
 drivers/media/usb/usbtv/usbtv-video.c          |  2 +-
 drivers/media/usb/usbvision/usbvision-video.c  |  5 +++--
 drivers/media/usb/uvc/uvc_v4l2.c               |  8 +++++---
 drivers/media/usb/zr364xx/zr364xx.c            |  5 +++--
 42 files changed, 96 insertions(+), 58 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 40110be4e986..382cc76b954b 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -2481,6 +2481,7 @@ static int bttv_querycap(struct file *file, void  *priv,
 		V4L2_CAP_VIDEO_CAPTURE |
 		V4L2_CAP_READWRITE |
 		V4L2_CAP_STREAMING |
+		V4L2_CAP_VDEV_CENTERED |
 		V4L2_CAP_DEVICE_CAPS;
 	if (no_overlay <= 0)
 		cap->capabilities |= V4L2_CAP_VIDEO_OVERLAY;
@@ -2511,7 +2512,8 @@ static int bttv_querycap(struct file *file, void  *priv,
 			 V4L2_CAP_STREAMING |
 			 V4L2_CAP_TUNER);
 	else {
-		cap->device_caps = V4L2_CAP_RADIO | V4L2_CAP_TUNER;
+		cap->device_caps = V4L2_CAP_RADIO | V4L2_CAP_TUNER |
+				   V4L2_CAP_VDEV_CENTERED;
 		if (btv->has_saa6588)
 			cap->device_caps |= V4L2_CAP_READWRITE |
 						V4L2_CAP_RDS_CAPTURE;
diff --git a/drivers/media/pci/cobalt/cobalt-v4l2.c b/drivers/media/pci/cobalt/cobalt-v4l2.c
index def4a3b37084..803a9cf09a9f 100644
--- a/drivers/media/pci/cobalt/cobalt-v4l2.c
+++ b/drivers/media/pci/cobalt/cobalt-v4l2.c
@@ -495,7 +495,8 @@ static int cobalt_querycap(struct file *file, void *priv_fh,
 	strlcpy(vcap->card, "cobalt", sizeof(vcap->card));
 	snprintf(vcap->bus_info, sizeof(vcap->bus_info),
 		 "PCIe:%s", pci_name(cobalt->pci_dev));
-	vcap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
+	vcap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_READWRITE |
+			    V4L2_CAP_VDEV_CENTERED;
 	if (s->is_output)
 		vcap->device_caps |= V4L2_CAP_VIDEO_OUTPUT;
 	else
diff --git a/drivers/media/pci/cx18/cx18-ioctl.c b/drivers/media/pci/cx18/cx18-ioctl.c
index 80b902b12a78..3e258fdc6685 100644
--- a/drivers/media/pci/cx18/cx18-ioctl.c
+++ b/drivers/media/pci/cx18/cx18-ioctl.c
@@ -402,8 +402,8 @@ static int cx18_querycap(struct file *file, void *fh,
 	snprintf(vcap->bus_info, sizeof(vcap->bus_info),
 		 "PCI:%s", pci_name(cx->pci_dev));
 	vcap->capabilities = cx->v4l2_cap;	/* capabilities */
-	vcap->device_caps = s->v4l2_dev_caps;	/* device capabilities */
-	vcap->capabilities |= V4L2_CAP_DEVICE_CAPS;
+	vcap->device_caps = V4L2_CAP_VDEV_CENTERED | s->v4l2_dev_caps;	/* device capabilities */
+	vcap->capabilities |= V4L2_CAP_DEVICE_CAPS | V4L2_CAP_VDEV_CENTERED;
 	return 0;
 }
 
diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index a71f3c7569ce..69a35e8ee894 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -1334,7 +1334,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
 		sizeof(cap->card));
 	sprintf(cap->bus_info, "PCIe:%s", pci_name(dev->pci));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
-			   V4L2_CAP_STREAMING;
+			   V4L2_CAP_STREAMING | V4L2_CAP_VDEV_CENTERED;
 	if (dev->tuner_type != TUNER_ABSENT)
 		cap->device_caps |= V4L2_CAP_TUNER;
 	cap->capabilities = cap->device_caps | V4L2_CAP_VBI_CAPTURE |
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index ecc580af0148..073c4201de34 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -642,7 +642,8 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	strlcpy(cap->card, cx23885_boards[dev->board].name,
 		sizeof(cap->card));
 	sprintf(cap->bus_info, "PCIe:%s", pci_name(dev->pci));
-	cap->device_caps = V4L2_CAP_READWRITE | V4L2_CAP_STREAMING | V4L2_CAP_AUDIO;
+	cap->device_caps = V4L2_CAP_READWRITE | V4L2_CAP_STREAMING |
+			   V4L2_CAP_AUDIO | V4L2_CAP_VDEV_CENTERED;
 	if (dev->tuner_type != TUNER_ABSENT)
 		cap->device_caps |= V4L2_CAP_TUNER;
 	if (vdev->vfl_type == VFL_TYPE_VBI)
diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index dbaf42ec26cd..6356f823bac2 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -438,8 +438,10 @@ static int cx25821_vidioc_querycap(struct file *file, void *priv,
 	struct cx25821_channel *chan = video_drvdata(file);
 	struct cx25821_dev *dev = chan->dev;
 	const u32 cap_input = V4L2_CAP_VIDEO_CAPTURE |
-			V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
-	const u32 cap_output = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_READWRITE;
+			      V4L2_CAP_READWRITE | V4L2_CAP_STREAMING |
+			      V4L2_CAP_VDEV_CENTERED;
+	const u32 cap_output = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_READWRITE |
+			       V4L2_CAP_VDEV_CENTERED;
 
 	strcpy(cap->driver, "cx25821");
 	strlcpy(cap->card, cx25821_boards[dev->board].name, sizeof(cap->card));
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index 7d25ecd4404b..51fa90f56a3e 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -812,7 +812,8 @@ void cx88_querycap(struct file *file, struct cx88_core *core,
 	struct video_device *vdev = video_devdata(file);
 
 	strlcpy(cap->card, core->board.name, sizeof(cap->card));
-	cap->device_caps = V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
+	cap->device_caps = V4L2_CAP_READWRITE | V4L2_CAP_STREAMING |
+			   V4L2_CAP_VDEV_CENTERED;
 	if (core->board.tuner_type != UNSET)
 		cap->device_caps |= V4L2_CAP_TUNER;
 	switch (vdev->vfl_type) {
diff --git a/drivers/media/pci/dt3155/dt3155.c b/drivers/media/pci/dt3155/dt3155.c
index 6a219694b225..77771e070338 100644
--- a/drivers/media/pci/dt3155/dt3155.c
+++ b/drivers/media/pci/dt3155/dt3155.c
@@ -311,7 +311,8 @@ static int dt3155_querycap(struct file *filp, void *p,
 	strcpy(cap->card, DT3155_NAME " frame grabber");
 	sprintf(cap->bus_info, "PCI:%s", pci_name(pd->pdev));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE |
-		V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
+			   V4L2_CAP_STREAMING | V4L2_CAP_READWRITE |
+			   V4L2_CAP_VDEV_CENTERED;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
diff --git a/drivers/media/pci/ivtv/ivtv-ioctl.c b/drivers/media/pci/ivtv/ivtv-ioctl.c
index 670462d195b5..d8d25f4ccac7 100644
--- a/drivers/media/pci/ivtv/ivtv-ioctl.c
+++ b/drivers/media/pci/ivtv/ivtv-ioctl.c
@@ -750,8 +750,9 @@ static int ivtv_querycap(struct file *file, void *fh, struct v4l2_capability *vc
 	strlcpy(vcap->driver, IVTV_DRIVER_NAME, sizeof(vcap->driver));
 	strlcpy(vcap->card, itv->card_name, sizeof(vcap->card));
 	snprintf(vcap->bus_info, sizeof(vcap->bus_info), "PCI:%s", pci_name(itv->pdev));
-	vcap->capabilities = itv->v4l2_cap | V4L2_CAP_DEVICE_CAPS;
-	vcap->device_caps = s->caps;
+	vcap->capabilities = itv->v4l2_cap | V4L2_CAP_VDEV_CENTERED
+			     | V4L2_CAP_DEVICE_CAPS;
+	vcap->device_caps = s->caps | V4L2_CAP_VDEV_CENTERED;
 	if ((s->caps & V4L2_CAP_VIDEO_OUTPUT_OVERLAY) &&
 	    !itv->osd_video_pbase) {
 		vcap->capabilities &= ~V4L2_CAP_VIDEO_OUTPUT_OVERLAY;
diff --git a/drivers/media/pci/meye/meye.c b/drivers/media/pci/meye/meye.c
index 0fe76bea2393..d13723c9af2c 100644
--- a/drivers/media/pci/meye/meye.c
+++ b/drivers/media/pci/meye/meye.c
@@ -1024,7 +1024,7 @@ static int vidioc_querycap(struct file *file, void *fh,
 	sprintf(cap->bus_info, "PCI:%s", pci_name(meye.mchip_dev));
 
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE |
-			    V4L2_CAP_STREAMING;
+			   V4L2_CAP_STREAMING | V4L2_CAP_VDEV_CENTERED;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 
 	return 0;
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 51d42bbf969e..4b7449622db1 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -1507,7 +1507,8 @@ int saa7134_querycap(struct file *file, void *priv,
 		sizeof(cap->card));
 	sprintf(cap->bus_info, "PCI:%s", pci_name(dev->pci));
 
-	cap->device_caps = V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
+	cap->device_caps = V4L2_CAP_READWRITE | V4L2_CAP_STREAMING
+			   | V4L2_CAP_VDEV_CENTERED;
 	if ((tuner_type != TUNER_ABSENT) && (tuner_type != UNSET))
 		cap->device_caps |= V4L2_CAP_TUNER;
 
diff --git a/drivers/media/pci/saa7164/saa7164-encoder.c b/drivers/media/pci/saa7164/saa7164-encoder.c
index f21c245a54f7..fa6e63607868 100644
--- a/drivers/media/pci/saa7164/saa7164-encoder.c
+++ b/drivers/media/pci/saa7164/saa7164-encoder.c
@@ -505,7 +505,8 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	cap->device_caps =
 		V4L2_CAP_VIDEO_CAPTURE |
 		V4L2_CAP_READWRITE |
-		V4L2_CAP_TUNER;
+		V4L2_CAP_TUNER |
+		V4L2_CAP_VDEV_CENTERED;
 
 	cap->capabilities = cap->device_caps |
 		V4L2_CAP_VBI_CAPTURE |
diff --git a/drivers/media/pci/saa7164/saa7164-vbi.c b/drivers/media/pci/saa7164/saa7164-vbi.c
index 9255d7d23947..a86e1fcfc792 100644
--- a/drivers/media/pci/saa7164/saa7164-vbi.c
+++ b/drivers/media/pci/saa7164/saa7164-vbi.c
@@ -216,7 +216,8 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	cap->device_caps =
 		V4L2_CAP_VBI_CAPTURE |
 		V4L2_CAP_READWRITE |
-		V4L2_CAP_TUNER;
+		V4L2_CAP_TUNER |
+		V4L2_CAP_VDEV_CENTERED;
 
 	cap->capabilities = cap->device_caps |
 		V4L2_CAP_VIDEO_CAPTURE |
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
index 25f9f2ebff1d..dce9ee5086c7 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
@@ -781,7 +781,8 @@ static int solo_enc_querycap(struct file *file, void  *priv,
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "PCI:%s",
 		 pci_name(solo_dev->pdev));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE |
-			V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
+			   V4L2_CAP_READWRITE | V4L2_CAP_STREAMING |
+			   V4L2_CAP_VDEV_CENTERED;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2.c b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
index 3266fc21825f..b832e607e0fd 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
@@ -388,7 +388,8 @@ static int solo_querycap(struct file *file, void  *priv,
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "PCI:%s",
 		 pci_name(solo_dev->pdev));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE |
-			V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
+			   V4L2_CAP_READWRITE | V4L2_CAP_STREAMING |
+			   V4L2_CAP_VDEV_CENTERED;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index 6343d24eb1d5..37badd722d94 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -419,7 +419,8 @@ static int vidioc_querycap(struct file *file, void *priv,
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "PCI:%s",
 		 pci_name(vip->pdev));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
-			   V4L2_CAP_STREAMING;
+			   V4L2_CAP_STREAMING |
+			   V4L2_CAP_VDEV_CENTERED;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 
 	return 0;
diff --git a/drivers/media/pci/tw5864/tw5864-video.c b/drivers/media/pci/tw5864/tw5864-video.c
index e7bd2b8484e3..2cb94183de82 100644
--- a/drivers/media/pci/tw5864/tw5864-video.c
+++ b/drivers/media/pci/tw5864/tw5864-video.c
@@ -930,7 +930,7 @@ static const struct video_device tw5864_video_template = {
 	.release = video_device_release_empty,
 	.tvnorms = TW5864_NORMS,
 	.device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
-		V4L2_CAP_STREAMING,
+		       V4L2_CAP_STREAMING | V4L2_CAP_VDEV_CENTERED,
 };
 
 /* Motion Detection Threshold matrix */
diff --git a/drivers/media/pci/tw68/tw68-video.c b/drivers/media/pci/tw68/tw68-video.c
index 58c4dd75bfa1..8b9645e67703 100644
--- a/drivers/media/pci/tw68/tw68-video.c
+++ b/drivers/media/pci/tw68/tw68-video.c
@@ -741,7 +741,8 @@ static int tw68_querycap(struct file *file, void  *priv,
 	cap->device_caps =
 		V4L2_CAP_VIDEO_CAPTURE |
 		V4L2_CAP_READWRITE |
-		V4L2_CAP_STREAMING;
+		V4L2_CAP_STREAMING |
+		V4L2_CAP_VDEV_CENTERED;
 
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
index c3fafa97b2d0..1915cf3365ee 100644
--- a/drivers/media/pci/tw686x/tw686x-video.c
+++ b/drivers/media/pci/tw686x/tw686x-video.c
@@ -770,7 +770,7 @@ static int tw686x_querycap(struct file *file, void *priv,
 	snprintf(cap->bus_info, sizeof(cap->bus_info),
 		 "PCI:%s", pci_name(dev->pci_dev));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
-			   V4L2_CAP_READWRITE;
+			   V4L2_CAP_READWRITE | V4L2_CAP_VDEV_CENTERED;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
diff --git a/drivers/media/pci/zoran/zoran_driver.c b/drivers/media/pci/zoran/zoran_driver.c
index a11cb501c550..9d9725aec8fb 100644
--- a/drivers/media/pci/zoran/zoran_driver.c
+++ b/drivers/media/pci/zoran/zoran_driver.c
@@ -1514,7 +1514,8 @@ static int zoran_querycap(struct file *file, void *__fh, struct v4l2_capability
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "PCI:%s",
 		 pci_name(zr->pci_dev));
 	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_CAPTURE |
-			   V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_VIDEO_OVERLAY;
+			   V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_VIDEO_OVERLAY |
+			   V4L2_CAP_VDEV_CENTERED;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
diff --git a/drivers/media/platform/rcar_drif.c b/drivers/media/platform/rcar_drif.c
index 522364ff0d5d..2faba25dec8e 100644
--- a/drivers/media/platform/rcar_drif.c
+++ b/drivers/media/platform/rcar_drif.c
@@ -1079,7 +1079,8 @@ static int rcar_drif_sdr_register(struct rcar_drif_sdr *sdr)
 	sdr->vdev->ctrl_handler = &sdr->ctrl_hdl;
 	sdr->vdev->v4l2_dev = &sdr->v4l2_dev;
 	sdr->vdev->device_caps = V4L2_CAP_SDR_CAPTURE | V4L2_CAP_TUNER |
-		V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
+				 V4L2_CAP_STREAMING | V4L2_CAP_READWRITE |
+				 V4L2_CAP_VDEV_CENTERED;
 	video_set_drvdata(sdr->vdev, sdr);
 
 	/* Register V4L2 SDR device */
diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index ef344b9a48af..2286b3088e5f 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -1172,7 +1172,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 			 "vivid-%03d-vid-cap", inst);
 		vfd->fops = &vivid_fops;
 		vfd->ioctl_ops = &vivid_ioctl_ops;
-		vfd->device_caps = dev->vid_cap_caps;
+		vfd->device_caps = dev->vid_cap_caps | V4L2_CAP_VDEV_CENTERED;
 		vfd->release = video_device_release_empty;
 		vfd->v4l2_dev = &dev->v4l2_dev;
 		vfd->queue = &dev->vb_vid_cap_q;
diff --git a/drivers/media/usb/airspy/airspy.c b/drivers/media/usb/airspy/airspy.c
index 07f3f4e7144a..ab8ff78d2088 100644
--- a/drivers/media/usb/airspy/airspy.c
+++ b/drivers/media/usb/airspy/airspy.c
@@ -623,7 +623,8 @@ static int airspy_querycap(struct file *file, void *fh,
 	strlcpy(cap->card, s->vdev.name, sizeof(cap->card));
 	usb_make_path(s->udev, cap->bus_info, sizeof(cap->bus_info));
 	cap->device_caps = V4L2_CAP_SDR_CAPTURE | V4L2_CAP_STREAMING |
-			V4L2_CAP_READWRITE | V4L2_CAP_TUNER;
+			   V4L2_CAP_READWRITE | V4L2_CAP_TUNER |
+			   V4L2_CAP_VDEV_CENTERED;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 
 	return 0;
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 9342402b92f7..b5e53f8252b4 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -1199,7 +1199,8 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	cap->device_caps = V4L2_CAP_AUDIO |
 		V4L2_CAP_READWRITE |
 		V4L2_CAP_STREAMING |
-		V4L2_CAP_TUNER;
+		V4L2_CAP_TUNER |
+		V4L2_CAP_VDEV_CENTERED;
 	if (vdev->vfl_type == VFL_TYPE_GRABBER)
 		cap->device_caps |= V4L2_CAP_VIDEO_CAPTURE;
 	else
diff --git a/drivers/media/usb/cpia2/cpia2_v4l.c b/drivers/media/usb/cpia2/cpia2_v4l.c
index 7122023e7004..b73f44f31253 100644
--- a/drivers/media/usb/cpia2/cpia2_v4l.c
+++ b/drivers/media/usb/cpia2/cpia2_v4l.c
@@ -261,8 +261,9 @@ static int cpia2_querycap(struct file *file, void *fh, struct v4l2_capability *v
 		memset(vc->bus_info,0, sizeof(vc->bus_info));
 
 	vc->device_caps = V4L2_CAP_VIDEO_CAPTURE |
-			   V4L2_CAP_READWRITE |
-			   V4L2_CAP_STREAMING;
+			  V4L2_CAP_READWRITE |
+			  V4L2_CAP_STREAMING |
+			  V4L2_CAP_VDEV_CENTERED;
 	vc->capabilities = vc->device_caps |
 			   V4L2_CAP_DEVICE_CAPS;
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 179b8481a870..2255a8135337 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -1558,9 +1558,10 @@ int cx231xx_querycap(struct file *file, void *priv,
 	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
 
 	if (vdev->vfl_type == VFL_TYPE_RADIO)
-		cap->device_caps = V4L2_CAP_RADIO;
+		cap->device_caps = V4L2_CAP_RADIO | V4L2_CAP_VDEV_CENTERED;
 	else {
-		cap->device_caps = V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
+		cap->device_caps = V4L2_CAP_READWRITE | V4L2_CAP_STREAMING
+				   | V4L2_CAP_VDEV_CENTERED;
 		if (vdev->vfl_type == VFL_TYPE_VBI)
 			cap->device_caps |= V4L2_CAP_VBI_CAPTURE;
 		else
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 8d253a5df0a9..7b3026dbfa71 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1872,11 +1872,13 @@ static int vidioc_querycap(struct file *file, void  *priv,
 
 	if (vdev->vfl_type == VFL_TYPE_GRABBER)
 		cap->device_caps = V4L2_CAP_READWRITE |
-			V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+			 	   V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
+				   V4L2_CAP_VDEV_CENTERED;
 	else if (vdev->vfl_type == VFL_TYPE_RADIO)
-		cap->device_caps = V4L2_CAP_RADIO;
+		cap->device_caps = V4L2_CAP_RADIO | V4L2_CAP_VDEV_CENTERED;
 	else
-		cap->device_caps = V4L2_CAP_READWRITE | V4L2_CAP_VBI_CAPTURE;
+		cap->device_caps = V4L2_CAP_READWRITE | V4L2_CAP_VBI_CAPTURE |
+				   V4L2_CAP_VDEV_CENTERED;
 
 	if (dev->int_audio_type != EM28XX_INT_AUDIO_NONE)
 		cap->device_caps |= V4L2_CAP_AUDIO;
@@ -1885,7 +1887,8 @@ static int vidioc_querycap(struct file *file, void  *priv,
 		cap->device_caps |= V4L2_CAP_TUNER;
 
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS |
-		V4L2_CAP_READWRITE | V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+			    V4L2_CAP_READWRITE | V4L2_CAP_VIDEO_CAPTURE |
+			    V4L2_CAP_STREAMING;
 	if (video_is_registered(&v4l2->vbi_dev))
 		cap->capabilities |= V4L2_CAP_VBI_CAPTURE;
 	if (video_is_registered(&v4l2->radio_dev))
diff --git a/drivers/media/usb/go7007/go7007-v4l2.c b/drivers/media/usb/go7007/go7007-v4l2.c
index 445f17b850c5..fa3f3508844f 100644
--- a/drivers/media/usb/go7007/go7007-v4l2.c
+++ b/drivers/media/usb/go7007/go7007-v4l2.c
@@ -289,7 +289,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	strlcpy(cap->bus_info, go->bus_info, sizeof(cap->bus_info));
 
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
-				V4L2_CAP_STREAMING;
+			   V4L2_CAP_STREAMING | V4L2_CAP_VDEV_CENTERED;
 
 	if (go->board_info->num_aud_inputs)
 		cap->device_caps |= V4L2_CAP_AUDIO;
diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index 0f141762abf1..30813741e706 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -1345,7 +1345,8 @@ static int vidioc_querycap(struct file *file, void  *priv,
 			sizeof(cap->bus_info));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE
 			  | V4L2_CAP_STREAMING
-			  | V4L2_CAP_READWRITE;
+			  | V4L2_CAP_READWRITE
+			  | V4L2_CAP_VDEV_CENTERED;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
index a41b305c55d4..1a0905651450 100644
--- a/drivers/media/usb/hackrf/hackrf.c
+++ b/drivers/media/usb/hackrf/hackrf.c
@@ -911,16 +911,18 @@ static int hackrf_querycap(struct file *file, void *fh,
 
 	if (vdev->vfl_dir == VFL_DIR_RX)
 		cap->device_caps = V4L2_CAP_SDR_CAPTURE | V4L2_CAP_TUNER |
-				   V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
+				   V4L2_CAP_STREAMING | V4L2_CAP_READWRITE |
+				   V4L2_CAP_VDEV_CENTERED;
 
 	else
 		cap->device_caps = V4L2_CAP_SDR_OUTPUT | V4L2_CAP_MODULATOR |
-				   V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
+				   V4L2_CAP_STREAMING | V4L2_CAP_READWRITE |
+				   V4L2_CAP_VDEV_CENTERED;
 
 	cap->capabilities = V4L2_CAP_SDR_CAPTURE | V4L2_CAP_TUNER |
 			    V4L2_CAP_SDR_OUTPUT | V4L2_CAP_MODULATOR |
 			    V4L2_CAP_STREAMING | V4L2_CAP_READWRITE |
-			    V4L2_CAP_DEVICE_CAPS;
+			    V4L2_CAP_VDEV_CENTERED | V4L2_CAP_DEVICE_CAPS;
 	strlcpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
 	strlcpy(cap->card, dev->rx_vdev.name, sizeof(cap->card));
 	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index 7fb036d6a86e..8ee4f78ada94 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -582,7 +582,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	strcpy(cap->card, "Hauppauge HD PVR");
 	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_AUDIO |
-			    V4L2_CAP_READWRITE;
+			    V4L2_CAP_READWRITE | V4L2_CAP_VDEV_CENTERED;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
diff --git a/drivers/media/usb/msi2500/msi2500.c b/drivers/media/usb/msi2500/msi2500.c
index 79bfd2dbe649..2c5f65a994e2 100644
--- a/drivers/media/usb/msi2500/msi2500.c
+++ b/drivers/media/usb/msi2500/msi2500.c
@@ -608,7 +608,8 @@ static int msi2500_querycap(struct file *file, void *fh,
 	strlcpy(cap->card, dev->vdev.name, sizeof(cap->card));
 	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
 	cap->device_caps = V4L2_CAP_SDR_CAPTURE | V4L2_CAP_STREAMING |
-			V4L2_CAP_READWRITE | V4L2_CAP_TUNER;
+			   V4L2_CAP_READWRITE | V4L2_CAP_TUNER |
+			   V4L2_CAP_VDEV_CENTERED;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
index 8f13c60198ed..debc99b5f179 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
@@ -145,7 +145,8 @@ static int pvr2_querycap(struct file *file, void *priv, struct v4l2_capability *
 	strlcpy(cap->card, pvr2_hdw_get_desc(hdw), sizeof(cap->card));
 	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_TUNER |
 			    V4L2_CAP_AUDIO | V4L2_CAP_RADIO |
-			    V4L2_CAP_READWRITE | V4L2_CAP_DEVICE_CAPS;
+			    V4L2_CAP_READWRITE | V4L2_CAP_VDEV_CENTERED |
+			    V4L2_CAP_DEVICE_CAPS;
 	switch (fh->pdi->devbase.vfl_type) {
 	case VFL_TYPE_GRABBER:
 		cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_AUDIO;
@@ -154,7 +155,8 @@ static int pvr2_querycap(struct file *file, void *priv, struct v4l2_capability *
 		cap->device_caps = V4L2_CAP_RADIO;
 		break;
 	}
-	cap->device_caps |= V4L2_CAP_TUNER | V4L2_CAP_READWRITE;
+	cap->device_caps |= V4L2_CAP_TUNER | V4L2_CAP_READWRITE |
+			    V4L2_CAP_VDEV_CENTERED;
 	return 0;
 }
 
diff --git a/drivers/media/usb/pwc/pwc-v4l.c b/drivers/media/usb/pwc/pwc-v4l.c
index 043b2b97cee6..3066ca5ff21e 100644
--- a/drivers/media/usb/pwc/pwc-v4l.c
+++ b/drivers/media/usb/pwc/pwc-v4l.c
@@ -496,7 +496,7 @@ static int pwc_querycap(struct file *file, void *fh, struct v4l2_capability *cap
 	strlcpy(cap->card, pdev->vdev.name, sizeof(cap->card));
 	usb_make_path(pdev->udev, cap->bus_info, sizeof(cap->bus_info));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
-					V4L2_CAP_READWRITE;
+			   V4L2_CAP_READWRITE | V4L2_CAP_VDEV_CENTERED;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 23f606e7cd73..a82b7df0e271 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -733,7 +733,7 @@ static int vidioc_querycap(struct file *file, void *priv,
 	strlcpy(cap->card, "s2255", sizeof(cap->card));
 	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
-		V4L2_CAP_READWRITE;
+			   V4L2_CAP_READWRITE | V4L2_CAP_VDEV_CENTERED;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index a132faa590df..23908a688e30 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -350,7 +350,8 @@ static int vidioc_querycap(struct file *file,
 	cap->device_caps =
 		V4L2_CAP_VIDEO_CAPTURE |
 		V4L2_CAP_STREAMING |
-		V4L2_CAP_READWRITE;
+		V4L2_CAP_READWRITE |
+		V4L2_CAP_VDEV_CENTERED;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index 39abb58c65dd..5aee0f110f59 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -797,7 +797,8 @@ static int stk_vidioc_querycap(struct file *filp,
 	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
 
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE
-		| V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
+			   | V4L2_CAP_READWRITE | V4L2_CAP_STREAMING
+			   | V4L2_CAP_VDEV_CENTERED;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index ec8c4d2534dc..2ca27e53a4a7 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -877,9 +877,10 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	if (vdev->vfl_type == VFL_TYPE_GRABBER)
 		cap->device_caps |= V4L2_CAP_VIDEO_CAPTURE |
 				V4L2_CAP_STREAMING |
-				V4L2_CAP_READWRITE;
+				V4L2_CAP_READWRITE |
+				V4L2_CAP_VDEV_CENTERED;
 	else
-		cap->device_caps |= V4L2_CAP_RADIO;
+		cap->device_caps |= V4L2_CAP_RADIO | V4L2_CAP_VDEV_CENTERED;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS |
 		V4L2_CAP_RADIO | V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE;
 
diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index 8135614f395a..724dbcb8de9b 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -520,7 +520,7 @@ static int usbtv_querycap(struct file *file, void *priv,
 	strlcpy(cap->driver, "usbtv", sizeof(cap->driver));
 	strlcpy(cap->card, "usbtv", sizeof(cap->card));
 	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
-	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE;
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VDEV_CENTERED;
 	cap->device_caps |= V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index 756322c4ac05..816dbb7ba29f 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -476,9 +476,10 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	vc->device_caps = usbvision->have_tuner ? V4L2_CAP_TUNER : 0;
 	if (vdev->vfl_type == VFL_TYPE_GRABBER)
 		vc->device_caps |= V4L2_CAP_VIDEO_CAPTURE |
-			V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
+				   V4L2_CAP_READWRITE | V4L2_CAP_STREAMING |
+				   V4L2_CAP_VDEV_CENTERED;
 	else
-		vc->device_caps |= V4L2_CAP_RADIO;
+		vc->device_caps |= V4L2_CAP_RADIO | V4L2_CAP_VDEV_CENTERED;
 
 	vc->capabilities = vc->device_caps | V4L2_CAP_VIDEO_CAPTURE |
 		V4L2_CAP_READWRITE | V4L2_CAP_STREAMING | V4L2_CAP_DEVICE_CAPS;
diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 3e7e283a44a8..95430bb8d2a4 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -567,11 +567,13 @@ static int uvc_ioctl_querycap(struct file *file, void *fh,
 	strlcpy(cap->card, vdev->name, sizeof(cap->card));
 	usb_make_path(stream->dev->udev, cap->bus_info, sizeof(cap->bus_info));
 	cap->capabilities = V4L2_CAP_DEVICE_CAPS | V4L2_CAP_STREAMING
-			  | chain->caps;
+			  V4L2_CAP_VDEV_CENTERED | chain->caps;
 	if (stream->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+		cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING
+				   | V4L2_CAP_VDEV_CENTERED;
 	else
-		cap->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
+		cap->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING
+				   | V4L2_CAP_VDEV_CENTERED;
 
 	return 0;
 }
diff --git a/drivers/media/usb/zr364xx/zr364xx.c b/drivers/media/usb/zr364xx/zr364xx.c
index d4bb56baad9b..bb3597bce912 100644
--- a/drivers/media/usb/zr364xx/zr364xx.c
+++ b/drivers/media/usb/zr364xx/zr364xx.c
@@ -710,8 +710,9 @@ static int zr364xx_vidioc_querycap(struct file *file, void *priv,
 	strlcpy(cap->bus_info, dev_name(&cam->udev->dev),
 		sizeof(cap->bus_info));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE |
-			    V4L2_CAP_READWRITE |
-			    V4L2_CAP_STREAMING;
+			   V4L2_CAP_READWRITE |
+			   V4L2_CAP_STREAMING |
+			   V4L2_CAP_VDEV_CENTERED;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 
 	return 0;
-- 
2.13.3
