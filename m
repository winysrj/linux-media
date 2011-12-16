Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:44054 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab1LPQVs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Dec 2011 11:21:48 -0500
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LWB00GJO1G9XI@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 16 Dec 2011 16:21:45 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LWB000YO1G9GK@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 16 Dec 2011 16:21:45 +0000 (GMT)
Date: Fri, 16 Dec 2011 17:21:45 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [GIT PATCHES FOR 3.3] m5mols driver improvements
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Message-id: <4EEB7019.3030201@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 23a955ff8fe5461a77f59e1a3ce0ad1fc348c7e0:

  m5mols: Fix logic in sanity check (2011-12-16 14:21:28 +0100)

are available in the git repository at:
  git://git.infradead.org/users/kmpark/linux-samsung m5mols

These are m5mols driver initialization time optimizations and modifications
required for proper sub-device node support in user space.

HeungJun Kim (4):
      m5mols: Extend the busy wait helper
      m5mols: Improve the interrupt handling routines
      m5mols: Add support for the system initialization interrupt
      m5mols: Optimize the capture set up sequence

Sylwester Nawrocki (9):
      m5mols: Simplify the I2C registers definition
      m5mols: Remove mode_save field from struct m5mols_info
      m5mols: Change the end of frame v4l2_subdev notification id
      m5mols: Don't ignore v4l2_ctrl_handler_setup() return value
      m5mols: Move the control handler initialization to probe()
      m5mols: Do not reset the configured pixel format when unexpected
      m5mols: Change auto exposure control default value to AUTO
      m5mols: Enable v4l subdev device node
      s5p-csis: Enable v4l subdev device node

 drivers/media/video/m5mols/m5mols.h         |   46 +++--
 drivers/media/video/m5mols/m5mols_capture.c |   83 +++-----
 drivers/media/video/m5mols/m5mols_core.c    |  288 +++++++++++++++------------
 drivers/media/video/m5mols/m5mols_reg.h     |  247 +++++++++--------------
 drivers/media/video/s5p-fimc/mipi-csis.c    |   22 ++
 drivers/media/video/s5p-fimc/mipi-csis.h    |    3 +
 6 files changed, 339 insertions(+), 350 deletions(-)


-- 
Regards,

Sylwester
