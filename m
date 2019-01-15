Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8144C43612
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 01:24:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 880FE206BA
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 01:24:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nextdimension.cc header.i=@nextdimension.cc header.b="UJWn3b4w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727346AbfAOBYW (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 20:24:22 -0500
Received: from eastern.maple.relay.mailchannels.net ([23.83.214.55]:24652 "EHLO
        eastern.maple.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727299AbfAOBYV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 20:24:21 -0500
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 0FE491243D4;
        Tue, 15 Jan 2019 01:24:19 +0000 (UTC)
Received: from pdx1-sub0-mail-a35.g.dreamhost.com (unknown [100.96.33.121])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id B1FDE1245BC;
        Tue, 15 Jan 2019 01:24:18 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from pdx1-sub0-mail-a35.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.16.2);
        Tue, 15 Jan 2019 01:24:19 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|brad@nextdimension.ws
X-MailChannels-Auth-Id: dreamhost
X-Minister-Well-Made: 00c3012268596c58_1547515458879_1028720570
X-MC-Loop-Signature: 1547515458878:503500210
X-MC-Ingress-Time: 1547515458878
Received: from pdx1-sub0-mail-a35.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a35.g.dreamhost.com (Postfix) with ESMTP id 289BD7ED32;
        Mon, 14 Jan 2019 17:24:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=nextdimension.cc; h=from
        :to:cc:subject:date:message-id:in-reply-to:references; s=
        nextdimension.cc; bh=0/6orC+IaAWtTfRFQot+vTJlgs4=; b=UJWn3b4wgv0
        CHWTu096RDdFuKLb6er8O/SXUycIsspabiSZgT7MXL0cmVaxLk4qbWy6l36SQQNw
        Qvk/uJ2/Cgdzh3ffRGRJsPHBzWn87TGNsHSvM4btKTVTX7weYl7zVlMAD82eegQu
        UQwtxu3fBJItM1wx+M6iDu0q6/j2MEt0=
Received: from localhost.localdomain (66-90-189-166.dyn.grandenetworks.net [66.90.189.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: brad@nextdimension.ws)
        by pdx1-sub0-mail-a35.g.dreamhost.com (Postfix) with ESMTPSA id A3A20811B8;
        Mon, 14 Jan 2019 17:24:17 -0800 (PST)
X-DH-BACKEND: pdx1-sub0-mail-a35
From:   Brad Love <brad@nextdimension.cc>
To:     linux-media@vger.kernel.org, mchehab@kernel.org
Cc:     Brad Love <brad@nextdimension.cc>
Subject: [PATCH 1/2] cx231xx-video: Set media controller taint for analog
Date:   Mon, 14 Jan 2019 19:24:07 -0600
Message-Id: <1547515448-15258-2-git-send-email-brad@nextdimension.cc>
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


This sets the taint for the source pad on the bridge to PAD_SIGNAL_ANALOG


Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/usb/cx231xx/cx231xx-video.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index d5e51a5..12f2c00 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -1120,6 +1120,7 @@ void cx231xx_v4l2_create_entities(struct cx231xx *dev)
 		ent->name = iname[INPUT(i)->type];
 		ent->flags = MEDIA_ENT_FL_CONNECTOR;
 		dev->input_pad[i].flags = MEDIA_PAD_FL_SOURCE;
+		dev->input_pad[i].sig_type = PAD_SIGNAL_ANALOG;
 
 		switch (INPUT(i)->type) {
 		case CX231XX_VMUX_COMPOSITE1:
-- 
2.7.4

