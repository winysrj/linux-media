Return-Path: <SRS0=SnUM=RC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AE6FC10F01
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 18:28:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A7B82186A
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 18:28:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nextdimension.cc header.i=@nextdimension.cc header.b="XvFpwLPR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729918AbfB0S2K (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Feb 2019 13:28:10 -0500
Received: from bonobo.maple.relay.mailchannels.net ([23.83.214.22]:41372 "EHLO
        bonobo.maple.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726389AbfB0S2I (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Feb 2019 13:28:08 -0500
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 4407A5C5695;
        Wed, 27 Feb 2019 18:28:07 +0000 (UTC)
Received: from pdx1-sub0-mail-a6.g.dreamhost.com (unknown [100.96.35.41])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id D8E755C534D;
        Wed, 27 Feb 2019 18:28:06 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from pdx1-sub0-mail-a6.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.16.3);
        Wed, 27 Feb 2019 18:28:07 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|brad@nextdimension.ws
X-MailChannels-Auth-Id: dreamhost
X-Battle-Thread: 693bde347ab19fea_1551292087040_3670631996
X-MC-Loop-Signature: 1551292087040:1798157538
X-MC-Ingress-Time: 1551292087040
Received: from pdx1-sub0-mail-a6.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a6.g.dreamhost.com (Postfix) with ESMTP id 8C8DA7FEE5;
        Wed, 27 Feb 2019 10:28:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=nextdimension.cc; h=from
        :to:cc:subject:date:message-id:in-reply-to:references; s=
        nextdimension.cc; bh=LYIzCRf0o70LWjxOW1dZ/cUqonc=; b=XvFpwLPRh5P
        8NSId1ECsIRHwN99Qbsk0Bbifh7r8hXyVqsrwSWWOVFNymCGroTJ85+91hS0OEQ6
        ZdLiBTxi8VUN1wiG0M7rZ6rNVJPyZQ4BLFxg5jEVOWoqwcVDfPop/I87ZYOYFJhC
        gRVR+WCs30GwqnIKhuSJRHa6A7E/8+h4=
Received: from localhost.localdomain (66-90-189-166.dyn.grandenetworks.net [66.90.189.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: brad@nextdimension.ws)
        by pdx1-sub0-mail-a6.g.dreamhost.com (Postfix) with ESMTPSA id 0A7677FF0C;
        Wed, 27 Feb 2019 10:28:05 -0800 (PST)
X-DH-BACKEND: pdx1-sub0-mail-a6
From:   Brad Love <brad@nextdimension.cc>
To:     linux-media@vger.kernel.org
Cc:     Brad Love <brad@nextdimension.cc>
Subject: [PATCH v2 09/12] cx23885: Add i2c device analog tuner support
Date:   Wed, 27 Feb 2019 12:27:43 -0600
Message-Id: <1551292066-29574-10-git-send-email-brad@nextdimension.cc>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1551292066-29574-1-git-send-email-brad@nextdimension.cc>
References: <1546105882-15693-1-git-send-email-brad@nextdimension.cc>
 <1551292066-29574-1-git-send-email-brad@nextdimension.cc>
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: 30
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedutddrvddugdduudefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfedtmdenucfjughrpefhvffufffkofgjfhestddtredtredttdenucfhrhhomhepuehrrgguucfnohhvvgcuoegsrhgrugesnhgvgihtughimhgvnhhsihhonhdrtggtqeenucfkphepieeirdeltddrudekledrudeiieenucfrrghrrghmpehmohguvgepshhmthhppdhhvghloheplhhotggrlhhhohhsthdrlhhotggrlhguohhmrghinhdpihhnvghtpeeiiedrledtrddukeelrdduieeipdhrvghtuhhrnhdqphgrthhhpeeurhgrugcunfhovhgvuceosghrrggusehnvgigthguihhmvghnshhiohhnrdgttgeqpdhmrghilhhfrhhomhepsghrrggusehnvgigthguihhmvghnshhiohhnrdgttgdpnhhrtghpthhtohepsghrrggusehnvgigthguihhmvghnshhiohhnrdgttgenucevlhhushhtvghrufhiiigvpeef
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hauppauge QuadHD boards all use i2c device drivers and have
tuner_type equal TUNER_ABSENT. This means additional support
is required to enable the analog tuning capability, a case
statement is used to identify these models.

Models with analog tuner inputs enabled:
- CX23885_BOARD_HAUPPAUGE_HVR1265_K4 (tested)
- CX23885_BOARD_HAUPPAUGE_QUADHD_DVB (tested)
- CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC (tested)

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
No changes

 drivers/media/pci/cx23885/cx23885-video.c | 60 +++++++++++++++++++++++++------
 1 file changed, 50 insertions(+), 10 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index ed4ca1e..6d6e7fb 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -646,8 +646,17 @@ static int vidioc_querycap(struct file *file, void  *priv,
 		sizeof(cap->card));
 	sprintf(cap->bus_info, "PCIe:%s", pci_name(dev->pci));
 	cap->device_caps = V4L2_CAP_READWRITE | V4L2_CAP_STREAMING | V4L2_CAP_AUDIO;
-	if (dev->tuner_type != TUNER_ABSENT)
+	switch (dev->board) { /* i2c device tuners */
+	case CX23885_BOARD_HAUPPAUGE_HVR1265_K4:
+	case CX23885_BOARD_HAUPPAUGE_QUADHD_DVB:
+	case CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC:
 		cap->device_caps |= V4L2_CAP_TUNER;
+		break;
+	default:
+		if (dev->tuner_type != TUNER_ABSENT)
+			cap->device_caps |= V4L2_CAP_TUNER;
+		break;
+	}
 	if (vdev->vfl_type == VFL_TYPE_VBI)
 		cap->device_caps |= V4L2_CAP_VBI_CAPTURE;
 	else
@@ -901,8 +910,16 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 {
 	struct cx23885_dev *dev = video_drvdata(file);
 
-	if (dev->tuner_type == TUNER_ABSENT)
-		return -EINVAL;
+	switch (dev->board) { /* i2c device tuners */
+	case CX23885_BOARD_HAUPPAUGE_HVR1265_K4:
+	case CX23885_BOARD_HAUPPAUGE_QUADHD_DVB:
+	case CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC:
+		break;
+	default:
+		if (dev->tuner_type == TUNER_ABSENT)
+			return -EINVAL;
+		break;
+	}
 	if (0 != t->index)
 		return -EINVAL;
 
@@ -917,8 +934,16 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 {
 	struct cx23885_dev *dev = video_drvdata(file);
 
-	if (dev->tuner_type == TUNER_ABSENT)
-		return -EINVAL;
+	switch (dev->board) { /* i2c device tuners */
+	case CX23885_BOARD_HAUPPAUGE_HVR1265_K4:
+	case CX23885_BOARD_HAUPPAUGE_QUADHD_DVB:
+	case CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC:
+		break;
+	default:
+		if (dev->tuner_type == TUNER_ABSENT)
+			return -EINVAL;
+		break;
+	}
 	if (0 != t->index)
 		return -EINVAL;
 	/* Update the A/V core */
@@ -932,9 +957,16 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 {
 	struct cx23885_dev *dev = video_drvdata(file);
 
-	if (dev->tuner_type == TUNER_ABSENT)
-		return -EINVAL;
-
+	switch (dev->board) { /* i2c device tuners */
+	case CX23885_BOARD_HAUPPAUGE_HVR1265_K4:
+	case CX23885_BOARD_HAUPPAUGE_QUADHD_DVB:
+	case CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC:
+		break;
+	default:
+		if (dev->tuner_type == TUNER_ABSENT)
+			return -EINVAL;
+		break;
+	}
 	f->type = V4L2_TUNER_ANALOG_TV;
 	f->frequency = dev->freq;
 
@@ -948,8 +980,16 @@ static int cx23885_set_freq(struct cx23885_dev *dev, const struct v4l2_frequency
 	struct v4l2_ctrl *mute;
 	int old_mute_val = 1;
 
-	if (dev->tuner_type == TUNER_ABSENT)
-		return -EINVAL;
+	switch (dev->board) { /* i2c device tuners */
+	case CX23885_BOARD_HAUPPAUGE_HVR1265_K4:
+	case CX23885_BOARD_HAUPPAUGE_QUADHD_DVB:
+	case CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC:
+		break;
+	default:
+		if (dev->tuner_type == TUNER_ABSENT)
+			return -EINVAL;
+		break;
+	}
 	if (unlikely(f->tuner != 0))
 		return -EINVAL;
 
-- 
2.7.4

