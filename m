Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:52899 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465Ab2AYPFl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jan 2012 10:05:41 -0500
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id q0PF5dp6009764
	for <linux-media@vger.kernel.org>; Wed, 25 Jan 2012 09:05:40 -0600
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH 0/4] davinci: add vpif support for da850/omap-l138
Date: Wed, 25 Jan 2012 20:35:30 +0530
Message-ID: <1327503934-28186-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

add vpif capture and display driver support for
da850/omap-l138 by taking care of the interrupt 
behavior changes and removing platform specific
connotations.

Manjunath Hadli (4):
  davinci: vpif: add check for genuine interrupts in the isr
  davinci: vpif: make generic changes to re-use the vpif drivers on
    da850/omap-l138 soc
  davinci: vpif: make request_irq flags as shared
  davinci: da850: add build configuration for vpif drivers

 drivers/media/video/davinci/Kconfig        |   26 +++++++++++++++++++++++++-
 drivers/media/video/davinci/Makefile       |    5 +++++
 drivers/media/video/davinci/vpif.c         |    2 +-
 drivers/media/video/davinci/vpif_capture.c |   16 ++++++++++------
 drivers/media/video/davinci/vpif_display.c |   21 +++++++++++++--------
 drivers/media/video/davinci/vpif_display.h |    2 +-
 include/media/davinci/vpif_types.h         |    2 ++
 7 files changed, 57 insertions(+), 17 deletions(-)

