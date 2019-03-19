Return-Path: <SRS0=DvKj=RW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 071A9C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 09:25:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C348520857
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 09:25:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbfCSJZw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Mar 2019 05:25:52 -0400
Received: from retiisi.org.uk ([95.216.213.190]:59124 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725862AbfCSJZw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Mar 2019 05:25:52 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2a01:4f9:c010:4572::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id F2C8A634C7B
        for <linux-media@vger.kernel.org>; Tue, 19 Mar 2019 11:23:55 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1h6AyS-0004Jf-Nn
        for linux-media@vger.kernel.org; Tue, 19 Mar 2019 11:23:56 +0200
Date:   Tue, 19 Mar 2019 11:23:56 +0200
From:   Sakari Ailus <sakari.ailus@iki.fi>
To:     linux-media@vger.kernel.org
Subject: [GIT PULL for 5.2] Sensor, IPU3 driver patches and fwnode fixes
Message-ID: <20190319092356.tnyctkhxmw7347se@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro,

Here's a set of sensor and IPU3 driver patches as well as fwnode fixes in
the frameworks as well as in the DaVinci VPE driver. Also put the lens
drivers in Kconfig into their own section (they were in the decoder
section).

Please pull.


The following changes since commit 9e98c678c2d6ae3a17cb2de55d17f69dddaa231b:

  Linux 5.1-rc1 (2019-03-17 14:22:26 -0700)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git tags/for-5.2-1-signed

for you to fetch changes up to 4feeb6c9436bda15b8146ca4d4a07b3bb110e863:

  v4l2-fwnode: Add a deprecation note in the old ACPI parsing example (2019-03-19 11:20:10 +0200)

----------------------------------------------------------------
sensor stuff for 5.2

----------------------------------------------------------------
Akinobu Mita (2):
      media: ov7670: restore default settings after power-up
      media: ov7670: don't access registers when the device is powered off

Arnd Bergmann (3):
      media: staging/intel-ipu3-v4l: reduce kernel stack usage
      media: staging/intel-ipu3: mark PM function as __maybe_unused
      media: staging/intel-ipu3: reduce kernel stack usage

Sakari Ailus (7):
      v4l2-fwnode: Defaults may not override endpoint configuration in firmware
      v4l2-fwnode: The first default data lane is 0 on C-PHY
      pxa-camera: Match with device node, not the port node
      ti-vpe: Parse local endpoint for properties, not the remote one
      v4l: i2c: Regroup lens drivers under their own section
      ipu3-cio2: Set CSI-2 receiver sub-device entity function
      v4l2-fwnode: Add a deprecation note in the old ACPI parsing example

 drivers/media/i2c/Kconfig                | 76 ++++++++++++++++----------------
 drivers/media/i2c/ov7670.c               | 32 +++++++++++---
 drivers/media/pci/intel/ipu3/ipu3-cio2.c |  1 +
 drivers/media/platform/pxa_camera.c      |  2 +-
 drivers/media/platform/ti-vpe/cal.c      | 12 +----
 drivers/media/v4l2-core/v4l2-fwnode.c    | 17 +++++--
 drivers/staging/media/ipu3/ipu3-css.c    | 35 ++++++++++-----
 drivers/staging/media/ipu3/ipu3-v4l2.c   | 40 ++++++++++-------
 drivers/staging/media/ipu3/ipu3.c        |  2 +-
 9 files changed, 133 insertions(+), 84 deletions(-)

-- 
Regards,

Sakari Ailus
