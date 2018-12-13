Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4752C67839
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 10:40:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 841E920989
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 10:40:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 841E920989
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728598AbeLMKkM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 05:40:12 -0500
Received: from mga03.intel.com ([134.134.136.65]:36195 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728560AbeLMKkM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 05:40:12 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2018 02:40:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,348,1539673200"; 
   d="scan'208";a="118254260"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Dec 2018 02:40:10 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id 55CC620376;
        Thu, 13 Dec 2018 12:40:09 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gXOPW-00007C-P8; Thu, 13 Dec 2018 12:40:06 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, mchehab@kernel.org,
        laurent.pinchart@ideasonboard.com
Subject: [PATCH 0/3] Videobuf2 corner case fixes
Date:   Thu, 13 Dec 2018 12:40:03 +0200
Message-Id: <20181213104006.401-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi folks,

Most drivers already have limits to size such that you don't hit these,
but if you do, then mayhem will follow. The two first are cc'd to stable.

Sakari Ailus (3):
  videobuf2-core: Prevent size alignment wrapping buffer size to 0
  videobuf2-dma-sg: Prevent size from overflowing
  videobuf2-core.h: Document the alloc memop size argument as page
    aligned

 drivers/media/common/videobuf2/videobuf2-core.c   | 4 ++++
 drivers/media/common/videobuf2/videobuf2-dma-sg.c | 2 +-
 include/media/videobuf2-core.h                    | 3 ++-
 3 files changed, 7 insertions(+), 2 deletions(-)

-- 
2.11.0

