Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46043 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab3AKNxI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jan 2013 08:53:08 -0500
Received: from avalon.localnet (unknown [91.178.45.2])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 8F3A535A82
	for <linux-media@vger.kernel.org>; Fri, 11 Jan 2013 14:53:07 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.8] uvcvideo fixes
Date: Fri, 11 Jan 2013 14:54:50 +0100
Message-ID: <1693696.M4Zb09gsEn@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 9931faca02c604c22335f5a935a501bb2ace6e20:

  Linux 3.8-rc3 (2013-01-09 18:59:55 -0800)

are available in the git repository at:
  git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-stable

Laurent Pinchart (3):
      uvcvideo: Return -EACCES when trying to set a read-only control
      uvcvideo: Cleanup leftovers of partial revert
      uvcvideo: Set error_idx properly for S_EXT_CTRLS failures

 drivers/media/usb/uvc/uvc_ctrl.c |    4 +++-
 drivers/media/usb/uvc/uvc_v4l2.c |    6 ++----
 2 files changed, 5 insertions(+), 5 deletions(-)

The corresponding patchwork are

pwclient update -s 'accepted' 16212
pwclient update -s 'accepted' 16213
pwclient update -s 'accepted' 16214

(I've manually marked v1 as superseded through the web interface)

-- 
Regards,

Laurent Pinchart

