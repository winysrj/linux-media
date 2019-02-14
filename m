Return-Path: <SRS0=jAfH=QV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2448DC43381
	for <linux-media@archiver.kernel.org>; Thu, 14 Feb 2019 11:32:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF3A22070D
	for <linux-media@archiver.kernel.org>; Thu, 14 Feb 2019 11:32:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732978AbfBNLc5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Feb 2019 06:32:57 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41768 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727231AbfBNLc4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Feb 2019 06:32:56 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 3BAE4634C7B
        for <linux-media@vger.kernel.org>; Thu, 14 Feb 2019 13:32:19 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1guFFb-0001k0-1B
        for linux-media@vger.kernel.org; Thu, 14 Feb 2019 13:32:19 +0200
Date:   Thu, 14 Feb 2019 13:32:18 +0200
From:   Sakari Ailus <sakari.ailus@iki.fi>
To:     linux-media@vger.kernel.org
Subject: [GIT PULL for 5.1] sun6 A64 CSI support and address an imgu TODO item
Message-ID: <20190214113218.6qxa4grjt4mcsaj2@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro,

This looks like the last one for 5.1; there's support for sun6 A64 CSI and
addressing one TODO item for the ipu3 imgu driver.

Please pull.


The following changes since commit 6fd369dd1cb65a032f1ab9227033ecb7b759656d:

  media: vimc: fill in bus_info in media_device_info (2019-02-07 12:38:59 -0500)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git tags/for-5.1-5-sign

for you to fetch changes up to ca3a9e55bc3a588efa9eb54e2275fb77d6e3f527:

  media: ipu3: update meta format documentation (2019-02-14 12:29:38 +0200)

----------------------------------------------------------------
sun6 and ipu3 stuff

----------------------------------------------------------------
Jagan Teki (2):
      dt-bindings: media: sun6i: Add A64 CSI compatible
      media: sun6i: Add A64 CSI block support

Yong Zhi (1):
      media: ipu3: update meta format documentation

 .../devicetree/bindings/media/sun6i-csi.txt        |   1 +
 Documentation/media/uapi/v4l/meta-formats.rst      |   2 +-
 .../media/uapi/v4l/pixfmt-meta-intel-ipu3.rst      | 119 ++---------------
 Documentation/media/v4l-drivers/ipu3.rst           | 147 +++++++++++++++++++++
 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c |  11 ++
 5 files changed, 171 insertions(+), 109 deletions(-)

-- 
Sakari Ailus
