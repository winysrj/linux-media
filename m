Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:33966 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754270AbdLNTJQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 14:09:16 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Benoit Parrot <bparrot@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH/RFC v2 00/15] Add multiplexed pad streaming support 
Date: Thu, 14 Dec 2017 20:08:20 +0100
Message-Id: <20171214190835.7672-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This is the second attempt to add streaming support to multiplexed pads.  
The first attempt was not aware of Sakari's work. His work have now been 
taken into account and this series depends on his series together with 
the master of media-tree.

git://linuxtv.org/sailus/media_tree.git#vc

It also depends on the latest out-of-tree patches for R-Car VIN and 
CSI-2 as these drivers together with the in-tree driver adv748x have 
been used to prove functionality of this series. Test procedure includes 
changing which CSI-2 VC the adv7482 outputs on (using the module 
parameter introduced in this patch-set) and verify that the R-Car CSI-2 
and VIN can receive that particular VC.

A second hardware setup have also been used to verify functionality 
based on the MAX9286 chip, which in contrast to the outputs multiple 
CSI-2 virtual channels. Unfortunate the driver side for the MAX9286 and 
the sensors RDACM20 is still in a prototype stage so the patches to 
enable multiplexed pads on that setup is not included in this patch-set.

The problem this patch-set is trying to solve is that there is no way in 
the v4l2 framework to describe and control links between subdevices 
which carry more then one video stream, for example a CSI-2 bus which 
can have 4 virtual channels carrying different video streams.

The idea is that on both sides of the multiplexed media link there are
one multiplexer subdevice and one demultiplexer subdevice. These two
subdevices can't do any format conversions, there sole purpose is to
(de)multiplex the CSI-2 link. If there is hardware which can do both
CSI-2 multiplexing and format conversions they can be modeled as two
subdevices from the same device driver.

        +------------------+              +------------------+
     +-------+  subdev 1   |              |  subdev 2   +-------+
  +--+ Pad 1 |             |              |             | Pad 3 +---+
     +--+----+   +---------+---+      +---+---------+   +----+--+
        |        | Muxed pad A +------+ Muxed pad B |        |
     +--+----+   +---------+---+      +---+---------+   +----+--+
  +--+ Pad 2 |             |              |             | Pad 4 +---+
     +-------+             |              |             +-------+
        +------------------+              +------------------+

In the example above Pad 1 is routed to Pad 3 and Pad 2 to Pad 4,
and the video data for both of them travels the link between pad A and
B. The routing between the pads inside subdev 1 and subdev 2 are 
controlled and communicated to user-space using the [GS]_ROUTING subdev 
ioctls (from Sakari's patch-set). I have patches for v4l2-ctl which 
creates a user-space interface for these now ioctls which I will post in 
a separate thread. These routes are also used to perform format 
validation between pad 1-3 and pad 2-4, the format validation is also 
part of Sakari's patch-set.

Obviously PATCH 01/15 is a RFC and if it is judged to be OK it should be 
split out to a separate patch and updated to move the .s_stream() 
operation from video ops to pad ops instead of adding a new one. I have 
posted a similar patch for this last year but it did not get much 
attention. For this RFC it's enough to add a new operation as to prove 
functionality.

A big thanks to Laurent and Sakari for being really nice and taking time
helping me grasp all the possibilities and issues with this problem, all
cred to them and all blame to me for misunderstanding there guidance :-)

Niklas Söderlund (15):
  v4l2-subdev.h: add pad and stream aware s_stream
  rcar-vin: use pad as the starting point for a pipeline
  rcar-vin: use the pad and stream aware s_stream
  rcar-csi2: switch to pad and stream aware s_stream
  rcar-csi2: count usage for each source pad
  rcar-csi2: use frame description information when propagating
    .s_stream()
  rcar-csi2: use frame description information to configure CSI-2 bus
  rcar-csi2: add get_routing support
  adv748x: csi2: add module param for virtual channel
  adv748x: csi2: add translation from pixelcode to CSI-2 datatype
  adv748x: csi2: implement get_frame_desc
  adv748x: csi2: switch to pad and stream aware s_stream
  adv748x: csi2: only allow formats on sink pads
  adv748x: csi2: add get_routing support
  adv748x: afe: add routing support

 drivers/media/i2c/adv748x/adv748x-afe.c     |  66 +++++++
 drivers/media/i2c/adv748x/adv748x-core.c    |  10 ++
 drivers/media/i2c/adv748x/adv748x-csi2.c    |  96 +++++++++-
 drivers/media/i2c/adv748x/adv748x.h         |   1 +
 drivers/media/platform/rcar-vin/rcar-csi2.c | 267 +++++++++++++++++++---------
 drivers/media/platform/rcar-vin/rcar-dma.c  |  14 +-
 include/media/v4l2-subdev.h                 |   5 +
 7 files changed, 365 insertions(+), 94 deletions(-)

-- 
2.15.1
