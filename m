Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40788 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968Ab2ISKCm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Sep 2012 06:02:42 -0400
Received: from avalon.localnet (unknown [91.178.74.202])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 303AB359D1
	for <linux-media@vger.kernel.org>; Wed, 19 Sep 2012 12:02:41 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PULL FOR v3.7] OMAP3 ISP patches
Date: Wed, 19 Sep 2012 12:03:17 +0200
Message-ID: <2089319.1KIpnbuWf7@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 4313902ebe33155209472215c62d2f29d117be29:

  [media] ivtv-alsa, ivtv: Connect ivtv PCM capture stream to ivtv-alsa 
interface driver (2012-09-18 13:29:07 -0300)

are available in the git repository at:
  git://linuxtv.org/pinchartl/media.git omap3isp-omap3isp-next

Laurent Pinchart (1):
      omap3isp: Use monotonic timestamps for statistics buffers

Wanlong Gao (1):
      omap3isp: Fix up ENOIOCTLCMD error handling

 drivers/media/platform/omap3isp/ispstat.c  |    2 +-
 drivers/media/platform/omap3isp/ispstat.h  |    2 +-
 drivers/media/platform/omap3isp/ispvideo.c |    8 ++++----
 include/linux/omap3isp.h                   |    7 ++++++-
 4 files changed, 12 insertions(+), 7 deletions(-)

-- 
Regards,

Laurent Pinchart

