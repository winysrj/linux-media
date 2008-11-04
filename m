Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HWerner4@gmx.de>) id 1KxOBG-0007BP-6M
	for linux-dvb@linuxtv.org; Tue, 04 Nov 2008 16:51:00 +0100
Date: Tue, 04 Nov 2008 16:50:24 +0100
From: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <c74595dc0811031212p1ebe023fm43e81861650fcd6d@mail.gmail.com>
Message-ID: <20081104155024.68280@gmx.net>
MIME-Version: 1.0
References: <c74595dc0810251452s65154902td934e87560cad9f0@mail.gmail.com>
	<b42fca4d0810280227n44d53f03hfaa8237793fc1db9@mail.gmail.com>
	<c74595dc0810281223j25d78c9eqbcbed70a1b495b43@mail.gmail.com>
	<b42fca4d0810281305l6e741c25ia25e1f3f348761d5@mail.gmail.com>
	<c74595dc0810281320r9ef1a1cw172a36738c8a4e8@mail.gmail.com>
	<c74595dc0810301510t5ae3df6fg28c6a62e999aed83@mail.gmail.com>
	<20081031145853.2b722c9f@bk.ru>
	<157f4a8c0811030703w195a4947uab8c3076173898e5@mail.gmail.com>
	<157f4a8c0811031004j776b2eb2v67d59b80775246b9@mail.gmail.com>
	<c74595dc0811031212p1ebe023fm43e81861650fcd6d@mail.gmail.com>
To: "Alex Betis" <alex.betis@gmail.com>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [ANNOUNCE] scan-s2 is available, please test
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

I don't know if anyone mentioned it already, but scan-s2 does not work for DVB-T.

Here is a patch which fixes DVB-T support.

Signed-off-by: Hans Werner <hwerner4@gmx.de>

diff -r fff2d1f1fd4f scan.c
--- a/scan.c	Fri Oct 31 14:07:06 2008 +0200
+++ b/scan.c	Tue Nov 04 15:38:09 2008 +0000
@@ -1523,6 +1523,7 @@ static int __tune_to_transponder (int fr
 	int i;
 	fe_status_t s;
 	uint32_t if_freq;
+	uint32_t bandwidth_hz = 0;
 	current_tp = t;
 
 	struct dtv_property p_clear[] = {
@@ -1580,7 +1581,22 @@ static int __tune_to_transponder (int fr
 		if (verbosity >= 2)
 			dprintf(1,"DVB-S IF freq is %d\n", if_freq);
 	}
-
+	else if (t->delivery_system == SYS_DVBT) {
+		if_freq=t->frequency;
+		if (t->bandwidth == BANDWIDTH_6_MHZ)
+                        bandwidth_hz = 6000000;
+                else if (t->bandwidth == BANDWIDTH_7_MHZ)
+                        bandwidth_hz = 7000000;
+                else if (t->bandwidth == BANDWIDTH_8_MHZ)
+                        bandwidth_hz = 8000000;
+                else
+                        /* Including BANDWIDTH_AUTO */
+                        bandwidth_hz = 0;
+		if (verbosity >= 2){
+			dprintf(1,"DVB-T frequency is %d\n", if_freq);
+			dprintf(1,"DVB-T bandwidth is %d\n", bandwidth_hz);
+		}
+	}
 
 	struct dvb_frontend_event ev;
 	struct dtv_property p_tune[] = {
@@ -1591,11 +1607,12 @@ static int __tune_to_transponder (int fr
 		{ .cmd = DTV_INNER_FEC,			.u.data = t->fec },
 		{ .cmd = DTV_INVERSION,			.u.data = t->inversion },
 		{ .cmd = DTV_ROLLOFF,			.u.data = t->rolloff },
-		{ .cmd = DTV_PILOT,				.u.data = PILOT_AUTO },
+		{ .cmd = DTV_BANDWIDTH_HZ,		.u.data = bandwidth_hz },
+		{ .cmd = DTV_PILOT,			.u.data = PILOT_AUTO },
 		{ .cmd = DTV_TUNE },
 	};
 	struct dtv_properties cmdseq_tune = {
-		.num = 9,
+		.num = 10,
 		.props = p_tune
 	};
 


-- 
Release early, release often.

"Feel free" - 10 GB Mailbox, 100 FreeSMS/Monat ...
Jetzt GMX TopMail testen: http://www.gmx.net/de/go/topmail

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
