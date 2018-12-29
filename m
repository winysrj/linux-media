Return-Path: <SRS0=xT8T=PG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18092C43387
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 17:51:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9D172145D
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 17:51:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nextdimension.cc header.i=@nextdimension.cc header.b="UUBOxE0B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbeL2Rvc (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 29 Dec 2018 12:51:32 -0500
Received: from bonobo.maple.relay.mailchannels.net ([23.83.214.22]:54906 "EHLO
        bonobo.maple.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727581AbeL2Rvb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Dec 2018 12:51:31 -0500
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 5A9EF5E3461;
        Sat, 29 Dec 2018 17:51:30 +0000 (UTC)
Received: from pdx1-sub0-mail-a20.g.dreamhost.com (unknown [100.96.29.126])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 115A35E32D3;
        Sat, 29 Dec 2018 17:51:30 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from pdx1-sub0-mail-a20.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.16.2);
        Sat, 29 Dec 2018 17:51:30 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|brad@nextdimension.ws
X-MailChannels-Auth-Id: dreamhost
X-Arch-Print: 5721512b2d3e1c48_1546105890238_1062653282
X-MC-Loop-Signature: 1546105890238:2537938988
X-MC-Ingress-Time: 1546105890238
Received: from pdx1-sub0-mail-a20.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a20.g.dreamhost.com (Postfix) with ESMTP id B7FDE805E8;
        Sat, 29 Dec 2018 09:51:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=nextdimension.cc; h=from
        :to:cc:subject:date:message-id:in-reply-to:references; s=
        nextdimension.cc; bh=TYfNxbrhaHvnu8JGTDgH/ML7HvU=; b=UUBOxE0Bkyf
        94ALKO3tu9qdNJ4lIBzKABc67oPvv5rDnNTZdHXyX9aWBBxLIQ0KIGYGzzzZbymn
        JZD8J7lqtdya7oq4GFIqxlPZGHC5NpVbx345EuPKVQCoO1pAc7GgDr4mAAbzuuzN
        qklAtpmOvVx0lwxW8ldkGAE7+GYk7uUw=
Received: from localhost.localdomain (66-90-189-166.dyn.grandenetworks.net [66.90.189.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: brad@nextdimension.ws)
        by pdx1-sub0-mail-a20.g.dreamhost.com (Postfix) with ESMTPSA id 3C777805D7;
        Sat, 29 Dec 2018 09:51:29 -0800 (PST)
X-DH-BACKEND: pdx1-sub0-mail-a20
From:   Brad Love <brad@nextdimension.cc>
To:     linux-media@vger.kernel.org, mchehab@kernel.org
Cc:     Brad Love <brad@nextdimension.cc>
Subject: [PATCH 02/13] si2157: Check error status bit on cmd execute
Date:   Sat, 29 Dec 2018 11:51:11 -0600
Message-Id: <1546105882-15693-3-git-send-email-brad@nextdimension.cc>
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

Check error status bit on command execute, if error bit is
set return -EAGAIN. Ignore -EAGAIN in probe during device check.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/tuners/si2157.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index 4855448..3924c42 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -56,14 +56,20 @@ static int si2157_cmd_execute(struct i2c_client *client, struct si2157_cmd *cmd)
 				break;
 		}
 
-		dev_dbg(&client->dev, "cmd execution took %d ms\n",
+		dev_dbg(&client->dev, "cmd execution took %d ms, status=%x\n",
 				jiffies_to_msecs(jiffies) -
-				(jiffies_to_msecs(timeout) - TIMEOUT));
+				(jiffies_to_msecs(timeout) - TIMEOUT),
+				cmd->args[0]);
 
 		if (!((cmd->args[0] >> 7) & 0x01)) {
 			ret = -ETIMEDOUT;
 			goto err_mutex_unlock;
 		}
+		/* check error status bit */
+		if (cmd->args[0] & 0x40) {
+			ret = -EAGAIN;
+			goto err_mutex_unlock;
+		}
 	}
 
 	mutex_unlock(&dev->i2c_mutex);
@@ -477,7 +483,7 @@ static int si2157_probe(struct i2c_client *client,
 	cmd.wlen = 0;
 	cmd.rlen = 1;
 	ret = si2157_cmd_execute(client, &cmd);
-	if (ret)
+	if (ret && (ret != -EAGAIN))
 		goto err_kfree;
 
 	memcpy(&fe->ops.tuner_ops, &si2157_ops, sizeof(struct dvb_tuner_ops));
-- 
2.7.4

