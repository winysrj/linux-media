Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:20588 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab1IVQmh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Sep 2011 12:42:37 -0400
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LRX00BQONR0Q0@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 22 Sep 2011 17:42:36 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LRX00F0NNQZA3@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 22 Sep 2011 17:42:36 +0100 (BST)
Date: Thu, 22 Sep 2011 18:42:29 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v4 0/2] v4l: Add media bus FIELD signal polarity flags
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, laurent.pinchart@ideasonboard.com,
	kyungmin.park@samsung.com, g.liakhovetski@gmx.de,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
Message-id: <1316709751-29922-1-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This is an updated version of the change set adding support for FIELD signal
polarity configuration through the parallel media bus flags.
The second patch just converts s5p-fimc driver to use generic flags.

If there is no further comments I'd like to send Mauro a pull request for these
patches.

Changes since v1:
 - dropped V4L2_MBUS_HREF* definitions, added comment on usage of
   V4L2_MBUS_[HV]SYNC* flags for [HV]REF signals
 - added V4L2_MBUS_FIELD*
 - modified the second patch to use HSYNC flags only

Changes since v2/3:
 - renamed V4L2_MBUS_FIELD_ACTIVE_[HIGH/LOW] to V4L2_MBUS_FIELD_EVEN_[HIGH/LOW]
   and updated the comments

Sylwester Nawrocki (2):
  v4l2: Add polarity flag definitons for parallel bus FIELD signal
  s5p-fimc: Convert to use generic media bus polarity flags

 drivers/media/video/s5p-fimc/fimc-reg.c  |   14 +++++++++-----
 drivers/media/video/s5p-fimc/regs-fimc.h |    1 +
 include/media/s5p_fimc.h                 |    7 +------
 include/media/v4l2-mediabus.h            |   12 ++++++++++--
 4 files changed, 21 insertions(+), 13 deletions(-)


Thanks,
--
Sylwester Nawrocki
Samsung Poland R&D Center
