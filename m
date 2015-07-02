Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53013 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbbGBM3D (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jul 2015 08:29:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, mchehab@osg.samsung.com
Subject: Re: [RFCv2 PATCH 0/8] Add VIDIOC_SUBDEV_QUERYCAP and use MEDIA_IOC_DEVICE_INFO
Date: Thu, 02 Jul 2015 15:29:07 +0300
Message-ID: <14360550.BzyYl6Itqi@avalon>
In-Reply-To: <1430895443-41839-1-git-send-email-hverkuil@xs4all.nl>
References: <1430895443-41839-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patches.

On Wednesday 06 May 2015 08:57:15 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This patch series adds the VIDIOC_SUBDEV_QUERYCAP ioctl for v4l-subdev
> devices as discussed during the ELC in San Jose and as discussed here:
> 
> http://www.spinics.net/lists/linux-media/msg88009.html
> 
> It also add support for MEDIA_IOC_DEVICE_INFO to any media entities so
> applications can use that to find the media controller and detailed
> information about the entity.
> 
> This is the second RFC patch series. The main changes are:
> 
> - Drop the entity ID from the querycap ioctls
> - Instead have every entity device implement MEDIA_IOC_DEVICE_INFO
> - Add major, minor and entity_id fields to struct media_device_info:
>   this allows applications to find the MC device and to determine
>   the entity ID of the device for which they called the ioctl. It
>   is 0 for the MC (entity IDs are always > 0 for entities).
> 
> This is IMHO simple, consistent, and it will work for any media entity.

As discussed over IRC, I'd prefer adding the entity ID back to the querycap 
ioctl, and skipping the MEDIA_IOC_DEVICE_INFO changes for now. The reason is 
that our only current use case is v4l2-compliance which, albeit a real use 
case, doesn't seem enough to me to design two new ioctls.

I'm fine with a VIDIOC_SUBDEV_QUERYCAP ioctl as it mimics the V4L2 video 
device nodes API and is generally useful, and I believe it should be enough to 
fulfill v4l2-compliance's use cases if we add the entity ID.

> PS: I have not tested the DVB changes yet. I hope I got those right.
> 
> Hans Verkuil (8):
>   v4l2-subdev: add VIDIOC_SUBDEV_QUERYCAP ioctl
>   DocBook/media: document VIDIOC_SUBDEV_QUERYCAP
>   videodev2.h: add V4L2_CAP_ENTITY to querycap
>   media: add major/minor/entity_id to struct media_device_info
>   v4l2-subdev: add MEDIA_IOC_DEVICE_INFO
>   v4l2-ioctl: add MEDIA_IOC_DEVICE_INFO
>   dvb: add MEDIA_IOC_DEVICE_INFO
>   DocBook/media: document the new media_device_info fields.
> 
>  .../DocBook/media/v4l/media-ioc-device-info.xml    |  35 +++++-
>  Documentation/DocBook/media/v4l/v4l2.xml           |   1 +
>  .../DocBook/media/v4l/vidioc-querycap.xml          |   6 +
>  .../DocBook/media/v4l/vidioc-subdev-querycap.xml   | 125 ++++++++++++++++++
>  drivers/media/dvb-core/dmxdev.c                    |  24 +++-
>  drivers/media/dvb-core/dvb_ca_en50221.c            |  11 ++
>  drivers/media/dvb-core/dvb_net.c                   |  11 ++
>  drivers/media/media-device.c                       |  29 +++--
>  drivers/media/media-devnode.c                      |   5 +-
>  drivers/media/v4l2-core/v4l2-ioctl.c               |  43 ++++++-
>  drivers/media/v4l2-core/v4l2-subdev.c              |  26 +++++
>  include/media/media-device.h                       |   3 +
>  include/media/media-devnode.h                      |   1 +
>  include/uapi/linux/media.h                         |   5 +-
>  include/uapi/linux/v4l2-subdev.h                   |  10 ++
>  include/uapi/linux/videodev2.h                     |   1 +
>  16 files changed, 316 insertions(+), 20 deletions(-)
>  create mode 100644
> Documentation/DocBook/media/v4l/vidioc-subdev-querycap.xml

-- 
Regards,

Laurent Pinchart

