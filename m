Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:35040 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754431AbdLNTKJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 14:10:09 -0500
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
Subject: [RFC 0/2] v4l2-ctl: add ROUTING get and set options
Date: Thu, 14 Dec 2017 20:09:41 +0100
Message-Id: <20171214190943.8179-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This small series adds support for the [GS]_ROUTING subdev ioctls 
introduced in Sakari's vc branch.

git://linuxtv.org/sailus/media_tree.git#vc

The use-case for this is to control the internal routing between pads 
inside a subdevice. Currently this is used on the ADV7482 to select 
which of it's 8 analog inputs are routed to the source pad. It is also 
used in the R-Car CSI-2, ADV7482 and MAX9286 drivers to deserve which 
pad is routed to which stream of the multiplexed link between the R-Car 
CSI-2 and either the ADV7482 or the MAX9286.

Niklas Söderlund (2):
  Synchronize with the Kernel headers for routing operations
  v4l2-ctl: add ROUTING get and set options

 include/linux/v4l2-subdev.h         |  41 ++++++++++
 utils/v4l2-ctl/Android.mk           |   2 +-
 utils/v4l2-ctl/Makefile.am          |   2 +-
 utils/v4l2-ctl/v4l2-ctl-routing.cpp | 154 ++++++++++++++++++++++++++++++++++++
 utils/v4l2-ctl/v4l2-ctl.cpp         |  10 +++
 utils/v4l2-ctl/v4l2-ctl.h           |   9 +++
 6 files changed, 216 insertions(+), 2 deletions(-)
 create mode 100644 utils/v4l2-ctl/v4l2-ctl-routing.cpp

-- 
2.14.2
