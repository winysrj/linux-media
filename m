Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45218 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304Ab1GORuR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 13:50:17 -0400
Received: from lancelot.localnet (unknown [91.178.94.100])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 63C93359A4
	for <linux-media@vger.kernel.org>; Fri, 15 Jul 2011 17:50:16 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.1] uvcvideo fix
Date: Fri, 15 Jul 2011 19:50:10 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201107151950.11569.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit bec969c908bb22931fd5ab8ecdf99de8702a6a31:

  [media] v4l: s5p-tv: add TV Mixer driver for Samsung S5P platform 
(2011-07-14 13:09:48 -0300)

are available in the git repository at:
  git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-next

Stephan Lachowsky (1):
      uvcvideo: Fix control mapping for devices with multiple chains

 drivers/media/video/uvc/uvc_ctrl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

-- 
Regards,

Laurent Pinchart
