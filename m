Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from pne-smtpout3-sn2.hy.skanova.net ([81.228.8.111])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1JfXqa-0000Se-0N
	for linux-dvb@linuxtv.org; Sat, 29 Mar 2008 10:59:36 +0100
Message-ID: <47EE12CE.2050301@iki.fi>
Date: Sat, 29 Mar 2008 11:58:38 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: ptay1685 <ptay1685@Bigpond.net.au>
References: <e44ae5e0712172128p4e1428aao493d0a1725b6fcd3@mail.gmail.com>	<47EC3BD4.3070307@iki.fi>
	<012f01c89134$85561fc0$6e00a8c0@barny1e59e583e>
In-Reply-To: <012f01c89134$85561fc0$6e00a8c0@barny1e59e583e>
Cc: k.bannister@ieee.org, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] new USB-ID for Leadtek Winfast DTV was: Re:
 New Leadtek Winfast DTV Dongle working - with mods but	no RC
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

ptay1685 wrote:
> Didnt work for me, sorry. Device still not detected.
> 
> Probably me not getting the sources correctly or something - i followed the 
> directions on linuxtv.org website.

hg clone http://linuxtv.org/hg/~pb/v4l-dvb/
cd v4l-dvb/
patch -p1 < ../Leadtek_Winfast_DTV_Dongle_6f01.patch
make
make install

Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
