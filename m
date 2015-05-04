Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:38443 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751893AbbEDIGX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 May 2015 04:06:23 -0400
Message-ID: <55472873.3010601@xs4all.nl>
Date: Mon, 04 May 2015 10:06:11 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] Add VIDIOC_SUBDEV_QUERYCAP
References: <1430480030-29136-1-git-send-email-hverkuil@xs4all.nl> <5543664F.3090803@xs4all.nl> <5300971.JLUFHG4Si2@avalon>
In-Reply-To: <5300971.JLUFHG4Si2@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/04/2015 12:33 AM, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Friday 01 May 2015 13:41:03 Hans Verkuil wrote:
>> On 05/01/2015 01:33 PM, Hans Verkuil wrote:
>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>
>>> This patch series adds the VIDIOC_SUBDEV_QUERYCAP ioctl for v4l-subdev
>>> devices as discussed during the ELC in San Jose and as discussed here:
>>>
>>> http://www.spinics.net/lists/linux-media/msg88009.html
>>>
>>> It also adds the entity_id to v4l2_capability.
>>
>> Question: why do we have CONFIG_VIDEO_V4L2_SUBDEV_API? I don't really see
>> the point of this and I would propose to remove this config option and
>> instead use CONFIG_MEDIA_CONTROLLER.
>>
>> I don't see the use-case of having MEDIA_CONTROLLER defined but not
>> VIDEO_V4L2_SUBDEV_API.
>>
>> Comments?
> 
> The idea is to compile the subdev userspace API code out when not needed. Not 
> all media controller drivers need that API.

Sure, but it is not a lot of code, and I think it is somewhat confusing.

Just my opinion, though.

	Hans

> 
>>> Hans Verkuil (3):
>>>   v4l2-subdev: add VIDIOC_SUBDEV_QUERYCAP ioctl
>>>   DocBook/media: document VIDIOC_SUBDEV_QUERYCAP
>>>   videodev2.h: add entity_id to struct v4l2_capability
>>>  
>>>  Documentation/DocBook/media/v4l/v4l2.xml           |   1 +
>>>  .../DocBook/media/v4l/vidioc-querycap.xml          |  18 ++-
>>>  .../DocBook/media/v4l/vidioc-subdev-querycap.xml   | 140 ++++++++++++++++
>>>  drivers/media/v4l2-core/v4l2-ioctl.c               |   7 ++
>>>  drivers/media/v4l2-core/v4l2-subdev.c              |  19 +++
>>>  include/uapi/linux/v4l2-subdev.h                   |  12 ++
>>>  include/uapi/linux/videodev2.h                     |   5 +-
>>>  7 files changed, 199 insertions(+), 3 deletions(-)
>>>  create mode 100644
>>>  Documentation/DocBook/media/v4l/vidioc-subdev-querycap.xml
> 

