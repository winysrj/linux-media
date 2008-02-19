Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from f163.mail.ru ([194.67.57.38])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1JRTwX-0002Lc-FU
	for linux-dvb@linuxtv.org; Tue, 19 Feb 2008 15:59:37 +0100
From: Igor <goga777@bk.ru>
To: Zenon Mousmoulas <zmousm@admin.grnet.gr>
Mime-Version: 1.0
Date: Tue, 19 Feb 2008 17:59:03 +0300
References: <E0915816-8882-4017-94A5-5FD69DE84DFC@admin.grnet.gr>
In-Reply-To: <E0915816-8882-4017-94A5-5FD69DE84DFC@admin.grnet.gr>
Message-Id: <E1JRTvz-0006ob-00.goga777-bk-ru@f163.mail.ru>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb]
	=?koi8-r?b?SGF1cHBhdWdlIFdpblRWLUhWUjQwMDAgYW5kIERW?=
	=?koi8-r?b?Qi1TMi4uLg==?=
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

> > could you show the szap2 output during dvb-s2 tuning
> 
> I just tried it again with 2.6.22:
> 
> tvbox2:~# szap2 -r -t2 -e3 -m8 -c tvbox_dvb/zap/dvb-s/ 
> diseqc4_HellasSat2-39.0E.new LUXETV
> reading channels from file 'tvbox_dvb/zap/dvb-s/ 
> diseqc4_HellasSat2-39.0E.new'
> zapping to 2 'LUXETV':
> sat 3, frequency = 12718 MHz H, symbolrate 7720000, vpid = 0x0bc3,  
> apid = 0x0bc6 sid = 0x012d (fec = 64, mod = 8)
> Querying info .. Delivery system=DVB-S2
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> ioctl DVBFE_GET_INFO failed: Operation not supported
> 
> I will try it again shortly with 2.6.24.

try to use the usual szap, not szap2

Igor


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
