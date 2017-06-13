Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:60460 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753024AbdFMObC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 10:31:02 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v3 0/2] v4l2-async: add subnotifier registration for subdevices
Date: Tue, 13 Jun 2017 16:30:34 +0200
Message-Id: <20170613143036.533-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This series enables incremental async find and bind of subdevices,
please se patch 2/2 for a more detailed description.

This is tested on Renesas H3 and M3-W together with the Renesas CSI-2
and VIN Gen3 driver (posted separately). It is based on top of the media-tree.

* Changes since v2
- Fixed lots of spelling mistakes, thanks Hans!
- Used a goto instead if state variable when restarting iteration over 
  subdev list as suggested by Sakari. Thank you it's much easier read 
  now.
- Added Acked-by from Sakari and Hans, thanks!
- Rebased to latest media-tree.

* Changes since v1:
- Added a pre-patch which adds an error check which was previously in
  the new incremental async code but is more useful on its own.
- Added documentation to Documentation/media/kapi/v4l2-subdev.rst.
- Fixed data type of bool variable.
- Added call to lockdep_assert_held(), thanks Sakari.
- Fixed commit messages typo, thanks Sakari.


Niklas Söderlund (2):
  v4l: async: check for v4l2_dev in v4l2_async_notifier_register()
  v4l: async: add subnotifier registration for subdevices

 Documentation/media/kapi/v4l2-subdev.rst | 20 ++++++++++
 drivers/media/v4l2-core/v4l2-async.c     | 68 +++++++++++++++++++++++++++-----
 include/media/v4l2-async.h               | 22 +++++++++++
 3 files changed, 100 insertions(+), 10 deletions(-)

-- 
2.13.1
