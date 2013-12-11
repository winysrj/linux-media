Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:36384 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab3LKDEX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 22:04:23 -0500
Received: by mail-wi0-f177.google.com with SMTP id cc10so234228wib.4
        for <linux-media@vger.kernel.org>; Tue, 10 Dec 2013 19:04:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANnVQS1xg25VpaoU6W=rpC+HgyqaKLwnL4VcQ3FKN0q1r11h-Q@mail.gmail.com>
References: <20131210160541.GA15282@ubuntu> <2939201.P8qvUzaVN6@avalon> <CANnVQS1xg25VpaoU6W=rpC+HgyqaKLwnL4VcQ3FKN0q1r11h-Q@mail.gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 11 Dec 2013 08:34:02 +0530
Message-ID: <CA+V-a8si3Yetnrok4CuCY3C2opmSz8U6fFXyyg_dR22XMZo-vA@mail.gmail.com>
Subject: Re: [PATCH v2] staging: media: davinci_vpfe: Rewrite return statement
 in vpfe_video.c
To: Lisa Nguyen <lisa@xenapiadmin.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lisa,

On Tue, Dec 10, 2013 at 11:27 PM, Lisa Nguyen <lisa@xenapiadmin.com> wrote:
> Hi Laurent,
>
> On Tue, Dec 10, 2013 at 8:50 AM, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
>> Hi Lisa,
>>
>> Thank you for the patch.
>>
>> On Tuesday 10 December 2013 08:05:42 Lisa Nguyen wrote:
>>> Rewrite the return statement in vpfe_video.c to eliminate the
>>> use of a ternary operator. This will prevent the checkpatch.pl
>>> script from generating a warning saying to remove () from
>>> this particular return statement.
>>>
>>> Signed-off-by: Lisa Nguyen <lisa@xenapiadmin.com>
>>> ---
>>> Changes since v2:
>>> - Aligned -ETIMEDOUT return statement with if condition
>>>
>>>  drivers/staging/media/davinci_vpfe/vpfe_video.c |    5 ++++-
>>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c
>>> b/drivers/staging/media/davinci_vpfe/vpfe_video.c index 24d98a6..22e31d2
>>> 100644
>>> --- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
>>> +++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
>>> @@ -346,7 +346,10 @@ static int vpfe_pipeline_disable(struct vpfe_pipeline
>>> *pipe) }
>>>       mutex_unlock(&mdev->graph_mutex);
>>>
>>> -     return (ret == 0) ? ret : -ETIMEDOUT ;
>>> +     if (ret == 0)
>>> +             return ret;
>>> +
>>> +     return -ETIMEDOUT;
>>
>> I don't want to point the obvious, but what about just
>>
>>         return ret ? -ETIMEDOUT : 0;
>>
>> or, if this is just about fixing the checkpatch.pl warning,
>>
>>         return ret == 0 ? ret : -ETIMEDOUT;
>>
>> (I'd prefer the first)
>
> I understand your point :) I was making changes based on Prabhakar's
> feedback he gave me a while back[1].
>
Please go ahead as per Laurent's suggestion.

Thanks,
--Prabhakar Lad
