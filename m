Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:58939 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387951AbeGWJbc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 05:31:32 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.19] cec/cec-gpio: add support for 5V testing
Message-ID: <438460b2-2eb4-a23e-d8a3-9e085109bfea@xs4all.nl>
Date: Mon, 23 Jul 2018 10:31:26 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some displays disable CEC if the HDMI 5V is not detected. In order
to test issues related to this you want to be able to optionally
detect when the 5V line changes in the cec-gpio driver.

This patch series adds support for this feature.

Regards,

	Hans

The following changes since commit 39fbb88165b2bbbc77ea7acab5f10632a31526e6:

  media: bpf: ensure bpf program is freed on detach (2018-07-13 11:07:29 -0400)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git cec-5v

for you to fetch changes up to d2c3c626897322f5a343347e805a35e31f7ca08b:

  cec-gpio: support 5v testing (2018-07-23 10:27:40 +0200)

----------------------------------------------------------------
Hans Verkuil (5):
      cec-gpio.txt: add v5-gpios for testing the 5V line
      cec-ioc-dqevent.rst: document the new 5V events
      uapi/linux/cec.h: add 5V events
      cec: add support for 5V signal testing
      cec-gpio: support 5v testing

 Documentation/devicetree/bindings/media/cec-gpio.txt | 22 +++++++++++++--------
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst     | 18 +++++++++++++++++
 drivers/media/cec/cec-adap.c                         | 18 ++++++++++++++++-
 drivers/media/cec/cec-api.c                          |  8 ++++++++
 drivers/media/platform/cec-gpio/cec-gpio.c           | 54 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/media/cec-pin.h                              |  4 ++++
 include/media/cec.h                                  | 12 +++++++++++-
 include/uapi/linux/cec.h                             |  2 ++
 8 files changed, 128 insertions(+), 10 deletions(-)
