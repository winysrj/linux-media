Return-Path: <SRS0=xT8T=PG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EF5DC43387
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 18:00:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDD3120873
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 18:00:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nextdimension.cc header.i=@nextdimension.cc header.b="QHPdrlsT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727696AbeL2SAo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 29 Dec 2018 13:00:44 -0500
Received: from goldenrod.birch.relay.mailchannels.net ([23.83.209.74]:40068
        "EHLO goldenrod.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727580AbeL2SAo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Dec 2018 13:00:44 -0500
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 477525E34E2;
        Sat, 29 Dec 2018 18:00:41 +0000 (UTC)
Received: from pdx1-sub0-mail-a20.g.dreamhost.com (unknown [100.96.19.78])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 08C235E3285;
        Sat, 29 Dec 2018 18:00:41 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from pdx1-sub0-mail-a20.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.16.2);
        Sat, 29 Dec 2018 18:00:41 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|brad@nextdimension.ws
X-MailChannels-Auth-Id: dreamhost
X-Bored-Stupid: 2ff9ebff0e488674_1546106441162_4082469491
X-MC-Loop-Signature: 1546106441162:1017692307
X-MC-Ingress-Time: 1546106441161
Received: from pdx1-sub0-mail-a20.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a20.g.dreamhost.com (Postfix) with ESMTP id BFA26805D7;
        Sat, 29 Dec 2018 10:00:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=nextdimension.cc; h=from
        :to:cc:subject:date:message-id; s=nextdimension.cc; bh=jfe5Ji6aj
        t5sxgz5mDcGgZgEK8Q=; b=QHPdrlsTusGGTMTO8CDCziXvWQXcLRvC5ecKIKAuN
        Ub3KAK2Eyt+smpHYTZoNF8471N92K3w7U6YjWjToCuIJjYa8+SGoOMYelesIx7Ee
        Xn54A2V1Hdjd59HQTqYrLjXFQIJ7XZcmXOnGSLRX9FBVCzkKEvCaxDt3UdmzvFtl
        Lk=
Received: from localhost.localdomain (66-90-189-166.dyn.grandenetworks.net [66.90.189.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: brad@nextdimension.ws)
        by pdx1-sub0-mail-a20.g.dreamhost.com (Postfix) with ESMTPSA id E9CBD805E8;
        Sat, 29 Dec 2018 10:00:38 -0800 (PST)
X-DH-BACKEND: pdx1-sub0-mail-a20
From:   Brad Love <brad@nextdimension.cc>
To:     linux-media@vger.kernel.org, mchehab@kernel.org, crope@iki.fi
Cc:     Brad Love <brad@nextdimension.cc>
Subject: [PATCH] si2168: Change from DVB-T to DVB-T/T2 autodetect
Date:   Sat, 29 Dec 2018 12:00:18 -0600
Message-Id: <1546106418-18474-1-git-send-email-brad@nextdimension.cc>
X-Mailer: git-send-email 2.7.4
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: 30
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtledrtdekgddutdelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfedtmdenucfjughrpefhvffufffkofestddtredtredttdenucfhrhhomhepuehrrgguucfnohhvvgcuoegsrhgrugesnhgvgihtughimhgvnhhsihhonhdrtggtqeenucfkphepieeirdeltddrudekledrudeiieenucfrrghrrghmpehmohguvgepshhmthhppdhhvghloheplhhotggrlhhhohhsthdrlhhotggrlhguohhmrghinhdpihhnvghtpeeiiedrledtrddukeelrdduieeipdhrvghtuhhrnhdqphgrthhhpeeurhgrugcunfhovhgvuceosghrrggusehnvgigthguihhmvghnshhiohhnrdgttgeqpdhmrghilhhfrhhomhepsghrrggusehnvgigthguihhmvghnshhiohhnrdgttgdpnhhrtghpthhtohepsghrrggusehnvgigthguihhmvghnshhiohhnrdgttgenucevlhhushhtvghrufhiiigvpedt
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

DVB-T2 support can be a bit lacking in user land, this provides a module
parameter to allow setting the PLP to auto detect DVB-T and DVB-T2
signals after tuning. If a DVB-T2 signal is found the signal is
processed as DVB-T2, otherwise it is left as DVB-T. The detected
signal type is taken into account when reading status.

The module parameter is default disabled, to be backwards compatible
with current behaviour.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/dvb-frontends/si2168.c | 59 ++++++++++++++++++++++++++++++++++--
 1 file changed, 56 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 324493e..4713ee5 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -18,6 +18,10 @@
 
 #include "si2168_priv.h"
 
+static int dvbt_auto_plp;
+module_param(dvbt_auto_plp, int, 0644);
+MODULE_PARM_DESC(dvbt_auto_plp, "if set, the PLP is set to auto detect DVB-T and DVB-T2 signals");
+
 static const struct dvb_frontend_ops si2168_ops;
 
 /* execute firmware command */
@@ -111,7 +115,7 @@ static int si2168_read_status(struct dvb_frontend *fe, enum fe_status *status)
 	struct i2c_client *client = fe->demodulator_priv;
 	struct si2168_dev *dev = i2c_get_clientdata(client);
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int ret, i;
+	int ret, i, sys;
 	unsigned int utmp, utmp1, utmp2;
 	struct si2168_cmd cmd;
 
@@ -122,7 +126,23 @@ static int si2168_read_status(struct dvb_frontend *fe, enum fe_status *status)
 		goto err;
 	}
 
