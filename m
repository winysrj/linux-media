Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4617C43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 01:24:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 948D1206BA
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 01:24:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nextdimension.cc header.i=@nextdimension.cc header.b="0FvtaCpp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727342AbfAOBYV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 20:24:21 -0500
Received: from quail.birch.relay.mailchannels.net ([23.83.209.151]:12961 "EHLO
        quail.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727195AbfAOBYV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 20:24:21 -0500
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 17C765C43CA;
        Tue, 15 Jan 2019 01:24:18 +0000 (UTC)
Received: from pdx1-sub0-mail-a35.g.dreamhost.com (unknown [100.96.33.121])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id C78305C4407;
        Tue, 15 Jan 2019 01:24:17 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from pdx1-sub0-mail-a35.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.16.2);
        Tue, 15 Jan 2019 01:24:18 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|brad@nextdimension.ws
X-MailChannels-Auth-Id: dreamhost
X-Left-Bored: 40d250875a2d1403_1547515457929_625262536
X-MC-Loop-Signature: 1547515457929:4011671161
X-MC-Ingress-Time: 1547515457929
Received: from pdx1-sub0-mail-a35.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a35.g.dreamhost.com (Postfix) with ESMTP id 7F4C67ED32;
        Mon, 14 Jan 2019 17:24:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=nextdimension.cc; h=from
        :to:cc:subject:date:message-id; s=nextdimension.cc; bh=8kDoeiy1K
        ewwHjKjSDCq+elBIpw=; b=0FvtaCppRTjvf5EKe7LhID+rjD7qpJIYSMdSo/P2x
        kmBQ4m/eg59uHFKAZiPEzQd+ylXZOGEyYYxfY+hEMgWAmK28bvZJ+ada9HBU/7xN
        24E7b1Eos7PS1YgDmYYLTPdSOnuedulBAfLfYKuduXkwHi7atC0NMRTlvUW8Wn1Q
        0A=
Received: from localhost.localdomain (66-90-189-166.dyn.grandenetworks.net [66.90.189.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: brad@nextdimension.ws)
        by pdx1-sub0-mail-a35.g.dreamhost.com (Postfix) with ESMTPSA id E5211811B6;
        Mon, 14 Jan 2019 17:24:16 -0800 (PST)
X-DH-BACKEND: pdx1-sub0-mail-a35
From:   Brad Love <brad@nextdimension.cc>
To:     linux-media@vger.kernel.org, mchehab@kernel.org
Cc:     Brad Love <brad@nextdimension.cc>
Subject: [PATCH 0/2] Media Controller "taint" fixes
Date:   Mon, 14 Jan 2019 19:24:06 -0600
Message-Id: <1547515448-15258-1-git-send-email-brad@nextdimension.cc>
X-Mailer: git-send-email 2.7.4
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: 30
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtledrgedvgdefvdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucggtfgfnhhsuhgsshgtrhhisggvpdfftffgtefojffquffvnecuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdeftddmnecujfgurhephffvufffkffosedttdertdertddtnecuhfhrohhmpeeurhgrugcunfhovhgvuceosghrrggusehnvgigthguihhmvghnshhiohhnrdgttgeqnecukfhppeeiiedrledtrddukeelrdduieeinecurfgrrhgrmhepmhhouggvpehsmhhtphdphhgvlhhopehlohgtrghlhhhoshhtrdhlohgtrghlughomhgrihhnpdhinhgvthepieeirdeltddrudekledrudeiiedprhgvthhurhhnqdhprghthhepuehrrgguucfnohhvvgcuoegsrhgrugesnhgvgihtughimhgvnhhsihhonhdrtggtqedpmhgrihhlfhhrohhmpegsrhgrugesnhgvgihtughimhgvnhhsihhonhdrtggtpdhnrhgtphhtthhopegsrhgrugesnhgvgihtughimhgvnhhsihhonhdrtggtnecuvehluhhsthgvrhfuihiivgeptd
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hauppauge USBLive2 was reported broken. A change in media controller
logic appears to be the culprit.

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


This series sets the taint as follows:
- source pads from the bridge to PAD_SIGNAL_ANALOG
- sink pads on the decoder to PAD_SIGNAL_ANALOG
- source pads on the decoder to PAD_SIGNAL_DV



Brad Love (2):
  cx231xx-video: Set media controller taint for analog outputs
  cx25840-core: Set media controller taint for pads

 drivers/media/i2c/cx25840/cx25840-core.c  | 6 ++++++
 drivers/media/usb/cx231xx/cx231xx-video.c | 1 +
 2 files changed, 7 insertions(+)

-- 
2.7.4

