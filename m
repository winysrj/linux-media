Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:1241 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab2GWLgS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jul 2012 07:36:18 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr16.xs4all.nl (8.13.8/8.13.8) with ESMTP id q6NBaGpn070880
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Mon, 23 Jul 2012 13:36:17 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.195])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 53B1546A0006
	for <linux-media@vger.kernel.org>; Mon, 23 Jul 2012 13:36:15 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.6] Add adv7604/ad9389b drivers
Date: Mon, 23 Jul 2012 13:36:15 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201207231336.15392.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all!

There haven't been any comments since either RFCv1 or RFCv2.

(http://www.spinics.net/lists/linux-media/msg48529.html and
http://www.spinics.net/lists/linux-media/msg50413.html)

So I'm making this pull request now.

The only changes since RFCv2 are some documentation fixes:

- Add a note that the SUBDEV_G/S_EDID ioctls are experimental
- Add the proper revision/experimental references.
- Update the spec version to 3.6.

Regards,

	Hans

The following changes since commit 931efdf58bd83af8d0578a6cc53421675daf6d41:

  Merge branch 'v4l_for_linus' into staging/for_v3.6 (2012-07-14 15:45:44 -0300)

are available in the git repository at:


  git://linuxtv.org/hverkuil/media_tree.git hdmi2

for you to fetch changes up to d3e17e09dfd48ce8a8f7c6d80ca777230b487855:

  ad9389b: driver for the Analog Devices AD9389B video encoder. (2012-07-23 13:34:01 +0200)

----------------------------------------------------------------
Hans Verkuil (7):
      v4l2 core: add the missing pieces to support DVI/HDMI/DisplayPort.
      V4L2 spec: document the new DV controls and ioctls.
      v4l2-subdev: add support for the new edid ioctls.
      v4l2-ctrls.c: add support for the new DV controls.
      v4l2-common: add CVT and GTF detection functions.
      adv7604: driver for the Analog Devices ADV7604 video decoder.
      ad9389b: driver for the Analog Devices AD9389B video encoder.

 Documentation/DocBook/media/v4l/compat.xml               |   21 +
 Documentation/DocBook/media/v4l/controls.xml             |  149 ++++
 Documentation/DocBook/media/v4l/v4l2.xml                 |   14 +-
 Documentation/DocBook/media/v4l/vidioc-subdev-g-edid.xml |  161 +++++
 drivers/media/video/Kconfig                              |   23 +
 drivers/media/video/Makefile                             |    2 +
 drivers/media/video/ad9389b.c                            | 1328 ++++++++++++++++++++++++++++++++++
 drivers/media/video/adv7604.c                            | 1959 ++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/video/v4l2-common.c                        |  358 +++++++++
 drivers/media/video/v4l2-ctrls.c                         |   39 +
 drivers/media/video/v4l2-ioctl.c                         |   13 +
 drivers/media/video/v4l2-subdev.c                        |    6 +
 include/linux/v4l2-subdev.h                              |   10 +
 include/linux/videodev2.h                                |   23 +
 include/media/ad9389b.h                                  |   49 ++
 include/media/adv7604.h                                  |  153 ++++
 include/media/v4l2-chip-ident.h                          |    6 +
 include/media/v4l2-common.h                              |   13 +
 include/media/v4l2-subdev.h                              |    2 +
 19 files changed, 4327 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-subdev-g-edid.xml
 create mode 100644 drivers/media/video/ad9389b.c
 create mode 100644 drivers/media/video/adv7604.c
 create mode 100644 include/media/ad9389b.h
 create mode 100644 include/media/adv7604.h
