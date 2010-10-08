Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:38265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759776Ab0JHVoI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Oct 2010 17:44:08 -0400
Received: from int-mx08.intmail.prod.int.phx2.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o98Li8MT020737
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 8 Oct 2010 17:44:08 -0400
Date: Fri, 8 Oct 2010 17:44:07 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com
Subject: [GIT PULL REQUEST] IR patches for 2.6.37-rc1
Message-ID: <20101008214407.GI5165@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hey Mauro,

I've queued up some lirc fixes and a couple of patches that add a new
ir-core driver for the Nuvoton w836x7hg Super I/O integrated CIR
functionality. All but the Kconfig re-sorting patch have been posted to
linux-media for review, but I'm hoping they can all get merged in time for
the 2.6.37-rc1 window, and any additional review feedback can be taken
care of with follow-up patches.

The following changes since commit b9a1211dff08aa73fc26db66980ec0710a6c7134:

  V4L/DVB: Staging: cx25821: fix braces and space coding style issues (2010-10-07 15:37:27 -0300)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jarod/linux-2.6-lirc.git staging

Jarod Wilson (5):
      IR: add driver for Nuvoton w836x7hg integrated CIR
      nuvoton-cir: add proper rx fifo overrun handling
      IR/Kconfig: sort hardware entries alphabetically
      IR/lirc: further ioctl portability fixups
      staging/lirc: ioctl portability fixups

 drivers/media/IR/Kconfig             |   27 +-
 drivers/media/IR/Makefile            |    1 +
 drivers/media/IR/ir-lirc-codec.c     |   10 +-
 drivers/media/IR/lirc_dev.c          |   14 +-
 drivers/media/IR/nuvoton-cir.c       | 1237 ++++++++++++++++++++++++++++++++++
 drivers/media/IR/nuvoton-cir.h       |  408 +++++++++++
 drivers/staging/lirc/lirc_it87.c     |   17 +-
 drivers/staging/lirc/lirc_ite8709.c  |    6 +-
 drivers/staging/lirc/lirc_parallel.c |   32 +-
 drivers/staging/lirc/lirc_serial.c   |   21 +-
 drivers/staging/lirc/lirc_sir.c      |   21 +-
 include/media/lirc_dev.h             |    4 +-
 12 files changed, 1727 insertions(+), 71 deletions(-)
 create mode 100644 drivers/media/IR/nuvoton-cir.c
 create mode 100644 drivers/media/IR/nuvoton-cir.h

-- 
Jarod Wilson
jarod@redhat.com

