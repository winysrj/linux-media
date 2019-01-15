Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1C0FC43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 01:56:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87FD42063F
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 01:56:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ohBpz33k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbfAOB42 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 20:56:28 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:59317 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727169AbfAOB41 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 20:56:27 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id E4EE22904F;
        Mon, 14 Jan 2019 20:56:26 -0500 (EST)
Received: from web3 ([10.202.2.213])
  by compute6.internal (MEProxy); Mon, 14 Jan 2019 20:56:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=aDPD+j7N8+MQFmqmpBSOasf7oaYbaowIZVzf/a8s2
        wc=; b=ohBpz33krjDn5SQ9NG00N5s7JvQjiOmex6OPf3GO8ujczklYAIS4AmiUW
        PLwSoQiJTkRhAOJD5DsOmBycmZ9dUFwhqKp2a6fISlSUuG+EGIfuZFsRoX0auowR
        sXxjuhAWkEYXMeHmSCdNzAqf40VT+W75bD0mY1v3u3jJ7M5Nn61nMq4IXK0Li1zt
        l1DlX1NuFneoLgDs4CA5POC3OzmeFIOhgnjIVzt1w5NhvF30StnYf3lRDH7XQXxY
        Dz+6X5//mu8kqaKckosRWQNicRHlUviqiqLwu6fb89YofAq8w6M3yfhNtgeuq5EF
        btvdSvXKCjCvJUcBe+2arHMe+IdtA==
X-ME-Sender: <xms:yj09XE-Ts7wI57rRMizI_mKUBS9ZR-gYnOm9RHP1RXqXZDOtrlMbZg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedtledrgedvgdefkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfhuthenuceurghilhhouhhtmecufedt
    tdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkffhvfgggfgtof
    ffjghfufesthejredtredtjeenucfhrhhomhepmfgrihcujfgvnhgurhihuceohhgvnhgu
    rhihsehikhhirdhfiheqnecuffhomhgrihhnpehnrghtrghlihgrnhdrohhrghenucfrrg
    hrrghmpehmrghilhhfrhhomhephhgvnhgurhihsehikhhirdhfihenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:yj09XGaVL9u96T_ZpT9IcR2gb2QGrRX6bWYGSCCJl-fTT7OBq-Sfog>
    <xmx:yj09XJWB5UBiSgdZF8nDYUCNIt79MchczKocnQp9EG4V62gTOwd_EA>
    <xmx:yj09XMgogY_3Awa4ey9YVxy1exLA18OBq-iJ-1Vcz90LHGUDO8aC1w>
    <xmx:yj09XEvFbxQyZDjXbdSO5kdLaZM7Pq2d9tGSCew22xg2WlSNSdnEqQ>
Received: by mailuser.nyi.internal (Postfix, from userid 99)
        id 12C509E5A7; Mon, 14 Jan 2019 20:56:26 -0500 (EST)
Message-Id: <1547517386.513774.1634722944.3BD7EE05@webmail.messagingengine.com>
From:   Kai Hendry <hendry@iki.fi>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-usb@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Mailer: MessagingEngine.com Webmail Interface - ajax-36e4bfd3
Date:   Tue, 15 Jan 2019 09:56:26 +0800
In-Reply-To: <20190114093029.6bb2ff00@coco.lan>
References: <1547442625.3056462.1633755704.1BCFEEC2@webmail.messagingengine.com>
 <20190114093029.6bb2ff00@coco.lan>
Subject: Re: Magewell Gen 2935:0001 USB annoyances
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Thanks for getting back to me Mauro.

So it works on MacOS.... via a hootoo USB-C dongle https://s.natalian.org/2019-01-15/hootoo.jpeg

So since my T480s has two USB-C ports, I tried using the same dongle on my Thinkpad. It works!

I discovered that I can reliably get the device working by using another USB-C adaptor. https://s.natalian.org/2019-01-15/ss.jpeg

This to my astonishment reliably works.

[hendry@t480s ~]$ lsusb -vvv 2>/dev/null | grep -A5 2935:0001
Bus 004 Device 002: ID 2935:0001
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               3.00
  bDeviceClass          239 Miscellaneous Device


Maybe it's some USB bus power supply issue on my other Thinkpad ports. No idea.

Thanks for sounding me out.
