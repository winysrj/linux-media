Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:13199 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbaENPZx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 May 2014 11:25:53 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N5K0048TLJ2XM30@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 14 May 2014 16:25:50 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: 'Archit Taneja' <archit@ti.com>
Subject: [GIT PULL for 3.16] ti-vpe patches
Date: Wed, 14 May 2014 17:26:07 +0200
Message-id: <038c01cf6f88$d3f26fb0$7bd74f10$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit ba0d342ecc21fbbe2f6c178f4479944d1fb34f3b:

  saa7134-alsa: include vmalloc.h (2014-05-13 23:05:15 -0300)

are available in the git repository at:

  git://linuxtv.org/kdebski/media_tree_2.git for-3.16

for you to fetch changes up to 61b2123701c3568fcf8a07e69fe1c2854f640a4e:

  v4l: ti-vpe: Rename csc memory resource name (2014-05-14 15:53:39 +0200)

----------------------------------------------------------------
Archit Taneja (5):
      v4l: ti-vpe: register video device only when firmware is loaded
      v4l: ti-vpe: Allow DMABUF buffer type support
      v4l: ti-vpe: Fix some params in VPE data descriptors
      v4l: ti-vpe: Add selection API in VPE driver
      v4l: ti-vpe: Rename csc memory resource name

 drivers/media/platform/ti-vpe/csc.c   |    2 +-
 drivers/media/platform/ti-vpe/vpdma.c |   68 +++++++---
 drivers/media/platform/ti-vpe/vpdma.h |   17 ++-
 drivers/media/platform/ti-vpe/vpe.c   |  227
++++++++++++++++++++++++++++-----
 4 files changed, 258 insertions(+), 56 deletions(-)

