Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:46676 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300Ab2AEJvA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jan 2012 04:51:00 -0500
Received: from tele (unknown [IPv6:2a01:e35:2f5c:9de0:212:bfff:fe1e:9ce4])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 2E184940252
	for <linux-media@vger.kernel.org>; Thu,  5 Jan 2012 10:50:53 +0100 (CET)
Date: Thu, 5 Jan 2012 10:50:57 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 3.3] gspca for_v3.3
Message-ID: <20120105105057.250db575@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This set includes the patch http://patchwork.linuxtv.org/patch/8858.

Most of these patches concern regression fixes and should be backported
to the kernel 3.2.

The following changes since commit 1e73fa5d56333230854ae9460579eb2fcee8af02:

  [media] stb6100: Properly retrieve symbol rate (2011-12-31 17:26:23 -0200)

are available in the git repository at:
  git://linuxtv.org/jfrancois/gspca.git for_v3.3

Hans de Goede (8):
      gspca - main: rename build_ep_tb to build_isoc_ep_tb
      gspca - main: Correct use of interval in bandwidth calculation
      gspca - main: Take numerator into account in fps calculations
      gspca: Check dev->actconfig rather than dev->config
      gspca - main: Avoid clobbering all bandwidth when mic in webcam
      gspca - main: isoc mode devices are never low speed
      gspca: Add a need_max_bandwidth flag to sd_desc
      gscpa - sn9c20x: Add sd_isoc_init ensuring enough bw when i420 fmt

Jean-François Moine (1):
      gspca - main: Change the bandwidth estimation of isochronous transfer.

Jose Alberto Reguero (1):
      gspca - ov534_9: New sensor ov5621 and webcam 05a9:1550

 Documentation/video4linux/gspca.txt         |    1 +
 drivers/media/video/gspca/gspca.c           |   70 +++++++++----
 drivers/media/video/gspca/gspca.h           |    3 +
 drivers/media/video/gspca/nw80x.c           |    1 +
 drivers/media/video/gspca/ov534_9.c         |  141 ++++++++++++++++++++++++++-
 drivers/media/video/gspca/sn9c20x.c         |   38 +++++++
 drivers/media/video/gspca/spca561.c         |    1 +
 drivers/media/video/gspca/stv06xx/stv06xx.c |    4 +-
 drivers/media/video/gspca/xirlink_cit.c     |    4 +-
 9 files changed, 236 insertions(+), 27 deletions(-)


-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
