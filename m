Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:47723 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759010Ab3E1H0q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 May 2013 03:26:46 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MNH00BQBZAWJB70@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 28 May 2013 08:26:44 +0100 (BST)
From: Andrzej Hajda <a.hajda@samsung.com>
To: Kamil Debski <k.debski@samsung.com>, linux-media@vger.kernel.org
Cc: Jeongtae Park <jtp.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH 0/3] s5p-mfc encoder fixes
Date: Tue, 28 May 2013 09:26:13 +0200
Message-id: <1369725976-7828-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those three independent patches are fixes for s5p-mfc encoder.
The first one is a serious bug fix - some controls were not working properly.
The latter two fixes minor issues.

Regards
Andrzej Hajda

Andrzej Hajda (3):
  s5p-mfc: separate encoder parameters for h264 and mpeg4
  s5p-mfc: v4l2 controls setup routine moved to initialization code
  s5p-mfc: added missing end-of-lines in debug messages

 drivers/media/platform/s5p-mfc/s5p_mfc.c        |  2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |  2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_debug.h  |  4 ++--
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    | 18 +++++++++---------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c |  4 ++--
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c | 14 +++++++-------
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c     |  4 ++--
 7 files changed, 24 insertions(+), 24 deletions(-)

-- 
1.8.1.2

