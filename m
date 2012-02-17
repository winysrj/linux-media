Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40180 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab2BQJJP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Feb 2012 04:09:15 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Fabio Estevam <festevam@gmail.com>, g.liakhovetski@gmx.de,
	javier.martin@vista-silicon.com, baruch@tkos.co.il
Subject: i.MX27 camera: remove i.MX27 DMA support
Date: Fri, 17 Feb 2012 10:09:07 +0100
Message-Id: <1329469749-18099-1-git-send-email-s.hauer@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

i.MX27 DMA support was initially introduced by me and I never got
this to work properly. As this is also uses a legacy DMA API and
is the source of ifdeffery in the driver, remove it.


Sascha Hauer (2):
      media/video mx2_camera: make using emma mandatory for i.MX27
      media/video mx2_camera: remove now unused code

 drivers/media/video/mx2_camera.c |  244 +++++---------------------------------
 1 files changed, 28 insertions(+), 216 deletions(-)
