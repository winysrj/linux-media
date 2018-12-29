Return-Path: <SRS0=xT8T=PG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E519C43387
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 17:51:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E43221871
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 17:51:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nextdimension.cc header.i=@nextdimension.cc header.b="vKsAu4AN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727675AbeL2Rvg (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 29 Dec 2018 12:51:36 -0500
Received: from firebrick.maple.relay.mailchannels.net ([23.83.214.59]:55427
        "EHLO firebrick.maple.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727650AbeL2Rvf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Dec 2018 12:51:35 -0500
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 3E8775E265D;
        Sat, 29 Dec 2018 17:51:33 +0000 (UTC)
Received: from pdx1-sub0-mail-a20.g.dreamhost.com (unknown [100.96.30.62])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id E228D5E2B0D;
        Sat, 29 Dec 2018 17:51:32 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from pdx1-sub0-mail-a20.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.16.2);
        Sat, 29 Dec 2018 17:51:33 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|brad@nextdimension.ws
X-MailChannels-Auth-Id: dreamhost
X-Trade-Little: 75f4431e1ed62356_1546105893129_3934609508
X-MC-Loop-Signature: 1546105893129:284142135
X-MC-Ingress-Time: 1546105893129
Received: from pdx1-sub0-mail-a20.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a20.g.dreamhost.com (Postfix) with ESMTP id 7A348805EC;
        Sat, 29 Dec 2018 09:51:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=nextdimension.cc; h=from
        :to:cc:subject:date:message-id:in-reply-to:references; s=
        nextdimension.cc; bh=lmZrH1B/edWCWAFyMKqaY7Mr+Ck=; b=vKsAu4ANReK
        IJ7y5FwO660qW0LIG/CsOjzxi8UyZiVWCGvUe6vt96NiitQbxFXn3jxYARw1Xgv0
        bHGcl/1Gzg6kVOXjMPmZBhS0BNsSwcCFndwnlPnPMFrCWAIfBP00e4B9Hq6y/EKK
        7yfeL8VUsxzOTauIKiBAL5hYdwIrEiXs=
