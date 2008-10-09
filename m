Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from f134.mail.ru ([194.67.57.115])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1KnurX-0001ow-F1
	for linux-dvb@linuxtv.org; Thu, 09 Oct 2008 14:43:31 +0200
Received: from mail by f134.mail.ru with local id 1Knuqz-000KNf-00
	for linux-dvb@linuxtv.org; Thu, 09 Oct 2008 16:42:53 +0400
From: Goga777 <goga777@bk.ru>
To: linux-dvb@linuxtv.org
Mime-Version: 1.0
Date: Thu, 09 Oct 2008 16:42:53 +0400
References: <200810091404.05506.ajurik@quick.cz>
In-Reply-To: <200810091404.05506.ajurik@quick.cz>
Message-Id: <E1Knuqz-000KNf-00.goga777-bk-ru@f134.mail.ru>
Subject: Re: [linux-dvb]
	=?koi8-r?b?W3Zkcl0gc3RiMDg5OSBhbmQgdHQgczItMzIwMA==?=
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

> > it's not working with SR 30000 FEC 3/4 dvb-s2 8PSK, still the same problem.
> >
> > kind regards
> >
> > Newsy
> >
> 
> It seems that patch from 
> http://www.linuxtv.org/pipermail/linux-dvb/2008-July/027264.html is not 
> applied. The internal PLL must be disabled when setting new frequency as is 
> written in stb6100 documentation.


has your July-patch any relation with stb0899 patches from Alex Betis ?

http://www.linuxtv.org/pipermail/linux-dvb/2008-October/029455.html
http://www.linuxtv.org/pipermail/linux-dvb/2008-September/029361.html

Goga


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
