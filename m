Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:41254 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753479AbeDSQdh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 12:33:37 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 0/4] Improve v4l2-compat-ioctl32 handler getting rid of smatch warnings
Date: Thu, 19 Apr 2018 12:33:28 -0400
Message-Id: <cover.1524155425.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series correspond to the last 3 patches of my previous patch series:
	https://www.spinics.net/lists/linux-media/msg132453.html

It contains the compat32 related bits.

Version 2 addresses some comments from Hans.
It adds a new patch better documenting it.

Mauro Carvalho Chehab (4):
  media: v4l2-compat-ioctl32: fix several __user annotations
  media: v4l2-compat-ioctl32: better name userspace pointers
  media: v4l2-compat-ioctl32: simplify casts
  media: v4l2-compat-ioctl32: better document the code

 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 805 ++++++++++++++++----------
 1 file changed, 496 insertions(+), 309 deletions(-)

-- 
2.14.3
