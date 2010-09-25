Return-path: <mchehab@pedra>
Received: from smtp5-g21.free.fr ([212.27.42.5]:56261 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754454Ab0IYJRn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Sep 2010 05:17:43 -0400
Received: from tele (unknown [82.245.201.222])
	by smtp5-g21.free.fr (Postfix) with ESMTP id 7AD8DD48154
	for <linux-media@vger.kernel.org>; Sat, 25 Sep 2010 11:17:37 +0200 (CEST)
Date: Sat, 25 Sep 2010 11:18:05 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.37] gspca for_2.6.37
Message-ID: <20100925111805.3d093ce7@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The following changes since commit
dace3857de7a16b83ae7d4e13c94de8e4b267d2a:

  V4L/DVB: tvaudio: remove obsolete tda8425 initialization (2010-09-24 19:20:20 -0300)

are available in the git repository at:
  git://linuxtv.org/jfrancois/gspca.git for_2.6.37

Jean-François Moine (6):
      gspca - benq: Display error messages when gspca debug disabled.
      gspca - benq: Remove useless module load/unload messages.
      gspca - cpia1: Fix compilation warning when gspca debug disabled.
      gspca - many subdrivers: Handle INPUT as a module.
      gspca - spca505: Remove the eeprom write commands of NxUltra.
      gspca - sonixj: Propagate USB errors to higher level.

 drivers/media/video/gspca/benq.c            |   20 ++----
 drivers/media/video/gspca/cpia1.c           |    2 +
 drivers/media/video/gspca/konica.c          |    8 ++-
 drivers/media/video/gspca/ov519.c           |    6 +-
 drivers/media/video/gspca/pac207.c          |    6 +-
 drivers/media/video/gspca/pac7302.c         |    6 +-
 drivers/media/video/gspca/pac7311.c         |    6 +-
 drivers/media/video/gspca/sn9c20x.c         |    6 +-
 drivers/media/video/gspca/sonixb.c          |    6 +-
 drivers/media/video/gspca/sonixj.c          |   91 +++++++++++++++++++++------
 drivers/media/video/gspca/spca505.c         |    4 -
 drivers/media/video/gspca/spca561.c         |    8 ++-
 drivers/media/video/gspca/stv06xx/stv06xx.c |    6 +-
 drivers/media/video/gspca/zc3xx.c           |    6 +-
 14 files changed, 119 insertions(+), 62 deletions(-)

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
