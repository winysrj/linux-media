Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900Ab1LRAV0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Dec 2011 19:21:26 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBI0LQkd000466
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 17 Dec 2011 19:21:26 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 0/6] Change support for Annex A/C
Date: Sat, 17 Dec 2011 22:21:07 -0200
Message-Id: <1324167673-20787-1-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As discussed at the ML, all existing drivers, except for dvb-k only
support DVB-C ITU-T J.83 Annex A. Also, a few dvb-c drivers don't support
0.13 roll-off, requred for Annex C. So, apply Manu's patch that
adds a separate delivery system for Annex C, and change a few existing
drivers that are known to work with both standards to work properly with
both annexes.

Mauro Carvalho Chehab (6):
  [media] Update documentation to reflect DVB-C Annex A/C support
  [media] Remove Annex A/C selection via roll-off factor
  [media] drx-k: report the supported delivery systems
  [media] tda10023: Don't use a magic numbers for QAM modulation
  [media] tda10023: add support for DVB-C Annex C
  [media] tda10021: Add support for DVB-C Annex C

 Documentation/DocBook/media/dvb/dvbproperty.xml |   11 +-
 Documentation/DocBook/media/dvb/frontend.xml    |    4 +-
 drivers/media/common/tuners/xc5000.c            |  137 +++++++++-------------
 drivers/media/dvb/dvb-core/dvb_frontend.c       |   25 ++++-
 drivers/media/dvb/frontends/drxk_hard.c         |   43 ++++++-
 drivers/media/dvb/frontends/tda10021.c          |   83 ++++++++++----
 drivers/media/dvb/frontends/tda10023.c          |   77 +++++++++----
 drivers/media/dvb/frontends/tda18271c2dd.c      |   44 +++----
 include/linux/dvb/frontend.h                    |    2 -
 9 files changed, 258 insertions(+), 168 deletions(-)

-- 
1.7.8

