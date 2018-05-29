Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:33448 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935569AbeE2QgJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 May 2018 12:36:09 -0400
Received: by mail-pl0-f65.google.com with SMTP id n10-v6so9269534plp.0
        for <linux-media@vger.kernel.org>; Tue, 29 May 2018 09:36:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <638b94cd-7112-4f45-ffe2-a652cdc47492@xs4all.nl>
References: <1527435011-9318-1-git-send-email-akinobu.mita@gmail.com> <638b94cd-7112-4f45-ffe2-a652cdc47492@xs4all.nl>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Wed, 30 May 2018 01:35:48 +0900
Message-ID: <CAC5umygbraw5HOtUt3Ty0oEjd3EV3oqAg_9kEg-9nLKv3Vh+Tg@mail.gmail.com>
Subject: Re: [PATCH v2] media: pxa_camera: avoid duplicate s_power calls
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018-05-29 15:17 GMT+09:00 Hans Verkuil <hverkuil@xs4all.nl>:
> Hi Akinobu,
>
> On 05/27/2018 05:30 PM, Akinobu Mita wrote:
>> The open() operation for the pxa_camera driver always calls s_power()
>> operation to put its subdevice sensor in normal operation mode, and the
>> release() operation always call s_power() operation to put the subdevice
>> in power saving mode.
>>
>> This requires the subdevice sensor driver to keep track of its power
>> state in order to avoid putting the subdevice in power saving mode while
>> the device is still opened by some users.
>>
>> Many subdevice drivers handle it by the boilerplate code that increments
>> and decrements an internal counter in s_power() like below:
>>
>>       /*
>>        * If the power count is modified from 0 to != 0 or from != 0 to 0,
>>        * update the power state.
>>        */
>>       if (sensor->power_count == !on) {
>>               ret = ov5640_set_power(sensor, !!on);
>>               if (ret)
>>                       goto out;
>>       }
>>
>>       /* Update the power count. */
>>       sensor->power_count += on ? 1 : -1;
>>
>> However, some subdevice drivers don't handle it and may cause a problem
>> with the pxa_camera driver if the video device is opened by more than
>> two users at the same time.
>>
>> Instead of propagating the boilerplate code for each subdevice driver
>> that implement s_power, this introduces an trick that many V4L2 drivers
>> are using with v4l2_fh_is_singular_file().
>>
>> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
>> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> ---
>> * v2
>> - Print warning message when s_power() is failed. (not printing warning
>>   when _vb2_fop_release() is failed as it always returns zero for now)
>
> Please note that v1 has already been merged, so if you can make a v3 rebased
> on top of the latest media_tree master branch, then I'll queue that up for
> 4.18.

OK.  There are several calls to s_power in this driver, so I'll make
a patch to add a wrapper function that prints warning message and
replace s_power calls with it.

I realized that s_power calls in suspend/resume ignore -ENOIOCTLCMD
error and other s_power calls also should ignore it.  So I'll include
the check in the wrapper function.
