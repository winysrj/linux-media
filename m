Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:44043 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab1LSQ2b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Dec 2011 11:28:31 -0500
Message-ID: <4EEF6622.6050904@infradead.org>
Date: Mon, 19 Dec 2011 14:28:18 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	javier Martin <javier.martin@vista-silicon.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	saaguirre@ti.com
Subject: Re: [PATCH] V4L: soc-camera: provide support for S_INPUT.
References: <1324022443-5967-1-git-send-email-javier.martin@vista-silicon.com> <CACKLOr1=vFs8xDaDMSX146Y1h18q=+fPEBGHekgNq2xRVCOGsA@mail.gmail.com> <Pine.LNX.4.64.1112191237300.23694@axis700.grange> <201112191252.24101.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201112191252.24101.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19-12-2011 09:52, Laurent Pinchart wrote:
> Hi,
> 
> On Monday 19 December 2011 12:43:28 Guennadi Liakhovetski wrote:
>> On Mon, 19 Dec 2011, javier Martin wrote:
>>> On 19 December 2011 11:58, Guennadi Liakhovetski wrote:
>>>> On Mon, 19 Dec 2011, javier Martin wrote:
>>>>> On 19 December 2011 11:41, Guennadi Liakhovetski wrote:
>>>>>> On Mon, 19 Dec 2011, Laurent Pinchart wrote:
>>>>>>> On Monday 19 December 2011 11:13:58 Guennadi Liakhovetski wrote:
>>>>>>>> On Mon, 19 Dec 2011, Laurent Pinchart wrote:
>>>>>>>>> On Monday 19 December 2011 09:09:34 Guennadi Liakhovetski wrote:
> 
> [snip]
> 
>>>>>>>>>> Good, this would mean, we need additional subdevice
>>>>>>>>>> operations along the lines of enum_input and enum_output,
>>>>>>>>>> and maybe also g_input and g_output?
>>>>>>>>>
>>>>>>>>> What about implementing pad support in the subdevice ? Input
>>>>>>>>> enumeration could then be performed without a subdev
>>>>>>>>> operation.
>>>>>>>>
>>>>>>>> soc-camera doesn't support pad operations yet.
>>>>>>>
>>>>>>> soc-camera doesn't support enum_input yet either, so you need to
>>>>>>> implement something anyway ;-)
>>>>>>>
>>>>>>> You wouldn't need to call a pad operation here, you would just need
>>>>>>> to iterate through the pads provided by the subdev.
>>>>>>
>>>>>> tvp5150 doesn't implement it either yet. So, I would say, it is a
>>>>>> better solution ATM to fix this functionality independent of the
>>>>>> pad-level API.
>>>>>
>>>>> I agree,
>>>>> I cannot contribute to implement pad-level API stuff since I can't
>>>>> test it with tvp5150.
>>>>>
>>>>> Would you accept a patch implementing only S_INPUT?
>>>>
>>>> Sorry, maybe I'm missing something, but how would it work? I mean, how
>>>> can we accept from the user any S_INPUT request with index != 0, if we
>>>> always return only 0 in reply to ENUM_INPUT? Ok, G_INPUT we could
>>>> implement internally in soc-camera: return 0 by default, then remember
>>>> last set input number per soc-camera device / subdev. But
>>>> ENUM_INPUT?...
>>>
>>> It clearly is not a complete solution but at least it allows setting
>>> input 0 in broken drivers such as tvp5150 which have input 1 enabled
>>> by default, while soc-camera assumes input 0 is enabled.
>>
>> I would really prefer an addition of an .enum_input() video subdev
>> operation.
> 
> I agree that input enumeration is needed, but I really think this should be 
> handled through pads, no with a new subdev operation. I don't like the idea of 
> introducing a new operation that will already be deprecated from the very 
> beginning.

The enum_input/g_input/s_input operations/callbacks are not deprecated at all.
They're widely used on all analog TV devices, and there's absolutely no reason
at all to deprecate them.

Regards,
Mauro
