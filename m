Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40229 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932478Ab1JXNpY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Oct 2011 09:45:24 -0400
Received: from lancelot.localnet (unknown [85.13.70.251])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 62AE335999
	for <linux-media@vger.kernel.org>; Mon, 24 Oct 2011 13:45:23 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.2] uvcvideo fixes
Date: Mon, 24 Oct 2011 15:45:47 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110241545.48557.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 35a912455ff5640dc410e91279b03e04045265b2:

  Merge branch 'v4l_for_linus' into staging/for_v3.2 (2011-10-19 12:41:18 
-0200)

are available in the git repository at:

  git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-next

Hans de Goede (1):
      uvcvideo: GET_RES should only be checked for BITMAP type menu controls

 drivers/media/video/uvc/uvc_ctrl.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

-- 
Regards,

Laurent Pinchart
