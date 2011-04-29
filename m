Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.26]:45921 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755206Ab1D2HMo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2011 03:12:44 -0400
From: Kalle Jokiniemi <kalle.jokiniemi@nokia.com>
To: laurent.pinchart@ideasonboard.com, tony@atomide.com,
	mchebab@infradead.org
Cc: linux-omap@vger.kernel.org, linux-media@vger.kernel.org,
	Kalle Jokiniemi <kalle.jokiniemi@nokia.com>
Subject: [PATCH 0/2] omap3isp/rx-51: Add vdds_csib regulator handling
Date: Fri, 29 Apr 2011 10:11:58 +0300
Message-Id: <1304061120-6383-1-git-send-email-kalle.jokiniemi@nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The CSIb block is used in rx-51 to handle camera ccp2 IO. Adding
support to omap3isp driver for managing the power supply for the
CSIb IO complex via regulator framework. Also create the
apropriate regulator definitions in the rx-51 board file.

I propose to push this set through the linux-media, since most
of the changes are on the omap3isp driver side.

Any comments/review appreciated. Tested on Nokia N900 and the
MeeGo testing daily images (.37 based kernel). Patches on top
of Mauro's linux-next tree, build tested and boot tested with
that. 

Kalle Jokiniemi (2):
  OMAP3: ISP: Add regulator control for omap34xx
  OMAP3: RX-51: define vdds_csib regulator supply

 arch/arm/mach-omap2/board-rx51-peripherals.c |    9 +++++++++
 drivers/media/video/omap3isp/ispccp2.c       |   24 +++++++++++++++++++++++-
 drivers/media/video/omap3isp/ispccp2.h       |    1 +
 3 files changed, 33 insertions(+), 1 deletions(-)

