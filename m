Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:39597 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863Ab0IWNj1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Sep 2010 09:39:27 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o8NDdQWR009067
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 23 Sep 2010 09:39:27 -0400
Date: Thu, 23 Sep 2010 09:39:25 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com
Subject: [GIT PULL REQUEST] misc IR fixes and enhancements for 2.6.37
Message-ID: <20100923133925.GB14421@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

Please grab these IR fixes and enhancements. There's a patch that inches
us closer to being able to remove lirc_i2c entirely, courtesy of Aris
Rozanski, an added safety check in the lirc_dev unregister path which
prevents a possible oops, and David Härdeman's patch to split out imon
mouse events onto their own input device, which will facilitate his later
enhancements to the remote control device interface. Also bundled in are a
few other imon fixes and enhancements on top of David's patch, prompted by
a kernel.org bugzilla and some feedback on the lirc mailing list.

The following changes since commit 991403c594f666a2ed46297c592c60c3b9f4e1e2:

  V4L/DVB: cx231xx: Avoid an OOPS when card is unknown (card=0) (2010-09-11 11:58:01 -0300)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jarod/linux-2.6-lirc.git/ staging

Aristeu Rozanski (1):
      IR: add support to Asus TV-Box to ir-kbd-i2c driver

David Härdeman (1):
      imon: split mouse events to a separate input dev

Jarod Wilson (4):
      IR: export ir_keyup so imon driver can use it directly
      IR/imon: protect ictx's kc and last_keycode w/spinlock
      IR/imon: set up mce-only devices w/mce keytable
      IR/lirc_dev: check for valid irctl in unregister path

 drivers/media/IR/imon.c                   |  583 +++++++++++++++++------------
 drivers/media/IR/ir-keytable.c            |    3 +-
 drivers/media/IR/keymaps/Makefile         |    1 +
 drivers/media/IR/keymaps/rc-asus-tv-box.c |   75 ++++
 drivers/media/IR/lirc_dev.c               |    5 +
 drivers/media/video/ir-kbd-i2c.c          |   77 ++++
 include/media/ir-core.h                   |    1 +
 include/media/rc-map.h                    |    1 +
 8 files changed, 503 insertions(+), 243 deletions(-)
 create mode 100644 drivers/media/IR/keymaps/rc-asus-tv-box.c

-- 
Jarod Wilson
jarod@redhat.com

