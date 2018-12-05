Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65F36C04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 10:55:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D0B6206B7
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 10:55:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2D0B6206B7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=iki.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbeLEKzc (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 05:55:32 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39364 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726171AbeLEKzc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Dec 2018 05:55:32 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 46EAC634C83
        for <linux-media@vger.kernel.org>; Wed,  5 Dec 2018 12:55:24 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1gUUpw-0000Ph-6o
        for linux-media@vger.kernel.org; Wed, 05 Dec 2018 12:55:24 +0200
Date:   Wed, 5 Dec 2018 12:55:24 +0200
From:   sakari.ailus@iki.fi
To:     linux-media@vger.kernel.org
Subject: [GIT PULL for 4.21] More sensor driver patches
Message-ID: <20181205105524.zzugyiya53ytutg7@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro,

Here are improvements for various sensor drivers for 4.21. There area few
trivial V4L2 fwnode and async framework changes as well, plus DT binding
documentation for mt9m111.

Please pull.


The following changes since commit 9b90dc85c718443a3e573a0ccf55900ff4fa73ae:

  media: seco-cec: add missing header file to fix build (2018-12-03 15:11:00 -0500)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git tags/for-4.21-4-sign

for you to fetch changes up to bf8da26398f03704bbf7bb10b9c847fd187f4260:

  v4l2: async: remove locking when initializing async notifier (2018-12-05 12:10:24 +0200)

----------------------------------------------------------------
sensor driver patches and stuff for 4.21

----------------------------------------------------------------
Bingbu Cao (3):
      media: imx319: fix wrong order in test pattern menus
      media: imx355: fix wrong order in test pattern menus
      media: unify some sony camera sensors pattern naming

Enrico Scholz (1):
      media: mt9m111: allow to setup pixclk polarity

Fabio Estevam (1):
      media: v4l2-fwnode: Demote warning to debug level

Jacopo Mondi (1):
      media: ov5640: Fix set format regression

Luca Ceresoli (3):
      media: imx274: fix stack corruption in imx274_read_reg
      media: imx274: declare the correct number of controls
      media: imx274: select REGMAP_I2C

Marco Felsch (3):
      media: mt9m111: add s_stream callback
      dt-bindings: media: mt9m111: adapt documentation to be more clear
      dt-bindings: media: mt9m111: add pclk-sample property

Maxime Ripard (11):
      media: ov5640: Adjust the clock based on the expected rate
      media: ov5640: Remove the clocks registers initialization
      media: ov5640: Remove redundant defines
      media: ov5640: Remove redundant register setup
      media: ov5640: Compute the clock rate at runtime
      media: ov5640: Remove pixel clock rates
      media: ov5640: Enhance FPS handling
      media: ov5640: Make the return rate type more explicit
      media: ov5640: Make the FPS clamping / rounding more extendable
      media: ov5640: Add 60 fps support
      media: ov5640: Remove duplicate auto-exposure setup

Michael Grzeschik (2):
      media: mt9m111: add streaming check to set_fmt
      media: mt9m111: add support to select formats and fps for {Q,SXGA}

Niklas Söderlund (1):
      v4l2: async: remove locking when initializing async notifier

 .../devicetree/bindings/media/i2c/mt9m111.txt      |  13 +-
 drivers/media/i2c/Kconfig                          |   2 +
 drivers/media/i2c/imx258.c                         |   8 +-
 drivers/media/i2c/imx274.c                         |   9 +-
 drivers/media/i2c/imx319.c                         |   8 +-
 drivers/media/i2c/imx355.c                         |   8 +-
 drivers/media/i2c/mt9m111.c                        | 222 +++++-
 drivers/media/i2c/ov5640.c                         | 764 ++++++++++++---------
 drivers/media/v4l2-core/v4l2-async.c               |   4 -
 drivers/media/v4l2-core/v4l2-fwnode.c              |   2 +-
 10 files changed, 703 insertions(+), 337 deletions(-)

-- 
Regards,

Sakari Ailus
