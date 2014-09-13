Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:34831 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbaIMV1Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Sep 2014 17:27:24 -0400
Received: by mail-la0-f41.google.com with SMTP id s18so2783800lam.28
        for <linux-media@vger.kernel.org>; Sat, 13 Sep 2014 14:27:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1918377.tBK2dPDOH0@avalon>
References: <CA+NJmkdrRWHvSwHQ248qHqaaGBu8N=4aY7XaPQ4WUeD3QrhjMA@mail.gmail.com>
 <1918377.tBK2dPDOH0@avalon>
From: Isaac Nickaein <nickaein.i@gmail.com>
Date: Sun, 14 Sep 2014 01:57:02 +0430
Message-ID: <CA+NJmkdSXNkY70xiZ1m=dB7gTwr8jJ49gVt1B4VgXqqk1yca2g@mail.gmail.com>
Subject: Re: Framerate is consistently divided by 2.5
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ah sorry for the confusion. The USB camera was not working on the old
kernel of ARM board. After patching the kernel, I can grab images but
the framerate is 1/2.5 of expected framerate. The camera works without
any issue on my PC (with kernel 3.13) though.

On Wed, Sep 10, 2014 at 6:11 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Isaac,
>
> On Saturday 06 September 2014 12:35:25 Isaac Nickaein wrote:
>> Hi,
>>
>> After patching the kernel, the rate that images are captured from the
>> camera reduce by a factor of 2.5.
>
> How have you patched the kernel ? If you have both a working and non-working
> version you could use git-bisect to find the commit that causes this breakage.
>
>> Here are a list of frame rates I have tried followed by the resulted frame-
>> rate:
>>
>> 10 fps --> 4 fps
>> 15 fps --> 6 fps
>> 25 fps --> 10 fps
>> 30 fps --> 12 fps
>>
>> Note that all of the rates are consistently divided by 2.5. This seems
>> to be a clocking issue to me. Is there any multipliers in V4L2 (or
>> UVC?) code in framerate calculation which depends on the hardware and
>> be cause of this?
>
> --
> Regards,
>
> Laurent Pinchart
>
