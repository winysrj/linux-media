Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:39164 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab2HNP1Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 11:27:16 -0400
Received: from eusync4.samsung.com (mailout4.w1.samsung.com [210.118.77.14])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8R00B7U4AG9J10@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Aug 2012 16:27:52 +0100 (BST)
Received: from [106.116.147.32] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0M8R00KJS49DLE10@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Aug 2012 16:27:14 +0100 (BST)
Message-id: <502A6E51.3000203@samsung.com>
Date: Tue, 14 Aug 2012 17:27:13 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	"Tomasz Stanislawski/Poland R&D Center-Linux (MSS)/./????"
	<t.stanislaws@samsung.com>
Subject: [GIT PATCHES FOR 3.7] s5p-tv driver updates
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 1511288620bd4ea794bae08871f9e108ca034b2d:

  ioctl-number.txt: Remove legacy private ioctl's from media drivers (2012-08-14 00:07:39 -0300)

are available in the git repository at:

  git://git.infradead.org/users/kmpark/linux-samsung v4l_samsung_for_v3.7

for you to fetch changes up to 768ce5950059f98ef1e390a1ec2bb98a3104c943:

  s5p-tv: Use devm_* functions in sii9234_drv.c file (2012-08-14 16:37:55 +0200)

----------------------------------------------------------------
Sachin Kamat (3):
      s5p-tv: Use devm_regulator_get() in sdo_drv.c file
      s5p-tv: Replace printk with pr_* functions
      s5p-tv: Use devm_* functions in sii9234_drv.c file

 drivers/media/video/s5p-tv/hdmi_drv.c    |    6 ++++--
 drivers/media/video/s5p-tv/mixer_drv.c   |    6 +++---
 drivers/media/video/s5p-tv/mixer_video.c |    4 +++-
 drivers/media/video/s5p-tv/sdo_drv.c     |   10 +++-------
 drivers/media/video/s5p-tv/sii9234_drv.c |   17 ++++-------------
 5 files changed, 17 insertions(+), 26 deletions(-)

I'll post a separate pull request including some fixup patches this week.


Thanks,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
