Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:42900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754562Ab1ACMEO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Jan 2011 07:04:14 -0500
Message-ID: <4D21BB35.9090401@redhat.com>
Date: Mon, 03 Jan 2011 10:04:05 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for v2.6.37-rc8] V4L/DVB regression fixes
References: <4D21B752.8070000@redhat.com>
In-Reply-To: <4D21B752.8070000@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 03-01-2011 09:47, Mauro Carvalho Chehab escreveu:
> Hi Linus,
> 
> There are two regressions affecting audio at ivtv driver. One of them is at the
> initial volume setting, and the other one at wm8775, and it is due to a new board
> addition on another driver that uses it. Both patches are trivial: one checks
> the volume range and the other just reverts the patch that broke wm8775+ivtv.
> 
> Could you please merge them before releasing 2.6.37?

Linus,

I added a one-line patch to the series, fixing a regression at em28xx radio, due
to the BKL conversion.

Please pull from:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

Thanks!
Mauro

--

The following changes since commit 387c31c7e5c9805b0aef8833d1731a5fe7bdea14:

  Linux 2.6.37-rc8 (2010-12-28 17:05:48 -0800)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

Andy Walls (1):
      [media] cx25840: Prevent device probe failure due to volume control ERANGE error

Hans Verkuil (1):
      [media] em28xx: radio_fops should also use unlocked_ioctl

Mauro Carvalho Chehab (1):
      [media] wm8775: Revert changeset fcb9757333 to avoid a regression

 drivers/media/video/cx25840/cx25840-core.c |   19 +++++-
 drivers/media/video/cx88/cx88-alsa.c       |   99 +++-----------------------
 drivers/media/video/cx88/cx88-cards.c      |    7 ++
 drivers/media/video/cx88/cx88-video.c      |   27 +-------
 drivers/media/video/cx88/cx88.h            |    6 +-
 drivers/media/video/em28xx/em28xx-video.c  |    2 +-
 drivers/media/video/wm8775.c               |  104 ++++++++++-----------------
 include/media/wm8775.h                     |    3 -
 8 files changed, 79 insertions(+), 188 deletions(-)

