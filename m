Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49522 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932388Ab2HQCFA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 22:05:00 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 0/4] dvb_frontend: few DTV validation routines
Date: Fri, 17 Aug 2012 05:03:38 +0300
Message-Id: <1345169022-10221-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It could be nice to validate transmission parameters, coming from
the userspace, against standards before those are passed to the
individual chipset driver. As a starting point towards that
I implemented checks for few common standards. Those checks could
be better as I added almost none checks for comparing allowed
parameter combinations. I found it quite time consuming to search
all allowed parameters and combinations...

Those checks are now exported from the dvb-frontend, making for
example demodulator driver possible to call. Maybe someday those
could be used by frontend itself to validate data before pass call
for the driver.

I also noticed our documentation lacks quite totally possible values,
only possible parameters were listed. How do we expect application
makers could know those?

Antti Palosaari (4):
  dvb_frontend: add routine for DVB-T parameter validation
  dvb_frontend: add routine for DVB-T2 parameter validation
  dvb_frontend: add routine for DVB-C annex A parameter validation
  dvb_frontend: add routine for DTMB parameter validation

 drivers/media/dvb-core/dvb_frontend.c | 405 ++++++++++++++++++++++++++++++++++
 drivers/media/dvb-core/dvb_frontend.h |   5 +
 2 files changed, 410 insertions(+)

-- 
1.7.11.2

