Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:35282 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757526AbcAYRIh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2016 12:08:37 -0500
Subject: Re: [PATCH v2] V4L: add Y12I, Y8I and Z16 pixel format documentation
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Aviv Greenberg <avivgr@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <Pine.LNX.4.64.1601181336520.9140@axis700.grange>
 <569E37E6.9080802@linux.intel.com>
 <Pine.LNX.4.64.1601251706240.20896@axis700.grange>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <56A6564A.1040207@linux.intel.com>
Date: Mon, 25 Jan 2016 19:07:22 +0200
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1601251706240.20896@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Guennadi Liakhovetski wrote:
> Hi Sakari,
>
> On Tue, 19 Jan 2016, Sakari Ailus wrote:
>
>> Hi Guennadi,
>>
>> Guennadi Liakhovetski wrote:
>>> Add documentation for 3 formats, used by RealSense cameras like R200.
>>>
>>> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>>> ---
>
> [snip]
>
>>> +    <para>This is a 16-bit format, representing depth data. Each pixel is a
>>> +distance to the respective point in the image coordinates. Distance unit can
>>> +vary and has to be negotiated with the device separately. Each pixel is stored
>>> +in a 16-bit word in the little endian byte order.
>>
>> I think we really need a way to convey the unit (and prefix) information
>> to the user. Considering the same should be done to controls, it'd be
>> logical to do that at the same time with the controls.
>
> Do I understand you correctly, that you'd like to add a control to specify
> distance units for this format? If yes - I don't think you want a separate
> control just for this format, right? And you mention, you also want to be

Considering there are no other depth formats defined, it should be 
generic I think, but so far with a single user.

> able to specify units for other controls. But I would've thought, that
> controls themselves should define, what unit they are using. E.g.
> V4L2_CID_EXPOSURE_ABSOLUTE specifies, that it's unit is 100us. I would
> expect the same from other controls too. "Legacy" controls like
> V4L2_CID_EXPOSURE don't specify units, so, I would expect, that their use
> should be discouraged.

Would you create a new control whenever someone needs a new unit for a 
control? That's the very problem I think --- currently applications have 
no means to know what's the unit for the control.

I've always wondered why we had V4L2_CID_EXPOSURE_ABSOLUTE as 
V4L2_CID_EXPOSURE already existed. :-)

The smiapp driver, for instance, uses V4L2_CID_EXPOSURE, and the unit is 
lines. There's a fine exposure control as well implemented by many 
sensors but the driver currently does not expose that capability.

>> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>>
>> I'd like to have Hans's and/or Laurent's ack on this as well.
>>
>> Unless the original patch requires changes, it could be re-applied if no
>> changes are requested to it. My understanding is that the issue mainly
>> was the missing documentation, i.e. this patch.
>
> Yes, I'll repost both patches as a series, maybe let's try to get some
> understanding on the units question first.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
