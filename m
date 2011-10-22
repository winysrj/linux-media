Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:34149 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753462Ab1JVMGd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Oct 2011 08:06:33 -0400
From: <hvaibhav@ti.com>
To: <linux-media@vger.kernel.org>
CC: <mchehab@redhat.com>
Subject: [GIT PULL for v3.2] OMAP_VOUT: Few cleaups and feature addition
Date: Sat, 22 Oct 2011 17:36:24 +0530
Message-ID: <1319285184-14605-1-git-send-email-hvaibhav@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 35a912455ff5640dc410e91279b03e04045265b2:
  Mauro Carvalho Chehab (1):
        Merge branch 'v4l_for_linus' into staging/for_v3.2

are available in the git repository at:

  git://arago-project.org/git/people/vaibhav/ti-psp-omap-video.git for-linux-media

Archit Taneja (5):
      OMAP_VOUT: Fix check in reqbuf for buf_size allocation
      OMAP_VOUT: CLEANUP: Remove redundant code from omap_vout_isr
      OMAP_VOUT: Fix VSYNC IRQ handling in omap_vout_isr
      OMAP_VOUT: Add support for DSI panels
      OMAP_VOUT: Increase MAX_DISPLAYS to a larger value

 drivers/media/video/omap/omap_vout.c    |  187 ++++++++++++++++---------------
 drivers/media/video/omap/omap_voutdef.h |    2 +-
 2 files changed, 97 insertions(+), 92 deletions(-)
