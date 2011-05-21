Return-path: <mchehab@pedra>
Received: from smtp5-g21.free.fr ([212.27.42.5]:42793 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383Ab1EUG7H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 May 2011 02:59:07 -0400
Received: from tele (unknown [82.245.201.222])
	by smtp5-g21.free.fr (Postfix) with ESMTP id E1806D4824B
	for <linux-media@vger.kernel.org>; Sat, 21 May 2011 08:59:00 +0200 (CEST)
Date: Sat, 21 May 2011 08:59:33 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.40] gspca for_v2.6.40
Message-ID: <20110521085933.485f77aa@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The following changes since commit
f9b51477fe540fb4c65a05027fdd6f2ecce4db3b:

  [media] DVB: return meaningful error codes in dvb_frontend (2011-05-09 05:47:20 +0200)

are available in the git repository at:
  git://linuxtv.org/jfrancois/gspca.git for_v2.6.40

Jean-François Moine (9):
      gspca - cpia1: Fix some warnings.
      gspca - kinect: Remove __devinitdata
      gspca - stk014 / t613: Accept the index 0 in querymenu
      gspca - main: Version change to 2.13
      gspca - main: Remove USB traces
      gspca - cpia1: Remove a bad conditional compilation instruction
      gspca: Unset debug by default
      gspca: Fix some warnings tied to 'no debug'
      gspca - sunplus: Fix some warnings and simplify code

 drivers/media/video/gspca/cpia1.c       |    6 +--
 drivers/media/video/gspca/gl860/gl860.c |   15 +----
 drivers/media/video/gspca/gspca.c       |    4 +-
 drivers/media/video/gspca/gspca.h       |    6 +-
 drivers/media/video/gspca/kinect.c      |    2 +-
 drivers/media/video/gspca/spca508.c     |    5 +-
 drivers/media/video/gspca/stk014.c      |   15 ++---
 drivers/media/video/gspca/sunplus.c     |   99 ++++++++++--------------------
 drivers/media/video/gspca/t613.c        |   17 ++----
 drivers/media/video/gspca/zc3xx.c       |    5 +-
 10 files changed, 61 insertions(+), 113 deletions(-)

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
