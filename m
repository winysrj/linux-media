Return-Path: <SRS0=xT8T=PG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44A50C43612
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 17:51:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 099A021871
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 17:51:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nextdimension.cc header.i=@nextdimension.cc header.b="kRvfHe89"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727683AbeL2Rvi (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 29 Dec 2018 12:51:38 -0500
Received: from eastern.maple.relay.mailchannels.net ([23.83.214.55]:59439 "EHLO
        eastern.maple.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727658AbeL2Rvg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Dec 2018 12:51:36 -0500
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 5259D682AD5;
        Sat, 29 Dec 2018 17:51:34 +0000 (UTC)
Received: from pdx1-sub0-mail-a20.g.dreamhost.com (unknown [100.96.30.62])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 0F45A681FB9;
        Sat, 29 Dec 2018 17:51:34 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from pdx1-sub0-mail-a20.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.16.2);
        Sat, 29 Dec 2018 17:51:34 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|brad@nextdimension.ws
X-MailChannels-Auth-Id: dreamhost
X-Society-Quick: 20ce19f06c1b7bac_1546105894200_3811012164
X-MC-Loop-Signature: 1546105894200:500249451
X-MC-Ingress-Time: 1546105894200
Received: from pdx1-sub0-mail-a20.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a20.g.dreamhost.com (Postfix) with ESMTP id C96D4805E8;
        Sat, 29 Dec 2018 09:51:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=nextdimension.cc; h=from
        :to:cc:subject:date:message-id:in-reply-to:references; s=
        nextdimension.cc; bh=BtUJK/2FZqW2y7VaJcnJbdrJ7uk=; b=kRvfHe896yd
        ouZn3I35ur59JHPI7lnxdV4ATzc0EIpV4dRxP8LDTdLY7E0eIAZLHUQHYr4bP+R8
        iYBRFhukzPJlHa40EIQrbQ2omgtVe45Si5vneAWcyZvnH2G34I6K2VMcLsrbUdeR
        My2zba9mR2N5TO30IaAfLB7AIg4ABTXY=
Received: from localhost.localdomain (66-90-189-166.dyn.grandenetworks.net [66.90.189.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: brad@nextdimension.ws)
        by pdx1-sub0-mail-a20.g.dreamhost.com (Postfix) with ESMTPSA id 51557805D7;
        Sat, 29 Dec 2018 09:51:33 -0800 (PST)
X-DH-BACKEND: pdx1-sub0-mail-a20
From:   Brad Love <brad@nextdimension.cc>
To:     linux-media@vger.kernel.org, mchehab@kernel.org
Cc:     Brad Love <brad@nextdimension.cc>
Subject: [PATCH 08/13] cx23885: Add analog tuner support to Hauppauge QuadHD
Date:   Sat, 29 Dec 2018 11:51:17 -0600
Message-Id: <1546105882-15693-9-git-send-email-brad@nextdimension.cc>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1546105882-15693-1-git-send-email-brad@nextdimension.cc>
References: <1546105882-15693-1-git-send-email-brad@nextdimension.cc>
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: 30
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtledrtdekgddutdejucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfedtmdenucfjughrpefhvffufffkofgjfhestddtredtredttdenucfhrhhomhepuehrrgguucfnohhvvgcuoegsrhgrugesnhgvgihtughimhgvnhhsihhonhdrtggtqeenucfkphepieeirdeltddrudekledrudeiieenucfrrghrrghmpehmohguvgepshhmthhppdhhvghloheplhhotggrlhhhohhsthdrlhhotggrlhguohhmrghinhdpihhnvghtpeeiiedrledtrddukeelrdduieeipdhrvghtuhhrnhdqphgrthhhpeeurhgrugcunfhovhgvuceosghrrggusehnvgigthguihhmvghnshhiohhnrdgttgeqpdhmrghilhhfrhhomhepsghrrggusehnvgigthguihhmvghnshhiohhnrdgttgdpnhhrtghpthhtohepsghrrggusehnvgigthguihhmvghnshhiohhnrdgttgenucevlhhushhtvghrufhiiigvpedu
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add analog tuner frontend to 888 Hauppauge QuadHD boards

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/pci/cx23885/cx23885-cards.c | 32 +++++++++++++++++++++++++++----
 drivers/media/pci/cx23885/cx23885-dvb.c   | 20 +++++++++++++++++++
 drivers/media/pci/cx23885/cx23885-video.c |  8 +++++++-
 3 files changed, 55 insertions(+), 5 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
index ed3210d..774c6ea 100644
--- a/drivers/media/pci/cx23885/cx23885-cards.c
+++ b/drivers/media/pci/cx23885/cx23885-cards.c
@@ -767,24 +767,48 @@ struct cx23885_board cx23885_boards[] = {
 		} },
 	},
 	[CX23885_BOARD_HAUPPAUGE_QUADHD_DVB] = {
-		.name        = "Hauppauge WinTV-QuadHD-DVB",
+		.name         = "Hauppauge WinTV-QuadHD-DVB",
+		.porta        = CX23885_ANALOG_VIDEO,
 		.portb        = CX23885_MPEG_DVB,
 		.portc        = CX23885_MPEG_DVB,
+		.tuner_type	= TUNER_ABSENT,
+		.force_bff	= 1,
+		.input          = {{
+			.type   = CX23885_VMUX_TELEVISION,
+			.vmux   =	CX25840_VIN7_CH3 |
+					CX25840_VIN5_CH2 |
+					CX25840_VIN2_CH1 |
+					CX25840_DIF_ON,
+			.amux   = CX25840_AUDIO8,
+		} },
 	},
 	[CX23885_BOARD_HAUPPAUGE_QUADHD_DVB_885] = {
-		.name       = "Hauppauge WinTV-QuadHD-DVB(885)",
+		.name         = "Hauppauge WinTV-QuadHD-DVB(885)",
 		.portb        = CX23885_MPEG_DVB,
 		.portc        = CX23885_MPEG_DVB,
+		.tuner_type   = TUNER_ABSENT,
 	},
 	[CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC] = {
-		.name        = "Hauppauge WinTV-QuadHD-ATSC",
+		.name         = "Hauppauge WinTV-QuadHD-ATSC",
+		.porta        = CX23885_ANALOG_VIDEO,
 		.portb        = CX23885_MPEG_DVB,
 		.portc        = CX23885_MPEG_DVB,
+		.tuner_type	= TUNER_ABSENT,
+		.force_bff	= 1,
+		.input          = {{
+			.type   = CX23885_VMUX_TELEVISION,
+			.vmux   =	CX25840_VIN7_CH3 |
+					CX25840_VIN5_CH2 |
+					CX25840_VIN2_CH1 |
+					CX25840_DIF_ON,
+			.amux   = CX25840_AUDIO8,
+		} },
 	},
 	[CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC_885] = {
-		.name       = "Hauppauge WinTV-QuadHD-ATSC(885)",
+		.name         = "Hauppauge WinTV-QuadHD-ATSC(885)",
 		.portb        = CX23885_MPEG_DVB,
 		.portc        = CX23885_MPEG_DVB,
+		.tuner_type   = TUNER_ABSENT,
 	},
 	[CX23885_BOARD_HAUPPAUGE_HVR1265_K4] = {
 		.name		= "Hauppauge WinTV-HVR-1265(161111)",
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 0d0929c..ee85c55 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -2382,6 +2382,16 @@ static int dvb_register(struct cx23885_tsport *port)
 				goto frontend_detach;
 			}
 			port->i2c_client_tuner = client_tuner;
