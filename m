Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38210 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626AbbGPIMi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jul 2015 04:12:38 -0400
Received: from avalon.localnet (89-27-67-84.bb.dnainternet.fi [89.27.67.84])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id BC5B92005B
	for <linux-media@vger.kernel.org>; Thu, 16 Jul 2015 10:12:01 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.3] Xilinx video driver fix
Date: Thu, 16 Jul 2015 11:13:02 +0300
Message-ID: <2033534.oBvt8Ix8az@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 8783b9c50400c6279d7c3b716637b98e83d3c933:

  [media] SMI PCIe IR driver for DVBSky cards (2015-07-06 08:26:16 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git xilinx/next

for you to fetch changes up to 0b35afd34edbad0ca874264110513311daa8f822:

  v4l: xilinx: missing error code (2015-07-16 10:36:47 +0300)

----------------------------------------------------------------
Dan Carpenter (1):
      v4l: xilinx: missing error code

 drivers/media/platform/xilinx/xilinx-dma.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

-- 
Regards,

Laurent Pinchart

