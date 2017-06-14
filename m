Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00252a01.pphosted.com ([91.207.212.211]:57438 "EHLO
        mx08-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751880AbdFNQ3c (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 12:29:32 -0400
Received: from pps.filterd (m0102629.ppops.net [127.0.0.1])
        by mx08-00252a01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5EGSWO9017734
        for <linux-media@vger.kernel.org>; Wed, 14 Jun 2017 17:29:31 +0100
Received: from mail-pf0-f198.google.com (mail-pf0-f198.google.com [209.85.192.198])
        by mx08-00252a01.pphosted.com with ESMTP id 2b058et7ee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Wed, 14 Jun 2017 17:29:30 +0100
Received: by mail-pf0-f198.google.com with SMTP id h21so4198012pfk.13
        for <linux-media@vger.kernel.org>; Wed, 14 Jun 2017 09:29:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <eef29bfb-3336-4f65-c188-975d3937cb67@xs4all.nl>
References: <cover.1497452006.git.dave.stevenson@raspberrypi.org> <eef29bfb-3336-4f65-c188-975d3937cb67@xs4all.nl>
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
Date: Wed, 14 Jun 2017 17:29:28 +0100
Message-ID: <CAAoAYcN67=d1DyqeAEYpeZDTuMh9p1eaiAzt7RJdcpYOwShVgw@mail.gmail.com>
Subject: Re: [RFC 0/2] BCM283x Camera Receiver driver
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-rpi-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans.

On 14 June 2017 at 16:42, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Dave,
>
> How does this driver relate to this staging driver:
>
> drivers/staging/vc04_services/bcm2835-camera/
>
> It's not obvious to me.

drivers/staging/vc04_services/bcm2835-camera/ is using the VideoCore
firmware to control Unicam, ISP, and all the tuner algorithms. The ARM
gets delivered fully processed buffers from the VideoCore side. The
firmware only has drivers for the Omnivision OV5647 and Sony IMX219
(and an unsupported one for the Toshiba TC358743).

This driver is solely the Unicam block, reading the data in over
CSI2/CCP2 from the sensor and writing it to memory. No ISP or control
loops.
Other than power management, this driver is running solely on the ARM
with no involvement from the VideoCore firmware.
The sensor driver is whatever suitable V4L2 subdevice driver you fancy
attaching (as long as it supports CSI2, or eventually CCP2).

> On 06/14/2017 05:15 PM, Dave Stevenson wrote:
>>
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
>
>
> Are you compiling v4l2-compliance from the v4l-utils git repo? If not,
> then please do so and run again. The version packaged by distros tends
> to be seriously outdated.

Yes, I'm building from v4l-utils.git.
I updated within the last week, although you appear to have added 2
commits since (both CEC related).
I'm on "ef074cf media-ctl: add colorimetry support"

>> I must admit to not having got OV5647 to stream with the current driver
>> register settings. It works with a set of register settings for VGA RAW10.
>> I also have a couple of patches pending for OV5647, but would like to
>> understand the issues better before sending them out.
>>
>> Two queries I do have in V4L2-land:
>> - When s_dv_timings or s_std is called, is the format meant to
>>    be updated automatically?
>
>
> Yes. Exception is if the new timings/std is exactly the same as the old
> timings/std, in that case you can just return 0 and do nothing.

OK, can do that.

>> Even if we're already streaming?
>
> That's not allowed. Return -EBUSY in that case.

Also reasonable.
So if the TC358743 flags a source change we have to stop streaming,
set the new timings (which will update the format), and start up again
with fresh buffers. That's what I was expecting, but wanted to
confirm.

>>    Some existing drivers seem to, but others don't.
>> - With s_fmt, is sizeimage settable by the application in the same
>>    way as bytesperline?
>
>
> No, the driver will fill in this field, overwriting anything the
> application put there.
>
> bytesperline IS settable, but most drivers will ignore what userspace
> did and overwrite this as well.
>
> Normally the driver knows about HW requirements and will set sizeimage
> to something that will work (e.g. make sure it is a multiple of 16 lines).

There are subtly different requirements in different hardware blocks :-(
eg Unicam needs bytesperline to be a multiple of 16 bytes,whilst the
ISP requires a multiple of 32.
The vertical padding is generally where we're doing software
processing on the VideoCore side as it's easier to just leave the the
16 way SIMD processor running all 16 ways, hence needing scratch space
to avoid reading beyond buffers.

The main consumer is likely to be the ISP and that doesn't need
vertical context, so I'll look at removing the requirement there
rather than forcing it in this driver.
As long as we can set bytesperline (which is already supported) then
that requirement of the ISP is already handled.

>> yavta allows you to specify it on the command
>>
>>    line, whilst v4l2-ctl doesn't. Some of the other parts of the Pi
>>    firmware have a requirement that the buffer is a multiple of 16 lines
>>    high, which can be matched by V4L2 if we can over-allocate the
>>    buffers by the app specifying sizeimage. But if I allow that,
>>    then I get a v4l2-compliance failure as the size doesn't get
>>    reset when switching from RGB3 to UYVY as it takes the request as
>>    a request to over-allocate.
>>
>> Apologies if I've messed up in sending these patches - so many ways
>> to do something.
>
>
> It looks fine at a glance.
>
> I will probably review this on Friday or Monday. But I need some
> clarification
> of the difference between this and the staging driver first.

Thanks. Hopefully I've given you that clarification above.

I'll fix the s_dv_timings and s_std handling, and s_fmt of sizeimage,
but will wait for other review comments before sending a v2.

  Dave
