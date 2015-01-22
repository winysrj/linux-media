Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59877 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbbAVMSV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2015 07:18:21 -0500
Received: from avalon.localnet (dsl-hkibrasgw3-50ddcc-40.dhcp.inet.fi [80.221.204.40])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id A069420AEF
	for <linux-media@vger.kernel.org>; Thu, 22 Jan 2015 13:14:10 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.20] uvcvideo fixes
Date: Thu, 22 Jan 2015 14:18:55 +0200
Message-ID: <6052863.3nxiOF9SjW@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 1fc77d013ba85a29e2edfaba02fd21e8c8187fae:

  [media] cx23885: Hauppauge WinTV-HVR5525 (2014-12-30 10:48:04 -0200)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git uvc/next

for you to fetch changes up to 3aeea86592772e69db7328ae2a35dd8212e77975:

  uvcvideo: remove unnecessary version.h inclusion (2015-01-22 14:15:06 +0200)

----------------------------------------------------------------
Aviv Greenberg (1):
      uvcvideo: Remove extra commit on resume()

Fabian Frederick (1):
      uvcvideo: remove unnecessary version.h inclusion

 drivers/media/usb/uvc/uvc_v4l2.c  | 1 -
 drivers/media/usb/uvc/uvc_video.c | 6 +++---
 2 files changed, 3 insertions(+), 4 deletions(-)

-- 
Regards,

Laurent Pinchart

