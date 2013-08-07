Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f194.google.com ([209.85.223.194]:65228 "EHLO
	mail-ie0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757001Ab3HGS4X (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Aug 2013 14:56:23 -0400
Received: by mail-ie0-f194.google.com with SMTP id w15so26225iea.9
        for <linux-media@vger.kernel.org>; Wed, 07 Aug 2013 11:56:23 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 7 Aug 2013 20:56:23 +0200
Message-ID: <CAFq0+eTc+aDRDF4YvXTXZoX9jyw97QuuHYZ6U3mhZsL4zHwGUQ@mail.gmail.com>
Subject: PROLINK PixelView PlayTV Cinema BX1500 TV card
From: =?ISO-8859-13?Q?Ivan_Skeled=FEija?= <iskeledz@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, I'm copying my post from the Ubuntu Forums:

// starts here

Hi, I'm running Linux Mint 12 32-bit (the equivalent of Ubuntu 11.10) with
the 3.2.49 kernel and I have the TV card from the title.
Manufacturer's website:
http://www.prolink.com.tw/style/frame/templates15/product_detail.asp?lang=2&customer_id=1470&name_id=36169&rid=17744&id=79936&content_set=color_5

I have properly installed the latest V4L drivers following this guide:
http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers

However, it looks like the driver doesn't have support for this particular
card as noted in the first warning in the above article. The proper kernel
module (cx23885) loads, but it doesn't do anything. I've tried it with
MythTV, Kaffeine and VLC and all of them report that there is no capture
card.

This is the output of lspci -v:
04:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885 PCI
Video and Audio Decoder (rev 02)
    Subsystem: PROLINK Microsystems Corp Device 4980
    Flags: bus master, fast devsel, latency 0, IRQ 16
    Memory at fbe00000 (64-bit, non-prefetchable) [size=2M]
    Capabilities: [40] Express Endpoint, MSI 00
    Capabilities: [80] Power Management version 2
    Capabilities: [90] Vital Product Data
    Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
    Kernel driver in use: cx23885
    Kernel modules: cx23885

The output of dmesg is here: http://pastebin.com/yVK2NE3u
Trying to modprobe the module with other card ids just spits out a bunch of
errors in dmesg.

// ends here

I have been googling a lot and found no information whatsoever about this
and similar PlayTV Cinema cards on Linux. After receiving no reply on
Ubuntu Forums, on linuxtv.org wiki I found that I can contact LMML directly
about driver support. So I was wondering if there is any way to add support
for this and similar cards to the cx23885 driver. I am willing to provide
more information if necessary.
