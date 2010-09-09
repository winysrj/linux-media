Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:60016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754993Ab0IIBoO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Sep 2010 21:44:14 -0400
Message-ID: <4C883BEF.5020504@redhat.com>
Date: Wed, 08 Sep 2010 22:44:15 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
Subject: Re: [RFC/PATCH v4 00/11] Media controller (core and V4L2)
References: <1282318153-18885-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1282318153-18885-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Em 20-08-2010 12:29, Laurent Pinchart escreveu:
> Hi everybody,
> 
> Here's the fourth version of the media controller patches. All comments received
> so far have hopefully been incorporated.
> 
> Compared to the previous version, the patches have been rebased on top of 2.6.35
> and a MEDIA_IOC_DEVICE_INFO ioctl has been added.
> 
> I won't submit a rebased version of the V4L2 API additions and OMAP3 ISP patches
> right now. I will first clean up (and document) the V4L2 API additions patches,
> and I will submit them as a proper RFC instead of sample code.

Hi Laurent,

Sorry for a late review on the media controller API. I got flooded by patches and
other work since the merge window. Anyway, just finished my review, and sent a
per-patch comment for most patches.

One general comment about it: the userspace API should be documented via DocBook, 
to be consistent with V4L2 and DVB API specs.

It should also be clear at the API specs there that not all media drivers will 
implement the media controller API, as its main focus is to allow better control
of SoC devices, where there are needs to control some intrinsic characteristics of 
parts of the devices, complementing the V4L2 spec. 

This means that it is needed to add some comments at the kernelspace API doc, saying that
the drivers implementing the media controller API are required to work properly even 
when userspace is not using the media controller API;

This also means that it is needed to add some comments at the userspace API doc, saying
that userspace applications should not assume that media drivers will implement the 
media controller API. So, userspace applications implementing the media controller 
and V4L2 API's are required to work properly if the device doesn't present a media 
controler API interface. It should also say that no driver should just implement the
media controller API.

> 
> Laurent Pinchart (9):
>   media: Media device node support
>   media: Media device
>   media: Entities, pads and links
>   media: Media device information query
>   media: Entities, pads and links enumeration
>   media: Links setup
>   v4l: Add a media_device pointer to the v4l2_device structure
>   v4l: Make video_device inherit from media_entity
>   v4l: Make v4l2_subdev inherit from media_entity
> 
> Sakari Ailus (2):
>   media: Entity graph traversal
>   media: Reference count and power handling
> 
>  Documentation/media-framework.txt            |  574 ++++++++++++++++++++++++
>  Documentation/video4linux/v4l2-framework.txt |   72 +++-
>  drivers/media/Makefile                       |    8 +-
>  drivers/media/media-device.c                 |  377 ++++++++++++++++
>  drivers/media/media-devnode.c                |  310 +++++++++++++
>  drivers/media/media-entity.c                 |  614 ++++++++++++++++++++++++++
>  drivers/media/video/v4l2-dev.c               |   35 ++-
>  drivers/media/video/v4l2-device.c            |   45 ++-
>  drivers/media/video/v4l2-subdev.c            |   27 ++-
>  include/linux/media.h                        |  105 +++++
>  include/media/media-device.h                 |   90 ++++
>  include/media/media-devnode.h                |   78 ++++
>  include/media/media-entity.h                 |  112 +++++
>  include/media/v4l2-dev.h                     |    6 +
>  include/media/v4l2-device.h                  |    2 +
>  include/media/v4l2-subdev.h                  |    7 +
>  16 files changed, 2440 insertions(+), 22 deletions(-)
>  create mode 100644 Documentation/media-framework.txt
>  create mode 100644 drivers/media/media-device.c
>  create mode 100644 drivers/media/media-devnode.c
>  create mode 100644 drivers/media/media-entity.c
>  create mode 100644 include/linux/media.h
>  create mode 100644 include/media/media-device.h
>  create mode 100644 include/media/media-devnode.h
>  create mode 100644 include/media/media-entity.h
> 

