Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:39275 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728826AbeHMMG7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Aug 2018 08:06:59 -0400
From: Marco Felsch <m.felsch@pengutronix.de>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
Cc: kernel@pengutronix.de, devicetree@vger.kernel.org,
        p.zabel@pengutronix.de, javierm@redhat.com,
        laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
        afshin.nasser@gmail.com, linux-media@vger.kernel.org
Subject: [PATCH v2 0/7] TVP5150 fixes and new features
Date: Mon, 13 Aug 2018 11:25:01 +0200
Message-Id: <20180813092508.1334-1-m.felsch@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

this is my v2 with the integrated reviews from my v1 [1]. Since Mauro
applied the most patches from my v1 to his experimental/tvp5150-3
branch [2], this series only contains those which aren't applied.

Patches I changed contain a changelog, so I will omit these here.

Patch ('[media] tvp5150: add FORMAT_TRY support for get/set selection
handlers') throws a compile error. Therefore I added two v4l2-subdev.h
patches which should fix the error in a common way.

Patch ('[media] tvp5150: add s_power callback') is new too. I forget
them in my v1. This patch address the interrupt enable/disable handling.
Now it is possible to pause streaming and keep the interrupts on.

The changes I made in the ('[media] tvp5150: add input source selection
of_graph support') patch are based on the the RFC [3] and discussion [4].
I dropped patch ('[media] tvp5150: Change default input source selection
behaviour') since the default input source selectopn is setup during the
.registered() callback now.

I've tested this series on a customer dt-based board. Unfortunately I
haven't a device which use the em28xx driver. So other tester a welcome :)

[1] https://www.spinics.net/lists/devicetree/msg236650.html
[2] https://git.linuxtv.org/mchehab/experimental.git/log/?h=tvp5150-3
[3] https://www.spinics.net/lists/devicetree/msg243181.html
[4] https://www.spinics.net/lists/devicetree/msg243840.html

Regards,
Marco

Marco Felsch (6):
  [media] tvp5150: add input source selection of_graph support
  [media] dt-bindings: tvp5150: Add input port connectors DT bindings
  [media] v4l2-subdev: add stubs for v4l2_subdev_get_try_*
  [media] v4l2-subdev: fix v4l2_subdev_get_try_* dependency
  [media] tvp5150: add FORMAT_TRY support for get/set selection handlers
  [media] tvp5150: add s_power callback

Michael Tretter (1):
  [media] tvp5150: initialize subdev before parsing device tree

 .../devicetree/bindings/media/i2c/tvp5150.txt | 191 +++++-
 drivers/media/i2c/tvp5150.c                   | 611 +++++++++++++++---
 include/media/v4l2-subdev.h                   | 111 ++--
 3 files changed, 776 insertions(+), 137 deletions(-)

-- 
2.18.0
