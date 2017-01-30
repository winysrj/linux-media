Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59589 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752384AbdA3KrI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jan 2017 05:47:08 -0500
Received: from avalon.localnet (unknown [91.179.29.12])
        by galahad.ideasonboard.com (Postfix) with ESMTPSA id 9DF7A20098
        for <linux-media@vger.kernel.org>; Mon, 30 Jan 2017 11:46:09 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.11] OMAP3 ISP and OMAP4 ISS changes
Date: Mon, 30 Jan 2017 12:47:10 +0200
Message-ID: <2093918.XGWHg47VVU@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 40eca140c404505c09773d1c6685d818cb55ab1a:

  [media] mn88473: add DVB-T2 PLP support (2016-12-27 14:00:15 -0200)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git omap3isp/next

for you to fetch changes up to 2ea65cbd5684934bcda4fc140a34cb2746c2c80b:

  v4l: omap4iss: Clean up file handle in open() and release() (2017-01-30 
12:45:46 +0200)

----------------------------------------------------------------
Shailendra Verma (2):
      v4l: omap3isp: Clean up file handle in open() and release()
      v4l: omap4iss: Clean up file handle in open() and release()

 drivers/media/platform/omap3isp/ispvideo.c | 2 ++
 drivers/staging/media/omap4iss/iss_video.c | 2 ++
 2 files changed, 4 insertions(+)

-- 
Regards,

Laurent Pinchart

