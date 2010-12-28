Return-path: <mchehab@gaivota>
Received: from smtp5-g21.free.fr ([212.27.42.5]:60907 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903Ab0L1Kk3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Dec 2010 05:40:29 -0500
Received: from tele (unknown [82.245.201.222])
	by smtp5-g21.free.fr (Postfix) with ESMTP id 24022D4802F
	for <linux-media@vger.kernel.org>; Tue, 28 Dec 2010 11:40:22 +0100 (CET)
Date: Tue, 28 Dec 2010 11:42:48 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.38] gspca for_2.6.38
Message-ID: <20101228114248.5e6c9b44@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

The following changes since commit
fc43dd115e1c07af122440971177451cef5c45c0:

  [media] MEDIA: RC: Provide full scancodes for TT-1500 remote control (2010-12-27 19:26:56 -0200)

are available in the git repository at:
  git://linuxtv.org/jfrancois/gspca.git for_2.6.38

Jean-François Moine (9):
      gspca - main: Fix some warnings
      gspca - pac7302/pac7311: Fix some warnings
      gspca: Bad comment
      gspca - zc3xx: Keep sorted the device table
      gspca - zc3xx: Use the new video control mechanism
      gspca - zc3xx: The sensor of the VF0250 is a GC0303
      gspca - vc032x: Cleanup source
      gspca - stv06xx/st6422: Use the new video control mechanism
      gspca - sonixj: Bad clock for om6802 in 640x480

 drivers/media/video/gspca/gspca.c                  |   10 +-
 drivers/media/video/gspca/gspca.h                  |    2 +-
 drivers/media/video/gspca/pac7302.c                |    2 +-
 drivers/media/video/gspca/pac7311.c                |    2 +-
 drivers/media/video/gspca/sonixj.c                 |    2 +-
 drivers/media/video/gspca/stv06xx/stv06xx_st6422.c |  272 ++++++++-----------
 drivers/media/video/gspca/stv06xx/stv06xx_st6422.h |   10 -
 drivers/media/video/gspca/vc032x.c                 |   74 +++---
 drivers/media/video/gspca/zc3xx.c                  |  290 ++++++--------------
 9 files changed, 251 insertions(+), 413 deletions(-)

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
