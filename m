Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:10010 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514Ab2BTJdt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Feb 2012 04:33:49 -0500
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LZO00JQ2QKBK0@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 20 Feb 2012 09:33:47 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LZO00GEFQK7I9@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 20 Feb 2012 09:33:47 +0000 (GMT)
Date: Mon, 20 Feb 2012 10:33:31 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 0/3] Fix subdev name in s5k6aa, m5mols, noon010pc30 drivers
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <1329730414-7757-1-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series updates s5k6aa, m5mols, noon010pc30 drivers so their
subdev names don't have I2C addresses appended to them. This ensures
a constant subdevice name across different boards.

Sylwester Nawrocki (3):
  s5k6aa: Make subdev name independent of the I2C slave address
  m5mols: Make subdev name independent of the I2C slave address
  noon010pc30: Make subdev name independent of the I2C slave address

 drivers/media/video/m5mols/m5mols_core.c |    2 +-
 drivers/media/video/noon010pc30.c        |    2 +-
 drivers/media/video/s5k6aa.c             |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

-- 
1.7.9

