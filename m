Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-17.arcor-online.net ([151.189.21.57])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <debalance@arcor.de>) id 1KDNkl-000208-NY
	for linux-dvb@linuxtv.org; Mon, 30 Jun 2008 20:05:28 +0200
Message-ID: <48692061.90705@arcor.de>
Date: Mon, 30 Jun 2008 20:05:21 +0200
From: =?KOI8-R?Q?Philipp_Hu=22bner?= <debalance@arcor.de>
MIME-Version: 1.0
To: Goga777 <goga777@bk.ru>, goga777@bk.ru
References: <48664867.9060507@arcor.de>
	<E1KCx5p-000Bpw-00.goga777-bk-ru@f37.mail.ru>
In-Reply-To: <E1KCx5p-000Bpw-00.goga777-bk-ru@f37.mail.ru>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TerraTec Cinergy S2 PCI HD
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

hey,

Goga777 schrieb:
>> Unfortunately szap seems not to work successfully and I didn't manage to
>> see any TV yet.
> 
> you should use szap2 from test directory of dvb-apps
> http://linuxtv.org/hg/dvb-apps/file/77e3c7baa1e4/test/szap2.c

I compiled that one and tried it out, but it still doesn't work:

./szap2 -r -n 001
reading channels from file '/root/.szap/channels.conf'
zapping to 1 'ASTRA SDT':
sat 0, frequency = 12551 MHz V, symbolrate 22000000, vpid = 0x1fff, apid
= 0x1fff sid = 0x000c
Delivery system=DVB-S
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'

do_tune: API version=3, delivery system = 0
do_tune: Frequency = 1951000, Srate = 22000000
do_tune: Frequency = 1951000, Srate = 22000000


status 00 | signal 32e0 | snr b7f6 | ber 00000000 | unc fffffffe |
status 00 | signal 32e0 | snr b7f6 | ber 00000000 | unc fffffffe |
status 00 | signal 32e0 | snr b7f6 | ber 00000000 | unc fffffffe |
status 1e | signal 0154 | snr 007d | ber 00000000 | unc fffffffe |
FE_HAS_LOCK
status 1e | signal 0154 | snr 007b | ber 00000000 | unc fffffffe |
FE_HAS_LOCK
status 1e | signal 0154 | snr 0079 | ber 00000000 | unc fffffffe |
FE_HAS_LOCK
status 1e | signal 0154 | snr 007a | ber 00000000 | unc fffffffe |
FE_HAS_LOCK
[..]

Same behaviour for root and a regular user.
I hate the idea of windows being my only choice.

Best regards,
Philipp
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIaSBhFhl05MJZ4OgRAp34AKDGuxUFqW+AYJltPhUsAMhpn0IRNgCcC8bs
yOke07MoeqhLn33kL6kPvyg=
=uhNh
-----END PGP SIGNATURE-----

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
