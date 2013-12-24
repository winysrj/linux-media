Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52632 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab3LXMXm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Dec 2013 07:23:42 -0500
Received: from avalon.localnet (unknown [91.178.148.87])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 08E0935A67
	for <linux-media@vger.kernel.org>; Tue, 24 Dec 2013 13:22:51 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.14] OMAP4 ISS fixes
Date: Tue, 24 Dec 2013 13:24:08 +0100
Message-ID: <1772163.7Po6Rjmdc4@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 7d459937dc09bb8e448d9985ec4623779427d8a5:

  [media] Add driver for Samsung S5K5BAF camera sensor (2013-12-21 07:01:36 
-0200)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git omap4iss/next

for you to fetch changes up to 7b5084c8f99aea161ab53cce828357912ec80891:

  v4l: omap4iss: Restore irq flags correctly in omap4iss_video_buffer_next() 
(2013-12-24 13:23:09 +0100)

----------------------------------------------------------------
Dan Carpenter (2):
      v4l: omap4iss: use snprintf() to make smatch happy
      v4l: omap4iss: Restore irq flags correctly in 
omap4iss_video_buffer_next()

 drivers/staging/media/omap4iss/iss_csi2.c  | 3 +--
 drivers/staging/media/omap4iss/iss_video.c | 4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

-- 
Regards,

Laurent Pinchart

