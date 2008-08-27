Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail4.sea5.speakeasy.net ([69.17.117.6])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <xyzzy@speakeasy.org>) id 1KYA3y-0001eA-ID
	for linux-dvb@linuxtv.org; Wed, 27 Aug 2008 03:43:12 +0200
Date: Tue, 26 Aug 2008 18:43:05 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Thierry Merle <thierry.merle@free.fr>
In-Reply-To: <48B4571C.1040207@free.fr>
Message-ID: <Pine.LNX.4.58.0808261839370.2423@shell2.speakeasy.net>
References: <48B4571C.1040207@free.fr>
MIME-Version: 1.0
Cc: Linux DVB Mailing List <linux-dvb@linuxtv.org>,
	Martin Michlmayr <tbm@cyrius.com>
Subject: Re: [linux-dvb] [PATCH] transform udelay to mdelay
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

On Tue, 26 Aug 2008, Thierry Merle wrote:
> > Right, I experienced the same problem with the em28xx (from mcentral.de)
> > driver compilation on my NSLU2 target.
> > I guess you are doing the same thing for this driver.
> > The solution was to use mdelay when possible.
> > It solves the compilation on these low-power-consuming-but-high-capacities targets.
> >
> Here is the patch I proposed, this should be harmless but I have no
> device to test them.

I think mdelay and udelay should be safe for this.  I know that generally
msleep(2) will produce a much shorter sleep than "msleep(1);msleep(1);"

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
