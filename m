Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:41807 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758340Ab2CSIYk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Mar 2012 04:24:40 -0400
Received: from tele (unknown [IPv6:2a01:e35:2f5c:9de0:212:bfff:fe1e:9ce4])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 93083940143
	for <linux-media@vger.kernel.org>; Mon, 19 Mar 2012 09:24:33 +0100 (CET)
Date: Mon, 19 Mar 2012 09:24:48 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 3.4] gspca for_v3.4
Message-ID: <20120319092448.1ac7a587@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This set includes the patch http://patchwork.linuxtv.org/patch/9494.

The following changes since commit 632fba4d012458fd5fedc678fb9b0f8bc59ceda2:

  [media] cx25821: Add a card definition for "No brand" cards that have: subvendor = 0x0000 subdevice = 0x0000 (2012-03-08 12:42:28 -0300)

are available in the git repository at:

  git://linuxtv.org/jfrancois/gspca.git for_v3.4

for you to fetch changes up to 898b0fd6218c7012a1b73e3bf7a7c60fd578c0a6:

  gspca - sn9c20x: Cleanup source (2012-03-19 08:55:16 +0100)

----------------------------------------------------------------
Jean-François Moine (12):
      gspca - zc3xx: Add V4L2_CID_JPEG_COMPRESSION_QUALITY control support
      gspca - zc3xx: Lack of register 08 value for sensor cs2102k
      gspca - sn9c20x: Fix loss of frame start
      gspca - sn9c20x: Use the new video control mechanism
      gspca - sn9c20x: Propagate USB errors to higher level
      gspca - sn9c20x: Add a delay after Omnivision sensor reset
      gspca - sn9c20x: Add the JPEG compression quality control
      gspca - sn9c20x: Optimize the code of write sequences
      gspca - sn9c20x: Greater delay in case of sensor no response
      gspca - sn9c20x: Add automatic JPEG compression mechanism
      gspca - sn9c20x: Simplify register write for capture start/stop
      gspca - sn9c20x: Cleanup source

Jose Alberto Reguero (1):
      gspca - ov534_9: Add brightness to OmniVision 5621 sensor

 drivers/media/video/gspca/ov534_9.c |   49 ++-
 drivers/media/video/gspca/sn9c20x.c | 1138 ++++++++++++++++-------------------
 drivers/media/video/gspca/zc3xx.c   |   47 ++-
 3 files changed, 582 insertions(+), 652 deletions(-)


-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
