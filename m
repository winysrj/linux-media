Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4393 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab3CKLqx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 07:46:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 20/42] go7007: go7007: add device_caps and bus_info support to querycap.
Date: Mon, 11 Mar 2013 12:45:58 +0100
Message-Id: <261b14784f5746ead82d4aa5430d227e0328e906.1363000605.git.hans.verkuil@cisco.com>
In-Reply-To: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
References: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

And don't set the version field, the core does that for you.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/go7007/go7007-priv.h    |    1 +
 drivers/staging/media/go7007/go7007-usb.c     |    1 +
 drivers/staging/media/go7007/go7007-v4l2.c    |   10 +++-------
 drivers/staging/media/go7007/saa7134-go7007.c |    1 +
 4 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-priv.h b/drivers/staging/media/go7007/go7007-priv.h
index 898eb5b..1c4b049 100644
--- a/drivers/staging/media/go7007/go7007-priv.h
+++ b/drivers/staging/media/go7007/go7007-priv.h
@@ -171,6 +171,7 @@ enum go7007_parser_state {
 
 struct go7007 {
 	struct device *dev;
+	u8 bus_info[32];
 	struct go7007_board_info *board_info;
 	unsigned int board_id;
 	int tuner_type;
diff --git a/drivers/staging/media/go7007/go7007-usb.c b/drivers/staging/media/go7007/go7007-usb.c
index 5e3e5a0..0b1af50 100644
--- a/drivers/staging/media/go7007/go7007-usb.c
+++ b/drivers/staging/media/go7007/go7007-usb.c
@@ -1087,6 +1087,7 @@ static int go7007_usb_probe(struct usb_interface *intf,
 		goto allocfail;
 	usb->board = board;
 	usb->usbdev = usbdev;
+	usb_make_path(usbdev, go->bus_info, sizeof(go->bus_info));
 	go->board_id = id->driver_info;
 	strncpy(go->name, name, sizeof(go->name));
 	if (board->flags & GO7007_USB_EZUSB)
diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index b79cda8..6f14ac5 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -602,19 +602,15 @@ static int vidioc_querycap(struct file *file, void  *priv,
 
 	strlcpy(cap->driver, "go7007", sizeof(cap->driver));
 	strlcpy(cap->card, go->name, sizeof(cap->card));
-#if 0
-	strlcpy(cap->bus_info, dev_name(&dev->udev->dev), sizeof(cap->bus_info));
-#endif
-
-	cap->version = KERNEL_VERSION(0, 9, 8);
+	strlcpy(cap->bus_info, go->bus_info, sizeof(cap->bus_info));
 
 	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
 
 	if (go->board_info->num_aud_inputs)
 		cap->device_caps |= V4L2_CAP_AUDIO;
 	if (go->board_info->flags & GO7007_BOARD_HAS_TUNER)
-		cap->capabilities |= V4L2_CAP_TUNER;
-
+		cap->device_caps |= V4L2_CAP_TUNER;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
diff --git a/drivers/staging/media/go7007/saa7134-go7007.c b/drivers/staging/media/go7007/saa7134-go7007.c
index e037a39..d65e17a 100644
--- a/drivers/staging/media/go7007/saa7134-go7007.c
+++ b/drivers/staging/media/go7007/saa7134-go7007.c
@@ -456,6 +456,7 @@ static int saa7134_go7007_init(struct saa7134_dev *dev)
 	if (go == NULL)
 		goto allocfail;
 	go->board_id = GO7007_BOARDID_PCI_VOYAGER;
+	snprintf(go->bus_info, sizeof(go->bus_info), "PCI:%s", pci_name(dev->pci));
 	strncpy(go->name, saa7134_boards[dev->board].name, sizeof(go->name));
 	go->hpi_ops = &saa7134_go7007_hpi_ops;
 	go->hpi_context = saa;
-- 
1.7.10.4

