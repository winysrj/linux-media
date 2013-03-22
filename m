Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:64067 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab3CVFdR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Mar 2013 01:33:17 -0400
Received: by mail-wi0-f178.google.com with SMTP id hq4so3899602wib.5
        for <linux-media@vger.kernel.org>; Thu, 21 Mar 2013 22:33:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1302022132420.8751@axis700.grange>
References: <CA+V-a8sOHbseLe+rATFtLRwxdURB83QM0LvZ+5fQjfh7CDAkZQ@mail.gmail.com>
 <Pine.LNX.4.64.1302022132420.8751@axis700.grange>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 22 Mar 2013 11:02:55 +0530
Message-ID: <CA+V-a8uzLtt64yG8yUGit6vDFGDDCmCb7O1SaTQm3H3YZjdUzw@mail.gmail.com>
Subject: Re: [QUERY] V4L async api
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi,

On Sun, Feb 3, 2013 at 2:32 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Wed, 30 Jan 2013, Prabhakar Lad wrote:
>
>> Hi Guennadi,
>>
>> I am working on adding v4l-asyn for capture and display device..
>>
>> Here is my hw details:--
>>  1: The capture device has two subdevs tvp514x @0x5c and tvp514x @0x5d.
>>  2: The display device has a one subdev adv7343 @0x2a.
>>
>> Note:- I have added  async support for all the subdevices and the
>> capture and display driver too
>>
>> Test Case:-
>>   1:   I have v4l2_async_notifier_register() for both capture and
>> display driver, as of now I have built
>>         the subdevices as module. when board is up, I insert the
>> tvp514x  subdevices and the capture
>>         driver gets intialized (/dev/video0 & /dev/video1) nodes get
>> created, now I do insmod on the other
>>         subdevice adv7343, the bound callback is called in capture
>> driver, but whereas this should have been
>>         called in the display driver.
>
> This certainly _should_ not happen. Your subdevice driver should call
> v4l2_async_subdev_bound(), which will walk the notifier list and check,
> which of them this subdevice matches. I'm afraid you'll have to debug your
> set up to see why the wrong notifier matches.
>
>>   2:   When I build the subdevices as part of uImage I hit a crash.
>> Attached is the crash log.
>
> The crash happens in v4l2_async_notifier_register() when a newly
> registered notifier walks the list of _already_ successfully probed
> subdevices. Then I'm not exactly sure where the actual crash happens, one
> of the possibilities is if the match_i2c() function is called for an
> invalid or unbound i2c device. You'll have to debug this too.
>
Trying to debug, I see that list_for_each_entry() in v4l2_async_belongs()
is picking up some invalid entry which is causing it to crash!

Cheers,
--Prabhakar

> Thanks
> Guennadi
>
>>   3:   When I just build and use either the capture/display driver and
>> their respective subdevices only every thing works fine.
>>
>> Regards,
>> --Prabhakar
>>
>
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
