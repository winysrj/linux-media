Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52694 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab2HaNSI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Aug 2012 09:18:08 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Pawel Osciak <p.osciak@samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] v4l2 mem2mem
Date: Fri, 31 Aug 2012 15:18:02 +0200
Message-Id: <1346419084-10879-1-git-send-email-s.hauer@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Two small patches, one fix and one more or less cosmetic patch for the
v4l2 mem2mem framework.

Comments welcome.

Thanks,
 Sascha

----------------------------------------------------------------
Sascha Hauer (2):
      media v4l2-mem2mem: Use list_first_entry
      media v4l2-mem2mem: fix src/out and dst/cap num_rdy

 drivers/media/video/v4l2-mem2mem.c |    6 +++---
 include/media/v4l2-mem2mem.h       |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)
