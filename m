Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:10465 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200AbaCKKb2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 06:31:28 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N290044RP8DBQA0@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 11 Mar 2014 10:31:25 +0000 (GMT)
Received: from AMDN910 ([106.116.147.102])
 by eusync1.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0N29002DTP8CMW70@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 11 Mar 2014 10:31:24 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'LMML' <linux-media@vger.kernel.org>
Subject: [GIT PULL for 3.15] mem2mem patches
Date: Tue, 11 Mar 2014 11:31:24 +0100
Message-id: <1d1f01cf3d15$0dc203a0$29460ae0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit f2d7313534072a5fe192e7cf46204b413acef479:

  [media] drx-d: add missing braces in drxd_hard.c:DRXD_init (2014-03-09
09:20:50 -0300)

are available in the git repository at:

  git://linuxtv.org/kdebski/media_tree_2.git master

for you to fetch changes up to 0dceda80c0cc903a491ec76264768dd2bc4faeda:

  mem2mem_testdev: improve field handling (2014-03-11 11:22:23 +0100)

----------------------------------------------------------------
Hans Verkuil (7):
      mem2mem_testdev: use 40ms default transfer time.
      mem2mem_testdev: pick default format with try_fmt.
      mem2mem_testdev: set priv to 0
      mem2mem_testdev: add USERPTR support.
      mem2mem_testdev: return pending buffers in stop_streaming()
      mem2mem_testdev: fix field, sequence and time copying
      mem2mem_testdev: improve field handling

Joonyoung Shim (1):
      s5p-mfc: Replaced commas with semicolons.

Seung-Woo Kim (1):
      s5p-mfc: remove meaningless memory bank assignment

 drivers/media/platform/mem2mem_testdev.c      |   94
+++++++++++++++++++------
 drivers/media/platform/s5p-mfc/s5p_mfc.c      |    8 +--
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c |    2 -
 3 files changed, 75 insertions(+), 29 deletions(-)

