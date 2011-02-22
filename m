Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:58759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185Ab1BVCVy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Feb 2011 21:21:54 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1M2LsLO029670
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 21 Feb 2011 21:21:54 -0500
Received: from pedra (vpn-224-79.phx2.redhat.com [10.3.224.79])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p1M2HksX012926
	for <linux-media@vger.kernel.org>; Mon, 21 Feb 2011 21:21:53 -0500
Date: Mon, 21 Feb 2011 23:17:41 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/4] Some fixes for tuner, tvp5150 and em28xx
Message-ID: <20110221231741.71a2149e@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This series contain a minor cleanup for tuner and tvp5150, and two fixes
for em28xx controls. Before the em28xx patches, s_ctrl were failing on
qv4l2, because it were returning a positive value of 1 for some calls.

It also contains a fix for control get/set, as it will now check if the
control exists before actually calling subdev for get/set.

Mauro Carvalho Chehab (4):
  [media] tuner: Remove remaining usages of T_DIGITAL_TV
  [media] tvp5150: device detection should be done only once
  [media] em28xx: Fix return value for s_ctrl
  [media] em28xx: properly handle subdev controls

 drivers/media/common/tuners/tuner-xc2028.c |    8 ++--
 drivers/media/video/em28xx/em28xx-video.c  |   35 ++++++++++++++++++++---
 drivers/media/video/tvp5150.c              |   42 ++++++++++++++--------------
 drivers/staging/tm6000/tm6000-cards.c      |    2 -
 include/media/tuner.h                      |    2 +-
 5 files changed, 56 insertions(+), 33 deletions(-)

