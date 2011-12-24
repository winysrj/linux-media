Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755598Ab1LXPvI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Dec 2011 10:51:08 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBOFp74P009962
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 24 Dec 2011 10:51:07 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v4 42/47] [media] cxusb: use DVBv5 parameters on set_params()
Date: Sat, 24 Dec 2011 13:50:47 -0200
Message-Id: <1324741852-26138-43-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324741852-26138-42-git-send-email-mchehab@redhat.com>
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
 <1324741852-26138-36-git-send-email-mchehab@redhat.com>
 <1324741852-26138-37-git-send-email-mchehab@redhat.com>
 <1324741852-26138-38-git-send-email-mchehab@redhat.com>
 <1324741852-26138-39-git-send-email-mchehab@redhat.com>
 <1324741852-26138-40-git-send-email-mchehab@redhat.com>
 <1324741852-26138-41-git-send-email-mchehab@redhat.com>
 <1324741852-26138-42-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using DVBv3 parameters, rely on DVBv5 parameters to
set the tuner

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb/cxusb.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/cxusb.c b/drivers/media/dvb/dvb-usb/cxusb.c
index 9f2a02c..4f9bfc5 100644
--- a/drivers/media/dvb/dvb-usb/cxusb.c
+++ b/drivers/media/dvb/dvb-usb/cxusb.c
@@ -1074,11 +1074,12 @@ struct dib0700_adapter_state {
 static int dib7070_set_param_override(struct dvb_frontend *fe,
 				      struct dvb_frontend_parameters *fep)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct dvb_usb_adapter *adap = fe->dvb->priv;
 	struct dib0700_adapter_state *state = adap->priv;
 
 	u16 offset;
-	u8 band = BAND_OF_FREQUENCY(fep->frequency/1000);
+	u8 band = BAND_OF_FREQUENCY(p->frequency/1000);
 	switch (band) {
 	case BAND_VHF: offset = 950; break;
 	default:
-- 
1.7.8.352.g876a6

