Return-path: <mchehab@pedra>
Received: from smtp5-g21.free.fr ([212.27.42.5]:36116 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061Ab1EWJUW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 05:20:22 -0400
Received: from tele (unknown [82.245.201.222])
	by smtp5-g21.free.fr (Postfix) with ESMTP id 922B3D481E8
	for <linux-media@vger.kernel.org>; Mon, 23 May 2011 11:20:16 +0200 (CEST)
Date: Mon, 23 May 2011 11:20:54 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.40] gspca for_v2.6.40
Message-ID: <20110523112054.4d8b29ef@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The following changes since commit
87cf028f3aa1ed51fe29c36df548aa714dc7438f:

  [media] dm1105: GPIO handling added, I2C on GPIO added, LNB control through GPIO reworked (2011-05-21 11:10:28 -0300)

are available in the git repository at:
  git://linuxtv.org/jfrancois/gspca.git for_v2.6.40

Jean-François Moine (6):
      gspca - ov519: Fix a regression for ovfx2 webcams
      gspca - ov519: Change the ovfx2 bulk transfer size
      gspca: Remove coarse_expo_autogain.h
      gspca - stv06xx: Set a lower default value of gain for hdcs sensors
      gspca - ov519: New sensor ov9600 with bridge ovfx2
      gspca - ov519: Set the default frame rate to 15 fps

 drivers/media/video/gspca/coarse_expo_autogain.h |  116 ---------------------
 drivers/media/video/gspca/ov519.c                |  117 ++++++++++++++++++---
 drivers/media/video/gspca/stv06xx/stv06xx_hdcs.h |    2 +-
 3 files changed, 101 insertions(+), 134 deletions(-)
 delete mode 100644 drivers/media/video/gspca/coarse_expo_autogain.h

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
