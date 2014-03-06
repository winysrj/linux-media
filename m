Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2767 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbaCFM73 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Mar 2014 07:59:29 -0500
Message-ID: <5318710C.1070204@xs4all.nl>
Date: Thu, 06 Mar 2014 13:58:52 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, marbugge@cisco.com
Subject: Re: [RFCv1 PATCH 0/4] add G/S_EDID support for video nodes
References: <1393932659-13817-1-git-send-email-hverkuil@xs4all.nl> <2313806.6Mf9nE69NY@avalon> <5318252B.2080802@xs4all.nl> <2719510.vO5HGhFCIt@avalon>
In-Reply-To: <2719510.vO5HGhFCIt@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/06/14 11:37, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Thursday 06 March 2014 08:35:07 Hans Verkuil wrote:
>> On 03/06/2014 02:45 AM, Laurent Pinchart wrote:
>>> On Tuesday 04 March 2014 12:30:55 Hans Verkuil wrote:
>>>> Currently the VIDIOC_SUBDEV_G/S_EDID and struct v4l2_subdev_edid are
>>>> subdev APIs. However, that's in reality quite annoying since for simple
>>>> video pipelines there is no need to create v4l-subdev device nodes for
>>>> anything else except for setting or getting EDIDs.
>>>>
>>>> What happens in practice is that v4l2 bridge drivers add explicit support
>>>> for VIDIOC_SUBDEV_G/S_EDID themselves, just to avoid having to create
>>>> subdev device nodes just for this.
>>>>
>>>> So this patch series makes the ioctls available as regular ioctls as
>>>> well. In that case the pad field should be set to 0 and the bridge driver
>>>> will fill in the right pad value internally depending on the current
>>>> input or output and pass it along to the actual subdev driver.
>>>
>>> Would it make sense to allow usage of the pad field on video nodes as well
>>> ?
>> No, really not. The video node driver has full control over which
>> inputs/outputs map to which pads. None of that is (or should be) visible
>> from userspace.
> 
> What about using the pad field as an input number in that case ? That would 
> allow getting and setting EDID for the different inputs without requiring to 
> change the active input, just like we can do with the subdev API.

That's a good idea. How should I do that with the v4l2_edid struct: just
expect userspace to fill in the pad but interpret it differently, or change
it to a union:

	union {
		__u32 pad;
		__u32 input;
		__u32 output;
	};

Regards,

	Hans

> 
>> What should probably change is that rather than requiring userspace to set
>> pad to 0, I just say that it is ignored. The bridge driver will fill in the
>> pad before handing it over to the relevant subdev. Requiring apps to set it
>> to 0 (which is a valid pad number anyway, so that doesn't really help with
>> possible future use of the field) will require the driver to set it to 0 as
>> well after having called the subdev. Which is annoying and will be
>> forgotten anyway.
>>
>> I also need to mention in the docbook that if it is called for a pad, an
>> input or an output that does not support EDIDs these ioctls will return
>> -EINVAL.
>>
>> I'll post a REVIEWv1 series soon.
>>
>> Regards,
>>
>> 	Hans
>>
>>> Apart from that and minor issues with patch 2/4 this series looks good to
>>> me.
> 

