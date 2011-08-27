Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4308 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab1H0Ocs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Aug 2011 10:32:48 -0400
Received: from alastor.dyndns.org (215.80-203-102.nextgentel.com [80.203.102.215])
	(authenticated bits=0)
	by smtp-vbr10.xs4all.nl (8.13.8/8.13.8) with ESMTP id p7REWj7c043163
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Sat, 27 Aug 2011 16:32:47 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 2C8205A60001
	for <linux-media@vger.kernel.org>; Sat, 27 Aug 2011 16:32:46 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PATCHES FOR 3.2] First round of compiler warning fixes
Date: Sat, 27 Aug 2011 16:32:44 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201108271632.44921.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 9bed77ee2fb46b74782d0d9d14b92e9d07f3df6e:

  [media] tuner_xc2028: Allow selection of the frequency adjustment code for XC3028 (2011-08-06 09:52:47 -0300)

are available in the git repository at:
  ssh://linuxtv.org/git/hverkuil/media_tree.git fixes

Hans Verkuil (14):
      radio-si4713.c: fix compiler warning
      mt20xx.c: fix compiler warnings
      wl128x: fix compiler warning + wrong write() return.
      saa7146: fix compiler warning
      ddbridge: fix compiler warnings
      mxl5005s: fix compiler warning
      af9005-fe: fix compiler warning
      tvaudio: fix compiler warnings
      az6027: fix compiler warnings
      mantis: fix compiler warnings
      drxd_hard: fix compiler warnings
      vpx3220, bt819: fix compiler warnings
      si470x: fix compile warning.
      dvb_frontend: fix compile warning.

 drivers/media/common/saa7146_video.c          |   12 ++++--------
 drivers/media/common/tuners/mt20xx.c          |   24 +++++++++++-------------
 drivers/media/common/tuners/mxl5005s.c        |   22 ++++++++++------------
 drivers/media/dvb/ddbridge/ddbridge-core.c    |    9 ++++++---
 drivers/media/dvb/dvb-core/dvb_frontend.c     |    3 +--
 drivers/media/dvb/dvb-usb/af9005-fe.c         |    2 --
 drivers/media/dvb/dvb-usb/az6027.c            |   12 +++++-------
 drivers/media/dvb/frontends/drxd_hard.c       |   11 ++++++-----
 drivers/media/dvb/mantis/hopper_cards.c       |    4 ++--
 drivers/media/dvb/mantis/mantis_cards.c       |    4 ++--
 drivers/media/radio/radio-si4713.c            |    4 ----
 drivers/media/radio/si470x/radio-si470x-usb.c |    2 --
 drivers/media/radio/wl128x/fmdrv_v4l2.c       |    4 +++-
 drivers/media/video/bt819.c                   |    2 +-
 drivers/media/video/tvaudio.c                 |    9 ++++++---
 drivers/media/video/vpx3220.c                 |    2 +-
 16 files changed, 58 insertions(+), 68 deletions(-)
