Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D13DC282CB
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 21:11:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EEA82175B
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 21:11:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbfBEVLc (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Feb 2019 16:11:32 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:41968 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbfBEVLb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2019 16:11:31 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 8AC5D280229
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH] media: vb2: Fix buf_out_validate documentation
Date:   Tue,  5 Feb 2019 18:11:15 -0300
Message-Id: <20190205211115.23780-1-ezequiel@collabora.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The .buf_out_validate callback is mandatory for OUTPUT
queues. Mark it as such in the callback's doc.

Fixes: 28d77c21cb ("media: vb2: add buf_out_validate callback")
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 include/media/videobuf2-core.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 4849b865b908..06142c1469cc 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -345,7 +345,8 @@ struct vb2_buffer {
  *			waiting for a new buffer to arrive.
  * @buf_out_validate:	called when the output buffer is prepared or queued
  *			to a request; drivers can use this to validate
- *			userspace-provided information; optional.
+ *			userspace-provided information; this is required only
+ *			for OUTPUT queues.
  * @buf_init:		called once after allocating a buffer (in MMAP case)
  *			or after acquiring a new USERPTR buffer; drivers may
  *			perform additional buffer-related initialization;
-- 
2.20.1

