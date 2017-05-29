Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:40940 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750994AbdE2Nvs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 May 2017 09:51:48 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.13] Fixes, mostly for rcar-vin
Message-ID: <0a095cca-7255-2091-d256-f399041b2ff6@xs4all.nl>
Date: Mon, 29 May 2017 15:51:43 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Important: this pull request assumes that this pull request:

https://patchwork.linuxtv.org/patch/41530/

was merged first!

Regards,

	Hans

The following changes since commit 575cafad3859ae42e83538b1c60d2beb51bd845f:

   v4l: Remove V4L2 OF framework in favour of V4L2 fwnode framework (2017-05-29 12:26:22 +0300)

are available in the git repository at:

   git://linuxtv.org/hverkuil/media_tree.git for-v4.13b

for you to fetch changes up to 2b25d98531fded5a10356478abb021c6d3469770:

   Doc*/media/uapi: fix control name (2017-05-29 11:50:34 +0200)

----------------------------------------------------------------
Niklas Söderlund (16):
       rcar-vin: reset bytesperline and sizeimage when resetting format
       rcar-vin: use rvin_reset_format() in S_DV_TIMINGS
       rcar-vin: fix how pads are handled for v4l2 subdevice operations
       rcar-vin: fix standard in input enumeration
       rcar-vin: move subdev source and sink pad index to rvin_graph_entity
       rcar-vin: refactor pad lookup code
       rcar-vin: move pad lookup to async bound handler
       rcar-vin: use pad information when verifying media bus format
       rcar-vin: decrease buffers needed to capture
       rcar-vin: move functions which acts on hardware
       rcar-vin: select capture mode based on free buffers
       rcar-vin: allow switch between capturing modes when stalling
       rcar-vin: refactor and fold in function after stall handling rework
       rcar-vin: remove subdevice matching from bind and unbind callbacks
       rcar-vin: add missing error check to propagate error
       rcar-vin: fix bug in pixelformat selection

Nori, Sekhar (1):
       davinci: vpif_capture: fix default pixel format for BT.656/BT.1120 video

Pavel Machek (1):
       Doc*/media/uapi: fix control name

Philipp Zabel (1):
       coda: improve colorimetry handling

Ulrich Hecht (2):
       media: adv7180: add adv7180cp, adv7180st compatible strings
       media: adv7180: Add adv7180cp, adv7180st bindings

  Documentation/devicetree/bindings/media/i2c/adv7180.txt |  15 +++
  Documentation/media/uapi/v4l/extended-controls.rst      |   2 +-
  drivers/media/i2c/adv7180.c                             |   2 +
  drivers/media/platform/coda/coda-common.c               |  51 +++++++---
  drivers/media/platform/coda/coda.h                      |   3 +
  drivers/media/platform/davinci/vpif_capture.c           |  10 +-
  drivers/media/platform/rcar-vin/rcar-core.c             |  51 +++++++---
  drivers/media/platform/rcar-vin/rcar-dma.c              | 230 +++++++++++++++++++++++---------------------
  drivers/media/platform/rcar-vin/rcar-v4l2.c             |  97 ++++++++-----------
  drivers/media/platform/rcar-vin/rcar-vin.h              |   9 +-
  10 files changed, 261 insertions(+), 209 deletions(-)
