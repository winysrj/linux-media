Return-path: <mchehab@gaivota>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:53327 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757619Ab1EMQPp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 May 2011 12:15:45 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LL5000116I71O40@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 13 May 2011 17:15:43 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LL5008Q66I6IU@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 13 May 2011 17:15:43 +0100 (BST)
Date: Fri, 13 May 2011 18:15:42 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [GIT PULL FOR 2.6.40] v4l2 subdev driver for Samsung S5P MIPI CSI
	receiver
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Message-id: <4DCD592E.8060302@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Mauro,

The following changes since commit f9b51477fe540fb4c65a05027fdd6f2ecce4db3b:

  [media] DVB: return meaningful error codes in dvb_frontend (2011-05-09 05:47:20 +0200)

are available in the git repository at:
  git://git.infradead.org/users/kmpark/linux-2.6-samsung s5p-csis

Sylwester Nawrocki (3):
      v4l: Add V4L2_MBUS_FMT_JPEG_1X8 media bus format
      v4l: Move s5p-fimc driver into Video capture devices
      v4l: Add v4l2 subdev driver for S5P/EXYNOS4 MIPI-CSI receivers

It's a new driver for MIPI CSI receiver available in S5PVxxx/EXYNOS4 SoCs.
The first patch adds definition of a media bus code for JPEG format.
 
I've done three further driver amendments comparing to the last (v5) version 
posted on the mailing lists, i.e.:
 - slightly improved description of struct csis_state
 - moved the pad number check from __s5pcsis_get_format directly to set_fmt/get_fmt
   pad level operation handlers
 - replaced __init attribute of s5pcsis_probe() with __devinit and added
   __devexit for s5pcsis_remove()

Gitweb: http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/s5p-csis

 Documentation/DocBook/v4l/subdev-formats.xml |   46 ++
 drivers/media/video/Kconfig                  |   28 +-
 drivers/media/video/s5p-fimc/Makefile        |    6 +-
 drivers/media/video/s5p-fimc/mipi-csis.c     |  725 ++++++++++++++++++++++++++
 drivers/media/video/s5p-fimc/mipi-csis.h     |   22 +
 include/linux/v4l2-mediabus.h                |    3 +
 6 files changed, 820 insertions(+), 10 deletions(-)
 create mode 100644 drivers/media/video/s5p-fimc/mipi-csis.c
 create mode 100644 drivers/media/video/s5p-fimc/mipi-csis.h

--
Regards, 
Sylwester Nawrocki
Samsung Poland R&D Center
