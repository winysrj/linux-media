Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:59454 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab0I2Hjx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Sep 2010 03:39:53 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Received: from eu_spt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0L9H00JEHZYFBU60@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 Sep 2010 08:39:51 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L9H00LE7ZYEA5@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 Sep 2010 08:39:51 +0100 (BST)
Date: Wed, 29 Sep 2010 09:39:50 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [GIT PULL] V4L fixes for 2.6.36
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com
Message-id: <4CA2ED46.2020904@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

please pull the below fixes for 2.6.36:

The following changes since commit ddc79e0fdc16c05c3ff7f9b6ae9052bda0506108

V4L/DVB: v4l: s5p-fimc: Fix 3-planar formats handling and pixel offset 
error on S5PV210 SoCs (Mon Sep 6 03:53:44 2010 -0300)

are available in the git repository at:

git://git.infradead.org/users/kmpark/linux-2.6-samsung v4l/fixes_for_v2.6.36

Marek Szyprowski (1):
v4l: radio: si470x: fix unneeded free_irq() call

Pawel Osciak (1):
v4l: videobuf: prevent passing a NULL to dma_free_coherent()

  drivers/media/radio/si470x/radio-si470x-i2c.c |    2 +-
  drivers/media/video/videobuf-dma-contig.c     |    6 ++++--
  2 files changed, 5 insertions(+), 3 deletions(-)

Regards,
Sylwester

-- 
Sylwester Nawrocki
Linux Platform Group
Samsung Poland R&D Center
