Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:38458 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947AbbFXPLg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jun 2015 11:11:36 -0400
Received: by wibdq8 with SMTP id dq8so49720940wib.1
        for <linux-media@vger.kernel.org>; Wed, 24 Jun 2015 08:11:35 -0700 (PDT)
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
	patrice.chotard@st.com, mchehab@osg.samsung.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org,
	hugues.fruchet@st.com, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
Subject: [PATCH 04/12] [media] stv0367: Add support for 16Mhz reference clock
Date: Wed, 24 Jun 2015 16:11:02 +0100
Message-Id: <1435158670-7195-5-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1435158670-7195-1-git-send-email-peter.griffin@linaro.org>
References: <1435158670-7195-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The B2100A dvb NIM card from ST has 2x stv0367 demodulators
and 2x TDA18212 silicon tuners, with a 16Mhz crystal. To
get this working properly with the upstream driver we need
to add support for the 16Mhz reference clock.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 drivers/media/dvb-frontends/stv0367.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/dvb-frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
index c3b7e6c..ad7cab7 100644
--- a/drivers/media/dvb-frontends/stv0367.c
+++ b/drivers/media/dvb-frontends/stv0367.c
@@ -1554,6 +1554,11 @@ static int stv0367ter_init(struct dvb_frontend *fe)
 
 	switch (state->config->xtal) {
 		/*set internal freq to 53.125MHz */
+	case 16000000:
+		stv0367_writereg(state, R367TER_PLLMDIV, 0x2);
+		stv0367_writereg(state, R367TER_PLLNDIV, 0x1b);
+		stv0367_writereg(state, R367TER_PLLSETUP, 0x18);
+		break;
 	case 25000000:
 		stv0367_writereg(state, R367TER_PLLMDIV, 0xa);
 		stv0367_writereg(state, R367TER_PLLNDIV, 0x55);
-- 
1.9.1

