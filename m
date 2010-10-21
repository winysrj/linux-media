Return-path: <mchehab@pedra>
Received: from smtp5-g21.free.fr ([212.27.42.5]:58625 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720Ab0JUHSu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Oct 2010 03:18:50 -0400
Received: from tele (unknown [82.245.201.222])
	by smtp5-g21.free.fr (Postfix) with ESMTP id 26C9DD4810C
	for <linux-media@vger.kernel.org>; Thu, 21 Oct 2010 09:18:43 +0200 (CEST)
Date: Thu, 21 Oct 2010 09:19:46 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.36] gspca for_2.6.36
Message-ID: <20101021091946.7e13a5e0@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

I added two fixes of an other regression. They should go to 2.6.36.

The following changes since commit
d65728875a85ac7c8b7d6eb8d51425bacc188980:

  V4L/DVB: v4l: radio: si470x: fix unneeded free_irq() call (2010-09-30 07:35:12 -0300)

are available in the git repository at:
  git://linuxtv.org/jfrancois/gspca.git for_2.6.36

Jean-François Moine (3):
      gspca - main: Fix a regression with the PS3 Eye webcam
      gspca - sonixj: Fix a regression of sensors hv7131r and mi0360
      gspca - sonixj: Fix a regression with sensor hv7131r

 drivers/media/video/gspca/gspca.c  |    4 ++--
 drivers/media/video/gspca/sonixj.c |    6 ++----
 2 files changed, 4 insertions(+), 6 deletions(-)

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
