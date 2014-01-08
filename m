Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:64285 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010AbaAHLwS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 06:52:18 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZ200DG1ZN2NBA0@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 08 Jan 2014 11:52:14 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: 'Mauro Carvalho Chehab' <m.chehab@samsung.com>
Subject: [GIT PULL for v3.14 v2] mem2mem patches
Date: Wed, 08 Jan 2014 12:52:15 +0100
Message-id: <049c01cf0c68$136c23e0$3a446ba0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 6892f65b7b9e14fe29b6e4f0dc4f7ed3796a6e71:

  exynos-scaler: Add DT bindings for SCALER driver (2013-12-24 10:37:23
+0100)

are available in the git repository at:

  git://linuxtv.org/kdebski/media.git master

for you to fetch changes up to 0f6616ebb7a04219ad7aa84dd9ff9c7ac9323529:

  s5p-mfc: Add controls to set vp8 enc profile (2013-12-24 10:37:27 +0100)

----------------------------------------------------------------
Arun Kumar K (1):
      s5p-mfc: Add QP setting support for vp8 encoder

Kiran AVND (1):
      s5p-mfc: Add controls to set vp8 enc profile

Marek Szyprowski (1):
      media: s5p_mfc: remove s5p_mfc_get_node_type() function

 Documentation/DocBook/media/v4l/controls.xml    |   41 +++++++++++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc.c        |   28 +++---------
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |   14 +++---
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |   55
+++++++++++++++++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |   26 +++++++++--
 drivers/media/v4l2-core/v4l2-ctrls.c            |    5 +++
 include/uapi/linux/v4l2-controls.h              |    5 +++
 7 files changed, 140 insertions(+), 34 deletions(-)

