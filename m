Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:43819 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbbEFJab (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 May 2015 05:30:31 -0400
Date: Wed, 6 May 2015 06:30:26 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [RFCv2 PATCH 0/8] Add VIDIOC_SUBDEV_QUERYCAP and use
 MEDIA_IOC_DEVICE_INFO
Message-ID: <20150506063026.4ff3ff61@recife.lan>
In-Reply-To: <1430895443-41839-1-git-send-email-hverkuil@xs4all.nl>
References: <1430895443-41839-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 06 May 2015 08:57:15 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This patch series adds the VIDIOC_SUBDEV_QUERYCAP ioctl for v4l-subdev devices
> as discussed during the ELC in San Jose and as discussed here:
> 
> http://www.spinics.net/lists/linux-media/msg88009.html
> 
> It also add support for MEDIA_IOC_DEVICE_INFO to any media entities so
> applications can use that to find the media controller and detailed information
> about the entity.

Why "IOC" at MEDIA_IOC_DEVICE_INFO?

Also, I'm not sure yet how do you think apps should use this information,
especially when multiple media controller entities are present.

IMHO, the media controller instance number should be added at the
struct. Also, IMO, the docbook would need to give an usage example
for this ioctl.
> 
> This is the second RFC patch series. The main changes are:
> 
> - Drop the entity ID from the querycap ioctls

I'm not seeing this happening. Also, removing something at existing
ioctls may break userspace.

> - Instead have every entity device implement MEDIA_IOC_DEVICE_INFO
> - Add major, minor and entity_id fields to struct media_device_info:
>   this allows applications to find the MC device and to determine
>   the entity ID of the device for which they called the ioctl. It
>   is 0 for the MC (entity IDs are always > 0 for entities).
> 
> This is IMHO simple, consistent, and it will work for any media entity.
> 
> Regards,
> 
> 	Hans
> 
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
>  .../DocBook/media/v4l/vidioc-subdev-querycap.xml   | 125 +++++++++++++++++++++
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
>  create mode 100644 Documentation/DocBook/media/v4l/vidioc-subdev-querycap.xml
> 
