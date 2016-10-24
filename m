Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52725 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936457AbcJXJDo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Oct 2016 05:03:44 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran@ksquared.org.uk>
Subject: [PATCH v4 0/4] v4l: platform: Add Renesas R-Car FDP1 Driver
Date: Mon, 24 Oct 2016 12:03:34 +0300
Message-Id: <1477299818-31935-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Here's the fourth version of the Renesas R-Car FDP1 driver.

The FDP1 (Fine Display Processor) is a hardware memory-to-memory de-interlacer
device, with capability to convert from various YCbCr/YUV formats to both
YCbCr/YUV and RGB formats at the same time as converting interlaced content to
progressive.

Patch 01/04 adds a new standard V4L2 menu control for the deinterlacing mode.
The menu items are driver specific.

Patches 02/04 and 03/04 add DT bindings and a new driver for the FDP1.
Compared to v3, all FDP1 patches have been squashed together after being
reviewed by Kieran, and Kieran's e-mail address has been updated to
'kieran+renesas@bingham.xyz' in all Signed-off-by and authorship lines.

Patch 04/04 then adds an FDP1 instance to the R-Car M3-W SoC DT. It will be
merged separately through the ARM-SoC tree and depends on patch "arm64: dts:
renesas: r8a7796: Add FCPF and FCPV instances" scheduled for merge in v4.10.

Kieran Bingham (2):
  dt-bindings: Add Renesas R-Car FDP1 bindings
  v4l: Add Renesas R-Car FDP1 Driver

Laurent Pinchart (2):
  v4l: ctrls: Add deinterlacing mode control
  arm64: dts: renesas: r8a7796: Add FDP1 instance

 .../devicetree/bindings/media/renesas,fdp1.txt     |   33 +
 Documentation/media/uapi/v4l/extended-controls.rst |    4 +
 Documentation/media/v4l-drivers/index.rst          |    3 +
 Documentation/media/v4l-drivers/rcar-fdp1.rst      |   37 +
 MAINTAINERS                                        |    9 +
 arch/arm64/boot/dts/renesas/r8a7796.dtsi           |    9 +
 drivers/media/platform/Kconfig                     |   13 +
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/rcar_fdp1.c                 | 2446 ++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c               |    2 +
 include/uapi/linux/v4l2-controls.h                 |    1 +
 11 files changed, 2558 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/renesas,fdp1.txt
 create mode 100644 Documentation/media/v4l-drivers/rcar-fdp1.rst
 create mode 100644 drivers/media/platform/rcar_fdp1.c

-- 
Regards,

Laurent Pinchart

