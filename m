Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:54128 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab0IVW2f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Sep 2010 18:28:35 -0400
Received: from lancelot.localnet (unknown [91.178.85.248])
	by perceval.irobotique.be (Postfix) with ESMTPSA id C713735ACC
	for <linux-media@vger.kernel.org>; Wed, 22 Sep 2010 22:28:33 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.36] Bug fixes for the uvcvideo driver
Date: Thu, 23 Sep 2010 00:28:31 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201009230028.32773.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

The following changes since commit 67ac062a5138ed446a821051fddd798a01478f85:

  V4L/DVB: Fix regression for BeholdTV Columbus (2010-08-24 10:39:32 -0300)

are available in the git repository at:
  git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-stable

Laurent Pinchart (2):
      uvcvideo: Fix support for Medion Akoya All-in-one PC integrated webcam
      uvcvideo: Restrict frame rates for Chicony CNF7129 webcam

 drivers/media/video/uvc/uvc_driver.c |   24 ++++++++++++++++++++++++
 drivers/media/video/uvc/uvcvideo.h   |    1 +
 2 files changed, 25 insertions(+), 0 deletions(-)

-- 
Regards,

Laurent Pinchart
