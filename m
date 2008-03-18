Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from aa012msr.fastwebnet.it ([85.18.95.72])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <insomniac@slackware.it>) id 1Jbfxu-000680-Ja
	for linux-dvb@linuxtv.org; Tue, 18 Mar 2008 18:51:31 +0100
Date: Tue, 18 Mar 2008 18:48:20 +0100
From: insomniac <insomniac@slackware.it>
To: Antti Palosaari <crope@iki.fi>
Message-ID: <20080318184820.7127c263@slackware.it>
In-Reply-To: <47DFFD0D.9060206@iki.fi>
References: <47DFFD0D.9060206@iki.fi>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] PATCH Support for Pinnacle PCTV 73e (Dib7770)
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

On Tue, 18 Mar 2008 19:34:05 +0200
Antti Palosaari <crope@iki.fi> wrote:

> moi
> This patch adds support for Pinnacle PCTV 73e DVB-T stick.
> 
> Albert, could you also give signed-off-by?
> 
> Insomniac, can you still test that there is no copy & paste errors in 
> this patch :)

I just tested your patch against the hg tree, it works perfectly after
having removed old modules, rebooted and plugged back again the usb
stick.

I received a *great* support, in less than 2 days my card moved from
being a small expensive brick to a perfectly working DVB-T card :-)
I want to personally thank Albert and Antti, again, great work :-)

Regards,
-- 
Andrea Barberio

a.barberio@oltrelinux.com - Linux&C.
andrea.barberio@slackware.it - Slackware Linux Project Italia
GPG key on http://insomniac.slackware.it/gpgkey.asc
2818 A961 D6D8 1A8C 6E84  6181 5FA6 03B2 E68A 0B7D
SIP: 5327786, Phone: 06 916503784

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
