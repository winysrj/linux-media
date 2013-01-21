Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40317 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab3AULJs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jan 2013 06:09:48 -0500
Received: from avalon.localnet (unknown [91.178.41.12])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id E8414359DB
	for <linux-media@vger.kernel.org>; Mon, 21 Jan 2013 12:09:47 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.9] uvcvideo fixes
Date: Mon, 21 Jan 2013 12:11:30 +0100
Message-ID: <8941823.6hYmFOuMdv@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 3151d14aa6e983aa36d51a80d0477859f9ba12af:

  [media] media: remove __dev* annotations (2013-01-11 13:03:24 -0200)

are available in the git repository at:
  git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-next

Ezequiel Garcia (1):
      uvcvideo: Replace memcpy with struct assignment

Oliver Neukum (1):
      uvcvideo: Fix race of open and suspend in error case

 drivers/media/usb/uvc/uvc_ctrl.c |    2 +-
 drivers/media/usb/uvc/uvc_v4l2.c |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

The corresponding patchwork commands are

pwclient update -s 'accepted' 16201
pwclient update -s 'accepted' 16253

-- 
Regards,

Laurent Pinchart

