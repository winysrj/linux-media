Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from f183.mail.ru ([194.67.57.216])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1JQM8w-0005vR-Rg
	for linux-dvb@linuxtv.org; Sat, 16 Feb 2008 13:27:46 +0100
Received: from mail by f183.mail.ru with local id 1JQM8S-00063T-00
	for linux-dvb@linuxtv.org; Sat, 16 Feb 2008 15:27:16 +0300
From: Igor <goga777@bk.ru>
To: linux-dvb@linuxtv.org
Mime-Version: 1.0
Date: Sat, 16 Feb 2008 15:27:16 +0300
Message-Id: <E1JQM8S-00063T-00.goga777-bk-ru@f183.mail.ru>
Subject: [linux-dvb] =?koi8-r?b?cGFybTogZHZiX3Bvd2VyZG93bl9vbl9zbGVlcDow?=
	=?koi8-r?b?ICYgbXVsdGlwcm90bw==?=
Reply-To: Igor <goga777@bk.ru>
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi

it's seems the option "dvb-core dvb_shutdown_timeout=0"  doesn't work properly in multiproto

szap2 -c "Astra-19.2E.conf" -r -m 8 -t 2 -p -n 5 -x
reading channels from file 'Astra-19.2E.conf'
zapping to 5 'Astra HD Promo 2':
sat 0, frequency = 11914 MHz H, symbolrate 27500000, vpid = 0x04ff, apid = 0x0503 sid = 0x0083 (fec = -2147483648, mod = 8 )
Querying info .. Delivery system=DVB-S2
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
----------------------------------> Using 'STB0899 DVB-S2' DVB-S2 diseqc: sat_no:0 pol_vert:0 hi_band:1 cmd:e0 10 38 f3 wait:0
do_tune: API version=2, delivery system = 2
do_tune: Frequency = 1314000, Srate = 27500000 (DVB-S2)
do_tune: Frequency = 1314000, Srate = 27500000 (SET_PARAMS) 
status 1a | signal 05aa | snr 001d | ber 00000000 | unc fffffffe | FE_HAS_LOCK

and after that the power for LNB switchedd off.
@Manu
would you check this moment.

Igor




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
