Return-path: <mchehab@pedra>
Received: from smtp5-g21.free.fr ([212.27.42.5]:42577 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172Ab0JSI5h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Oct 2010 04:57:37 -0400
Received: from tele (unknown [82.245.201.222])
	by smtp5-g21.free.fr (Postfix) with ESMTP id EB33CD48138
	for <linux-media@vger.kernel.org>; Tue, 19 Oct 2010 10:57:30 +0200 (CEST)
Date: Tue, 19 Oct 2010 10:58:31 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.37] gspca for_2.6.37
Message-ID: <20101019105831.04e2d7e4@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The following changes since commit
350df81ebaccc651fa4dfad27738db958e067ded:

  Revert changeset d455b639c1fb09f8ea888371fb6e04b490e115fb (2010-10-17 19:32:45 -0200)

are available in the git repository at:
  git://linuxtv.org/jfrancois/gspca.git for_2.6.37

Jean-François Moine (1):
      gspca: Fix coding style issues

Németh Márton (2):
      gspca - sonixj: Remove magic numbers for delay
      gspca - sonixj: Add horizontal and vertical flip for po2030n

 drivers/media/video/gspca/benq.c                   |    3 +-
 drivers/media/video/gspca/conex.c                  |    6 +-
 drivers/media/video/gspca/etoms.c                  |    4 +-
 drivers/media/video/gspca/gl860/gl860-mi2020.c     |    6 +-
 drivers/media/video/gspca/gspca.c                  |    2 +-
 drivers/media/video/gspca/konica.c                 |    4 +-
 drivers/media/video/gspca/m5602/m5602_mt9m111.c    |   48 ++++----
 drivers/media/video/gspca/m5602/m5602_mt9m111.h    |   14 +--
 drivers/media/video/gspca/m5602/m5602_ov7660.c     |   70 +++++-----
 drivers/media/video/gspca/m5602/m5602_ov7660.h     |    9 +-
 drivers/media/video/gspca/m5602/m5602_ov9650.c     |  102 ++++++++--------
 drivers/media/video/gspca/m5602/m5602_ov9650.h     |   12 +-
 drivers/media/video/gspca/m5602/m5602_po1030.c     |  136 ++++++++++----------
 drivers/media/video/gspca/m5602/m5602_po1030.h     |   13 +-
 drivers/media/video/gspca/m5602/m5602_s5k4aa.c     |   28 ++--
 drivers/media/video/gspca/m5602/m5602_s5k4aa.h     |   14 +--
 drivers/media/video/gspca/m5602/m5602_s5k83a.h     |   12 +-
 drivers/media/video/gspca/ov519.c                  |   18 +--
 drivers/media/video/gspca/pac207.c                 |    2 +-
 drivers/media/video/gspca/pac7302.c                |    3 +-
 drivers/media/video/gspca/pac7311.c                |    3 +-
 drivers/media/video/gspca/sn9c20x.c                |   13 ++-
 drivers/media/video/gspca/sonixb.c                 |    9 +-
 drivers/media/video/gspca/sonixj.c                 |  111 +++++++++++-----
 drivers/media/video/gspca/spca501.c                |    6 +-
 drivers/media/video/gspca/spca508.c                |    3 +-
 drivers/media/video/gspca/stv06xx/stv06xx.h        |    2 +-
 drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c   |   19 ++--
 drivers/media/video/gspca/stv06xx/stv06xx_hdcs.h   |    2 +-
 drivers/media/video/gspca/stv06xx/stv06xx_vv6410.c |    2 +-
 drivers/media/video/gspca/stv06xx/stv06xx_vv6410.h |    4 +-
 drivers/media/video/gspca/sunplus.c                |    9 +-
 drivers/media/video/gspca/w996Xcf.c                |    2 +-
 drivers/media/video/gspca/zc3xx.c                  |   14 +--
 34 files changed, 359 insertions(+), 346 deletions(-)

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
