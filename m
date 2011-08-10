Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:57918 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814Ab1HJGn0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Aug 2011 02:43:26 -0400
Received: from tele (unknown [IPv6:2a01:e35:2f5c:9de0:212:bfff:fe1e:8db5])
	by smtp1-g21.free.fr (Postfix) with ESMTP id F341C9400F3
	for <linux-media@vger.kernel.org>; Wed, 10 Aug 2011 08:43:19 +0200 (CEST)
Date: Wed, 10 Aug 2011 08:43:22 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 3.1] gspca for_v3.1
Message-ID: <20110810084322.3725ec7b@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit
46540f7ac646ada7f22912ea7ea9b761ff5c4718:

  [media] ir-mce_kbd-decoder: include module.h for its facilities (2011-07-29 12:52:23 -0300)

are available in the git repository at:
  git://linuxtv.org/jfrancois/gspca.git for_v3.1

Jean-François Moine (2):
      gspca - ov519: Fix LED inversion of some ov519 webcams
      gspca - sonixj: Fix the darkness of sensor om6802 in 320x240

Luiz Carlos Ramos (1):
      gspca - sonixj: Fix wrong register mask for sensor om6802

 drivers/media/video/gspca/ov519.c  |   22 ++++++++++------------
 drivers/media/video/gspca/sonixj.c |    6 +++++-
 2 files changed, 15 insertions(+), 13 deletions(-)

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
