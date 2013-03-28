Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46525 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab3C1LzI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Mar 2013 07:55:08 -0400
Received: from avalon.localnet (unknown [91.177.137.142])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id ABF7835A54
	for <linux-media@vger.kernel.org>; Thu, 28 Mar 2013 12:54:52 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.10] uvcvideo fix
Date: Thu, 28 Mar 2013 12:55:58 +0100
Message-ID: <2013957.FD5NngIJSl@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 004e45d736bfe62159bd4dc1549eff414bd27496:

  [media] tuner-core: handle errors when getting signal strength/afc 
(2013-03-25 15:10:43 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-next

for you to fetch changes up to a5104bfc835d4e8a9420f558a2a7b1a8da30f5a6:

  uvcvideo: Return -EINVAL when setting a menu control to an invalid value 
(2013-03-28 12:53:48 +0100)

----------------------------------------------------------------
Laurent Pinchart (1):
      uvcvideo: Return -EINVAL when setting a menu control to an invalid value

 drivers/media/usb/uvc/uvc_ctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
Regards,

Laurent Pinchart

