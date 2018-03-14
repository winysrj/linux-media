Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:15506 "EHLO
        bin-mail-out-06.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750902AbeCNCtf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 22:49:35 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v2 0/2] rcar-vin: always run in continues mode
Date: Wed, 14 Mar 2018 03:49:08 +0100
Message-Id: <20180314024910.16676-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This series reworks the R-Car VIN driver to only run using its continues
capture mode. This improves performance a lot when userspace struggles
to keep up and queue buffers as fast as the VIN driver consumes them.
The solution to always be able to run in continues is to introduce a
scratch buffer inside the VIN driver which it can pad the hardware
capture buffer ring with if it have no buffer from userspace. Using this
scratch buffer allows the driver to not need to stop capturing when it
run out of buffers and then restart it once it have more buffers.

Patch 1/2 adds the allocation of the scratch buffer. And patch 2/2 drops 
the single capture mode in favor of always running in continues capture 
mode and the scratch buffer.

The series is based on top of the latest media-tree master branch and
can be fetched from.

git://git.ragnatech.se/linux v4l2/next/vin/mode-v2

It is tested on R-Car Koelsch Gen2 board using the onboard HDMI and CVBS
inputs. The test application v4l2-compliance pass for both inputs
without issues or warnings. A slight adaption of these patches to the
pending VIN Gen3 patches have been tested with great improvement in
capture speed for buffer strained situations and no regressions in the
vin-tests suite.

* Changes since v1
- Dropped first patch in series as it removed a correct check due to my 
  poor reading skills.
- Corrected spelling in commit messages and comments.
- Added review tags from Jacopo and Kieran, thanks!


Niklas Söderlund (2):
  rcar-vin: allocate a scratch buffer at stream start
  rcar-vin: use scratch buffer and always run in continuous mode

 drivers/media/platform/rcar-vin/rcar-dma.c | 206 ++++++++++-------------------
 drivers/media/platform/rcar-vin/rcar-vin.h |  10 +-
 2 files changed, 75 insertions(+), 141 deletions(-)

-- 
2.16.2
