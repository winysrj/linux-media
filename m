Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:55499 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751523AbaKCOMN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Nov 2014 09:12:13 -0500
Message-ID: <54578D38.4000004@xs4all.nl>
Date: Mon, 03 Nov 2014 15:12:08 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, m.chehab@samsung.com
Subject: Re: [PATCH v4] media: spi: Add support for LMH0395
References: <1410342234-7444-1-git-send-email-jean-michel.hautbois@vodalys.com> <1630377.tEqlt7fWO7@avalon> <545784DA.50109@xs4all.nl> <12414520.uxZUhSYI7c@avalon>
In-Reply-To: <12414520.uxZUhSYI7c@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/03/2014 02:42 PM, Laurent Pinchart wrote:
> On Monday 03 November 2014 14:36:26 Hans Verkuil wrote:
>> On 11/03/2014 02:13 PM, Laurent Pinchart wrote:
>>> Hi Jean-Michel,
>>>
>>> Thank you for the patch.
>>
>>> On Wednesday 10 September 2014 11:43:54 Jean-Michel Hautbois wrote:
>> <snip>
>>
>>>> +static int lmh0395_s_routing(struct v4l2_subdev *sd, u32 input, u32
>>>> output, +				u32 config)
>>>> +{
>>>> +	struct lmh0395_state *state = to_state(sd);
>>>> +	int err = 0;
>>>> +
>>>> +	if (state->output_type != output)
>>>> +		err = lmh0395_set_output_type(sd, output);
>>>> +
>>>> +	return err;
>>>>
>>>         if (state->output_type == output)
>>>                 return 0;
>>>         
>>>         return lmh0395_set_output_type(sd, output);
>>>
>>> You can then get rid of the err variable.
>>>
>>> I don't really like this implementation though, the output argument is
>>> device- specific, you thus require explicit knowledge of the LMH0395 in
>>> your bridge driver.
>>
>> Well, that's the way s_routing is defined. It's the bridge driver's job to
>> translate between V4L2 inputs/outputs and low-level routing information.
>>
>>> I'm not sure what the config argument is used for, but naively I would
>>> have
>>
>> config is normally not used. There are one or two drivers that need it for
>> additional routing configuration, but it's rare.
> 
> OK.
> 
>>> used it to tell whether to enable (1) or disable (0) the route from input
>>> to output. The input value should then always be 0, and the output value
>>> can be 1 or 2. Another option would be to use the new S_ROUTING userspace
>>> ioctl I've proposed in
>>> http://git.linuxtv.org/cgit.cgi/pinchartl/media.git/commit/?h=xilinx-wip&i
>>> d=fc094c354338861673464ed4b8fa198089fe7bf0.
>>>
>>> Hans, could you comment on that ?
>>
>> Well, first of all your proposed API isn't merged yet, or even posted on the
>> mailinglist, so it's a bit unfair to require someone else to use it :-)
> 
> It's not a requirement, just a proposal :-) I can send a patch series if 
> there's enough interest for using that API.
> 
>> Also, while I do agree with your proposed new API I am a lot less
>> enthusiastic about creating yet another duplicate pad op for an existing
>> audio/video routing op.
>>
>> The problem is that existing drivers are never updated for the new op and
>> you are stuck with competing internal APIs. Not nice at all.
> 
> Agreed, it's not nice, feel free to propose a better solution :-)
> 
>> Bottom line is that this driver uses s_routing like any other driver
>> currently in the kernel, so I have no problem with that.
> 
> I do :-)
> 
> The bridge to subdev dependency is fine for PCI or USB devices where the 
> hardware topology is known to the driver. It isn't for composite embedded 
> devices, as we don't want to teach all bridges about all subdevs.
> 

I agree, and your proposal is a nice solution. But whoever want to get this
merged *will* have to take a good look at the existing g/s_routing ops and
how they can be converted to the new one. I didn't block that when similar
duplicate ops were added in the past and I am increasingly sorry I didn't do
that. It's creating incompatible subdevs, where the whole point of the subdev
API was to avoid that.

Regards,

	Hans
