Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:23753 "EHLO
        bin-vsp-out-02.atm.binero.net" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932855AbeCJAKx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 19:10:53 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 0/3] rcar-vin: always run in continues mode
Date: Sat, 10 Mar 2018 01:09:50 +0100
Message-Id: <20180310000953.25366-1-niklas.soderlund+renesas@ragnatech.se>
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

Patch 1/3 removes a duplicated check in the VIN interrupt handler. Patch 
2/3 adds the allocation of the scratch buffer. And finally 3/3 drops the 
single capture mode in favor of always running in continues capture mode 
and the scratch buffer.

The series is based on top of the latest media-tree master branch and 
can be fetched from.

git://git.ragnatech.se/linux v4l2/next/vin/mode-v1

It is tested on R-Car Koelsch Gen2 board using the onboard HDMI and CVBS 
inputs. The test application v4l2-compliance pass for both inputs 
without issues or warnings. A slight adaption of these patches to the 
pending VIN Gen3 patches have been tested with great improvement in 
capture speed for buffer strained situations and no regressions in the 
vin-tests suite.

Niklas Söderlund (3):
  rcar-vin: remove duplicated check of state in irq handler
  rcar-vin: allocate a scratch buffer at stream start
  rcar-vin: use scratch buffer and always run in continuous mode

 drivers/media/platform/rcar-vin/rcar-dma.c | 212 ++++++++++-------------------
 drivers/media/platform/rcar-vin/rcar-vin.h |  10 +-
 2 files changed, 75 insertions(+), 147 deletions(-)

-- 
2.16.2
