Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40732 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751630AbdLDWai (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Dec 2017 17:30:38 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by galahad.ideasonboard.com (Postfix) with ESMTPSA id 77DB120064
        for <linux-media@vger.kernel.org>; Mon,  4 Dec 2017 23:28:52 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.16] uvcvideo
Date: Tue, 05 Dec 2017 00:30:52 +0200
Message-ID: <1730000.MBkvG3CCLr@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 781b045baefdabf7e0bc9f33672ca830d3db9f27:

  media: imx274: Fix error handling, add MAINTAINERS entry (2017-11-30 
04:45:12 -0500)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git uvc/next

for you to fetch changes up to ed0c7e626c71120d844b06ce06c561670e0feb32:

  uvcvideo: Stream error events carry no data (2017-12-05 00:28:50 +0200)

----------------------------------------------------------------
Baoyou Xie (1):
      uvcvideo: Mark buffer error where overflow

Jaejoong Kim (1):
      uvcvideo: Remove duplicate & operation

Laurent Pinchart (1):
      uvcvideo: Stream error events carry no data

Nicolas Dufresne (1):
      uvcvideo: Add D3DFMT_L8 support

 drivers/media/usb/uvc/uvc_driver.c | 5 +++++
 drivers/media/usb/uvc/uvc_status.c | 5 +++--
 drivers/media/usb/uvc/uvc_video.c  | 5 +++--
 drivers/media/usb/uvc/uvcvideo.h   | 5 +++++
 4 files changed, 16 insertions(+), 4 deletions(-)

-- 
Regards,

Laurent Pinchart
