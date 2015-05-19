Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:34875 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbbESEuk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2015 00:50:40 -0400
Received: by pdea3 with SMTP id a3so7137133pde.2
        for <linux-media@vger.kernel.org>; Mon, 18 May 2015 21:50:40 -0700 (PDT)
Message-ID: <555AC11A.1040203@linaro.org>
Date: Tue, 19 May 2015 10:20:34 +0530
From: Vaibhav Hiremath <vaibhav.hiremath@linaro.org>
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH 1/1 linux-next] omap_vout: use swap() in omapvid_init()
References: <1431971658-20986-1-git-send-email-fabf@skynet.be> <555A2D88.7070808@linaro.org> <1601184049.17932.1431973900041.open-xchange@webmail.nmp.proximus.be>
In-Reply-To: <1601184049.17932.1431973900041.open-xchange@webmail.nmp.proximus.be>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Tuesday 19 May 2015 12:01 AM, Fabian Frederick wrote:
>
>
>> On 18 May 2015 at 20:20 Vaibhav Hiremath <vaibhav.hiremath@linaro.org> wrote:
>>
>>
>>
>>
>> On Monday 18 May 2015 11:24 PM, Fabian Frederick wrote:
>>> Use kernel.h macro definition.
>>>
>>> Signed-off-by: Fabian Frederick <fabf@skynet.be>
>>> ---
>>>     drivers/media/platform/omap/omap_vout.c | 10 +++-------
>>>     1 file changed, 3 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/drivers/media/platform/omap/omap_vout.c
>>> b/drivers/media/platform/omap/omap_vout.c
>>> index 17b189a..f09c5f1 100644
>>> --- a/drivers/media/platform/omap/omap_vout.c
>>> +++ b/drivers/media/platform/omap/omap_vout.c
>>> @@ -445,7 +445,7 @@ static int omapvid_init(struct omap_vout_device *vout,
>>> u32 addr)
>>>       int ret = 0, i;
>>>       struct v4l2_window *win;
>>>       struct omap_overlay *ovl;
>>> -   int posx, posy, outw, outh, temp;
>>> +   int posx, posy, outw, outh;
>>>       struct omap_video_timings *timing;
>>>       struct omapvideo_info *ovid = &vout->vid_info;
>>>
>>> @@ -468,9 +468,7 @@ static int omapvid_init(struct omap_vout_device *vout,
>>> u32 addr)
>>>                       /* Invert the height and width for 90
>>>                        * and 270 degree rotation
>>>                        */
>>> -                   temp = outw;
>>> -                   outw = outh;
>>> -                   outh = temp;
>>> +                   swap(outw, outh);
>>>                       posy = (timing->y_res - win->w.width) - win->w.left;
>>>                       posx = win->w.top;
>>>                       break;
>>> @@ -481,9 +479,7 @@ static int omapvid_init(struct omap_vout_device *vout,
>>> u32 addr)
>>>                       break;
>>>
>>>               case dss_rotation_270_degree:
>>> -                   temp = outw;
>>> -                   outw = outh;
>>> -                   outh = temp;
>>> +                   swap(outw, outh);
>>>                       posy = win->w.left;
>>>                       posx = (timing->x_res - win->w.height) - win->w.top;
>>>                       break;
>>>
>>
>>
>> Curious to know,
>> How do you test this? Do you have any OMAP2/3 or AM335x board?
>> Does this driver still works?
>
> Hello Vaibhav,
>
>     Unfortunately I can't test it.
>

Thats what I expected.

I am doubtful that anyone still uses this driver.
With DRM framework support, I see very little use of this driver.

Also there are some hacks regarding buffer management, that need to be
fixed if at all we want to support it.

I would really want to slowly kill this driver, if no one uses it.

Thanks,
Vaibhav
