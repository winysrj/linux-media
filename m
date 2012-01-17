Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927Ab2AQS5O (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jan 2012 13:57:14 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0HIvEAG006560
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 17 Jan 2012 13:57:14 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/4] Some DVB fixes (3 for API, 1 for dvb_frontend)
Date: Tue, 17 Jan 2012 16:57:05 -0200
Message-Id: <1326826629-29961-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series of patches contain 3 API fixes. I'm not increasing the
DVB API number because it will be increased anyway by Antti's
API additions for DTMB.

Those fixes on this series are:

1) DTV_FREQUENCY is kHz on DVB-S & friends;

2) There are more parameters for ISDB-T than supported. On ISDB-T,
the hierarchical transmission is completely different than the one
on DVB-T: the OFDM carriers are grouped into up to 3 layers. each
layer can be decoded independently from the others, as each layer
group of carriers use their own modulation. So, there's no such
concept as code rate HP/LP;

3) Some frontends behave badly if they're called while sleeping.
As DVB FE_GET_PROPERTY is called before tuning, to retrieve the
DVB version and the current and supported delivery systems, this
can cause troubles for them.

The fix for (3) is not complete, as a DVBv3 call can still do
bad things. Also, the DVB frontend thread may call get_frontend
before the frontend is ready to provide the needed information.

A deeper analysis will be needed to fix it completely, but
at least the regression is fixed with this change.

Mauro Carvalho Chehab (4):
  [media] DocBook/dvbproperty.xml: Fix the units for DTV_FREQUENCY
  [media] DocBook/dvbproperty.xml: Fix ISDB-T delivery system
    parameters
  [media] DocBook/dvbproperty.xml: Remove DTV_MODULATION from ISDB-T
  [media] dvb_frontend: Don't call get_frontend() if idle

 Documentation/DocBook/media/dvb/dvbproperty.xml |   12 +++++-------
 drivers/media/dvb/dvb-core/dvb_frontend.c       |   10 ++++++++--
 2 files changed, 13 insertions(+), 9 deletions(-)

-- 
1.7.8

