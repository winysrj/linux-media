Return-path: <mchehab@localhost>
Received: from mx1.redhat.com ([209.132.183.28]:46020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755819Ab1GKB73 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2011 21:59:29 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6B1xT4o014276
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 21:59:29 -0400
Received: from pedra (vpn-225-29.phx2.redhat.com [10.3.225.29])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p6B1xKKT030664
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 21:59:28 -0400
Date: Sun, 10 Jul 2011 22:58:49 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 02/21] [media] tda18271c2dd: add tda18271c2dd prefix to the
 errors
Message-ID: <20110710225849.475c1eda@pedra>
In-Reply-To: <cover.1310347962.git.mchehab@redhat.com>
References: <cover.1310347962.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

It is hard to identify the origin for those errors without a
prefix to indicate which driver produced them:

[ 1390.220984] i2c_write error
[ 1390.224133] I2C Write error
[ 1391.284202] i2c_read error
[ 1392.288685] i2c_read error

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/frontends/tda18271c2dd.c b/drivers/media/dvb/frontends/tda18271c2dd.c
index 90584eb..2eb3a31 100644
--- a/drivers/media/dvb/frontends/tda18271c2dd.c
+++ b/drivers/media/dvb/frontends/tda18271c2dd.c
@@ -130,7 +130,7 @@ static int i2c_write(struct i2c_adapter *adap, u8 adr, u8 *data, int len)
 			      .buf = data, .len = len};
 
 	if (i2c_transfer(adap, &msg, 1) != 1) {
-		printk(KERN_ERR "i2c_write error\n");
+		printk(KERN_ERR "tda18271c2dd: i2c write error at addr %i\n", adr);
 		return -1;
 	}
 	return 0;
@@ -582,7 +582,7 @@ static int RFTrackingFiltersInit(struct tda_state *state,
 	state->m_RF3[RFBand] = RF3;
 
 #if 0
-	printk(KERN_ERR "%s %d RF1 = %d A1 = %d B1 = %d RF2 = %d A2 = %d B2 = %d RF3 = %d\n", __func__,
+	printk(KERN_ERR "tda18271c2dd: %s %d RF1 = %d A1 = %d B1 = %d RF2 = %d A2 = %d B2 = %d RF3 = %d\n", __func__,
 	       RFBand, RF1, state->m_RF_A1[RFBand], state->m_RF_B1[RFBand], RF2,
 	       state->m_RF_A2[RFBand], state->m_RF_B2[RFBand], RF3);
 #endif
@@ -610,7 +610,7 @@ static int PowerScan(struct tda_state *state,
 		      SearchMap1(m_GainTaper_Map, RF_in, &Gain_Taper) &&
 		      SearchMap3(m_CID_Target_Map, RF_in, &CID_Target, &CountLimit))) {
 
-			printk(KERN_ERR "%s Search map failed\n", __func__);
+			printk(KERN_ERR "tda18271c2dd: %s Search map failed\n", __func__);
 			return -EINVAL;
 		}
 
@@ -991,7 +991,7 @@ static int ChannelConfiguration(struct tda_state *state,
 	u8 IR_Meas = 0;
 
 	state->IF = IntermediateFrequency;
-	/* printk("%s Freq = %d Standard = %d IF = %d\n", __func__, Frequency, Standard, IntermediateFrequency); */
+	/* printk("tda18271c2dd: %s Freq = %d Standard = %d IF = %d\n", __func__, Frequency, Standard, IntermediateFrequency); */
 	/* get values from tables */
 
 	if (!(SearchMap1(m_BP_Filter_Map, Frequency, &BP_Filter) &&
@@ -999,7 +999,7 @@ static int ChannelConfiguration(struct tda_state *state,
 	       SearchMap1(m_IR_Meas_Map, Frequency, &IR_Meas) &&
 	       SearchMap4(m_RF_Band_Map, Frequency, &RF_Band))) {
 
-		printk(KERN_ERR "%s SearchMap failed\n", __func__);
+		printk(KERN_ERR "tda18271c2dd: %s SearchMap failed\n", __func__);
 		return -EINVAL;
 	}
 
-- 
1.7.1


