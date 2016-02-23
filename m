Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:48498 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751809AbcBWQJ6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2016 11:09:58 -0500
Subject: Re: [PATCH] soc_camera/omap1: move to staging in preparation for
 removal
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <56CC4CD0.7050308@xs4all.nl>
 <Pine.LNX.4.64.1602231554230.17650@axis700.grange>
 <56CC73B7.6070804@xs4all.nl>
 <Pine.LNX.4.64.1602231604460.17650@axis700.grange> <56CC8125.60205@xs4all.nl>
 <Pine.LNX.4.64.1602231701380.17650@axis700.grange>
Cc: linux-media <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56CC8451.5080909@xs4all.nl>
Date: Tue, 23 Feb 2016 17:09:53 +0100
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1602231701380.17650@axis700.grange>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/23/2016 05:03 PM, Guennadi Liakhovetski wrote:
> On Tue, 23 Feb 2016, Hans Verkuil wrote:
> 
>> On 02/23/2016 04:05 PM, Guennadi Liakhovetski wrote:
>>> On Tue, 23 Feb 2016, Hans Verkuil wrote:
>>>
>>>> On 02/23/16 15:55, Guennadi Liakhovetski wrote:
>>>>> Hi Hans,
>>>>>
>>>>> On Tue, 23 Feb 2016, Hans Verkuil wrote:
>>>>>
>>>>>> This driver is deprecated: it needs to be converted to vb2 and
>>>>>> it should become a stand-alone driver instead of using the
>>>>>> soc-camera framework.
>>>>>>
>>>>>> Unless someone is willing to take this on (unlikely with such
>>>>>> ancient hardware) it is going to be removed from the kernel
>>>>>> soon.
>>>>>>
>>>>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>>>>
>>>>> I guess I won't be pulling this through my tree, right?
>>>>
>>>> Right.
>>>>
>>>>>
>>>>> Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>>>>
>>>> Thanks!
>>>>
>>>> This one was easy.
>>>
>>> mx2, mx3 should be easy too?
>>
>> Sure. Are you certain these can be deprecated? I haven't heard
>> anything regarding the status of these driver. You probably know that
>> best.
>>
>> If you give me the go ahead, then I'll prepare patches for these to
>> move them to staging.
> 
> I asked pengutronix guys, they don't care about them any more. We had 
> someone from freescale on CC in the original discussion, they didn't 
> report back either, so... Up to you really, I'd put the probability of 
> someone coming forward with a strong enough case to keep them at 4% :-) Is 
> it good enough for you to prepare that patch?

Yes, that's good enough. It's not as if we remove it right away, it'll be
in staging for a while.

Thanks for the info,

	Hans

