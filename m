Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520Ab1G1TFK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jul 2011 15:05:10 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6SJ5AcM001190
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 28 Jul 2011 15:05:10 -0400
Received: from localhost.localdomain (vpn-8-21.rdu.redhat.com [10.11.8.21])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p6SJ58KC026840
	for <linux-media@vger.kernel.org>; Thu, 28 Jul 2011 15:05:09 -0400
Date: Thu, 28 Jul 2011 16:04:35 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/2] Some fixes for DVB-C with DRX-K
Message-ID: <20110728160435.68823b02@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those two fixes are needed in order to properly support DVB-C with
Terratec H5 here in Brazil. After those, the quality of the image
for DVB-C is now acceptable.

Mauro Carvalho Chehab (2):
  em28xx: Fix DVB-C maxsize for em2884
  tda18271c2dd: Fix saw filter configuration for DVB-6 @ 6MHz

 drivers/media/dvb/frontends/tda18271c2dd.c |   20 +++++++++++++-
 drivers/media/video/em28xx/em28xx-core.c   |   39 ++++++++++++++++++++--------
 drivers/media/video/em28xx/em28xx-dvb.c    |    5 +++
 3 files changed, 52 insertions(+), 12 deletions(-)

