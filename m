Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42952 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751473AbdDMMBK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Apr 2017 08:01:10 -0400
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 03EAC600AD
        for <linux-media@vger.kernel.org>; Thu, 13 Apr 2017 15:01:03 +0300 (EEST)
Date: Thu, 13 Apr 2017 15:00:30 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.12] Voice coil lens controls, use them for ad5820
Message-ID: <20170413120029.GA7456@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull request adds a control class for voice coil lens controls and
makes use of the new control for ad5820.

Please pull.


The following changes since commit 0538bee6fdec9b79910c1c9835e79be75d0e1bdf:

  [media] MAINTAINERS: update atmel-isi.c path (2017-04-10 08:13:08 -0300)

are available in the git repository at:

  https://linuxtv.org/git/sailus/media_tree.git lens

for you to fetch changes up to 117e4713db7b4ac1211a21e9964926966d0867eb:

  ad5820: Use VOICE_COIL_CURRENT control (2017-04-13 14:14:37 +0300)

----------------------------------------------------------------
Sakari Ailus (2):
      v4l: Add camera voice coil lens control class, current control
      ad5820: Use VOICE_COIL_CURRENT control

 Documentation/media/uapi/v4l/extended-controls.rst | 28 ++++++++++++++++++++++
 drivers/media/i2c/ad5820.c                         | 27 ++++++++++++++++-----
 include/uapi/linux/v4l2-controls.h                 |  8 +++++++
 3 files changed, 57 insertions(+), 6 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
