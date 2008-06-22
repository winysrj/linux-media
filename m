Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.224])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <psofa.psofa@gmail.com>) id 1KAUAC-0008Fo-ET
	for linux-dvb@linuxtv.org; Sun, 22 Jun 2008 20:19:45 +0200
Received: by rv-out-0506.google.com with SMTP id b25so9572651rvf.41
	for <linux-dvb@linuxtv.org>; Sun, 22 Jun 2008 11:19:38 -0700 (PDT)
Message-ID: <8e485a510806221119v65bcc8dei54681a86a5055244@mail.gmail.com>
Date: Sun, 22 Jun 2008 21:19:37 +0300
From: psofa <psofa.psofa@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <200806211920.25821.ajurik@quick.cz>
MIME-Version: 1.0
Content-Disposition: inline
References: <200805122042.43456.ajurik@quick.cz>
	<200806211552.41278.ajurik@quick.cz>
	<200806211840.47025.dkuhlen@gmx.net>
	<200806211920.25821.ajurik@quick.cz>
Subject: Re: [linux-dvb] Re : Re : No lock possible at some DVB-S2 channels
	with TT S2-3200/linux
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

This is with the previous mentioned patch applied
the freq as reported in kingofsat is
Astra 1G (19.2E) - 11797.50 H

Mythbox dvb # ./simpledvbtune -f 11801 -a 0 -n 0 -p h -d 1 -s 27500
using '/dev/dvb/adapter0/frontend0' as frontend
frontend fd=3: type=0
ioclt: FE_SET_VOLTAGE : 1
High band
tone: 1
dvbfe setparams :  delsys=1 1201MHz / Rate : 27500kBPS
Status: 1e: Carrier Viterbi Sync Lock
SNR: 0 46 (0x2e) (4.6dB)
BER: 0 0 0 0 (0x0)
Signal: 0 230 (0xe6) 230 (23.0dBm)
Frontend: f=1197.538

Status: 1e: Carrier Viterbi Sync Lock
SNR: 0 48 (0x30) (4.8dB)
BER: 0 0 0 0 (0x0)
Signal: 0 231 (0xe7) 231 (23.1dBm)
Frontend: f=1197.538

Status: 1e: Carrier Viterbi Sync Lock
SNR: 0 48 (0x30) (4.8dB)
BER: 0 0 0 0 (0x0)
Signal: 0 230 (0xe6) 230 (23.0dBm)
Frontend: f=1197.538
^C
Mythbox dvb # ./simpledvbtune -f 11797 -a 0 -n 0 -p h -d 1 -s 27500
using '/dev/dvb/adapter0/frontend0' as frontend
frontend fd=3: type=0
ioclt: FE_SET_VOLTAGE : 1
High band
tone: 1
dvbfe setparams :  delsys=1 1197MHz / Rate : 27500kBPS
Status: 1e: Carrier Viterbi Sync Lock
SNR: 0 69 (0x45) (6.9dB)
BER: 0 0 0 0 (0x0)
Signal: 222 173 (0xdead) -8531 (5700.5dBm)
Frontend: f=1197.516

Status: 00:
SNR: 222 173 (0xdead) (5700.5dB)
BER: 0 0 0 0 (0x0)
Signal: 222 173 (0xdead) -8531 (5700.5dBm)
Frontend: f=1197.516

Status: 00:
SNR: 222 173 (0xdead) (5700.5dB)
BER: 0 0 0 0 (0x0)
Signal: 222 173 (0xdead) -8531 (5700.5dBm)
Frontend: f=1197.516

Status: 00:
SNR: 222 173 (0xdead) (5700.5dB)
BER: 0 0 0 0 (0x0)
Signal: 222 173 (0xdead) -8531 (5700.5dBm)
Frontend: f=1197.516

after like 10 mins i pushed <enter>

Status: 1e: Carrier Viterbi Sync Lock
SNR: 0 52 (0x34) (5.2dB)
BER: 0 0 0 0 (0x0)
Signal: 0 231 (0xe7) 231 (23.1dBm)
Frontend: f=1197.475

Status: 1e: Carrier Viterbi Sync Lock
SNR: 0 53 (0x35) (5.3dB)
BER: 0 0 0 0 (0x0)
Signal: 0 231 (0xe7) 231 (23.1dBm)
Frontend: f=1197.475



> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
