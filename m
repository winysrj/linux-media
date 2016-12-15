Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:37621 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754784AbcLONCP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 08:02:15 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input <linux-input@vger.kernel.org>
Subject: [PATCH 0/2] Add support for the RainShadow Tech HDMI CEC adapter
Date: Thu, 15 Dec 2016 14:02:05 +0100
Message-Id: <20161215130207.12913-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series adds support to the RainShadow Tech HDMI CEC adapter
(http://rainshadowtech.com/HdmiCecUsb.html).

The first patch adds the needed serio ID, the second adds the driver itself.

Dmitry, will you take the first patch, or can we take it together with the
second patch?

This is of course for 4.11.

Regards,

	Hans

Hans Verkuil (2):
  serio.h: add SERIO_RAINSHADOW_CEC ID
  rainshadow-cec: new RainShadow Tech HDMI CEC driver

 MAINTAINERS                                       |   7 +
 drivers/media/usb/Kconfig                         |   1 +
 drivers/media/usb/Makefile                        |   1 +
 drivers/media/usb/rainshadow-cec/Kconfig          |  10 +
 drivers/media/usb/rainshadow-cec/Makefile         |   1 +
 drivers/media/usb/rainshadow-cec/rainshadow-cec.c | 344 ++++++++++++++++++++++
 include/uapi/linux/serio.h                        |   1 +
 7 files changed, 365 insertions(+)
 create mode 100644 drivers/media/usb/rainshadow-cec/Kconfig
 create mode 100644 drivers/media/usb/rainshadow-cec/Makefile
 create mode 100644 drivers/media/usb/rainshadow-cec/rainshadow-cec.c

-- 
2.10.2

