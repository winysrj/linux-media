Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755654Ab1LXPvJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Dec 2011 10:51:09 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBOFp9cS017086
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 24 Dec 2011 10:51:09 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v4 43/47] [media] dib0700_devices: use DVBv5 parameters on set_params()
Date: Sat, 24 Dec 2011 13:50:48 -0200
Message-Id: <1324741852-26138-44-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324741852-26138-43-git-send-email-mchehab@redhat.com>
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
 <1324741852-26138-43-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using DVBv3 parameters, rely on DVBv5 parameters to
set the tuner

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb/dib0700_devices.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
index d0174fd..70c3be6 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -806,11 +806,12 @@ static struct dib0070_config dib7770p_dib0070_config = {
 
 static int dib7070_set_param_override(struct dvb_frontend *fe, struct dvb_frontend_parameters *fep)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct dvb_usb_adapter *adap = fe->dvb->priv;
 	struct dib0700_adapter_state *state = adap->priv;
 
 	u16 offset;
-	u8 band = BAND_OF_FREQUENCY(fep->frequency/1000);
+	u8 band = BAND_OF_FREQUENCY(p->frequency/1000);
 	switch (band) {
 		case BAND_VHF: offset = 950; break;
 		case BAND_UHF:
@@ -824,11 +825,12 @@ static int dib7070_set_param_override(struct dvb_frontend *fe, struct dvb_fronte
 static int dib7770_set_param_override(struct dvb_frontend *fe,
 		struct dvb_frontend_parameters *fep)
 {
-	 struct dvb_usb_adapter *adap = fe->dvb->priv;
-	 struct dib0700_adapter_state *state = adap->priv;
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+	struct dvb_usb_adapter *adap = fe->dvb->priv;
+	struct dib0700_adapter_state *state = adap->priv;
 
 	 u16 offset;
-	 u8 band = BAND_OF_FREQUENCY(fep->frequency/1000);
+	 u8 band = BAND_OF_FREQUENCY(p->frequency/1000);
 	 switch (band) {
 	 case BAND_VHF:
 		  dib7000p_set_gpio(fe, 0, 0, 1);
@@ -1208,11 +1210,12 @@ static struct dib0070_config dib807x_dib0070_config[2] = {
 static int dib807x_set_param_override(struct dvb_frontend *fe,
 		struct dvb_frontend_parameters *fep)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct dvb_usb_adapter *adap = fe->dvb->priv;
 	struct dib0700_adapter_state *state = adap->priv;
 
 	u16 offset = dib0070_wbd_offset(fe);
-	u8 band = BAND_OF_FREQUENCY(fep->frequency/1000);
+	u8 band = BAND_OF_FREQUENCY(p->frequency/1000);
 	switch (band) {
 	case BAND_VHF:
 		offset += 750;
@@ -1506,9 +1509,10 @@ static struct dib0090_config dib809x_dib0090_config = {
 static int dib8096_set_param_override(struct dvb_frontend *fe,
 		struct dvb_frontend_parameters *fep)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct dvb_usb_adapter *adap = fe->dvb->priv;
 	struct dib0700_adapter_state *state = adap->priv;
-	u8 band = BAND_OF_FREQUENCY(fep->frequency/1000);
+	u8 band = BAND_OF_FREQUENCY(p->frequency/1000);
 	u16 target;
 	int ret = 0;
 	enum frontend_tune_state tune_state = CT_SHUTDOWN;
@@ -1822,6 +1826,7 @@ struct dibx090p_adc dib8090p_adc_tab[] = {
 static int dib8096p_agc_startup(struct dvb_frontend *fe,
 		struct dvb_frontend_parameters *fep)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct dvb_usb_adapter *adap = fe->dvb->priv;
 	struct dib0700_adapter_state *state = adap->priv;
 	struct dibx000_bandwidth_config pll;
@@ -1841,7 +1846,7 @@ static int dib8096p_agc_startup(struct dvb_frontend *fe,
 	dib8000_set_wbd_ref(fe, target);
 
 
-	while (fep->frequency / 1000 > adc_table->freq) {
+	while (p->frequency / 1000 > adc_table->freq) {
 		better_sampling_freq = 1;
 		adc_table++;
 	}
-- 
1.7.8.352.g876a6

