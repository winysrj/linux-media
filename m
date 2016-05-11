Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49067 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbcEKHqH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2016 03:46:07 -0400
Received: from avalon.localnet (85-23-193-79.bb.dnainternet.fi [85.23.193.79])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id 402722004D
	for <linux-media@vger.kernel.org>; Wed, 11 May 2016 09:44:56 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.7] uvcvideo fixes
Date: Wed, 11 May 2016 10:46:34 +0300
Message-ID: <487662138.z7K0SjRaAr@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit aff093d4bbca91f543e24cde2135f393b8130f4b:

  [media] exynos-gsc: avoid build warning without CONFIG_OF (2016-05-09 
18:38:33 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git uvc/next

for you to fetch changes up to f169fec5a6c40a3328b953c774a6a092e7688df2:

  uvcvideo: Correct speed testing (2016-05-10 01:12:55 +0300)

----------------------------------------------------------------
Nicolas Dufresne (1):
      uvcvideo: Fix bytesperline calculation for planar YUV

Oliver Neukum (1):
      uvcvideo: Correct speed testing

 drivers/media/usb/uvc/uvc_v4l2.c  | 19 +++++++++++++++++--
 drivers/media/usb/uvc/uvc_video.c |  1 +
 2 files changed, 18 insertions(+), 2 deletions(-)

-- 
Regards,

Laurent Pinchart

