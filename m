Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:26291 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbaLHONl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Dec 2014 09:13:41 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NG9003R4P1IVZ10@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 08 Dec 2014 14:17:42 +0000 (GMT)
Received: from AMDN910 ([106.116.147.102])
 by eusync1.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0NG900DSMOUQB730@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 08 Dec 2014 14:13:38 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL] mem2mem patches
Date: Mon, 08 Dec 2014 15:13:37 +0100
Message-id: <034201d012f1$298eff40$7cacfdc0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 71947828caef0c83d4245f7d1eaddc799b4ff1d1:

  [media] mn88473: One function call less in mn88473_init() after error
(2014-12-04 16:00:47 -0200)

are available in the git repository at:

  git://linuxtv.org/kdebski/media_tree_2.git for-3.20

for you to fetch changes up to 7760045d005bf16e89488416960223bde86c7a0e:

  media: s5p-mfc: use vb2_ops_wait_prepare/finish helper (2014-12-08
13:05:29 +0100)

----------------------------------------------------------------
Prabhakar Lad (6):
      media: s3c-camif: use vb2_ops_wait_prepare/finish helper
      media: ti-vpe: use vb2_ops_wait_prepare/finish helper
      media: exynos-gsc: use vb2_ops_wait_prepare/finish helper
      media: sh_veu: use vb2_ops_wait_prepare/finish helper
      media: s5p-tv: use vb2_ops_wait_prepare/finish helper
      media: s5p-mfc: use vb2_ops_wait_prepare/finish helper

 drivers/media/platform/exynos-gsc/gsc-core.h     |   12 --------
 drivers/media/platform/exynos-gsc/gsc-m2m.c      |    6 ++--
 drivers/media/platform/s3c-camif/camif-capture.c |   17 ++---------
 drivers/media/platform/s5p-mfc/s5p_mfc.c         |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c     |   20 ++-----------
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c     |   20 ++-----------
 drivers/media/platform/s5p-tv/mixer_video.c      |   21 ++-----------
 drivers/media/platform/sh_veu.c                  |   35
+++++-----------------
 drivers/media/platform/ti-vpe/vpe.c              |   19 ++++--------
 9 files changed, 27 insertions(+), 124 deletions(-)

