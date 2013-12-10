Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35696 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab3LJN3N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 08:29:13 -0500
Received: from avalon.localnet (9.6-200-80.adsl-dyn.isp.belgacom.be [80.200.6.9])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 2A0FD35A6A
	for <linux-media@vger.kernel.org>; Tue, 10 Dec 2013 14:28:25 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.14] OMAP4 ISS fixes
Date: Tue, 10 Dec 2013 14:29:23 +0100
Message-ID: <2970364.6xFiHIOhl1@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 431cb350187c6bf1ed083622d633418a298a7216:

  [media] az6007: support Technisat Cablestar Combo HDCI (minus remote) 
(2013-12-10 07:15:54 -0200)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git omap4iss/next

for you to fetch changes up to 049b02eb38f96cc38ade4a3424451d1db4960b28:

  v4l: omap4iss: resizer: Fix comment regarding bypass mode (2013-12-10 
14:26:28 +0100)

----------------------------------------------------------------
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
      v4l: omap4iss: Make __iss_video_get_format() return a v4l2_mbus_framefmt
      v4l: omap4iss: Add enum_fmt_vid_cap ioctl support
      v4l: omap4iss: Propagate stop timeouts from submodules to the driver 
core
      v4l: omap4iss: Enable/disabling the ISP interrupts globally
      v4l: omap4iss: Reset the ISS when the pipeline can't be stopped
      v4l: omap4iss: csi2: Replace manual if statement with a subclk field
      v4l: omap4iss: Cancel streaming when a fatal error occurs
      v4l: omap4iss: resizer: Fix comment regarding bypass mode

 drivers/staging/media/omap4iss/iss.c         | 337 +++++++++++++++--------
 drivers/staging/media/omap4iss/iss.h         |  89 ++++++-
 drivers/staging/media/omap4iss/iss_csi2.c    | 184 ++++++-------
 drivers/staging/media/omap4iss/iss_csi2.h    |   8 +-
 drivers/staging/media/omap4iss/iss_csiphy.c  |  39 +--
 drivers/staging/media/omap4iss/iss_csiphy.h  |   6 +-
 drivers/staging/media/omap4iss/iss_ipipe.c   |  59 ++--
 drivers/staging/media/omap4iss/iss_ipipeif.c | 180 ++++++-------
 drivers/staging/media/omap4iss/iss_regs.h    | 502 +++++++++++++-------------
 drivers/staging/media/omap4iss/iss_resizer.c | 242 ++++++++---------
 drivers/staging/media/omap4iss/iss_video.c   | 174 +++++++++---
 drivers/staging/media/omap4iss/iss_video.h   |   8 +-
 12 files changed, 1046 insertions(+), 782 deletions(-)

-- 
Regards,

Laurent Pinchart

