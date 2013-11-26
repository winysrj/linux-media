Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46598 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757264Ab3KZQGv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Nov 2013 11:06:51 -0500
Received: from avalon.localnet (unknown [109.134.93.159])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 42E5235A49
	for <linux-media@vger.kernel.org>; Tue, 26 Nov 2013 17:06:06 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.14] OMAP3 ISP fix
Date: Tue, 26 Nov 2013 17:06:53 +0100
Message-ID: <20681285.3SfEVTvYXU@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 258d2fbf874c87830664cb7ef41f9741c1abffac:

  Merge tag 'v3.13-rc1' into patchwork (2013-11-25 05:57:23 -0200)

are available in the git repository at:


  git://linuxtv.org/pinchartl/media.git omap3isp/next

for you to fetch changes up to 11b1ea50ce6589cf532761ffce79bbcda17f8c3e:

  v4l: omap3isp: Don't check for missing get_fmt op on remote subdev 
(2013-11-26 17:04:34 +0100)

----------------------------------------------------------------
Laurent Pinchart (1):
      v4l: omap3isp: Don't check for missing get_fmt op on remote subdev

 drivers/media/platform/omap3isp/ispvideo.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

-- 
Regards,

Laurent Pinchart

