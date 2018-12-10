Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E3FFC5CFFE
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 21:20:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29546204FD
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 21:20:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 29546204FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbeLJVUi (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 16:20:38 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59428 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727709AbeLJVUi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 16:20:38 -0500
Received: from lanttu.localdomain (lanttu.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::c1:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 69EC1634C7F;
        Mon, 10 Dec 2018 23:20:32 +0200 (EET)
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     yong.zhi@intel.com
Subject: [v4l-utils PATCH 0/2] META_OUTPUT buffer type support for v4l2-compliance
Date:   Mon, 10 Dec 2018 23:20:34 +0200
Message-Id: <20181210212036.16643-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi all,

Here are the patches needed to support the META_OUTPUT queue type for
v4l2-compliance. The patch that adds the support is preceded by the kernel
header update --- the headers have been recently updated and there were
no other changes.

Sakari Ailus (1):
  Update uAPI headers from the kernel

Yong Zhi (1):
  v4l2-compliance: Add support for metadata output

 include/linux/videodev2.h                   |  2 ++
 utils/common/v4l-helpers.h                  | 14 +++++++++++++-
 utils/common/v4l2-info.cpp                  |  4 ++++
 utils/v4l2-compliance/v4l2-compliance.cpp   |  7 ++++---
 utils/v4l2-compliance/v4l2-compliance.h     |  2 +-
 utils/v4l2-compliance/v4l2-test-formats.cpp |  7 +++++++
 6 files changed, 31 insertions(+), 5 deletions(-)

-- 
2.11.0

