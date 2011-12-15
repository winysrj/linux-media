Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1103 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab1LOJme (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 04:42:34 -0500
Received: from alastor.dyndns.org (215.80-203-102.nextgentel.com [80.203.102.215])
	(authenticated bits=0)
	by smtp-vbr11.xs4all.nl (8.13.8/8.13.8) with ESMTP id pBF9gV0q049877
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Thu, 15 Dec 2011 10:42:32 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.cisco.com (64-103-25-233.cisco.com [64.103.25.233])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 53A5811C043D
	for <linux-media@vger.kernel.org>; Thu, 15 Dec 2011 10:42:29 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv3 PATCH 0/3] Add per-device-node capabilities
Date: Thu, 15 Dec 2011 10:42:25 +0100
Message-Id: <1323942148-13503-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This patch series adds support for per-device capabilities.

All comments from the previous RFC PATCH series:

http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/40688

have been incorporated and the documentation has been updated.

The only file changed since the previous series was vidioc-querycap.xml.

As far as I am concerned it is ready to be merged for v3.3.

The git request-pull output is below:

The following changes since commit bcc072756e4467dc30e502a311b1c3adec96a0e4:

  [media] STV0900: Query DVB frontend delivery capabilities (2011-12-12 15:04:34 -0200)

are available in the git repository at:
  git://linuxtv.org/hverkuil/media_tree.git capsv3

Hans Verkuil (3):
      V4L2: Add per-device-node capabilities
      vivi: set device_caps.
      ivtv: setup per-device caps.

 Documentation/DocBook/media/v4l/compat.xml         |    9 +++++
 Documentation/DocBook/media/v4l/v4l2.xml           |    9 ++++-
 .../DocBook/media/v4l/vidioc-querycap.xml          |   36 ++++++++++++++++++--
 drivers/media/video/cx231xx/cx231xx-417.c          |    1 -
 drivers/media/video/ivtv/ivtv-driver.h             |    1 +
 drivers/media/video/ivtv/ivtv-ioctl.c              |    7 +++-
 drivers/media/video/ivtv/ivtv-streams.c            |   14 ++++++++
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c         |    1 -
 drivers/media/video/v4l2-ioctl.c                   |    6 ++-
 drivers/media/video/vivi.c                         |    5 ++-
 include/linux/videodev2.h                          |   29 +++++++++++-----
 11 files changed, 97 insertions(+), 21 deletions(-)
