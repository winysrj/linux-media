Return-path: <mchehab@pedra>
Received: from rtp-iport-1.cisco.com ([64.102.122.148]:27938 "EHLO
	rtp-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab0JVHBD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Oct 2010 03:01:03 -0400
From: mats.randgaard@tandberg.com
To: hvaibhav@ti.com
Cc: linux-media@vger.kernel.org, hans.verkuil@tandberg.com,
	Mats Randgaard <mats.randgaard@tandberg.com>
Subject: [RFC/PATCH 0/5] DaVinci VPIF: Support for DV preset and DV timings.
Date: Fri, 22 Oct 2010 09:00:46 +0200
Message-Id: <1287730851-18579-1-git-send-email-mats.randgaard@tandberg.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Mats Randgaard <mats.randgaard@tandberg.com>

Support for DV preset and timings added to vpif_capture and vpif_display drivers.
Functions for debugging are added and the code is improved as well.

Mats Randgaard (5):
  vpif_cap/disp: Add debug functionality
  vpif: Move and extend ch_params[]
  vpif_cap/disp: Added support for DV presets
  vpif_cap/disp: Added support for DV timings
  vpif_cap/disp: Cleanup, improved comments

 drivers/media/video/davinci/vpif.c         |  178 +++++++++++++
 drivers/media/video/davinci/vpif.h         |   18 +-
 drivers/media/video/davinci/vpif_capture.c |  380 ++++++++++++++++++++++++++--
 drivers/media/video/davinci/vpif_capture.h |    2 +
 drivers/media/video/davinci/vpif_display.c |  370 +++++++++++++++++++++++++--
 drivers/media/video/davinci/vpif_display.h |    2 +
 6 files changed, 893 insertions(+), 57 deletions(-)

