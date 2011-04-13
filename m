Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:24150 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab1DMKAv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Apr 2011 06:00:51 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from eu_spt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LJL00HQN55D2Z30@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 13 Apr 2011 11:00:49 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LJL00ED655CTE@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 13 Apr 2011 11:00:48 +0100 (BST)
Date: Wed, 13 Apr 2011 12:00:47 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [GIT PULL FOR 2.6.39] s5p-fimc driver updates
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Message-id: <4DA5744F.4070004@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

please pull from
  git://git.infradead.org/users/kmpark/linux-2.6-samsung for-mauro

for a few s5p-fimc driver bugfixes.


The following changes since commit 28df73703e738d8ae7a958350f74b08b2e9fe9ed:

  [media] xc5000: Improve it to work better with 6MHz-spaced channels
(2011-03-28 15:49:28 -0300)

are available in the git repository at:
  git://git.infradead.org/users/kmpark/linux-2.6-samsung for-mauro

Sylwester Nawrocki (4):
      s5p-fimc: Fix FIMC3 pixel limits on Exynos4
      s5p-fimc: Do not allow changing format after REQBUFS
      s5p-fimc: Fix bytesperline and plane payload setup
      s5p-fimc: Add support for the buffer timestamps and sequence

 drivers/media/video/s5p-fimc/fimc-capture.c |    8 ++-
 drivers/media/video/s5p-fimc/fimc-core.c    |   74 +++++++++++++++++----------
 2 files changed, 52 insertions(+), 30 deletions(-)


Thank you,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
