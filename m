Return-Path: <SRS0=g7QC=O6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3564BC43387
	for <linux-media@archiver.kernel.org>; Fri, 21 Dec 2018 19:40:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAE7521927
	for <linux-media@archiver.kernel.org>; Fri, 21 Dec 2018 19:40:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nextdimension.cc header.i=@nextdimension.cc header.b="vyf1Qq2t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389667AbeLUTkh (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 21 Dec 2018 14:40:37 -0500
Received: from goldenrod.birch.relay.mailchannels.net ([23.83.209.74]:60744
        "EHLO goldenrod.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387777AbeLUTkh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Dec 2018 14:40:37 -0500
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 6A4985C4348;
        Fri, 21 Dec 2018 19:40:35 +0000 (UTC)
Received: from pdx1-sub0-mail-a63.g.dreamhost.com (unknown [100.96.19.74])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id F17EA5C3F2A;
        Fri, 21 Dec 2018 19:40:34 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from pdx1-sub0-mail-a63.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.16.2);
        Fri, 21 Dec 2018 19:40:35 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|brad@nextdimension.ws
X-MailChannels-Auth-Id: dreamhost
X-Arithmetic-Thoughtful: 17fbd970080ba5f7_1545421235236_1975821433
X-MC-Loop-Signature: 1545421235236:2681580321
X-MC-Ingress-Time: 1545421235236
Received: from pdx1-sub0-mail-a63.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a63.g.dreamhost.com (Postfix) with ESMTP id 8CD0181EF5;
        Fri, 21 Dec 2018 11:40:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=nextdimension.cc; h=from
        :to:cc:subject:date:message-id:in-reply-to:references; s=
        nextdimension.cc; bh=1L1cyv0+5q90OlsKg/VP/7DM7Zo=; b=vyf1Qq2t8cT
        DYfMG2LsmN5sPRYWO9aBsRWT7MxUopiGEwE0t/WI86h4p2dH25TZH48w2kBJaE30
        GDp6jVCOuF27nPNDO3odYuZ4SgOf6UFxEB+30VjzX/U5L7OLPxEIzqOjXUk24eE9
        gg9LqGn7VbLNuSyoEBi0OB7xScJubWcM=
Received: from localhost.localdomain (66-90-189-166.dyn.grandenetworks.net [66.90.189.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: brad@nextdimension.ws)
        by pdx1-sub0-mail-a63.g.dreamhost.com (Postfix) with ESMTPSA id E4CC481EFA;
        Fri, 21 Dec 2018 11:40:33 -0800 (PST)
X-DH-BACKEND: pdx1-sub0-mail-a63
From:   Brad Love <brad@nextdimension.cc>
To:     linux-media@vger.kernel.org, mchehab@kernel.org
Cc:     Brad Love <brad@nextdimension.cc>
Subject: [PATCH v2 1/4] si2157: add detection of si2177 tuner
Date:   Fri, 21 Dec 2018 13:40:20 -0600
Message-Id: <1545421223-3577-2-git-send-email-brad@nextdimension.cc>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1545421223-3577-1-git-send-email-brad@nextdimension.cc>
References: <1545343031-20935-1-git-send-email-brad@nextdimension.cc>
 <1545421223-3577-1-git-send-email-brad@nextdimension.cc>
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: 30
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtkedrudejhedgudeftdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucggtfgfnhhsuhgsshgtrhhisggvpdfftffgtefojffquffvnecuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdeftddmnecujfgurhephffvufffkffojghfsedttdertdertddtnecuhfhrohhmpeeurhgrugcunfhovhgvuceosghrrggusehnvgigthguihhmvghnshhiohhnrdgttgeqnecukfhppeeiiedrledtrddukeelrdduieeinecurfgrrhgrmhepmhhouggvpehsmhhtphdphhgvlhhopehlohgtrghlhhhoshhtrdhlohgtrghlughomhgrihhnpdhinhgvthepieeirdeltddrudekledrudeiiedprhgvthhurhhnqdhprghthhepuehrrgguucfnohhvvgcuoegsrhgrugesnhgvgihtughimhgvnhhsihhonhdrtggtqedpmhgrihhlfhhrohhmpegsrhgrugesnhgvgihtughimhgvnhhsihhonhdrtggtpdhnrhgtphhtthhopegsrhgrugesnhgvgihtughimhgvnhhsihhonhdrtggtnecuvehluhhsthgvrhfuihiivgeptd
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Works in ATSC and QAM as is, DVB is completely untested.

Firmware required.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
No changes since v1

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

