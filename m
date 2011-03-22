Return-path: <mchehab@pedra>
Received: from smtp5-g21.free.fr ([212.27.42.5]:33601 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753743Ab1CVJ4n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2011 05:56:43 -0400
Received: from tele (unknown [82.245.201.222])
	by smtp5-g21.free.fr (Postfix) with ESMTP id 1BA74D48240
	for <linux-media@vger.kernel.org>; Tue, 22 Mar 2011 10:56:36 +0100 (CET)
Date: Tue, 22 Mar 2011 10:57:07 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.39] gspca for_v2.6.39
Message-ID: <20110322105707.2581001b@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The following changes since commit
d2803205ff3be8e8ea4634709799606c5d5294b5:

  [media] via-camera: Fix OLPC serial check (2011-03-21 21:48:25 -0300)

are available in the git repository at:
  git://linuxtv.org/jfrancois/gspca.git for_v2.6.39

Jean-François Moine (9):
      gspca - nw80x: Cleanup source
      gspca - nw80x: The webcam dsb-c110 is the same as the twinkle
      gspca - nw80x: Do some initialization at probe time
      gspca - nw80x: Fix the gain, exposure and autogain
      gspca - nw80x: Check the bridge from the webcam type
      gspca - nw80x: Fix some image resolutions
      gspca - nw80x: Get the sensor ID when bridge et31x110
      gspca - nw80x: Fix exposure for some webcams
      gspca - zc3xx: Add exposure control for sensor hv7131r

Patrice Chotard (1):
      gspca - main: Add endpoint direction test in alt_xfer

 drivers/media/video/gspca/gspca.c |    3 +-
 drivers/media/video/gspca/nw80x.c |  858 ++++++++++++-------------------------
 drivers/media/video/gspca/zc3xx.c |   76 +++-
 3 files changed, 351 insertions(+), 586 deletions(-)
-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
