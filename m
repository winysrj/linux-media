Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54478C282CB
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 11:24:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FE3621924
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 11:24:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbfBHLY2 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 06:24:28 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45418 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726162AbfBHLY2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Feb 2019 06:24:28 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 68923634C7B
        for <linux-media@vger.kernel.org>; Fri,  8 Feb 2019 13:24:14 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1gs4GU-0000nZ-83
        for linux-media@vger.kernel.org; Fri, 08 Feb 2019 13:24:14 +0200
Date:   Fri, 8 Feb 2019 13:24:14 +0200
From:   Sakari Ailus <sakari.ailus@iki.fi>
To:     linux-media@vger.kernel.org
Subject: [GIT PULL for 5.1] Sensor and imgu driver patches
Message-ID: <20190208112414.aqeyld5l6t3khvdw@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro,

Here's the next set of ov5640 and imgu driver patches.

Please pull.


The following changes since commit 6fd369dd1cb65a032f1ab9227033ecb7b759656d:

  media: vimc: fill in bus_info in media_device_info (2019-02-07 12:38:59 -0500)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git tags/for-5.1-4-sign

for you to fetch changes up to 7bdac7ae08dbc6ca17d617a33bd1aa7b1cf2bf19:

  media: ipu3-imgu: Prefix functions with imgu_* instead of ipu3_* (2019-02-08 13:04:57 +0200)

----------------------------------------------------------------
sensor + ipu3 for 5.1

----------------------------------------------------------------
Chen-Yu Tsai (6):
      media: ov5640: Move test_pattern_menu before ov5640_set_ctrl_test_pattern
      media: ov5640: Add register definition for test pattern register
      media: ov5640: Disable transparent feature for test pattern
      media: ov5640: Add three more test patterns
      media: ov5640: Set JPEG output timings when outputting JPEG data
      media: ov5640: Consolidate JPEG compression mode setting

Jagan Teki (1):
      media: ov5640: Fix set 15fps regression

Loic Poulain (1):
      media: i2c: ov5640: Fix post-reset delay

Yong Zhi (1):
      media: ipu3-imgu: Prefix functions with imgu_* instead of ipu3_*

 drivers/media/i2c/ov5640.c                   |  99 ++++--
 drivers/staging/media/ipu3/TODO              |   3 -
 drivers/staging/media/ipu3/ipu3-css-fw.c     |  18 +-
 drivers/staging/media/ipu3/ipu3-css-fw.h     |   8 +-
 drivers/staging/media/ipu3/ipu3-css-params.c | 270 ++++++++--------
 drivers/staging/media/ipu3/ipu3-css-params.h |   8 +-
 drivers/staging/media/ipu3/ipu3-css-pool.c   |  32 +-
 drivers/staging/media/ipu3/ipu3-css-pool.h   |  30 +-
 drivers/staging/media/ipu3/ipu3-css.c        | 454 +++++++++++++--------------
 drivers/staging/media/ipu3/ipu3-css.h        |  92 +++---
 drivers/staging/media/ipu3/ipu3-dmamap.c     |  42 +--
 drivers/staging/media/ipu3/ipu3-dmamap.h     |  14 +-
 drivers/staging/media/ipu3/ipu3-mmu.c        | 120 +++----
 drivers/staging/media/ipu3/ipu3-mmu.h        |  18 +-
 drivers/staging/media/ipu3/ipu3-tables.c     |  50 +--
 drivers/staging/media/ipu3/ipu3-tables.h     |  54 ++--
 drivers/staging/media/ipu3/ipu3-v4l2.c       | 290 ++++++++---------
 drivers/staging/media/ipu3/ipu3.c            |  86 ++---
 drivers/staging/media/ipu3/ipu3.h            |  18 +-
 19 files changed, 881 insertions(+), 825 deletions(-)

-- 
Sakari Ailus
