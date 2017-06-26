Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51568 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751101AbdFZRGF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 13:06:05 -0400
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id CD95D600AF
        for <linux-media@vger.kernel.org>; Mon, 26 Jun 2017 20:06:01 +0300 (EEST)
Date: Mon, 26 Jun 2017 20:05:31 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.13] ov6650 V4L2 sub-device conversion
Message-ID: <20170626170531.GS12407@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This set includes converting the ov6650 driver to V4L2 sub-device driver
(from SoC camera).

Rebased w/o conflicts on more recent media tree master.

Please pull.


The following changes since commit 430e29d9c0f65d9653a0b7f7a56f1c6cd374b84b:

  media: dvb-frontends/stv0367: Improve DVB-C/T frontend status (2017-06-25 10:48:45 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-4.13-4

for you to fetch changes up to 86210a19e331647c09122db329f80eae7fe34ba2:

  media: ov6650: convert to standalone v4l2 subdevice (2017-06-26 15:05:20 +0300)

----------------------------------------------------------------
Janusz Krzysztofik (1):
      media: ov6650: convert to standalone v4l2 subdevice

 drivers/media/i2c/Kconfig                   | 11 +++++
 drivers/media/i2c/Makefile                  |  1 +
 drivers/media/i2c/{soc_camera => }/ov6650.c | 77 +++++++++--------------------
 drivers/media/i2c/soc_camera/Kconfig        |  6 ---
 drivers/media/i2c/soc_camera/Makefile       |  1 -
 5 files changed, 35 insertions(+), 61 deletions(-)
 rename drivers/media/i2c/{soc_camera => }/ov6650.c (92%)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
