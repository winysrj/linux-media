Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5326C169C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 08:42:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AE3021919
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 08:42:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727238AbfBHImk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 03:42:40 -0500
Received: from mga06.intel.com ([134.134.136.31]:21748 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726115AbfBHImj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Feb 2019 03:42:39 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Feb 2019 00:42:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,347,1544515200"; 
   d="scan'208";a="273445209"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga004.jf.intel.com with ESMTP; 08 Feb 2019 00:42:38 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id 6A7B9201AF;
        Fri,  8 Feb 2019 10:42:37 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gs1jH-0002bc-NE; Fri, 08 Feb 2019 10:41:47 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl
Subject: [PATCH 0/4] Move SoC camera to staging, depend on BROKEN
Date:   Fri,  8 Feb 2019 10:41:43 +0200
Message-Id: <20190208084147.9973-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi all,

This series moves the SoC camera framework and the remaining drivers under
the staging tree and makes them depend on BROKEN.

The files could be later removed.

Sakari Ailus (4):
  soc_camera: Move to the staging tree
  soc_camera: Move the imx074 under soc_camera directory
  soc_camera: Move the mt9t031 under soc_camera directory
  soc_camera: Depend on BROKEN

 drivers/media/i2c/Kconfig                           |  8 --------
 drivers/media/i2c/Makefile                          |  1 -
 drivers/media/platform/Kconfig                      |  1 -
 drivers/media/platform/Makefile                     |  2 --
 drivers/media/platform/soc_camera/Kconfig           |  8 --------
 drivers/media/platform/soc_camera/Makefile          |  1 -
 drivers/staging/media/Kconfig                       |  6 ++----
 drivers/staging/media/Makefile                      |  3 +--
 drivers/staging/media/imx074/Kconfig                |  5 -----
 drivers/staging/media/imx074/Makefile               |  1 -
 drivers/staging/media/imx074/TODO                   |  5 -----
 .../{media/i2c => staging/media}/soc_camera/Kconfig | 21 +++++++++++++++++++++
 .../i2c => staging/media}/soc_camera/Makefile       |  3 +++
 .../staging/media/{imx074 => soc_camera}/imx074.c   |  0
 .../staging/media/{mt9t031 => soc_camera}/mt9t031.c |  0
 .../media}/soc_camera/soc_camera.c                  |  0
 .../media}/soc_camera/soc_mediabus.c                |  0
 .../i2c => staging/media}/soc_camera/soc_mt9v022.c  |  0
 .../i2c => staging/media}/soc_camera/soc_ov5642.c   |  0
 .../i2c => staging/media}/soc_camera/soc_ov9740.c   |  0
 20 files changed, 27 insertions(+), 38 deletions(-)
 delete mode 100644 drivers/media/platform/soc_camera/Kconfig
 delete mode 100644 drivers/media/platform/soc_camera/Makefile
 delete mode 100644 drivers/staging/media/imx074/Kconfig
 delete mode 100644 drivers/staging/media/imx074/Makefile
 delete mode 100644 drivers/staging/media/imx074/TODO
 rename drivers/{media/i2c => staging/media}/soc_camera/Kconfig (57%)
 rename drivers/{media/i2c => staging/media}/soc_camera/Makefile (55%)
 rename drivers/staging/media/{imx074 => soc_camera}/imx074.c (100%)
 rename drivers/staging/media/{mt9t031 => soc_camera}/mt9t031.c (100%)
 rename drivers/{media/platform => staging/media}/soc_camera/soc_camera.c (100%)
 rename drivers/{media/platform => staging/media}/soc_camera/soc_mediabus.c (100%)
 rename drivers/{media/i2c => staging/media}/soc_camera/soc_mt9v022.c (100%)
 rename drivers/{media/i2c => staging/media}/soc_camera/soc_ov5642.c (100%)
 rename drivers/{media/i2c => staging/media}/soc_camera/soc_ov9740.c (100%)

-- 
2.11.0

