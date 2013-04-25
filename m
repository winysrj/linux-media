Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:11507 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab3DYJuM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 05:50:12 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MLT00BSH1Z5TYM0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 25 Apr 2013 18:50:10 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 0/7] Add copy time stamp handling to mem2mem drivers
Date: Thu, 25 Apr 2013 11:49:43 +0200
Message-id: <1366883390-12890-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This set of patches adds support for copy time stamp handling in the following
mem2mem drivers:
* CODA video codec
* Exynos GScaler
* m2m-deinterlace
* mx2_emmaprp
* Exynos G2D
* Exynos Jpeg
In addition there is a slight optimisation for the Exynos MFC driver.

Best wishes,
Kamil Debski

Kamil Debski (7):
  s5p-g2d: Add copy time stamp handling
  s5p-jpeg: Add copy time stamp handling
  s5p-mfc: Optimize copy time stamp handling
  coda: Add copy time stamp handling
  exynos-gsc: Add copy time stamp handling
  m2m-deinterlace: Add copy time stamp handling
  mx2-emmaprp: Add copy time stamp handling

 drivers/media/platform/coda.c               |    5 +++++
 drivers/media/platform/exynos-gsc/gsc-m2m.c |    5 +++++
 drivers/media/platform/m2m-deinterlace.c    |    5 +++++
 drivers/media/platform/mx2_emmaprp.c        |    5 +++++
 drivers/media/platform/s5p-g2d/g2d.c        |    5 +++++
 drivers/media/platform/s5p-jpeg/jpeg-core.c |    5 +++++
 drivers/media/platform/s5p-mfc/s5p_mfc.c    |   10 ++++------
 7 files changed, 34 insertions(+), 6 deletions(-)

-- 
1.7.9.5

