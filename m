Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756159Ab3AHA0X (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Jan 2013 19:26:23 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r080QNl2002985
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 7 Jan 2013 19:26:23 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFCv9 0/4] DVB QoS statistics API
Date: Mon,  7 Jan 2013 22:25:46 -0200
Message-Id: <1357604750-772-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the version 9 of the stats API. On this patchset, there are
DocBooks, API headers, dvb-core and one driver example for the new
API usage.

Currently, the driver example is too simple: it adds just 2 QoS
indicators, being one global (signal strength) and one per-layer.

It is simple like that to help others to review this patch series.

Adding the code for the remaining indicators (CNR, UCB, per-layer CNR)
is easy, coding them are a little more complex, as table lookups are
needed to convert from MER to CNR, and from global CNR into dB.
So, I'll code that later.

Mauro Carvalho Chehab (4):
  dvb: Add DVBv5 stats properties for Quality of Service
  dvb: the core logic to handle the DVBv5 QoS properties
  mb86a20s: provide signal strength via DVBv5 stats API
  mb86a20s: add BER measure

 Documentation/DocBook/media/dvb/dvbproperty.xml |  97 ++++++++-
 drivers/media/dvb-core/dvb_frontend.c           |  56 ++++++
 drivers/media/dvb-core/dvb_frontend.h           |  12 ++
 drivers/media/dvb-frontends/mb86a20s.c          | 257 ++++++++++++++++++++++--
 include/uapi/linux/dvb/frontend.h               |  84 +++++++-
 5 files changed, 484 insertions(+), 22 deletions(-)

-- 
1.7.11.7

