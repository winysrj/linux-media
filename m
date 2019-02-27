Return-Path: <SRS0=SnUM=RC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCA57C43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 18:28:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81E88217F5
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 18:28:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nextdimension.cc header.i=@nextdimension.cc header.b="g5TDDTDx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729986AbfB0S2M (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Feb 2019 13:28:12 -0500
Received: from goldenrod.birch.relay.mailchannels.net ([23.83.209.74]:16658
        "EHLO goldenrod.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726894AbfB0S2K (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Feb 2019 13:28:10 -0500
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 633185C580F;
        Wed, 27 Feb 2019 18:28:09 +0000 (UTC)
Received: from pdx1-sub0-mail-a6.g.dreamhost.com (unknown [100.96.36.131])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id E11BF5C5748;
        Wed, 27 Feb 2019 18:28:08 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from pdx1-sub0-mail-a6.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.16.3);
        Wed, 27 Feb 2019 18:28:09 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|brad@nextdimension.ws
X-MailChannels-Auth-Id: dreamhost
X-Tart-Plucky: 7a225ba70f380a82_1551292089064_3887711518
X-MC-Loop-Signature: 1551292089064:1063908746
X-MC-Ingress-Time: 1551292089064
Received: from pdx1-sub0-mail-a6.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a6.g.dreamhost.com (Postfix) with ESMTP id 5A9F77FEE5;
        Wed, 27 Feb 2019 10:28:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=nextdimension.cc; h=from
        :to:cc:subject:date:message-id:in-reply-to:references; s=
        nextdimension.cc; bh=sRVZa0uKYlQ+3bX6koShRSXK41A=; b=g5TDDTDxnrd
        2iUjORxzTrycC6Ht3ap+SEy94Dygwub0WigsD22wY8L1Fgz00JsWftI2ONG07UYj
        7HquSNAs/tfNgRS0iFhfgNYZqrJE62w1hRzLsmbOpH5b0xws1H90b6Wa5krok34X
        L61DPC2G2wKTruWHIv/P7A8wkM2t+6iY=
Received: from localhost.localdomain (66-90-189-166.dyn.grandenetworks.net [66.90.189.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: brad@nextdimension.ws)
        by pdx1-sub0-mail-a6.g.dreamhost.com (Postfix) with ESMTPSA id B31787FF08;
        Wed, 27 Feb 2019 10:28:06 -0800 (PST)
X-DH-BACKEND: pdx1-sub0-mail-a6
From:   Brad Love <brad@nextdimension.cc>
To:     linux-media@vger.kernel.org
Cc:     Brad Love <brad@nextdimension.cc>
Subject: [PATCH v2 10/12] cx231xx: Add i2c device analog tuner support
Date:   Wed, 27 Feb 2019 12:27:44 -0600
Message-Id: <1551292066-29574-11-git-send-email-brad@nextdimension.cc>
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

The boards listed below use i2c device drivers and have
tuner_type equal TUNER_ABSENT. This means additional support
is required to enable the analog tuning capability, a case
statement is used to identify these models.

Models with analog tuning enabled:
- CX231XX_BOARD_HAUPPAUGE_930C_HD_1114xx (tested)
- CX231XX_BOARD_HAUPPAUGE_935C (tested)
- CX231XX_BOARD_HAUPPAUGE_955Q (tested)
- CX231XX_BOARD_HAUPPAUGE_975 (tested)
- CX231XX_BOARD_EVROMEDIA_FULL_HYBRID_FULLHD (untested)

The EvroMedia model was added, since it uses the si2157
tuner and the board profile claims it has analog inputs.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
Changes since v1:
- remove __func__ from dev_dbg macros

 drivers/media/usb/cx231xx/cx231xx-avcore.c | 35 ++++++++++++++----
 drivers/media/usb/cx231xx/cx231xx-video.c  | 57 ++++++++++++++++++++++++------
 2 files changed, 76 insertions(+), 16 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-avcore.c b/drivers/media/usb/cx231xx/cx231xx-avcore.c
index fdd3c22..a6202a4 100644
--- a/drivers/media/usb/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/usb/cx231xx/cx231xx-avcore.c
@@ -599,14 +599,27 @@ int cx231xx_set_video_input_mux(struct cx231xx *dev, u8 input)
 				return status;
 			}
 		}
