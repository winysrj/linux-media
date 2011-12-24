Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755309Ab1LXPvF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Dec 2011 10:51:05 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBOFp5iw018663
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 24 Dec 2011 10:51:05 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v4 10/47] [media] mxl5005s: fix: don't discard bandwidth changes
Date: Sat, 24 Dec 2011 13:50:15 -0200
Message-Id: <1324741852-26138-11-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324741852-26138-10-git-send-email-mchehab@redhat.com>
References: <1324741852-26138-1-git-send-email-mchehab@redhat.com>
 <1324741852-26138-2-git-send-email-mchehab@redhat.com>
 <1324741852-26138-3-git-send-email-mchehab@redhat.com>
 <1324741852-26138-4-git-send-email-mchehab@redhat.com>
 <1324741852-26138-5-git-send-email-mchehab@redhat.com>
 <1324741852-26138-6-git-send-email-mchehab@redhat.com>
 <1324741852-26138-7-git-send-email-mchehab@redhat.com>
 <1324741852-26138-8-git-send-email-mchehab@redhat.com>
 <1324741852-26138-9-git-send-email-mchehab@redhat.com>
 <1324741852-26138-10-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is a bug on mxl5005s logic: when the bandwidth changes, but using
the same delivery system, the code discard the set_params()
reconfiguration request.

This was happening because, in the previous coding, the bandwidth
calculus were after the check for delivery system changes.

The previous patch changed the logic to estimate the bandwidth to
happend together with the changes at the delivery system.

So, with a one-statement change, it is possible to make the tuner to
reconfigure, in order to adjust to bandwidth changes. this will
likely fix issues on countries that use 7MHz/8MHz DVB-T channels.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mxl5005s.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/common/tuners/mxl5005s.c b/drivers/media/common/tuners/mxl5005s.c
index c63f767..c35d355 100644
--- a/drivers/media/common/tuners/mxl5005s.c
+++ b/drivers/media/common/tuners/mxl5005s.c
@@ -4019,7 +4019,8 @@ static int mxl5005s_set_params(struct dvb_frontend *fe,
 	}
 
 	/* Change tuner for new modulation type if reqd */
-	if (req_mode != state->current_mode) {
+	if (req_mode != state->current_mode ||
+	    req_bw != state->Chan_Bandwidth) {
 		state->current_mode = req_mode;
 		ret = mxl5005s_reconfigure(fe, req_mode, req_bw);
 
-- 
1.7.8.352.g876a6

