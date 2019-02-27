Return-Path: <SRS0=SnUM=RC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A145FC43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 18:28:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D1C0217F5
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 18:28:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nextdimension.cc header.i=@nextdimension.cc header.b="bKrCDHRK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727488AbfB0S2F (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Feb 2019 13:28:05 -0500
Received: from goldenrod.birch.relay.mailchannels.net ([23.83.209.74]:5060
        "EHLO goldenrod.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726389AbfB0S2F (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Feb 2019 13:28:05 -0500
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 768FD1256A1;
        Wed, 27 Feb 2019 18:28:03 +0000 (UTC)
Received: from pdx1-sub0-mail-a6.g.dreamhost.com (unknown [100.96.24.101])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 110321254B4;
        Wed, 27 Feb 2019 18:28:03 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from pdx1-sub0-mail-a6.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.16.3);
        Wed, 27 Feb 2019 18:28:03 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|brad@nextdimension.ws
X-MailChannels-Auth-Id: dreamhost
X-Illustrious-Vacuous: 40089dce2ed8e3c0_1551292083259_150000546
X-MC-Loop-Signature: 1551292083259:2541459577
X-MC-Ingress-Time: 1551292083259
Received: from pdx1-sub0-mail-a6.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a6.g.dreamhost.com (Postfix) with ESMTP id D6B067FF0C;
        Wed, 27 Feb 2019 10:27:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=nextdimension.cc; h=from
        :to:cc:subject:date:message-id:in-reply-to:references; s=
        nextdimension.cc; bh=Edh2v/4CSthXNqrxEoYTPoljZds=; b=bKrCDHRKH/C
        LHDYreC0fxjb0qWceu89/sVbsttyIC7X5u/PgtN0lXcv7+2oa4cGQx8vkRBrwF3K
        /OsbnnYLN+NxVt6yXWnDiszkpsQMJyzsuKOxPNBFcvMPrrkdT8dv9NiI3M2jj/Hm
        H3ckv5TkvmtbQ0UlRYry7dSnG0YhQIBY=
Received: from localhost.localdomain (66-90-189-166.dyn.grandenetworks.net [66.90.189.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: brad@nextdimension.ws)
        by pdx1-sub0-mail-a6.g.dreamhost.com (Postfix) with ESMTPSA id C8BAD7FEFA;
        Wed, 27 Feb 2019 10:27:57 -0800 (PST)
X-DH-BACKEND: pdx1-sub0-mail-a6
From:   Brad Love <brad@nextdimension.cc>
To:     linux-media@vger.kernel.org
Cc:     Brad Love <brad@nextdimension.cc>
Subject: [PATCH v2 01/12] si2157: Enable tuner status flags
Date:   Wed, 27 Feb 2019 12:27:35 -0600
Message-Id: <1551292066-29574-2-git-send-email-brad@nextdimension.cc>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1551292066-29574-1-git-send-email-brad@nextdimension.cc>
References: <1546105882-15693-1-git-send-email-brad@nextdimension.cc>
 <1551292066-29574-1-git-send-email-brad@nextdimension.cc>
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: 30
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedutddrvddugdduudefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfedtmdenucfjughrpefhvffufffkofgjfhestddtredtredttdenucfhrhhomhepuehrrgguucfnohhvvgcuoegsrhgrugesnhgvgihtughimhgvnhhsihhonhdrtggtqeenucfkphepieeirdeltddrudekledrudeiieenucfrrghrrghmpehmohguvgepshhmthhppdhhvghloheplhhotggrlhhhohhsthdrlhhotggrlhguohhmrghinhdpihhnvghtpeeiiedrledtrddukeelrdduieeipdhrvghtuhhrnhdqphgrthhhpeeurhgrugcunfhovhgvuceosghrrggusehnvgigthguihhmvghnshhiohhnrdgttgeqpdhmrghilhhfrhhomhepsghrrggusehnvgigthguihhmvghnshhiohhnrdgttgdpnhhrtghpthhtohepsghrrggusehnvgigthguihhmvghnshhiohhnrdgttgenucevlhhushhtvghrufhiiigvpedu
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Enable flags to get status of commands sent to the tuner.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
No changes

 drivers/media/tuners/si2157.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index d389f1f..4855448 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -230,6 +230,28 @@ static int si2157_init(struct dvb_frontend *fe)
 
 	dev_info(&client->dev, "firmware version: %c.%c.%d\n",
 			cmd.args[6], cmd.args[7], cmd.args[8]);
+
+	/* enable tuner status flags */
+	memcpy(cmd.args, "\x14\x00\x01\x05\x01\x00", 6);
+	cmd.wlen = 6;
+	cmd.rlen = 1;
+	ret = si2157_cmd_execute(client, &cmd);
+	if (ret)
+		goto err;
+
+	memcpy(cmd.args, "\x14\x00\x01\x06\x01\x00", 6);
+	cmd.wlen = 6;
+	cmd.rlen = 1;
+	ret = si2157_cmd_execute(client, &cmd);
+	if (ret)
+		goto err;
+
+	memcpy(cmd.args, "\x14\x00\x01\x07\x01\x00", 6);
+	cmd.wlen = 6;
+	cmd.rlen = 1;
+	ret = si2157_cmd_execute(client, &cmd);
+	if (ret)
+		goto err;
 warm:
 	/* init statistics in order signal app which are supported */
 	c->strength.len = 1;
-- 
2.7.4

