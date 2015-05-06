Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:44162 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743AbbEFL1u (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 May 2015 07:27:50 -0400
Date: Wed, 6 May 2015 08:27:44 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [RFCv2 PATCH 0/8] Add VIDIOC_SUBDEV_QUERYCAP and use
 MEDIA_IOC_DEVICE_INFO
Message-ID: <20150506082744.4d7fc9aa@recife.lan>
In-Reply-To: <5549F1F7.6060701@xs4all.nl>
References: <1430895443-41839-1-git-send-email-hverkuil@xs4all.nl>
	<20150506063026.4ff3ff61@recife.lan>
	<5549F1F7.6060701@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 06 May 2015 12:50:31 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 05/06/15 11:30, Mauro Carvalho Chehab wrote:
> > Em Wed, 06 May 2015 08:57:15 +0200
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > 
> >> From: Hans Verkuil <hans.verkuil@cisco.com>
> >>
> >> This patch series adds the VIDIOC_SUBDEV_QUERYCAP ioctl for v4l-subdev devices
> >> as discussed during the ELC in San Jose and as discussed here:
> >>
> >> http://www.spinics.net/lists/linux-media/msg88009.html
> >>
> >> It also add support for MEDIA_IOC_DEVICE_INFO to any media entities so
> >> applications can use that to find the media controller and detailed information
> >> about the entity.
> > 
> > Why "IOC" at MEDIA_IOC_DEVICE_INFO?
> 
> Probably based on 'VIDIOC'. I can't help that that's the ioctl name.
> The MEDIA_IOC_DEVICE_INFO ioctl already exists as part of the media
> API. So I am not making a new ioctl here.

Ah, ok.

> > 
> > Also, I'm not sure yet how do you think apps should use this information,
> > especially when multiple media controller entities are present.
> > 
> > IMHO, the media controller instance number should be added at the
> > struct. Also, IMO, the docbook would need to give an usage example
> > for this ioctl.
> 
> The major+minor identifies the media controller exactly. An instance
> number doesn't add anything, or am I missing something?

Ah, so the major+minor are for the media controller device node, and
not for the v4l2 devnode.

OK.

> 
> And yes, a usage example will be needed, but this is still an RFC.
> 
> >>
> >> This is the second RFC patch series. The main changes are:
> >>
> >> - Drop the entity ID from the querycap ioctls
> > 
> > I'm not seeing this happening. Also, removing something at existing
> > ioctls may break userspace.
> 
> Changes since the *previous RFC patch series*. The existing code doesn't
> have an entity_id.

ah, ok.

I guess I should avoid avoid answering emails very early at morning
without taking first a good cup of coffee ;)
> 
> Regards,
> 
> 	Hans
> 
> >> - Instead have every entity device implement MEDIA_IOC_DEVICE_INFO
> >> - Add major, minor and entity_id fields to struct media_device_info:
> >>   this allows applications to find the MC device and to determine
> >>   the entity ID of the device for which they called the ioctl. It
> >>   is 0 for the MC (entity IDs are always > 0 for entities).
> >>
> >> This is IMHO simple, consistent, and it will work for any media entity.
> >>
> >> Regards,
> >>
> >> 	Hans
> >>
> >> PS: I have not tested the DVB changes yet. I hope I got those right.
> >>
> >> Hans Verkuil (8):
> >>   v4l2-subdev: add VIDIOC_SUBDEV_QUERYCAP ioctl
> >>   DocBook/media: document VIDIOC_SUBDEV_QUERYCAP
> >>   videodev2.h: add V4L2_CAP_ENTITY to querycap
> >>   media: add major/minor/entity_id to struct media_device_info
> >>   v4l2-subdev: add MEDIA_IOC_DEVICE_INFO
> >>   v4l2-ioctl: add MEDIA_IOC_DEVICE_INFO
> >>   dvb: add MEDIA_IOC_DEVICE_INFO
> >>   DocBook/media: document the new media_device_info fields.
> >>
> >>  .../DocBook/media/v4l/media-ioc-device-info.xml    |  35 +++++-
> >>  Documentation/DocBook/media/v4l/v4l2.xml           |   1 +
> >>  .../DocBook/media/v4l/vidioc-querycap.xml          |   6 +
> >>  .../DocBook/media/v4l/vidioc-subdev-querycap.xml   | 125 +++++++++++++++++++++
> >>  drivers/media/dvb-core/dmxdev.c                    |  24 +++-
> >>  drivers/media/dvb-core/dvb_ca_en50221.c            |  11 ++
> >>  drivers/media/dvb-core/dvb_net.c                   |  11 ++
> >>  drivers/media/media-device.c                       |  29 +++--
> >>  drivers/media/media-devnode.c                      |   5 +-
> >>  drivers/media/v4l2-core/v4l2-ioctl.c               |  43 ++++++-
> >>  drivers/media/v4l2-core/v4l2-subdev.c              |  26 +++++
> >>  include/media/media-device.h                       |   3 +
> >>  include/media/media-devnode.h                      |   1 +
> >>  include/uapi/linux/media.h                         |   5 +-
> >>  include/uapi/linux/v4l2-subdev.h                   |  10 ++
> >>  include/uapi/linux/videodev2.h                     |   1 +
> >>  16 files changed, 316 insertions(+), 20 deletions(-)
> >>  create mode 100644 Documentation/DocBook/media/v4l/vidioc-subdev-querycap.xml
> >>
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
