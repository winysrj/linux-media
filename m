Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ns.bog.msu.ru ([213.131.20.1] ident=1005)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ldvb@ns.bog.msu.ru>) id 1JciAY-0003Z5-GF
	for linux-dvb@linuxtv.org; Fri, 21 Mar 2008 15:24:33 +0100
Received: from ldvb (helo=localhost)
	by ns.bog.msu.ru with local-esmtp (Exim 4.69)
	(envelope-from <ldvb@ns.bog.msu.ru>) id 1JciBP-0006ut-Ji
	for linux-dvb@linuxtv.org; Fri, 21 Mar 2008 17:25:25 +0300
Date: Fri, 21 Mar 2008 17:25:23 +0300 (MSK)
From: ldvb@ns.bog.msu.ru
To: linux-dvb@linuxtv.org
In-Reply-To: <200803210956.03053@orion.escape-edv.de>
Message-ID: <Pine.LNX.4.62.0803211719590.19123@ns.bog.msu.ru>
References: <Pine.LNX.4.62.0803141625320.8859@ns.bog.msu.ru>
	<200803200118.26462@orion.escape-edv.de>
	<Pine.LNX.4.62.0803201931260.12540@ns.bog.msu.ru>
	<200803210956.03053@orion.escape-edv.de>
MIME-Version: 1.0
Subject: Re: [linux-dvb] TDA10086 fails? DiSEqC bad? TT S-1401 Horizontal
 transponder fails
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


On Fri, 21 Mar 2008, Oliver Endriss wrote:

> Could you please find out the _minimum_ value required?
> You might try 0xff, 0xf7, 0xef, 0xe7, 0xdf, 0xd7, 0xcf, 0xc7 and so on.
So, some statistics:
(Freq: 11043, Horizontal, bitrate 44948)

ff:
Tuner status:  Signal Lock Carrier VITERBI Sync
Signal Strength = 58% SNR = 89% BER = 0 Uncorrected Blocks = 0
 		(strength is flashing, 58-59, more 59)
f7,ef,e7,df,d7,cf:
Signal Strength = 59% SNR = 89% BER = 0 Uncorrected Blocks = 0
 	(with cf SNR is flashing, 88-89, more 88)
c7,bf:
Signal Strength = 59% SNR = 88% BER = 0 Uncorrected Blocks = 0
 	(with bf SNR is flashing, 87-88, more 88)
b7,af:
Signal Strength = 59% SNR = 87% BER = 0 Uncorrected Blocks = 0
 	(with b7 SNR is 87, rare - 88, with af - 87-86, more 87)
a7,a0:
Signal Strength = 59% SNR = 86% BER = 0 Uncorrected Blocks = 0
 	(a7,a0: SNR=85-87, more 86)
9a:
Signal Strength = 59% SNR = 85% BER = 0 Uncorrected Blocks = 0
 	(9a: SNR rare 84)
97:
Signal Strength = 59% SNR = 83% BER = 0 Uncorrected Blocks = 0 (!!!!!!!)
 	(Very rare small BER counts) (!!!!!!!!!!!)
95:
Signal Strength = 59% SNR = 83% BER = 0 Uncorrected Blocks = 0
Signal Strength = 59% SNR = 83% BER = 0 Uncorrected Blocks = 0
Signal Strength = 59% SNR = 83% BER = 0 Uncorrected Blocks = 0
Signal Strength = 59% SNR = 83% BER = 0 Uncorrected Blocks = 0
Signal Strength = 59% SNR = 83% BER = 3 Uncorrected Blocks = 0
Signal Strength = 59% SNR = 83% BER = 0 Uncorrected Blocks = 0
Signal Strength = 59% SNR = 83% BER = 0 Uncorrected Blocks = 0
Signal Strength = 59% SNR = 83% BER = 0 Uncorrected Blocks = 0

8f:
Signal Strength = 59% SNR = 80% BER = 25 Uncorrected Blocks = 0
Signal Strength = 59% SNR = 80% BER = b Uncorrected Blocks = 0
Signal Strength = 59% SNR = 80% BER = 0 Uncorrected Blocks = 0
Signal Strength = 59% SNR = 80% BER = 0 Uncorrected Blocks = 0
Signal Strength = 59% SNR = 80% BER = 0 Uncorrected Blocks = 0
Signal Strength = 59% SNR = 80% BER = 0 Uncorrected Blocks = 0
Signal Strength = 59% SNR = 80% BER = 6 Uncorrected Blocks = 0

