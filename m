Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:46034 "EHLO
        homiemail-a124.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751028AbeELPg3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 May 2018 11:36:29 -0400
Subject: Re: [PATCH 2/7] Disable additional drivers requiring gpio/consumer.h
From: Brad Love <brad@b-rad.cc>
To: "Jasmin J." <jasmin@anw.at>, Brad Love <brad@nextdimension.cc>,
        linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>
References: <1524763162-4865-1-git-send-email-brad@nextdimension.cc>
 <1524763162-4865-3-git-send-email-brad@nextdimension.cc>
 <e8d69388-3e47-eeaf-840d-5464fc6c8dc5@anw.at>
 <ca407df1-64be-6180-0e5d-7f055418eddf@b-rad.cc>
Message-ID: <d2198562-173d-c086-115f-3ac8a8a7f669@b-rad.cc>
Date: Sat, 12 May 2018 10:36:27 -0500
MIME-Version: 1.0
In-Reply-To: <ca407df1-64be-6180-0e5d-7f055418eddf@b-rad.cc>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jasmin,


On 2018-05-12 08:20, Brad Love wrote:
> Hi Jasmin,
>
>
> On 2018-05-12 04:31, Jasmin J. wrote:
>> Hello Brad!
>>
>> Tonight build broke due to patch 95ee4c285022!
>> You enabled VIDEO_OV2685 for 3.13., which doesn't
>> compile for Kernels older than 3.17. When you look
>> to the Kernel 3.17 section a lot of the drivers you
>> enabled for 3.13 with your patch should be enabled
>> for 3.17 only.
>>
>> So please test this and provide a follow up patch.
>> I will not revert 95ee4c285022 now, except you can't
>> fix it in a reasonable time frame.
>>
>> If you like and you have time you can improve
>> scripts/make_kconfig.pl to detect such an issue to
>> avoid future problems like this. I also had such a
>> situation with enabling a driver twice in the past.
>>
>> BR,
>>    Jasmin
> Apologies. Interesting though, as I was working against 3.10 while
> submitting this. I will verify and submit a correction today.
>
> Cheers,
>
> Brad

Looks like the media_build environment on the system I made this patch
for was a little older, pretty much from right before you added all the
affected drivers to 3.17.0. Bad on me for not noticing. I submitted a
fixup for that and also moved the other drivers from the patch to 3.17.0
as well. Should compile again for you.

Cheers,

Brad
