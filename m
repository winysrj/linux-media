Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from f182.mail.ru ([194.67.57.209])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1JcDfJ-0000ZP-Fa
	for linux-dvb@linuxtv.org; Thu, 20 Mar 2008 06:50:18 +0100
From: Igor <goga777@bk.ru>
To: Morfsta <morfsta@gmail.com>
Mime-Version: 1.0
Date: Thu, 20 Mar 2008 08:49:39 +0300
References: <eddfa47b0803191400k2368eebfo4da7aa1930e2c0cc@mail.gmail.com>
In-Reply-To: <eddfa47b0803191400k2368eebfo4da7aa1930e2c0cc@mail.gmail.com>
Message-Id: <E1JcDel-000Es1-00.goga777-bk-ru@f182.mail.ru>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb]
	=?koi8-r?b?SFZSNDAwMCBwYXRjaCBhbmQgTGF0ZXN0IE11bHRp?=
	=?koi8-r?b?cHJvdG8=?=
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

> /root/multiproto/v4l/cx24116.c:1506: error: unknown field 'delivery'
> specified in initializer
> /root/multiproto/v4l/cx24116.c:1506: warning: missing braces around initializer
> /root/multiproto/v4l/cx24116.c:1506: warning: (near initialization for
> 'dvbs_info.delsys')
> /root/multiproto/v4l/cx24116.c:1525: error: unknown field 'delivery'
> specified in initializer
> /root/multiproto/v4l/cx24116.c:1525: warning: missing braces around initializer
> /root/multiproto/v4l/cx24116.c:1525: warning: (near initialization for
> 'dvbs2_info.delsys')
> /root/multiproto/v4l/cx24116.c: In function 'cx24116_get_info':
> /root/multiproto/v4l/cx24116.c:1551: error: 'struct dvbfe_info' has no
> member named 'delivery'
> 
> Anyone got any ideas on how to fix this?

try please with this multiproto's version (without API updating)
http://jusst.de/hg/multiproto/archive/ecb96c96a69e.tar.bz2

Igor



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
