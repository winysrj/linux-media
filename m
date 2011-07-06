Return-path: <mchehab@localhost>
Received: from mx1.redhat.com ([209.132.183.28]:26385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755485Ab1GFSEz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Jul 2011 14:04:55 -0400
Date: Wed, 6 Jul 2011 15:04:04 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH RFCv3 00/17] Error code fixes and return -ENOTTY for
 no-ioctl
Message-ID: <20110706150404.3ac4ed6e@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

This patch series contain some fixes on how error codes are handled
at the media API's. It consists on two parts. 

The first part have the DocBook changes:
- Create a generic errno xml file, used by all media API's
  (V4L, MC, LIRC and DVB);
- Move the generic errorcodes to the new file;
- Removes code duplication/inconsistency along the several
  API files;
- Removes two bogus undefined errorcodes: EINTERNAL/ENOSIGNAL
  from the ioctl's.

The second part have the code changes:
- Some fixes on a few drivers that use EFAULT on a wrong
  way, and not compliant with the DVB API;
- The usage of ENOTTY meaning that no ioctl is implemented.

TODO:
- Some DVB open/close API description are mentioning the
  non-existent EINTERNAL error code;
- firedtv driver needs to be fixed with respect to the usage
  of -EFAULT (Stefan c/c).
- The DVB driver uses a couple different error codes to mean that
  an ioctl is not implemented: ENOSYS and EOPNOTSUPP. The last
  one is used on most places. It would be great to standardize
  this error code as well, but further study is required.
- There are still several error codes not present at gen-errors.xml.
  A match between what's currently used at the drivers and the
  API is needed. Probably, both code and DocBook needs to be
  changed, as, on several cases, different drivers return different
  error codes for the same error.

