Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00252a01.pphosted.com ([91.207.212.211]:33811 "EHLO
        mx08-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751125AbdFBNEQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Jun 2017 09:04:16 -0400
Received: from pps.filterd (m0102629.ppops.net [127.0.0.1])
        by mx08-00252a01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v52D448b003485
        for <linux-media@vger.kernel.org>; Fri, 2 Jun 2017 14:04:04 +0100
Received: from mail-io0-f198.google.com (mail-io0-f198.google.com [209.85.223.198])
        by mx08-00252a01.pphosted.com with ESMTP id 2apwxetxfs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Fri, 02 Jun 2017 14:04:04 +0100
Received: by mail-io0-f198.google.com with SMTP id t87so4467618ioe.7
        for <linux-media@vger.kernel.org>; Fri, 02 Jun 2017 06:04:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4dd94754-2a3c-532c-f07c-88ac3765efcf@xs4all.nl>
References: <cover.1496397071.git.dave.stevenson@raspberrypi.org> <4dd94754-2a3c-532c-f07c-88ac3765efcf@xs4all.nl>
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
Date: Fri, 2 Jun 2017 14:03:59 +0100
Message-ID: <CAAoAYcPWK1bLYSJDwM_Bp8szNkhXN38KRsx9j0xNWXwCH9qk3Q@mail.gmail.com>
Subject: Re: [PATCH 0/3] tc358743: minor driver fixes
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mats Randgaard <matrandg@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans.

On 2 June 2017 at 13:35, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 06/02/17 14:18, Dave Stevenson wrote:
>> These 3 patches for TC358743 came out of trying to use the
>> existing driver with a new Raspberry Pi CSI-2 receiver driver.
>
> Nice! Doing that has been on my todo list for ages but I never got
> around to it. I have one of these and using the Raspberry Pi with
> the tc358743 would allow me to add a CEC driver as well.

It's been on my list for a while too! It's working, but just the final
clean ups needed.
I've got 1 v4l2-compliance failure still outstanding that needs
digging into (subscribe_event), rebasing on top of the fwnode tree,
and a couple of config things to tidy up. RFC hopefully next week.
I'm testing with a demo board designed here at Pi Towers, but there
are others successfully testing it using the auvidea.com B101 board.

Are you aware of the HDMI modes that the TC358743 driver has been used with?
The comments mention 720P60 at 594MHz, but I have had to modify the
fifo_level value from 16 to 110 to get VGA60 or 576P50 to work. (The
value came out of Toshiba's spreadsheet for computing register
settings). It increases the delay by 2.96usecs at 720P60 on 2 lanes,
so not a huge change.
Is it worth going to the effort of dynamically computing the delay, or
is increasing the default acceptable?

>> A couple of the subdevice API calls were not implemented or
>> otherwise gave odd results. Those are fixed.
>>
>> The TC358743 interface board being used didn't have the IRQ
>> line wired up to the SoC. "interrupts" is listed as being
>> optional in the DT binding, but the driver didn't actually
>> function if it wasn't provided.
>>
>> Dave Stevenson (3):
>>   [media] tc358743: Add enum_mbus_code
>>   [media] tc358743: Setup default mbus_fmt before registering
>>   [media] tc358743: Add support for platforms without IRQ line
>
> All looks good, I'll take this for 4.12.

Thanks.

> Regards,
>
>         Hans
>
>>
>>  drivers/media/i2c/tc358743.c | 59 +++++++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 58 insertions(+), 1 deletion(-)
>>
>
