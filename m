Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45074 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724Ab2DWSHV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 14:07:21 -0400
Received: from avalon.localnet (unknown [91.178.216.230])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id BE23F7B0D
	for <linux-media@vger.kernel.org>; Mon, 23 Apr 2012 20:07:20 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for v3.5] uvcvideo fixes
Date: Mon, 23 Apr 2012 20:07:34 +0200
Message-ID: <5497184.zpSoyr2nta@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit aa6d5f29534a6d1459f9768c591a7a72aadc5941:

  [media] pluto2: remove some dead code (2012-04-19 17:15:32 -0300)

are available in the git repository at:
  git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-next

Laurent Pinchart (2):
      uvcvideo: Fix ENUMINPUT handling
      MAINTAINERS: Update UVC driver's mailing list address

 MAINTAINERS                        |    2 +-
 drivers/media/video/uvc/uvc_v4l2.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
Regards,

Laurent Pinchart

