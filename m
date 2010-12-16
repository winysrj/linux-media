Return-path: <mchehab@gaivota>
Received: from rtp-iport-2.cisco.com ([64.102.122.149]:2687 "EHLO
	rtp-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756335Ab0LPP1L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Dec 2010 10:27:11 -0500
From: mats.randgaard@cisco.com
To: linux-media@vger.kernel.org
Cc: mats.randgaard@cisco.com
Subject: [PATCH 0/5] DaVinci VPIF: Support for DV preset and DV timings. 
Date: Thu, 16 Dec 2010 16:17:40 +0100
Message-Id: <1292512665-22538-1-git-send-email-mats.randgaard@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: Mats Randgaard <mats.randgaard@cisco.com>

Support for DV preset and timings added to vpif_capture and vpif_display drivers.
Functions for debugging are added and the code is improved as well.

Mats Randgaard (5):
  vpif_cap/disp: Add debug functionality
  vpif: Consolidate formats from capture and display
  vpif_cap/disp: Add support for DV presets
  vpif_cap/disp: Added support for DV timings
  vpif_cap/disp: Cleanup, improved comments

 drivers/media/video/davinci/vpif.c         |  177 ++++++++++++
 drivers/media/video/davinci/vpif.h         |   18 +-
 drivers/media/video/davinci/vpif_capture.c |  361 +++++++++++++++++++++++--
 drivers/media/video/davinci/vpif_capture.h |    2 +
 drivers/media/video/davinci/vpif_display.c |  402 +++++++++++++++++++++++++---
 drivers/media/video/davinci/vpif_display.h |    2 +
 6 files changed, 886 insertions(+), 76 deletions(-)

