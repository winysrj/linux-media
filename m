Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:9064 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab2CBCPo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Mar 2012 21:15:44 -0500
Received: from epcpsbgm2.samsung.com (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0M08009G8JKSCED0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 02 Mar 2012 11:15:43 +0900 (KST)
Received: from jtppark ([12.23.118.214])
 by mmp2.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0M0800286JM7B0G0@mmp2.samsung.com>
 for linux-media@vger.kernel.org; Fri, 02 Mar 2012 11:15:43 +0900 (KST)
Reply-to: jtp.park@samsung.com
From: Jeongtae Park <jtp.park@samsung.com>
To: linux-media@vger.kernel.org, 'Kamil Debski' <k.debski@samsung.com>
Cc: janghyuck.kim@samsung.com, jaeryul.oh@samsung.com,
	'Marek Szyprowski' <m.szyprowski@samsung.com>
Subject: [PATCH 0/3] Multi Format Codec 6.x driver for Exynos5
Date: Fri, 02 Mar 2012 11:15:43 +0900
Message-id: <007001ccf81a$5efa1e70$1cee5b50$%park@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Everyone,

This patch series is the 1st version of the MFC 6.x driver based on
MFC 5.1 driver
I would be grateful for your comments.

This patch series contains:

[PATCH 1/3] v4l: add contorl definitions for codec devices.
[PATCH 2/3] v4l2-ctrl: add codec controls support to the control framework
[PATCH 3/3] MFC: update MFC v4l2 driver to support MFC6.x

Best regards,
Jeongtae Park

Patch summary:

Jeongtae Park (3):
	v4l: add contorl definitions for codec devices.
	v4l2-ctrl: add codec controls support to the control framework
	MFC: update MFC v4l2 driver to support MFC6.x

drivers/media/video/Kconfig                  |   15 +-
drivers/media/video/s5p-mfc/Makefile         |    7 +-
drivers/media/video/s5p-mfc/regs-mfc-v6.h    |  671 +++++++++++
drivers/media/video/s5p-mfc/regs-mfc.h       |   29 +
drivers/media/video/s5p-mfc/s5p_mfc.c        |  157 ++-
drivers/media/video/s5p-mfc/s5p_mfc_cmd.c    |    4 +-
drivers/media/video/s5p-mfc/s5p_mfc_cmd.h    |    3 +
drivers/media/video/s5p-mfc/s5p_mfc_cmd_v6.c |  129 ++
drivers/media/video/s5p-mfc/s5p_mfc_common.h |  125 ++-
drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c   |  113 ++-
drivers/media/video/s5p-mfc/s5p_mfc_dec.c    |  212 +++-
drivers/media/video/s5p-mfc/s5p_mfc_enc.c    |  364 +++++--
drivers/media/video/s5p-mfc/s5p_mfc_intr.c   |    1 -
drivers/media/video/s5p-mfc/s5p_mfc_opr.c    |  266 +++--
drivers/media/video/s5p-mfc/s5p_mfc_opr.h    |   20 +-
drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.c | 1670 ++++++++++++++++++++++++++
drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.h |  137 +++
drivers/media/video/s5p-mfc/s5p_mfc_shm.c    |   27 +-
drivers/media/video/s5p-mfc/s5p_mfc_shm.h    |   13 +-
drivers/media/video/v4l2-ctrls.c             |   41 +-
include/linux/videodev2.h                    |   51 +-
21 files changed, 3675 insertions(+), 380 deletions(-)
create mode 100644 drivers/media/video/s5p-mfc/regs-mfc-v6.h
create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_cmd_v6.c
create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.c
create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr_v6.h

