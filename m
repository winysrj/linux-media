Return-path: <mchehab@gaivota>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3850 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468Ab1ACLtr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jan 2011 06:49:47 -0500
Received: from tschai.localnet (43.80-203-71.nextgentel.com [80.203.71.43])
	(authenticated bits=0)
	by smtp-vbr12.xs4all.nl (8.13.8/8.13.8) with ESMTP id p03BniMs039448
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 3 Jan 2011 12:49:45 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.38] BKL: .ioctl to .unlocked_ioctl conversions
Date: Mon, 3 Jan 2011 12:49:40 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101031249.40215.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Tested with the mxb (saa7146-based) driver.

Since nobody has cpia2 hardware I was unable to test that driver.

Both drivers are converted using core-assisted locking.

Regards,

	Hans

The following changes since commit 187134a5875df20356f4dca075db29f294115a47:
  David Henningsson (1):
        [media] DVB: IR support for TechnoTrend CT-3650

are available in the git repository at:

  ssh://linuxtv.org/git/hverkuil/media_tree.git bkl

Hans Verkuil (2):
      saa7146: Convert from .ioctl to .unlocked_ioctl
      cpia2: convert .ioctl to .unlocked_ioctl

 drivers/media/common/saa7146_core.c    |    2 +-
 drivers/media/common/saa7146_fops.c    |    8 +--
 drivers/media/common/saa7146_vbi.c     |    2 +-
 drivers/media/common/saa7146_video.c   |   20 +------
 drivers/media/video/cpia2/cpia2.h      |    2 +-
 drivers/media/video/cpia2/cpia2_core.c |   65 +++++---------------
 drivers/media/video/cpia2/cpia2_v4l.c  |  108 ++++++++++---------------------
 include/media/saa7146.h                |    2 +-
 8 files changed, 57 insertions(+), 152 deletions(-)

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
