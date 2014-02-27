Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:37952 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaB0NR3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Feb 2014 08:17:29 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N1N00LM7OX29PB0@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 27 Feb 2014 13:17:26 +0000 (GMT)
Received: from AMDN910 ([106.116.147.102])
 by eusync4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0N1N001U4OX1GE90@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 27 Feb 2014 13:17:26 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL] mem2mem patches for 3.15
Date: Thu, 27 Feb 2014 14:17:25 +0100
Message-id: <14e601cf33be$42188620$c6499260$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit b215621049bd57221455990880fb6b906f7dac21:

  Merge branch 'v4l_for_linus' into to_next (2014-02-04 06:48:49 -0200)

are available in the git repository at:


  git://linuxtv.org/kdebski/media_tree_2.git master

for you to fetch changes up to 61ca9493f4f0d3c8c1b4129b5bda6a2be32e5bf4:

  s5p-mfc: Add Horizontal and Vertical MV Search Range (2014-02-26 14:54:08
+0100)

----------------------------------------------------------------
Amit Grover (2):
      v4l2: Add settings for Horizontal and Vertical MV Search Range
      s5p-mfc: Add Horizontal and Vertical MV Search Range

 Documentation/DocBook/media/v4l/controls.xml    |   20 +++++++++++++++++++
 drivers/media/platform/s5p-mfc/regs-mfc-v6.h    |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    2 ++
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |   24
+++++++++++++++++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |    8 ++------
 drivers/media/v4l2-core/v4l2-ctrls.c            |    6 ++++++
 include/uapi/linux/v4l2-controls.h              |    2 ++
 7 files changed, 57 insertions(+), 6 deletions(-)

