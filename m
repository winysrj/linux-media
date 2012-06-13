Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:33881 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754788Ab2FMVte (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jun 2012 17:49:34 -0400
Message-ID: <4FD90AE4.9010306@iki.fi>
Date: Thu, 14 Jun 2012 00:49:24 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Sylwester Nawrocki <snjw23@gmail.com>
CC: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 3/4] v4l: Unify selection targets across V4L2 and V4L2
 subdev interfaces
References: <4FD4F6B6.1070605@iki.fi> <1339356878-2179-3-git-send-email-sakari.ailus@iki.fi> <4FD720AC.8000906@gmail.com> <4FD90217.2060403@iki.fi> <4FD908AD.3010202@gmail.com>
In-Reply-To: <4FD908AD.3010202@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Sylwester Nawrocki wrote:
> Hi Sakari :)
> 
> On 06/13/2012 11:11 PM, Sakari Ailus wrote:
>> Hi Sylwester,
>>
>> Thanks for the comments!!
>>
>> Sylwester Nawrocki wrote:
>>> Hi Sakari,
>>>
>>> On 06/10/2012 09:34 PM, Sakari Ailus wrote:
>>>> Signed-off-by: Sakari Ailus<sakari.ailus@iki.fi>
>>>> ---
>>>>    drivers/media/video/omap3isp/ispccdc.c    |    6 ++--
>>>>    drivers/media/video/omap3isp/isppreview.c |    6 ++--
>>>>    drivers/media/video/omap3isp/ispresizer.c |    6 ++--
>>>>    drivers/media/video/smiapp/smiapp-core.c  |   30 +++++++++---------
>>>>    drivers/media/video/v4l2-subdev.c         |    4 +-
>>>>    include/linux/v4l2-common.h               |   49
>>>> +++++++++++++++++++++++++++++
>>>>    include/linux/v4l2-subdev.h               |   13 +------
>>>>    include/linux/videodev2.h                 |   20 +----------
>>>>    8 files changed, 79 insertions(+), 55 deletions(-)
>>>>    create mode 100644 include/linux/v4l2-common.h
>>> <snip>
>>>> diff --git a/include/linux/v4l2-common.h b/include/linux/v4l2-common.h
>>>> new file mode 100644
>>>> index 0000000..e0db6e3
>>>> --- /dev/null
>>>> +++ b/include/linux/v4l2-common.h
>>>> @@ -0,0 +1,49 @@
>>>> +/*
>>>> + * include/linux/v4l2-common.h
>>>> + *
>>>> + * Common V4L2 and V4L2 subdev definitions.
>>>> + *
>>>> + * Users are adviced to #include this file either videodev2.h (V4L2)
> 
> Shouldn't be "advised" ?

Yes. Fixed.

>>>
>>> s/either videodev2.h/either from videodev2.h ?
>>>
>>>> + * or v4l2-subdev.h (V4L2 subdev) rather than to refer to this file
>>>
>>> s/or v4l2-subdev.h/or from v4l2-subdev.h ?
>>
>> How about "through" for both?
> 
> Yeah, probably more appropriate.
> 
> [...]
>>>
>>> There are now some missing renames, due to some patches that were merged
>>> recently. Please feel free to squash the attached patch with this one.
>>
>> I merged it to the patch and put your SoB line there. :-)
> 
> OK, good :)
> 
> In case you wanted to compile test those changes, I've attached
> kernel config file for exynos4.

Compile testing? What is that? :-)

I'll check that before sending the pull req.

Cheers,

-- 
Sakari Ailus
sakari.ailus@iki.fi


