Return-path: <mchehab@gaivota>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:3994 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056Ab0L0P3t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Dec 2010 10:29:49 -0500
Received: from durdane.localnet (marune.xs4all.nl [82.95.89.49])
	(authenticated bits=0)
	by smtp-vbr16.xs4all.nl (8.13.8/8.13.8) with ESMTP id oBRFTiHn070286
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 27 Dec 2010 16:29:48 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PATCHES FOR 2.6.38] rds.h and bt819.h fixes
Date: Mon, 27 Dec 2010 16:29:44 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201012271629.44259.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

The following changes since commit 0ccbb0642d57b7d8b044ecf6d6529b186591c1ce:
  Mauro Carvalho Chehab (1):
        feature_removal_schedule.txt: mark VIDIOC_*_OLD ioctls to die

are available in the git repository at:

  ssh://linuxtv.org/git/hverkuil/media_tree.git rds

Hans Verkuil (2):
      saa6588: rename rds.h to saa6588.h
      bt819: the ioctls in the header are internal to the kernel.

 Documentation/ioctl/ioctl-number.txt        |    2 --
 drivers/media/radio/si470x/radio-si470x.h   |    1 -
 drivers/media/video/bt8xx/bttv-driver.c     |   14 +++++++-------
 drivers/media/video/saa6588.c               |   14 +++++++-------
 drivers/media/video/saa7134/saa7134-video.c |   14 +++++++-------
 include/media/bt819.h                       |    5 ++++-
 include/media/{rds.h => saa6588.h}          |   18 ++++++++----------
 7 files changed, 33 insertions(+), 35 deletions(-)
 rename include/media/{rds.h => saa6588.h} (76%)

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
