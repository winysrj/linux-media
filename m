Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:52106 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959Ab1IWIg5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Sep 2011 04:36:57 -0400
Received: from tele (unknown [IPv6:2a01:e35:2f5c:9de0:212:bfff:fe1e:8db5])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 43C3C940166
	for <linux-media@vger.kernel.org>; Fri, 23 Sep 2011 10:36:50 +0200 (CEST)
Date: Fri, 23 Sep 2011 10:37:09 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 3.2] gspca for_v3.2
Message-ID: <20110923103709.46363e45@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This set includes the patches:
	http://patchwork.linuxtv.org/patch/7358
	http://patchwork.linuxtv.org/patch/114

Cheers.

The following changes since commit e553000a14ead0e265a8aa4d241c7b3221e233e3:

  [media] sr030pc30: Remove empty s_stream op (2011-09-21 12:48:45 -0300)

are available in the git repository at:
  git://linuxtv.org/jfrancois/gspca.git for_v3.2

Frank Schaefer (1):
      gspca - sn9c20x: Fix status LED device 0c45:62b3.

Jean-François Moine (10):
      gspca - benq: Remove the useless function sd_isoc_init
      gspca - main: Use a better altsetting for image transfer
      gspca - main: Handle the xHCI error on usb_set_interface()
      gspca - topro: New subdriver for Topro webcams
      gspca - spca1528: Increase the status waiting time
      gspca - spca1528: Add some comments and update copyright
      gspca - spca1528: Change the JPEG quality of the images
      gspca - spca1528: Don't force the USB transfer alternate setting
      gspca - main: Version change to 2.14.0
      gspca - main: Display the subdriver name and version at probe time

Wolfram Sang (1):
      gspca - zc3xx: New webcam 03f0:1b07 HP Premium Starter Cam

 Documentation/video4linux/gspca.txt  |    3 +
 drivers/media/video/gspca/Kconfig    |   10 +
 drivers/media/video/gspca/Makefile   |    2 +
 drivers/media/video/gspca/benq.c     |   15 -
 drivers/media/video/gspca/gspca.c    |  225 ++-
 drivers/media/video/gspca/sn9c20x.c  |    2 +-
 drivers/media/video/gspca/spca1528.c |   26 +-
 drivers/media/video/gspca/topro.c    | 4989 ++++++++++++++++++++++++++++++++++
 drivers/media/video/gspca/zc3xx.c    |    1 +
 9 files changed, 5180 insertions(+), 93 deletions(-)
 create mode 100644 drivers/media/video/gspca/topro.c

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
