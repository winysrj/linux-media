Return-Path: <SRS0=g7QC=O6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 521D7C43387
	for <linux-media@archiver.kernel.org>; Fri, 21 Dec 2018 19:40:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BF2A21934
	for <linux-media@archiver.kernel.org>; Fri, 21 Dec 2018 19:40:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nextdimension.cc header.i=@nextdimension.cc header.b="y2wD0nUx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390019AbeLUTkk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 21 Dec 2018 14:40:40 -0500
Received: from goldenrod.birch.relay.mailchannels.net ([23.83.209.74]:20216
        "EHLO goldenrod.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389101AbeLUTkk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Dec 2018 14:40:40 -0500
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id E90EB5C419F;
        Fri, 21 Dec 2018 19:40:34 +0000 (UTC)
Received: from pdx1-sub0-mail-a63.g.dreamhost.com (unknown [100.96.36.160])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 488065C3B04;
        Fri, 21 Dec 2018 19:40:34 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from pdx1-sub0-mail-a63.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.16.2);
        Fri, 21 Dec 2018 19:40:34 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|brad@nextdimension.ws
X-MailChannels-Auth-Id: dreamhost
X-Zesty-Desert: 3d606a086041c8ac_1545421234642_381245352
X-MC-Loop-Signature: 1545421234642:3807538641
X-MC-Ingress-Time: 1545421234642
Received: from pdx1-sub0-mail-a63.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a63.g.dreamhost.com (Postfix) with ESMTP id C02F681EF2;
        Fri, 21 Dec 2018 11:40:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=nextdimension.cc; h=from
        :to:cc:subject:date:message-id:in-reply-to:references; s=
        nextdimension.cc; bh=2JLwnhDFxvnZk88C6rTdWvDJWJI=; b=y2wD0nUx7uG
        8/E/NIXtVbxKX69YCFnGVIafQ7rpK4wQjjiOirAuUEykCLjMKYNy/yvkcdiCVV0m
        VPe4PoJha5HjX2Lpr6f8jj+9/4PN/RhTsrLqA5WLIGfiJvonjo3/8WakzSueDOFS
        iBrpd0XFq10gtfblkrXnMmY15jnvWKNQ=
Received: from localhost.localdomain (66-90-189-166.dyn.grandenetworks.net [66.90.189.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: brad@nextdimension.ws)
        by pdx1-sub0-mail-a63.g.dreamhost.com (Postfix) with ESMTPSA id 1C64181EF5;
        Fri, 21 Dec 2018 11:40:32 -0800 (PST)
X-DH-BACKEND: pdx1-sub0-mail-a63
From:   Brad Love <brad@nextdimension.cc>
To:     linux-media@vger.kernel.org, mchehab@kernel.org
Cc:     Brad Love <brad@nextdimension.cc>
Subject: [PATCH v2 0/4] Add Hauppauge HVR1955/1975 devices
Date:   Fri, 21 Dec 2018 13:40:19 -0600
Message-Id: <1545421223-3577-1-git-send-email-brad@nextdimension.cc>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1545343031-20935-1-git-send-email-brad@nextdimension.cc>
References: <1545343031-20935-1-git-send-email-brad@nextdimension.cc>
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: 30
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtkedrudejhedgudeftdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucggtfgfnhhsuhgsshgtrhhisggvpdfftffgtefojffquffvnecuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdeftddmnecujfgurhephffvufffkffojghfsedttdertdertddtnecuhfhrohhmpeeurhgrugcunfhovhgvuceosghrrggusehnvgigthguihhmvghnshhiohhnrdgttgeqnecukfhppeeiiedrledtrddukeelrdduieeinecurfgrrhgrmhepmhhouggvpehsmhhtphdphhgvlhhopehlohgtrghlhhhoshhtrdhlohgtrghlughomhgrihhnpdhinhgvthepieeirdeltddrudekledrudeiiedprhgvthhurhhnqdhprghthhepuehrrgguucfnohhvvgcuoegsrhgrugesnhgvgihtughimhgvnhhsihhonhdrtggtqedpmhgrihhlfhhrohhmpegsrhgrugesnhgvgihtughimhgvnhhsihhonhdrtggtpdhnrhgtphhtthhopegsrhgrugesnhgvgihtughimhgvnhhsihhonhdrtggtnecuvehluhhsthgvrhfuihiivgeptd
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hauppauge device HVR1955 and HVR1975 are old Cypress based
devices. When originally produced the demods were lacking
upstream drivers and the tuner was unsupported. Well fast
forward to now and the only thing missing is the identification
of si2177 tuner in the si2157 driver, as well as extension
of the pvrusb2 driver to accomodate i2c client devices
and multiple frontends. This series addresses what is necessary.

QAM/ATSC are fully tested and work, the DVB tuning
*should* work, but is completely untested. Both demod
drivers are compatible with multiple frontend usage due
to previous patches I've submitted, so things should
work in pvrusb2 as well.

Composite video input is tested. Unable to test s-video,
but it should work. Radio is fully untested. Analog TV is
a work in progress, coming soon.

HVR-1955:
- LGDT3306a ATSC/QAM demod
- si2177 tuner
- cx25840 decoder for analog tv/composite/s-video/audio

HVR-1975 dual-frontend:
- LGDT3306a ATSC/QAM demod
- si2168 DVB-C/T/T2 demod
- si2177 tuner
- cx25840 decoder for analog tv/composite/s-video/audio

Changes since v1:
- Patch 4/4 build fixes and reorganization


Brad Love (4):
  si2157: add detection of si2177 tuner
  pvrusb2: Add multiple dvb frontend support
  pvrusb2: Add i2c client demod/tuner support
  pvrusb2: Add Hauppauge HVR1955/1975 devices

 drivers/media/tuners/si2157.c                   |   6 +
 drivers/media/tuners/si2157_priv.h              |   3 +-
 drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.c |  25 +++
 drivers/media/usb/pvrusb2/pvrusb2-devattr.c     | 202 +++++++++++++++++++++---
 drivers/media/usb/pvrusb2/pvrusb2-devattr.h     |   1 +
 drivers/media/usb/pvrusb2/pvrusb2-dvb.c         |  88 ++++++++---
 drivers/media/usb/pvrusb2/pvrusb2-dvb.h         |   5 +-
 drivers/media/usb/pvrusb2/pvrusb2-fx2-cmd.h     |   4 +
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c         |  36 ++++-
 9 files changed, 330 insertions(+), 40 deletions(-)

-- 
2.7.4

