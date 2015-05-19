Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:50810 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284AbbESWLp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2015 18:11:45 -0400
Subject: [PATCH 0/4] rc-core fixups
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Wed, 20 May 2015 00:03:07 +0200
Message-ID: <20150519220101.3467.16288.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The first two patches are fixups that should be uncontroversial.

The third patch is another take on a similar patch already submitted by Sean.

The fourth patch is another cleanup that should be applied before we look
at implementing scancodes in the set/get keycode ioctls.

---

David Härdeman (4):
      rc-core: fix remove uevent generation
      rc-core: use an IDA rather than a bitmap
      rc-core: remove the LIRC "protocol"
      lmedm04: NEC scancode cleanup


 drivers/media/rc/ir-lirc-codec.c       |    5 -
 drivers/media/rc/keymaps/rc-lirc.c     |    2 
 drivers/media/rc/keymaps/rc-lme2510.c  |  132 ++++++++++++++++----------------
 drivers/media/rc/rc-ir-raw.c           |    2 
 drivers/media/rc/rc-main.c             |   57 +++++++-------
 drivers/media/usb/dvb-usb-v2/lmedm04.c |   21 +++--
 include/media/rc-core.h                |    4 -
 include/media/rc-map.h                 |   38 ++++-----
 8 files changed, 129 insertions(+), 132 deletions(-)

--
David Härdeman
