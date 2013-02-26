Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2052 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758173Ab3BZRgD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Feb 2013 12:36:03 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 11/11] s2255: fix big-endian support.
Date: Tue, 26 Feb 2013 18:35:46 +0100
Message-Id: <73aace6ab8b80cfda30fa99a1bd02f359b7dad1f.1361900043.git.hans.verkuil@cisco.com>
In-Reply-To: <1361900146-32759-1-git-send-email-hverkuil@xs4all.nl>
References: <1361900146-32759-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <f11ed501c392d8891c3eefeb4959a117e5ddf94e.1361900043.git.hans.verkuil@cisco.com>
References: <f11ed501c392d8891c3eefeb4959a117e5ddf94e.1361900043.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/s2255/s2255drv.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index cd06f3c..2bd8613 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -522,7 +522,7 @@ static void s2255_timer(unsigned long user_data)
 
 
 /* this loads the firmware asynchronously.
-   Originally this was done synchroously in probe.
+   Originally this was done synchronously in probe.
    But it is better to load it asynchronously here than block
    inside the probe function. Blocking inside probe affects boot time.
    FW loading is triggered by the timer in the probe function
@@ -1157,6 +1157,8 @@ static int s2255_set_mode(struct s2255_channel *channel,
 	__le32 *buffer;
 	unsigned long chn_rev;
 	struct s2255_dev *dev = to_s2255_dev(channel->vdev.v4l2_dev);
+	int i;
+
 	chn_rev = G_chnmap[channel->idx];
 	dprintk(3, "%s channel: %d\n", __func__, channel->idx);
 	/* if JPEG, set the quality */
@@ -1179,7 +1181,8 @@ static int s2255_set_mode(struct s2255_channel *channel,
 	buffer[0] = IN_DATA_TOKEN;
 	buffer[1] = (__le32) cpu_to_le32(chn_rev);
 	buffer[2] = CMD_SET_MODE;
-	memcpy(&buffer[3], &channel->mode, sizeof(struct s2255_mode));
+	for (i = 0; i < sizeof(struct s2255_mode) / sizeof(u32); i++)
+		buffer[3 + i] = cpu_to_le32(((u32 *)&channel->mode)[i]);
 	channel->setmode_ready = 0;
 	res = s2255_write_config(dev->udev, (unsigned char *)buffer, 512);
 	if (debug)
@@ -2511,7 +2514,7 @@ static int s2255_probe(struct usb_interface *interface,
 		return -ENOMEM;
 	}
 	atomic_set(&dev->num_channels, 0);
-	dev->pid = id->idProduct;
+	dev->pid = le16_to_cpu(id->idProduct);
 	dev->fw_data = kzalloc(sizeof(struct s2255_fw), GFP_KERNEL);
 	if (!dev->fw_data)
 		goto errorFWDATA1;
@@ -2581,7 +2584,7 @@ static int s2255_probe(struct usb_interface *interface,
 		/* make sure firmware is the latest */
 		__le32 *pRel;
 		pRel = (__le32 *) &dev->fw_data->fw->data[fw_size - 4];
-		printk(KERN_INFO "s2255 dsp fw version %x\n", *pRel);
+		printk(KERN_INFO "s2255 dsp fw version %x\n", le32_to_cpu(*pRel));
 		dev->dsp_fw_ver = le32_to_cpu(*pRel);
 		if (dev->dsp_fw_ver < S2255_CUR_DSP_FWVER)
 			printk(KERN_INFO "s2255: f2255usb.bin out of date.\n");
-- 
1.7.10.4

