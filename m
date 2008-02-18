Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from f111.mail.ru ([194.67.57.231])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1JR74u-00066D-Hv
	for linux-dvb@linuxtv.org; Mon, 18 Feb 2008 15:34:44 +0100
From: Igor <goga777@bk.ru>
To: Michael Curtis <michael.curtis@glcweb.co.uk>
Mime-Version: 1.0
Date: Mon, 18 Feb 2008 17:34:02 +0300
In-Reply-To: <A33C77E06C9E924F8E6D796CA3D635D1023974@w2k3sbs.glcdomain.local>
References: <A33C77E06C9E924F8E6D796CA3D635D1023974@w2k3sbs.glcdomain.local>
Message-Id: <E1JR74E-0001pD-00.goga777-bk-ru@f111.mail.ru>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb]
	=?koi8-r?b?Tm8gcmVzdWx0cyBmcm9tIG11bHRpcHJvdG8gJiBU?=
	=?koi8-r?b?VDMyMDA=?=
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
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

> [mythtv@f864office szap2]$ ./szap2 -c ../../channels.sat2 -t0 -n101
> reading channels from file '../../channels.sat2'
> zapping to 101 'BBC NEWS 24;BSkyB':
> sat 0, frequency = 10773 MHz H, symbolrate 22000000, vpid = 0x1518, apid
> = 0x1519 sid = 0x151b Querying info .. Delivery system=DVB-S using
> '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> ----------------------------------> Using 'STB0899 DVB-S' DVB-S
> do_tune: API version=3, delivery system = 0
> do_tune: Frequency = 1023000, Srate = 22000000
> do_tune: Frequency = 1023000, Srate = 22000000
> 
> 
> status 00 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe | 
> status 1e | signal 0136 | snr 005f | ber 00000000 | unc fffffffe |
> FE_HAS_LOCK 
> status 1e | signal 0136 | snr 005f | ber 00000000 | unc fffffffe |
> FE_HAS_LOCK 
> status 1e | signal 0136 | snr 0060 | ber 00000000 | unc fffffffe |
> FE_HAS_LOCK 
> status 1e | signal 0136 | snr 005e | ber 00000000 | unc fffffffe |
> FE_HAS_LOCK 
> status 1e | signal 0136 | snr 005e | ber 00000000 | unc fffffffe |
> FE_HAS_LOCK


it's seems OK

> If I do 
> 
> cat /dev/dvb/adapter0/dv0 > test.ts

you are missing the letter R

cat /dev/dvb/adapter0/dvr0 > test.ts


Igor
	<linux-dvb@linuxtv.org>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
