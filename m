Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from f128.mail.ru ([194.67.57.128])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1JQJvo-00071p-Qf
	for linux-dvb@linuxtv.org; Sat, 16 Feb 2008 11:06:04 +0100
From: Igor <goga777@bk.ru>
To: henk schaap <haschaap@planet.nl>
Mime-Version: 1.0
Date: Sat, 16 Feb 2008 13:05:34 +0300
References: <47B6A9DB.501@planet.nl>
In-Reply-To: <47B6A9DB.501@planet.nl>
Message-Id: <E1JQJvK-000BwB-00.goga777-bk-ru@f128.mail.ru>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb]
	=?koi8-r?b?bXVsdGlwcm90byBhbmQgdHQzMjAwOiBkb24ndCBn?=
	=?koi8-r?b?ZXQgYSBsb2Nr?=
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

> henk@mediapark:~/bin/szap> ./szap -n 1775

try please witch patched szap2

http://abraham.manu.googlepages.com/szap.c

==========================================
Make sure you have the updated headers (frontend.h, version.h in your include 
path)
(You need the same headers from the multiproto tree)

wget http://abraham.manu.googlepages.com/szap.c
copy lnb.c and lnb.h from dvb-apps to the same folder where you downloaded 
szap.c
cc -c lnb.c
cc -c szap.c
cc -o szap szap.o lnb.o
That's it
Manu
==========================================


> reading channels from file '/home/henk/.szap/channels.conf'
> zapping to 1775 'WDR 3;ARD':
> sat 0, frequency = 12109 MHz H, symbolrate 27500000, vpid = 0x1fff, apid 
> = 0x05dd sid = 0x0000
> Querying info .. Delivery system=DVB-S
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> ----------------------------------> Using 'STB0899 DVB-S' DVB-Sstatus 00 
> | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe |
> status 00 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe |
> status 00 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe |
> status 00 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe |
> status 00 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe |
> status 00 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe |
> status 00 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe |
> status 00 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe |
> status 00 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe |
> status 00 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe |
> status 00 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe |
> 
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
