Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44660 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752366AbdJSPQE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Oct 2017 11:16:04 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id D7725600EB
        for <linux-media@vger.kernel.org>; Thu, 19 Oct 2017 18:16:02 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1e5CYE-0001qi-Es
        for linux-media@vger.kernel.org; Thu, 19 Oct 2017 18:16:02 +0300
Date: Thu, 19 Oct 2017 18:16:02 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.15] More sensor driver patches
Message-ID: <20171019151601.xvftrepionng7q2s@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's the third set of sensor driver patches for 4.15.

Please pull.


The following changes since commit 61065fc3e32002ba48aa6bc3816c1f6f9f8daf55:

  Merge commit '3728e6a255b5' into patchwork (2017-10-17 17:22:20 -0700)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-4.15-3

for you to fetch changes up to 2afbb0b3e1e139028e08d2099c72a1e3e3e61f86:

  tc358743: validate lane count (2017-10-19 14:02:56 +0300)

----------------------------------------------------------------
Jacob Chen (2):
      media: i2c: OV5647: ensure clock lane in LP-11 state before streaming on
      media: i2c: OV5647: change to use macro for the registers

Philipp Zabel (1):
      tc358743: validate lane count

Wenyou Yang (3):
      media: ov7670: Add entity pads initialization
      media: ov7670: Add the get_fmt callback
      media: ov7670: Add the ov7670_s_power function

 drivers/media/i2c/ov5647.c   |  51 ++++++++++++-----
 drivers/media/i2c/ov7670.c   | 129 ++++++++++++++++++++++++++++++++++++++++---
 drivers/media/i2c/tc358743.c |   5 ++
 3 files changed, 163 insertions(+), 22 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
