Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44095 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129Ab3LDA4Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 19:56:24 -0500
Received: from avalon.ideasonboard.com (unknown [91.177.177.98])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id C773135A6A
	for <linux-media@vger.kernel.org>; Wed,  4 Dec 2013 01:55:37 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 00/25] OMAP4 ISS fixes
Date: Wed,  4 Dec 2013 01:56:00 +0100
Message-Id: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Here's a first round of fixes for the OMAP4 ISS driver, based on top of the
linuxtv master branch. Given the very diverse nature of the patches, please
see the individual commit messages for more information.

Laurent Pinchart (25):
  v4l: omap4iss: Replace printk by dev_err
  v4l: omap4iss: Don't split log strings on multiple lines
  v4l: omap4iss: Restrict line lengths to 80 characters where possible
  v4l: omap4iss: Remove double semicolon at end of line
  v4l: omap4iss: Define more ISS and ISP IRQ register bits
  v4l: omap4iss: isif: Define more VDINT registers
  v4l: omap4iss: Enhance IRQ debugging
  v4l: omap4iss: Don't make IRQ debugging functions inline
  v4l: omap4iss: Fix operators precedence in ternary operators
  v4l: omap4iss: isif: Ignore VD0 interrupts when no buffer is available
  v4l: omap4iss: ipipeif: Shift input data according to the input format
  v4l: omap4iss: csi2: Enable automatic ULP mode transition
  v4l: omap4iss: Create and use register access functions
  v4l: omap4iss: csi: Create and use register access functions
  v4l: omap4iss: resizer: Stop the whole resizer to avoid FIFO overflows
  v4l: omap4iss: Convert hexadecimal constants to lower case
  v4l: omap4iss: Add description field to iss_format_info structure
  v4l: omap4iss: Make __iss_video_get_format() return a
    v4l2_mbus_framefmt
  v4l: omap4iss: Add enum_fmt_vid_cap ioctl support
  v4l: omap4iss: Propagate stop timeouts from submodules to the driver
    core
  v4l: omap4iss: Enable/disabling the ISP interrupts globally
  v4l: omap4iss: Reset the ISS when the pipeline can't be stopped
  v4l: omap4iss: csi2: Replace manual if statement with a subclk field
  v4l: omap4iss: Cancel streaming when a fatal error occurs
  v4l: omap4iss: resizer: Fix comment regarding bypass mode

 drivers/staging/media/omap4iss/iss.c         | 337 +++++++++++-------
 drivers/staging/media/omap4iss/iss.h         |  89 ++++-
 drivers/staging/media/omap4iss/iss_csi2.c    | 184 +++++-----
 drivers/staging/media/omap4iss/iss_csi2.h    |   8 +-
 drivers/staging/media/omap4iss/iss_csiphy.c  |  39 ++-
 drivers/staging/media/omap4iss/iss_csiphy.h  |   6 +-
 drivers/staging/media/omap4iss/iss_ipipe.c   |  59 ++--
 drivers/staging/media/omap4iss/iss_ipipeif.c | 180 +++++-----
 drivers/staging/media/omap4iss/iss_regs.h    | 502 ++++++++++++++-------------
 drivers/staging/media/omap4iss/iss_resizer.c | 242 ++++++-------
 drivers/staging/media/omap4iss/iss_video.c   | 174 ++++++++--
 drivers/staging/media/omap4iss/iss_video.h   |   8 +-
 12 files changed, 1046 insertions(+), 782 deletions(-)

-- 
Regards,

Laurent Pinchart

