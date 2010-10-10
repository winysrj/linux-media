Return-path: <mchehab@pedra>
Received: from smtp5-g21.free.fr ([212.27.42.5]:44665 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932342Ab0JJLYB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Oct 2010 07:24:01 -0400
Received: from tele (unknown [82.245.201.222])
	by smtp5-g21.free.fr (Postfix) with ESMTP id 335BDD48142
	for <linux-media@vger.kernel.org>; Sun, 10 Oct 2010 13:23:54 +0200 (CEST)
Date: Sun, 10 Oct 2010 13:24:47 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.36] gspca for_2.6.36
Message-ID: <20101010132447.0c7f9a22@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The following changes since commit
d65728875a85ac7c8b7d6eb8d51425bacc188980:

  V4L/DVB: v4l: radio: si470x: fix unneeded free_irq() call (2010-09-30 07:35:12 -0300)

are available in the git repository at:
  git://linuxtv.org/jfrancois/gspca.git for_2.6.36

Jean-François Moine (1):
      gspca - main: Fix a regression with the PS3 Eye webcam

 drivers/media/video/gspca/gspca.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
