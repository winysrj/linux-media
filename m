Return-path: <mchehab@gaivota>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4273 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042Ab0LRNMG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Dec 2010 08:12:06 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.37] em28xx: radio_fops should also use unlocked_ioctl
Date: Sat, 18 Dec 2010 14:11:52 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201012181411.53110.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Mauro,

This is an urgent one-liner fix for 2.6.37: em28xx was converted to core-assisted
locking, but the .ioctl for radio_fops wasn't replaced by .unlocked_ioctl.

Regards,

	Hans


The following changes since commit fcdbff339238c0e0a537f95372ef9782e0d18328:
  Mauro Carvalho Chehab (1):
        Merge branch 'v4l_for_linus_bkl_removal' into staging/for_v2.6.38

are available in the git repository at:

  ssh://linuxtv.org/git/hverkuil/media_tree.git bkl-trivial

Hans Verkuil (1):
      em28xx: radio_fops should also use unlocked_ioctl

 drivers/media/video/em28xx/em28xx-video.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
