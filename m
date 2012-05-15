Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2354 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757095Ab2EOLUX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 May 2012 07:20:23 -0400
Received: from alastor.dyndns.org (189.80-203-102.nextgentel.com [80.203.102.189] (may be forged))
	(authenticated bits=0)
	by smtp-vbr15.xs4all.nl (8.13.8/8.13.8) with ESMTP id q4FBKLr4040371
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Tue, 15 May 2012 13:20:22 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from durdane.localnet (64-103-25-233.cisco.com [64.103.25.233])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id EF3011C320001
	for <linux-media@vger.kernel.org>; Tue, 15 May 2012 13:20:19 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.5] Rebased version of the new Timings API
Date: Tue, 15 May 2012 13:20:19 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201205151320.19569.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Rebased as there were some conflicts after all the recent changes.

Also tested DocBook, works fine for me.

Note that I get this:

Error: no ID for constraint linkend: v4l2-auto-focus-area.

Something missing in those focus control patches.

Regards,

	Hans

The following changes since commit 152a3a7320d1582009db85d8be365ce430d079af:

  [media] v4l2-dev: rename two functions (2012-05-14 15:06:50 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git timingsv6

for you to fetch changes up to dc3ea70ea7d9b710b1e8bab83e92165806f91a42:

  V4L2: Mark the DV Preset API as deprecated. (2012-05-15 13:09:56 +0200)

----------------------------------------------------------------
Hans Verkuil (7):
      videodev2.h: add enum/query/cap dv_timings ioctls.
      V4L2 spec: document the new V4L2 DV timings ioctls.
      v4l2 framework: add support for the new dv_timings ioctls.
      v4l2-dv-timings.h: definitions for CEA-861 and VESA DMT timings.
      tvp7002: add support for the new dv timings API.
      Feature removal: remove invalid DV presets.
      V4L2: Mark the DV Preset API as deprecated.

 Documentation/DocBook/media/v4l/biblio.xml                  |   18 ++
 Documentation/DocBook/media/v4l/common.xml                  |   38 ++--
 Documentation/DocBook/media/v4l/compat.xml                  |   17 ++
 Documentation/DocBook/media/v4l/v4l2.xml                    |   15 +-
 Documentation/DocBook/media/v4l/vidioc-create-bufs.xml      |    6 +
 Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml   |  211 ++++++++++++++++++++++
 Documentation/DocBook/media/v4l/vidioc-enum-dv-presets.xml  |    4 +
 Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml  |  119 +++++++++++++
 Documentation/DocBook/media/v4l/vidioc-enuminput.xml        |    2 +-
 Documentation/DocBook/media/v4l/vidioc-enumoutput.xml       |    2 +-
 Documentation/DocBook/media/v4l/vidioc-g-dv-preset.xml      |    6 +
 Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml     |  130 ++++++++++++--
 Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml      |    6 +
 Documentation/DocBook/media/v4l/vidioc-query-dv-preset.xml  |    4 +
 Documentation/DocBook/media/v4l/vidioc-query-dv-timings.xml |  104 +++++++++++
 Documentation/feature-removal-schedule.txt                  |    9 +
 drivers/media/video/tvp7002.c                               |  102 +++++++++--
 drivers/media/video/v4l2-compat-ioctl32.c                   |    3 +
 drivers/media/video/v4l2-ioctl.c                            |  126 +++++++++----
 include/linux/Kbuild                                        |    1 +
 include/linux/v4l2-dv-timings.h                             |  816 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/videodev2.h                                   |  179 ++++++++++++++++---
 include/media/v4l2-ioctl.h                                  |    6 +
 include/media/v4l2-subdev.h                                 |    6 +
 24 files changed, 1825 insertions(+), 105 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-query-dv-timings.xml
 create mode 100644 include/linux/v4l2-dv-timings.h
