Return-path: <linux-media-owner@vger.kernel.org>
Received: from tango.tkos.co.il ([62.219.50.35]:41504 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131Ab0G0MGt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jul 2010 08:06:49 -0400
From: Baruch Siach <baruch@tkos.co.il>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Sascha Hauer <kernel@pengutronix.de>,
	Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH 0/4] mx2_camera: mx25 fixes and enhancements
Date: Tue, 27 Jul 2010 15:06:06 +0300
Message-Id: <cover.1280229966.git.baruch@tkos.co.il>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The first 3 pathces in this series are fixes for the mx2_camera driver which is 
going upstream via the imx git tree. The last patch implements forced active 
buffer termination on mx25.

Baruch Siach (4):
  mx2_camera: fix a race causing NULL dereference
  mx2_camera: return IRQ_NONE when doing nothing
  mx2_camera: fix comment typo
  mx2_camera: implement forced termination of active buffer for mx25

 drivers/media/video/mx2_camera.c |   34 ++++++++++++++++++++++++++--------
 1 files changed, 26 insertions(+), 8 deletions(-)

