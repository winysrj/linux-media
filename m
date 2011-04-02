Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:48011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905Ab1DBKkX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 2 Apr 2011 06:40:23 -0400
Message-ID: <4D96FD11.40404@redhat.com>
Date: Sat, 02 Apr 2011 07:40:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for 2.6.39-rc2] media fixes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Linus,

Please pull from:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

For two small bug fixes.

Thanks!
Mauro.

The following changes since commit 0ce790e7d736cedc563e1fb4e998babf5a4dbc3d:

  Linux 2.6.39-rc1 (2011-03-29 12:09:47 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

Manjunatha Halli (1):
      [media] radio: wl128x: Update registration process with ST

Randy Dunlap (1):
      [media] staging: altera-jtag needs delay.h

 drivers/media/radio/wl128x/fmdrv_common.c  |   16 +++++++++++++---
 drivers/staging/altera-stapl/altera-jtag.c |    1 +
 2 files changed, 14 insertions(+), 3 deletions(-)

