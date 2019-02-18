Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94316C43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 16:08:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6635C20836
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 16:08:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731142AbfBRQIL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 11:08:11 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:44685 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730490AbfBRQIK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 11:08:10 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud8.xs4all.net with ESMTPA
        id vlSfgbyQi4HFnvlSig0V4d; Mon, 18 Feb 2019 17:08:08 +0100
Subject: Re: [PATCH 0/2] Media Controller "taint" fixes
To:     Brad Love <brad@nextdimension.cc>, linux-media@vger.kernel.org,
        mchehab@kernel.org
References: <1547515448-15258-1-git-send-email-brad@nextdimension.cc>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5e18a556-17fa-de72-a915-45a5f1bea018@xs4all.nl>
Date:   Mon, 18 Feb 2019 17:08:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1547515448-15258-1-git-send-email-brad@nextdimension.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfH1az4aS02TRKZWGqRZx+adwSt7DLcGYxlK1MG+ktIEHwlWhfJ4r6QmW+TokaCrMK+cbeLkptNXHqb+uIRPivI0rcLhBW1CY2yezGjv+Hmxn1Pw533Yj
 bXpzRon+2WcZ62GPsr9i02f8TRw56vOgH8nmxeGuNeUc1dupt5cbkAghPMQ5x+Hwsy4mxOgUnoldt9f7xTgT3eReJdV8teBXxmUdglJsjn/ViqEEFV0c9R8x
 Nig6fiI7k4RL5v8+ykiTcw==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Brad,

On 1/15/19 2:24 AM, Brad Love wrote:
> Hauppauge USBLive2 was reported broken. A change in media controller
> logic appears to be the culprit.
> 
> Fixes: 9d6d20e652 ("v4l2-mc: switch it to use the new approach to setup pipelines")
> 
> Without "taint" set for signal type, devices
> with analog capture fail during probe:
> 
> [    5.821715] cx231xx 3-2:1.1: v4l2 driver version 0.0.3
> [    5.955721] cx231xx 3-2:1.1: Registered video device video0 [v4l2]
> [    5.955797] cx231xx 3-2:1.1: Registered VBI device vbi0
> [    5.955802] cx231xx 3-2:1.1: video EndPoint Addr 0x84, Alternate settings: 5
> [    5.955805] cx231xx 3-2:1.1: VBI EndPoint Addr 0x85, Alternate settings: 2
> [    5.955807] cx231xx 3-2:1.1: sliced CC EndPoint Addr 0x86, Alternate settings: 2
> [    5.955834] cx231xx 3-2:1.1: V4L2 device vbi0 deregistered
> [    5.955889] cx231xx 3-2:1.1: V4L2 device video0 deregistered
> [    5.959131] cx231xx: probe of 3-2:1.1 failed with error -22
> [    5.959190] usbcore: registered new interface driver cx231xx
> 
> 
> This series sets the taint as follows:
> - source pads from the bridge to PAD_SIGNAL_ANALOG
> - sink pads on the decoder to PAD_SIGNAL_ANALOG
> - source pads on the decoder to PAD_SIGNAL_DV

Mauro asked me to look at this, but it is still failing for me:

[ 2046.476092] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.00
[ 2046.476098] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[ 2046.476102] usb usb3: Product: xHCI Host Controller
[ 2046.476107] usb usb3: Manufacturer: Linux 5.0.0-rc1-zen xhci-hcd
[ 2046.476111] usb usb3: SerialNumber: 0000:39:00.0
[ 2046.476677] hub 3-0:1.0: USB hub found
[ 2046.476898] hub 3-0:1.0: 2 ports detected
[ 2046.478160] xhci_hcd 0000:39:00.0: xHCI Host Controller
[ 2046.478677] xhci_hcd 0000:39:00.0: new USB bus registered, assigned bus number 4
[ 2046.478690] xhci_hcd 0000:39:00.0: Host supports USB 3.1 Enhanced SuperSpeed
[ 2046.478838] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.00
[ 2046.478843] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[ 2046.478847] usb usb4: Product: xHCI Host Controller
[ 2046.478851] usb usb4: Manufacturer: Linux 5.0.0-rc1-zen xhci-hcd
[ 2046.478855] usb usb4: SerialNumber: 0000:39:00.0
[ 2046.479180] hub 4-0:1.0: USB hub found
[ 2046.479206] hub 4-0:1.0: 2 ports detected
[ 2046.802013] usb 3-2: new high-speed USB device number 2 using xhci_hcd
[ 2046.934170] usb 3-2: New USB device found, idVendor=2040, idProduct=c200, bcdDevice=40.01
[ 2046.934188] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[ 2046.934197] usb 3-2: Product: Hauppauge Device
[ 2046.934206] usb 3-2: Manufacturer: Hauppauge
[ 2046.934214] usb 3-2: SerialNumber: 0013567005
[ 2046.942224] cx231xx 3-2:1.1: New device Hauppauge Hauppauge Device @ 480 Mbps (2040:c200) with 6 interfaces
[ 2046.942626] cx231xx 3-2:1.1: can't change interface 3 alt no. to 3: Max. Pkt size = 0
[ 2046.942631] cx231xx 3-2:1.1: Identified as Hauppauge USB Live 2 (card=9)
[ 2046.944251] i2c i2c-10: Added multiplexed i2c bus 12
[ 2046.944382] i2c i2c-10: Added multiplexed i2c bus 13
[ 2047.054566] cx25840 9-0044: cx23102 A/V decoder found @ 0x88 (cx231xx #0-0)
[ 2049.997665] cx25840 9-0044: loaded v4l-cx231xx-avcore-01.fw firmware (16382 bytes)
[ 2050.091897] cx231xx 3-2:1.1: v4l2 driver version 0.0.3
[ 2050.307929] cx231xx 3-2:1.1: Registered video device video0 [v4l2]
[ 2050.308349] cx231xx 3-2:1.1: Registered VBI device vbi0
[ 2050.314083] cx231xx 3-2:1.1: audio EndPoint Addr 0x83, Alternate settings: 3
[ 2050.314131] cx231xx 3-2:1.1: video EndPoint Addr 0x84, Alternate settings: 5
[ 2050.314135] cx231xx 3-2:1.1: VBI EndPoint Addr 0x85, Alternate settings: 2
[ 2050.314138] cx231xx 3-2:1.1: sliced CC EndPoint Addr 0x86, Alternate settings: 2
[ 2050.314148] usb 3-2: couldn't get decoder output pad for V4L I/O
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

[ 2050.314151] cx231xx 3-2:1.1: V4L2 device vbi0 deregistered
[ 2050.314449] cx231xx 3-2:1.1: V4L2 device video0 deregistered
[ 2050.316448] cx231xx: probe of 3-2:1.1 failed with error -22

Can you take another look?

See also:

https://lore.kernel.org/linux-media/1550027010.2460608.1656864112.3A25F771@webmail.messagingengine.com/

And also:

https://patchwork.kernel.org/patch/10763655/

I'm really confused what the status is and what has and hasn't been tested/reviewed.

Regards,

	Hans

> 
> 
> 
> Brad Love (2):
>   cx231xx-video: Set media controller taint for analog outputs
>   cx25840-core: Set media controller taint for pads
> 
>  drivers/media/i2c/cx25840/cx25840-core.c  | 6 ++++++
>  drivers/media/usb/cx231xx/cx231xx-video.c | 1 +
>  2 files changed, 7 insertions(+)
> 

