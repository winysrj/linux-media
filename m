Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 881DAC4360F
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 11:20:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 578CE21902
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 11:20:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbfBTLU6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 06:20:58 -0500
Received: from mga03.intel.com ([134.134.136.65]:37280 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726414AbfBTLU5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 06:20:57 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Feb 2019 03:20:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,390,1544515200"; 
   d="scan'208";a="116357047"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga007.jf.intel.com with ESMTP; 20 Feb 2019 03:20:55 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id 3BC252063E;
        Wed, 20 Feb 2019 13:20:54 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gwPus-00023y-84; Wed, 20 Feb 2019 13:19:54 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, mchehab@kernel.org, rajmohan.mani@intel.com
Subject: [PATCH 0/5] Fix most ImgU driver compiler / checker warnings
Date:   Wed, 20 Feb 2019 13:19:48 +0200
Message-Id: <20190220111953.7886-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro, Hans,

This set addresses most of the compiler / checker warnings from the ImgU
driver. There are a few about stack usage from the compiler left but those
were not trivial to address so I postponed that. There are also a few
about memset but Hans suggested addressing that by increasing the maximum
size. I guess it wouldn't benefit anyone to split those memsets into
two...

Sakari Ailus (5):
  staging: imgu: Switch to __aligned() from __attribute__((aligned()))
  staging: imgu: Fix struct ipu3_uapi_awb_fr_config_s alignment
  staging: imgu: Remove redundant checks
  staging: imgu: Address compiler / checker warnings in MMU code
  Revert "media: ipu3: shut up warnings produced with W=1"

 drivers/staging/media/ipu3/Makefile             |  6 --
 drivers/staging/media/ipu3/TODO                 |  2 -
 drivers/staging/media/ipu3/include/intel-ipu3.h | 74 ++++++++++++-------------
 drivers/staging/media/ipu3/ipu3-css-fw.c        |  6 +-
 drivers/staging/media/ipu3/ipu3-mmu.c           | 39 +++++++++++--
 5 files changed, 74 insertions(+), 53 deletions(-)

-- 
2.11.0

