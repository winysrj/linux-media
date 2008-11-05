Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from blu0-omc1-s1.blu0.hotmail.com ([65.55.116.12])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stevthro@hotmail.fr>) id 1KxnpZ-0005Hc-5J
	for linux-dvb@linuxtv.org; Wed, 05 Nov 2008 20:14:18 +0100
Message-ID: <BLU126-W53DD1C6541585D37293AC1AF1F0@phx.gbl>
From: Steve Thro <stevthro@hotmail.fr>
To: <darron@kewl.org>
Date: Wed, 5 Nov 2008 20:13:42 +0100
In-Reply-To: <15308.1225910609@kewl.org>
References: <BLU126-W211E02BF45832661F2020BAF1F0@phx.gbl>
	<14964.1225909409@kewl.org>
	<BLU126-W1455E0B6279BBF11D1BDD4AF1F0@phx.gbl>
	<15308.1225910609@kewl.org>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] no lock on 3/4 with cx24116
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


> Ok. I just tested here:
> =

>> szap-s2 -x -c ./channels.conf "BSkyB Discovery HD"
> reading channels from file './channels.conf'
> zapping to 975 'BSkyB Discovery HD':
> delivery DVB-S2, modulation QPSK
> sat 1, frequency 12324 MHz V, symbolrate 29500000, coderate 3/4, rolloff =
0.35
> vpid 0x0202, apid 0x1fff, sid 0x0edb
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> status 1f | signal d200 | snr 0000 | ber 00000000 | unc 00000000 | FE_HAS=
_LOCK
> =

> it seems to work.

There are some difference between your output and mine:
yours:
rolloff 0.35
sid 0x0edb

mine;
rolloff auto
sid 0x0000


Could you post your channels.conf?


Thanks

steve,





_________________________________________________________________
T=E9l=E9phonez gratuitement =E0 tous vos proches avec Windows Live Messenge=
r=A0 !=A0 T=E9l=E9chargez-le maintenant !
http://www.windowslive.fr/messenger/1.asp
_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
