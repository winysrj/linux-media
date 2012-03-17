Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:44780 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756794Ab2CQLJJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Mar 2012 07:09:09 -0400
Received: from epcpsbgm1.samsung.com (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0M11009EH0B9ABC0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Sat, 17 Mar 2012 20:09:09 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp2.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0M1100JOJ0B86920@mmp2.samsung.com>
 for linux-media@vger.kernel.org; Sat, 17 Mar 2012 20:09:17 +0900 (KST)
From: Ajay Kumar <ajaykumar.rs@samsung.com>
To: linux-media@vger.kernel.org, k.debski@samsung.com
Cc: kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	es10.choi@samsung.com
Subject: [PATCH v2 0/1] media: video: s5p-g2d: Add support for FIMG2D v41 H/W
 logic
Date: Sat, 17 Mar 2012 16:52:13 +0530
Message-id: <1331983334-18934-1-git-send-email-ajaykumar.rs@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patches are created against "media-for-next" branch of kmpark's tree at:
git://git.infradead.org/users/kmpark/linux-2.6-samsung

The existing G2D driver supports only FIMG2D v3 style H/W.
This Patch modifies the existing G2D driver to support FIMG2D v41 style H/W.
FIMG2D v41 is present in Exynos4x12 and Exynos52x0 boards.

Patchset 1: http://patchwork.linuxtv.org/patch/10330/

Changes from Patchset1:
	-- Define 2 device_type ids(TYPE_G2D_3X and TYPE_G2D_41X) instead of 3
	-- Replace scale_factor_to_fixed16 function by g2d_calc_scale_factor
	-- Rename g2d_cmd_stretch function as g2d_set_v41_stretch
	-- Define and use CMD_V3_ENABLE_STRETCH instead of using (1 << 4)

Hi Mr.Kyungmin Park,
I have defined only 2 type ids as per spec - TYPE_G2D_3X and TYPE_G2D_41X.
Also, this patch works with dummy clock scheme for sclk_fimg2d on Exynos5.

Hi Mr.Kamil,
I have made changes as per your comments.
Patch is tested for stretching, ROP and flip features on Exynos5.

To Kamil:
	media: video: s5p-g2d: Add support for FIMG2D v41 H/W logic

 drivers/media/video/s5p-g2d/g2d-hw.c   |   39 ++++++++++++++++++++++++++++---
 drivers/media/video/s5p-g2d/g2d-regs.h |    6 +++++
 drivers/media/video/s5p-g2d/g2d.c      |   23 +++++++++++++++++-
 drivers/media/video/s5p-g2d/g2d.h      |    9 ++++++-
 4 files changed, 70 insertions(+), 7 deletions(-)

