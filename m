Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51580 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab1LSR3U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Dec 2011 12:29:20 -0500
Received: from lancelot.localnet (unknown [91.178.121.111])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 8922635995
	for <linux-media@vger.kernel.org>; Mon, 19 Dec 2011 17:29:19 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.2] OMAP3 ISP fix
Date: Mon, 19 Dec 2011 18:29:19 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201112191829.21037.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's the patch we've discussed today, based on top of your latest pull 
request.

The following changes since commit 4b5d8da88e3fab76700e89488a8c65c54facb9a3:

  Revert "[media] af9015: limit I2C access to keep FW happy" (2011-12-12 
16:02:15 -0200)

are available in the git repository at:
  git://linuxtv.org/pinchartl/media.git mauro-next

Laurent Pinchart (1):
      omap3isp: Fix crash caused by subdevs now having a pointer to devnodes

 drivers/media/video/omap3isp/ispccdc.c |    2 +-
 drivers/media/video/omap3isp/ispstat.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
Regards,

Laurent Pinchart
