Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40874 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbbEDHoY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2015 03:44:24 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] Add VIDIOC_SUBDEV_QUERYCAP
Date: Mon, 04 May 2015 01:33:02 +0300
Message-ID: <5300971.JLUFHG4Si2@avalon>
In-Reply-To: <5543664F.3090803@xs4all.nl>
References: <1430480030-29136-1-git-send-email-hverkuil@xs4all.nl> <5543664F.3090803@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Friday 01 May 2015 13:41:03 Hans Verkuil wrote:
> On 05/01/2015 01:33 PM, Hans Verkuil wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > This patch series adds the VIDIOC_SUBDEV_QUERYCAP ioctl for v4l-subdev
> > devices as discussed during the ELC in San Jose and as discussed here:
> > 
> > http://www.spinics.net/lists/linux-media/msg88009.html
> > 
> > It also adds the entity_id to v4l2_capability.
> 
> Question: why do we have CONFIG_VIDEO_V4L2_SUBDEV_API? I don't really see
> the point of this and I would propose to remove this config option and
> instead use CONFIG_MEDIA_CONTROLLER.
> 
> I don't see the use-case of having MEDIA_CONTROLLER defined but not
> VIDEO_V4L2_SUBDEV_API.
> 
> Comments?

The idea is to compile the subdev userspace API code out when not needed. Not 
all media controller drivers need that API.

> > Hans Verkuil (3):
> >   v4l2-subdev: add VIDIOC_SUBDEV_QUERYCAP ioctl
> >   DocBook/media: document VIDIOC_SUBDEV_QUERYCAP
> >   videodev2.h: add entity_id to struct v4l2_capability
> >  
> >  Documentation/DocBook/media/v4l/v4l2.xml           |   1 +
> >  .../DocBook/media/v4l/vidioc-querycap.xml          |  18 ++-
> >  .../DocBook/media/v4l/vidioc-subdev-querycap.xml   | 140 ++++++++++++++++
> >  drivers/media/v4l2-core/v4l2-ioctl.c               |   7 ++
> >  drivers/media/v4l2-core/v4l2-subdev.c              |  19 +++
> >  include/uapi/linux/v4l2-subdev.h                   |  12 ++
> >  include/uapi/linux/videodev2.h                     |   5 +-
> >  7 files changed, 199 insertions(+), 3 deletions(-)
> >  create mode 100644
> >  Documentation/DocBook/media/v4l/vidioc-subdev-querycap.xml

-- 
Regards,

Laurent Pinchart

