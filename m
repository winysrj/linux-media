Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:51135 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756925Ab0GNN3L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Jul 2010 09:29:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [RFC/PATCH 00/10] Media controller (core and V4L2)
Date: Wed, 14 Jul 2010 15:30:09 +0200
Message-Id: <1279114219-27389-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

A bit less than one year after Hans' initial media controller proposal, I'm
happy to report that we've finally reached the point where an initial working
implementation can be sent for review. Before going any further, I'd like to
thank everybody who made this possible, including Hans for his initial proposal
and his advices throughout the 10 months of development, my Nokia colleagues
who have provided patches, feedback and nasty bug reports :-) (in alphabetical
order Antti, David, Sakari, Stan, Tuukka and Vimarsh), and all the developers
who participated in the LPC 2009 and Helsinki 2010 V4L2 summits where the media
controller was extensively discussed.

Without waiting any further, Ladies and Gentlemen, here are at last the media
controller patches, ready for review. The first 7 patches provide the media
controller core (including documentation !) and the last 3 add media controller
support to the V4L2 core.

I will send another patch set that further enhance the V4L2 API and provide the
OMAP3 ISP driver as the first example of the media controller usage. Those
patches are not meant to be reviewed yet (I still need to document the new
APIs), so please consider them as sample code only.

I wish you all a happy review, and please don't punch, kick or otherwise bite
too hard.

Laurent Pinchart (8):
  media: Media device node support
  media: Media device
  media: Entities, pads and links
  media: Entities, pads and links enumeration
  media: Links setup
  v4l: Add a media_device pointer to the v4l2_device structure
  v4l: Make video_device inherit from media_entity
  v4l: Make v4l2_subdev inherit from media_entity

Sakari Ailus (2):
  media: Entity graph traversal
  media: Reference count and power handling

 Documentation/media-framework.txt            |  479 ++++++++++++++++++++
 Documentation/video4linux/v4l2-framework.txt |   71 +++-
 drivers/media/Makefile                       |    8 +-
 drivers/media/media-device.c                 |  329 ++++++++++++++
 drivers/media/media-devnode.c                |  479 ++++++++++++++++++++
 drivers/media/media-entity.c                 |  618 ++++++++++++++++++++++++++
 drivers/media/video/v4l2-dev.c               |   35 ++-
 drivers/media/video/v4l2-device.c            |   39 ++-
 drivers/media/video/v4l2-subdev.c            |   27 ++-
 include/linux/media.h                        |   74 +++
 include/media/media-device.h                 |   75 +++
 include/media/media-devnode.h                |   97 ++++
 include/media/media-entity.h                 |  101 +++++
 include/media/v4l2-dev.h                     |    6 +
 include/media/v4l2-device.h                  |    2 +
 include/media/v4l2-subdev.h                  |    7 +
 16 files changed, 2427 insertions(+), 20 deletions(-)
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

