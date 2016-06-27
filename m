Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57726 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbcF0Mdp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2016 08:33:45 -0400
Received: from avalon.localnet (33.154-246-81.adsl-dyn.isp.belgacom.be [81.246.154.33])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id 04CC320010
	for <linux-media@vger.kernel.org>; Mon, 27 Jun 2016 14:31:13 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.8] V4L2 core fixes
Date: Mon, 27 Jun 2016 15:34:07 +0300
Message-ID: <1532561.v6UYOJVH7L@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 0db5c79989de2c68d5abb7ba891bfdb3cd3b7e05:

  [media] media-devnode.h: Fix documentation (2016-06-16 08:14:56 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git v4l2/core

for you to fetch changes up to 7dccb13aef849b9e9e02faa3c46269bb130297d3:

  videodev2.h: Fix V4L2_PIX_FMT_YUV411P description (2016-06-27 15:32:54 
+0300)

----------------------------------------------------------------
Laurent Pinchart (2):
      videodev2.h: Group YUV 3 planes formats together
      videodev2.h: Fix V4L2_PIX_FMT_YUV411P description

 include/uapi/linux/videodev2.h | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

-- 
Regards,

Laurent Pinchart

