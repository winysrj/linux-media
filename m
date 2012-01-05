Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756208Ab2AEPiA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Jan 2012 10:38:00 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q05Fc0sU003006
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 5 Jan 2012 10:38:00 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/5] Fix dvb-core set_delivery_system and port drxk to one frontend
Date: Thu,  5 Jan 2012 13:37:47 -0200
Message-Id: <1325777872-14696-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series contain one feature and two bug fixes:

1) it ports the DRX-K driver to use just one frontend for all three
   delivery systems (DVB-C Annex A, DVB-C Annex C and DVB-T).
   As not all DRX-K supports all three, it also adds a logic there to
   show and accept only the delivery systems that are valid to the
   detected DRX-K version;

2) fixes a bug at dvb_frontend that causes it to wait forever, while
   changing to the second or upper delivery system (a var were not
   incremented inside it);

3) fixes a bug that a delivery system change would appear only on the
   second call, for a DVBv3 application.

With all these series applied, it is now possible to use frontend 0
for all delivery systems. As the current tools don't support changing
the delivery system, the dvb-fe-tool (on my experimental tree[1]) can now
be used to change between them:

For example, to use DVB-T with the standard scan:

$ ./dvb-fe-tool -d DVBT && scan /usr/share/dvb/dvb-t/au-Adelaide

[1] http://git.linuxtv.org/mchehab/experimental-v4l-utils.git/shortlog/refs/heads/dvb-utils


Mauro Carvalho Chehab (5):
  [media] drxk: remove ops.info.frequency_stepsize from DVB-C
  [media] drxk: create only one frontend for both DVB-C and DVB-T
  [media] drxk_hard: fix locking issues when changing the delsys
  [media] dvb_frontend: regression fix: add a missing inc inside the
    loop
  [media] dvb_frontend: Update ops.info.type earlier

 drivers/media/dvb/ddbridge/ddbridge-core.c |    2 +-
 drivers/media/dvb/dvb-core/dvb_frontend.c  |   11 +-
 drivers/media/dvb/frontends/drxk.h         |    6 +-
 drivers/media/dvb/frontends/drxk_hard.c    |  206 ++++++++++++----------------
 drivers/media/dvb/frontends/drxk_hard.h    |    4 +-
 drivers/media/dvb/ngene/ngene-cards.c      |    2 +-
 drivers/media/video/em28xx/em28xx-dvb.c    |   28 +----
 7 files changed, 104 insertions(+), 155 deletions(-)

-- 
1.7.7.5

