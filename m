Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:59645 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035AbZCMXRc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2009 19:17:32 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v2 0/4] pxa_camera: DMA redesign
Date: Sat, 14 Mar 2009 00:17:16 +0100
Message-Id: <1236986240-24115-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an update of the DMA redesign work for pxa_camera.

Guennadi, I hope I got all your comments within this serie. If I missed
something, I hope you won't be bothered. Just tell me and I'll fix it right
away.

To the last submit I added a little change to overrun :
 - handling for a corner case (test of pcdev->active in DMA irq).
 - case of YUV422P where one channel overrun while another completes

OK, now time for second iteration of this patchset.

Happy review.

Robert Jarzmik (4):
  pxa_camera: Enforce YUV422P frame sizes to be 16 multiples
  pxa_camera: remove YUV planar formats hole
  pxa_camera: Redesign DMA handling
  pxa_camera: Fix overrun condition on last buffer

 Documentation/video4linux/pxa_camera.txt |  125 +++++++
 drivers/media/video/pxa_camera.c         |  516 +++++++++++++++++++-----------
 2 files changed, 460 insertions(+), 181 deletions(-)
 create mode 100644 Documentation/video4linux/pxa_camera.txt
