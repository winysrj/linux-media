Return-Path: <SRS0=xT8T=PG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0B38C43444
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 17:51:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A477B21871
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 17:51:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nextdimension.cc header.i=@nextdimension.cc header.b="hC04NCQt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbeL2Rvk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 29 Dec 2018 12:51:40 -0500
Received: from quail.birch.relay.mailchannels.net ([23.83.209.151]:57219 "EHLO
        quail.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727678AbeL2Rvi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Dec 2018 12:51:38 -0500
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 21E8F433C8;
        Sat, 29 Dec 2018 17:51:37 +0000 (UTC)
Received: from pdx1-sub0-mail-a20.g.dreamhost.com (unknown [100.96.26.166])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id C946D42C03;
        Sat, 29 Dec 2018 17:51:36 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from pdx1-sub0-mail-a20.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.16.2);
        Sat, 29 Dec 2018 17:51:37 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|brad@nextdimension.ws
X-MailChannels-Auth-Id: dreamhost
X-Minister-Bitter: 4d99727c0c669540_1546105896985_830789051
X-MC-Loop-Signature: 1546105896985:332040155
X-MC-Ingress-Time: 1546105896984
Received: from pdx1-sub0-mail-a20.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a20.g.dreamhost.com (Postfix) with ESMTP id 78408805EC;
        Sat, 29 Dec 2018 09:51:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=nextdimension.cc; h=from
        :to:cc:subject:date:message-id:in-reply-to:references; s=
        nextdimension.cc; bh=w1KX7Rj0E9EtW823O2bzy9NaBxI=; b=hC04NCQtGgs
        Yunx3dyC7pg8+Lh3pgyhXBotXIMsqebUMNplf36RH694euWLSs1Lt8z11+TQiGbf
        7LKG0vOni3hdPfGTk6Vv5xjx+GRoCp2utqJCtlLCSd3t/o5nlYCKgDUP27+tNK3j
        vz19ziQTyzHIUHh3QiekS24mGElpJGb4=
Received: from localhost.localdomain (66-90-189-166.dyn.grandenetworks.net [66.90.189.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: brad@nextdimension.ws)
        by pdx1-sub0-mail-a20.g.dreamhost.com (Postfix) with ESMTPSA id F32DF805E8;
        Sat, 29 Dec 2018 09:51:35 -0800 (PST)
X-DH-BACKEND: pdx1-sub0-mail-a20
From:   Brad Love <brad@nextdimension.cc>
To:     linux-media@vger.kernel.org, mchehab@kernel.org
Cc:     Brad Love <brad@nextdimension.cc>
Subject: [PATCH 12/13] si2157: add on-demand rf strength func
Date:   Sat, 29 Dec 2018 11:51:21 -0600
Message-Id: <1546105882-15693-13-git-send-email-brad@nextdimension.cc>
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

Add get_rf_strength callback to get RSSI from the tuner. DVBv5
stat cache is updated.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/tuners/si2157.c | 38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index 1737007..f28bf7f 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -752,6 +752,40 @@ static int si2157_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 	return 0;
 }
 
+static int si2157_get_rf_strength(struct dvb_frontend *fe, u16 *rssi)
+{
+	struct i2c_client *client = fe->tuner_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	struct si2157_cmd cmd;
+	int ret;
+	int strength;
+
+	dev_dbg(&client->dev, "\n");
+
+	memcpy(cmd.args, "\x42\x00", 2);
+	cmd.wlen = 2;
+	cmd.rlen = 12;
+	ret = si2157_cmd_execute(client, &cmd);
+	if (ret)
+		goto err;
+
+	c->strength.stat[0].scale = FE_SCALE_DECIBEL;
+	c->strength.stat[0].svalue = (s8) cmd.args[3] * 1000;
+
+	strength = (s8)cmd.args[3];
+	strength = (strength > -80) ? (u16)(strength + 100) : 0;
+	strength = strength > 80 ? 100 : strength;
+
+	*rssi = (u16)(strength * 0xffff / 100);
+	dev_dbg(&client->dev, "%s: strength=%d rssi=%u\n",
+		__func__, (s8)cmd.args[3], *rssi);
+
+	return 0;
+err:
+	dev_dbg(&client->dev, "failed=%d\n", ret);
+	return ret;
+}
+
 static const struct dvb_tuner_ops si2157_ops = {
 	.info = {
 		.name             = "Silicon Labs Si2141/Si2146/2147/2148/2157/2158",
@@ -765,7 +799,9 @@ static const struct dvb_tuner_ops si2157_ops = {
 	.set_analog_params = si2157_set_analog_params,
 	.get_frequency     = si2157_get_frequency,
 	.get_bandwidth     = si2157_get_bandwidth,
-	.get_if_frequency = si2157_get_if_frequency,
+	.get_if_frequency  = si2157_get_if_frequency,
+
+	.get_rf_strength   = si2157_get_rf_strength,
 };
 
 static void si2157_stat_work(struct work_struct *work)
-- 
2.7.4

