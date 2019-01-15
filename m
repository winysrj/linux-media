Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4D36C43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 01:24:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72AF9206BA
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 01:24:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nextdimension.cc header.i=@nextdimension.cc header.b="IGXJaeG2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbfAOBYW (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 20:24:22 -0500
Received: from ostrich.birch.relay.mailchannels.net ([23.83.209.138]:31627
        "EHLO ostrich.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727314AbfAOBYV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 20:24:21 -0500
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 6456A124551;
        Tue, 15 Jan 2019 01:24:19 +0000 (UTC)
Received: from pdx1-sub0-mail-a35.g.dreamhost.com (unknown [100.96.36.160])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 10F23124480;
        Tue, 15 Jan 2019 01:24:19 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from pdx1-sub0-mail-a35.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.16.2);
        Tue, 15 Jan 2019 01:24:19 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|brad@nextdimension.ws
X-MailChannels-Auth-Id: dreamhost
X-Hysterical-Cure: 0d16b2f62a181248_1547515459235_278189803
X-MC-Loop-Signature: 1547515459235:2983056355
X-MC-Ingress-Time: 1547515459235
Received: from pdx1-sub0-mail-a35.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a35.g.dreamhost.com (Postfix) with ESMTP id C90FD811B8;
        Mon, 14 Jan 2019 17:24:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=nextdimension.cc; h=from
        :to:cc:subject:date:message-id:in-reply-to:references; s=
        nextdimension.cc; bh=hK3sl4gZ/eLI45IU65eEnZWn924=; b=IGXJaeG2b44
        ZFM9VUB1L+kjspOvBpVl2qJAS4k1oj8qoOmmL6TQ6n5q7s+2K3ne7+tRnCYOHmMa
        sMEV+yg50WwFqZF5laiKXVyh584g0YSk+/Ypj+jIZXMGm97CVLo6JhLb5F282Dk6
        0mWg1TnGr2jGpQ4cyOMyiA4ynUArFQvk=
Received: from localhost.localdomain (66-90-189-166.dyn.grandenetworks.net [66.90.189.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: brad@nextdimension.ws)
        by pdx1-sub0-mail-a35.g.dreamhost.com (Postfix) with ESMTPSA id 4CF96811B6;
        Mon, 14 Jan 2019 17:24:18 -0800 (PST)
X-DH-BACKEND: pdx1-sub0-mail-a35
From:   Brad Love <brad@nextdimension.cc>
To:     linux-media@vger.kernel.org, mchehab@kernel.org
Cc:     Brad Love <brad@nextdimension.cc>
Subject: [PATCH 2/2] cx25840-core: Set media controller taint for pads
Date:   Mon, 14 Jan 2019 19:24:08 -0600
Message-Id: <1547515448-15258-3-git-send-email-brad@nextdimension.cc>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1547515448-15258-1-git-send-email-brad@nextdimension.cc>
References: <1547515448-15258-1-git-send-email-brad@nextdimension.cc>
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: 30
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtledrgedvgdefvdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucggtfgfnhhsuhgsshgtrhhisggvpdfftffgtefojffquffvnecuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdeftddmnecujfgurhephffvufffkffojghfsedttdertdertddtnecuhfhrohhmpeeurhgrugcunfhovhgvuceosghrrggusehnvgigthguihhmvghnshhiohhnrdgttgeqnecukfhppeeiiedrledtrddukeelrdduieeinecurfgrrhgrmhepmhhouggvpehsmhhtphdphhgvlhhopehlohgtrghlhhhoshhtrdhlohgtrghlughomhgrihhnpdhinhgvthepieeirdeltddrudekledrudeiiedprhgvthhurhhnqdhprghthhepuehrrgguucfnohhvvgcuoegsrhgrugesnhgvgihtughimhgvnhhsihhonhdrtggtqedpmhgrihhlfhhrohhmpegsrhgrugesnhgvgihtughimhgvnhhsihhonhdrtggtpdhnrhgtphhtthhopegsrhgrugesnhgvgihtughimhgvnhhsihhonhdrtggtnecuvehluhhsthgvrhfuihiivgeptd
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Fixes: 9d6d20e652 ("v4l2-mc: switch it to use the new approach to setup pipelines")

Without "taint" set for signal type, devices
with analog capture fail during probe:

[    5.821715] cx231xx 3-2:1.1: v4l2 driver version 0.0.3
[    5.955721] cx231xx 3-2:1.1: Registered video device video0 [v4l2]
[    5.955797] cx231xx 3-2:1.1: Registered VBI device vbi0
[    5.955802] cx231xx 3-2:1.1: video EndPoint Addr 0x84, Alternate settings: 5
[    5.955805] cx231xx 3-2:1.1: VBI EndPoint Addr 0x85, Alternate settings: 2
[    5.955807] cx231xx 3-2:1.1: sliced CC EndPoint Addr 0x86, Alternate settings: 2
[    5.955834] cx231xx 3-2:1.1: V4L2 device vbi0 deregistered
[    5.955889] cx231xx 3-2:1.1: V4L2 device video0 deregistered
[    5.959131] cx231xx: probe of 3-2:1.1 failed with error -22
[    5.959190] usbcore: registered new interface driver cx231xx


This sets the taint as follows:
- sink pads to PAD_SIGNAL_ANALOG
- source pads to PAD_SIGNAL_DV


Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/i2c/cx25840/cx25840-core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
index b23d8e4..0c94be5 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.c
+++ b/drivers/media/i2c/cx25840/cx25840-core.c
@@ -5225,8 +5225,12 @@ static int cx25840_probe(struct i2c_client *client,
 	 * those extra inputs. So, let's add it only when needed.
 	 */
 	state->pads[CX25840_PAD_INPUT].flags = MEDIA_PAD_FL_SINK;
+	state->pads[CX25840_PAD_INPUT].sig_type = PAD_SIGNAL_ANALOG;
 	state->pads[CX25840_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
+	state->pads[CX25840_PAD_VID_OUT].sig_type = PAD_SIGNAL_DV;
 	state->pads[CX25840_PAD_VBI_OUT].flags = MEDIA_PAD_FL_SOURCE;
+	state->pads[CX25840_PAD_VBI_OUT].sig_type = PAD_SIGNAL_DV;
+
 	sd->entity.function = MEDIA_ENT_F_ATV_DECODER;
 
 	ret = media_entity_pads_init(&sd->entity, ARRAY_SIZE(state->pads),
-- 
2.7.4

