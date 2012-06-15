Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:50647 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875Ab2FOHoH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jun 2012 03:44:07 -0400
Received: from [192.168.239.74] (maxwell.research.nokia.com [172.21.199.25])
	by mgw-da02.nokia.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q5F7i4gr027824
	for <linux-media@vger.kernel.org>; Fri, 15 Jun 2012 10:44:05 +0300
Message-ID: <4FDAE7C4.7020304@iki.fi>
Date: Fri, 15 Jun 2012 10:44:04 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR 3.5] SMIA++ compile fix
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull contains a simple compile fix for the SMIA++ driver. 3.5 would
be preferred.

The following changes since commit 5472d3f17845c4398c6a510b46855820920c2181:

  [media] mt9m032: Implement V4L2_CID_PIXEL_RATE control (2012-05-24
09:27:24 -0300)

are available in the git repository at:
  ssh://linuxtv.org/git/sailus/media_tree.git media-for-3.5-smiapp-fix

Alan Cox (1):
      smia: Fix compile failures

 drivers/media/video/smiapp/Kconfig       |    2 +-
 drivers/media/video/smiapp/smiapp-core.c |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)


Regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi

