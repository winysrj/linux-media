Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:59664 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731371AbeGQOBw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Jul 2018 10:01:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH 0/5] cec/cec-gpio: add support for 5V testing
Date: Tue, 17 Jul 2018 15:29:04 +0200
Message-Id: <20180717132909.92158-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Some displays disable CEC if the HDMI 5V is not detected. In order
to test issues related to this you want to be able to optionally
detect when the 5V line changes in the cec-gpio driver.

This patch series adds support for this feature.

Regards,

	Hans

Hans Verkuil (5):
  cec-gpio.txt: add v5-gpios for testing the 5V line
  cec-ioc-dqevent.rst: document the new 5V events
  uapi/linux/cec.h: add 5V events
  cec: add support for 5V signal testing
  cec-gpio: support 5v testing

 .../devicetree/bindings/media/cec-gpio.txt    | 17 +++---
 .../media/uapi/cec/cec-ioc-dqevent.rst        | 18 +++++++
 drivers/media/cec/cec-adap.c                  | 18 ++++++-
 drivers/media/cec/cec-api.c                   |  8 +++
 drivers/media/platform/cec-gpio/cec-gpio.c    | 54 +++++++++++++++++++
 include/media/cec-pin.h                       |  4 ++
 include/media/cec.h                           | 12 ++++-
 include/uapi/linux/cec.h                      |  2 +
 8 files changed, 124 insertions(+), 9 deletions(-)

-- 
2.18.0
