Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:53400 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750823AbcEDJMo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2016 05:12:44 -0400
Received: from [192.168.1.137] (marune.xs4all.nl [80.101.105.217])
	by tschai.lan (Postfix) with ESMTPSA id 3F5DE1800BB
	for <linux-media@vger.kernel.org>; Wed,  4 May 2016 11:12:39 +0200 (CEST)
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.7] Various fixes
Message-ID: <5729BD06.5050307@xs4all.nl>
Date: Wed, 4 May 2016 11:12:38 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 68af062b5f38510dc96635314461c6bbe1dbf2fe:

  Merge tag 'v4.6-rc6' into patchwork (2016-05-02 07:48:23 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.7d

for you to fetch changes up to 416997d02013936b65c9d7a3d05d2030027fac0c:

  media: vb2-dma-contig: configure DMA max segment size properly (2016-05-04 11:08:13 +0200)

----------------------------------------------------------------
Hans Verkuil (1):
      v4l2-ioctl.c: improve cropcap compatibility code

Ismael Luceno (1):
      solo6x10: Set FRAME_BUF_SIZE to 200KB

Marek Szyprowski (1):
      media: vb2-dma-contig: configure DMA max segment size properly

 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c |  7 +++++--
 drivers/media/v4l2-core/v4l2-ioctl.c           | 70 +++++++++++++++++++++++++++++++++++++++++++---------------------------
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 99 insertions(+), 31 deletions(-)
