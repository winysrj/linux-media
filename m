Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:48993 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751792AbbHTMgl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Aug 2015 08:36:41 -0400
Message-ID: <55D5C93A.6010405@xs4all.nl>
Date: Thu, 20 Aug 2015 14:34:02 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [RFC v3 02/19] media/v4l2-core: add new ioctl VIDIOC_G_DEF_EXT_CTRLS
References: <1434127598-11719-1-git-send-email-ricardo.ribalda@gmail.com> <CAPybu_2a+z6ZVY=-ZXE6Usmoe0nsLjUzw3AE5=K9vQ6OCDgKaw@mail.gmail.com> <55AD063A.1030705@xs4all.nl> <1822611.kBQQQkHzQk@avalon>
In-Reply-To: <1822611.kBQQQkHzQk@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/20/15 00:19, Laurent Pinchart wrote:
> Hi Hans,
> 
> I like your proposal, and especially how it would integrate with the requests 
> API. Should we give the requests API a try to make sure your proposal works 
> fine with it ?

To be honest, I don't see what there is to test. Request IDs have their own range
and there is no conflict there. Easiest for me is to rebase my request patch series
on top of Ricardo's patch series that implements this. That should be pretty quick
to do.

Ricardo, just go ahead with this and I'll take care of rebasing the request patch
series on top of it once you're done. I'll probably do that as part of my review
of your new patch series once it is posted.

> As a side note, I'll need to requests API for Renesas. The current schedule is 
> to have a first RFC implementation by the end of October.

Cool. I'd like to get this in! Please involve me if there are any questions you
have or work that you want me to do on the request API to improve it.

Regards,

	Hans

> 
> On Monday 20 July 2015 16:31:22 Hans Verkuil wrote:
>> On 07/20/2015 03:52 PM, Ricardo Ribalda Delgado wrote:
>>> Hello
>>>
>>> I have no preference over the two implementations, but I see an issue
>>> with this suggestion.
>>>
>>> What happens to out out tree drivers, or drivers that don't support
>>> this functionality?
>>>
>>> With the ioctl, the user receives a -ENOTTY. So he knows there is
>>> something wrong with the driver.
>>>
>>> With this class, the driver might interpret this a simple G_VAL and
>>> return he current value with no way for the user to know what is going
>>> on.
>>
>> Drivers that implement the current API correctly will return an error
>> if V4L2_CTRL_WHICH_DEF_VAL was specified. Such drivers will interpret
>> the value as a control class, and no control classes in that range exist.
>> See also class_check() in v4l2-ctrls.c.
>>
>> The exception here is uvc which doesn't have this class check and it will
>> just return the current value :-(
>>
>> I don't see a way around this, unfortunately.
> 
> The rationale for implementing VIDIOC_G_DEF_EXT_CTRLS was to get the default 
> value of controls that don't fit in 32 bits. uvcvideo doesn't have any such 
> control, so I don't think we really need to care. Of course newer versions of 
> the uvcvideo driver should implement the new API.
> 
>> Out-of-tree drivers that use the control framework are fine, and I don't
>> really care about drivers (out-of-tree or otherwise) that do not use the
>> control framework.
>>
>>> Regarding the new implementation.... I can make some code next week,
>>> this week I am 120% busy :)
>>
>> Wait until there is a decision first :-)
>>
>> It's not a lot of work, I think.
> 
> I think I like your proposal better than VIDIOC_G_DEF_EXT_CTRLS, so seeing an 
> implementation would be nice.
> 
