Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-out.m-online.net ([212.18.0.9])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zzam@gentoo.org>) id 1JkhIj-0003S5-3p
	for linux-dvb@linuxtv.org; Sat, 12 Apr 2008 17:05:57 +0200
Message-Id: <20080412150451.505508402@gentoo.org>
References: <20080412150444.987445669@gentoo.org>
Date: Sat, 12 Apr 2008 17:04:50 +0200
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-dvb@linuxtv.org
Content-Disposition: inline; filename=05_mt312-invertable-lnb-voltage.diff
Subject: [linux-dvb] [patch 5/5] mt312: add attach-time setting to invert
	lnb-voltage
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Add a setting to config struct for inversion of lnb-voltage.
Needed for support of Avermedia A700 cards.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
Index: v4l-dvb/linux/drivers/media/dvb/frontends/mt312.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/mt312.c
+++ v4l-dvb/linux/drivers/media/dvb/frontends/mt312.c
@@ -422,11 +422,16 @@ static int mt312_set_voltage(struct dvb_
 {
 	struct mt312_state *state = fe->demodulator_priv;
 	const u8 volt_tab[3] = { 0x00, 0x40, 0x00 };
+	u8 val;
 
 	if (v > SEC_VOLTAGE_OFF)
 		return -EINVAL;
 
-	return mt312_writereg(state, DISEQC_MODE, volt_tab[v]);
+	val = volt_tab[v];
+	if (state->config->voltage_inverted)
+		val ^= 0x40;
+
+	return mt312_writereg(state, DISEQC_MODE, val);
 }
 
 static int mt312_read_status(struct dvb_frontend *fe, fe_status_t *s)
Index: v4l-dvb/linux/drivers/media/dvb/frontends/mt312.h
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/mt312.h
+++ v4l-dvb/linux/drivers/media/dvb/frontends/mt312.h
@@ -31,6 +31,9 @@
 struct mt312_config {
 	/* the demodulator's i2c address */
 	u8 demod_address;
+
+	/* inverted voltage setting */
+	int voltage_inverted:1;
 };
 
 #if defined(CONFIG_DVB_MT312) || (defined(CONFIG_DVB_MT312_MODULE) && defined(MODULE))

-- 

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
