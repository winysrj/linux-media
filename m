Return-path: <mchehab@pedra>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:3134 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab1AHM6F (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Jan 2011 07:58:05 -0500
Received: from tschai.localnet (43.80-203-71.nextgentel.com [80.203.71.43])
	(authenticated bits=0)
	by smtp-vbr18.xs4all.nl (8.13.8/8.13.8) with ESMTP id p08Cw3Zc066848
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 8 Jan 2011 13:58:03 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.38] Fix incorrect error code if VIDIOC_DBG_G/S_REGISTER are unsupported
Date: Sat, 8 Jan 2011 13:58:02 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101081358.02939.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

A small and trivial fix, but it fixes a V4L2 API compliance issue.

Regards,

	Hans

The following changes since commit aeb13b434d0953050306435cd3134d65547dbcf4:
  Mauro Carvalho Chehab (1):
        cx25821: Fix compilation breakage due to BKL dependency

are available in the git repository at:

  ssh://linuxtv.org/git/hverkuil/media_tree.git dbgfix

Hans Verkuil (1):
      v4l2-ioctl: fix incorrect error code if VIDIOC_DBG_G/S_REGISTER are unsupported

 drivers/media/video/v4l2-ioctl.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
