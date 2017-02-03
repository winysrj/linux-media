Return-path: <linux-media-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:52726 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751134AbdBCR0o (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Feb 2017 12:26:44 -0500
Received: from mailhost.synopsys.com (mailhost1.synopsys.com [10.12.238.239])
        by smtprelay.synopsys.com (Postfix) with ESMTP id B769F10C1466
        for <linux-media@vger.kernel.org>; Fri,  3 Feb 2017 09:26:43 -0800 (PST)
Received: from mailhost.synopsys.com (localhost [127.0.0.1])
        by mailhost.synopsys.com (Postfix) with ESMTP id 9E53A7DD
        for <linux-media@vger.kernel.org>; Fri,  3 Feb 2017 09:26:43 -0800 (PST)
Received: from arc-dev.internal.synopsys.com (roliveir-e7470.internal.synopsys.com [10.107.25.136])
        by mailhost.synopsys.com (Postfix) with ESMTP id E1E8E7D2
        for <linux-media@vger.kernel.org>; Fri,  3 Feb 2017 09:26:42 -0800 (PST)
From: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
To: linux-media@vger.kernel.org
Subject: [PATCH RESEND v7 0/2] Add support for Omnivision OV5647
Date: Fri,  3 Feb 2017 17:25:47 +0000
Message-Id: <cover.1486136893.git.roliveir@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'm resending this patchset since it didn't have much feedback, and it
already had two ACKs, one in each patch.

This patchset adds support for the Omnivision OV5647 sensor.

At the moment it only supports 640x480 in RAW 8.

This is the seventh version of the OV5647 camera driver patchset.

v7:
 - Remove "0x" and leading 0 from DT documentation examples

v6:
 - Add example to DT documentation
 - Remove data-lanes and clock-lane property from DT
 - Add external clock property to DT
 - Order includes
 - Remove unused variables and functions
 - Add external clock handling
 - Add power on counter
 - Change from g/s_parm to g/s_frame_interval

v5:
 - Refactor code 
 - Change comments
 - Add missing error handling in some functions

v4: 
 - Add correct license
 - Revert debugging info to generic infrastructure
 - Turn defines into enums
 - Correct code style issues
 - Remove unused defines
 - Make sure all errors where being handled
 - Rename some functions to make code more readable
 - Add some debugging info

v3: 
 - No changes. Re-submitted due to lack of responses

v2: 
 - Corrections in DT documentation

Ramiro Oliveira (2):
  Add OV5647 device tree documentation
  Add support for OV5647 sensor.

 .../devicetree/bindings/media/i2c/ov5647.txt       |  35 +
 MAINTAINERS                                        |   7 +
 drivers/media/i2c/Kconfig                          |  12 +
 drivers/media/i2c/Makefile                         |   1 +
 drivers/media/i2c/ov5647.c                         | 718 +++++++++++++++++++++
 5 files changed, 773 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5647.txt
 create mode 100644 drivers/media/i2c/ov5647.c

-- 
2.11.0


