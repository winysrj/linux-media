Return-path: <mchehab@pedra>
Received: from smtp1-g21.free.fr ([212.27.42.1]:33856 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725Ab1GCI1Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Jul 2011 04:27:24 -0400
Received: from tele (unknown [IPv6:2a01:e35:2f5c:9de0:212:bfff:fe1e:8db5])
	by smtp1-g21.free.fr (Postfix) with ESMTP id AEDAE940120
	for <linux-media@vger.kernel.org>; Sun,  3 Jul 2011 10:27:18 +0200 (CEST)
Date: Sun, 3 Jul 2011 10:28:53 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 3.0] gspca for_v3.0
Message-ID: <20110703102853.13c5b0bf@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The following changes since commit
215c52702775556f4caf5872cc84fa8810e6fc7d:

  [media] V4L/videobuf2-memops: use pr_debug for debug messages (2011-06-01 18:20:34 -0300)

are available in the git repository at:
  git://linuxtv.org/jfrancois/gspca.git for_v3.0

Jean-François Moine (2):
      gspca - ov519: Fix sensor detection problems
      gspca - ov519: Fix a LED inversion

 drivers/media/video/gspca/ov519.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
