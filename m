Return-path: <mchehab@pedra>
Received: from smtp5-g21.free.fr ([212.27.42.5]:58997 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348Ab1CNLyY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2011 07:54:24 -0400
Received: from tele (unknown [82.245.201.222])
	by smtp5-g21.free.fr (Postfix) with ESMTP id 25596D48267
	for <linux-media@vger.kernel.org>; Mon, 14 Mar 2011 12:54:17 +0100 (CET)
Date: Mon, 14 Mar 2011 12:54:40 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.39] gspca for_v2.6.39
Message-ID: <20110314125440.4d3578ed@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The following changes since commit
41f3becb7bef489f9e8c35284dd88a1ff59b190c:

  [media] V4L DocBook: update V4L2 version (2011-03-11 18:09:02 -0300)

are available in the git repository at:
  git://linuxtv.org/jfrancois/gspca.git for_v2.6.39

Hans de Goede (1):
      gspca - sonixb: Update inactive flags to reflect autogain setting

Jean-François Moine (9):
      gspca - zc3xx: Remove double definition
      gspca - zc3xx: Cleanup source
      gspca: New file autogain_functions.h
      gspca - sonixb: Use the new control mechanism
      gspca - sonixb: Clenup source
      gspca - jeilinj / stv06xx: Fix some warnings
      gspca - ov519: Add exposure and autogain controls for ov2610/2610ae
      gspca - main: Cleanup source
      gspca - nw80x: New subdriver for Divio based webcams

 Documentation/video4linux/gspca.txt            |    9 +
 drivers/media/video/gspca/Kconfig              |    9 +
 drivers/media/video/gspca/Makefile             |    2 +
 drivers/media/video/gspca/autogain_functions.h |  179 ++
 drivers/media/video/gspca/gspca.c              |   13 +-
 drivers/media/video/gspca/jeilinj.c            |    2 -
 drivers/media/video/gspca/nw80x.c              | 2443 ++++++++++++++++++++++++
 drivers/media/video/gspca/ov519.c              |  120 +-
 drivers/media/video/gspca/sonixb.c             |  306 ++--
 drivers/media/video/gspca/stv06xx/stv06xx.c    |    2 -
 drivers/media/video/gspca/zc3xx-reg.h          |    2 -
 drivers/media/video/gspca/zc3xx.c              |   48 +-
 include/linux/videodev2.h                      |    1 +
 13 files changed, 2888 insertions(+), 248 deletions(-)
 create mode 100644 drivers/media/video/gspca/autogain_functions.h
 create mode 100644 drivers/media/video/gspca/nw80x.c

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
