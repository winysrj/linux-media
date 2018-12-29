Return-Path: <SRS0=xT8T=PG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F11ECC43387
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 17:51:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBF0321907
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 17:51:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nextdimension.cc header.i=@nextdimension.cc header.b="M7a0OU8N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbeL2Rvg (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 29 Dec 2018 12:51:36 -0500
Received: from ladybird.maple.relay.mailchannels.net ([23.83.214.98]:4556 "EHLO
        ladybird.maple.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727657AbeL2Rvf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Dec 2018 12:51:35 -0500
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id D48D743416;
        Sat, 29 Dec 2018 17:51:33 +0000 (UTC)
Received: from pdx1-sub0-mail-a20.g.dreamhost.com (unknown [100.96.29.126])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 84E0A431A2;
        Sat, 29 Dec 2018 17:51:33 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from pdx1-sub0-mail-a20.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.16.2);
        Sat, 29 Dec 2018 17:51:33 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|brad@nextdimension.ws
X-MailChannels-Auth-Id: dreamhost
X-Abiding-Share: 20a6204d7ed61cc9_1546105893706_1001196010
X-MC-Loop-Signature: 1546105893706:2608126703
X-MC-Ingress-Time: 1546105893705
Received: from pdx1-sub0-mail-a20.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a20.g.dreamhost.com (Postfix) with ESMTP id 2A7A1805E0;
        Sat, 29 Dec 2018 09:51:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=nextdimension.cc; h=from
        :to:cc:subject:date:message-id:in-reply-to:references; s=
        nextdimension.cc; bh=VHc3qJb4yZEAkRtOzxAVVhiwvXs=; b=M7a0OU8N9kB
        zZsy/cAECDRfS+hE4x7CxqhrpHWDMPMYUCByMsHwRN2tyUNNBpBOO6hrtsYRga9Y
        p2z6ltHljuVYmfgpxldZEwPctV7Nc9FFprZNje6e6WAQ+noVKIMlpz5zDABtbeGa
        vAJwm3fHuWRxoQBiQzb7ZMpqnDbRRvkQ=
Received: from localhost.localdomain (66-90-189-166.dyn.grandenetworks.net [66.90.189.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: brad@nextdimension.ws)
        by pdx1-sub0-mail-a20.g.dreamhost.com (Postfix) with ESMTPSA id A0590805D7;
        Sat, 29 Dec 2018 09:51:32 -0800 (PST)
X-DH-BACKEND: pdx1-sub0-mail-a20
From:   Brad Love <brad@nextdimension.cc>
To:     linux-media@vger.kernel.org, mchehab@kernel.org
Cc:     Brad Love <brad@nextdimension.cc>
Subject: [PATCH 07/13] si2157: Briefly wait for tuning operation to complete
Date:   Sat, 29 Dec 2018 11:51:16 -0600
Message-Id: <1546105882-15693-8-git-send-email-brad@nextdimension.cc>
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

Some software reports no signal found on a frequency due to immediately
checking for lock as soon as set_params returns. This waits up 40ms for
tuning operation, then from 30-150ms (dig/analog) for signal lock before
returning from set_params and set_analog_params.

Tuning typically completes in 20-30ms. Digital tuning will additionally
wait depending on signal characteristics. Analog tuning will wait the
full timeout in case of no signal.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/tuners/si2157.c | 87 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index ff462ba..1737007 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -318,6 +318,89 @@ static int si2157_sleep(struct dvb_frontend *fe)
 	return ret;
 }
 
+static int si2157_tune_wait(struct i2c_client *client, u8 is_digital)
+{
+#define TUN_TIMEOUT 40
+#define DIG_TIMEOUT 30
+#define ANALOG_TIMEOUT 150
+	struct si2157_dev *dev = i2c_get_clientdata(client);
+	int ret;
+	unsigned long timeout;
+	unsigned long start_time;
+	u8 wait_status;
+	u8  tune_lock_mask;
+
+	if (is_digital)
+		tune_lock_mask = 0x04;
+	else
+		tune_lock_mask = 0x02;
+
+	mutex_lock(&dev->i2c_mutex);
+
+	/* wait tuner command complete */
+	start_time = jiffies;
+	timeout = start_time + msecs_to_jiffies(TUN_TIMEOUT);
+	while (!time_after(jiffies, timeout)) {
+		ret = i2c_master_recv(client, &wait_status,
+					sizeof(wait_status));
+		if (ret < 0) {
+			goto err_mutex_unlock;
+		} else if (ret != sizeof(wait_status)) {
+			ret = -EREMOTEIO;
+			goto err_mutex_unlock;
+		}
+
+		/* tuner done? */
+		if ((wait_status & 0x81) == 0x81)
+			break;
+		usleep_range(5000, 10000);
+	}
+
+	dev_dbg(&client->dev, "tuning took %d ms, status=0x%x\n",
+		jiffies_to_msecs(jiffies) - jiffies_to_msecs(start_time),
+		wait_status);
+
+	/* if we tuned ok, wait a bit for tuner lock */
+	if ((wait_status & 0x81) == 0x81) {
+		if (is_digital)
+			timeout = jiffies + msecs_to_jiffies(DIG_TIMEOUT);
+		else
+			timeout = jiffies + msecs_to_jiffies(ANALOG_TIMEOUT);
+		while (!time_after(jiffies, timeout)) {
+			ret = i2c_master_recv(client, &wait_status,
+						sizeof(wait_status));
+			if (ret < 0) {
+				goto err_mutex_unlock;
+			} else if (ret != sizeof(wait_status)) {
+				ret = -EREMOTEIO;
+				goto err_mutex_unlock;
+			}
+
+			/* tuner locked? */
+			if (wait_status & tune_lock_mask)
+				break;
+			usleep_range(5000, 10000);
+		}
+	}
+
+	dev_dbg(&client->dev, "tuning+lock took %d ms, status=0x%x\n",
+		jiffies_to_msecs(jiffies) - jiffies_to_msecs(start_time),
+		wait_status);
+
+	if ((wait_status & 0xc0) != 0x80) {
+		ret = -ETIMEDOUT;
+		goto err_mutex_unlock;
+	}
+
+	mutex_unlock(&dev->i2c_mutex);
+	return 0;
+
+err_mutex_unlock:
+	mutex_unlock(&dev->i2c_mutex);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
+	return ret;
+}
+
 static int si2157_set_params(struct dvb_frontend *fe)
 {
 	struct i2c_client *client = fe->tuner_priv;
@@ -417,6 +500,8 @@ static int si2157_set_params(struct dvb_frontend *fe)
 	dev->bandwidth = bandwidth;
 	dev->frequency = c->frequency;
 
+	si2157_tune_wait(client, 1); /* wait to complete, ignore any errors */
+
 	return 0;
 err:
 	dev->bandwidth = 0;
@@ -626,6 +711,8 @@ static int si2157_set_analog_params(struct dvb_frontend *fe,
 #endif
 	dev->bandwidth = bandwidth;
 
+	si2157_tune_wait(client, 0); /* wait to complete, ignore any errors */
+
 	return 0;
 err:
 	dev->bandwidth = 0;
-- 
2.7.4