+
+			/* we only attach tuner for analog on the 888 version */
+			if (dev->board == CX23885_BOARD_HAUPPAUGE_QUADHD_DVB) {
+				pr_info("%s(): QUADHD_DVB analog setup\n",
+					__func__);
+				dev->ts1.analog_fe.tuner_priv = client_tuner;
+				memcpy(&dev->ts1.analog_fe.ops.tuner_ops,
+					&fe0->dvb.frontend->ops.tuner_ops,
+					sizeof(struct dvb_tuner_ops));
+			}
 			break;
 
 		/* port c - terrestrial/cable */
@@ -2471,6 +2481,16 @@ static int dvb_register(struct cx23885_tsport *port)
 				goto frontend_detach;
 			}
 			port->i2c_client_tuner = client_tuner;
+
+			/* we only attach tuner for analog on the 888 version */
+			if (dev->board == CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC) {
+				pr_info("%s(): QUADHD_ATSC analog setup\n",
+					__func__);
+				dev->ts1.analog_fe.tuner_priv = client_tuner;
+				memcpy(&dev->ts1.analog_fe.ops.tuner_ops,
+					&fe0->dvb.frontend->ops.tuner_ops,
+					sizeof(struct dvb_tuner_ops));
+			}
 			break;
 
 		/* port c - terrestrial/cable */
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index 168178c..ed4ca1e 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -264,6 +264,8 @@ static int cx23885_video_mux(struct cx23885_dev *dev, unsigned int input)
 		(dev->board == CX23885_BOARD_HAUPPAUGE_HVR1255) ||
 		(dev->board == CX23885_BOARD_HAUPPAUGE_HVR1255_22111) ||
 		(dev->board == CX23885_BOARD_HAUPPAUGE_HVR1265_K4) ||
+		(dev->board == CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC) ||
+		(dev->board == CX23885_BOARD_HAUPPAUGE_QUADHD_DVB) ||
 		(dev->board == CX23885_BOARD_HAUPPAUGE_HVR1850) ||
 		(dev->board == CX23885_BOARD_MYGICA_X8507) ||
 		(dev->board == CX23885_BOARD_AVERMEDIA_HC81R) ||
@@ -1012,7 +1014,9 @@ static int cx23885_set_freq_via_ops(struct cx23885_dev *dev,
 	if ((dev->board == CX23885_BOARD_HAUPPAUGE_HVR1850) ||
 	    (dev->board == CX23885_BOARD_HAUPPAUGE_HVR1255) ||
 	    (dev->board == CX23885_BOARD_HAUPPAUGE_HVR1255_22111) ||
-	    (dev->board == CX23885_BOARD_HAUPPAUGE_HVR1265_K4))
+	    (dev->board == CX23885_BOARD_HAUPPAUGE_HVR1265_K4) ||
+	    (dev->board == CX23885_BOARD_HAUPPAUGE_QUADHD_DVB) ||
+	    (dev->board == CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC))
 		fe = &dev->ts1.analog_fe;
 
 	if (fe && fe->ops.tuner_ops.set_analog_params) {
@@ -1043,6 +1047,8 @@ int cx23885_set_frequency(struct file *file, void *priv,
 	case CX23885_BOARD_HAUPPAUGE_HVR1255_22111:
 	case CX23885_BOARD_HAUPPAUGE_HVR1265_K4:
 	case CX23885_BOARD_HAUPPAUGE_HVR1850:
+	case CX23885_BOARD_HAUPPAUGE_QUADHD_DVB:
+	case CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC:
 		ret = cx23885_set_freq_via_ops(dev, f);
 		break;
 	default:
-- 
2.7.4

