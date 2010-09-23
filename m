Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:42701 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab0IWLfN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Sep 2010 07:35:13 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [RFC/PATCH v5 00/12] Media controller (core and V4L2)
Date: Thu, 23 Sep 2010 13:34:44 +0200
Message-Id: <1285241696-16826-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi everybody,

Fifth version of the media controller core and V4L2 patches. All comments so
far have hopefully been incorporated.

Compared to the previous version, the main difference is the userspace API
documentation that has been converted to DocBook. The patches have also been
rebased on top of 2.6.36-rc4, and a new entity locking and pipeline management
patch has been added.

Laurent Pinchart (10):
  media: Media device node support
  media: Media device
  media: Entities, pads and links
  media: Media device information query
  media: Entities, pads and links enumeration
  media: Links setup
  media: Entity locking and pipeline management
  v4l: Add a media_device pointer to the v4l2_device structure
  v4l: Make video_device inherit from media_entity
  v4l: Make v4l2_subdev inherit from media_entity

Sakari Ailus (2):
  media: Entity graph traversal
  media: Reference count and power handling

 Documentation/DocBook/media-entities.tmpl          |   24 +
 Documentation/DocBook/media.tmpl                   |    3 +
 Documentation/DocBook/v4l/media-controller.xml     |   60 ++
 Documentation/DocBook/v4l/media-func-close.xml     |   59 ++
 Documentation/DocBook/v4l/media-func-ioctl.xml     |  116 ++++
 Documentation/DocBook/v4l/media-func-open.xml      |   94 +++
 .../DocBook/v4l/media-ioc-device-info.xml          |  133 ++++
 .../DocBook/v4l/media-ioc-enum-entities.xml        |  287 +++++++++
 Documentation/DocBook/v4l/media-ioc-enum-links.xml |  202 ++++++
 Documentation/DocBook/v4l/media-ioc-setup-link.xml |   90 +++
 Documentation/media-framework.txt                  |  380 +++++++++++
 Documentation/video4linux/v4l2-framework.txt       |   72 ++-
 drivers/media/Makefile                             |    8 +-
 drivers/media/media-device.c                       |  377 +++++++++++
 drivers/media/media-devnode.c                      |  310 +++++++++
 drivers/media/media-entity.c                       |  678 ++++++++++++++++++++
 drivers/media/video/v4l2-dev.c                     |   35 +-
 drivers/media/video/v4l2-device.c                  |   43 +-
 drivers/media/video/v4l2-subdev.c                  |   30 +-
 include/linux/Kbuild                               |    1 +
 include/linux/media.h                              |  105 +++
 include/media/media-device.h                       |   90 +++
 include/media/media-devnode.h                      |   78 +++
 include/media/media-entity.h                       |  122 ++++
 include/media/v4l2-dev.h                           |    6 +
 include/media/v4l2-device.h                        |    2 +
 include/media/v4l2-subdev.h                        |    7 +
 27 files changed, 3391 insertions(+), 21 deletions(-)
 create mode 100644 Documentation/DocBook/v4l/media-controller.xml
 create mode 100644 Documentation/DocBook/v4l/media-func-close.xml
 create mode 100644 Documentation/DocBook/v4l/media-func-ioctl.xml
 create mode 100644 Documentation/DocBook/v4l/media-func-open.xml
 create mode 100644 Documentation/DocBook/v4l/media-ioc-device-info.xml
 create mode 100644 Documentation/DocBook/v4l/media-ioc-enum-entities.xml
 create mode 100644 Documentation/DocBook/v4l/media-ioc-enum-links.xml
 create mode 100644 Documentation/DocBook/v4l/media-ioc-setup-link.xml
 create mode 100644 Documentation/media-framework.txt
 create mode 100644 drivers/media/media-device.c
 create mode 100644 drivers/media/media-devnode.c
 create mode 100644 drivers/media/media-entity.c
 create mode 100644 include/linux/media.h
 create mode 100644 include/media/media-device.h
 create mode 100644 include/media/media-devnode.h
 create mode 100644 include/media/media-entity.h

-- 
Regards,

Laurent Pinchart

