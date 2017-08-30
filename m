Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00252a01.pphosted.com ([91.207.212.211]:48108 "EHLO
        mx08-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750835AbdH3Jkt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Aug 2017 05:40:49 -0400
Received: from pps.filterd (m0102629.ppops.net [127.0.0.1])
        by mx08-00252a01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v7U9WT0E010970
        for <linux-media@vger.kernel.org>; Wed, 30 Aug 2017 10:40:47 +0100
Received: from mail-pg0-f71.google.com (mail-pg0-f71.google.com [74.125.83.71])
        by mx08-00252a01.pphosted.com with ESMTP id 2cjwfea0tv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Wed, 30 Aug 2017 10:40:47 +0100
Received: by mail-pg0-f71.google.com with SMTP id 83so11671578pgb.1
        for <linux-media@vger.kernel.org>; Wed, 30 Aug 2017 02:40:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55eba688-5765-72dc-0984-7b642abaf38e@xs4all.nl>
References: <cover.1497452006.git.dave.stevenson@raspberrypi.org> <55eba688-5765-72dc-0984-7b642abaf38e@xs4all.nl>
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
Date: Wed, 30 Aug 2017 10:40:41 +0100
Message-ID: <CAAoAYcM5E5vsQ0Cn4X4XSJOO6uNuLqjXaBs1bBHwfiQbi5oHXw@mail.gmail.com>
Subject: Re: [RFC 0/2] BCM283x Camera Receiver driver
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-rpi-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans.

On 28 August 2017 at 15:15, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Dave,
>
> What is the status of this work? I ask because I tried to use this driver
> plus my tc358743 on my rpi-2b without any luck. Specifically the tc358843
> isn't able to read from the i2c bus.

I was on other things until last week, but will try to get a V2 sorted
either this week or early next.
The world moved on slightly too, so there are a few more updates
around fwnode stuff that I ought to adopt.

> This is probably a bug in my dts, if you have a tree somewhere containing
> a working dts for this, then that would be very helpful.

Almost certainly just pin ctrl on the I2C bus. The default for i2c0 is
normally to GPIOs 0&1 as that is exposed on the 40 pin header
(physical pins 27&28). The camera is on GPIOs 28&29 (alt0) for the
majority of Pi models (not the Pi3, or the early model B).

I generally do my config via the DT overlays used in the Pi specific
kernels, but that isn't so directly relevant to mainline.
My 4.9 based WIP project that I'm using on a Pi2 is at
https://github.com/6by9/linux/commits/unicam_wip. Mods to:
- arch/arm/boot/dts/bcm283x.dtsi add the CSI nodes
- arch/arm/boot/dts/overlays/tc358743-overlay.dts adds the relevant
config for TC358743
- /arch/arm/boot/dts/overlays/i2c0-bcm2708-overlay.dts is used with
the pins_28_29 parameter to select 28&29 (that needs updating as it
now uses the bcm2835-i2c driver, not bcm2708-i2c)
Sorry it's piece-meal, but that should give you the bits required.

I hope that helps.
  Dave

> Regards,
>
>         Hans
>
> On 14/06/17 17:15, Dave Stevenson wrote:
>> Hi All.
>>
>> This is adding a V4L2 subdevice driver for the CSI2/CCP2 camera
>> receiver peripheral on BCM283x, as used on Raspberry Pi.
>>
>> v4l2-compliance results depend on the sensor subdevice this is
>> connected to. It passes the basic tests cleanly with TC358743,
>> but objects with OV5647
>> fail: v4l2-test-controls.cpp(574): g_ext_ctrls does not support count == 0
>> Neither OV5647 nor Unicam support any controls.
>>
>> I must admit to not having got OV5647 to stream with the current driver
>> register settings. It works with a set of register settings for VGA RAW10.
>> I also have a couple of patches pending for OV5647, but would like to
>> understand the issues better before sending them out.
>>
>> Two queries I do have in V4L2-land:
>> - When s_dv_timings or s_std is called, is the format meant to
>>   be updated automatically? Even if we're already streaming?
>>   Some existing drivers seem to, but others don't.
>> - With s_fmt, is sizeimage settable by the application in the same
>>   way as bytesperline? yavta allows you to specify it on the command
>>   line, whilst v4l2-ctl doesn't. Some of the other parts of the Pi
>>   firmware have a requirement that the buffer is a multiple of 16 lines
>>   high, which can be matched by V4L2 if we can over-allocate the
>>   buffers by the app specifying sizeimage. But if I allow that,
>>   then I get a v4l2-compliance failure as the size doesn't get
>>   reset when switching from RGB3 to UYVY as it takes the request as
>>   a request to over-allocate.
>>
>> Apologies if I've messed up in sending these patches - so many ways
>> to do something.
>>
>> Thanks in advance.
>>   Dave
>>
>> Dave Stevenson (2):
>>   [media] dt-bindings: Document BCM283x CSI2/CCP2 receiver
>>   [media] bcm2835-unicam: Driver for CCP2/CSI2 camera interface
>>
>>  .../devicetree/bindings/media/bcm2835-unicam.txt   |   76 +
>>  drivers/media/platform/Kconfig                     |    1 +
>>  drivers/media/platform/Makefile                    |    2 +
>>  drivers/media/platform/bcm2835/Kconfig             |   14 +
>>  drivers/media/platform/bcm2835/Makefile            |    3 +
>>  drivers/media/platform/bcm2835/bcm2835-unicam.c    | 2100 ++++++++++++++++++++
>>  drivers/media/platform/bcm2835/vc4-regs-unicam.h   |  257 +++
>>  7 files changed, 2453 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/bcm2835-unicam.txt
>>  create mode 100644 drivers/media/platform/bcm2835/Kconfig
>>  create mode 100644 drivers/media/platform/bcm2835/Makefile
>>  create mode 100644 drivers/media/platform/bcm2835/bcm2835-unicam.c
>>  create mode 100644 drivers/media/platform/bcm2835/vc4-regs-unicam.h
>>
>
