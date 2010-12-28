Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:41675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535Ab0L1K1T (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Dec 2010 05:27:19 -0500
Message-ID: <4D19BB7D.2050304@redhat.com>
Date: Tue, 28 Dec 2010 08:27:09 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for 2.6.37-rc7] V4L fix
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Linus,

Please pull from:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

It is a regression fix for soc_camera driver.

Thanks!
Mauro

-

The following changes since commit 501aaa110a4269c99eff9736a81b5f93bb8b59be:

  [media] mceusb: set a default rx timeout (2010-12-20 14:11:18 -0200)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

Guennadi Liakhovetski (1):
      [media] v4l: soc-camera: fix multiple simultaneous user case

 drivers/media/video/soc_camera.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

