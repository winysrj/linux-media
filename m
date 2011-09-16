Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:58644 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab1IPR2t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Sep 2011 13:28:49 -0400
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LRM0001BLVZDO@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 16 Sep 2011 18:28:47 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LRM00KWDLVYOD@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 16 Sep 2011 18:28:47 +0100 (BST)
Date: Fri, 16 Sep 2011 19:28:41 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 0/2] v4l: Add media bus polarity flags for HREF signal
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	g.liakhovetski@gmx.de, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Message-id: <1316194123-21185-1-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

The following patche adds support for HREF signal polarity configuration
through the parallel media bus flags.
The second one just converts s5p-fimc driver to use generic flags.


Sylwester Nawrocki (2):
  v4l2: Add the parallel bus HREF signal polarity flags
  s5p-fimc: Convert to use generic bus polarity flags

 drivers/media/video/s5p-fimc/fimc-reg.c |    8 ++++----
 include/media/s5p_fimc.h                |    7 +------
 include/media/v4l2-mediabus.h           |   14 ++++++++------
 3 files changed, 13 insertions(+), 16 deletions(-)


Thanks,
--
Sylwester Nawrocki
Samsung Poland R&D Center
