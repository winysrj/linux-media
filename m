Return-path: <mchehab@gaivota>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:52203 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756989Ab0KSXmk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 18:42:40 -0500
Subject: [PATCH 00/10] rc-core: various cleanups
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: jarod@wilsonet.com, mchehab@infradead.org
Date: Sat, 20 Nov 2010 00:42:36 +0100
Message-ID: <20101119233959.3511.91287.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Here's a set of smaller patches which performs various cleanups, mostly to
the saa7134 and bttv driver. They are based on the media_tree.git repo
(2.6.38 branch) on top of Mauro's recent renaming patches.

---

David Härdeman (10):
      saa7134: remove unused module parameter
      saa7134: use full keycode for BeholdTV
      saa7134: some minor cleanups
      saa7134: merge saa7134_card_ir->timer and saa7134_card_ir->timer_end
      saa7134: protect the ir user count
      saa7134: make module parameters boolean
      bttv: rename struct card_ir to bttv_ir
      bttv: merge ir decoding timers
      mceusb: int to bool conversion
      rc-core: fix some leftovers from the renaming patches


 drivers/media/rc/ir-raw.c                   |    2 
 drivers/media/rc/keymaps/rc-behold.c        |   70 +++++++-------
 drivers/media/rc/mceusb.c                   |   62 +++++--------
 drivers/media/rc/rc-core-priv.h             |    6 +
 drivers/media/rc/rc-main.c                  |    2 
 drivers/media/video/bt8xx/bttv-input.c      |   31 +++---
 drivers/media/video/bt8xx/bttvp.h           |   32 ++----
 drivers/media/video/saa7134/saa7134-input.c |  133 +++++++++++----------------
 drivers/media/video/saa7134/saa7134.h       |    6 +
 include/media/rc-core.h                     |   12 +-
 10 files changed, 154 insertions(+), 202 deletions(-)

-- 
David Härdeman
