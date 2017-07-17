Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:35415 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751313AbdGQRAZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 13:00:25 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v4 0/3] v4l2-async: add subnotifier registration for subdevices
Date: Mon, 17 Jul 2017 18:59:14 +0200
Message-Id: <20170717165917.24851-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This is a rewrite of the feature since v3, maybe it should have been 
posted as a new series?

This series enables incremental async find and bind of subdevices,
please se patch 3/3 for a more detailed description of the new behavior, 
changelog in this cover letter for the differences to v3. The two 
primary reasons for a new implementation where:

1. Hans expressed an interest having the async complete() callbacks to 
   happen only once all notifiers in the pipeline where complete. To do 
   this a stronger connection between the notifiers where needed, hence 
   the subnotifier is now embedded in struct v4l2_subdev.

   Whit this change it is possible to check all notifiers in a pipeline 
   is complete before calling any of them.

2. There where concerns that the v3 solution was a bit to complex and 
   hard to refactor in the future if other issues in the v4l2-async 
   framework where to be addressed. By hiding the notifier in the struct 
   v4l2_subdev and adding a new function to set that structure the 
   interface towards drivers are minimized while everything else happens 
   in the v4l2-async framework. This leaves the interface in a good 
   position for possible changes in v4l2-async.

This is tested on Renesas H3 and M3-W together with the Renesas CSI-2
and VIN Gen3 driver (posted separately). It is based on top of the media-tree.

* Changes since v3
- Almost a complete rewrite, so drop all Ack-ed by tags.
- Do not add new functions to register/unregister subnotifiers from 
  callbacks. Instead have have the subdevice drivers populate the 
  subnotifer list at probe time and have the v4l2-async framework handle 
  the (un)registration of the notifiers.
- Synchronize the call off the complete() callbacks. They will now all 
  happens once all notifiers in a pipeline are all complete and from the 
  edge towards the root device.
- Add a new function v4l2_async_subdev_register_notifier() to hide the 
  setup of the subnotifier internals to ease improvements later.

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

Niklas Söderlund (3):
  v4l: async: fix unbind error in v4l2_async_notifier_unregister()
  v4l: async: do not hold list_lock when reprobing devices
  v4l: async: add subnotifier to subdevices

 Documentation/media/kapi/v4l2-subdev.rst |  12 +++
 drivers/media/v4l2-core/v4l2-async.c     | 165 +++++++++++++++++++++++++------
 include/media/v4l2-async.h               |  25 +++++
 include/media/v4l2-subdev.h              |   5 +
 4 files changed, 179 insertions(+), 28 deletions(-)

-- 
2.13.1
