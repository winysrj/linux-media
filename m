Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ns.bog.msu.ru ([213.131.20.1] ident=1005)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ldvb@ns.bog.msu.ru>) id 1Ja9x0-0004Iv-4P
	for linux-dvb@linuxtv.org; Fri, 14 Mar 2008 14:27:58 +0100
Received: from ldvb (helo=localhost)
	by ns.bog.msu.ru with local-esmtp (Exim 4.69)
	(envelope-from <ldvb@ns.bog.msu.ru>) id 1Ja9yB-0002Nb-Fx
	for linux-dvb@linuxtv.org; Fri, 14 Mar 2008 16:29:13 +0300
Date: Fri, 14 Mar 2008 16:29:11 +0300 (MSK)
From: ldvb@ns.bog.msu.ru
To: linux-dvb@linuxtv.org
Message-ID: <Pine.LNX.4.62.0803141625320.8859@ns.bog.msu.ru>
MIME-Version: 1.0
Subject: [linux-dvb] (no subject)
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


Hi!

Maybe, somebody could help...
I have the next list of transponders params:
S 11605700 V 44948000 5/6
S 11043300 H 44948000 5/6
(at Orion-express sat, www.orion-express.ru)

and TT-budget card.
Bitrate is approx. 67Mbit.
V-transponder works well.
For the H, there are problems:
Tuner status:  Signal Lock Carrier VITERBI Sync
Signal Strength = 70% SNR = 67% BER = efc Uncorrected Blocks = 3
Signal Strength = 70% SNR = 67% BER = d80 Uncorrected Blocks = 25
Signal Strength = 70% SNR = 67% BER = c77 Uncorrected Blocks = 7
Signal Strength = 70% SNR = 67% BER = d2f Uncorrected Blocks = 0
Signal Strength = 70% SNR = 67% BER = de6 Uncorrected Blocks = 2
Signal Strength = 70% SNR = 67% BER = d9c Uncorrected Blocks = 0
Signal Strength = 70% SNR = 67% BER = ce7 Uncorrected Blocks = 1

The same card used with Hotbird works well with horizontal polarization 
(bitrate approx. 35Mbit).
Cable and receivers are good (checked by another dvb hardware on the 
same cable).

Thanx!


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
