Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 304C4C65BAE
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 10:40:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA47C21104
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 10:40:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA47C21104
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbeLMKkN (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 05:40:13 -0500
Received: from mga02.intel.com ([134.134.136.20]:46204 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728596AbeLMKkM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 05:40:12 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2018 02:40:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,348,1539673200"; 
   d="scan'208";a="303495495"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga005.fm.intel.com with ESMTP; 13 Dec 2018 02:40:10 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id 1FD43206FC;
        Thu, 13 Dec 2018 12:40:10 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gXOPX-00007H-R9; Thu, 13 Dec 2018 12:40:07 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, mchehab@kernel.org,
        laurent.pinchart@ideasonboard.com
Subject: [PATCH 2/3] videobuf2-dma-sg: Prevent size from overflowing
Date:   Thu, 13 Dec 2018 12:40:05 +0200
Message-Id: <20181213104006.401-3-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20181213104006.401-1-sakari.ailus@linux.intel.com>
References: <20181213104006.401-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

buf->size is an unsigned long; casting that to int will lead to an
overflow if buf->size exceeds INT_MAX.

Fix this by changing the type to unsigned long instead. This is possible
as the buf->size is always aligned to PAGE_SIZE, and therefore the size
will never have values lesser than 0.

Note on backporting to stable: the file used to be under
drivers/media/v4l2-core, it was moved to the current location after 4.14.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: stable@vger.kernel.org
---
 drivers/media/common/videobuf2/videobuf2-dma-sg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-dma-sg.c b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
index 015e737095cdd..e9bfea986cc47 100644
--- a/drivers/media/common/videobuf2/videobuf2-dma-sg.c
+++ b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
@@ -59,7 +59,7 @@ static int vb2_dma_sg_alloc_compacted(struct vb2_dma_sg_buf *buf,
 		gfp_t gfp_flags)
 {
 	unsigned int last_page = 0;
-	int size = buf->size;
+	unsigned long size = buf->size;
 
 	while (size > 0) {
 		struct page *pages;
-- 
2.11.0

