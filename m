Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48309 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbbIIKig (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Sep 2015 06:38:36 -0400
Received: from avalon.localnet (85-23-193-79.bb.dnainternet.fi [85.23.193.79])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id CEB5B20066
	for <linux-media@vger.kernel.org>; Wed,  9 Sep 2015 12:36:28 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.4] uvcvideo fixes
Date: Wed, 09 Sep 2015 13:38:35 +0300
Message-ID: <1545832.0rxgpelTNn@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 50ef28a6ac216fd8b796257a3768fef8f57b917d:

  [media] c8sectpfe: Remove select on undefined LIBELF_32 (2015-09-03 14:10:06 
-0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git uvc/next

for you to fetch changes up to 9f9720591c14a177764d169073264243e2bd50b3:

  uvcvideo: Disable hardware timestamps by default (2015-09-09 13:36:57 +0300)

----------------------------------------------------------------
Laurent Pinchart (1):
      uvcvideo: Disable hardware timestamps by default

 drivers/media/usb/uvc/uvc_driver.c | 3 +++
 drivers/media/usb/uvc/uvc_video.c  | 3 +++
 drivers/media/usb/uvc/uvcvideo.h   | 1 +
 3 files changed, 7 insertions(+)

-- 
Regards,

Laurent Pinchart

