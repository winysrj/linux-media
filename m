Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:14032 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbbLBIXf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Dec 2015 03:23:35 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NYQ007EK1Z9YY00@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 02 Dec 2015 08:23:33 +0000 (GMT)
From: Andrzej Hajda <a.hajda@samsung.com>
To: Kamil Debski <k.debski@samsung.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-media@vger.kernel.org (open list:ARM/SAMSUNG S5P SERIES Multi
	Format Codec (MFC)...), s.nawrocki@samsung.com
Subject: [PATCH 0/6] MFC locking rework and code cleanup
Date: Wed, 02 Dec 2015 09:22:27 +0100
Message-id: <1449044553-27115-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

This patchset contains one patch which should fix races during accessing context fields.
As the patch significantly changes locking I have tested it in different different scenarios.
Other patches just clean up the code.

The patchset is based on the latest media-tree branch.

Regards
Andrzej


Andrzej Hajda (6):
  s5p-mfc: use one implementation of s5p_mfc_get_new_ctx
  s5p-mfc: make queue cleanup code common
  s5p-mfc: remove unnecessary callbacks
  s5p-mfc: use spinlock to protect MFC context
  s5p-mfc: merge together s5p_mfc_hw_call and s5p_mfc_hw_call_void
  s5p-mfc: remove volatile attribute from MFC register addresses

 drivers/media/platform/s5p-mfc/s5p_mfc.c        |  99 +++--
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |  12 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c   |  16 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    |  31 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |  40 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h    | 507 ++++++++++++------------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c |  94 -----
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c | 121 +-----
 8 files changed, 351 insertions(+), 569 deletions(-)

-- 
1.9.1

