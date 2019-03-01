Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51DA1C10F03
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 11:24:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B5CA20818
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 11:24:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732784AbfCALYK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 06:24:10 -0500
Received: from mga03.intel.com ([134.134.136.65]:13529 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732302AbfCALYK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Mar 2019 06:24:10 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Mar 2019 03:24:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,427,1544515200"; 
   d="scan'208";a="324477274"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga005.fm.intel.com with ESMTP; 01 Mar 2019 03:24:07 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id BAC502010E;
        Fri,  1 Mar 2019 13:24:06 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gzgGm-0006LJ-U0; Fri, 01 Mar 2019 13:24:01 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, mchehab@kernel.org, rajmohan.mani@intel.com
Subject: [PATCH v2 0/4] Fix most ImgU driver compiler / checker warnings           
Date:   Fri,  1 Mar 2019 13:23:56 +0200
Message-Id: <20190301112400.24339-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
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

since v2:

- Drop __attribute__((aligned())) -> __aligned() change for now

- Align awb_fr field in struct ipu3_uapi_acc_param

- Add Raj's Tested-by: tag

Sakari Ailus (4):
  staging: imgu: Address a compiler warning on alignment
  staging: imgu: Remove redundant checks
  staging: imgu: Address compiler / checker warnings in MMU code
  Revert "media: ipu3: shut up warnings produced with W=1"

 drivers/staging/media/ipu3/Makefile             |  6 ----
 drivers/staging/media/ipu3/TODO                 |  2 --
 drivers/staging/media/ipu3/include/intel-ipu3.h |  2 +-
 drivers/staging/media/ipu3/ipu3-css-fw.c        |  6 ++--
 drivers/staging/media/ipu3/ipu3-mmu.c           | 39 ++++++++++++++++++++++---
 5 files changed, 38 insertions(+), 17 deletions(-)

-- 
2.11.0

