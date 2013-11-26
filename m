Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-062.synserver.de ([212.40.185.62]:1046 "EHLO
	smtp-out-025.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932201Ab3KZWF0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Nov 2013 17:05:26 -0500
Message-ID: <52951B49.6000201@metafoo.de>
Date: Tue, 26 Nov 2013 23:06:01 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Valentine <valentine.barshak@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH V2] media: i2c: Add ADV761X support
References: <1384520071-16463-1-git-send-email-valentine.barshak@cogentembedded.com> <692757747.1f4Evv5u9p@avalon> <52951AA7.4030202@metafoo.de> <16902508.hqJSb2Hj3Q@avalon>
In-Reply-To: <16902508.hqJSb2Hj3Q@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/26/2013 11:03 PM, Laurent Pinchart wrote:
> On Tuesday 26 November 2013 23:03:19 Lars-Peter Clausen wrote:
>> On 11/26/2013 11:00 PM, Laurent Pinchart wrote:
>>> On Tuesday 26 November 2013 22:43:32 Lars-Peter Clausen wrote:
>>>> On 11/26/2013 10:28 PM, Valentine wrote:
>>>>> On 11/20/2013 07:53 PM, Valentine wrote:
>>>>>> On 11/20/2013 07:42 PM, Hans Verkuil wrote:
>>>>>>> Hi Valentine,
>>>>>
>>>>> Hi Hans,
>>>>>
>>>>>>> Did you ever look at this adv7611 driver:
>>>>>>>
>>>>>>> https://github.com/Xilinx/linux-xlnx/commit/610b9d5de22ae7c0047c65a07e
>>>>>>> 4afa42af2daa12
>>>>>>
>>>>>> No, I missed that one somehow, although I did search for the
>>>>>> adv7611/7612 before implementing this one.
>>>>>> I'm going to look closer at the patch and test it.
>>>>>
>>>>> I've tried the patch and I doubt that it was ever tested on adv7611.
>>>>
>>>> It was and it works.
>>>>
>>>>> I haven't been able to make it work so far. Here's the description of
>>>>> some of the issues I've encountered.
>>>>>
>>>>> The patch does not apply cleanly so I had to make small adjustments just
>>>>> to make it apply without changing the functionality.
>>>>
>>>> I have an updated version of the patch, which I intend to submit soon.
>>>
>>> Is it publicly available already ?
>>
>> Just started working on it the other day.
> 
> I'm working on the same chip, how can we avoid effort duplication ?

I'll have something by the end of the week, latest.

