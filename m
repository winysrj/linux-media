Return-Path: <SRS0=XPZo=QL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 239AAC282C4
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 17:02:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F270E2087C
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 17:02:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728770AbfBDRCM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Feb 2019 12:02:12 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60080 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727626AbfBDRCM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Feb 2019 12:02:12 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id D36FB634C7E
        for <linux-media@vger.kernel.org>; Mon,  4 Feb 2019 19:00:55 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1gqhc8-0002ri-R3
        for linux-media@vger.kernel.org; Mon, 04 Feb 2019 19:00:56 +0200
Date:   Mon, 4 Feb 2019 19:00:56 +0200
From:   Sakari Ailus <sakari.ailus@iki.fi>
To:     linux-media@vger.kernel.org
Subject: [GIT PULL for 5.1] Ipu3 patches
Message-ID: <20190204170056.geczaf7toujpq4bk@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro,

Here are a few ipu3 driver fixes for 5.1.

Please pull.


The following changes since commit f0ef022c85a899bcc7a1b3a0955c78a3d7109106:

  media: vim2m: allow setting the default transaction time via parameter (2019-01-31 17:17:08 -0200)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git tags/for-5.1-3-sign

for you to fetch changes up to bfbf2c969375ca43333ddc891791cee6e5397468:

  media: staging: intel-ipu3: fix unsigned comparison with < 0 (2019-02-04 18:03:25 +0200)

----------------------------------------------------------------
ipu3 stuff

----------------------------------------------------------------
Colin Ian King (1):
      media: staging: intel-ipu3: fix unsigned comparison with < 0

Yong Zhi (2):
      media: ipu3-imgu: Use MENU type for mode control
      media: ipu3-imgu: Remove dead code for NULL check

 drivers/staging/media/ipu3/TODO                 |  2 --
 drivers/staging/media/ipu3/include/intel-ipu3.h |  6 ------
 drivers/staging/media/ipu3/ipu3-css.c           |  8 ++++----
 drivers/staging/media/ipu3/ipu3-v4l2.c          | 15 +++++++++++----
 drivers/staging/media/ipu3/ipu3.c               | 11 +++++------
 5 files changed, 20 insertions(+), 22 deletions(-)

-- 
Sakari Ailus
