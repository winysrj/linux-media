Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:50534 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750735AbcEDNvF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2016 09:51:05 -0400
Received: from [192.168.1.137] (marune.xs4all.nl [80.101.105.217])
	by tschai.lan (Postfix) with ESMTPSA id EFDE41800BB
	for <linux-media@vger.kernel.org>; Wed,  4 May 2016 15:51:00 +0200 (CEST)
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.7] Various fixes
Message-ID: <5729FE44.1080503@xs4all.nl>
Date: Wed, 4 May 2016 15:51:00 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(Superseeds https://patchwork.linuxtv.org/patch/34178/, dropping Ismael's patch
due to confused patch provenance)

The following changes since commit 68af062b5f38510dc96635314461c6bbe1dbf2fe:

  Merge tag 'v4.6-rc6' into patchwork (2016-05-02 07:48:23 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.7d

for you to fetch changes up to 3b97cd1d95c24647842359ac9515295ce5c97038:

  media: vb2-dma-contig: configure DMA max segment size properly (2016-05-04 15:48:45 +0200)

----------------------------------------------------------------
Hans Verkuil (1):
      v4l2-ioctl.c: improve cropcap compatibility code

Marek Szyprowski (1):
      media: vb2-dma-contig: configure DMA max segment size properly

 drivers/media/v4l2-core/v4l2-ioctl.c           | 70 +++++++++++++++++++++++++++++++++++++++++++---------------------------
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 94 insertions(+), 29 deletions(-)
