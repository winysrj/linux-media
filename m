Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:48995 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766Ab2B0MEo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Feb 2012 07:04:44 -0500
Received: from tele (unknown [IPv6:2a01:e35:2f5c:9de0:212:bfff:fe1e:9ce4])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 59E72940182
	for <linux-media@vger.kernel.org>; Mon, 27 Feb 2012 13:04:35 +0100 (CET)
Date: Mon, 27 Feb 2012 13:06:06 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 3.4] gspca for_v3.4
Message-ID: <20120227130606.1f432e7b@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit a3db60bcf7671cc011ab4f848cbc40ff7ab52c1e:

  [media] xc5000: declare firmware configuration structures as static const (2012-02-14 17:22:46 -0200)

are available in the git repository at:

  git://linuxtv.org/jfrancois/gspca.git for_v3.4

for you to fetch changes up to 1b9ace2d5769c1676c96a6dc70ea84d2dea17140:

  gspca - zc3xx: Set the exposure at start of hv7131r (2012-02-27 12:49:49 +0100)

----------------------------------------------------------------
Jean-François Moine (13):
      gspca - pac7302: Add new webcam 06f8:301b
      gspca - pac7302: Cleanup source
      gspca - pac7302: Simplify the function pkt_scan
      gspca - pac7302: Use the new video control mechanism
      gspca - pac7302: Do autogain setting work
      gspca - sonixj: Remove the jpeg control
      gspca - sonixj: Add exposure, gain and auto exposure for po2030n
      gspca - zc3xx: Adjust the JPEG decompression tables
      gspca - zc3xx: Do automatic transfer control for hv7131r and pas202b
      gspca - zc3xx: Remove the low level traces
      gspca - zc3xx: Cleanup source
      gspca - zc3xx: Fix bad sensor values when changing autogain
      gspca - zc3xx: Set the exposure at start of hv7131r

 Documentation/video4linux/gspca.txt |    1 +
 drivers/media/video/gspca/pac7302.c |  583 ++++++++++-------------------------
 drivers/media/video/gspca/sonixj.c  |  185 +++++++++---
 drivers/media/video/gspca/zc3xx.c   |  295 ++++++++++++------
 4 files changed, 511 insertions(+), 553 deletions(-)

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
