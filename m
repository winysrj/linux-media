Return-path: <mchehab@pedra>
Received: from mail-out.m-online.net ([212.18.0.9]:54866 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab1AZIt0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jan 2011 03:49:26 -0500
From: Anatolij Gustschin <agust@denx.de>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-arm-kernel@lists.infradead.org, Detlev Zundel <dzu@denx.de>,
	Markus Niebel <Markus.Niebel@tqs.de>,
	Anatolij Gustschin <agust@denx.de>
Subject: [PATCH 0/2] Fix issues with frame reception from CSI on i.MX31
Date: Wed, 26 Jan 2011 09:49:47 +0100
Message-Id: <1296031789-1721-1-git-send-email-agust@denx.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On some camera systems we do not tolerate the losing of
captured frames. We observed losing of the first frame
from CSI when double buffering is used (multiple buffers
queued by the mx3-camera driver).

The patches provide fixes for the observed problem.

Anatolij Gustschin (2):
  v4l: soc-camera: start stream after queueing the buffers
  dma: ipu_idmac: do not lose valid received data in the irq handler

 drivers/dma/ipu/ipu_idmac.c      |   50 --------------------------------------
 drivers/media/video/soc_camera.c |    4 +-
 2 files changed, 2 insertions(+), 52 deletions(-)

