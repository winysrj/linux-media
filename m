Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB53AC43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 08:58:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2DD32183F
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 08:58:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbfAHI6l (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 03:58:41 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33900 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727435AbfAHI6l (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Jan 2019 03:58:41 -0500
Received: from lanttu.localdomain (unknown [IPv6:2001:1bc8:1a6:d3d5::e1:1002])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 07ECD634C7F;
        Tue,  8 Jan 2019 10:57:27 +0200 (EET)
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, mchehab@kernel.org,
        laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 0/3] Videobuf2 corner case fixes
Date:   Tue,  8 Jan 2019 10:58:33 +0200
Message-Id: <20190108085836.9376-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi all,

Here's a second version of the set fixing a few videobuf2 corner cases.
Most drivers have limits for the size already but not necessarily all of
them.

since v1:

- Add a sanity check for alignment in vb2_dma_sg_alloc_compacted.

- Add a comment in __vb2_buf_mem_alloc noting that the size shall be page
  aligned.

Sakari Ailus (3):
  videobuf2-core: Prevent size alignment wrapping buffer size to 0
  videobuf2-dma-sg: Prevent size from overflowing
  videobuf2-core.h: Document the alloc memop size argument as page
    aligned

 drivers/media/common/videobuf2/videobuf2-core.c   | 5 +++++
 drivers/media/common/videobuf2/videobuf2-dma-sg.c | 5 ++++-
 include/media/videobuf2-core.h                    | 3 ++-
 3 files changed, 11 insertions(+), 2 deletions(-)

-- 
2.11.0

