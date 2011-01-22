Return-path: <mchehab@pedra>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:4491 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab1AVJmh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Jan 2011 04:42:37 -0500
Received: from tschai.localnet (43.80-203-71.nextgentel.com [80.203.71.43])
	(authenticated bits=0)
	by smtp-vbr18.xs4all.nl (8.13.8/8.13.8) with ESMTP id p0M9gZTg031842
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 22 Jan 2011 10:42:36 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.39] Switch cpia2 and pwc to video_ioctl2
Date: Sat, 22 Jan 2011 10:42:35 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101221042.35713.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Tested with pwc, but we still have no hardware for cpia2 so that is untested.
But the changes are pretty straightforward.

Regards,

	Hans

The following changes since commit cf720fed25b8078ce0d6a10036dbf7a0baded679:
  Mauro Carvalho Chehab (1):
        [media] add support for Encore FM3

are available in the git repository at:

  ssh://linuxtv.org/git/hverkuil/media_tree.git ioctl2

Hans Verkuil (3):
      pwc: convert to core-assisted locking
      pwc: convert to video_ioctl2
      cpia2: convert to video_ioctl2

 drivers/media/video/cpia2/cpia2_v4l.c |  373 ++++--------
 drivers/media/video/pwc/pwc-if.c      |   38 +-
 drivers/media/video/pwc/pwc-v4l.c     | 1032 ++++++++++++++++-----------------
 drivers/media/video/pwc/pwc.h         |    3 +-
 4 files changed, 623 insertions(+), 823 deletions(-)
-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
