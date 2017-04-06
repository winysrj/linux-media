Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:43739 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932933AbdDFHTC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Apr 2017 03:19:02 -0400
Received: from tschai.fritz.box (localhost [127.0.0.1])
        by tschai.lan (Postfix) with ESMTPSA id D9FC018061E
        for <linux-media@vger.kernel.org>; Thu,  6 Apr 2017 09:18:56 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCHv3 0/2] Add support for the RainShadow Tech HDMI CEC adapter
Date: Thu,  6 Apr 2017 09:18:54 +0200
Message-Id: <20170406071856.17404-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series adds support to the RainShadow Tech HDMI CEC adapter
(http://rainshadowtech.com/HdmiCecUsb.html).

The first patch adds the needed serio ID, the second adds the driver itself.

This is identical to the v2 just rebased and now using the cec_get_drvdata()
instead of accessing adap->priv directly.

A pull request will follow shortly.

Regards,

        Hans

Changes since v2:

- Rebased
- Use cec_get_drvdata()

Changes since v1:

Implemented almost all of Dmitry's suggestions:  
- use dev_dbg instead of 'if (debug) dev_info()'
- reworked the interrupt/workqueue handling
- use switch instead of 'if .. else if ...'


Hans Verkuil (2):
  serio.h: add SERIO_RAINSHADOW_CEC ID
  rainshadow-cec: new RainShadow Tech HDMI CEC driver

 MAINTAINERS                                       |   7 +
 drivers/media/usb/Kconfig                         |   1 +
 drivers/media/usb/Makefile                        |   1 +
 drivers/media/usb/rainshadow-cec/Kconfig          |  10 +
 drivers/media/usb/rainshadow-cec/Makefile         |   1 +
 drivers/media/usb/rainshadow-cec/rainshadow-cec.c | 388 ++++++++++++++++++++++
 include/uapi/linux/serio.h                        |   1 +
 7 files changed, 409 insertions(+)
 create mode 100644 drivers/media/usb/rainshadow-cec/Kconfig
 create mode 100644 drivers/media/usb/rainshadow-cec/Makefile
 create mode 100644 drivers/media/usb/rainshadow-cec/rainshadow-cec.c

-- 
2.11.0
