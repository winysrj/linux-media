Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:34091 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934791AbcKMWqS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 Nov 2016 17:46:18 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by galahad.ideasonboard.com (Postfix) with ESMTPSA id 97C6F2006D
        for <linux-media@vger.kernel.org>; Sun, 13 Nov 2016 23:45:12 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.10] Renesas R-Car FDP1 driver
Date: Mon, 14 Nov 2016 00:46:23 +0200
Message-ID: <2172364.WBr6Pj0SaB@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 1001354ca34179f3db924eb66672442a173147dc:

  Linux 4.9-rc1 (2016-10-15 12:17:50 -0700)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git fdp1/next

for you to fetch changes up to bba78375df219a4a1fecc2a0c716c10e04e1e399:

  v4l: Add Renesas R-Car FDP1 Driver (2016-10-24 14:49:42 +0300)

----------------------------------------------------------------
Kieran Bingham (2):
      dt-bindings: Add Renesas R-Car FDP1 bindings
      v4l: Add Renesas R-Car FDP1 Driver

Laurent Pinchart (1):
      v4l: ctrls: Add deinterlacing mode control

 .../devicetree/bindings/media/renesas,fdp1.txt          |   37 +
 Documentation/media/uapi/v4l/extended-controls.rst      |    4 +
 Documentation/media/v4l-drivers/index.rst               |    3 +
 Documentation/media/v4l-drivers/rcar-fdp1.rst           |   37 +
 MAINTAINERS                                             |    9 +
 drivers/media/platform/Kconfig                          |   13 +
 drivers/media/platform/Makefile                         |    1 +
 drivers/media/platform/rcar_fdp1.c                      | 2445 ++++++++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c                    |    2 +
 include/uapi/linux/v4l2-controls.h                      |    1 +
 10 files changed, 2552 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/renesas,fdp1.txt
 create mode 100644 Documentation/media/v4l-drivers/rcar-fdp1.rst
 create mode 100644 drivers/media/platform/rcar_fdp1.c

-- 
Regards,

Laurent Pinchart