-		if (dev->tuner_type == TUNER_NXP_TDA18271)
+		switch (dev->model) { /* i2c device tuners */
+		case CX231XX_BOARD_HAUPPAUGE_930C_HD_1114xx:
+		case CX231XX_BOARD_HAUPPAUGE_935C:
+		case CX231XX_BOARD_HAUPPAUGE_955Q:
+		case CX231XX_BOARD_HAUPPAUGE_975:
+		case CX231XX_BOARD_EVROMEDIA_FULL_HYBRID_FULLHD:
 			status = cx231xx_set_decoder_video_input(dev,
 							CX231XX_VMUX_TELEVISION,
 							INPUT(input)->vmux);
-		else
-			status = cx231xx_set_decoder_video_input(dev,
+			break;
+		default:
+			if (dev->tuner_type == TUNER_NXP_TDA18271)
+				status = cx231xx_set_decoder_video_input(dev,
+							CX231XX_VMUX_TELEVISION,
+							INPUT(input)->vmux);
+			else
+				status = cx231xx_set_decoder_video_input(dev,
 							CX231XX_VMUX_COMPOSITE1,
 							INPUT(input)->vmux);
+			break;
+		};
 
 		break;
 	default:
@@ -1205,12 +1218,22 @@ int cx231xx_set_audio_decoder_input(struct cx231xx *dev,
 					cx231xx_set_field(FLD_SIF_EN, 0));
 			break;
 		default:
+			switch (dev->model) { /* i2c device tuners */
+			case CX231XX_BOARD_HAUPPAUGE_930C_HD_1114xx:
+			case CX231XX_BOARD_HAUPPAUGE_935C:
+			case CX231XX_BOARD_HAUPPAUGE_955Q:
+			case CX231XX_BOARD_HAUPPAUGE_975:
+			case CX231XX_BOARD_EVROMEDIA_FULL_HYBRID_FULLHD:
+			/* TODO: Normal mode: SIF passthrough at 14.32 MHz??? */
+				break;
+			default:
 			/* This is just a casual suggestion to people adding
 			   new boards in case they use a tuner type we don't
 			   currently know about */
-			dev_info(dev->dev,
-				 "Unknown tuner type configuring SIF");
-			break;
+				dev_info(dev->dev,
+					 "Unknown tuner type configuring SIF");
+				break;
+			}
 		}
 		break;
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index aebbaf9..b64ab53 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -1293,7 +1293,7 @@ int cx231xx_s_frequency(struct file *file, void *priv,
 	struct cx231xx_fh *fh = priv;
 	struct cx231xx *dev = fh->dev;
 	struct v4l2_frequency new_freq = *f;
-	int rc;
+	int rc, need_if_freq = 0;
 	u32 if_frequency = 5400000;
 
 	dev_dbg(dev->dev,
@@ -1310,14 +1310,30 @@ int cx231xx_s_frequency(struct file *file, void *priv,
 	/* set pre channel change settings in DIF first */
 	rc = cx231xx_tuner_pre_channel_change(dev);
 
-	call_all(dev, tuner, s_frequency, f);
-	call_all(dev, tuner, g_frequency, &new_freq);
-	dev->ctl_freq = new_freq.frequency;
+	switch (dev->model) { /* i2c device tuners */
+	case CX231XX_BOARD_HAUPPAUGE_930C_HD_1114xx:
+	case CX231XX_BOARD_HAUPPAUGE_935C:
+	case CX231XX_BOARD_HAUPPAUGE_955Q:
+	case CX231XX_BOARD_HAUPPAUGE_975:
+	case CX231XX_BOARD_EVROMEDIA_FULL_HYBRID_FULLHD:
+		if (dev->cx231xx_set_analog_freq)
+			dev->cx231xx_set_analog_freq(dev, f->frequency);
+		dev->ctl_freq = f->frequency;
+		need_if_freq = 1;
+		break;
+	default:
+		call_all(dev, tuner, s_frequency, f);
+		call_all(dev, tuner, g_frequency, &new_freq);
+		dev->ctl_freq = new_freq.frequency;
+		break;
+	}
+
+	pr_debug("%s() %u  :  %u\n", __func__, f->frequency, dev->ctl_freq);
 
 	/* set post channel change settings in DIF first */
 	rc = cx231xx_tuner_post_channel_change(dev);
 
-	if (dev->tuner_type == TUNER_NXP_TDA18271) {
+	if (need_if_freq || dev->tuner_type == TUNER_NXP_TDA18271) {
 		if (dev->norm & (V4L2_STD_MN | V4L2_STD_NTSC_443))
 			if_frequency = 5400000;  /*5.4MHz	*/
 		else if (dev->norm & V4L2_STD_B)
@@ -1584,8 +1600,19 @@ int cx231xx_querycap(struct file *file, void *priv,
 		else
 			cap->device_caps |= V4L2_CAP_VIDEO_CAPTURE;
 	}
-	if (dev->tuner_type != TUNER_ABSENT)
+	switch (dev->model) { /* i2c device tuners */
+	case CX231XX_BOARD_HAUPPAUGE_930C_HD_1114xx:
+	case CX231XX_BOARD_HAUPPAUGE_935C:
+	case CX231XX_BOARD_HAUPPAUGE_955Q:
+	case CX231XX_BOARD_HAUPPAUGE_975:
+	case CX231XX_BOARD_EVROMEDIA_FULL_HYBRID_FULLHD:
 		cap->device_caps |= V4L2_CAP_TUNER;
+		break;
+	default:
+		if (dev->tuner_type != TUNER_ABSENT)
+			cap->device_caps |= V4L2_CAP_TUNER;
+		break;
+	}
 	cap->capabilities = cap->device_caps | V4L2_CAP_READWRITE |
 		V4L2_CAP_VBI_CAPTURE | V4L2_CAP_VIDEO_CAPTURE |
 		V4L2_CAP_STREAMING | V4L2_CAP_DEVICE_CAPS;
@@ -2191,10 +2218,20 @@ static void cx231xx_vdev_init(struct cx231xx *dev,
 
 	video_set_drvdata(vfd, dev);
 	if (dev->tuner_type == TUNER_ABSENT) {
-		v4l2_disable_ioctl(vfd, VIDIOC_G_FREQUENCY);
-		v4l2_disable_ioctl(vfd, VIDIOC_S_FREQUENCY);
-		v4l2_disable_ioctl(vfd, VIDIOC_G_TUNER);
-		v4l2_disable_ioctl(vfd, VIDIOC_S_TUNER);
+		switch (dev->model) {
+		case CX231XX_BOARD_HAUPPAUGE_930C_HD_1114xx:
+		case CX231XX_BOARD_HAUPPAUGE_935C:
+		case CX231XX_BOARD_HAUPPAUGE_955Q:
+		case CX231XX_BOARD_HAUPPAUGE_975:
+		case CX231XX_BOARD_EVROMEDIA_FULL_HYBRID_FULLHD:
+			break;
+		default:
+			v4l2_disable_ioctl(vfd, VIDIOC_G_FREQUENCY);
+			v4l2_disable_ioctl(vfd, VIDIOC_S_FREQUENCY);
+			v4l2_disable_ioctl(vfd, VIDIOC_G_TUNER);
+			v4l2_disable_ioctl(vfd, VIDIOC_S_TUNER);
+			break;
+		}
 	}
 }
 
-- 
2.7.4

