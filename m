Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:60071 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259Ab1HLIhs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Aug 2011 04:37:48 -0400
Received: from tele (unknown [IPv6:2a01:e35:2f5c:9de0:212:bfff:fe1e:8db5])
	by smtp1-g21.free.fr (Postfix) with ESMTP id D4273940138
	for <linux-media@vger.kernel.org>; Fri, 12 Aug 2011 10:37:42 +0200 (CEST)
Date: Fri, 12 Aug 2011 10:37:49 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 3.2] gspca for_v3.2
Message-ID: <20110812103749.0ba22d60@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit
9bed77ee2fb46b74782d0d9d14b92e9d07f3df6e:

  [media] tuner_xc2028: Allow selection of the frequency adjustment code for XC3028 (2011-08-06 09:52:47 -0300)

are available in the git repository at:
  git://linuxtv.org/jfrancois/gspca.git for_v3.2

Jean-François Moine (15):
      gspca - ov519: Fix LED inversion of some ov519 webcams
      gspca - sonixj: Fix the darkness of sensor om6802 in 320x240
      gspca - jeilinj: Cleanup code
      gspca - sonixj: Adjust the contrast control
      gspca - sonixj: Increase the exposure for sensor soi768
      gspca - sonixj: Cleanup source and remove useless instructions
      gspca - benq: Remove the useless function sd_isoc_init
      gspca - kinect: Remove the gspca_debug definition
      gspca - ov534_9: Use the new control mechanism
      gspca - ov534_9: New sensor ov9712 and new webcam 05a9:8065
      gspca - main: Fix the isochronous transfer interval
      gspca - main: Better values for V4L2_FMT_FLAG_COMPRESSED
      gspca - main: Use a better altsetting for image transfer
      gspca - main: Handle the xHCI error on usb_set_interface()
      gspca - tp6800: New subdriver for Topro webcams

Luiz Carlos Ramos (1):
      gspca - sonixj: Fix wrong register mask for sensor om6802

 Documentation/video4linux/gspca.txt |    3 +
 drivers/media/video/gspca/Kconfig   |    9 +
 drivers/media/video/gspca/Makefile  |    2 +
 drivers/media/video/gspca/benq.c    |   15 -
 drivers/media/video/gspca/gspca.c   |  234 ++-
 drivers/media/video/gspca/jeilinj.c |   10 +-
 drivers/media/video/gspca/kinect.c  |    5 -
 drivers/media/video/gspca/ov519.c   |   22 +-
 drivers/media/video/gspca/ov534_9.c |  504 ++--
 drivers/media/video/gspca/sonixj.c  |   29 +-
 drivers/media/video/gspca/tp6800.c  | 4989 +++++++++++++++++++++++++++++++++++
 11 files changed, 5430 insertions(+), 392 deletions(-)
 create mode 100644 drivers/media/video/gspca/tp6800.c

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
