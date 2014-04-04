Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:40767 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847AbaDDWFx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Apr 2014 18:05:53 -0400
Subject: [PATCH 0/3] 3.15 fixes
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: james.hogan@imgtec.com, m.chehab@samsung.com
Date: Sat, 05 Apr 2014 00:05:50 +0200
Message-ID: <20140404220404.5068.3669.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following three patches are the quickfixes that we (Mauro, James, me)
seemed to agree to. I've updated the patches to apply cleanly without 
the preceeding patches from my previous patchbomb and I've hopefully fixed
the comments that James provided (I'll let him reply with separate Acked-by
lines if he agrees to each patch).

---

David Härdeman (3):
      rc-core: do not change 32bit NEC scancode format for now
      rc-core: split dev->s_filter
      rc-core: remove generic scancode filter


 drivers/media/rc/img-ir/img-ir-hw.c  |   15 +++++
 drivers/media/rc/img-ir/img-ir-nec.c |   27 +++++----
 drivers/media/rc/ir-nec-decoder.c    |    5 --
 drivers/media/rc/keymaps/rc-tivo.c   |   86 +++++++++++++++---------------
 drivers/media/rc/rc-main.c           |   98 ++++++++++++++++++++++------------
 include/media/rc-core.h              |    8 ++-
 6 files changed, 142 insertions(+), 97 deletions(-)

--
David Härdeman
