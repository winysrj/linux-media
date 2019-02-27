Return-Path: <SRS0=SnUM=RC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0584C4360F
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 18:28:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B24E52186A
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 18:28:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nextdimension.cc header.i=@nextdimension.cc header.b="purtS6n1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729935AbfB0S2N (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Feb 2019 13:28:13 -0500
Received: from bonobo.maple.relay.mailchannels.net ([23.83.214.22]:9984 "EHLO
        bonobo.maple.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726397AbfB0S2L (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Feb 2019 13:28:11 -0500
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 5F38B125530;
        Wed, 27 Feb 2019 18:28:09 +0000 (UTC)
Received: from pdx1-sub0-mail-a6.g.dreamhost.com (unknown [100.96.24.101])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id B4A58125711;
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
X-Wipe-Lettuce: 37b49d2e66da044a_1551292089161_660760465
X-MC-Loop-Signature: 1551292089160:2358633153
X-MC-Ingress-Time: 1551292089160
Received: from pdx1-sub0-mail-a6.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a6.g.dreamhost.com (Postfix) with ESMTP id DDA8A7FF0C;
        Wed, 27 Feb 2019 10:28:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=nextdimension.cc; h=from
        :to:cc:subject:date:message-id:in-reply-to:references; s=
        nextdimension.cc; bh=gnQpIWaFA7v8V1XMJ0NjcLUel2g=; b=purtS6n1R8J
        hoi56gEpx2/o7XuViGY9FJemKDHKa48R0JM/wkCto/BG0GRvWXZS7Rf0j206BcVU
        jYH519s3iAslMyhBJvAUCmOUd65jTbJYoGYq/24l7hAnAOkNAD93tkZMPpzih7zC
        OW9RmZcdQbEzRmyiHo/MkwdMGBvcqOM4=
Received: from localhost.localdomain (66-90-189-166.dyn.grandenetworks.net [66.90.189.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: brad@nextdimension.ws)
        by pdx1-sub0-mail-a6.g.dreamhost.com (Postfix) with ESMTPSA id 5C0B07FEFA;
        Wed, 27 Feb 2019 10:28:07 -0800 (PST)
X-DH-BACKEND: pdx1-sub0-mail-a6
From:   Brad Love <brad@nextdimension.cc>
To:     linux-media@vger.kernel.org
Cc:     Brad Love <brad@nextdimension.cc>
Subject: [PATCH v2 11/12] si2157: add on-demand rf strength func
Date:   Wed, 27 Feb 2019 12:27:45 -0600
Message-Id: <1551292066-29574-12-git-send-email-brad@nextdimension.cc>
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

Add get_rf_strength callback to get RSSI from the tuner. DVBv5
stat cache is updated. get_rf_strength is called by tuner_core
for analog tuners and is also used by some bridge drivers to
obtain RSSI directly from the tuner.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
Changes since v1:
- simplify normalization of signal strength calculation
- use clamp and add description of operation
- remove __func__ from dev_dbg macro

 drivers/media/tuners/si2157.c | 40 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index 36b2ea8..5ce7562 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -735,6 +735,42 @@ static int si2157_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
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
+	/* normalize values based on Silicon Labs reference
+	 * add 100, then anything > 80 is 100% signal
+	 */
+	strength = (s8)cmd.args[3] + 100;
+	strength = clamp_val(strength, 0, 80);
+	*rssi = (u16)(strength * 0xffff / 80);
+
+	dev_dbg(&client->dev, "strength=%d rssi=%u\n",
+		(s8)cmd.args[3], *rssi);
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
@@ -748,7 +784,9 @@ static const struct dvb_tuner_ops si2157_ops = {
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

