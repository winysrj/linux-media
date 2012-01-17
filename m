Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55039 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547Ab2AQPXi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jan 2012 10:23:38 -0500
Received: from lancelot.localnet (unknown [91.178.45.26])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id E044D35995
	for <linux-media@vger.kernel.org>; Tue, 17 Jan 2012 15:23:36 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.3] as3645a compilation fix
Date: Tue, 17 Jan 2012 16:23:43 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201201171623.44959.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit d04ca8df70f0e1c3fe6ee2aeb1114b03a3a3de88:

  [media] cxd2820r: do not switch to DVB-T when DVB-C fails (2012-01-16 
12:47:32 -0200)

are available in the git repository at:
  git://linuxtv.org/pinchartl/media.git omap3isp-omap3isp-stable

Laurent Pinchart (1):
      as3645a: Fix compilation by including slab.h

 drivers/media/video/as3645a.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

-- 
Regards,

Laurent Pinchart
