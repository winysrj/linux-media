Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:62957 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756725Ab1ISQlp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Sep 2011 12:41:45 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LRS000WZ3PJ8360@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 19 Sep 2011 17:41:43 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LRS002J13PJ2S@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 19 Sep 2011 17:41:43 +0100 (BST)
Date: Mon, 19 Sep 2011 18:41:35 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 0/2] v4l: Add media bus polarity flags for FIELD signal
In-reply-to: <alpine.DEB.2.00.1109171423460.28766@axis700.grange>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, laurent.pinchart@ideasonboard.com,
	kyungmin.park@samsung.com, g.liakhovetski@gmx.de,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
Message-id: <1316450497-6723-1-git-send-email-s.nawrocki@samsung.com>
References: <alpine.DEB.2.00.1109171423460.28766@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

The following patch adds support for FIELD signal polarity configuration
through the parallel media bus flags.
The second one just converts s5p-fimc driver to use generic flags.

Changes since v2:
 - dropped V4L2_MBUS_HREF* definitions, added comment on usage of
   V4L2_MBUS_[HV]SYNC* flags for [HV]REF signals
 - added V4L2_MBUS_FIELD*
 - modified the second patch to use HSYNC flags only

Sylwester Nawrocki (2):
  v4l2: Add the polarity flags for parallel camera bus FIELD signal
  s5p-fimc: Convert to use generic media bus polarity flags

 drivers/media/video/s5p-fimc/fimc-reg.c  |   14 +++++++++-----
 drivers/media/video/s5p-fimc/regs-fimc.h |    1 +
 include/media/s5p_fimc.h                 |    7 +------
 include/media/v4l2-mediabus.h            |   11 +++++++++--
 4 files changed, 20 insertions(+), 13 deletions(-)


Thanks,
--
Sylwester Nawrocki
Samsung Poland R&D Center

