Return-Path: <SRS0=xT8T=PG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E6BCC43387
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 17:51:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1669A2146F
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 17:51:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nextdimension.cc header.i=@nextdimension.cc header.b="r4tdmenz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727643AbeL2Rva (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 29 Dec 2018 12:51:30 -0500
Received: from palegreen.birch.relay.mailchannels.net ([23.83.209.140]:65229
        "EHLO palegreen.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727581AbeL2Rva (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Dec 2018 12:51:30 -0500
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 27A2642B72;
        Sat, 29 Dec 2018 17:51:29 +0000 (UTC)
Received: from pdx1-sub0-mail-a20.g.dreamhost.com (unknown [100.96.26.166])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id C5D4F433C8;
        Sat, 29 Dec 2018 17:51:28 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|brad@nextdimension.ws
Received: from pdx1-sub0-mail-a20.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.16.2);
        Sat, 29 Dec 2018 17:51:29 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|brad@nextdimension.ws
X-MailChannels-Auth-Id: dreamhost
X-Minister-Coil: 762c03be48f76c53_1546105889007_2663375007
X-MC-Loop-Signature: 1546105889007:1698896971
X-MC-Ingress-Time: 1546105889007
Received: from pdx1-sub0-mail-a20.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a20.g.dreamhost.com (Postfix) with ESMTP id 6A7C9805E8;
        Sat, 29 Dec 2018 09:51:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=nextdimension.cc; h=from
        :to:cc:subject:date:message-id; s=nextdimension.cc; bh=vTmcFVmws
        yhqQ9PuynP/5AnLsSM=; b=r4tdmenzbSKHac46nMqA0yyIaDHV5S1PDvxqv88a3
        eFsDq7+eUySFxbObtKrHWNQLI4gecuH60rX7JNn0ApElHcFMN33I72DD9FwT3DnU
        W/aTyujyLRjgzT5uxJZZIvkIerihgYrvkyqcINtY29EtKTd6n9UGx3ixjSKi+fn8
        mQ=
Received: from localhost.localdomain (66-90-189-166.dyn.grandenetworks.net [66.90.189.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: brad@nextdimension.ws)
        by pdx1-sub0-mail-a20.g.dreamhost.com (Postfix) with ESMTPSA id E44AD805D7;
        Sat, 29 Dec 2018 09:51:26 -0800 (PST)
X-DH-BACKEND: pdx1-sub0-mail-a20
From:   Brad Love <brad@nextdimension.cc>
To:     linux-media@vger.kernel.org, mchehab@kernel.org
Cc:     Brad Love <brad@nextdimension.cc>
Subject: [PATCH 00/13] si2157: Analog tuning and optimizations
Date:   Sat, 29 Dec 2018 11:51:09 -0600
Message-Id: <1546105882-15693-1-git-send-email-brad@nextdimension.cc>
X-Mailer: git-send-email 2.7.4
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: 30
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtledrtdekgddutdejucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfedtmdenucfjughrpefhvffufffkofestddtredtredttdenucfhrhhomhepuehrrgguucfnohhvvgcuoegsrhgrugesnhgvgihtughimhgvnhhsihhonhdrtggtqeenucfkphepieeirdeltddrudekledrudeiieenucfrrghrrghmpehmohguvgepshhmthhppdhhvghloheplhhotggrlhhhohhsthdrlhhotggrlhguohhmrghinhdpihhnvghtpeeiiedrledtrddukeelrdduieeipdhrvghtuhhrnhdqphgrthhhpeeurhgrugcunfhovhgvuceosghrrggusehnvgigthguihhmvghnshhiohhnrdgttgeqpdhmrghilhhfrhhomhepsghrrggusehnvgigthguihhmvghnshhiohhnrdgttgdpnhhrtghpthhtohepsghrrggusehnvgigthguihhmvghnshhiohhnrdgttgenucevlhhushhtvghrufhiiigvpedt
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This series mainly enables analog tuning in the si2157
driver. Some various optimizations are included as well,
along with the dots connected to allow devices with
TUNER_ABSENT to utilize an analog frontend on two different
bridges. Finally two missing statistics are added to get
signal strength and CNR on a tuner and demod respectively.

Summary:
- Enable tuner status flags
- Check tuner status flags
- Some si2141 init
- String cleanup and register labeling
- The analog tuning functions in si2157
- A function to wait for set_*params to complete
- Enable analog fe on TUNER_ABSENT devices in cx231xx and cx23885
- Include some signal strength DVBv5 stats

Now the two patches that 'Add i2c device analog tuner support'
I would like comment on. It looks quite ugly to have big case
statements identifying the TUNER_ABSENT models that have analog.
There is nothing unique done in the blocks, mostly. Right now
there is only a few models, but the addition of more would become
a bit excessive.

Instead of the case statement should a board profile field be
added to the two affected drivers? Something like .has_i2c_analog_fe ?


Brad Love (13):
  si2157: Enable tuner status flags
  si2157: Check error status bit on cmd execute
  si2157: Better check for running tuner in init
  si2157: Add clock and pin setup for si2141
  cx25840: Register labeling, chip specific correction
  si2157: Add analog tuning related functions
  si2157: Briefly wait for tuning operation to complete
  cx23885: Add analog tuner support to Hauppauge QuadHD
  cx23885: Add analog tuner to 1265_K4
  cx23885: Add i2c device analog tuner support
  cx231xx: Add i2c device analog tuner support
  si2157: add on-demand rf strength func
  lgdt3306a: Add CNR v5 stat

 drivers/media/dvb-frontends/lgdt3306a.c    |  14 +
 drivers/media/i2c/cx25840/cx25840-core.c   |  33 ++-
 drivers/media/pci/cx23885/cx23885-cards.c  |  39 ++-
 drivers/media/pci/cx23885/cx23885-dvb.c    |  25 ++
 drivers/media/pci/cx23885/cx23885-video.c  |  68 ++++-
 drivers/media/tuners/si2157.c              | 436 ++++++++++++++++++++++++++++-
 drivers/media/tuners/si2157_priv.h         |   2 +
 drivers/media/usb/cx231xx/cx231xx-avcore.c |  35 ++-
 drivers/media/usb/cx231xx/cx231xx-video.c  |  57 +++-
 9 files changed, 651 insertions(+), 58 deletions(-)

-- 
2.7.4

