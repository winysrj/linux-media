Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:40536 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185Ab3DYMLL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 08:11:11 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MLT0065R8HL4W70@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 25 Apr 2013 13:11:08 +0100 (BST)
Received: from AMDN910 ([106.116.147.102])
 by eusync2.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0MLT001V48IGDHB0@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 25 Apr 2013 13:11:08 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL] m2m: Time stamp related fixes
Date: Thu, 25 Apr 2013 14:11:04 +0200
Message-id: <000b01ce41ad$f5f6c160$e1e44420$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Sorry for posting this so late. The patches in this pull request add
timestamp_type 
handling to mem2mem drivers.

Best wishes,
-- 
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center		

The following changes since commit 5f3f254f7c138a22a544b80ce2c14a3fc4ed711e:

  [media] media/rc/imon.c: kill urb when send_packet() is interrupted
(2013-04-23 17:50:34 -0300)

are available in the git repository at:

  git://git.linuxtv.org/kdebski/media.git media_tree

for you to fetch changes up to 3a9e65ae54131b8d4568a9e1b0695c37fffb37a2:

  mem2mem_testdev: set timestamp_type and add debug param (2013-04-25
13:51:13 +0200)

----------------------------------------------------------------
Hans Verkuil (1):
      mem2mem_testdev: set timestamp_type and add debug param

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
 drivers/media/platform/mem2mem_testdev.c    |   12 +++++++++++-
 drivers/media/platform/mx2_emmaprp.c        |    5 +++++
 drivers/media/platform/s5p-g2d/g2d.c        |    5 +++++
 drivers/media/platform/s5p-jpeg/jpeg-core.c |    5 +++++
 drivers/media/platform/s5p-mfc/s5p_mfc.c    |   10 ++++------
 8 files changed, 45 insertions(+), 7 deletions(-)





