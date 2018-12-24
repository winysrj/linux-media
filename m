Return-Path: <SRS0=3Wpa=PB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A792C676E2
	for <linux-media@archiver.kernel.org>; Mon, 24 Dec 2018 17:00:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55DEE21850
	for <linux-media@archiver.kernel.org>; Mon, 24 Dec 2018 17:00:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nextdimension.cc header.i=@nextdimension.cc header.b="sVY0Ce0h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725788AbeLXRAv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 24 Dec 2018 12:00:51 -0500
Received: from goldenrod.birch.relay.mailchannels.net ([23.83.209.74]:8365
        "EHLO goldenrod.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725710AbeLXRAv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Dec 2018 12:00:51 -0500
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 9C4D628372D;
        Mon, 24 Dec 2018 17:00:49 +0000 (UTC)
Received: from pdx1-sub0-mail-a7.g.dreamhost.com (unknown [100.96.26.166])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 5D7D5283705;
        Mon, 24 Dec 2018 17:00:49 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from pdx1-sub0-mail-a7.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.16.2);
        Mon, 24 Dec 2018 17:00:49 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|brad@nextdimension.ws
X-MailChannels-Auth-Id: dreamhost
X-Print-Obese: 05baaf6627db3d04_1545670849485_1661358276
X-MC-Loop-Signature: 1545670849485:204204322
X-MC-Ingress-Time: 1545670849484
Received: from pdx1-sub0-mail-a7.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a7.g.dreamhost.com (Postfix) with ESMTP id 15CFD80166;
        Mon, 24 Dec 2018 09:00:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=nextdimension.cc; h=from
        :to:cc:subject:date:message-id:in-reply-to:references; s=
        nextdimension.cc; bh=g3m36C6V0qfNykwPfV64g6kJrWY=; b=sVY0Ce0h400
        Are4Jt+WiJ86lC3g/g/TmX7pMOhWMuZgS82+wymIbOSShXeTyGYrnBVcugq5ERyk
        nyKsmQ4pM7h9pP1sDFy6FZDbH0OC3sC1rZxoH4CGOGKZygcnZ2beRKunqsYWACVG
        FP2R9MwyekE4fXNRywo+v90+ETWdFtus=
Received: from localhost.localdomain (66-90-189-166.dyn.grandenetworks.net [66.90.189.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: brad@nextdimension.ws)
        by pdx1-sub0-mail-a7.g.dreamhost.com (Postfix) with ESMTPSA id 8F87D80167;
        Mon, 24 Dec 2018 09:00:48 -0800 (PST)
X-DH-BACKEND: pdx1-sub0-mail-a7
From:   Brad Love <brad@nextdimension.cc>
To:     linux-media@vger.kernel.org, mchehab@kernel.org
Cc:     Brad Love <brad@nextdimension.cc>
Subject: [PATCH v3 1/4] si2157: add detection of si2177 tuner
Date:   Mon, 24 Dec 2018 11:00:33 -0600
Message-Id: <1545670836-24035-2-git-send-email-brad@nextdimension.cc>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1545670836-24035-1-git-send-email-brad@nextdimension.cc>
References: <1545421223-3577-1-git-send-email-brad@nextdimension.cc>
 <1545670836-24035-1-git-send-email-brad@nextdimension.cc>
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: 30
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtkedrudekuddgleejucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfedtmdenucfjughrpefhvffufffkofgjfhestddtredtredttdenucfhrhhomhepuehrrgguucfnohhvvgcuoegsrhgrugesnhgvgihtughimhgvnhhsihhonhdrtggtqeenucfkphepieeirdeltddrudekledrudeiieenucfrrghrrghmpehmohguvgepshhmthhppdhhvghloheplhhotggrlhhhohhsthdrlhhotggrlhguohhmrghinhdpihhnvghtpeeiiedrledtrddukeelrdduieeipdhrvghtuhhrnhdqphgrthhhpeeurhgrugcunfhovhgvuceosghrrggusehnvgigthguihhmvghnshhiohhnrdgttgeqpdhmrghilhhfrhhomhepsghrrggusehnvgigthguihhmvghnshhiohhnrdgttgdpnhhrtghpthhtohepsghrrggusehnvgigthguihhmvghnshhiohhnrdgttgenucevlhhushhtvghrufhiiigvpedt
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Works in ATSC and QAM as is, DVB is completely untested.

Firmware required.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
No changes

 drivers/media/tuners/si2157.c      | 6 ++++++
 drivers/media/tuners/si2157_priv.h | 3 ++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index d389f1f..3d21af5 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -138,6 +138,7 @@ static int si2157_init(struct dvb_frontend *fe)
 	chip_id = cmd.args[1] << 24 | cmd.args[2] << 16 | cmd.args[3] << 8 |
 			cmd.args[4] << 0;
 
+	#define SI2177_A30 ('A' << 24 | 77 << 16 | '3' << 8 | '0' << 0)
 	#define SI2158_A20 ('A' << 24 | 58 << 16 | '2' << 8 | '0' << 0)
 	#define SI2148_A20 ('A' << 24 | 48 << 16 | '2' << 8 | '0' << 0)
 	#define SI2157_A30 ('A' << 24 | 57 << 16 | '3' << 8 | '0' << 0)
@@ -153,6 +154,9 @@ static int si2157_init(struct dvb_frontend *fe)
 	case SI2141_A10:
 		fw_name = SI2141_A10_FIRMWARE;
 		break;
+	case SI2177_A30:
+		fw_name = SI2157_A30_FIRMWARE;
+		break;
 	case SI2157_A30:
 	case SI2147_A30:
 	case SI2146_A10:
@@ -529,6 +533,7 @@ static const struct i2c_device_id si2157_id_table[] = {
 	{"si2157", SI2157_CHIPTYPE_SI2157},
 	{"si2146", SI2157_CHIPTYPE_SI2146},
 	{"si2141", SI2157_CHIPTYPE_SI2141},
+	{"si2177", SI2157_CHIPTYPE_SI2177},
 	{}
 };
 MODULE_DEVICE_TABLE(i2c, si2157_id_table);
@@ -550,3 +555,4 @@ MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
 MODULE_LICENSE("GPL");
 MODULE_FIRMWARE(SI2158_A20_FIRMWARE);
 MODULE_FIRMWARE(SI2141_A10_FIRMWARE);
+MODULE_FIRMWARE(SI2157_A30_FIRMWARE);
diff --git a/drivers/media/tuners/si2157_priv.h b/drivers/media/tuners/si2157_priv.h
index 50f8630..67caee5 100644
--- a/drivers/media/tuners/si2157_priv.h
+++ b/drivers/media/tuners/si2157_priv.h
@@ -50,6 +50,7 @@ struct si2157_dev {
 #define SI2157_CHIPTYPE_SI2157 0
 #define SI2157_CHIPTYPE_SI2146 1
 #define SI2157_CHIPTYPE_SI2141 2
+#define SI2157_CHIPTYPE_SI2177 3
 
 /* firmware command struct */
 #define SI2157_ARGLEN      30
@@ -61,5 +62,5 @@ struct si2157_cmd {
 
 #define SI2158_A20_FIRMWARE "dvb-tuner-si2158-a20-01.fw"
 #define SI2141_A10_FIRMWARE "dvb-tuner-si2141-a10-01.fw"
-
+#define SI2157_A30_FIRMWARE "dvb-tuner-si2157-a30-05.fw"
 #endif
-- 
2.7.4

