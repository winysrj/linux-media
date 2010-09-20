Return-path: <mchehab@pedra>
Received: from smtp5-g21.free.fr ([212.27.42.5]:34829 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162Ab0ITHii convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Sep 2010 03:38:38 -0400
Received: from tele (unknown [82.245.201.222])
	by smtp5-g21.free.fr (Postfix) with ESMTP id 59FB8D4812F
	for <linux-media@vger.kernel.org>; Mon, 20 Sep 2010 09:38:31 +0200 (CEST)
Date: Mon, 20 Sep 2010 09:38:53 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.37] gspca for_2.6.37
Message-ID: <20100920093853.6198b5ef@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

This new patch request cancels the previous one. I removed two changes
which were not mature.

The following changes since commit
991403c594f666a2ed46297c592c60c3b9f4e1e2:

  V4L/DVB: cx231xx: Avoid an OOPS when card is unknown (card=0) (2010-09-11 11:58:01 -0300)

are available in the git repository at:
  git://linuxtv.org/jfrancois/gspca.git for_2.6.37

Alexander Goncharov (1):
      gspca - sonixj: Add webcam 0c45:612b

Andy Walls (3):
      gspca_cpia1: Add basic v4l2 illuminator controls for the Intel Play QX3
      gspca_cpia1: Restore QX3 illuminators' state on resume
      gspca_cpia1: Disable illuminator controls if not an Intel Play QX3

Jean-François Moine (7):
      gspca - all modules: Remove useless module load/unload messages.
      gspca - all modules: Display error messages when gspca debug disabled.
      gspca - sn9c20x: Bad transfer size of Bayer images.
      gspca - sn9c20x: Fix the number of bytes per line.
      gspca - sn9c20x: Better image sizes.
      gspca - sonixj: Webcam 0c45:6102 added.
      v4l2: Add illuminator controls.

 Documentation/DocBook/v4l/controls.xml             |    9 ++-
 Documentation/video4linux/gspca.txt                |    2 +
 drivers/media/video/gspca/conex.c                  |    8 +-
 drivers/media/video/gspca/cpia1.c                  |  127 ++++++++++++++++++--
 drivers/media/video/gspca/etoms.c                  |    8 +-
 drivers/media/video/gspca/finepix.c                |   15 +--
 drivers/media/video/gspca/gl860/gl860.c            |    6 +-
 drivers/media/video/gspca/gspca.c                  |   23 ++--
 drivers/media/video/gspca/jeilinj.c                |   15 +--
 drivers/media/video/gspca/konica.c                 |   19 +--
 drivers/media/video/gspca/m5602/m5602_core.c       |    8 +-
 drivers/media/video/gspca/mars.c                   |   11 +--
 drivers/media/video/gspca/mr97310a.c               |   29 ++---
 drivers/media/video/gspca/ov519.c                  |   51 ++++-----
 drivers/media/video/gspca/ov534.c                  |   19 +--
 drivers/media/video/gspca/ov534_9.c                |   19 +--
 drivers/media/video/gspca/pac207.c                 |   16 +--
 drivers/media/video/gspca/pac7302.c                |   25 ++---
 drivers/media/video/gspca/pac7311.c                |   25 ++---
 drivers/media/video/gspca/sn9c2028.c               |   19 +--
 drivers/media/video/gspca/sn9c20x.c                |   49 ++++-----
 drivers/media/video/gspca/sonixb.c                 |    8 +-
 drivers/media/video/gspca/sonixj.c                 |   15 +--
 drivers/media/video/gspca/spca1528.c               |   15 +--
 drivers/media/video/gspca/spca500.c                |   14 +--
 drivers/media/video/gspca/spca501.c                |   10 +--
 drivers/media/video/gspca/spca505.c                |   14 +--
 drivers/media/video/gspca/spca508.c                |   13 +--
 drivers/media/video/gspca/spca561.c                |   10 +--
 drivers/media/video/gspca/sq905.c                  |   21 +--
 drivers/media/video/gspca/sq905c.c                 |   15 +--
 drivers/media/video/gspca/sq930x.c                 |   23 ++---
 drivers/media/video/gspca/stk014.c                 |   20 +--
 drivers/media/video/gspca/stv0680.c                |   13 +--
 drivers/media/video/gspca/stv06xx/stv06xx.c        |   10 +--
 drivers/media/video/gspca/stv06xx/stv06xx_st6422.c |    2 +-
 drivers/media/video/gspca/sunplus.c                |   18 +--
 drivers/media/video/gspca/t613.c                   |   10 +--
 drivers/media/video/gspca/tv8532.c                 |    8 +-
 drivers/media/video/gspca/vc032x.c                 |   19 +--
 drivers/media/video/gspca/w996Xcf.c                |    6 +-
 drivers/media/video/gspca/xirlink_cit.c            |   17 +--
 drivers/media/video/gspca/zc3xx.c                  |   17 +--
 drivers/media/video/sn9c102/sn9c102_devtable.h     |    2 +
 drivers/media/video/v4l2-ctrls.c                   |    4 +
 include/linux/videodev2.h                          |    5 +-
 46 files changed, 340 insertions(+), 472 deletions(-)

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
