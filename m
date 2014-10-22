Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2458 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933239AbaJVLLn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Oct 2014 07:11:43 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209])
	(authenticated bits=0)
	by smtp-vbr15.xs4all.nl (8.13.8/8.13.8) with ESMTP id s9MBBdtd034319
	for <linux-media@vger.kernel.org>; Wed, 22 Oct 2014 13:11:41 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [10.61.200.78] (173-38-208-170.cisco.com [173.38.208.170])
	by tschai.lan (Postfix) with ESMTPSA id 12F922A0432
	for <linux-media@vger.kernel.org>; Wed, 22 Oct 2014 13:11:28 +0200 (CEST)
Message-ID: <544790EA.1000903@xs4all.nl>
Date: Wed, 22 Oct 2014 13:11:38 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [GIT FIXES for v3.18] Various fixes
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Various fixes for 3.18.

Regards,

	Hans

The following changes since commit 1ef24960ab78554fe7e8e77d8fc86524fbd60d3c:

   Merge tag 'v3.18-rc1' into patchwork (2014-10-21 08:32:51 -0200)

are available in the git repository at:

   git://linuxtv.org/hverkuil/media_tree.git for-v3.18f

for you to fetch changes up to 30da44af2da231c02a8cb2d6d4d3905c6e8030c9:

   videobuf-dma-contig: set vm_pgoff to be zero to pass the sanity check in vm_iomap_memory(). (2014-10-22 13:04:09 +0200)

----------------------------------------------------------------
Dan Carpenter (3):
       em28xx-input: NULL dereference on error
       xc5000: use after free in release()
       usbvision-video: two use after frees

Fabian Frederick (1):
       tw68: remove deprecated IRQF_DISABLED

Fancy Fang (1):
       videobuf-dma-contig: set vm_pgoff to be zero to pass the sanity check in vm_iomap_memory().

Hans Verkuil (2):
       wl128x: fix fmdbg compiler warning
       tw68: remove bogus I2C_ALGOBIT dependency

  drivers/media/pci/tw68/Kconfig                | 1 -
  drivers/media/pci/tw68/tw68-core.c            | 2 +-
  drivers/media/radio/wl128x/fmdrv_common.c     | 2 +-
  drivers/media/tuners/xc5000.c                 | 2 +-
  drivers/media/usb/em28xx/em28xx-input.c       | 4 +++-
  drivers/media/usb/usbvision/usbvision-video.c | 2 ++
  drivers/media/v4l2-core/videobuf-dma-contig.c | 9 +++++++++
  7 files changed, 17 insertions(+), 5 deletions(-)
