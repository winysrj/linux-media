Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:45900 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933474AbeCENvn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Mar 2018 08:51:43 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        dri-devel@lists.freedesktop.org
Subject: [PATCHv2 0/7] cec: add error injection support
Date: Mon,  5 Mar 2018 14:51:32 +0100
Message-Id: <20180305135139.95652-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series adds support for CEC error injection for drivers
using the CEC Pin Framework (cec-pin.c). There are two CEC drivers
currently using this framework: the sun4i Allwinner A10/A20 driver
and the cec-gpio driver. This patch series was developed with the
cec-gpio driver and a Raspberry Pi.

The CEC Pin Framework is meant for hardware that has no high-level
support but only direct low-level control of the bus (i.e. pull the
CEC line down or read the CEC line). Low-level bus access like that
is ideal to implement error injection since you have full control of
the bus and you can do anything you want.

This new error injection framework can create most if not all error
conditions that I could think of. We (Cisco) used it to verify our
own CEC implementation and in fact this error injection framework
was developed together with the low-level CEC analysis code in the
cec-ctl userspace utility to analyze what is happening on the bus.

I have been working on creating scripts that can test a remote CEC
adapter for low-level compliance with the CEC standard:

https://git.linuxtv.org/hverkuil/v4l-utils.git/log/?h=cec-pin-tests

(note: these scripts are for the v1 version of this patch series,
they need to be updated for this v2)

These scripts are not complete yet since it isn't smart enough to
tell the difference between different (but valid) interpretations
of the CEC specification and actual violations of the specification.
I plan to continue working on that since I would like to have a
test-suite that can check a CEC implementation automatically.

Special thanks go to Wolfram Sang since his i2c error injection
presentation at the Embedded Linux Conference Europe 2017 inspired
me to switch to debugfs for this instead of using ioctls.

Changes since v1:

- added 'mode' support (off/once/always/toggle).
- simplified the error injection data structures and logic.
- added patch 7 to log various errors in the 'status' debugfs file.

Regards,

	Hans


Hans Verkuil (7):
  cec: add core error injection support
  cec-core.rst: document the error injection ops
  cec-pin: create cec_pin_start_timer() function
  cec-pin-error-inj: parse/show error injection
  cec-pin: add error injection support
  cec-pin-error-inj.rst: document CEC Pin Error Injection
  cec-pin: improve status log

 .../media/cec-drivers/cec-pin-error-inj.rst        | 322 +++++++++++
 Documentation/media/cec-drivers/index.rst          |   1 +
 Documentation/media/kapi/cec-core.rst              |  72 ++-
 MAINTAINERS                                        |   1 +
 drivers/media/cec/Kconfig                          |   6 +
 drivers/media/cec/Makefile                         |   4 +
 drivers/media/cec/cec-core.c                       |  58 ++
 drivers/media/cec/cec-pin-error-inj.c              | 341 +++++++++++
 drivers/media/cec/cec-pin-priv.h                   | 124 +++-
 drivers/media/cec/cec-pin.c                        | 627 ++++++++++++++++++---
 include/media/cec.h                                |   5 +
 11 files changed, 1490 insertions(+), 71 deletions(-)
 create mode 100644 Documentation/media/cec-drivers/cec-pin-error-inj.rst
 create mode 100644 drivers/media/cec/cec-pin-error-inj.c

-- 
2.16.1
