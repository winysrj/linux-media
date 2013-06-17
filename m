Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f172.google.com ([209.85.220.172]:47428 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab3FQGSK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jun 2013 02:18:10 -0400
Received: by mail-vc0-f172.google.com with SMTP id ib11so1696801vcb.17
        for <linux-media@vger.kernel.org>; Sun, 16 Jun 2013 23:18:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51BB6F85.1030708@samsung.com>
References: <1370870586-24141-1-git-send-email-arun.kk@samsung.com>
	<1370870586-24141-6-git-send-email-arun.kk@samsung.com>
	<51B5D876.2000704@samsung.com>
	<CALt3h7_BhORpmJUNZD1G-2eEZZ72YKus6wrfRiwRL4eLfViZHA@mail.gmail.com>
	<51BAE81B.4050008@samsung.com>
	<CALt3h78de0geS3+HdD3AE2OvTL3Zz10N5J7GUgHXjBUpz-tXow@mail.gmail.com>
	<51BB6F85.1030708@samsung.com>
Date: Mon, 17 Jun 2013 11:48:09 +0530
Message-ID: <CALt3h78dT5b6VgX+Ctn_jopGO9n=4xS7Hzn3=LR11=_jOsnErA@mail.gmail.com>
Subject: Re: [PATCH 5/6] [media] V4L: Add VP8 encoder controls
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Arun Kumar K <arun.kk@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>, jtp.park@samsung.com,
	avnd.kiran@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

>
>>>> Also for number of ref frames, the standard allows only the options 1,
>>>> 2 and 3 which
>>>> cannot be extended more. So is it correct to use INTEGER_MENU control here and
>>>> let the driver define the values?
>>>
>>> If this is standard then the core should define available menu items. But
>>> it seems more appropriate for me to use INTEGER_MENU. I'd like to hear other
>>> opinions though.
>>
>> Here even though 1,2 and 3 are standard, the interpretation is
>> 1 - 1 reference frame (previous frame)
>> 2 - previous frame + golden frame
>> 3 - previous frame + golden frame + altref frame.
>
> OK, then perhaps for this parameter a standard menu control would be better.
> However, why there are only 2 options in vpx_num_ref_frames[] arrays ?
> You probably want to change the menu strings to reflect this more precisely,
> but there might be not enough room for any creative names anyway. Maybe
> something like:
>
> static const char * const vpx_num_ref_frames[] = {
>         "Previous Frame",
>         "Previous + Golden Frame",
>         "Prev + Golden + Altref Frame",
>         NULL,
> };
>

On a more detailed inspection, the standard says maximum of 3 reference
frames. So in case of 2, it can be any of the permutation combination
possible. So rather I will stick to integer menu items saying 1, 2 and 3 where
on setting value 2, the encoder can decide on which frames to refer based
on its implementation but keeping the searching limit to 2 frames only.

Regards
Arun
