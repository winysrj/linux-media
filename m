Return-Path: <SRS0=s3Lq=O5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB599C43387
	for <linux-media@archiver.kernel.org>; Thu, 20 Dec 2018 18:58:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF8DE218D3
	for <linux-media@archiver.kernel.org>; Thu, 20 Dec 2018 18:58:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nextdimension.cc header.i=@nextdimension.cc header.b="ce9D/nar"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731314AbeLTS6G (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 20 Dec 2018 13:58:06 -0500
Received: from goldenrod.birch.relay.mailchannels.net ([23.83.209.74]:57915
        "EHLO goldenrod.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725785AbeLTS6G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Dec 2018 13:58:06 -0500
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id E3F5F125A05;
        Thu, 20 Dec 2018 18:58:04 +0000 (UTC)
Received: from pdx1-sub0-mail-a23.g.dreamhost.com (unknown [100.96.35.77])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 769391259FD;
        Thu, 20 Dec 2018 18:58:04 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from pdx1-sub0-mail-a23.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.16.2);
        Thu, 20 Dec 2018 18:58:04 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|brad@nextdimension.ws
X-MailChannels-Auth-Id: dreamhost
X-Cure-Daffy: 3d40f23d5fb06ff8_1545332284754_1768042566
X-MC-Loop-Signature: 1545332284754:2532249705
X-MC-Ingress-Time: 1545332284753
Received: from pdx1-sub0-mail-a23.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a23.g.dreamhost.com (Postfix) with ESMTP id 1C1A980A67;
        Thu, 20 Dec 2018 10:58:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=nextdimension.cc; h=from
        :to:cc:subject:date:message-id; s=nextdimension.cc; bh=3OYAYkPSA
        JZqoQqBZ4ur9d42KGU=; b=ce9D/narjHzX+pAsYgEH80RdUF1b+/A4RoIasbS76
        +vu3RHOjFpDkUX8McdhUmVAYSO0UlCc8gJrkfbYx97eO0/bAVGEw+GMDZDd7PU5Y
        Jp8tLtcjAPIbAEh3ZqcPegri8YAiqvnhZYhkPGjPpFG2RFdG5JIt9zt36++4QN6g
        no=
Received: from localhost.localdomain (66-90-189-166.dyn.grandenetworks.net [66.90.189.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: brad@nextdimension.ws)
        by pdx1-sub0-mail-a23.g.dreamhost.com (Postfix) with ESMTPSA id 76B7080A54;
        Thu, 20 Dec 2018 10:58:03 -0800 (PST)
X-DH-BACKEND: pdx1-sub0-mail-a23
From:   Brad Love <brad@nextdimension.cc>
To:     linux-media@vger.kernel.org
Cc:     Brad Love <brad@nextdimension.cc>
Subject: [PATCH 1/5] si2168: add frequency data to frontend info
Date:   Thu, 20 Dec 2018 12:54:44 -0600
Message-Id: <1545332084-12661-1-git-send-email-brad@nextdimension.cc>
X-Mailer: git-send-email 2.7.4
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: 30
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtkedrudejfedguddvtdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucggtfgfnhhsuhgsshgtrhhisggvpdfftffgtefojffquffvnecuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdeftddmnecujfgurhephffvufffkffosedttdertdertddtnecuhfhrohhmpeeurhgrugcunfhovhgvuceosghrrggusehnvgigthguihhmvghnshhiohhnrdgttgeqnecukfhppeeiiedrledtrddukeelrdduieeinecurfgrrhgrmhepmhhouggvpehsmhhtphdphhgvlhhopehlohgtrghlhhhoshhtrdhlohgtrghlughomhgrihhnpdhinhgvthepieeirdeltddrudekledrudeiiedprhgvthhurhhnqdhprghthhepuehrrgguucfnohhvvgcuoegsrhgrugesnhgvgihtughimhgvnhhsihhonhdrtggtqedpmhgrihhlfhhrohhmpegsrhgrugesnhgvgihtughimhgvnhhsihhonhdrtggtpdhnrhgtphhtthhopegsrhgrugesnhgvgihtughimhgvnhhsihhonhdrtggtnecuvehluhhsthgvrhfuihiivgeptd
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Minimum, maximum, and stepsize taken from Silicon Labs reference.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/dvb-frontends/si2168.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 324493e..17301c6 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -683,8 +683,11 @@ static const struct dvb_frontend_ops si2168_ops = {
 	.delsys = {SYS_DVBT, SYS_DVBT2, SYS_DVBC_ANNEX_A},
 	.info = {
 		.name = "Silicon Labs Si2168",
-		.symbol_rate_min = 1000000,
-		.symbol_rate_max = 7200000,
+		.frequency_min_hz      =  48 * MHz,
+		.frequency_max_hz      = 870 * MHz,
+		.frequency_stepsize_hz = 62500,
+		.symbol_rate_min       = 1000000,
+		.symbol_rate_max       = 7200000,
 		.caps =	FE_CAN_FEC_1_2 |
 			FE_CAN_FEC_2_3 |
 			FE_CAN_FEC_3_4 |
-- 
2.7.4

