Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from blu0-omc3-s15.blu0.hotmail.com ([65.55.116.90])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stevthro@hotmail.fr>) id 1Kxmyi-0000vS-8O
	for linux-dvb@linuxtv.org; Wed, 05 Nov 2008 19:19:41 +0100
Message-ID: <BLU126-W211E02BF45832661F2020BAF1F0@phx.gbl>
From: Steve Thro <stevthro@hotmail.fr>
To: <linux-dvb@linuxtv.org>
Date: Wed, 5 Nov 2008 19:19:04 +0100
MIME-Version: 1.0
Subject: [linux-dvb] no lock on 3/4 with cx24116
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


Hi,

I'am using a TBS 8920 on 2.6.27.2 kernel with s2-liplianin-8c4f85bfc115 dvb=
 drivers.

I could not lock any dvb-s2 channel  with FEC 3/4 on Astra 28.2E.

I have an TT 3200 which lock fine on 3/4 using the same dvb driver.

What information could I provide you to debug?

Regards

steve,

TBS:::

stv:/mnt/szap-s2-80703f959335# ./szap-s2 -c ./channels.conf -n 4 -a 1
reading channels from file './channels.conf'
zapping to 4 'Discovery HD;BSkyB':
delivery DVB-S2, modulation QPSK
sat 0, frequency 12324 MHz V, symbolrate 29500000, coderate 3/4, rolloff au=
to
vpid 0x0202, apid 0x1fff, sid 0x0000
using '/dev/dvb/adapter1/frontend0' and '/dev/dvb/adapter1/demux0'
FE_SET_VOLTAGE failed: Operation not supported
status 01 | signal d440 | snr 0000 | ber 00000000 | unc 00000000 | =

status 01 | signal d440 | snr 0000 | ber 00000000 | unc 00000000 | =

status 01 | signal d440 | snr 0000 | ber 00000000 | unc 00000000 | =



TT 3200:
stv:/mnt/szap-s2-80703f959335# ./szap-s2 -c ./channels.conf -n 4 -a 0
reading channels from file './channels.conf'
zapping to 4 'Discovery HD;BSkyB':
delivery DVB-S2, modulation QPSK
sat 0, frequency 12324 MHz V, symbolrate 29500000, coderate 3/4, rolloff au=
to
vpid 0x0202, apid 0x1fff, sid 0x0000
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1a | signal 05aa | snr 0026 | ber 00000000 | unc fffffffe | FE_HAS_L=
OCK
status 1a | signal 05aa | snr 0015 | ber 00000000 | unc fffffffe | FE_HAS_L=
OCK


Discovery HD;BSkyB:12324:VC34M2O0S1:S28.2E:29500:514=3D27:0;662=3Deng:0:0:3=
803:2:2032:0

_________________________________________________________________
T=E9l=E9phonez gratuitement =E0 tous vos proches avec Windows Live Messenge=
r=A0 !=A0 T=E9l=E9chargez-le maintenant !
http://www.windowslive.fr/messenger/1.asp
_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
