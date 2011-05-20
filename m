Return-path: <mchehab@pedra>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:17526 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935006Ab1ETQnH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 May 2011 12:43:07 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from spt2.w1.samsung.com ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LLI00NYM6FT2720@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 20 May 2011 17:43:05 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LLI00KJ26FS9J@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 20 May 2011 17:43:05 +0100 (BST)
Date: Fri, 20 May 2011 18:43:04 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [GIT PATCHES FOR 2.6.40] v4l subdev driver for M-5MOLS camera
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Message-id: <4DD69A18.8010603@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

The following changes since commit f9b51477fe540fb4c65a05027fdd6f2ecce4db3b:

  [media] DVB: return meaningful error codes in dvb_frontend (2011-05-09
05:47:20 +0200)

are available in the git repository at:
  git://git.infradead.org/users/kmpark/linux-2.6-samsung m5mols

HeungJun, Kim (1):
      Add support for M-5MOLS 8 Mega Pixel camera ISP

 drivers/media/video/Kconfig                  |    2 +
 drivers/media/video/Makefile                 |    1 +
 drivers/media/video/m5mols/Kconfig           |    5 +
 drivers/media/video/m5mols/Makefile          |    3 +
 drivers/media/video/m5mols/m5mols.h          |  296 ++++++++
 drivers/media/video/m5mols/m5mols_capture.c  |  191 +++++
 drivers/media/video/m5mols/m5mols_controls.c |  299 ++++++++
 drivers/media/video/m5mols/m5mols_core.c     | 1004 ++++++++++++++++++++++++++
 drivers/media/video/m5mols/m5mols_reg.h      |  399 ++++++++++
 include/media/m5mols.h                       |   35 +
 10 files changed, 2235 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/m5mols/Kconfig
 create mode 100644 drivers/media/video/m5mols/Makefile
 create mode 100644 drivers/media/video/m5mols/m5mols.h
 create mode 100644 drivers/media/video/m5mols/m5mols_capture.c
 create mode 100644 drivers/media/video/m5mols/m5mols_controls.c
 create mode 100644 drivers/media/video/m5mols/m5mols_core.c
 create mode 100644 drivers/media/video/m5mols/m5mols_reg.h
 create mode 100644 include/media/m5mols.h


Regards,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
