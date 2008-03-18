Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ns.bog.msu.ru ([213.131.20.1] ident=1005)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ldvb@ns.bog.msu.ru>) id 1Jbfl0-0004PB-0k
	for linux-dvb@linuxtv.org; Tue, 18 Mar 2008 18:37:57 +0100
Received: from ldvb (helo=localhost)
	by ns.bog.msu.ru with local-esmtp (Exim 4.69)
	(envelope-from <ldvb@ns.bog.msu.ru>) id 1Jbflw-0000ow-54
	for linux-dvb@linuxtv.org; Tue, 18 Mar 2008 20:38:54 +0300
Date: Tue, 18 Mar 2008 20:38:48 +0300 (MSK)
From: ldvb@ns.bog.msu.ru
To: linux-dvb@linuxtv.org
In-Reply-To: <Pine.LNX.4.62.0803171305520.18849@ns.bog.msu.ru>
Message-ID: <Pine.LNX.4.62.0803182020190.2543@ns.bog.msu.ru>
References: <Pine.LNX.4.62.0803141625320.8859@ns.bog.msu.ru>
	<04AD1EEA-DF6C-4575-8A8B-D460F199288F@krastelcom.ru>
	<Pine.LNX.4.62.0803141736520.8859@ns.bog.msu.ru>
	<31748235-0C9E-4847-93E1-71B39029E718@krastelcom.ru>
	<Pine.LNX.4.62.0803141819410.8859@ns.bog.msu.ru>
	<Pine.LNX.4.62.0803171305520.18849@ns.bog.msu.ru>
MIME-Version: 1.0
Subject: [linux-dvb] TT-budget S-1401 issues. Horizontal transponder fails
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


Hi again!

New experiment with TT-budget S-1401 shows the next result:
using 2 boxes - one with Linux for error detection and one with Windows 
for control. Both are connected via the passive splitter to the sat. So, 
on Windows ProgDVB is running, controlling the  transponder. And it works 
fine, without errors, showing the free prog. Linux box with the similar 
card shows errors in the stream (at the same time):
Tuner status:  Signal Lock Carrier VITERBI Sync
Signal Strength = 59% SNR = 66% BER = 138c Uncorrected Blocks = 9

Note: strength on the windows box is 78% (10db from 88 were eaten by the 
splitter). Seems, that the problem is not with diseqc control.
Any ideas?

Thanx!


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
