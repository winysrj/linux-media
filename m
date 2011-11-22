Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3546 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349Ab1KVKFf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Nov 2011 05:05:35 -0500
Received: from alastor.dyndns.org (215.80-203-102.nextgentel.com [80.203.102.215])
	(authenticated bits=0)
	by smtp-vbr5.xs4all.nl (8.13.8/8.13.8) with ESMTP id pAMA5XZV062751
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Tue, 22 Nov 2011 11:05:34 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from durdane.cisco.com (64-103-25-233.cisco.com [64.103.25.233])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 2D6EF11800C1
	for <linux-media@vger.kernel.org>; Tue, 22 Nov 2011 11:05:26 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/3] Add per-device-node capabilities
Date: Tue, 22 Nov 2011 11:05:19 +0100
Message-Id: <1321956322-25084-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This patch series adds support for per-device capabilities.

All comments from the previous RFC PATCH series have been incorporated and
the documentation has been updated.

As far as I am concerned it is ready to be merged for v3.3.

The git request-pull output is below:

The following changes since commit 6fd7dba026f17076ac4bd63a3590f993c1f5c2c6:

[media] get_dvb_firmware: add support for HVR-930C firmware (2011-11-21 10:38:39 -0200)

are available in the git repository at:
git://linuxtv.org/hverkuil/media_tree.git capsv2

Hans Verkuil (3):
	V4L2: Add per-device-node capabilities
	vivi: set device_caps.
	ivtv: setup per-device caps.

	Documentation/DocBook/media/v4l/compat.xml         |    9 ++++++
	Documentation/DocBook/media/v4l/v4l2.xml           |    9 +++++-
	.../DocBook/media/v4l/vidioc-querycap.xml          |   29 +++++++++++++++++--
	drivers/media/video/cx231xx/cx231xx-417.c          |    1 -
	drivers/media/video/ivtv/ivtv-driver.h             |    1 +
	drivers/media/video/ivtv/ivtv-ioctl.c              |    7 +++-
	drivers/media/video/ivtv/ivtv-streams.c            |   14 +++++++++
	drivers/media/video/pvrusb2/pvrusb2-v4l2.c         |    1 -
	drivers/media/video/v4l2-ioctl.c                   |    6 +++-
	drivers/media/video/vivi.c                         |    5 ++-
	include/linux/videodev2.h                          |   29 +++++++++++++------
11 files changed, 90 insertions(+), 21 deletions(-)


