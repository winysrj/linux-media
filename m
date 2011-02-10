Return-path: <mchehab@pedra>
Received: from smtp5-g21.free.fr ([212.27.42.5]:35717 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820Ab1BJRFF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Feb 2011 12:05:05 -0500
Received: from tele (unknown [82.245.201.222])
	by smtp5-g21.free.fr (Postfix) with ESMTP id 5FE14D481C2
	for <linux-media@vger.kernel.org>; Thu, 10 Feb 2011 18:04:58 +0100 (CET)
Date: Thu, 10 Feb 2011 18:08:38 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.39] gspca for_v2.6.39
Message-ID: <20110210180838.04d597f2@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The following changes since commit
6148a47ac3872092d4bc4888838bec6dff16654d:

  Merge branch 'rc-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6 (2011-02-09 16:56:33 -0800)

are available in the git repository at:

  git://linuxtv.org/jfrancois/gspca.git for_v2.6.39

Jean-François Moine (16):
      gspca - sonixj: Move the avg lum computation to a separate function
      gspca - sonixj: Better scanning of isochronous packets
      gspca - sonixj: Have the same JPEG quality for encoding and decoding
      gspca - sonixj: Update the JPEG quality for best image transfer
      gspca - sonixj: Fix start sequence of sensor mt9v111
      gspca - sonixj: Adjust autogain for sensor mt9v111
      gspca - sonixj: Simplify GPIO setting when audio present
      gspca - sonixj: Same init for all bridges but the sn9c102p
      gspca - sonixj: Set both pins for infrared of mt9v111 webcams
      gspca - sonixj, zc3xx: Let some bandwidth for audio when USB 1.1
      gspca - ov534: Use the new control mechanism
      gspca - ov534: Add the webcam 06f8:3002 and sensor ov767x
      gspca - ov534: Add saturation control for ov767x
      gspca - sonixj: The pin S_PWR_DN is inverted for sensor mi0360
      gspca - ov519: Add the sensor ov2610ae
      gspca - ov519: Add the 800x600 resolution for sensors ov2610/2610ae

 Documentation/video4linux/gspca.txt |    1 +
 drivers/media/video/gspca/ov519.c   |   90 +++-
 drivers/media/video/gspca/ov534.c   |  980 +++++++++++++++++++++--------------
 drivers/media/video/gspca/sonixj.c  |  353 ++++++++-----
 drivers/media/video/gspca/zc3xx.c   |    4 +
 5 files changed, 912 insertions(+), 516 deletions(-)

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
