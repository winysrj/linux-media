Return-path: <mchehab@pedra>
Received: from smtp1-g21.free.fr ([212.27.42.1]:48683 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755336Ab1GCKbf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Jul 2011 06:31:35 -0400
Received: from tele (unknown [IPv6:2a01:e35:2f5c:9de0:212:bfff:fe1e:8db5])
	by smtp1-g21.free.fr (Postfix) with ESMTP id D460E94016B
	for <linux-media@vger.kernel.org>; Sun,  3 Jul 2011 12:31:29 +0200 (CEST)
Date: Sun, 3 Jul 2011 12:33:05 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 3.1] gspca for_v3.1
Message-ID: <20110703123305.7b17e5f8@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The following changes since commit
df6aabbeb2b8799d97f3886fc994c318bc6a6843:

  [media] v4l2-ctrls.c: add support for V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK (2011-07-01 20:54:51 -0300)

are available in the git repository at:
  git://linuxtv.org/jfrancois/gspca.git for_v3.1

Frank Schaefer (1):
      gspca - sn9c20x: device 0c45:62b3: fix status LED

Jean-François Moine (3):
      gspca - ov519: Fix sensor detection problems
      gspca - ov519: Fix a LED inversion
      gspca - jeilinj: Cleanup code

Wolfram Sang (1):
      gspca - zc3xx: add usb_id for HP Premium Starter Cam

 Documentation/video4linux/gspca.txt |    1 +
 drivers/media/video/gspca/jeilinj.c |   10 ++--------
 drivers/media/video/gspca/ov519.c   |    6 +++++-
 drivers/media/video/gspca/sn9c20x.c |    2 +-
 drivers/media/video/gspca/zc3xx.c   |    1 +
 5 files changed, 10 insertions(+), 10 deletions(-)

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
