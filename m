Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F8EEC169C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 03:37:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 255932147C
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 03:37:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbfBHDhr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 22:37:47 -0500
Received: from mga05.intel.com ([192.55.52.43]:51816 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726896AbfBHDhr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Feb 2019 22:37:47 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Feb 2019 19:37:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,346,1544515200"; 
   d="scan'208";a="142566575"
Received: from orsmsx109.amr.corp.intel.com ([10.22.240.7])
  by fmsmga004.fm.intel.com with ESMTP; 07 Feb 2019 19:37:46 -0800
Received: from vkasired-desk2.fm.intel.com (10.22.254.138) by
 ORSMSX109.amr.corp.intel.com (10.22.240.7) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Thu, 7 Feb 2019 19:37:46 -0800
From:   Vivek Kasireddy <vivek.kasireddy@intel.com>
To:     <linux-media@vger.kernel.org>
CC:     Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: [PATCH 0/4] Add support for 32-bit packed YUV formats
Date:   Thu, 7 Feb 2019 19:18:42 -0800
Message-ID: <20190208031846.14453-1-vivek.kasireddy@intel.com>
X-Mailer: git-send-email 2.14.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.22.254.138]
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This patch series adds support for formats that can be used directly
by other drivers such as i915 drm driver. Also, the buffers generated
by vivid in one of these formats using tpg can be used by the Weston
compositor as textures.

Vivek Kasireddy (4):
  media: v4l: Add 32-bit packed YUV formats
  media: v4l2-tpg-core: Add support for 32-bit packed YUV formats
  media: vivid: Add definitions for the 32-bit packed YUV formats
  media: imx-pxp: Start using the format VUYA32 instead of YUV32

 Documentation/media/uapi/v4l/pixfmt-packed-yuv.rst | 170 ++++++++++++++++++++-
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c      |  13 ++
 drivers/media/platform/imx-pxp.c                   |   8 +-
 drivers/media/platform/vivid/vivid-vid-common.c    |  30 ++++
 drivers/media/v4l2-core/v4l2-ioctl.c               |   4 +
 include/uapi/linux/videodev2.h                     |   4 +
 6 files changed, 224 insertions(+), 5 deletions(-)

-- 
2.14.5

