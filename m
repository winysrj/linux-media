Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36522 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751886AbeCIIis (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 03:38:48 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id D1B6C600C1
        for <linux-media@vger.kernel.org>; Fri,  9 Mar 2018 10:38:46 +0200 (EET)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1euDY6-0004WY-Be
        for linux-media@vger.kernel.org; Fri, 09 Mar 2018 10:38:46 +0200
Date: Fri, 9 Mar 2018 10:38:46 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL v2 for 4.17] Add V4L2 framework function for selecting the
 most suitable size
Message-ID: <20180309083845.27mnjcparld6lvln@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

In drivers for hardware that have a discrete set of supported sizes, the
size selection is a commonly needed functionality. This set implements it
in a way that is usable in drivers and converts a few existing drivers to
use it.

since v1:

- Fix KernelDoc documentation

- Align argument order in __v4l2_find_nearest_size() function and its
  prototype. Align argument names across the function and the macro.

Please pull.


The following changes since commit 29422737017b866d4a51014cc7522fa3a99e8852:

  media: rc: get start time just before calling driver tx (2018-02-14 14:17:21 -0500)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git v4l2-common-size

for you to fetch changes up to 3839a37f69da4dc567d3b00dc5e985f8e8425811:

  ov5670: Use v4l2_find_nearest_size (2018-02-22 15:44:57 +0200)

----------------------------------------------------------------
Sakari Ailus (5):
      v4l: common: Add a function to obtain best size from a list
      vivid: Use v4l2_find_nearest_size
      v4l: common: Remove v4l2_find_nearest_format
      ov13858: Use v4l2_find_nearest_size
      ov5670: Use v4l2_find_nearest_size

 drivers/media/i2c/ov13858.c                  | 37 +++-------------------------
 drivers/media/i2c/ov5670.c                   | 34 +++----------------------
 drivers/media/platform/vivid/vivid-vid-cap.c |  6 ++---
 drivers/media/v4l2-core/v4l2-common.c        | 34 ++++++++++++++-----------
 include/media/v4l2-common.h                  | 34 ++++++++++++++++++-------
 5 files changed, 53 insertions(+), 92 deletions(-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
