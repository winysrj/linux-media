Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:42899 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376Ab1LEISW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Dec 2011 03:18:22 -0500
Received: from tele (unknown [IPv6:2a01:e35:2f5c:9de0:212:bfff:fe1e:8db5])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 7FDF89404FF
	for <linux-media@vger.kernel.org>; Mon,  5 Dec 2011 09:18:15 +0100 (CET)
Date: Mon, 5 Dec 2011 09:19:14 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 3.3] gspca for_v3.3
Message-ID: <20111205091914.05095cf3@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 36d36b884c745c507d9b3f60eb42925749f7d758:

  [media] tm6000: Warning cleanup (2011-11-28 21:58:54 -0200)

are available in the git repository at:
  git://linuxtv.org/jfrancois/gspca.git for_v3.3

Jean-François Moine (6):
      gspca: Remove the useless variable 'reverse_alts'
      gspca: Remove the useless variable 'nbalt'
      gspca - sonixj: Bad sensor mode at start time.
      gspca - sonixj: Change color control for sensor po2030n
      gspca - topro: Lower the frame rate in 640x480 for the tp6800
      gspca - zc3xx: Bad initialization of zc305/gc0303

 drivers/media/video/gspca/benq.c        |    7 ++-
 drivers/media/video/gspca/gl860/gl860.c |    1 -
 drivers/media/video/gspca/gspca.c       |    3 +-
 drivers/media/video/gspca/gspca.h       |    2 -
 drivers/media/video/gspca/konica.c      |    3 -
 drivers/media/video/gspca/mars.c        |    1 -
 drivers/media/video/gspca/nw80x.c       |    1 -
 drivers/media/video/gspca/ov519.c       |    1 -
 drivers/media/video/gspca/se401.c       |   10 +++-
 drivers/media/video/gspca/sonixj.c      |   18 +++--
 drivers/media/video/gspca/spca561.c     |    1 -
 drivers/media/video/gspca/topro.c       |    2 +-
 drivers/media/video/gspca/xirlink_cit.c |    2 -
 drivers/media/video/gspca/zc3xx.c       |  117 +++++++++++++------------------
 14 files changed, 78 insertions(+), 91 deletions(-)

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
