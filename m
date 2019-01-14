Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DAA5C43387
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 05:16:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2F6F2086D
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 05:16:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="V7Q/IxSA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726064AbfANFQy (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 00:16:54 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:38937 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725837AbfANFQx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 00:16:53 -0500
X-Greylist: delayed 386 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Jan 2019 00:16:53 EST
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id A86292893C
        for <linux-media@vger.kernel.org>; Mon, 14 Jan 2019 00:10:26 -0500 (EST)
Received: from web3 ([10.202.2.213])
  by compute6.internal (MEProxy); Mon, 14 Jan 2019 00:10:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=PwZuFV
        O4MMhvpzRFuZq31yHcXKYYD/IucgXCQzvltcI=; b=V7Q/IxSACgcg8ZnAqdAxpb
        vdSMx0nEhA190VG1alpphkzoj0oJQEBXfSk4ybmThlV7FE38JqtIMGK+SYikfj2i
        RwqwAbiA9M8H8XkeoQViYoobEBdcW++TX5HGFS1ezZ3+Hd5f3h1AnlUAxn6Os/A7
        lktMmCiKH1NChwjn4S5thgs/GvCaaBvIzCsusinYDQeT8IpEZUbBHaox/vNE6glb
        WAUOTNvUuMOc0su3lHkqLvseceoEqYhaXwwIvCyL3/aVV2OR+QjtqmXEejZ1FrLA
        DQrsf6nqaZGF2i5457caMlBw68qLufuxr81633g1f3Iesi0M9XL7WbMcOHDkgLZQ
        ==
X-ME-Sender: <xms:wRk8XIq1y2kPSwicsrLeKjNYLhm_aqdtkVmzvNGXzI-HtptVGycXRg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedtledrgedtgdekvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfhuthenuceurghilhhouhhtmecufedt
    tdenucgoteefjeefqddtgeculdehtddmnecujfgurhepkffhvfgggfgtofffufesthejre
    dtredtjeenucfhrhhomhepmfgrihcujfgvnhgurhihuceohhgvnhgurhihsehikhhirdhf
    iheqnecuffhomhgrihhnpehnrghtrghlihgrnhdrohhrghenucfrrghrrghmpehmrghilh
    hfrhhomhephhgvnhgurhihsehikhhirdhfihenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:wRk8XP6748NsqNgpxYYkfpXAilA7jFAFm_9gF8czJINiQFh_JdT8Lg>
    <xmx:wRk8XKScFzCMfuFrM2sXep1L5_5AxGNaBZM9s-avPRAoKhVdQZOmgQ>
    <xmx:wRk8XC4MHSNPMrT4qYtXn3FL-cRNKrDfVUJuKi6d3NCaAtj1eiRX1Q>
    <xmx:whk8XCL7wF-qW44LL_PisU6RgO5pwYiSYVp9Gs3gR55LV4Q-DJq7Vw>
Received: by mailuser.nyi.internal (Postfix, from userid 99)
        id B65C39E564; Mon, 14 Jan 2019 00:10:25 -0500 (EST)
Message-Id: <1547442625.3056462.1633755704.1BCFEEC2@webmail.messagingengine.com>
From:   Kai Hendry <hendry@iki.fi>
To:     linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Mailer: MessagingEngine.com Webmail Interface - ajax-36e4bfd3
Date:   Mon, 14 Jan 2019 13:10:25 +0800
Subject: Magewell Gen 2935:0001 USB annoyances
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Archlinux user here. It doesn't matter whether I'm running LTS kernel 4.19.14-1-lts or 4.20.1.arch1-1, I get these very annoying USB issues with my Magewell XI100DUSB-HDMI. Most of the time it doesn't work. I seemingly have better chances of getting it working after a reboot.

I don't know if this is a UVC issue or a USB issue on my Gen8 Thinkpad T480s. All I can say for a fact is that plugging this device into my Macbook Pro running MacOS via a USB-C dongle, is more reliable. I've had the same "plug in" issues admittedly on previous Thinkpad hardware and kernel versions.

Another annoying aspect, is that it also seems to drop USB speeds when hot plugging. I need USB 3 else it won't be able to get 60fps at 1080p.
https://s.natalian.org/2019-01-14/1547438681_2548x1398.png

It's a crazy ritual with accompanying dance when I get USB3 and my /dev/video2 actually working.

This is what dmesg looks like when it's flailing.

[   71.896534] usb 2-2: Disable of device-initiated U1 failed.
[   71.900554] usb 2-2: Disable of device-initiated U2 failed.
[   71.909474] usb 2-2: Set SEL for device-initiated U1 failed.
[   72.691371] usb 2-2: USB disconnect, device number 6
[   73.041273] usb 1-2: new high-speed USB device number 10 using xhci_hcd
[   73.620177] usb 1-2: New USB device found, idVendor=2935, idProduct=0001, bcdDevice= 0.00
[   73.620180] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   73.620182] usb 1-2: Product: XI100DUSB-HDMI
[   73.620183] usb 1-2: Manufacturer: Magewell
[   73.620185] usb 1-2: SerialNumber: C021150326019
[   76.920993] usb 2-2: Set SEL for device-initiated U2 failed.
[   76.923341] uvcvideo: Found UVC 1.00 device XI100DUSB-HDMI (2935:0001)
[   76.925324] uvcvideo 1-2:1.0: Entity type for entity Processing 2 was not initialized!
[   76.925327] uvcvideo 1-2:1.0: Entity type for entity Camera 1 was not initialized!
[   76.925413] input: XI100DUSB-HDMI: XI100DUSB-HDMI  as /devices/pci0000:00/0000:00:14.0/usb1/1-2/1-2:1.0/input/input25
[   76.928710] usbhid 1-2:1.4: couldn't find an input interrupt endpoint
[   91.516482] usb 1-2: USB disconnect, device number 10


Is there any workarounds or ideas to make my capture device less annoying? Thank you in advance,
