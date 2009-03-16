Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:51080 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790AbZCPWQt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 18:16:49 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v3 0/4] pxa_camera: DMA redesign
Date: Mon, 16 Mar 2009 23:16:33 +0100
Message-Id: <1237241797-381-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the second update of the DMA redesign work for pxa_camera.

Guennadi, I hope I got all your comments within this serie right.
We shouldn't be too far from the final iteration now.

Cheers.

--
Robert


Robert Jarzmik (4):
  pxa_camera: Enforce YUV422P frame sizes to be 16 multiples
  pxa_camera: Remove YUV planar formats hole
  pxa_camera: Redesign DMA handling
  pxa_camera: Fix overrun condition on last buffer

 Documentation/video4linux/pxa_camera.txt |  125 +++++++
 drivers/media/video/pxa_camera.c         |  519 +++++++++++++++++++-----------
 2 files changed, 462 insertions(+), 182 deletions(-)
 create mode 100644 Documentation/video4linux/pxa_camera.txt

