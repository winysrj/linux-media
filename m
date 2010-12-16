Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:3415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757319Ab0LPTDD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Dec 2010 14:03:03 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oBGJ33W3030396
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 16 Dec 2010 14:03:03 -0500
Date: Thu, 16 Dec 2010 14:03:02 -0500
From: Jarod Wilson <jarod@redhat.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org
Subject: [GIT PULL] IR fixups for 2.6.37
Message-ID: <20101216190302.GA25148@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hey Mauro,

As previously discussed, here's a handful of IR patches I'd like to see
make it into 2.6.37 still, as they fix a number of issues with the
mceusb, streamzap, nuvoton and lirc_dev drivers.

The last three mceusb patches are not yet in the v4l/dvb tree, but I've
just posted them.

The following changes since commit b0c3844d8af6b9f3f18f31e1b0502fbefa2166be:

  Linux 2.6.37-rc6 (2010-12-15 17:24:48 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jarod/linux-2.6-ir.git for-2.6.37

Dan Carpenter (2):
      [media] lirc_dev: stray unlock in lirc_dev_fop_poll()
      [media] lirc_dev: fixes in lirc_dev_fop_read()

Jarod Wilson (10):
      [media] mceusb: add support for Conexant Hybrid TV RDU253S
      [media] nuvoton-cir: improve buffer parsing responsiveness
      [media] mceusb: fix up reporting of trailing space
      [media] mceusb: buffer parsing fixups for 1st-gen device
      [media] IR: add tv power scancode to rc6 mce keymap
      [media] mceusb: fix keybouce issue after parser simplification
      [media] streamzap: merge timeout space with trailing space
      mceusb: add another Fintek device ID
      mceusb: fix inverted mask inversion logic
      mceusb: set a default rx timeout

Paul Bender (1):
      rc: fix sysfs entry for mceusb and streamzap

 drivers/media/IR/keymaps/rc-rc6-mce.c |   21 ++--
 drivers/media/IR/lirc_dev.c           |   29 +++---
 drivers/media/IR/mceusb.c             |  174 ++++++++++++++++++++------------
 drivers/media/IR/nuvoton-cir.c        |   10 ++-
 drivers/media/IR/streamzap.c          |   21 +++--
 5 files changed, 156 insertions(+), 99 deletions(-)

-- 
Jarod Wilson
jarod@redhat.com

