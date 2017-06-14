Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00252a01.pphosted.com ([91.207.212.211]:55677 "EHLO
        mx08-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752180AbdFNPQV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 11:16:21 -0400
Received: from pps.filterd (m0102629.ppops.net [127.0.0.1])
        by mx08-00252a01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5EFDvV6008728
        for <linux-media@vger.kernel.org>; Wed, 14 Jun 2017 16:16:14 +0100
Received: from mail-wr0-f200.google.com (mail-wr0-f200.google.com [209.85.128.200])
        by mx08-00252a01.pphosted.com with ESMTP id 2b058et6e0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Wed, 14 Jun 2017 16:16:14 +0100
Received: by mail-wr0-f200.google.com with SMTP id g36so1029871wrg.4
        for <linux-media@vger.kernel.org>; Wed, 14 Jun 2017 08:16:14 -0700 (PDT)
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-rpi-kernel@lists.infradead.org
Cc: Dave Stevenson <dave.stevenson@raspberrypi.org>
Subject: [RFC 0/2] BCM283x Camera Receiver driver
Date: Wed, 14 Jun 2017 16:15:45 +0100
Message-Id: <cover.1497452006.git.dave.stevenson@raspberrypi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All.

This is adding a V4L2 subdevice driver for the CSI2/CCP2 camera
receiver peripheral on BCM283x, as used on Raspberry Pi.

v4l2-compliance results depend on the sensor subdevice this is
connected to. It passes the basic tests cleanly with TC358743,
but objects with OV5647
fail: v4l2-test-controls.cpp(574): g_ext_ctrls does not support count == 0
Neither OV5647 nor Unicam support any controls.

I must admit to not having got OV5647 to stream with the current driver
register settings. It works with a set of register settings for VGA RAW10.
I also have a couple of patches pending for OV5647, but would like to
understand the issues better before sending them out.

Two queries I do have in V4L2-land:
- When s_dv_timings or s_std is called, is the format meant to
  be updated automatically? Even if we're already streaming?
  Some existing drivers seem to, but others don't.
- With s_fmt, is sizeimage settable by the application in the same
  way as bytesperline? yavta allows you to specify it on the command
  line, whilst v4l2-ctl doesn't. Some of the other parts of the Pi
  firmware have a requirement that the buffer is a multiple of 16 lines
  high, which can be matched by V4L2 if we can over-allocate the
  buffers by the app specifying sizeimage. But if I allow that,
  then I get a v4l2-compliance failure as the size doesn't get
  reset when switching from RGB3 to UYVY as it takes the request as
  a request to over-allocate.

Apologies if I've messed up in sending these patches - so many ways
to do something.

Thanks in advance.
  Dave

Dave Stevenson (2):
  [media] dt-bindings: Document BCM283x CSI2/CCP2 receiver
  [media] bcm2835-unicam: Driver for CCP2/CSI2 camera interface

 .../devicetree/bindings/media/bcm2835-unicam.txt   |   76 +
 drivers/media/platform/Kconfig                     |    1 +
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/bcm2835/Kconfig             |   14 +
 drivers/media/platform/bcm2835/Makefile            |    3 +
 drivers/media/platform/bcm2835/bcm2835-unicam.c    | 2100 ++++++++++++++++++++
 drivers/media/platform/bcm2835/vc4-regs-unicam.h   |  257 +++
 7 files changed, 2453 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/bcm2835-unicam.txt
 create mode 100644 drivers/media/platform/bcm2835/Kconfig
 create mode 100644 drivers/media/platform/bcm2835/Makefile
 create mode 100644 drivers/media/platform/bcm2835/bcm2835-unicam.c
 create mode 100644 drivers/media/platform/bcm2835/vc4-regs-unicam.h

-- 
2.7.4
