Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44274 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755860AbaICUd1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:33:27 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 02/46] [media] marvel-ccic: don't initialize static vars with 0
Date: Wed,  3 Sep 2014 17:32:34 -0300
Message-Id: <a7459a9d3ab932209e3340d5ae4dadf73147e8d5.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

alloc_bufs_at_read is static. No need to initialize with
zero, as the Kernel will cleanup the data memory already.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index be4b51212106..7a86c77bffa0 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -67,7 +67,7 @@ MODULE_PARM_DESC(dma_buf_size,
 		"parameters require larger buffers, an attempt to reallocate "
 		"will be made.");
 #else /* MCAM_MODE_VMALLOC */
-static const bool alloc_bufs_at_read = 0;
+static const bool alloc_bufs_at_read;
 static const int n_dma_bufs = 3;  /* Used by S/G_PARM */
 #endif /* MCAM_MODE_VMALLOC */
 
-- 
1.9.3

