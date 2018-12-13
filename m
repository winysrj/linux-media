Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72682C67872
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 10:40:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AC8520811
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 10:40:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3AC8520811
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728610AbeLMKkO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 05:40:14 -0500
Received: from mga18.intel.com ([134.134.136.126]:44659 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728596AbeLMKkN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 05:40:13 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2018 02:40:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,348,1539673200"; 
   d="scan'208";a="301845978"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga006.fm.intel.com with ESMTP; 13 Dec 2018 02:40:11 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id 8C02B208B8;
        Thu, 13 Dec 2018 12:40:10 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gXOPY-00007K-87; Thu, 13 Dec 2018 12:40:08 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, mchehab@kernel.org,
        laurent.pinchart@ideasonboard.com
Subject: [PATCH 3/3] videobuf2-core.h: Document the alloc memop size argument as page aligned
Date:   Thu, 13 Dec 2018 12:40:06 +0200
Message-Id: <20181213104006.401-4-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20181213104006.401-1-sakari.ailus@linux.intel.com>
References: <20181213104006.401-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The size argument of the alloc memop, which allocates buffer memory, is
page aligned. Document it as such, as code elsewhere has not taken this
into account.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/media/videobuf2-core.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index e86981d615ae4..68b9fe660e4f1 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -54,7 +54,8 @@ struct vb2_threadio_data;
  *		will then be passed as @buf_priv argument to other ops in this
  *		structure. Additional gfp_flags to use when allocating the
  *		are also passed to this operation. These flags are from the
- *		gfp_flags field of vb2_queue.
+ *		gfp_flags field of vb2_queue. The size argument to this function
+ *		shall be *page aligned*.
  * @put:	inform the allocator that the buffer will no longer be used;
  *		usually will result in the allocator freeing the buffer (if
  *		no other users of this buffer are present); the @buf_priv
-- 
2.11.0

