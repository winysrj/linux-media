Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:36746 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755879Ab2CXSOw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Mar 2012 14:14:52 -0400
Received: from tele (unknown [IPv6:2a01:e35:2f5c:9de0:212:bfff:fe1e:9ce4])
	by smtp1-g21.free.fr (Postfix) with ESMTP id C35C094015D
	for <linux-media@vger.kernel.org>; Sat, 24 Mar 2012 19:14:45 +0100 (CET)
Date: Sat, 24 Mar 2012 19:15:11 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 3.4] gspca for_v3.4
Message-ID: <20120324191511.284734cf@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit f92c97c8bd77992ff8bd6ef29a23dc82dca799cb:

  [media] update CARDLIST.em28xx (2012-03-19 23:12:02 -0300)

are available in the git repository at:

  git://linuxtv.org/jfrancois/gspca.git for_v3.4

for you to fetch changes up to 9aadae9dfed054929f80c9f2a7e8b35b195f0b2a:

  gspca - sn9c20x: Change the exposure setting of Omnivision sensors (2012-03-24 13:33:42 +0100)

----------------------------------------------------------------
Jean-François Moine (7):
      gspca - ov519: Add more information about probe problems
      gspca - sn9c20x: Change the number of the sensor mt9vprb
      gspca - sn9c20x: Add the sensor mt9vprb to the sensor ident table
      gspca - sn9c20x: Define more tables as constant
      gspca - sn9c20x: Set the i2c interface speed
      gspca - sn9c20x: Don't do sensor update before the capture is started
      gspca - sn9c20x: Change the exposure setting of Omnivision sensors

 drivers/media/video/gspca/ov519.c   |   10 ++--
 drivers/media/video/gspca/sn9c20x.c |   97 ++++++++++++++++++++++------------
 2 files changed, 68 insertions(+), 39 deletions(-)

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
