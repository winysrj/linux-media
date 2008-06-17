Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1K8azx-0005lp-6G
	for linux-dvb@linuxtv.org; Tue, 17 Jun 2008 15:13:22 +0200
Message-ID: <4857B85C.9010207@iki.fi>
Date: Tue, 17 Jun 2008 16:13:00 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: SG <SiestaGomez@web.de>
References: <20080615192300.90886244.SiestaGomez@web.de>	<4855F6B0.8060507@gmail.com>
	<1213620050.6543.6.camel@pascal>	<20080616142616.75F9C3BC99@waldorfmail.homeip.net>	<1213626832.6543.23.camel@pascal>
	<20080616194256.cc5f9a55.SiestaGomez@web.de>
In-Reply-To: <20080616194256.cc5f9a55.SiestaGomez@web.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] experimental support for C-1501
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

SG wrote:
> I noticed when using Win32 the signal strenght is very poor on the non working transponders for linux-dvb.
> Perhaps it's enough for Win32 but not for the linux driver.

Cold you test different deltaf and output_mode setting for demodulator? 
Those settings could provide better performance when signal is not so good.

Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
