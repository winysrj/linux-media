Return-path: <mchehab@pedra>
Received: from smtp5-g21.free.fr ([212.27.42.5]:54875 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752379Ab0JPRW6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Oct 2010 13:22:58 -0400
Received: from tele (unknown [82.245.201.222])
	by smtp5-g21.free.fr (Postfix) with ESMTP id A5F31D481A5
	for <linux-media@vger.kernel.org>; Sat, 16 Oct 2010 19:22:52 +0200 (CEST)
Date: Sat, 16 Oct 2010 19:23:51 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.37] gspca for_2.6.37
Message-ID: <20101016192351.3c44a374@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The following changes since commit
e749edc7e6967f8f92d2c0251c8a3a96524ec327:

  V4L/DVB: IR: ene_ir: few bugfixes (2010-10-16 00:30:12 -0300)

are available in the git repository at:
  git://linuxtv.org/jfrancois/gspca.git for_2.6.37

Jean-François Moine (5):
      gspca - main: Fix a regression with the PS3 Eye webcam
      gspca - main: Have discontinuous sequence numbers when frames are lost
      gspca - mars: Use the new video control mechanism.
      gspca - mars: Propagate USB errors to higher level
      gspca - mars: Add illuminator controls

 drivers/media/video/gspca/gspca.c |    7 +-
 drivers/media/video/gspca/mars.c  |  316 +++++++++++++++++++------------------
 2 files changed, 166 insertions(+), 157 deletions(-)

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