Received: from localhost.localdomain (66-90-189-166.dyn.grandenetworks.net [66.90.189.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: brad@nextdimension.ws)
        by pdx1-sub0-mail-a20.g.dreamhost.com (Postfix) with ESMTPSA id E7630805D7;
        Sat, 29 Dec 2018 09:51:31 -0800 (PST)
X-DH-BACKEND: pdx1-sub0-mail-a20
From:   Brad Love <brad@nextdimension.cc>
To:     linux-media@vger.kernel.org, mchehab@kernel.org
Cc:     Brad Love <brad@nextdimension.cc>
Subject: [PATCH 06/13] si2157: Add analog tuning related functions
Date:   Sat, 29 Dec 2018 11:51:15 -0600
Message-Id: <1546105882-15693-7-git-send-email-brad@nextdimension.cc>
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

Include set_analog_params, get_frequency, and get_bandwidth.

Tested with NTSC and PAL standards via ch3/4 generator. Other standards
are included, but are untested due to lack of generator.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/tuners/si2157.c      | 245 ++++++++++++++++++++++++++++++++++++-
 drivers/media/tuners/si2157_priv.h |   2 +
 2 files changed, 244 insertions(+), 3 deletions(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index 1ad2d42..ff462ba 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -388,7 +388,7 @@ static int si2157_set_params(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	/* set if frequency if needed */
+	/* set digital if frequency if needed */
 	if (if_frequency != dev->if_frequency) {
 		memcpy(cmd.args, "\x14\x00\x06\x07", 4);
 		cmd.args[4] = (if_frequency / 1000) & 0xff;
@@ -402,7 +402,7 @@ static int si2157_set_params(struct dvb_frontend *fe)
 		dev->if_frequency = if_frequency;
 	}
 
-	/* set frequency */
+	/* set digital frequency */
 	memcpy(cmd.args, "\x41\x00\x00\x00\x00\x00\x00\x00", 8);
 	cmd.args[4] = (c->frequency >>  0) & 0xff;
 	cmd.args[5] = (c->frequency >>  8) & 0xff;
@@ -414,18 +414,254 @@ static int si2157_set_params(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
+	dev->bandwidth = bandwidth;
+	dev->frequency = c->frequency;
+
+	return 0;
+err:
+	dev->bandwidth = 0;
+	dev->frequency = 0;
+	dev->if_frequency = 0;
+	dev_dbg(&client->dev, "failed=%d\n", ret);
+	return ret;
+}
+
+static int si2157_set_analog_params(struct dvb_frontend *fe,
+				      struct analog_parameters *params)
+{
+	struct i2c_client *client = fe->tuner_priv;
+	struct si2157_dev *dev = i2c_get_clientdata(client);
+	char *std; /* for debugging */
+	int ret;
+	struct si2157_cmd cmd;
+	u32 bandwidth = 0;
+	u32 if_frequency = 0;
+	u32 freq = 0;
+	u64 tmp_lval = 0;
+	u8 system = 0;
+	u8 color = 0;    /* 0=NTSC/PAL, 0x10=SECAM */
+	u8 invert_analog = 1; /* analog tuner spectrum; 0=normal, 1=inverted */
+
+	if (dev->chiptype != SI2157_CHIPTYPE_SI2157) {
+		dev_info(&client->dev, "%s: Analog tuning not supported for chiptype=%u\n",
+				__func__, dev->chiptype);
+		ret = -EINVAL;
+		goto err;
+	}
+
+	if (!dev->active)
+		si2157_init(fe);
+
+	if (!dev->active) {
+		ret = -EAGAIN;
+		goto err;
+	}
+	if (params->mode == V4L2_TUNER_RADIO) {
+	/*
+	 * std = "fm";
+	 * bandwidth = 1700000; //best can do for FM, AGC will be a mess though
+	 * if_frequency = 1250000;  //HVR-225x(saa7164), HVR-12xx(cx23885)
+	 * if_frequency = 6600000;  //HVR-9xx(cx231xx)
+	 * if_frequency = 5500000;  //HVR-19xx(pvrusb2)
+	 */
+		dev_err(&client->dev, "si2157 does not currently support FM radio\n");
+		ret = -EINVAL;
+		goto err;
+	}
+	tmp_lval = params->frequency * 625LL;
+	do_div(tmp_lval, 10); /* convert to HZ */
+	freq = (u32)tmp_lval;
+
+	if (freq < 1000000) /* is freq in KHz */
+		freq = freq * 1000;
+	dev->frequency = freq;
+
+	/* if_frequency values based on tda187271C2 */
+	if (params->std & (V4L2_STD_B|V4L2_STD_GH)) {
+		if (freq >= 470000000) {
+			std = "palGH";
+			bandwidth = 8000000;
+			if_frequency = 6000000;
+			system = 1;
+			if (params->std & (V4L2_STD_SECAM_G|V4L2_STD_SECAM_H)) {
+				std = "secamGH";
+				color = 0x10;
+			}
+		} else {
+			std = "palB";
+			bandwidth = 7000000;
+			if_frequency = 6000000;
+			system = 0;
+			if (params->std & V4L2_STD_SECAM_B) {
+				std = "secamB";
+				color = 0x10;
+			}
+		}
+	} else if (params->std & V4L2_STD_MN) {
+		std = "MN";
+		bandwidth = 6000000;
+		if_frequency = 5400000;
+		system = 2;
+	} else if (params->std & V4L2_STD_PAL_I) {
+		std = "palI";
+		bandwidth = 8000000;
+		if_frequency = 7250000; /* TODO: does not work yet */
+		system = 4;
+	} else if (params->std & V4L2_STD_DK) {
+		std = "palDK";
+		bandwidth = 8000000;
+		if_frequency = 6900000; /* TODO: does not work yet */
+		system = 5;
+		if (params->std & V4L2_STD_SECAM_DK) {
+			std = "secamDK";
+			color = 0x10;
+		}
+	} else if (params->std & V4L2_STD_SECAM_L) {
+		std = "secamL";
+		bandwidth = 8000000;
+		if_frequency = 6750000; /* TODO: untested */
+		system = 6;
+		color = 0x10;
+	} else if (params->std & V4L2_STD_SECAM_LC) {
+		std = "secamL'";
+		bandwidth = 7000000;
+		if_frequency = 1250000; /* TODO: untested */
+		system = 7;
+		color = 0x10;
+	} else {
+		std = "unknown";
+	}
+	/* calc channel center freq */
+	freq = freq - 1250000 + (bandwidth/2);
+
+	dev_dbg(&client->dev,
+			"mode=%d system=%u std='%s' params->frequency=%u center freq=%u if=%u bandwidth=%u\n",
+			params->mode, system, std, params->frequency,
+			freq, if_frequency, bandwidth);
+
+	/* set analog IF port */
+	memcpy(cmd.args, "\x14\x00\x03\x06\x08\x02", 6);
+	/* in using dev->if_port, we assume analog and digital IF's */
+	/*  are always on different ports */
+	/* assumes if_port definition is 0 or 1 for digital out */
+	cmd.args[4] = (dev->if_port == 1)?8:10;
+	cmd.args[5] = (dev->if_port == 1)?2:1; /* Analog AGC assumed external */
+	cmd.wlen = 6;
+	cmd.rlen = 4;
+	ret = si2157_cmd_execute(client, &cmd);
+	if (ret)
+		goto err;
+
+	/* set analog IF output config */
+	memcpy(cmd.args, "\x14\x00\x0d\x06\x94\x64", 6);
+	cmd.wlen = 6;
+	cmd.rlen = 4;
+	ret = si2157_cmd_execute(client, &cmd);
+	if (ret)
+		goto err;
+
+	/* make this distinct from a digital IF */
+	dev->if_frequency = if_frequency | 1;
+
+	/* calc and set tuner analog if center frequency */
+	if_frequency = if_frequency + 1250000 - (bandwidth/2);
+	dev_dbg(&client->dev, "IF Ctr freq=%d\n", if_frequency);
+
+	memcpy(cmd.args, "\x14\x00\x0C\x06", 4);
+	cmd.args[4] = (if_frequency / 1000) & 0xff;
+	cmd.args[5] = ((if_frequency / 1000) >> 8) & 0xff;
+	cmd.wlen = 6;
+	cmd.rlen = 4;
+	ret = si2157_cmd_execute(client, &cmd);
+	if (ret)
+		goto err;
+
+	/* set analog AGC config */
+	memcpy(cmd.args, "\x14\x00\x07\x06\x32\xc8", 6);
+	cmd.wlen = 6;
+	cmd.rlen = 4;
+	ret = si2157_cmd_execute(client, &cmd);
+	if (ret)
+		goto err;
+
+	/* set analog video mode */
+	memcpy(cmd.args, "\x14\x00\x04\x06\x00\x00", 6);
+	cmd.args[4] = system | color;
+#if 1 /* can use dev->inversion if assumed it applies to both digital/analog */
+	if (invert_analog)
+		cmd.args[5] |= 0x02;
+#else
+	if (dev->inversion)
+		cmd.args[5] |= 0x02;
+#endif
+	cmd.wlen = 6;
+	cmd.rlen = 1;
+	ret = si2157_cmd_execute(client, &cmd);
+	if (ret)
+		goto err;
+
+	/* set analog frequency */
+	memcpy(cmd.args, "\x41\x01\x00\x00\x00\x00\x00\x00", 8);
+	cmd.args[4] = (freq >>  0) & 0xff;
+	cmd.args[5] = (freq >>  8) & 0xff;
+	cmd.args[6] = (freq >> 16) & 0xff;
+	cmd.args[7] = (freq >> 24) & 0xff;
+	cmd.wlen = 8;
+	cmd.rlen = 1;
+	ret = si2157_cmd_execute(client, &cmd);
+	if (ret)
+		goto err;
+
+#if 0 /* testing */
+	/* get tuner status, RSSI values */
+	memcpy(cmd.args, "\x42\x01", 2);
+	cmd.wlen = 2;
+	cmd.rlen = 12;
+	ret = si2157_cmd_execute(client, &cmd);
+
+	dev_info(&client->dev, "%s: tuner status: ret=%d rssi=%d mode=%x freq=%d\n",
+		__func__, ret, cmd.args[3], cmd.args[8],
+		(cmd.args[7]<<24 | cmd.args[6]<<16 |
+		cmd.args[5]<<8 | cmd.args[4]));
+#endif
+	dev->bandwidth = bandwidth;
+
 	return 0;
 err:
+	dev->bandwidth = 0;
+	dev->frequency = 0;
+	dev->if_frequency = 0;
 	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
+static int si2157_get_frequency(struct dvb_frontend *fe, u32 *frequency)
+{
+	struct i2c_client *client = fe->tuner_priv;
+	struct si2157_dev *dev = i2c_get_clientdata(client);
+
+	*frequency = dev->frequency;
+	dev_dbg(&client->dev, "%s: freq=%u\n", __func__, dev->frequency);
+	return 0;
+}
+
+static int si2157_get_bandwidth(struct dvb_frontend *fe, u32 *bandwidth)
+{
+	struct i2c_client *client = fe->tuner_priv;
+	struct si2157_dev *dev = i2c_get_clientdata(client);
+
+	*bandwidth = dev->bandwidth;
+	dev_dbg(&client->dev, "%s: bandwidth=%u\n", __func__, dev->bandwidth);
+	return 0;
+}
+
 static int si2157_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
 	struct i2c_client *client = fe->tuner_priv;
 	struct si2157_dev *dev = i2c_get_clientdata(client);
 
-	*frequency = dev->if_frequency;
+	*frequency = dev->if_frequency & ~1; /* strip analog IF indicator bit */
+	dev_dbg(&client->dev, "%s: if_frequency=%u\n", __func__, *frequency);
 	return 0;
 }
 
@@ -439,6 +675,9 @@ static const struct dvb_tuner_ops si2157_ops = {
 	.init = si2157_init,
 	.sleep = si2157_sleep,
 	.set_params = si2157_set_params,
+	.set_analog_params = si2157_set_analog_params,
+	.get_frequency     = si2157_get_frequency,
+	.get_bandwidth     = si2157_get_bandwidth,
 	.get_if_frequency = si2157_get_if_frequency,
 };
 
diff --git a/drivers/media/tuners/si2157_priv.h b/drivers/media/tuners/si2157_priv.h
index 50f8630..1e5ce5b 100644
--- a/drivers/media/tuners/si2157_priv.h
+++ b/drivers/media/tuners/si2157_priv.h
@@ -37,6 +37,8 @@ struct si2157_dev {
 	u8 chiptype;
 	u8 if_port;
 	u32 if_frequency;
+	u32 bandwidth;
+	u32 frequency;
 	struct delayed_work stat_work;
 
 #if defined(CONFIG_MEDIA_CONTROLLER)
-- 
2.7.4

