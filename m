Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36572 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932679AbaGQMgA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 08:36:00 -0400
Received: from avalon.localnet (unknown [91.178.197.224])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 57AD2359FA
	for <linux-media@vger.kernel.org>; Thu, 17 Jul 2014 14:34:56 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.17] OMAP3 ISP fix
Date: Thu, 17 Jul 2014 14:36:07 +0200
Message-ID: <1765557.UeLuh1tycz@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 3c0d394ea7022bb9666d9df97a5776c4bcc3045c:

  [media] dib8000: improve the message that reports per-layer locks 
(2014-07-07 09:59:01 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git omap3isp/next

for you to fetch changes up to c4f186967492e8f44478657d6993ce71545bfaef:

  media:platform: OMAP3 camera support needs VIDEOBUF2_DMA_CONTIG (2014-07-17 
14:17:54 +0200)

----------------------------------------------------------------
Peter Meerwald (1):
      media:platform: OMAP3 camera support needs VIDEOBUF2_DMA_CONTIG

 drivers/media/platform/Kconfig | 1 +
 1 file changed, 1 insertion(+)

-- 
Regards,

Laurent Pinchart

