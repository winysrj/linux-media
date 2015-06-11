Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f65.google.com ([209.85.192.65]:33649 "EHLO
	mail-qg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbbFKUWR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2015 16:22:17 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: bp@suse.de
Cc: mchehab@osg.samsung.com, tomi.valkeinen@ti.com,
	bhelgaas@google.com, luto@amacapital.net,
	linux-media@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v7 0/3] linux: address broken PAT drivers
Date: Thu, 11 Jun 2015 13:19:51 -0700
Message-Id: <1434053994-2196-1-git-send-email-mcgrof@do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

Boris,

the following patches make use of the newly exported pat_enabled()
which went in through your tree. All driver and respective subsystem
maintainers have Acked these patches and are OK for them to go in through
your tree. Please let me know if there any issues or questions.

This v7 series goes with the return value fixed to be negative, this
was spotted by Mauro on the ivtv driver, I also spotted this then on
the ipath driver so fixed that there too in this series. The v7 also
goes with a small change on language on the Kconfig for the ivtv as
requested by Mauro. The v7 also goes with a small change on language
on the Kconfig for the ivtv as requested by Mauro.

Luis R. Rodriguez (3):
  ivtv: use arch_phys_wc_add() and require PAT disabled
  IB/ipath: add counting for MTRR
  IB/ipath: use arch_phys_wc_add() and require PAT disabled

 drivers/infiniband/hw/ipath/Kconfig           |  3 ++
 drivers/infiniband/hw/ipath/ipath_driver.c    | 18 ++++++---
 drivers/infiniband/hw/ipath/ipath_kernel.h    |  4 +-
 drivers/infiniband/hw/ipath/ipath_wc_x86_64.c | 43 +++++---------------
 drivers/media/pci/ivtv/Kconfig                |  3 ++
 drivers/media/pci/ivtv/ivtvfb.c               | 58 +++++++++++----------------
 6 files changed, 52 insertions(+), 77 deletions(-)

-- 
2.3.2.209.gd67f9d5.dirty

