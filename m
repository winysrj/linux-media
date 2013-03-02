Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2210 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab3CBXpq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Mar 2013 18:45:46 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 03/20] solo6x10: fix querycap.
Date: Sun,  3 Mar 2013 00:45:19 +0100
Message-Id: <67bd93c8342e5062d8c85827e6b63fc415ea25ad.1362266529.git.hans.verkuil@cisco.com>
In-Reply-To: <1362267936-6772-1-git-send-email-hverkuil@xs4all.nl>
References: <1362267936-6772-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <5384481a4f621f619f37dd5716df122283e80704.1362266529.git.hans.verkuil@cisco.com>
References: <5384481a4f621f619f37dd5716df122283e80704.1362266529.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Setup correct bus_info, let the v4l2 core set the version and add device_caps
support.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/solo6x10/v4l2-enc.c |    9 ++++-----
 drivers/staging/media/solo6x10/v4l2.c     |    9 ++++-----
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/media/solo6x10/v4l2-enc.c b/drivers/staging/media/solo6x10/v4l2-enc.c
index 4977e86..85e90df 100644
--- a/drivers/staging/media/solo6x10/v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/v4l2-enc.c
@@ -1061,12 +1061,11 @@ static int solo_enc_querycap(struct file *file, void  *priv,
 	strcpy(cap->driver, SOLO6X10_NAME);
 	snprintf(cap->card, sizeof(cap->card), "Softlogic 6x10 Enc %d",
 		 solo_enc->ch);
-	snprintf(cap->bus_info, sizeof(cap->bus_info), "PCI %s",
+	snprintf(cap->bus_info, sizeof(cap->bus_info), "PCI:%s",
 		 pci_name(solo_dev->pdev));
-	cap->version = SOLO6X10_VER_NUM;
-	cap->capabilities =     V4L2_CAP_VIDEO_CAPTURE |
-				V4L2_CAP_READWRITE |
-				V4L2_CAP_STREAMING;
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE |
+			V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
diff --git a/drivers/staging/media/solo6x10/v4l2.c b/drivers/staging/media/solo6x10/v4l2.c
index ca774cc..9c69c34 100644
--- a/drivers/staging/media/solo6x10/v4l2.c
+++ b/drivers/staging/media/solo6x10/v4l2.c
@@ -573,12 +573,11 @@ static int solo_querycap(struct file *file, void  *priv,
 
 	strcpy(cap->driver, SOLO6X10_NAME);
 	strcpy(cap->card, "Softlogic 6x10");
-	snprintf(cap->bus_info, sizeof(cap->bus_info), "PCI %s",
+	snprintf(cap->bus_info, sizeof(cap->bus_info), "PCI:%s",
 		 pci_name(solo_dev->pdev));
-	cap->version = SOLO6X10_VER_NUM;
-	cap->capabilities =     V4L2_CAP_VIDEO_CAPTURE |
-				V4L2_CAP_READWRITE |
-				V4L2_CAP_STREAMING;
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE |
+			V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
-- 
1.7.10.4

