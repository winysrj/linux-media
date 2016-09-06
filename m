Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57480 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755379AbcIFMNT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Sep 2016 08:13:19 -0400
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 0BB0460093
        for <linux-media@vger.kernel.org>; Tue,  6 Sep 2016 15:13:14 +0300 (EEST)
Date: Tue, 6 Sep 2016 15:12:43 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.9] Add an operations callback struct for the media
 device
Message-ID: <20160906121243.GB3236@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This request contains a single patch, one that moves the link_notify()
callback to a separate struct.

As the patch touches several drivers and is required by anything that's
adding new callbacks to the media device, I think it makes sense to merge it
now rather than later on.

Please pull.


The following changes since commit e62c30e76829d46bf11d170fd81b735f13a014ac:

  [media] smiapp: Remove set_xclk() callback from hwconfig (2016-09-05 15:53:20 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git media-request-prepare

for you to fetch changes up to ff299860f5ae379a336d462ee9d8c987c60e7de5:

  media: Move media_device link_notify operation to an ops structure (2016-09-06 10:34:51 +0300)

----------------------------------------------------------------
Laurent Pinchart (1):
      media: Move media_device link_notify operation to an ops structure

 drivers/media/media-entity.c                  | 11 ++++++-----
 drivers/media/platform/exynos4-is/media-dev.c |  6 +++++-
 drivers/media/platform/omap3isp/isp.c         |  6 +++++-
 drivers/staging/media/omap4iss/iss.c          |  6 +++++-
 include/media/media-device.h                  | 16 ++++++++++++----
 5 files changed, 33 insertions(+), 12 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
