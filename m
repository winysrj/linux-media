Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3912 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab2JAKc4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Oct 2012 06:32:56 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.7] ivtv v4l2-compliance fixes
Date: Mon, 1 Oct 2012 12:32:49 +0200
Cc: Andy Walls <awalls@md.metrocast.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201210011232.49748.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro, Andy,

This is a series of ivtv compliance fixes. All video nodes except for the PCM capture
node (obviously) and the YUV output node (a remaining issue with FIELD_ANY) now pass
the tests.

Regards,

	Hans

The following changes since commit 8928b6d1568eb9104cc9e2e6627d7086437b2fb3:

  [media] media: mx2_camera: use managed functions to clean up code (2012-09-27 15:56:47 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git ivtv

for you to fetch changes up to 91ee4e0011811752f389b925df370c897e96e4d7:

  ivtv: fix format enumeration: don't show invalid formats. (2012-10-01 12:22:06 +0200)

----------------------------------------------------------------
Hans Verkuil (8):
      sliced vbi: subdevs shouldn't clear the full v4l2_sliced_vbi_format struct.
      ivtv: DECODER_CMD v4l2-compliance fixes.
      ivtv: fix v4l2-compliance error: inconsistent std reporting.
      ivtv: fix v4l2-compliance errors for the radio device.
      ivtv: don't allow g/s_frequency for output device nodes.
      ivtv: fix incorrect service_set for the decoder VBI capture.
      ivtv: disable a bunch of ioctls that are invalid for the decoder VBI.
      ivtv: fix format enumeration: don't show invalid formats.

 drivers/media/i2c/cx25840/cx25840-vbi.c |    3 ++-
 drivers/media/i2c/saa7115.c             |    3 ++-
 drivers/media/i2c/saa7127.c             |    2 +-
 drivers/media/i2c/tvp5150.c             |    2 +-
 drivers/media/pci/cx18/cx18-av-vbi.c    |    4 +++-
 drivers/media/pci/cx18/cx18-ioctl.c     |    4 ----
 drivers/media/pci/ivtv/ivtv-driver.c    |    1 +
 drivers/media/pci/ivtv/ivtv-fileops.c   |    5 +++--
 drivers/media/pci/ivtv/ivtv-ioctl.c     |   92 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------------
 drivers/media/pci/ivtv/ivtv-streams.c   |   23 +++++++++++++++++++++-
 10 files changed, 94 insertions(+), 45 deletions(-)