Mauro Carvalho Chehab (17):
  [media] DocBook: Add a chapter to describe media errors
  [media] DocBook: Use the generic ioctl error codes for all V4L
    ioctl's
  [media] DocBook: Use the generic error code page also for MC API
  [media] DocBook/media-ioc-setup-link.xml: Remove EBUSY
  [media] DocBook: Remove V4L generic error description for ioctl()
  [media] DocBook: Add an error code session for LIRC interface
  [media] DocBook: Add return error codes to LIRC ioctl session
  [media] siano: bad parameter is -EINVAL and not -EFAULT
  [media] nxt6000: i2c bus error should return -EIO
  [media] DVB: Point to the generic error chapter
  [media] DocBook/audio.xml: Remove generic errors
  [media] DocBook/demux.xml: Remove generic errors
  [media] dvb-bt8xx: Don't return -EFAULT when a device is not found
  [media] DocBook/dvb: Use generic descriptions for the frontend API
  [media] DocBook/dvb: Use generic descriptions for the video API
  [media] v4l2 core: return -ENOTTY if an ioctl doesn't exist
  [media] return -ENOTTY for unsupported ioctl's at legacy drivers

 Documentation/DocBook/.gitignore                   |    2 +
 Documentation/DocBook/media/Makefile               |   42 ++-
 Documentation/DocBook/media/dvb/audio.xml          |  372 +--------------
 Documentation/DocBook/media/dvb/ca.xml             |    6 +-
 Documentation/DocBook/media/dvb/demux.xml          |  121 +-----
 Documentation/DocBook/media/dvb/dvbproperty.xml    |   23 +-
 Documentation/DocBook/media/dvb/frontend.xml       |  487 +-------------------
 Documentation/DocBook/media/dvb/video.xml          |  418 +----------------
 Documentation/DocBook/media/v4l/func-ioctl.xml     |   72 +---
 Documentation/DocBook/media/v4l/gen-errors.xml     |   77 +++
 .../DocBook/media/v4l/lirc_device_interface.xml    |    4 +-
 .../DocBook/media/v4l/media-func-ioctl.xml         |   47 +--
 .../DocBook/media/v4l/media-ioc-device-info.xml    |    3 +-
 .../DocBook/media/v4l/media-ioc-setup-link.xml     |    9 -
 Documentation/DocBook/media/v4l/v4l2.xml           |    2 +
 Documentation/DocBook/media/v4l/vidioc-cropcap.xml |   13 +-
 .../DocBook/media/v4l/vidioc-dbg-g-chip-ident.xml  |   11 +-
 .../DocBook/media/v4l/vidioc-dbg-g-register.xml    |   17 -
 Documentation/DocBook/media/v4l/vidioc-dqevent.xml |   10 +-
 .../DocBook/media/v4l/vidioc-encoder-cmd.xml       |   11 +-
 .../media/v4l/vidioc-enum-frameintervals.xml       |   11 -
 .../DocBook/media/v4l/vidioc-enum-framesizes.xml   |   11 -
 .../DocBook/media/v4l/vidioc-enumaudio.xml         |   12 +-
 .../DocBook/media/v4l/vidioc-enumaudioout.xml      |   12 +-
 Documentation/DocBook/media/v4l/vidioc-g-audio.xml |   18 +-
 .../DocBook/media/v4l/vidioc-g-audioout.xml        |   18 +-
 Documentation/DocBook/media/v4l/vidioc-g-crop.xml  |   17 -
 .../DocBook/media/v4l/vidioc-g-dv-preset.xml       |   12 +-
 .../DocBook/media/v4l/vidioc-g-dv-timings.xml      |   11 +-
 .../DocBook/media/v4l/vidioc-g-enc-index.xml       |   17 -
 Documentation/DocBook/media/v4l/vidioc-g-fbuf.xml  |   19 +-
 Documentation/DocBook/media/v4l/vidioc-g-fmt.xml   |   20 +-
 Documentation/DocBook/media/v4l/vidioc-g-input.xml |   19 +-
 .../DocBook/media/v4l/vidioc-g-jpegcomp.xml        |   17 -
 .../DocBook/media/v4l/vidioc-g-output.xml          |   18 +-
 Documentation/DocBook/media/v4l/vidioc-g-parm.xml  |   17 -
 .../DocBook/media/v4l/vidioc-g-priority.xml        |    3 +-
 .../DocBook/media/v4l/vidioc-g-sliced-vbi-cap.xml  |   11 +-
 Documentation/DocBook/media/v4l/vidioc-g-std.xml   |    9 +-
 .../DocBook/media/v4l/vidioc-log-status.xml        |   17 -
 Documentation/DocBook/media/v4l/vidioc-overlay.xml |   11 +-
 Documentation/DocBook/media/v4l/vidioc-qbuf.xml    |   17 -
 .../DocBook/media/v4l/vidioc-query-dv-preset.xml   |   22 -
 .../DocBook/media/v4l/vidioc-querycap.xml          |   19 -
 .../DocBook/media/v4l/vidioc-querystd.xml          |   23 -
 Documentation/DocBook/media/v4l/vidioc-reqbufs.xml |   16 -
 .../DocBook/media/v4l/vidioc-streamon.xml          |   14 +-
 .../DocBook/media/v4l/vidioc-subdev-g-fmt.xml      |    3 +
 .../DocBook/media/v4l/vidioc-subscribe-event.xml   |   11 +-
 Documentation/DocBook/media_api.tmpl               |    9 +-
 drivers/media/dvb/bt8xx/dvb-bt8xx.c                |    4 +-
 drivers/media/dvb/frontends/nxt6000.c              |    2 +-
 drivers/media/dvb/siano/smscoreapi.c               |    2 +-
 drivers/media/video/et61x251/et61x251_core.c       |   10 +-
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c         |    7 +-
 drivers/media/video/sn9c102/sn9c102_core.c         |   10 +-
 drivers/media/video/uvc/uvc_v4l2.c                 |    2 +-
 drivers/media/video/v4l2-ioctl.c                   |    4 +-
 58 files changed, 267 insertions(+), 1955 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/gen-errors.xml

