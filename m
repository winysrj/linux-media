Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:24077 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab1IUPXG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Sep 2011 11:23:06 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LRV005PGPEGD950@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 Sep 2011 16:23:04 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LRV001HEPEGNL@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 Sep 2011 16:23:04 +0100 (BST)
Date: Wed, 21 Sep 2011 17:23:03 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [GIT PATCHES FOR 3.2] noon010pc30 conversion to the pad (v2)
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Message-id: <4E7A0157.5020200@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

here is an updated pull request. Additionally I have appended a Kconfig
cleanup patch to it.


The following changes since commit de2fb698c6fb1e968a5ed9cc449024f119ad3853:

  [media] saa7164: Adding support for HVR2200 card id 0x8953 (2011-09-21
10:16:31 -0300)

are available in the git repository at:
  git://git.infradead.org/users/kmpark/linux-2.6-samsung v4l_noon010pc30

Sylwester Nawrocki (4):
      noon010pc30: Conversion to the media controller API
      noon010pc30: Improve s_power operation handling
      noon010pc30: Remove g_chip_ident operation handler
      v4l: Move SR030PC30, NOON010PC30, M5MOLS drivers to the right location

 drivers/media/video/Kconfig       |   28 ++--
 drivers/media/video/noon010pc30.c |  263 +++++++++++++++++++++++--------------
 include/media/v4l2-chip-ident.h   |    3 -
 3 files changed, 180 insertions(+), 114 deletions(-)


Thank you,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
