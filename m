Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33490 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753650AbcKMTFE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 Nov 2016 14:05:04 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by galahad.ideasonboard.com (Postfix) with ESMTPSA id 7391B20046
        for <linux-media@vger.kernel.org>; Sun, 13 Nov 2016 20:03:59 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.10] uvcvideo change
Date: Sun, 13 Nov 2016 21:05:08 +0200
Message-ID: <2737574.WrWS6IrUAN@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Could you please pull the following single patch for v4.10 ? It adds an entry 
in the uvcvideo devices table for the Oculus Rift sensor.

The following changes since commit bd676c0c04ec94bd830b9192e2c33f2c4532278d:

  [media] v4l2-flash-led-class: remove a now unused var (2016-10-24 18:51:29 
-0200)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git uvc/next

for you to fetch changes up to 9226eabf0314a809a097c17a4793becb9a9fcde7:

  uvcvideo: add support for Oculus Rift Sensor (2016-11-11 04:06:46 +0200)

----------------------------------------------------------------
Philipp Zabel (1):
      uvcvideo: add support for Oculus Rift Sensor

 drivers/media/usb/uvc/uvc_driver.c | 9 +++++++++
 1 file changed, 9 insertions(+)

-- 
Regards,

Laurent Pinchart

