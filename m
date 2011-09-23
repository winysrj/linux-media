Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:22174 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765Ab1IWP4f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Sep 2011 11:56:35 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LRZ009G6GA9J050@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 23 Sep 2011 16:56:33 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LRZ00A59GA9J0@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 23 Sep 2011 16:56:33 +0100 (BST)
Date: Fri, 23 Sep 2011 17:56:33 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [GIT PATCHES FOR 3.2] Media bus configuration flags
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Message-id: <4E7CAC31.3090007@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please pull from git://git.infradead.org/users/kmpark/linux-2.6-samsung v4l_mbus_config
for a small addition to the media bus configuration flags, a patch converting s5p-fimc
driver to use generic flags and an optimization patch for m5mols driver.

I have added the m5mols patch which has also been included in recent pull request from
Marek, as I wasn't sure if you're going to pull it due to some further ongoing discussion
on the selection API.

The following changes since commit 3a7a62378be538944ff00904b8e0b795fe16609a:

  [media] ati_remote: update Kconfig description (2011-09-22 10:55:10 -0300)

are available in the git repository at:
  git://git.infradead.org/users/kmpark/linux-2.6-samsung v4l_mbus_config

Sylwester Nawrocki (3):
      v4l2: Add polarity flag definitions for the parallel bus FIELD signal
      s5p-fimc: Convert to use generic media bus polarity flags
      m5mols: Remove superfluous irq field from the platform data struct

 drivers/media/video/m5mols/m5mols_core.c |    6 +++---
 drivers/media/video/s5p-fimc/fimc-reg.c  |   14 +++++++++-----
 drivers/media/video/s5p-fimc/regs-fimc.h |    1 +
 include/media/m5mols.h                   |    4 +---
 include/media/s5p_fimc.h                 |    7 +------
 include/media/v4l2-mediabus.h            |   12 ++++++++++--
 6 files changed, 25 insertions(+), 19 deletions(-)

Best regards,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
