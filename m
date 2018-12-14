Return-Path: <SRS0=AYlV=OX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8A48C67839
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 12:28:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86F0020892
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 12:28:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 86F0020892
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731474AbeLNM2B (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 14 Dec 2018 07:28:01 -0500
Received: from mga01.intel.com ([192.55.52.88]:22009 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730438AbeLNM2B (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Dec 2018 07:28:01 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Dec 2018 04:28:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,352,1539673200"; 
   d="scan'208";a="101524817"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga008.jf.intel.com with ESMTP; 14 Dec 2018 04:27:59 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id 1CDBA2029C;
        Fri, 14 Dec 2018 14:27:58 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gXmZO-0008WM-LP; Fri, 14 Dec 2018 14:27:54 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     mchehab@kernel.org
Cc:     linux-media@vger.kernel.org
Subject: [PATCH 0/2] staging/ipu3-imgu fixes
Date:   Fri, 14 Dec 2018 14:27:52 +0200
Message-Id: <20181214122754.32714-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro,

These two patches should fix the most pressing issues, will send
checkpatch.pl fixes later.

Sakari Ailus (2):
  Documentation: staging/ipu3-imgu: Add license information
  Documentation: staging/ipu3-imgu: Fix reference file name

 Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst | 9 ++++++++-
 Documentation/media/v4l-drivers/ipu3.rst                | 4 +++-
 2 files changed, 11 insertions(+), 2 deletions(-)

-- 
2.11.0

