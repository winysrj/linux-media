Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40385 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbbHVR2f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2015 13:28:35 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-doc@vger.kernel.org
Subject: [PATCH 00/39] Document the kABI for the media subsystem
Date: Sat, 22 Aug 2015 14:27:45 -0300
Message-Id: <cover.1440264165.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Despite the media system being there for years and several
files have already doc-nano tags, we never actually added a
Media drivers section at device-drivers.

Add one and add an initial set of documentation there for the
kABI. The kAPI is already documented on a separate DocBook.

Jon,

As most of the changes here are inside the media drivers, I
prefer to merge this series via my tree, if this is ok for
you.

Thanks!
Mauro


Mauro Carvalho Chehab (39):
  [media] DocBook: fix an unbalanced <para> tag
  [media] DocBook/device-drivers: Add drivers/media core stuff
  [media] Docbook: Fix description of struct media_devnode
  [media] DocBook/media/Makefile: Avoid make htmldocs to fail
  [media] Docbook: Fix  comments at v4l2-async.h
  [media] Docbook: Fix s_rx_carrier_range parameter description
  [media] Docbook: fix comments at v4l2-flash-led-class.h
  [media] Docbook: Fix comments at v4l2-mem2mem.h
  [media] v4l2-subdev: convert documentation to the right format
  [media] v4l2-subdev: Add description for core ioctl handlers
  [media] v4l2-subdev: Add description for radio ioctl handlers
  [media] v4l2-subdev: reorder the v4l2_subdev_video_ops comments
  [media] v4l2_subdev: describe ioctl parms at v4l2_subdev_video_ops
  [media] v4l2_subdev: describe ioctl parms at the remaining structs
  [media] v4l2-subdev: add remaining argument descriptions
  [media] DocBook: add dvb_ca_en50221.h to documentation
  [media] DocBook: add dvb_frontend.h to documentation
  [media] DocBook: add dvb_math.h to documentation
  [media] DocBook: add dvb_ringbuffer.h to documentation
  [media] v4l2-ctrls.h: add to device-drivers DocBook
  [media] v4l2-ctls: don't document v4l2_ctrl_fill()
  [media] v4l2-ctrls.h: Document a few missing arguments
  [media] v4l2-event.h: fix comments and add to DocBook
  [media] v4l-dv-timings.h: Add to device-drivers DocBook
  [media] videobuf2-core: Add it to device-drivers DocBook
  [media] videobuf2-memops.h: add to device-drivers DocBook
  [media] v4l2-mediabus: Add to DocBook
  [media] DocBook: Better organize media devices
  [media] dvb_frontend: document dvb_frontend_tune_settings
  [media] add documentation for struct dvb_tuner_info
  [media] dvb_frontend.h: get rid of dvbfe_modcod
  [media] Docbook: Document struct analog_parameters
  fixup: dvb_tuner_info
  [media] dvb_frontend.h: Document struct dvb_tuner_ops
  [media] dvb_frontend.h: document struct analog_demod_ops
  [media] dvb: Use DVBFE_ALGO_HW where applicable
  [media] dvb-frontend.h: document struct dvb_frontend_ops
  [media] dvb-frontend.h: document struct dtv_frontend_properties
  [media] dvb_frontend.h: document the struct dvb_frontend

 Documentation/DocBook/device-drivers.tmpl |   33 +
 Documentation/DocBook/media/Makefile      |    3 +-
 Documentation/DocBook/media/dvb/intro.xml |    2 +-
 drivers/media/dvb-core/dvb_ca_en50221.c   |  167 ++---
 drivers/media/dvb-core/dvb_ca_en50221.h   |   34 +-
 drivers/media/dvb-core/dvb_frontend.c     |    1 -
 drivers/media/dvb-core/dvb_frontend.h     |  406 +++++++++---
 drivers/media/dvb-core/dvb_math.h         |   25 +-
 drivers/media/dvb-core/dvb_ringbuffer.h   |  133 ++--
 drivers/media/dvb-frontends/cx24123.c     |    2 +-
 drivers/media/dvb-frontends/s921.c        |    2 +-
 include/media/media-devnode.h             |    4 +
 include/media/rc-core.h                   |    2 +-
 include/media/v4l2-async.h                |    8 +-
 include/media/v4l2-ctrls.h                | 1018 ++++++++++++++++-------------
 include/media/v4l2-dv-timings.h           |  135 ++--
 include/media/v4l2-event.h                |   47 +-
 include/media/v4l2-flash-led-class.h      |   12 +-
 include/media/v4l2-mediabus.h             |    4 +-
 include/media/v4l2-mem2mem.h              |   20 +
 include/media/v4l2-subdev.h               |  372 +++++++----
 include/media/videobuf2-core.h            |   10 +-
 include/media/videobuf2-memops.h          |    3 +-
 23 files changed, 1508 insertions(+), 935 deletions(-)

-- 
2.4.3

