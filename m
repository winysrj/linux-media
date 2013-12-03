Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:11565 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab3LCSXD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 13:23:03 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MX800NDDTQE3Z40@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 03 Dec 2013 18:23:02 +0000 (GMT)
Received: from [106.116.147.32] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MX80072UTQDCW10@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 03 Dec 2013 18:23:01 +0000 (GMT)
Message-id: <529E2184.90303@samsung.com>
Date: Tue, 03 Dec 2013 19:23:00 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL]  git://linuxtv.org/snawrocki/samsung.git v3.14-s5p-tv-clk
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


The following changes since commit fa507e4d32bf6c35eb5fe7dbc0593ae3723c9575:

  [media] media: marvell-ccic: use devm to release clk (2013-11-29 14:46:47 -0200)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git v3.14-s5p-tv-clk

for you to fetch changes up to 929dc93636681aa0c1f4ec763924cc1837aef94f:

  s5p-tv: mixer: Prepare for common clock framework (2013-12-02 22:49:55 +0100)

----------------------------------------------------------------
Mateusz Krawczuk (3):
      s5p-tv: sdo: Restore vpll clock rate after streamoff
      s5p-tv: sdo: Prepare for common clock framework
      s5p-tv: mixer: Prepare for common clock framework

 drivers/media/platform/s5p-tv/mixer_drv.c |   34 ++++++++++++++++++++-----
 drivers/media/platform/s5p-tv/sdo_drv.c   |   39 +++++++++++++++++++++++------
 2 files changed, 59 insertions(+), 14 deletions(-)
