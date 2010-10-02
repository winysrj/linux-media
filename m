Return-path: <mchehab@pedra>
Received: from smtp5-g21.free.fr ([212.27.42.5]:60896 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005Ab0JBKcA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Oct 2010 06:32:00 -0400
Received: from tele (unknown [82.245.201.222])
	by smtp5-g21.free.fr (Postfix) with ESMTP id 27A32D480AF
	for <linux-media@vger.kernel.org>; Sat,  2 Oct 2010 12:31:53 +0200 (CEST)
Date: Sat, 2 Oct 2010 12:32:35 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.37] gspca for_2.6.37
Message-ID: <20101002123235.7d3fa669@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The following changes since commit
c8dd732fd119ce6d562d5fa82a10bbe75a376575:

  V4L/DVB: gspca - sonixj: Have 0c45:6130 handled by sonixj instead of sn9c102 (2010-10-01 18:14:35 -0300)

are available in the git repository at:
  git://linuxtv.org/jfrancois/gspca.git for_2.6.37

Jean-François Moine (4):
      gspca - main: New video control mechanism.
      gspca - stk014: Use the new video control mechanism.
      gspca - ov519: Use the new video control mechanism.
      gspca - sonixj: Use the new video control mechanism.

 drivers/media/video/gspca/gspca.c   |  131 ++++++--
 drivers/media/video/gspca/gspca.h   |   12 +-
 drivers/media/video/gspca/ov519.c   |  316 +++++---------------
 drivers/media/video/gspca/sonixj.c  |  583 ++++++++++------------------------
 drivers/media/video/gspca/stk014.c  |  154 +++-------
 drivers/media/video/gspca/w996Xcf.c |    2 +-
 6 files changed, 395 insertions(+), 803 deletions(-)

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
