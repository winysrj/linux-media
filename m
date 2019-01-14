Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AA84C43387
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 11:30:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28B832086D
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 11:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547465437;
	bh=wP9CUN65w0vsyFo6q8+EgE5+dA8ZaRO5cqjLZH6V72g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=EGs+yCAkhNwgHciu0NzxTgROsbSy8biM7gJvXGwhhPtCWeOCkCGF5y8RZInZyYKJl
	 a4LvfbbLlvpyGpQW5VXOxrJCfNLiEplMyQCIBpzFOrklRGC9oWngYKY6v/yPi8Qi9B
	 eam5bKdMJdIyLThGCjJ7JZizDSY82XlhaDEpqyDc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbfANLag (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 06:30:36 -0500
Received: from casper.infradead.org ([85.118.1.10]:41974 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbfANLaf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 06:30:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=RFZ435qnTSMpY3SX4Fd1ZTXS93GcokJs6mT6OKqAgZc=; b=e1Y53oXng+vE+auOPo+iJSeCSc
        TnCGPOTRys5CrHXc1QqVS+UcMzsO9F+fUl0HUNKseys0W6yBDGy8jlRxcnhWsY+pFBV1of7M6znmC
        q1wpBS8+GeZSNz0jR+TIguz4Ox/jWtI/DGH+rs7Ot3uWO9TDZkZLqphemzjzpKjyARyMnVb+0jfA9
        ruFBMhJPWH6OuJuQdREE8UffTjWW15gL8R8Lv5ur7hbDrsuaK6p2p7wXixUCr3OnqdEmxOiz7vxuD
        uFqqSRE5LlpsnVcKnQ2Rslp4EMEuH0+NNJlI96pCzRv0jRXG8uLWuH4t1+L7OhZjkaUpQSDSlEjnb
        LSSJk3/A==;
Received: from [177.159.251.133] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gj0Rt-0004Ps-9E; Mon, 14 Jan 2019 11:30:33 +0000
Date:   Mon, 14 Jan 2019 09:30:29 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Kai Hendry <hendry@iki.fi>
Cc:     linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-usb@vger.kernel.org
Subject: Re: Magewell Gen 2935:0001 USB annoyances
Message-ID: <20190114093029.6bb2ff00@coco.lan>
In-Reply-To: <1547442625.3056462.1633755704.1BCFEEC2@webmail.messagingengine.com>
References: <1547442625.3056462.1633755704.1BCFEEC2@webmail.messagingengine.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Mon, 14 Jan 2019 13:10:25 +0800
Kai Hendry <hendry@iki.fi> escreveu:

> Archlinux user here. It doesn't matter whether I'm running LTS kernel 4.19.14-1-lts or 4.20.1.arch1-1, I get these very annoying USB issues with my Magewell XI100DUSB-HDMI. Most of the time it doesn't work. I seemingly have better chances of getting it working after a reboot.
> 
> I don't know if this is a UVC issue or a USB issue on my Gen8 Thinkpad T480s. All I can say for a fact is that plugging this device into my Macbook Pro running MacOS via a USB-C dongle, is more reliable. I've had the same "plug in" issues admittedly on previous Thinkpad hardware and kernel versions.
> 
> Another annoying aspect, is that it also seems to drop USB speeds when hot plugging. I need USB 3 else it won't be able to get 60fps at 1080p.

(adding c/c to linux-usb)

If the image is not compressed, a 640x480 image with 16 bits per pixel
and 30 frames per second eats 60% of the USB 2.0 maximum number of
ISOC frames with em28xx driver[1].

[1] The actual value is driver/device specific, as it depends on the
maximum frame size.

So, I'm pretty sure that you won't be able to get 60fps at 1080p
if it doesn't enable USB 3.0 SuperSpeed mode.

That's said, it is up to the USB stack to detect the device as an
USB 3.0. If this is not working well, it could either be a hardware
problem or some issue at the USB host driver.

> https://s.natalian.org/2019-01-14/1547438681_2548x1398.png
> 
> It's a crazy ritual with accompanying dance when I get USB3 and my /dev/video2 actually working.
> 
> This is what dmesg looks like when it's flailing.
> 
> [   71.896534] usb 2-2: Disable of device-initiated U1 failed.
> [   71.900554] usb 2-2: Disable of device-initiated U2 failed.
> [   71.909474] usb 2-2: Set SEL for device-initiated U1 failed.
> [   72.691371] usb 2-2: USB disconnect, device number 6
> [   73.041273] usb 1-2: new high-speed USB device number 10 using xhci_hcd
> [   73.620177] usb 1-2: New USB device found, idVendor=2935, idProduct=0001, bcdDevice= 0.00
> [   73.620180] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [   73.620182] usb 1-2: Product: XI100DUSB-HDMI
> [   73.620183] usb 1-2: Manufacturer: Magewell
> [   73.620185] usb 1-2: SerialNumber: C021150326019
> [   76.920993] usb 2-2: Set SEL for device-initiated U2 failed.

Everything here happens at USB host driver and USB subsystem.

> [   76.923341] uvcvideo: Found UVC 1.00 device XI100DUSB-HDMI (2935:0001)
> [   76.925324] uvcvideo 1-2:1.0: Entity type for entity Processing 2 was not initialized!
> [   76.925327] uvcvideo 1-2:1.0: Entity type for entity Camera 1 was not initialized!

The above is at uvcvideo, and seems OK to my eyes.

> [   76.925413] input: XI100DUSB-HDMI: XI100DUSB-HDMI  as /devices/pci0000:00/0000:00:14.0/usb1/1-2/1-2:1.0/input/input25
> [   76.928710] usbhid 1-2:1.4: couldn't find an input interrupt endpoint

This is related to input/evdev probing. Also unrelated to media.

> [   91.516482] usb 1-2: USB disconnect, device number 10

This is also at USB subsystem. Usually, it indicates a bad contact at the
USB cable.

> Is there any workarounds or ideas to make my capture device less annoying? Thank you in advance,

I would try to buy a high quality USB 3.0 cable, and see if things improve.

You should remember that a USB 3.0 data transfer will use higher
frequency signals, making the cable more susceptible to interference.

So, a cable with a good shield can make a difference, specially if
you're passing it close to other cables.

Thanks,
Mauro
