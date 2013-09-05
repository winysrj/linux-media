Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46397 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934094Ab3IELER (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Sep 2013 07:04:17 -0400
Received: from avalon.localnet (unknown [91.177.150.224])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 0CCAF35A6D
	for <linux-media@vger.kernel.org>; Thu,  5 Sep 2013 13:03:52 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.12] uvcvideo fixes
Date: Thu, 05 Sep 2013 13:04:20 +0200
Message-ID: <1679280.7BIEXJlCLW@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are two ucvideo patches that enable quirks by default for buggy devices. 
Despite not being regressions, they're candidates for v3.12 (see 
http://www.spinics.net/lists/stable/msg18747.html).

The following changes since commit f66b2a1c7f2ae3fb0d5b67d07ab4f5055fd3cf16:

  [media] cx88: Fix regression: CX88_AUDIO_WM8775 can't be 0 (2013-09-03 
09:24:22 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-fixes

for you to fetch changes up to c8f2c441127589c66229991a53d75dd53be1d358::

  uvcvideo: quirk PROBE_DEF for Microsoft Lifecam NX-3000 (2013-09-03 22:07:35 
+0200)

----------------------------------------------------------------
Joseph Salisbury (1):
      uvcvideo: quirk PROBE_DEF for Dell SP2008WFP monitor

Laurent Pinchart (1):
      uvcvideo: quirk PROBE_DEF for Microsoft Lifecam NX-3000

 drivers/media/usb/uvc/uvc_driver.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

-- 
Regards,

Laurent Pinchart

