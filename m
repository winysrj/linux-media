Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755395Ab1LXPvG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Dec 2011 10:51:06 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBOFp5f8030838
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 24 Dec 2011 10:51:05 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v4 35/47] [media] pluto2: use DVBv5 parameters on set_params()
Date: Sat, 24 Dec 2011 13:50:40 -0200
Message-Id: <1324741852-26138-36-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324741852-26138-35-git-send-email-mchehab@redhat.com>
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
 <1324741852-26138-11-git-send-email-mchehab@redhat.com>
 <1324741852-26138-12-git-send-email-mchehab@redhat.com>
 <1324741852-26138-13-git-send-email-mchehab@redhat.com>
 <1324741852-26138-14-git-send-email-mchehab@redhat.com>
 <1324741852-26138-15-git-send-email-mchehab@redhat.com>
 <1324741852-26138-16-git-send-email-mchehab@redhat.com>
 <1324741852-26138-17-git-send-email-mchehab@redhat.com>
 <1324741852-26138-18-git-send-email-mchehab@redhat.com>
 <1324741852-26138-19-git-send-email-mchehab@redhat.com>
 <1324741852-26138-20-git-send-email-mchehab@redhat.com>
 <1324741852-26138-21-git-send-email-mchehab@redhat.com>
 <1324741852-26138-22-git-send-email-mchehab@redhat.com>
 <1324741852-26138-23-git-send-email-mchehab@redhat.com>
 <1324741852-26138-24-git-send-email-mchehab@redhat.com>
 <1324741852-26138-25-git-send-email-mchehab@redhat.com>
 <1324741852-26138-26-git-send-email-mchehab@redhat.com>
 <1324741852-26138-27-git-send-email-mchehab@redhat.com>
 <1324741852-26138-28-git-send-email-mchehab@redhat.com>
 <1324741852-26138-29-git-send-email-mchehab@redhat.com>
 <1324741852-26138-30-git-send-email-mchehab@redhat.com>
 <1324741852-26138-31-git-send-email-mchehab@redhat.com>
 <1324741852-26138-32-git-send-email-mchehab@redhat.com>
 <1324741852-26138-33-git-send-email-mchehab@redhat.com>
 <1324741852-26138-34-git-send-email-mchehab@redhat.com>
 <1324741852-26138-35-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using DVBv3 parameters, rely on DVBv5 parameters to
set the tuner

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/pluto2/pluto2.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/pluto2/pluto2.c b/drivers/media/dvb/pluto2/pluto2.c
index 80fb510..027da57 100644
--- a/drivers/media/dvb/pluto2/pluto2.c
+++ b/drivers/media/dvb/pluto2/pluto2.c
@@ -446,8 +446,9 @@ static inline u32 divide(u32 numerator, u32 denominator)
 
 /* LG Innotek TDTE-E001P (Infineon TUA6034) */
 static int lg_tdtpe001p_tuner_set_params(struct dvb_frontend *fe,
-					 struct dvb_frontend_parameters *p)
+					 struct dvb_frontend_parameters *foo)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct pluto *pluto = frontend_to_pluto(fe);
 	struct i2c_msg msg;
 	int ret;
@@ -478,7 +479,7 @@ static int lg_tdtpe001p_tuner_set_params(struct dvb_frontend *fe,
 	else
 		buf[3] = 0x04;
 
-	if (p->u.ofdm.bandwidth == BANDWIDTH_8_MHZ)
+	if (p->bandwidth_hz == 8000000)
 		buf[3] |= 0x08;
 
 	if (sizeof(buf) == 6) {
-- 
1.7.8.352.g876a6

