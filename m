Return-path: <mchehab@pedra>
Received: from rtp-iport-2.cisco.com ([64.102.122.149]:13541 "EHLO
	rtp-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932530Ab0J1Gqj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Oct 2010 02:46:39 -0400
From: mats.randgaard@tandberg.com
To: hvaibhav@ti.com, mkaricheri@gmail.com
Cc: hans.verkuil@tandberg.com, linux-media@vger.kernel.org,
	Mats Randgaard <mats.randgaard@tandberg.com>
Subject: [RFCv2/PATCH 0/5] DaVinci VPIF: Support for DV preset and DV timings.
Date: Thu, 28 Oct 2010 08:46:18 +0200
Message-Id: <1288248383-12557-1-git-send-email-mats.randgaard@tandberg.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Mats Randgaard <mats.randgaard@tandberg.com>

Support for DV preset and timings added to vpif_capture and vpif_display drivers.
Functions for debugging are added and the code is improved as well.

Mats Randgaard (5):
  vpif_cap/disp: Add debug functionality
  vpif: Consolidate formats from capture and display
  vpif_cap/disp: Add support for DV presets
  vpif_cap/disp: Added support for DV timings
  vpif_cap/disp: Cleanup, improved comments

 drivers/media/video/davinci/vpif.c         |  177 ++++++++++++++
 drivers/media/video/davinci/vpif.h         |   18 +-
 drivers/media/video/davinci/vpif_capture.c |  357 ++++++++++++++++++++++++++--
 drivers/media/video/davinci/vpif_capture.h |    2 +
 drivers/media/video/davinci/vpif_display.c |  351 +++++++++++++++++++++++++--
 drivers/media/video/davinci/vpif_display.h |    2 +
 6 files changed, 850 insertions(+), 57 deletions(-)

