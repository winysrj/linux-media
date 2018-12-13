Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD0E9C65BAE
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 10:40:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A255620811
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 10:40:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A255620811
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728594AbeLMKkM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 05:40:12 -0500
Received: from mga01.intel.com ([192.55.52.88]:50877 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728537AbeLMKkM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 05:40:12 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2018 02:40:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,348,1539673200"; 
   d="scan'208";a="129600906"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga001.fm.intel.com with ESMTP; 13 Dec 2018 02:40:10 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id B07C7204CC;
        Thu, 13 Dec 2018 12:40:09 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gXOPX-00007E-8H; Thu, 13 Dec 2018 12:40:07 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, mchehab@kernel.org,
        laurent.pinchart@ideasonboard.com
Subject: [PATCH 1/3] videobuf2-core: Prevent size alignment wrapping buffer size to 0
Date:   Thu, 13 Dec 2018 12:40:04 +0200
Message-Id: <20181213104006.401-2-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20181213104006.401-1-sakari.ailus@linux.intel.com>
References: <20181213104006.401-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

PAGE_ALIGN() may wrap the buffer size around to 0. Prevent this by
checking that the aligned value is not smaller than the unaligned one.

Note on backporting to stable: the file used to be under
drivers/media/v4l2-core, it was moved to the current location after 4.14.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: stable@vger.kernel.org
---
 drivers/media/common/videobuf2/videobuf2-core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 0ca81d495bdaf..0234ddbfa4de2 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -207,6 +207,10 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 	for (plane = 0; plane < vb->num_planes; ++plane) {
 		unsigned long size = PAGE_ALIGN(vb->planes[plane].length);
 
+		/* Did it wrap around? */
+		if (size < vb->planes[plane].length)
+			goto free;
+
 		mem_priv = call_ptr_memop(vb, alloc,
 				q->alloc_devs[plane] ? : q->dev,
 				q->dma_attrs, size, q->dma_dir, q->gfp_flags);
-- 
2.11.0

