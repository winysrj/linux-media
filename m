Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45359 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932510Ab3JOQ2b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Oct 2013 12:28:31 -0400
Received: from avalon.localnet (unknown [91.177.131.201])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 7913B35A47
	for <linux-media@vger.kernel.org>; Tue, 15 Oct 2013 18:27:56 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.13] uvcvideo fix
Date: Tue, 15 Oct 2013 18:28:47 +0200
Message-ID: <7765768.sADSukMofm@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 4699b5f34a09e6fcc006567876b0c3d35a188c62:

  [media] cx24117: prevent mutex to be stuck on locked state if FE init fails 
(2013-10-14 06:38:56 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-next

for you to fetch changes up to c7f6c5481b5713c3c2255d885271a7519bb198ca:

  uvcvideo: Fix data type for pan/tilt control (2013-10-15 18:22:08 +0200)

----------------------------------------------------------------
Chanho Min (1):
      uvcvideo: Fix data type for pan/tilt control

 drivers/media/usb/uvc/uvc_ctrl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
Regards,

Laurent Pinchart

