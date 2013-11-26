Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:59090 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757687Ab3KZV55 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Nov 2013 16:57:57 -0500
Received: by mail-lb0-f181.google.com with SMTP id q8so4982660lbi.12
        for <linux-media@vger.kernel.org>; Tue, 26 Nov 2013 13:57:56 -0800 (PST)
Message-ID: <52951961.30903@cogentembedded.com>
Date: Wed, 27 Nov 2013 01:57:53 +0400
From: Valentine <valentine.barshak@cogentembedded.com>
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH V2] media: i2c: Add ADV761X support
References: <1384520071-16463-1-git-send-email-valentine.barshak@cogentembedded.com> <528B347E.2060107@xs4all.nl> <528C8BA1.9070706@cogentembedded.com> <528C9ADB.3050803@xs4all.nl> <528CA9E1.2020401@cogentembedded.com> <528CD86D.70506@xs4all.nl> <528CDB0B.3000109@cogentembedded.com> <52951270.9040804@cogentembedded.com> <52951604.2050603@metafoo.de>
In-Reply-To: <52951604.2050603@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/27/2013 01:43 AM, Lars-Peter Clausen wrote:
> On 11/26/2013 10:28 PM, Valentine wrote:
>> On 11/20/2013 07:53 PM, Valentine wrote:
>>> On 11/20/2013 07:42 PM, Hans Verkuil wrote:
>>>> Hi Valentine,
>>
>> Hi Hans,
>>
>>>>
>>>> Did you ever look at this adv7611 driver:
>>>>
>>>> https://github.com/Xilinx/linux-xlnx/commit/610b9d5de22ae7c0047c65a07e4afa42af2daa12
>>>>
>>>
>>> No, I missed that one somehow, although I did search for the adv7611/7612
>>> before implementing this one.
>>> I'm going to look closer at the patch and test it.
>>>
>>
>> I've tried the patch and I doubt that it was ever tested on adv7611.
>
> It was and it works.

That's good to hear.

>
>> I haven't been able to make it work so far. Here's the description of some
>> of the issues
>> I've encountered.
>>
>> The patch does not apply cleanly so I had to make small adjustments just to
>> make it apply
>> without changing the functionality.
>
> I have an updated version of the patch, which I intend to submit soon.

That's great, thanks!

>
> [...]

I'd also appreciate your thoughts about the issues I've described,
which have been replaced by [...] here.

>>>>
>>>> It adds adv761x support to the adv7604 in a pretty clean way.
>>
>> Doesn't seem that clean to me after having a look at it.
>> It tries to handle both 7604 and 7611 chips in the same way, though,
>> I'm not exactly sure if it's a good idea since 7611/12 is a pure HDMI
>> receiver with no analog inputs.
>
> It is the same HDMI core (with minor modifications) though. So you end end
> up with largely the same code for the 7604 and the 7611.

Yes, but that's about half of the code while 7611 doesn't really need the non-HDMI part.
Just thought that we may end up with a bigger mess if we keep adding adv76xx support to 7604 driver.

>
> - Lars
>

Thanks,
Val.
