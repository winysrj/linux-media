Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45067 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab3FYAB2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jun 2013 20:01:28 -0400
Received: from avalon.localnet (unknown [91.178.213.225])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id B086B35A4D
	for <linux-media@vger.kernel.org>; Tue, 25 Jun 2013 02:01:19 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.11] uvcvideo Kconfig dependency fix
Date: Tue, 25 Jun 2013 02:01:49 +0200
Message-ID: <3613317.mCisrll7GG@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Sorry for the late pull request. This small patch fixes a Kconfig dependency 
that can prevent the kernel from building. Is it still possible to get it to 
v3.11 ?

The following changes since commit ee17608d6aa04a86e253a9130d6c6d00892f132b:

  [media] imx074: support asynchronous probing (2013-06-21 16:36:15 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-next

for you to fetch changes up to e0bfc7456ea282bc8532d8f5747d44033ba104ae:

  uvc: Depend on VIDEO_V4L2 (2013-06-25 01:58:36 +0200)

----------------------------------------------------------------
Laurent Pinchart (1):
      uvc: Depend on VIDEO_V4L2

 drivers/media/usb/uvc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

-- 
Regards,

Laurent Pinchart

