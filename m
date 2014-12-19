Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:3266 "EHLO
	aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbaLSMVc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 07:21:32 -0500
Message-ID: <54941849.4090608@cisco.com>
Date: Fri, 19 Dec 2014 13:21:29 +0100
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	prabhakar.csengg@gmail.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 5/8] media/i2c/Kconfig: drop superfluous MEDIA_CONTROLLER
References: <1417686899-30149-1-git-send-email-hverkuil@xs4all.nl> <14053074.Xr1qj9KfnY@avalon> <54940FAE.1060004@xs4all.nl> <2482917.BOOSdVSKV1@avalon>
In-Reply-To: <2482917.BOOSdVSKV1@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/19/2014 01:18 PM, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Friday 19 December 2014 12:44:46 Hans Verkuil wrote:
>> On 12/08/2014 12:38 AM, Laurent Pinchart wrote:
>>> On Thursday 04 December 2014 10:54:56 Hans Verkuil wrote:
>>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>>
>>>> These drivers depend on VIDEO_V4L2_SUBDEV_API, which in turn
>>>> depends on MEDIA_CONTROLLER. So it is sufficient to just depend
>>>> on VIDEO_V4L2_SUBDEV_API.
>>>
>>> Shouldn't the VIDEO_V4L2_SUBDEV_API dependency be dropped from those (and
>>> other) subdev drivers ? They don't require the userspace API, just the
>>> kernel part.
>>
>> They set V4L2_SUBDEV_FL_HAS_DEVNODE and use v4l2_subdev_get_try_format,
>> so they do need VIDEO_V4L2_SUBDEV_API. Or am I missing something?
> 
> VIDEO_V4L2_SUBDEV_API was initially designed to cover both the subdev 
> userspace API and the subdev in-kernel pad-level API. Now that the latter has 
> been found useful without the former, I think we should revisit the idea.
> 
> Does it still make sense to have a single Kconfig option to cover both 
> concepts ? Should it be kept a-is, split in two, or redefined to cover the 
> userspace API only (with the v4l2_subdev_get_try_* functions being then always 
> available) ? As the idea is to standardize on pad-level operations for in-
> kernel communication between bridges and subdevs the v4l2_subdev_get_try_* 
> functions will get increasingly used in most (if not all) subdev drivers.

OK, but if you don't mind I would make such changes in a separate patch.
This patch just removes an obviously superfluous dependency and brings these
drivers in line with the others.

Removing it altogether is a separate issue.

Regards,

	Hans

