Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3558C43387
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 14:13:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7499D206B7
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 14:13:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbfANONk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 09:13:40 -0500
Received: from mga06.intel.com ([134.134.136.31]:53546 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbfANONk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 09:13:40 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jan 2019 06:13:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,477,1539673200"; 
   d="scan'208";a="138099844"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga001.fm.intel.com with ESMTP; 14 Jan 2019 06:13:38 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id D4D752010E;
        Mon, 14 Jan 2019 16:13:37 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gj2zE-0007do-MM; Mon, 14 Jan 2019 16:13:08 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     rajmohan.mani@intel.com, yong.zhi@intel.com, hverkuil@xs4all.nl
Subject: [v4l-utils PATCH 0/4] Metadata output support for v4l2-ctl
Date:   Mon, 14 Jan 2019 16:13:04 +0200
Message-Id: <20190114141308.29329-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi folks,

This set adds metadata output buffer type support for v4l2-ctl. There are
a few more things done by the set, too:

- fixed static build instructions,

- fixed --all argument handling for metadata capture formats and

- include changes to videodev2.h brought by kernel patch I recently sent
  ("v4l: uAPI: V4L2_BUF_TYPE_META_OUTPUT is an output buffer type").

Sakari Ailus (4):
  Update static build instructions
  Sync the latest headers
  v4l2-ctl: Print metadata capture formats on --all
  v4l2-ctl: Add support for META_OUTPUT buffer type

 INSTALL                              |   8 +--
 include/linux/videodev2.h            |   3 +-
 utils/v4l2-ctl/Makefile.am           |   3 +-
 utils/v4l2-ctl/v4l2-ctl-common.cpp   |   3 +-
 utils/v4l2-ctl/v4l2-ctl-meta-out.cpp | 106 +++++++++++++++++++++++++++++++++++
 utils/v4l2-ctl/v4l2-ctl-meta.cpp     |  19 ++++---
 utils/v4l2-ctl/v4l2-ctl.cpp          |  17 ++++++
 utils/v4l2-ctl/v4l2-ctl.h            |  13 +++++
 8 files changed, 156 insertions(+), 16 deletions(-)
 create mode 100644 utils/v4l2-ctl/v4l2-ctl-meta-out.cpp

-- 
2.11.0

