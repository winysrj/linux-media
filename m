Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:36303 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998Ab1H2JIj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Aug 2011 05:08:39 -0400
From: <hvaibhav@ti.com>
To: <linux-media@vger.kernel.org>
CC: <mchehab@redhat.com>
Subject: [GIT PULL for v3.1-rc] OMAP_VOUT: Fix build failure
Date: Mon, 29 Aug 2011 14:38:28 +0530
Message-ID: <1314608908-7264-1-git-send-email-hvaibhav@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

I missed this patch for last rc release, can you please queue up for
next rc.


The following changes since commit 55f9c40ff632d03c527d6a6ceddcda0a224587a6:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/sparc

are available in the git repository at:

  git://arago-project.org/git/people/vaibhav/ti-psp-omap-video.git for-linux-media-rc

Archit Taneja (1):
      OMAP_VOUT: Fix build break caused by update_mode removal in DSS2

 drivers/media/video/omap/omap_vout.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)
