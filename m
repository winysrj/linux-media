Return-path: <mchehab@pedra>
Received: from smtp5-g21.free.fr ([212.27.42.5]:41434 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755577Ab0JALL0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Oct 2010 07:11:26 -0400
Received: from tele (unknown [82.245.201.222])
	by smtp5-g21.free.fr (Postfix) with ESMTP id E2054D4802D
	for <linux-media@vger.kernel.org>; Fri,  1 Oct 2010 13:11:20 +0200 (CEST)
Date: Fri, 1 Oct 2010 13:12:00 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.37] gspca for_2.6.37
Message-ID: <20101001131200.53022736@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The following changes since commit
1a45fd8d5ec39af5c00bec6094a606ccfc7957d5:

  V4L/DVB: tda18271: Add some hint about what tda18217 reg ID returned (2010-09-30 22:47:20 -0300)

are available in the git repository at:
  git://linuxtv.org/jfrancois/gspca.git for_2.6.37

Jean-François Moine (5):
      gspca - many subdrivers: Handle the buttons when CONFIG_INPUT=m.
      gspca - mr97310a: Declare static the constant tables.
      gspca - sonixj: Add sensor mi0360b.
      gspca - sonixj: Bad detection of the end of image.
      gspca - sonixj: Have 0c45:6130 handled by sonixj instead of sn9c102.

 drivers/media/video/gspca/konica.c             |    6 +-
 drivers/media/video/gspca/mr97310a.c           |   23 ++--
 drivers/media/video/gspca/ov519.c              |    4 +-
 drivers/media/video/gspca/pac207.c             |    4 +-
 drivers/media/video/gspca/pac7302.c            |    4 +-
 drivers/media/video/gspca/pac7311.c            |    4 +-
 drivers/media/video/gspca/sn9c20x.c            |    6 +-
 drivers/media/video/gspca/sonixb.c             |    4 +-
 drivers/media/video/gspca/sonixj.c             |  180 ++++++++++++++++++++----
 drivers/media/video/gspca/spca561.c            |    6 +-
 drivers/media/video/gspca/stv06xx/stv06xx.c    |    4 +-
 drivers/media/video/gspca/zc3xx.c              |    6 +-
 drivers/media/video/sn9c102/sn9c102_devtable.h |    2 +
 13 files changed, 187 insertions(+), 66 deletions(-)

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
