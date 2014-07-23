Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4255 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbaGWGjz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 02:39:55 -0400
Message-ID: <53CF58AE.7020806@xs4all.nl>
Date: Wed, 23 Jul 2014 08:39:42 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "Monica, Agnes" <Agnes.Monica@analog.com>,
	"v4l2-library@linuxtv.org" <v4l2-library@linuxtv.org>,
	linux-media <linux-media@vger.kernel.org>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [V4l2-library] FourCC support
References: <E2B3634EC825DA45A0EB7D5409D69FBE584D03FA@NWD2MBX6.ad.analog.com> <53CE116D.8010404@xs4all.nl> <53CE14CF.9010900@xs4all.nl> <E2B3634EC825DA45A0EB7D5409D69FBE584D1571@NWD2MBX6.ad.analog.com>
In-Reply-To: <E2B3634EC825DA45A0EB7D5409D69FBE584D1571@NWD2MBX6.ad.analog.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/23/2014 07:04 AM, Monica, Agnes wrote:
> Hi,
> 
> It would be good if support exists for full and limited range. 
> 
> 1. So can we re-use(map) the existing  colorspace  for our different color format.

Well, no, obviously. You need to propose new colorspace defines. The list of
colorspace defines is in videodev2.h. the best procedure is to post an RFC to
the linux-media mailinglist with the new defines that you need and explain why
you need them. The next step would be to write patches adding those defines
and updating the DocBook documentation (Documentation/DocBook/media/v4l/pixfmt.xml).

Contact me first before working on the docbook since I plan on rewriting that
section.

There is always a chicken-and-egg problem in that a driver actually need to
use the new defines before they can go in. However, in this case you can try
to add support for it to e.g. adv7604 and/or adv7511. That might be the fastest
way of getting it in.

> 2. Or is it a good way to use custom control command. 

Absolutely not. Colorspace handling is done through the colorspace defines. So
if you need new ones, just add them properly.

For what chip(s) are you developing? Quite a few adv drivers are already in the
kernel. Perhaps it is wise to coordinate this? In particular, take a look at
existing drivers like the adv7604 and adv7511.

> 
> So in future if we come across some specific features with respect to
> our chip, is it good to use custom control or duplicate the
> functionality of the existing enums.

First you ask on the mailinglist, then we can give an answer what the best
approach will be. Abuse of existing APIs will make it very hard if not
impossible to get such a driver merged in the kernel. So please don't do that.
In general either proper support should be added to v4l2 for the feature you
want to add, or it is a driver-specific control or ioctl. But all too often
what you think is driver specific is really a lot more common than you thought.

But above all, ask first on the mailinglist!

If your goal is to upstream the drivers (I hope so, speaking as one customer of
Analog), then please avoid taking shortcuts. It will only cause problems later.

I'm happy to help out with pointers, review, etc.

Regards,

	Hans

> 
> Regards,
> Monica
> 
> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl] 
> Sent: Tuesday, July 22, 2014 1:08 PM
> To: Monica, Agnes; v4l2-library@linuxtv.org; linux-media; Lars-Peter Clausen
> Subject: Re: [V4l2-library] FourCC support
> 
> On 07/22/14 09:23, Hans Verkuil wrote:
>> Hi Monica,
>>
>> The v4l2-library is not the best mailinglist for that so I've added 
>> linux-media as well, which is more appropriate. I've also added 
>> Lars-Peter since he does a lot of adv work as well.
>>
>> The short answer is that those colorspaces are not supported at the 
>> moment, but that it is not a problem to add them, provided the driver 
>> you are working on is going to be upstreamed (i.e., we'd like to have 
>> users for the API elements we add).
>>
>> One note of interest: there is currently no API mechanism to tell 
>> userspace if the image data is limited or full range. YCbCr is always 
>> assumed to be limited range and RGB full range. If you need to signal 
>> that, then let me know. A flags field has been added to struct 
>> v4l2_pix_format in the last few days that would allow you to add a 
>> 'ALT_RANGE' flag, telling userspace that the alternate quantization 
>> range is used. This flag doesn't exist yet, but it is no problem to add it.
> 
> To prevent any confusion: the colorspace isn't determined by the format fourcc, it's a separate colorspace field using the V4L2_COLORSPACE_* defines. The pixelformat and colorspace are two very different things.
> 
> Regards,
> 
> 	Hans
> 
>>
>> Hope this helps,
>>
>> 	Hans
>>
>> On 07/22/14 08:18, Monica, Agnes wrote:
>>> Hi ,
>>>
>>> One of drivers which we are developing supports formats like sYcc , 
>>> AdobeRGB and AdobeYCC601 which was added recently in HDMI spec1.4. So 
>>> can you please tell me how will these formats be supported by fmt.
>>>
>>> Regards,
>>>
>>> Monica
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" 
>> in the body of a message to majordomo@vger.kernel.org More majordomo 
>> info at  http://vger.kernel.org/majordomo-info.html
>>
> 

