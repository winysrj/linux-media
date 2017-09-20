Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00252a01.pphosted.com ([91.207.212.211]:41786 "EHLO
        mx08-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751618AbdITQId (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 12:08:33 -0400
Received: from pps.filterd (m0102629.ppops.net [127.0.0.1])
        by mx08-00252a01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v8KG8WDe006761
        for <linux-media@vger.kernel.org>; Wed, 20 Sep 2017 17:08:32 +0100
Received: from mail-wm0-f69.google.com (mail-wm0-f69.google.com [74.125.82.69])
        by mx08-00252a01.pphosted.com with ESMTP id 2d0reg260a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Wed, 20 Sep 2017 17:08:32 +0100
Received: by mail-wm0-f69.google.com with SMTP id b195so3265900wmb.6
        for <linux-media@vger.kernel.org>; Wed, 20 Sep 2017 09:08:32 -0700 (PDT)
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Eric Anholt <eric@anholt.net>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-media@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Cc: Dave Stevenson <dave.stevenson@raspberrypi.org>
Subject: [PATCH v3 0/4] BCM283x Camera Receiver driver
Date: Wed, 20 Sep 2017 17:07:53 +0100
Message-Id: <cover.1505916622.git.dave.stevenson@raspberrypi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All.

v3 of this patch set.
This addresses the DT issues raised by Rob, and the things raised by
Eric on the driver. More complete change details between v2 and v3
are in the individual patches.

Thanks
  Dave

Dave Stevenson (4):
  [media] v4l2-common: Add helper function for fourcc to string
  [media] dt-bindings: Document BCM283x CSI2/CCP2 receiver
  [media] bcm2835-unicam: Driver for CCP2/CSI2 camera interface
  MAINTAINERS: Add entry for BCM2835 camera driver

 .../devicetree/bindings/media/bcm2835-unicam.txt   |   85 +
 MAINTAINERS                                        |    7 +
 drivers/media/platform/Kconfig                     |    1 +
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/bcm2835/Kconfig             |   14 +
 drivers/media/platform/bcm2835/Makefile            |    3 +
 drivers/media/platform/bcm2835/bcm2835-unicam.c    | 2192 ++++++++++++++++++++
 drivers/media/platform/bcm2835/vc4-regs-unicam.h   |  264 +++
 drivers/media/v4l2-core/v4l2-common.c              |   18 +
 include/media/v4l2-common.h                        |    3 +
 10 files changed, 2588 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/bcm2835-unicam.txt
 create mode 100644 drivers/media/platform/bcm2835/Kconfig
 create mode 100644 drivers/media/platform/bcm2835/Makefile
 create mode 100644 drivers/media/platform/bcm2835/bcm2835-unicam.c
 create mode 100644 drivers/media/platform/bcm2835/vc4-regs-unicam.h

-- 
2.7.4
