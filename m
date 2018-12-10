Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CC17C04EB8
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 12:22:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C9B92086D
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 12:22:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4C9B92086D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbeLJMWT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 07:22:19 -0500
Received: from mga11.intel.com ([192.55.52.93]:55099 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727074AbeLJMWT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 07:22:19 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Dec 2018 04:22:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,338,1539673200"; 
   d="scan'208";a="109168997"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga003.jf.intel.com with ESMTP; 10 Dec 2018 04:22:17 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id 358FE205E8;
        Mon, 10 Dec 2018 14:22:16 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gWKZW-0006v3-S1; Mon, 10 Dec 2018 14:22:03 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     yong.zhi@intel.com, tfiga@chromium.org, rajmohan.mani@intel.com
Subject: [PATCH 1/1] ipu3-imgu: Fix compiler warnings
Date:   Mon, 10 Dec 2018 14:22:02 +0200
Message-Id: <20181210122202.26558-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Address a few false positive compiler warnings related to uninitialised
variables. While at it, use bool where bool is needed and %u to print an
unsigned integer.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/staging/media/ipu3/ipu3.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/ipu3/ipu3.c b/drivers/staging/media/ipu3/ipu3.c
index b7886edeb01b7..d521b3afb8b1a 100644
--- a/drivers/staging/media/ipu3/ipu3.c
+++ b/drivers/staging/media/ipu3/ipu3.c
@@ -228,7 +228,6 @@ int imgu_queue_buffers(struct imgu_device *imgu, bool initial, unsigned int pipe
 {
 	unsigned int node;
 	int r = 0;
-	struct imgu_buffer *ibuf;
 	struct imgu_media_pipe *imgu_pipe = &imgu->imgu_pipe[pipe];
 
 	if (!ipu3_css_is_streaming(&imgu->css))
@@ -250,7 +249,8 @@ int imgu_queue_buffers(struct imgu_device *imgu, bool initial, unsigned int pipe
 		} else if (imgu_pipe->queue_enabled[node]) {
 			struct ipu3_css_buffer *buf =
 				imgu_queue_getbuf(imgu, node, pipe);
-			int dummy;
+			struct imgu_buffer *ibuf = NULL;
+			bool dummy;
 
 			if (!buf)
 				break;
@@ -263,7 +263,7 @@ int imgu_queue_buffers(struct imgu_device *imgu, bool initial, unsigned int pipe
 				ibuf = container_of(buf, struct imgu_buffer,
 						    css_buf);
 			dev_dbg(&imgu->pci_dev->dev,
-				"queue %s %s buffer %d to css da: 0x%08x\n",
+				"queue %s %s buffer %u to css da: 0x%08x\n",
 				dummy ? "dummy" : "user",
 				imgu_node_map[node].name,
 				dummy ? 0 : ibuf->vid_buf.vbb.vb2_buf.index,
@@ -479,7 +479,7 @@ static irqreturn_t imgu_isr_threaded(int irq, void *imgu_ptr)
 	do {
 		u64 ns = ktime_get_ns();
 		struct ipu3_css_buffer *b;
-		struct imgu_buffer *buf;
+		struct imgu_buffer *buf = NULL;
 		unsigned int node, pipe;
 		bool dummy;
 
-- 
2.11.0

