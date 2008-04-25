Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from f92.mail.ru ([194.67.57.162])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1JpI27-0005jY-62
	for linux-dvb@linuxtv.org; Fri, 25 Apr 2008 09:07:47 +0200
Received: from mail by f92.mail.ru with local id 1JpI1Z-000H1F-00
	for linux-dvb@linuxtv.org; Fri, 25 Apr 2008 11:07:13 +0400
From: Igor <goga777@bk.ru>
To: linux-dvb@linuxtv.org
Mime-Version: 1.0
Date: Fri, 25 Apr 2008 11:07:13 +0400
In-Reply-To: <20080424201502.GC4097@gmail.com>
References: <20080424201502.GC4097@gmail.com>
Message-Id: <E1JpI1Z-000H1F-00.goga777-bk-ru@f92.mail.ru>
Subject: Re: [linux-dvb]
	=?koi8-r?b?UEFUQ0g6IEhWUi00MDAwIHN1cHBvcnQgZm9yIG11?=
	=?koi8-r?b?bHRpcHJvdG9fcGx1cwkodGVzdGVkb24gMi42LjI1KQ==?=
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

Hi, Gregoire

with multiproto_plus + your hvr4000-patch I have the same problem with szap2 from dvb-apps

./szap2 -c 19 -n1

reading channels from file '19'
zapping to 1 'Pro7':
sat 0, frequency = 12722 MHz H, symbolrate 22000000, vpid = 0x00ff, apid = 0x0103 sid = 0x27d8
Querying info .. Delivery system=DVB-S
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
ioctl DVBFE_GET_INFO failed: Operation not supported

Igor



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
