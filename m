Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:60208 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752257AbbCWOwY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Mar 2015 10:52:24 -0400
Message-ID: <5510289D.5040107@xs4all.nl>
Date: Mon, 23 Mar 2015 07:52:13 -0700
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [RFC PATCH] v4l2-ioctl: fill in the description for VIDIOC_ENUM_FMT
References: <550C0FCF.4030302@xs4all.nl> <2791463.SXeInvhsda@avalon>
In-Reply-To: <2791463.SXeInvhsda@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/22/2015 01:38 PM, Laurent Pinchart wrote:
> Hi Hans,
> 
> Thank you for the patch.
> 
> On Friday 20 March 2015 13:17:19 Hans Verkuil wrote:
>> The descriptions used in drivers for the formats returned with ENUM_FMT
>> are all over the place.
>>
>> So instead allow the core to fill in the description and flags. This
>> allows drivers to drop the description and flags.
>>
>> If the format is not found in the list, and if the description field is
>> filled in, then just return but call WARN_ONCE to let developers know
>> that this list needs to be extended.
>>
>> Based on an earlier patch from Philipp Zabel:
>> http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/814
>> 11
>>
>> But this patch moves the code into the core and away from drivers.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> Cc: Philipp Zabel <p.zabel@pengutronix.de>
> 
> I have a similar patch in one of my git trees, although I'm not sure exactly 
> where I've put it :-) It at least means that I like the idea.
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> I wonder whether the big switch statement could be optimized though, 
> especially given that there's two of them, one for the description, and one 
> for the flags. You could store the information in an array and lookup the 
> entry based on the pixelcode, that would at least get rid of one switch 
> statement. Further optimization would be possible by using some kind of hash 
> table, but I'm not sure if it's worth it.

The gcc compiler is quite smart when optimizing a switch statement, it
certainly produces code that is faster than a table lookup. I'll take a
look at the gcc output, but I expect it to be either O(log N) comparisons,
or possibly even O(1) if it is smart enough to create a perfect hash for this.

Regards,

	Hans
