Return-Path: <SRS0=SnUM=RC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D660C00319
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 18:28:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C3C2217F5
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 18:28:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nextdimension.cc header.i=@nextdimension.cc header.b="Kaza0T4E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729136AbfB0S2H (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Feb 2019 13:28:07 -0500
Received: from bonobo.maple.relay.mailchannels.net ([23.83.214.22]:41166 "EHLO
        bonobo.maple.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727169AbfB0S2G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Feb 2019 13:28:06 -0500
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 634D712575F;
        Wed, 27 Feb 2019 18:28:04 +0000 (UTC)
Received: from pdx1-sub0-mail-a6.g.dreamhost.com (unknown [100.96.19.254])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id CF9EA125640;
        Wed, 27 Feb 2019 18:28:03 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from pdx1-sub0-mail-a6.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.16.3);
        Wed, 27 Feb 2019 18:28:04 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|brad@nextdimension.ws
X-MailChannels-Auth-Id: dreamhost
X-Trail-Supply: 1dd56a5e057b1071_1551292084226_2580035727
X-MC-Loop-Signature: 1551292084226:562338998
X-MC-Ingress-Time: 1551292084225
Received: from pdx1-sub0-mail-a6.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a6.g.dreamhost.com (Postfix) with ESMTP id 322CC7FEFA;
        Wed, 27 Feb 2019 10:28:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=nextdimension.cc; h=from
        :to:cc:subject:date:message-id:in-reply-to:references; s=
        nextdimension.cc; bh=9Cxm6MggDrxeA/i3Cxoj2iB3pPU=; b=Kaza0T4EUle
        +17bfxfQdLJOhqgcMg1piG6De58SspNxA8M4F6azfvo9OztifEYaIpTl3AI0QqN4
        6aP+NPSM0d0dPU3TiCbTJxFYcWwP5EZsdrbK5uTABu33yjn+MqhvlPhQFWywJZsy
        zFf7i8psKR97MO/L2P/Bk83xLdkFm3dU=
Received: from localhost.localdomain (66-90-189-166.dyn.grandenetworks.net [66.90.189.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: brad@nextdimension.ws)
        by pdx1-sub0-mail-a6.g.dreamhost.com (Postfix) with ESMTPSA id B076C7FEE5;
        Wed, 27 Feb 2019 10:28:02 -0800 (PST)
X-DH-BACKEND: pdx1-sub0-mail-a6
From:   Brad Love <brad@nextdimension.cc>
To:     linux-media@vger.kernel.org
Cc:     Brad Love <brad@nextdimension.cc>
Subject: [PATCH v2 04/12] cx25840: Register labeling, chip specific correction
Date:   Wed, 27 Feb 2019 12:27:38 -0600
Message-Id: <1551292066-29574-5-git-send-email-brad@nextdimension.cc>
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

Remove vbi_regs_offset from a group of registers that are 888 specific,
include those registers names.

Add labels to some undocumented registers.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
No changes

 drivers/media/i2c/cx25840/cx25840-core.c | 33 ++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
index 8b0b8b5a..7416b29 100644
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

