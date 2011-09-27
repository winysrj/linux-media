Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:47911 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292Ab1I0ORP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Sep 2011 10:17:15 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-15; format=flowed
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LS6004BNQCP4350@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 27 Sep 2011 15:17:13 +0100 (BST)
Received: from [106.116.48.223] by spt1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LS600GMYQCOLE@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 27 Sep 2011 15:17:13 +0100 (BST)
Date: Tue, 27 Sep 2011 16:17:11 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH 2/4] v4l: add documentation for selection API
In-reply-to: <201109271317.07571.laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl, sakari.ailus@iki.fi,
	'Kamil Debski' <k.debski@samsung.com>
Message-id: <4E81DAE7.60509@samsung.com>
References: <1314793703-32345-1-git-send-email-t.stanislaws@samsung.com>
 <201109231513.22342.laurent.pinchart@ideasonboard.com>
 <4E7CA433.1000402@samsung.com>
 <201109271317.07571.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 09/27/2011 01:17 PM, Laurent Pinchart wrote:
> Hi Tomasz,
>
> On Friday 23 September 2011 17:22:27 Tomasz Stanislawski wrote:
>> On 09/23/2011 03:13 PM, Laurent Pinchart wrote:
>

[snip]

>>
>> I have to ideas to add subpixels to selection API.
>>
>> 1. Introduce struct v4l2_frect similar to struct v4l2_rect. All its
>> fields' type would be struct v4l2_fract.
>> 2. Add field denominator to v4l2_selection as one of reserved fields.
>> All selection coordinates would be divided by this number.
>>
>> The 2nd proposal could added in the future update to selection API.
>
> The second solution seems the simplest. Drivers will likely not support
> arbitrary denominators, so we also need a way to report the acceptable
> value(s) to userspace.
>

The driver could set denominator to zero for G_SELECTION to indicate 
that no subpixel resolutions are supported. Moreover it is easy to 
convert fractional value to integers because rounding would be 
controlled by the constraints flags. This operation could be done by new 
helper function from V4L2 kernel API.

[snip]

>>>>>
>>>>> How would an application remove them ?
>>>>
>>>> The application may use memset if it recognizes fourcc. The idea of
>>>> padding target was to provide information about artifacts introduced the
>>>> hardware. If the image is decoded directly to framebuffer then the
>>>> application could remove artifacts. We could introduce some V4L2
>>>> control to inform if the padding are is filled with zeros to avoid
>>>> redundant memset.
>>>> What do you think?
>>>
>>> OK, I understand this better now. I'm still not sure how applications
>>> will be able to cope with that. memset'ing the garbage area won't look
>>> good on the screen.
>>
>> The memset is just a simple and usually fast solution. The application
>> could fill the padding area with any pattern or background color.
>>
>>> Does your hardware have different compose and padding rectangles ?
>>
>> I assume that you mean active and padded targets for composing, right?
>> The answer is yes. The MFC inserts data to the image that dimensions are
>> multiples of 128x32. The movie inside could be any size that fits to the
>> buffer. The area that contains the movie frame is the active rectangle.
>> The padded is filled with zeros. For MFC the bounds and padded rectangle
>> are the same.
>>
>> Hmm...
>>
>> Does it violate 'no margin requirement', doesn't it?
>
> Seems so :-)
>

For S5P MFC is it not possible to satisfy 'no margin' requirement in all 
cases. The default rectangle is not equal to the bound rectangle in all 
cases. BTW, the MFC is mem2mem device so its API may change.
To sum up for MFC following inequalities are satisfied:

active <= padded == bound

Do you think that 'no margin' requirement should be downgraded to a 
recommendation status?

[snip]

>
> I think the driver should always return the best-hit rectangle, regardless of
> whether we use hints or not.
>

The problem is that when the VIDIOC_S_SELECTION fails (could not satisfy 
constraints) then the ioctl'a parameters are not copied to the 
userspace. So no best-hit rectangle can be returned. On the other hand, 
if the ioctl would not fail in this case then the configuration is 
applied, causing pipeline messing. We have no-win situation.

If the application accepts all rectangles then it should never use the 
constraint flags in the first place. Moreover, the application can 
always remove the constraints flags and try again. At least, the fall 
back is done explicitly in that case.

The VIDIOC_TRY_SELECTION could be added to cope with more complex 
negotiations.

Best regards,
Tomasz Stanislawski
