Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:37769 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752085AbeDSLQB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 07:16:01 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Daniel Mentz <danielmentz@google.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH RESEND 0/6] Remaining COMPILE_TEST and smatch cleanups
Date: Thu, 19 Apr 2018 07:15:45 -0400
Message-Id: <cover.1524136402.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm re-sending this patch series, because I forgot to add a C/C on the first
patch of this series. Also, the last patch was sent in separate. So, better
to repost this series.

-

There were several interactions at the COMPILE_TEST and smatch
patch series. While I applied most of them, there are 5 patches that
I kept out of it. The omap3 patch that were in my tree was the old
one. So, I'm re-posting it.

The ioctl32 patches are the latest version. Let's repost it to get some
acks, as this patch touches at V4L2 core, so a careful review is
always a good idea.

Arnd Bergmann (1):
  media: omap3isp: Allow it to build with COMPILE_TEST

Laurent Pinchart (1):
  media: omap3isp: Enable driver compilation on ARM with COMPILE_TEST

Mauro Carvalho Chehab (4):
  omap: omap-iommu.h: allow building drivers with COMPILE_TEST
  media: v4l2-compat-ioctl32: fix several __user annotations
  media: v4l2-compat-ioctl32: better name userspace pointers
  media: v4l2-compat-ioctl32: simplify casts

 drivers/media/platform/Kconfig                |   7 +-
 drivers/media/platform/omap3isp/isp.c         |   8 +
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 641 ++++++++++++++------------
 include/linux/omap-iommu.h                    |   5 +
 4 files changed, 354 insertions(+), 307 deletions(-)

-- 
2.14.3
