Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:57049 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751202AbaKQI5i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Nov 2014 03:57:38 -0500
Message-ID: <5469B874.9040008@xs4all.nl>
Date: Mon, 17 Nov 2014 09:57:24 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, pawel@osciak.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 06/11] videodev2.h: add new v4l2_ext_control flags
 field
References: <1411310909-32825-1-git-send-email-hverkuil@xs4all.nl> <1411310909-32825-7-git-send-email-hverkuil@xs4all.nl> <20141115141858.GG8907@valkosipuli.retiisi.org.uk> <20141115174459.GH8907@valkosipuli.retiisi.org.uk>
In-Reply-To: <20141115174459.GH8907@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/15/2014 06:44 PM, Sakari Ailus wrote:
> Hi,
> 
> On Sat, Nov 15, 2014 at 04:18:59PM +0200, Sakari Ailus wrote:
> ...
>>>  	union {
>>>  		__s32 value;
>>>  		__s64 value64;
>>> @@ -1294,6 +1294,10 @@ struct v4l2_ext_control {
>>>  	};
>>>  } __attribute__ ((packed));
>>>  
>>> +/* v4l2_ext_control flags */
>>> +#define V4L2_EXT_CTRL_FL_IGN_STORE_AFTER_USE	0x00000001
>>> +#define V4L2_EXT_CTRL_FL_IGN_STORE		0x00000002
>>
>> Do we need both? Aren't these mutually exclusive, and you must have either
>> to be meaningful in the context of a store?
> 
> Ah. Now I think I understand what do these mean. Please ignore my previous
> comment.
> 
> I might call them differently. What would you think of

I was never happy with the naming :-)

> V4L2_EXT_CTRL_FL_STORE_IGNORE and V4L2_EXT_CTRL_FL_STORE_ONCE?

I will give this some more thought.

> V4L2_EXT_CTRL_FL_IGN_STORE_AFTER_USE is quite long IMO. Up to you.
> 
> I wonder if we need EXT in V4L2_EXT_CTRL_FL. It's logical but also
> redundant since the old control interface won't have flags either.

True.

> I'd assume that for cameras the vast majority of users will always want to
> just apply the values once. How are the use cases in video decoding?

I am wondering whether 'apply once' shouldn't be the default and whether I
really need to implement the 'apply always' (Hey, not bad names either!)
functionality for this initial version.

I only used the 'apply always' functionality for a somewhat contrived test
example where I changed the cropping rectangle (this is with the selection
controls from patch 10/11) for each buffer so that while streaming I would
get a continuous zoom-in/zoom-out effect. While nice for testing, it isn't
really practical in reality.

Regards,

	Hans
