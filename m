Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:45645 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750894AbcF0I6d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2016 04:58:33 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
	=?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.8] tw686x enhancements
Message-ID: <c5db5fbb-46f2-3d93-3267-5d1d02a8213e@xs4all.nl>
Date: Mon, 27 Jun 2016 10:58:28 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This improves the tw686x driver, adding support for features that were formerly
only available in the staging tw686x driver.

Krzysztof, please let us know if there are features that you need that are not
available in this driver. Otherwise I plan to remove the staging driver for
kernel 4.9.

Ezequiel, as a future follow-up patch it might be nice to automatically choose
between contig/memcpy and sg based on the requested field format.

Right now this is determined by dma_mode, but that can be improved.

It would also simplify the dma_mode since that would then be a bool saying
whether or not it should memcpy for stability.

I'm not postponing merging this series for that since this is already a
substantial improvement.

Regards,

	Hans

The following changes since commit 0db5c79989de2c68d5abb7ba891bfdb3cd3b7e05:

  [media] media-devnode.h: Fix documentation (2016-06-16 08:14:56 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.8b

for you to fetch changes up to f600ab6de581ab45751bbc157e507b0ec1c6cc1a:

  tw686x: be explicit about the possible dma_mode options (2016-06-27 10:28:59 +0200)

----------------------------------------------------------------
Ezequiel Garcia (6):
      tw686x: Introduce an interface to support multiple DMA modes
      tw686x: Add support for DMA contiguous interlaced frame mode
      tw686x: Add support for DMA scatter-gather mode
      tw686x: audio: Implement non-memcpy capture
      tw686x: audio: Allow to configure the period size
      tw686x: audio: Prevent hw param changes while busy

Hans Verkuil (1):
      tw686x: be explicit about the possible dma_mode options

 drivers/media/pci/tw686x/Kconfig        |   2 +
 drivers/media/pci/tw686x/tw686x-audio.c |  92 +++++++++---
 drivers/media/pci/tw686x/tw686x-core.c  |  56 ++++++-
 drivers/media/pci/tw686x/tw686x-regs.h  |   9 ++
 drivers/media/pci/tw686x/tw686x-video.c | 492 +++++++++++++++++++++++++++++++++++++++++++++++-------------
 drivers/media/pci/tw686x/tw686x.h       |  41 ++++-
 6 files changed, 544 insertions(+), 148 deletions(-)
