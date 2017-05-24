Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:45435 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760615AbdEXAHz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 May 2017 20:07:55 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v2 0/2] v4l2-async: add subnotifier registration for subdevices
Date: Wed, 24 May 2017 02:07:25 +0200
Message-Id: <20170524000727.12936-1-niklas.soderlund@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Hi,

This series enables incremental async find and bind of subdevices, 
please se patch 2/2 for a more detailed description.

This is tested on Renesas H3 and M3-W together with the Renesas CSI-2 
and VIN Gen3 driver (posted separately). It is based on top of Sakaris 
pull request '[GIT PULL FOR v4.13] V4L2 fwnode support'. While this 
series do not require the fwnode support the code that makes us of this 
feature do.

Changes since v1:
- Added a pre-patch which adds an error check which was previously in 
  the new incremental async code but is more useful on its own.
- Added documentation to Documentation/media/kapi/v4l2-subdev.rst.
- Fixed data type of bool variable.
- Added call to lockdep_assert_held(), thanks Sakari.
- Fixed commit messages typo, thanks Sakari.

Niklas Söderlund (2):
  v4l: async: check for v4l2_dev in v4l2_async_notifier_register()
  v4l: async: add subnotifier registration for subdevices

 Documentation/media/kapi/v4l2-subdev.rst | 20 +++++++
 drivers/media/v4l2-core/v4l2-async.c     | 91 +++++++++++++++++++++++++-------
 include/media/v4l2-async.h               | 22 ++++++++
 3 files changed, 115 insertions(+), 18 deletions(-)

-- 
2.13.0
