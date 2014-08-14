Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1775 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbaHNKGq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Aug 2014 06:06:46 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209])
	(authenticated bits=0)
	by smtp-vbr15.xs4all.nl (8.13.8/8.13.8) with ESMTP id s7EA6hfn070884
	for <linux-media@vger.kernel.org>; Thu, 14 Aug 2014 12:06:45 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [10.61.209.179] (173-38-208-169.cisco.com [173.38.208.169])
	by tschai.lan (Postfix) with ESMTPSA id 7827F2A2E57
	for <linux-media@vger.kernel.org>; Thu, 14 Aug 2014 12:06:39 +0200 (CEST)
Message-ID: <53EC8A32.8020104@xs4all.nl>
Date: Thu, 14 Aug 2014 12:06:42 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.18] cx23885: convert to the latest frameworks, including
 vb2.
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This pull request converts the cx23885 driver to the latest V4L2 core
frameworks, removing about 1000 lines in the process.

It now passes the v4l2-compliance tests and, frankly, feels much more
robust.

I have tested this with my HVR-1800 board with video (compressed and
uncompressed), vbi, dvb and alsa.

As usual, the vb2 conversion is a beast of a patch. But the vb2 conversion
affected video, vbi, dvb and alsa, so it's all over the place. And it is
all or nothing. See the commit log of that patch for some more information.

It also changed the risc code to simplify the code and to get rid of all
the timeouts that were copied-and-pasted from cx88. If anyone knows of a
reason for these timeouts, please let me know. I have tried to separate the
risc code changes from the vb2 changes, but that was impossible to get to
work with vb1.

Regards,

	Hans

The following changes since commit 0f3bf3dc1ca394a8385079a5653088672b65c5c4:

   [media] cx23885: fix UNSET/TUNER_ABSENT confusion (2014-08-01 15:30:59 -0300)

are available in the git repository at:

   git://linuxtv.org/hverkuil/media_tree.git cx23b

for you to fetch changes up to 295df1a7021a09ccaa3a478acbb4ed1e9fb4a023:

   cx23885: Add busy checks before changing formats (2014-08-14 11:43:36 +0200)

----------------------------------------------------------------
Hans Verkuil (21):
       vb2: fix wrong gfp flags
       cx23885: fix querycap
       cx23885: fix audio input handling
       cx23885: support v4l2_fh and g/s_priority
       cx23885: use core locking, switch to unlocked_ioctl.
       cx23885: convert to the control framework
       cx23885: convert 417 to the control framework
       cx23885: fix format colorspace compliance error
       cx23885: map invalid fields to a valid field.
       cx23885: drop radio-related dead code
       cx23885: drop type field from struct cx23885_fh
       cx23885: drop unused clip fields from struct cx23885_fh
       cx23885: fmt, width and height are global, not per-fh.
       cx23885: drop videobuf abuse in cx23885-alsa
       cx23885: use video_drvdata to get cx23885_dev pointer
       cx23885: convert to vb2
       cx23885: fix field handling
       cx23885: fix weird sizes.
       cx23885: remove FSF address as per checkpatch
       cx23885: remove btcx-risc dependency
       cx23885: Add busy checks before changing formats

  drivers/media/pci/cx23885/Kconfig          |    5 +-
  drivers/media/pci/cx23885/Makefile         |    1 -
  drivers/media/pci/cx23885/altera-ci.c      |    8 +-
  drivers/media/pci/cx23885/altera-ci.h      |    4 -
  drivers/media/pci/cx23885/cimax2.c         |    4 -
  drivers/media/pci/cx23885/cimax2.h         |    4 -
  drivers/media/pci/cx23885/cx23885-417.c    |  501 ++++++++++----------------------
  drivers/media/pci/cx23885/cx23885-alsa.c   |  109 +++++--
  drivers/media/pci/cx23885/cx23885-av.c     |    5 -
  drivers/media/pci/cx23885/cx23885-av.h     |    5 -
  drivers/media/pci/cx23885/cx23885-cards.c  |    6 -
  drivers/media/pci/cx23885/cx23885-core.c   |  362 ++++++++---------------
  drivers/media/pci/cx23885/cx23885-dvb.c    |  136 ++++++---
  drivers/media/pci/cx23885/cx23885-f300.c   |    4 -
  drivers/media/pci/cx23885/cx23885-i2c.c    |   12 -
  drivers/media/pci/cx23885/cx23885-input.c  |    5 -
  drivers/media/pci/cx23885/cx23885-input.h  |    5 -
  drivers/media/pci/cx23885/cx23885-ioctl.c  |   10 +-
  drivers/media/pci/cx23885/cx23885-ioctl.h  |    4 -
  drivers/media/pci/cx23885/cx23885-ir.c     |    5 -
  drivers/media/pci/cx23885/cx23885-ir.h     |    5 -
  drivers/media/pci/cx23885/cx23885-reg.h    |    4 -
  drivers/media/pci/cx23885/cx23885-vbi.c    |  282 +++++++++---------
  drivers/media/pci/cx23885/cx23885-video.c  | 1294 +++++++++++++++++++++-------------------------------------------------------------
  drivers/media/pci/cx23885/cx23885-video.h  |    5 -
  drivers/media/pci/cx23885/cx23885.h        |  127 +++-----
  drivers/media/pci/cx23885/cx23888-ir.c     |    5 -
  drivers/media/pci/cx23885/cx23888-ir.h     |    5 -
  drivers/media/pci/cx23885/netup-eeprom.c   |    4 -
  drivers/media/pci/cx23885/netup-eeprom.h   |    4 -
  drivers/media/pci/cx23885/netup-init.c     |    4 -
  drivers/media/pci/cx23885/netup-init.h     |    4 -
  drivers/media/v4l2-core/videobuf2-dma-sg.c |    2 +-
  33 files changed, 952 insertions(+), 1988 deletions(-)
