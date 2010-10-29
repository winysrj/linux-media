Return-path: <mchehab@pedra>
Received: from smtp5-g21.free.fr ([212.27.42.5]:56246 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934271Ab0J2R5K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Oct 2010 13:57:10 -0400
Received: from tele (unknown [82.245.201.222])
	by smtp5-g21.free.fr (Postfix) with ESMTP id 19B39D4803C
	for <linux-media@vger.kernel.org>; Fri, 29 Oct 2010 19:57:04 +0200 (CEST)
Date: Fri, 29 Oct 2010 19:58:18 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.37] gspca for_2.6.37
Message-ID: <20101029195818.1abd1759@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The following changes since commit
18cb657ca1bafe635f368346a1676fb04c512edf:

  Merge branch 'stable/xen-pcifront-0.8.2' of git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen   and branch 'for-linus' of git://xenbits.xen.org/people/sstabellini/linux-pvhvm (2010-10-28 17:11:17 -0700)

are available in the git repository at:

  git://linuxtv.org/jfrancois/gspca.git for_2.6.37

Jean-François Moine (5):
      gspca - main: Version change
      gspca - main: Fix a small code error
      gspca - zc3xx: Bad clocksetting for mt9v111_3 with 640x480 resolution
      gspca - sonixj: Simplify and clarify the hv7131r probe function
      gspca: Convert some uppercase hexadecimal values to lowercase

 drivers/media/video/gspca/cpia1.c                  |   10 +++++-----
 drivers/media/video/gspca/gspca.c                  |    4 ++--
 drivers/media/video/gspca/m5602/m5602_ov9650.c     |    2 +-
 drivers/media/video/gspca/pac207.c                 |    4 ++--
 drivers/media/video/gspca/sonixb.c                 |    4 ++--
 drivers/media/video/gspca/sonixj.c                 |   18 +++++++++---------
 drivers/media/video/gspca/spca561.c                |    2 +-
 drivers/media/video/gspca/stv06xx/stv06xx.c        |    2 +-
 drivers/media/video/gspca/stv06xx/stv06xx_st6422.c |    4 ++--
 drivers/media/video/gspca/t613.c                   |    2 +-
 drivers/media/video/gspca/tv8532.c                 |    2 +-
 drivers/media/video/gspca/zc3xx.c                  |    2 +-
 12 files changed, 28 insertions(+), 28 deletions(-)

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
