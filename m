Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:36662 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754594AbdCUBn3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 21:43:29 -0400
MIME-Version: 1.0
In-Reply-To: <58CFD505.60201@bfs.de>
References: <20170320105940.GA17472@SEL-JYOUN-D1> <58CFC561.8090104@bfs.de>
 <CAHb8M2DELnWoo8UAEni-dc8fnVmpp8d-XeOObeB37deT5+8_gQ@mail.gmail.com> <58CFD505.60201@bfs.de>
From: DaeSeok Youn <daeseok.youn@gmail.com>
Date: Tue, 21 Mar 2017 10:43:27 +0900
Message-ID: <CAHb8M2AgV0J4YWc52-yzSsUWUCWfNP-ffmjOFkt6Y-mzsF8zUg@mail.gmail.com>
Subject: Re: [PATCH 2/4] staging: atomisp: simplify if statement in atomisp_get_sensor_fps()
To: wharms@bfs.de
Cc: mchehab@kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        SIMRAN SINGHAL <singhalsimran0@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-media@vger.kernel.org, devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-03-20 22:11 GMT+09:00 walter harms <wharms@bfs.de>:
>
>
> Am 20.03.2017 13:51, schrieb DaeSeok Youn:
>> 2017-03-20 21:04 GMT+09:00 walter harms <wharms@bfs.de>:
>>>
>>>
>>> Am 20.03.2017 11:59, schrieb Daeseok Youn:
>>>> If v4l2_subdev_call() gets the global frame interval values,
>>>> it returned 0 and it could be checked whether numerator is zero or not.
>>>>
>>>> If the numerator is not zero, the fps could be calculated in this function.
>>>> If not, it just returns 0.
>>>>
>>>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>>>> ---
>>>>  .../media/atomisp/pci/atomisp2/atomisp_cmd.c       | 22 ++++++++++------------
>>>>  1 file changed, 10 insertions(+), 12 deletions(-)
>>>>
>>>> diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
>>>> index 8bdb224..6bdd19e 100644
>>>> --- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
>>>> +++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
>>>> @@ -153,20 +153,18 @@ struct atomisp_acc_pipe *atomisp_to_acc_pipe(struct video_device *dev)
>>>>
>>>>  static unsigned short atomisp_get_sensor_fps(struct atomisp_sub_device *asd)
>>>>  {
>>>> -     struct v4l2_subdev_frame_interval frame_interval;
>>>> +     struct v4l2_subdev_frame_interval fi;
>>>>       struct atomisp_device *isp = asd->isp;
>>>> -     unsigned short fps;
>>>>
>>>> -     if (v4l2_subdev_call(isp->inputs[asd->input_curr].camera,
>>>> -         video, g_frame_interval, &frame_interval)) {
>>>> -             fps = 0;
>>>> -     } else {
>>>> -             if (frame_interval.interval.numerator)
>>>> -                     fps = frame_interval.interval.denominator /
>>>> -                         frame_interval.interval.numerator;
>>>> -             else
>>>> -                     fps = 0;
>>>> -     }
>>>> +     unsigned short fps = 0;
>>>> +     int ret;
>>>> +
>>>> +     ret = v4l2_subdev_call(isp->inputs[asd->input_curr].camera,
>>>> +                            video, g_frame_interval, &fi);
>>>> +
>>>> +     if (!ret && fi.interval.numerator)
>>>> +             fps = fi.interval.denominator / fi.interval.numerator;
>>>> +
>>>>       return fps;
>>>>  }
>>>
>>>
>>>
>>> do you need to check ret at all ? if an error occurs can fi.interval.numerator
>>> be something else than 0 ?
>> the return value from the v4l2_subdev_call() function is zero when it
>> is done without any error. and also I checked
>> the ret value whether is 0 or not. if the ret is 0 then the value of
>> numerator should be checked to avoid for dividing by 0.
>>>
>>> if ret is an ERRNO it would be wise to return ret not fps, but this may require
>>> changes at other places also.
>> hmm.., yes, you are right. but I think it is ok because the
>> atomisp_get_sensor_fps() function is needed to get fps value.
>> (originally, zero or calculated fps value was returned.)
>
> maybe its better to divide this in:
>         if (ret)
>            return 0; // error case
>
>         return (fi.interval.numerator>0)?fi.interval.denominator / fi.interval.numerator:0;
>
> So there is a chance that someone will a) understand and b) fix the error return.
yes, it looks better than mine. I will update it and resend it.

Thanks walter,
Regards,
Daeseok Youn.

>
> re,
>  wh
>
>>
>>>
>>> re,
>>>  wh
>>>
>>>>
>>
