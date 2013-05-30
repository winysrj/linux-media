Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60456 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966739Ab3E3DfV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 23:35:21 -0400
Received: from avalon.localnet (p2155-ipngn4501marunouchi.tokyo.ocn.ne.jp [153.135.240.155])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 5E22135A4D
	for <linux-media@vger.kernel.org>; Thu, 30 May 2013 05:35:17 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.11] uvcvideo patches
Date: Thu, 30 May 2013 05:35:18 +0200
Message-ID: <1695053.ptG3MVOcOO@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 7eac97d7e714429f7ef1ba5d35f94c07f4c34f8e:

  [media] media: pci: remove duplicate checks for EPERM (2013-05-27 09:34:56 
-0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-next

for you to fetch changes up to f8ba161bd9a9cd474839e25e9729187766633056:

  uvcvideo: Fix open/close race condition (2013-05-30 05:31:59 +0200)

----------------------------------------------------------------
Joseph Salisbury (1):
      uvcvideo: quirk PROBE_DEF for Alienware X51 OmniVision webcam

Kamal Mostafa (1):
      uvcvideo: quirk PROBE_DEF for Dell Studio / OmniVision webcam

Laurent Pinchart (1):
      uvcvideo: Fix open/close race condition

 drivers/media/usb/uvc/uvc_driver.c | 41 +++++++++++++++++++++++++++++++------
 drivers/media/usb/uvc/uvc_status.c | 21 ++-------------------
 drivers/media/usb/uvc/uvc_v4l2.c   | 14 ++++++++++----
 drivers/media/usb/uvc/uvcvideo.h   |  7 +++----
 4 files changed, 50 insertions(+), 33 deletions(-)

-- 
Regards,

Laurent Pinchart

