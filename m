Return-Path: <SRS0=3Wpa=PB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84A0DC64E79
	for <linux-media@archiver.kernel.org>; Mon, 24 Dec 2018 17:00:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E367218B0
	for <linux-media@archiver.kernel.org>; Mon, 24 Dec 2018 17:00:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nextdimension.cc header.i=@nextdimension.cc header.b="o2Mocan2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725784AbeLXRAu (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 24 Dec 2018 12:00:50 -0500
Received: from bonobo.maple.relay.mailchannels.net ([23.83.214.22]:17694 "EHLO
        bonobo.maple.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725385AbeLXRAu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Dec 2018 12:00:50 -0500
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id DF55D5E3805;
        Mon, 24 Dec 2018 17:00:48 +0000 (UTC)
Received: from pdx1-sub0-mail-a7.g.dreamhost.com (unknown [100.96.29.126])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id A406E5E3852;
        Mon, 24 Dec 2018 17:00:48 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from pdx1-sub0-mail-a7.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.16.2);
        Mon, 24 Dec 2018 17:00:48 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|brad@nextdimension.ws
X-MailChannels-Auth-Id: dreamhost
X-Society-Supply: 3667b1cc221722aa_1545670848774_506782426
X-MC-Loop-Signature: 1545670848774:601967438
X-MC-Ingress-Time: 1545670848774
Received: from pdx1-sub0-mail-a7.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a7.g.dreamhost.com (Postfix) with ESMTP id 6D9E480166;
        Mon, 24 Dec 2018 09:00:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=nextdimension.cc; h=from
        :to:cc:subject:date:message-id:in-reply-to:references; s=
        nextdimension.cc; bh=a3f4s3neLV0scx2d5vi1GoR8Sds=; b=o2Mocan22h6
        zvN1Fr+aqlBLvPb2yBJD3kmUciY1LjeQkrRmpQUEfTwtg7sdht6nRE9sUc4ln7y/
        BsRRl0Z6vcHpgYaPHxhbqKAENpmsl4b0QrMPUJILsbsDPqVxdBAvJxncYf2z1B0j
        JFIzbXuFmhmVmljjq0xG1yiDjGWz/cMg=
Received: from localhost.localdomain (66-90-189-166.dyn.grandenetworks.net [66.90.189.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: brad@nextdimension.ws)
        by pdx1-sub0-mail-a7.g.dreamhost.com (Postfix) with ESMTPSA id B886680167;
        Mon, 24 Dec 2018 09:00:47 -0800 (PST)
X-DH-BACKEND: pdx1-sub0-mail-a7
From:   Brad Love <brad@nextdimension.cc>
To:     linux-media@vger.kernel.org, mchehab@kernel.org
Cc:     Brad Love <brad@nextdimension.cc>
Subject: [PATCH v3 0/4] Add Hauppauge HVR1955/1975 devices
Date:   Mon, 24 Dec 2018 11:00:32 -0600
Message-Id: <1545670836-24035-1-git-send-email-brad@nextdimension.cc>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1545421223-3577-1-git-send-email-brad@nextdimension.cc>
References: <1545421223-3577-1-git-send-email-brad@nextdimension.cc>
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: 30
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtkedrudekuddgleejucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfedtmdenucfjughrpefhvffufffkofgjfhestddtredtredttdenucfhrhhomhepuehrrgguucfnohhvvgcuoegsrhgrugesnhgvgihtughimhgvnhhsihhonhdrtggtqeenucfkphepieeirdeltddrudekledrudeiieenucfrrghrrghmpehmohguvgepshhmthhppdhhvghloheplhhotggrlhhhohhsthdrlhhotggrlhguohhmrghinhdpihhnvghtpeeiiedrledtrddukeelrdduieeipdhrvghtuhhrnhdqphgrthhhpeeurhgrugcunfhovhgvuceosghrrggusehnvgigthguihhmvghnshhiohhnrdgttgeqpdhmrghilhhfrhhomhepsghrrggusehnvgigthguihhmvghnshhiohhnrdgttgdpnhhrtghpthhtohepsghrrggusehnvgigthguihhmvghnshhiohhnrdgttgenucevlhhushhtvghrufhiiigvpedt
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

Since v2:
- Patch 4/4 build fix
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

