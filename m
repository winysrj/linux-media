Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:28309 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab2ALPcJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jan 2012 10:32:09 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.3] Add decoder API to V4L2
Date: Thu, 12 Jan 2012 16:32:02 +0100
Cc: Andy Walls <awalls@md.metrocast.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201201121632.02440.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here is my pull request for the decoder API.

The code is the same as the RFCv3 patch series:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg40516.html

except for being rebased to the latest for_v3.3 branch.

There is no urgency, so if you prefer then this can also be applied to 3.4.

Regards,

	Hans

The following changes since commit 240ab508aa9fb7a294b0ecb563b19ead000b2463:

  [media] [PATCH] don't reset the delivery system on DTV_CLEAR (2012-01-10 23:44:07 -0200)

are available in the git repository at:
  git://linuxtv.org/hverkuil/media_tree.git decoder5

Hans Verkuil (8):
      v4l2: add VIDIOC_(TRY_)DECODER_CMD.
      v4l spec: document VIDIOC_(TRY_)DECODER_CMD.
      ivtv: implement new decoder command ioctls.
      v4l2-ctrls: add new controls for MPEG decoder devices.
      Document decoder controls.
      ivtv: implement new decoder controls.
      cx18/ddbridge: remove unused headers.
      ivtv: add IVTV_IOC_PASSTHROUGH_MODE.

 Documentation/DocBook/media/v4l/controls.xml       |   59 +++++
 Documentation/DocBook/media/v4l/v4l2.xml           |    1 +
 .../DocBook/media/v4l/vidioc-decoder-cmd.xml       |  256 ++++++++++++++++++++
 .../DocBook/media/v4l/vidioc-encoder-cmd.xml       |    9 +-
 drivers/media/dvb/ddbridge/ddbridge.h              |    2 -
 drivers/media/video/cx18/cx18-driver.h             |    2 -
 drivers/media/video/ivtv/ivtv-controls.c           |   62 +++++
 drivers/media/video/ivtv/ivtv-controls.h           |    2 +
 drivers/media/video/ivtv/ivtv-driver.c             |   37 +++-
 drivers/media/video/ivtv/ivtv-driver.h             |   12 +-
 drivers/media/video/ivtv/ivtv-fileops.c            |    2 +-
 drivers/media/video/ivtv/ivtv-ioctl.c              |  181 +++++++-------
 drivers/media/video/ivtv/ivtv-streams.c            |    9 +-
 drivers/media/video/v4l2-compat-ioctl32.c          |    2 +
 drivers/media/video/v4l2-ctrls.c                   |   23 ++
 drivers/media/video/v4l2-ioctl.c                   |   28 +++
 include/linux/ivtv.h                               |    6 +-
 include/linux/videodev2.h                          |   66 +++++
 include/media/v4l2-ioctl.h                         |    4 +
 19 files changed, 652 insertions(+), 111 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml
