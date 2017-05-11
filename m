Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f171.google.com ([209.85.161.171]:34538 "EHLO
        mail-yw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754670AbdEKFhj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 May 2017 01:37:39 -0400
Received: by mail-yw0-f171.google.com with SMTP id l14so7775733ywk.1
        for <linux-media@vger.kernel.org>; Wed, 10 May 2017 22:37:38 -0700 (PDT)
Received: from mail-yw0-f176.google.com (mail-yw0-f176.google.com. [209.85.161.176])
        by smtp.gmail.com with ESMTPSA id b74sm357065ywa.25.2017.05.10.22.37.36
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 May 2017 22:37:36 -0700 (PDT)
Received: by mail-yw0-f176.google.com with SMTP id 203so7786912ywe.0
        for <linux-media@vger.kernel.org>; Wed, 10 May 2017 22:37:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6F87890CF0F5204F892DEA1EF0D77A595AA06541@FMSMSX114.amr.corp.intel.com>
References: <1494254208-30045-1-git-send-email-rajmohan.mani@intel.com>
 <CAAFQd5A34z8=uAAq-k+d-n0E+93dup1DuQZHsoaw+5YNaGqWPw@mail.gmail.com> <6F87890CF0F5204F892DEA1EF0D77A595AA06541@FMSMSX114.amr.corp.intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 11 May 2017 13:37:15 +0800
Message-ID: <CAAFQd5BAuEuVzaVrzNAa6N5H1TV56WJsGY2m6eYSSCnoM1khsw@mail.gmail.com>
Subject: Re: [PATCH v2] dw9714: Initial driver for dw9714 VCM
To: "Mani, Rajmohan" <rajmohan.mani@intel.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Raj,

On Thu, May 11, 2017 at 12:12 PM, Mani, Rajmohan
<rajmohan.mani@intel.com> wrote:
> Hi Tomasz,
> Thanks for the reviews. Please see comments inline.
>
>> -----Original Message-----
>> From: Tomasz Figa [mailto:tfiga@chromium.org]
>> Sent: Tuesday, May 09, 2017 4:44 PM
>> To: Mani, Rajmohan <rajmohan.mani@intel.com>
>> Cc: linux-media@vger.kernel.org; mchehab@kernel.org; Hans Verkuil
>> <hverkuil@xs4all.nl>
>> Subject: Re: [PATCH v2] dw9714: Initial driver for dw9714 VCM
>>
>> Hi Rajmohan,
>>
>> Some comments below.
>>
>> On Mon, May 8, 2017 at 10:36 PM, Rajmohan Mani
>> <rajmohan.mani@intel.com> wrote:
>> > DW9714 is a 10 bit DAC, designed for linear control of voice coil
>> > motor.
>> >
>> > This driver creates a V4L2 subdevice and provides control to set the
>> > desired focus.
>> >
>> > Signed-off-by: Rajmohan Mani <rajmohan.mani@intel.com>
>> > ---
>> > Changes in v2:
>> >         - Addressed review comments from Hans Verkuil
>> >         - Fixed a debug message typo
>> >         - Got rid of a return variable
>> > ---
>> >  drivers/media/i2c/Kconfig  |   9 ++
>> >  drivers/media/i2c/Makefile |   1 +
>> >  drivers/media/i2c/dw9714.c | 320
>> > +++++++++++++++++++++++++++++++++++++++++++++
>> >  3 files changed, 330 insertions(+)
>> >  create mode 100644 drivers/media/i2c/dw9714.c
>> [snip]
>> > diff --git a/drivers/media/i2c/dw9714.c b/drivers/media/i2c/dw9714.c
>> > new file mode 100644 index 0000000..cd6cde7
>> > --- /dev/null
>> > +++ b/drivers/media/i2c/dw9714.c
>> > @@ -0,0 +1,320 @@
>> > +/*
>> > + * Copyright (c) 2015--2017 Intel Corporation.
>> > + *
>> > + * This program is free software; you can redistribute it and/or
>> > + * modify it under the terms of the GNU General Public License
>> > +version
>> > + * 2 as published by the Free Software Foundation.
>> > + *
>> > + * This program is distributed in the hope that it will be useful,
>> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> > + * GNU General Public License for more details.
>> > + */
>> > +
>> > +#include <linux/acpi.h>
>> > +#include <linux/delay.h>
>> > +#include <linux/i2c.h>
>> > +#include <linux/module.h>
>> > +#include <linux/pm_runtime.h>
>> > +#include <media/v4l2-ctrls.h>
>> > +#include <media/v4l2-device.h>
>> > +
>> > +#define DW9714_NAME            "dw9714"
>> > +#define DW9714_MAX_FOCUS_POS   1023
>> > +#define DW9714_CTRL_STEPS      16      /* Keep this value power of 2 */
>>
>> Because?
>>
>
> This acts as the minimum granularity of lens movement.
> Keep this value power of 2, so the control steps can be uniformly adjusted for gradual lens movement, with desired number of control steps.

I mean, the comment should explain the reason.

>
>> > +#define DW9714_CTRL_DELAY_US   1000
>> > +/*
>> > + * S[3:2] = 0x00, codes per step for "Linear Slope Control"
>> > + * S[1:0] = 0x00, step period
>> > + */
>> > +#define DW9714_DEFAULT_S 0x0
>> > +#define DW9714_VAL(data, s) (u16)((data) << 4 | (s))
>>
>> Do we need this cast?
>>
> Yes. This is a write to a 2 byte register

Still, I'm not sure what this cast really gives us. If we want strict
type checking we should make this a static inline that has all types
specified, but that's probably not necessary either.

Best regards,
Tomasz
