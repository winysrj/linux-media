Return-path: <mchehab@pedra>
Received: from smtp5-g21.free.fr ([212.27.42.5]:54528 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541Ab1AXThd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jan 2011 14:37:33 -0500
Received: from tele (unknown [82.245.201.222])
	by smtp5-g21.free.fr (Postfix) with ESMTP id 2A09ED48256
	for <linux-media@vger.kernel.org>; Mon, 24 Jan 2011 20:37:26 +0100 (CET)
Date: Mon, 24 Jan 2011 20:40:41 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.38] gspca for_v2.6.38
Message-ID: <20110124204041.54a858b0@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The following changes since commit
e5fb95675639f064ca40df7ad319f1c380443999:

  [media] vivi: fix compiler warning (2011-01-23 12:34:08 -0200)

are available in the git repository at:
  git://linuxtv.org/jfrancois/gspca.git for_v2.6.38

Jean-François Moine (3):
      gspca - zc3xx: Bad delay when given by a table
      gspca - zc3xx: Fix bad images with the sensor hv7131r
      gspca - zc3xx: Discard the partial frames

 drivers/media/video/gspca/zc3xx.c |   31 ++++++++++++++++++++++++++-----
 1 files changed, 26 insertions(+), 5 deletions(-)

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
