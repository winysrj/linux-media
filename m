Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:49013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966Ab1AZQxc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jan 2011 11:53:32 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0QGrW94016338
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 26 Jan 2011 11:53:32 -0500
Date: Wed, 26 Jan 2011 11:53:31 -0500
From: Jarod Wilson <jarod@redhat.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org
Subject: [GIT PULL] More IR fixes for 2.6.38
Message-ID: <20110126165331.GA18067@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Mauro,

Please pull these additional IR driver fixes against Linus' tree in for
2.6.38 merge. Without these, mceusb is still broken (keybounce issues),
the HD-PVR tx won't work, and ir-kbd-i2c behaves badly with both the
HD-PVR and the HVR-1950.

Thanks much!

The following changes since commit 6fb1b304255efc5c4c93874ac8c066272e257e28:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input (2011-01-26 16:31:44 +1000)

are available in the git repository at:

  git://linuxtv.org/jarod/linux-2.6-ir.git for-2.6.38

Jarod Wilson (7):
      rc/mce: add mappings for missing keys
      hdpvr: fix up i2c device registration
      lirc_zilog: z8 on usb doesn't like back-to-back i2c_master_send
      ir-kbd-i2c: improve remote behavior with z8 behind usb
      rc/ir-lirc-codec: add back debug spew
      rc: use time unit conversion macros correctly
      mceusb: really fix remaining keybounce issues

 drivers/media/rc/ir-lirc-codec.c               |    6 +++-
 drivers/media/rc/keymaps/rc-rc6-mce.c          |    6 ++++
 drivers/media/rc/mceusb.c                      |    9 ++++--
 drivers/media/rc/nuvoton-cir.c                 |    6 ++--
 drivers/media/rc/streamzap.c                   |   12 ++++----
 drivers/media/video/hdpvr/hdpvr-core.c         |   24 +++++++++++++++---
 drivers/media/video/hdpvr/hdpvr-i2c.c          |   30 ++++++++++++++--------
 drivers/media/video/hdpvr/hdpvr.h              |    3 +-
 drivers/media/video/ir-kbd-i2c.c               |   13 +++++++++
 drivers/media/video/pvrusb2/pvrusb2-i2c-core.c |    1 -
 drivers/staging/lirc/lirc_zilog.c              |   32 +++++++++++++++++++----
 11 files changed, 106 insertions(+), 36 deletions(-)

-- 
Jarod Wilson
jarod@redhat.com

