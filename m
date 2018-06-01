Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:54198 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751801AbeFATuG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Jun 2018 15:50:06 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Heiko Stuebner <heiko@sntech.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jacob chen <jacob2.chen@rock-chips.com>,
        linux-rockchip@lists.infradead.org,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 0/2] rockchip/rga: A fix and a cleanup
Date: Fri,  1 Jun 2018 16:49:50 -0300
Message-Id: <20180601194952.17440-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Decided to test v4l2transform filters and found these two
issues.

Without the first commit, start_streaming fails. The second
commit is just a cleanup, removing a seemingly redundant
operation.

Tested on RK3288 Radxa Rock2 with these kind of pipelines:

gst-launch-1.0 videotestsrc ! video/x-raw,width=640,height=480,framerate=30/1,format=RGB ! v4l2video0convert ! video/x-raw,width=1920,height=1080,framerate=30/1,format=NV16 ! fakesink

gst-launch-1.0 v4l2src device=/dev/video1 ! video/x-raw,width=640,height=480,framerate=30/1,format=RGB ! v4l2video0convert ! video/x-raw,width=1920,height=1080,framerate=30/1,format=NV16 ! kmssink

Ezequiel Garcia (2):
  rockchip/rga: Fix broken .start_streaming
  rockchip/rga: Remove unrequired wait in .job_abort

 drivers/media/platform/rockchip/rga/rga-buf.c | 44 +++++++++----------
 drivers/media/platform/rockchip/rga/rga.c     | 13 +-----
 drivers/media/platform/rockchip/rga/rga.h     |  2 -
 3 files changed, 23 insertions(+), 36 deletions(-)

-- 
2.17.1
