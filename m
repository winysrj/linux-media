Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4455 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbaJ0Kel (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Oct 2014 06:34:41 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr6.xs4all.nl (8.13.8/8.13.8) with ESMTP id s9RAYbKW019040
	for <linux-media@vger.kernel.org>; Mon, 27 Oct 2014 11:34:39 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from [10.61.194.228] (173-38-208-169.cisco.com [173.38.208.169])
	by tschai.lan (Postfix) with ESMTPSA id 7A7E62A0377
	for <linux-media@vger.kernel.org>; Mon, 27 Oct 2014 11:34:19 +0100 (CET)
Message-ID: <544E1FBC.7060305@xs4all.nl>
Date: Mon, 27 Oct 2014 11:34:36 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.19] Two patches
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This fixes one tricky v4l2-ctrls.c sparse warning and increases the number
of buffers in vb2.

Regards,

	Hans


The following changes since commit 1ef24960ab78554fe7e8e77d8fc86524fbd60d3c:

  Merge tag 'v3.18-rc1' into patchwork (2014-10-21 08:32:51 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.19c

for you to fetch changes up to 0c0b10999ca6d68dc224d1330dc2541c66db0351:

  v4l2-ctrls: fix sparse warning (2014-10-27 11:33:14 +0100)

----------------------------------------------------------------
Divneil Wadhawan (1):
      vb2: replace VIDEO_MAX_FRAME with VB2_MAX_FRAME

Hans Verkuil (1):
      v4l2-ctrls: fix sparse warning

 drivers/media/pci/saa7134/saa7134-ts.c       |  4 +--
 drivers/media/pci/saa7134/saa7134-vbi.c      |  4 +--
 drivers/media/pci/saa7134/saa7134-video.c    |  2 +-
 drivers/media/platform/mem2mem_testdev.c     |  2 +-
 drivers/media/platform/ti-vpe/vpe.c          |  2 +-
 drivers/media/platform/vivid/vivid-core.h    |  2 +-
 drivers/media/platform/vivid/vivid-ctrls.c   |  2 +-
 drivers/media/platform/vivid/vivid-vid-cap.c |  2 +-
 drivers/media/v4l2-core/v4l2-ctrls.c         | 87 +++++++++++++++++++++++++++++++++++++++--------------------------
 drivers/media/v4l2-core/videobuf2-core.c     |  8 +++---
 include/media/videobuf2-core.h               |  4 ++-
 11 files changed, 69 insertions(+), 50 deletions(-)
