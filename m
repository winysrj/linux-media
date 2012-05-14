Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58805 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756614Ab2ENP40 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 May 2012 11:56:26 -0400
Date: Mon, 14 May 2012 18:56:22 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, laurent.pinchart@ideasonboard.com
Subject: [GIT PULL FOR v3.5] Implement V4L2_CID_PIXEL_RATE in various
 drivers
Message-ID: <20120514155622.GJ3373@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Here are a few patches that implement V4L2_CID_PIXEL_RATE in a couple of
drivers. The control is soon required by some CSI-2 receivers to configure
the hardware, such as the OMAP 3 ISP one.

---

The following changes since commit e89fca923f32de26b69bf4cd604f7b960b161551:

  [media] gspca - ov534: Add Hue control (2012-05-14 09:48:00 -0300)

are available in the git repository at:
  ssh://linuxtv.org/git/sailus/media_tree.git media-for-3.5

Laurent Pinchart (3):
      mt9t001: Implement V4L2_CID_PIXEL_RATE control
      mt9p031: Implement V4L2_CID_PIXEL_RATE control
      mt9m032: Implement V4L2_CID_PIXEL_RATE control

 drivers/media/video/mt9m032.c |   13 +++++++++++--
 drivers/media/video/mt9p031.c |    5 ++++-
 drivers/media/video/mt9t001.c |   13 +++++++++++--
 include/media/mt9t001.h       |    1 +
 4 files changed, 27 insertions(+), 5 deletions(-)



-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
