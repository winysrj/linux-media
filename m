Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41295 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288AbaBRMTQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Feb 2014 07:19:16 -0500
Received: from avalon.localnet (unknown [91.178.144.128])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 670FB35A46
	for <linux-media@vger.kernel.org>; Tue, 18 Feb 2014 13:18:15 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.15] OMAP3 ISP fixes
Date: Tue, 18 Feb 2014 13:20:24 +0100
Message-ID: <1505895.hMaJzqaOi5@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 37e59f876bc710d67a30b660826a5e83e07101ce:

  [media, edac] Change my email address (2014-02-07 08:03:07 -0200)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git omap3isp/next

for you to fetch changes up to 58ee8629ebc528b629dac36e5e5c67dffeecd2fa:

  omap3isp: Don't ignore failure to locate external subdev (2014-02-18 
13:18:52 +0100)

----------------------------------------------------------------
Florian Vaussard (1):
      omap3isp: preview: Fix the crop margins

Laurent Pinchart (2):
      omap3isp: Don't try to locate external subdev for mem-to-mem pipelines
      omap3isp: Don't ignore failure to locate external subdev

 drivers/media/platform/omap3isp/isppreview.c | 9 +++++++++
 drivers/media/platform/omap3isp/ispvideo.c   | 8 ++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

-- 
Regards,

Laurent Pinchart

