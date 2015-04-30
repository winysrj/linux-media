Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-4.cisco.com ([173.38.203.54]:5822 "EHLO
	aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbbD3Ntt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2015 09:49:49 -0400
Received: from [10.54.92.107] (dhcp-10-54-92-107.cisco.com [10.54.92.107])
	(authenticated bits=0)
	by aer-core-4.cisco.com (8.14.5/8.14.5) with ESMTP id t3UDnixq031590
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 30 Apr 2015 13:49:45 GMT
Message-ID: <554232F8.6090206@cisco.com>
Date: Thu, 30 Apr 2015 15:49:44 +0200
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.2] Clean up and move dt3155 out of staging
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This pull request cleans up the dt3155 driver and moves it out of staging.

Tested with my dt3155 board.

Regards,

	Hans

The following changes since commit e183201b9e917daf2530b637b2f34f1d5afb934d:

  [media] uvcvideo: add support for VIDIOC_QUERY_EXT_CTRL (2015-04-10 10:29:27 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git dt3155

for you to fetch changes up to 682454513c7c17c981645e5d9796ae5bed8edf61:

  dt3155: add GFP_DMA32 flag to vb2 queue (2015-04-26 11:27:00 +0200)

----------------------------------------------------------------
Hans Verkuil (13):
      dt3155v4l: code cleanup
      dt3155v4l: remove unused statistics
      dt3155v4l: add v4l2_device support
      dt3155v4l: remove pointless dt3155_alloc/free_coherent
      dt3155v4l: remove bogus single-frame capture in init_board
      dt3155v4l: move vb2_queue to top-level
      dt3155v4l: drop CONFIG_DT3155_STREAMING
      dt3155v4l: correctly start and stop streaming
      dt3155v4l: drop CONFIG_DT3155_CCIR, use s_std instead
      dt3155v4l: fix format handling
      dt3155v4l: support inputs VID0-3
      dt3155: move out of staging into drivers/media/pci
      dt3155: add GFP_DMA32 flag to vb2 queue

 MAINTAINERS                                                                |   8 +
 drivers/media/pci/Kconfig                                                  |   1 +
 drivers/media/pci/Makefile                                                 |   1 +
 drivers/media/pci/dt3155/Kconfig                                           |  13 +
 drivers/media/pci/dt3155/Makefile                                          |   1 +
 drivers/media/pci/dt3155/dt3155.c                                          | 627 +++++++++++++++++++++++++
 drivers/{staging/media/dt3155v4l/dt3155v4l.h => media/pci/dt3155/dt3155.h} |  64 +--
 drivers/staging/media/Kconfig                                              |   2 -
 drivers/staging/media/Makefile                                             |   1 -
 drivers/staging/media/dt3155v4l/Kconfig                                    |  29 --
 drivers/staging/media/dt3155v4l/Makefile                                   |   1 -
 drivers/staging/media/dt3155v4l/dt3155v4l.c                                | 981 ----------------------------------------
 12 files changed, 675 insertions(+), 1054 deletions(-)
 create mode 100644 drivers/media/pci/dt3155/Kconfig
 create mode 100644 drivers/media/pci/dt3155/Makefile
 create mode 100644 drivers/media/pci/dt3155/dt3155.c
 rename drivers/{staging/media/dt3155v4l/dt3155v4l.h => media/pci/dt3155/dt3155.h} (82%)
 delete mode 100644 drivers/staging/media/dt3155v4l/Kconfig
 delete mode 100644 drivers/staging/media/dt3155v4l/Makefile
 delete mode 100644 drivers/staging/media/dt3155v4l/dt3155v4l.c
