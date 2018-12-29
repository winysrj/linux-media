Return-Path: <SRS0=xT8T=PG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26489C43444
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 17:51:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E771A21871
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 17:51:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nextdimension.cc header.i=@nextdimension.cc header.b="VIfvzEgq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727661AbeL2Rvf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 29 Dec 2018 12:51:35 -0500
Received: from bisque.maple.relay.mailchannels.net ([23.83.214.18]:62275 "EHLO
        bisque.maple.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727651AbeL2Rve (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Dec 2018 12:51:34 -0500
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 763B35029DD;
        Sat, 29 Dec 2018 17:51:32 +0000 (UTC)
Received: from pdx1-sub0-mail-a20.g.dreamhost.com (unknown [100.96.30.62])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 21D4D502741;
        Sat, 29 Dec 2018 17:51:32 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from pdx1-sub0-mail-a20.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.16.2);
        Sat, 29 Dec 2018 17:51:32 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|brad@nextdimension.ws
X-MailChannels-Auth-Id: dreamhost
X-Duck-Oafish: 270d8f05033f05bf_1546105892338_24904915
X-MC-Loop-Signature: 1546105892338:2953389086
X-MC-Ingress-Time: 1546105892337
Received: from pdx1-sub0-mail-a20.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a20.g.dreamhost.com (Postfix) with ESMTP id C0C43805E8;
        Sat, 29 Dec 2018 09:51:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=nextdimension.cc; h=from
        :to:cc:subject:date:message-id:in-reply-to:references; s=
        nextdimension.cc; bh=EuxaW6pVWagx7g1iv1jnni1XGzg=; b=VIfvzEgqILp
        iCioNSExvvwOYhpKsjWc511T0LsM8oho9U/g3bLqjTx/acjqY4H2AaUsCFqPmCUv
        DEnRU6nczF5RcpfGARp6dUtqSrNtSAYUfDrQCg7Ro2SDdGJAl8eBg+vvvKmfxv1w
        mLVczK9DOWpATWa+cVa30CqzGRy5pL7c=
Received: from localhost.localdomain (66-90-189-166.dyn.grandenetworks.net [66.90.189.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: brad@nextdimension.ws)
        by pdx1-sub0-mail-a20.g.dreamhost.com (Postfix) with ESMTPSA id 42FB7805E0;
        Sat, 29 Dec 2018 09:51:31 -0800 (PST)
X-DH-BACKEND: pdx1-sub0-mail-a20
From:   Brad Love <brad@nextdimension.cc>
To:     linux-media@vger.kernel.org, mchehab@kernel.org
Cc:     Brad Love <brad@nextdimension.cc>
Subject: [PATCH 05/13] cx25840: Register labeling, chip specific correction
Date:   Sat, 29 Dec 2018 11:51:14 -0600
Message-Id: <1546105882-15693-6-git-send-email-brad@nextdimension.cc>
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

Remove vbi_regs_offset from a group of registers that are 888 specific,
include those registers names.

Add labels to some undocumented registers.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/i2c/cx25840/cx25840-core.c | 33 ++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
index b168bf3..b23d8e4 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.c
+++ b/drivers/media/i2c/cx25840/cx25840-core.c
@@ -684,14 +684,14 @@ static void cx23885_initialize(struct i2c_client *client)
 	 */
 	cx25840_write4(client, 0x404, 0x0010253e);
 
-	/* CC on  - Undocumented Register */
+	/* CC on  -  VBI_LINE_CTRL3, FLD_VBI_MD_LINE12 */
 	cx25840_write(client, state->vbi_regs_offset + 0x42f, 0x66);
 
 	/* HVR-1250 / HVR1850 DIF related */
 	/* Power everything up */
 	cx25840_write4(client, 0x130, 0x0);
 
-	/* Undocumented */
+	/* SRC_COMB_CFG */
 	if (is_cx23888(state))
 		cx25840_write4(client, 0x454, 0x6628021F);
 	else
@@ -1127,16 +1127,24 @@ static int set_input(struct i2c_client *client, enum cx25840_video_input vid_inp
 			cx25840_write4(client, 0x410, 0xffff0dbf);
 			cx25840_write4(client, 0x414, 0x00137d03);
 
-			cx25840_write4(client, state->vbi_regs_offset + 0x42c, 0x42600000);
-			cx25840_write4(client, state->vbi_regs_offset + 0x430, 0x0000039b);
-			cx25840_write4(client, state->vbi_regs_offset + 0x438, 0x00000000);
-
-			cx25840_write4(client, state->vbi_regs_offset + 0x440, 0xF8E3E824);
-			cx25840_write4(client, state->vbi_regs_offset + 0x444, 0x401040dc);
-			cx25840_write4(client, state->vbi_regs_offset + 0x448, 0xcd3f02a0);
-			cx25840_write4(client, state->vbi_regs_offset + 0x44c, 0x161f1000);
-			cx25840_write4(client, state->vbi_regs_offset + 0x450, 0x00000802);
-
+			if (is_cx23888(state)) {
+				/* 888 MISC_TIM_CTRL */
+				cx25840_write4(client, 0x42c, 0x42600000);
+				/* 888 FIELD_COUNT */
+				cx25840_write4(client, 0x430, 0x0000039b);
+				/* 888 VSCALE_CTRL */
+				cx25840_write4(client, 0x438, 0x00000000);
+				/* 888 DFE_CTRL1 */
+				cx25840_write4(client, 0x440, 0xF8E3E824);
+				/* 888 DFE_CTRL2 */
+				cx25840_write4(client, 0x444, 0x401040dc);
+				/* 888 DFE_CTRL3 */
+				cx25840_write4(client, 0x448, 0xcd3f02a0);
+				/* 888 PLL_CTRL */
+				cx25840_write4(client, 0x44c, 0x161f1000);
+				/* 888 HTL_CTRL */
+				cx25840_write4(client, 0x450, 0x00000802);
+			}
 			cx25840_write4(client, 0x91c, 0x01000000);
 			cx25840_write4(client, 0x8e0, 0x03063870);
 			cx25840_write4(client, 0x8d4, 0x7FFF0024);
@@ -1743,6 +1751,7 @@ static int cx25840_s_stream(struct v4l2_subdev *sd, int enable)
 	if (is_cx2388x(state) || is_cx231xx(state))
 		return 0;
 
+	/* PIN_CTRL1 */
 	if (enable) {
 		v = cx25840_read(client, 0x115) | 0x0c;
 		cx25840_write(client, 0x115, v);
-- 
2.7.4

