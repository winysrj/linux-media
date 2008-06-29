Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from f37.mail.ru ([194.67.57.75])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1KCx6N-0000CP-7z
	for linux-dvb@linuxtv.org; Sun, 29 Jun 2008 15:37:59 +0200
From: Goga777 <goga777@bk.ru>
To: =?koi8-r?Q?Philipp_H=3Fbner?= <debalance@arcor.de>
Mime-Version: 1.0
Date: Sun, 29 Jun 2008 17:37:25 +0400
In-Reply-To: <48664867.9060507@arcor.de>
References: <48664867.9060507@arcor.de>
Message-Id: <E1KCx5p-000Bpw-00.goga777-bk-ru@f37.mail.ru>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] =?koi8-r?b?VGVycmFUZWMgQ2luZXJneSBTMiBQQ0kgSEQ=?=
Reply-To: Goga777 <goga777@bk.ru>
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

> Artem Makhutov schrieb:
> > The dvb-utils package, that is shipped with debian won't work with multiproto,
> > because multiproto introduced a new DVB-API.
> > 
> > You have to compile szap (szap2) and scan for yourself, otherwise it
> > won't work.
> 
> Thanks for that hint.
> I uninstalled dvb-utils and compiled and installed the dvb-apps.
> Scan ran successfully and now I've got a very long channels.conf ;)
> 
> Unfortunately szap seems not to work successfully and I didn't manage to
> see any TV yet.

you should use szap2 from test directory of dvb-apps
http://linuxtv.org/hg/dvb-apps/file/77e3c7baa1e4/test/szap2.c


 

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
