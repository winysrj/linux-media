Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:43040 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409Ab1EQRFi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 May 2011 13:05:38 -0400
Received: from spt2.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LLC00E4BNHDUN@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 17 May 2011 18:05:37 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LLC00LUPNHCUN@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 17 May 2011 18:05:36 +0100 (BST)
Date: Tue, 17 May 2011 19:05:36 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [GIT PATCHES FOR 2.6.40] v4l2 subdev driver for Samsung S5P MIPI	CSI
 receiver
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Message-id: <4DD2AAE0.1010700@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

The following changes since commit f9b51477fe540fb4c65a05027fdd6f2ecce4db3b:

  [media] DVB: return meaningful error codes in dvb_frontend (2011-05-09 05:47:20 +0200)

are available in the git repository at:
  git://git.infradead.org/users/kmpark/linux-2.6-samsung s5p-csis

It's a new driver for MIPI CSI receiver available in S5PVxxx/EXYNOS4 SoCs.
The first patch adds a definition of media bus code for JPEG format.
 
Gitweb: http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/s5p-csis

Sylwester Nawrocki (3):
      v4l: Add V4L2_MBUS_FMT_JPEG_1X8 media bus format
      v4l: Move s5p-fimc driver into Video capture devices
      v4l: Add v4l2 subdev driver for S5P/EXYNOS4 MIPI-CSI receivers

 Documentation/DocBook/v4l/subdev-formats.xml |   46 ++
 drivers/media/video/Kconfig                  |   28 +-
 drivers/media/video/Makefile                 |    1 +
 drivers/media/video/s5p-fimc/Makefile        |    6 +-
 drivers/media/video/s5p-fimc/mipi-csis.c     |  724 ++++++++++++++++++++++++++
 drivers/media/video/s5p-fimc/mipi-csis.h     |   22 +
 include/linux/v4l2-mediabus.h                |    3 +
 7 files changed, 820 insertions(+), 10 deletions(-)
 create mode 100644 drivers/media/video/s5p-fimc/mipi-csis.c
 create mode 100644 drivers/media/video/s5p-fimc/mipi-csis.h

Regards,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