-	switch (c->delivery_system) {
+	sys = c->delivery_system;
+
+	/* check if we found DVB-T2 during DVB-T tuning */
+	if (dvbt_auto_plp && sys == SYS_DVBT) {
+		memcpy(cmd.args, "\x87\x01", 2);
+		cmd.wlen = 2;
+		cmd.rlen = 8;
+
+		ret = si2168_cmd_execute(client, &cmd);
+		if (ret)
+			goto err;
+
+		if ((cmd.args[3] & 0x0f) == 7)
+			sys = SYS_DVBT2;
+	}
+
+	switch (sys) {
 	case SYS_DVBT:
 		memcpy(cmd.args, "\xa0\x01", 2);
 		cmd.wlen = 2;
@@ -144,6 +164,24 @@ static int si2168_read_status(struct dvb_frontend *fe, enum fe_status *status)
 	}
 
 	ret = si2168_cmd_execute(client, &cmd);
+	if (dvbt_auto_plp && (ret == -EREMOTEIO)) {
+		/* In auto-PLP mode it is possible to read 0x8701 while
+		 * the frontend is in switchover transition. This causes
+		 * a status read failure, due to incorrect system. Check
+		 * the other sys if we hit this race condition.
+		 */
+		if (sys == SYS_DVBT) {
+			memcpy(cmd.args, "\x50\x01", 2); /* DVB-T2 */
+			cmd.wlen = 2;
+			cmd.rlen = 14;
+			ret = si2168_cmd_execute(client, &cmd);
+		} else if (sys == SYS_DVBT2) {
+			memcpy(cmd.args, "\xa0\x01", 2); /* DVB-T */
+			cmd.wlen = 2;
+			cmd.rlen = 13;
+			ret = si2168_cmd_execute(client, &cmd);
+		}
+	}
 	if (ret)
 		goto err;
 
@@ -254,7 +292,10 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 
 	switch (c->delivery_system) {
 	case SYS_DVBT:
-		delivery_system = 0x20;
+		if (dvbt_auto_plp)
+			delivery_system = 0xf0; /* T/T2 auto-detect */
+		else
+			delivery_system = 0x20;
 		break;
 	case SYS_DVBC_ANNEX_A:
 		delivery_system = 0x30;
@@ -324,6 +365,16 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 		ret = si2168_cmd_execute(client, &cmd);
 		if (ret)
 			goto err;
+	} else if (dvbt_auto_plp && (c->delivery_system == SYS_DVBT)) {
+		/* select Auto PLP */
+		cmd.args[0] = 0x52;
+		cmd.args[1] = 0;
+		cmd.args[2] = 0; /* Auto PLP */
+		cmd.wlen = 3;
+		cmd.rlen = 1;
+		ret = si2168_cmd_execute(client, &cmd);
+		if (ret)
+			goto err;
 	}
 
 	memcpy(cmd.args, "\x51\x03", 2);
@@ -363,6 +414,8 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 
 	memcpy(cmd.args, "\x14\x00\x0a\x10\x00\x00", 6);
 	cmd.args[4] = delivery_system | bandwidth;
+	if (delivery_system == 0xf0)
+		cmd.args[5] |= 2; /* Auto detect DVB-T/T2 */
 	if (dev->spectral_inversion)
 		cmd.args[5] |= 1;
 	cmd.wlen = 6;
-- 
2.7.4

