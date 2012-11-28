Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39777 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932358Ab2K1PQT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 10:16:19 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Vaibhav Hiremath <hvaibhav@ti.com>,
	Archit Taneja <archit@ti.com>
Subject: [GIT PULL FOR v3.8] OMAP VOUT fixes
Date: Wed, 28 Nov 2012 16:17:23 +0100
Message-ID: <17143281.p5Zi55G1L9@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The two patches included in this pull requests have been previously posted to 
the list and acked. As the omap_vout seems unmaintained, here's a pull 
request.

If no maintainer steps up in response to this e-mail I'll send a patch for 
MAINTAINERS to list myself as a 'Odd Fixes' maintainer.

The following changes since commit d8658bca2e5696df2b6c69bc5538f8fe54e4a01e:                                                                                                                               
                                                                                                                                                                                                           
  [media] omap3isp: Replace cpu_is_omap3630() with ISP revision check 
(2012-11-28 10:54:46 -0200)

are available in the git repository at:
  git://linuxtv.org/pinchartl/media.git omap3/vout

Laurent Pinchart (2):
      omap_vout: Drop overlay format enumeration
      omap_vout: Use the output overlay ioctl operations

 drivers/media/platform/omap/omap_vout.c |   22 +++-------------------
 1 files changed, 3 insertions(+), 19 deletions(-)

-- 
Regards,

Laurent Pinchart

