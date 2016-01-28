Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:40737 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934252AbcA1I3c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2016 03:29:32 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [PATCH 0/12] TW686x driver
Date: Thu, 28 Jan 2016 09:29:29 +0100
Message-ID: <m337tif6om.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm posting a driver for TW686[4589]-based PCIe cards. The first patch
has been posted and reviewed by Ezequiel back in July 2015, the
subsequent patches are changes made in response to the review and/or are
required by the more recent kernel versions.

This driver lacks CMA-based frame mode DMA operation, I'll add it a bit
later. Also:
- I haven't converted the kthread to a workqueue - the driver is
  modeled after other code and it can be done later, if needed
- I have skipped suggested PCI ID changes and the 704 vs 720 pixels/line
  question - this may need further consideration.

Please merge.

The following changes since Linux 4.4 are available in the git
repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/chris/linux.git techwell-4.4

for you to fetch changes up to 8e495778acd4602c472cefa460a1afb41c4b8f25:

  [MEDIA] TW686x: return VB2_BUF_STATE_ERROR frames on timeout/errors (2016-01-27 14:47:41 +0100)

----------------------------------------------------------------
Krzysztof Hałasa (12):
      [MEDIA] Add support for TW686[4589]-based frame grabbers
      [MEDIA] TW686x: Trivial changes suggested by Ezequiel Garcia
      [MEDIA] TW686x: Switch to devm_*()
      [MEDIA] TW686x: Fix s_std() / g_std() / g_parm() pointer to self
      [MEDIA] TW686x: Fix handling of TV standard values
      [MEDIA] TW686x: Fix try_fmt() color space
      [MEDIA] TW686x: Add enum_input() / g_input() / s_input()
      [MEDIA] TW686x: do not use pci_dma_supported()
      [MEDIA] TW686x: switch to vb2_v4l2_buffer
      [MEDIA] TW686x: handle non-NULL format in queue_setup()
      [MEDIA] TW686x: Track frame sequence numbers
      [MEDIA] TW686x: return VB2_BUF_STATE_ERROR frames on timeout/errors

 drivers/media/pci/Kconfig               |   1 +
 drivers/media/pci/Makefile              |   1 +
 drivers/media/pci/tw686x/Kconfig        |  16 ++
 drivers/media/pci/tw686x/Makefile       |   3 +
 drivers/media/pci/tw686x/tw686x-core.c  | 140 +++++++++++++
 drivers/media/pci/tw686x/tw686x-regs.h  | 103 +++++++++
 drivers/media/pci/tw686x/tw686x-video.c | 815 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/pci/tw686x/tw686x.h       | 118 +++++++++++
 8 files changed, 1197 insertions(+)
 create mode 100644 drivers/media/pci/tw686x/Kconfig
 create mode 100644 drivers/media/pci/tw686x/Makefile
 create mode 100644 drivers/media/pci/tw686x/tw686x-core.c
 create mode 100644 drivers/media/pci/tw686x/tw686x-regs.h
 create mode 100644 drivers/media/pci/tw686x/tw686x-video.c
 create mode 100644 drivers/media/pci/tw686x/tw686x.h

Thanks.
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
