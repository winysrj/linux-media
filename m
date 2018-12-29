Return-Path: <SRS0=xT8T=PG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6DF2C43387
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 17:51:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C222621871
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 17:51:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nextdimension.cc header.i=@nextdimension.cc header.b="qAW0gIa0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727690AbeL2Rvm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 29 Dec 2018 12:51:42 -0500
Received: from bonobo.maple.relay.mailchannels.net ([23.83.214.22]:38747 "EHLO
        bonobo.maple.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727665AbeL2Rvh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Dec 2018 12:51:37 -0500
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id BC60C6818E3;
        Sat, 29 Dec 2018 17:51:35 +0000 (UTC)
Received: from pdx1-sub0-mail-a20.g.dreamhost.com (unknown [100.96.30.62])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 72536682909;
        Sat, 29 Dec 2018 17:51:35 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from pdx1-sub0-mail-a20.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.16.2);
        Sat, 29 Dec 2018 17:51:35 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|brad@nextdimension.ws
X-MailChannels-Auth-Id: dreamhost
X-Decisive-Plucky: 1106dfb4577b430e_1546105895618_863960922
X-MC-Loop-Signature: 1546105895618:1841205228
X-MC-Ingress-Time: 1546105895618
Received: from pdx1-sub0-mail-a20.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a20.g.dreamhost.com (Postfix) with ESMTP id 2B24C805E0;
        Sat, 29 Dec 2018 09:51:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=nextdimension.cc; h=from
        :to:cc:subject:date:message-id:in-reply-to:references; s=
        nextdimension.cc; bh=5WwN+76mID5iDvikKFUmE2Mn578=; b=qAW0gIa0YF7
        Pm678b96nlTcsh6vMvT5jlvB9gX/qqNEItC4GxyO+EvWLYOnB5THHycXDy0ho9Rd
        4d3a4Edf2vWLkZPXcTTaDkLoQDRLdhkvbnDiHTI65RUGo4p8JfASQFuuvP28mBgb
        /eYGWC5n+Frifc+jbNjVDUy7db4Q2F2w=
Received: from localhost.localdomain (66-90-189-166.dyn.grandenetworks.net [66.90.189.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: brad@nextdimension.ws)
        by pdx1-sub0-mail-a20.g.dreamhost.com (Postfix) with ESMTPSA id 99F2E805D7;
        Sat, 29 Dec 2018 09:51:34 -0800 (PST)
X-DH-BACKEND: pdx1-sub0-mail-a20
From:   Brad Love <brad@nextdimension.cc>
To:     linux-media@vger.kernel.org, mchehab@kernel.org
Cc:     Brad Love <brad@nextdimension.cc>
Subject: [PATCH 11/13] cx23885: Add i2c device analog tuner support
Date:   Sat, 29 Dec 2018 11:51:19 -0600
Message-Id: <1546105882-15693-11-git-send-email-brad@nextdimension.cc>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1546105882-15693-1-git-send-email-brad@nextdimension.cc>
References: <1546105882-15693-1-git-send-email-brad@nextdimension.cc>
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: 30
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtledrtdekgddutdejucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfedtmdenucfjughrpefhvffufffkofgjfhestddtredtredttdenucfhrhhomhepuehrrgguucfnohhvvgcuoegsrhgrugesnhgvgihtughimhgvnhhsihhonhdrtggtqeenucfkphepieeirdeltddrudekledrudeiieenucfrrghrrghmpehmohguvgepshhmthhppdhhvghloheplhhotggrlhhhohhsthdrlhhotggrlhguohhmrghinhdpihhnvghtpeeiiedrledtrddukeelrdduieeipdhrvghtuhhrnhdqphgrthhhpeeurhgrugcunfhovhgvuceosghrrggusehnvgigthguihhmvghnshhiohhnrdgttgeqpdhmrghilhhfrhhomhepsghrrggusehnvgigthguihhmvghnshhiohhnrdgttgdpnhhrtghpthhtohepsghrrggusehnvgigthguihhmvghnshhiohhnrdgttgenucevlhhushhtvghrufhiiigvpeel
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

