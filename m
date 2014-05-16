Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47670 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaEPApX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 May 2014 20:45:23 -0400
Received: from avalon.localnet (135.5-200-80.adsl-dyn.isp.belgacom.be [80.200.5.135])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id D9ACD359FA
	for <linux-media@vger.kernel.org>; Fri, 16 May 2014 02:42:33 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.16] mt9p031 fixes
Date: Fri, 16 May 2014 02:45:27 +0200
Message-ID: <6639318.OE0dlORGdR@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit ba0d342ecc21fbbe2f6c178f4479944d1fb34f3b:

  saa7134-alsa: include vmalloc.h (2014-05-13 23:05:15 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git sensors/next

for you to fetch changes up to a3a7145c6cecbd9752311b8ae1e431f6755ad5f3:

  mt9p031: Fix BLC configuration restore when disabling test pattern 
(2014-05-16 02:43:50 +0200)

----------------------------------------------------------------
Laurent Pinchart (2):
      mt9p031: Really disable Black Level Calibration in test pattern mode
      mt9p031: Fix BLC configuration restore when disabling test pattern

 drivers/media/i2c/mt9p031.c | 53 
+++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 39 insertions(+), 14 deletions(-)

-- 
Regards,

Laurent Pinchart

