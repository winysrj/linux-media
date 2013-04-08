Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:37501 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935526Ab3DHNSy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Apr 2013 09:18:54 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MKX00DU4U8NR290@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 08 Apr 2013 14:18:53 +0100 (BST)
Received: from AMDN910 ([106.116.147.102])
 by eusync2.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0MKX00E50UATSL20@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 08 Apr 2013 14:18:53 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL] s5p-mfc: decoder fix
Date: Mon, 08 Apr 2013 15:18:27 +0200
Message-id: <02dc01ce345b$90293110$b07b9330$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Somehow the patch adding another way of ending video stream decoding was
lost.
I am not sure if this should be regarded as a fix or adding new
functionality.
It adds the ability to finish video decoding with an EOS command and notify
the
application with an event that the last frame was decoded. This is the
recommended
way to end decoding.

It was originally sent in January as a part of a 3 patch series. Other
patches
were pure fixes and already got merged.

In addition, I included a recent fix by Hans Verkuil.

Best wishes,
-- 
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center

The following changes since commit 53faa685fa7df0e12751eebbda30bc7e7bb5e71a:

  [media] siano: Fix array boundary at smscore_translate_msg() (2013-04-04
14:35:40 -0300)

are available in the git repository at:

  git://linuxtv.org/kdebski/media.git media_tree

for you to fetch changes up to 3d79b910d83f561bdf6c9c80083ee7ad529a4e4c:

  s5c73m3: Fix s5c73m3-core.c compiler warning (2013-04-08 15:09:25 +0200)

----------------------------------------------------------------
Hans Verkuil (1):
      s5c73m3: Fix s5c73m3-core.c compiler warning

Kamil Debski (1):
      s5p-mfc: Add support for EOS command and EOS event in video decoder

 drivers/media/i2c/s5c73m3/s5c73m3-core.c        |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c        |    2 +
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    |   76
+++++++++++++++++++++--
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c |    9 +++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |   10 ++-
 5 files changed, 93 insertions(+), 6 deletions(-)