8c:
Signal Strength = 59% SNR = 80% BER = 0 Uncorrected Blocks = 0
Signal Strength = 59% SNR = 80% BER = 3 Uncorrected Blocks = 0
Signal Strength = 59% SNR = 80% BER = 8 Uncorrected Blocks = 0
Signal Strength = 59% SNR = 80% BER = 0 Uncorrected Blocks = 0
Signal Strength = 59% SNR = 80% BER = 0 Uncorrected Blocks = 0
Signal Strength = 59% SNR = 80% BER = 0 Uncorrected Blocks = 0
Signal Strength = 59% SNR = 80% BER = 0 Uncorrected Blocks = 0

8b:
Signal Strength = 59% SNR = 80% BER = 0 Uncorrected Blocks = 0
Signal Strength = 59% SNR = 80% BER = 0 Uncorrected Blocks = 0
Signal Strength = 59% SNR = 80% BER = 12 Uncorrected Blocks = 0
Signal Strength = 59% SNR = 80% BER = 0 Uncorrected Blocks = 0
Signal Strength = 59% SNR = 80% BER = 0 Uncorrected Blocks = 0
Signal Strength = 59% SNR = 80% BER = 0 Uncorrected Blocks = 0
Signal Strength = 59% SNR = 80% BER = 0 Uncorrected Blocks = 0

8a:
Signal Strength = 59% SNR = 79% BER = 8 Uncorrected Blocks = 0
Signal Strength = 59% SNR = 79% BER = 0 Uncorrected Blocks = 0
Signal Strength = 59% SNR = 79% BER = 6 Uncorrected Blocks = 0
Signal Strength = 59% SNR = 80% BER = f Uncorrected Blocks = 0
Signal Strength = 59% SNR = 79% BER = 0 Uncorrected Blocks = 0
Signal Strength = 59% SNR = 80% BER = 7 Uncorrected Blocks = 0
Signal Strength = 59% SNR = 79% BER = d Uncorrected Blocks = 0
Signal Strength = 59% SNR = 71% BER = 3f3 Uncorrected Blocks = 0

87:
Signal Strength = 59% SNR = 75% BER = 6c Uncorrected Blocks = 0
Signal Strength = 59% SNR = 75% BER = 60 Uncorrected Blocks = 0
Signal Strength = 59% SNR = 75% BER = 54 Uncorrected Blocks = 0
Signal Strength = 59% SNR = 76% BER = 45 Uncorrected Blocks = 0
Signal Strength = 59% SNR = 76% BER = 6f Uncorrected Blocks = 0
Signal Strength = 59% SNR = 76% BER = 61 Uncorrected Blocks = 0

7f:
Signal Strength = 58% SNR = 71% BER = 246 Uncorrected Blocks = 0
Signal Strength = 59% SNR = 71% BER = 327 Uncorrected Blocks = 0
Signal Strength = 59% SNR = 72% BER = 28c Uncorrected Blocks = 0
Signal Strength = 59% SNR = 71% BER = 1dd Uncorrected Blocks = 0
Signal Strength = 59% SNR = 71% BER = 1ff Uncorrected Blocks = 0

7c:
Signal Strength = 59% SNR = 71% BER = 29d Uncorrected Blocks = 0

7a:
Signal Strength = 59% SNR = 71% BER = 2d6 Uncorrected Blocks = 0
Signal Strength = 59% SNR = 72% BER = 30a Uncorrected Blocks = 0
Signal Strength = 59% SNR = 71% BER = 2e8 Uncorrected Blocks = 0
Signal Strength = 59% SNR = 71% BER = 308 Uncorrected Blocks = 0

79:
Signal Strength = 59% SNR = 71% BER = 2ad Uncorrected Blocks = 0
Signal Strength = 59% SNR = 71% BER = 26e Uncorrected Blocks = 0
Signal Strength = 59% SNR = 71% BER = 323 Uncorrected Blocks = 0
Signal Strength = 59% SNR = 71% BER = 295 Uncorrected Blocks = 0

78:
Signal Strength = 59% SNR = 71% BER = 236 Uncorrected Blocks = 0
Signal Strength = 59% SNR = 71% BER = 2c2 Uncorrected Blocks = 0
Signal Strength = 59% SNR = 71% BER = 2d8 Uncorrected Blocks = 0
Signal Strength = 59% SNR = 71% BER = 223 Uncorrected Blocks = 0
Signal Strength = 59% SNR = 71% BER = 203 Uncorrected Blocks = 0

77:(!!!!!!!!!!!!!!!!!!!)
Signal Strength = 59% SNR = 67% BER = dd8 Uncorrected Blocks = 3b
Signal Strength = 58% SNR = 67% BER = dc4 Uncorrected Blocks = 4
Signal Strength = 58% SNR = 67% BER = cff Uncorrected Blocks = 3
Signal Strength = 59% SNR = 67% BER = e16 Uncorrected Blocks = 3
Signal Strength = 58% SNR = 67% BER = e19 Uncorrected Blocks = 1
Signal Strength = 58% SNR = 67% BER = 118e Uncorrected Blocks = 16


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
