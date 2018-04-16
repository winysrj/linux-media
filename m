Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:48317 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751903AbeDPKGt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 06:06:49 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.18] rcar-vin: Add Gen3 with media controller
Message-ID: <da49605e-49ff-f22a-9ffb-0f61af01daee@xs4all.nl>
Date: Mon, 16 Apr 2018 12:06:42 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pull request of the 'rcar-vin: Add Gen3 with media controller' v14 patch series.

Regards,

	Hans

The following changes since commit 60cc43fc888428bb2f18f08997432d426a243338:

  Linux 4.17-rc1 (2018-04-15 18:24:20 -0700)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git rcar

for you to fetch changes up to abe8957b91296d6ecf94ff2fd4d970d60ea9167a:

  rcar-vin: enable support for r8a77970 (2018-04-16 11:48:29 +0200)

----------------------------------------------------------------
Fabrizio Castro (2):
      dt-bindings: media: rcar_vin: Reverse SoC part number list
      dt-bindings: media: rcar_vin: add device tree support for r8a774[35]

Niklas Söderlund (31):
      rcar-vin: add Gen3 devicetree bindings documentation
      rcar-vin: rename poorly named initialize and cleanup functions
      rcar-vin: unregister video device on driver removal
      rcar-vin: move subdevice handling to async callbacks
      rcar-vin: move model information to own struct
      rcar-vin: move max width and height information to chip information
      rcar-vin: move functions regarding scaling
      rcar-vin: all Gen2 boards can scale simplify logic
      rcar-vin: set a default field to fallback on
      rcar-vin: fix handling of single field frames (top, bottom and alternate fields)
      rcar-vin: update bytesperline and sizeimage calculation
      rcar-vin: align pixelformat check
      rcar-vin: break out format alignment and checking
      rcar-vin: simplify how formats are set and reset
      rcar-vin: cache video standard
      rcar-vin: move media bus configuration to struct rvin_dev
      rcar-vin: enable Gen3 hardware configuration
      rcar-vin: add function to manipulate Gen3 chsel value
      rcar-vin: add flag to switch to media controller mode
      rcar-vin: use different v4l2 operations in media controller mode
      rcar-vin: force default colorspace for media centric mode
      rcar-vin: prepare for media controller mode initialization
      rcar-vin: add group allocator functions
      rcar-vin: change name of video device
      rcar-vin: add chsel information to rvin_info
      rcar-vin: parse Gen3 OF and setup media graph
      rcar-vin: add link notify for Gen3
      rcar-vin: extend {start, stop}_streaming to work with media controller
      rcar-vin: enable support for r8a7795
      rcar-vin: enable support for r8a7796
      rcar-vin: enable support for r8a77970

 Documentation/devicetree/bindings/media/rcar_vin.txt | 137 +++++++--
 drivers/media/platform/rcar-vin/Kconfig              |   2 +-
 drivers/media/platform/rcar-vin/rcar-core.c          | 956 ++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 drivers/media/platform/rcar-vin/rcar-dma.c           | 907 ++++++++++++++++++++++++++++++++-----------------------
 drivers/media/platform/rcar-vin/rcar-v4l2.c          | 480 +++++++++++++++++------------
 drivers/media/platform/rcar-vin/rcar-vin.h           | 146 +++++++--
 6 files changed, 1964 insertions(+), 664 deletions(-)
