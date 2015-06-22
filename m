Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34543 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbbFVWeK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2015 18:34:10 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: bp@suse.de, mchehab@osg.samsung.com, dledford@redhat.com
Cc: mingo@kernel.org, fengguang.wu@intel.com,
	linux-media@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH 0/2] x86/mm/pat: don't use WARN for nopat requirement
Date: Mon, 22 Jun 2015 15:31:56 -0700
Message-Id: <1435012318-381-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

Mauro, Doug,

The 0-day robot found using WARN() on built-in kernels confusing. Upon
further thought pr_warn() is better and will likely also not confuse
humans too.

Boris, provided maintainers Ack, please consider these patches.

These depend on pat_enabled() exported symbol which went in through
the x86 tree, so I suppose this also needs to go through there. This
is an example issue of cross-tree collateral evolution follow ups,
one reason why I punted the a RFD and proposal for a linux-oven [0].
In that regard I suppose follow ups like these would need to go through
that tree as well.

[0] http://lkml.kernel.org/r/20150619231255.GC7487@garbanzo.do-not-panic.com

Luis R. Rodriguez (2):
  x86/mm/pat, drivers/infiniband/ipath: replace WARN() with pr_warn()
  x86/mm/pat, drivers/media/ivtv: replace WARN() with pr_warn()

 drivers/infiniband/hw/ipath/ipath_driver.c | 6 ++++--
 drivers/media/pci/ivtv/ivtvfb.c            | 6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

-- 
2.3.2.209.gd67f9d5.dirty

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
