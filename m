Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-05.arcor-online.net ([151.189.21.45])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1LJOMi-0002ak-RG
	for linux-dvb@linuxtv.org; Sun, 04 Jan 2009 09:29:46 +0100
From: hermann pitton <hermann-pitton@arcor.de>
To: Goga777 <goga777@bk.ru>
In-Reply-To: <20090104111429.1f828fc8@bk.ru>
References: <op.um6wpcvirj95b0@localhost>
	<c74595dc0901030928r7a3e3353h5c2a44ffd8ffd82f@mail.gmail.com>
	<op.um60szqyrj95b0@localhost>
	<c74595dc0901031058u3ad48036y2e09ec1475174995@mail.gmail.com>
	<20090103193718.GB3118@gmail.com>  <20090104111429.1f828fc8@bk.ru>
Date: Sun, 04 Jan 2009 09:29:44 +0100
Message-Id: <1231057784.2615.9.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVB-S Channel searching problem
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


Am Sonntag, den 04.01.2009, 11:14 +0300 schrieb Goga777:
> > I would suggest not using S2API as it's seems to be broken for our card
> > at this time, 
> 
> why do you think so ? 
> 
> >I did test steven s2 repo which is better that all other
> > S2API repo 
> 
> have you tested http://mercurial.intuxication.org/hg/s2-liplianin ?
> 
> >I have tested but still worse than lipliandvb (multiproto
> > hg).
> 
> please try 
> 
> http://mercurial.intuxication.org/hg/s2-liplianin (yesterday Igor synchronized it with current v4l-dvb)
> +
> http://hg.kewl.org/dvb2010/ - new dvb scaner 
> 
> for me everything is working without any problem with my hvr4000. Also patched vdr 170 works well with s2api
> 
> 
> Goga
> 

Hi,

thanks.

We else need at least i2c_debug enabled on the cx88xx, yes, that is the
busmaster :)

I don't deny that strange things happened, wrong tuners loaded without
trace so far.

Mike at least had a hotfix, not to allow analog only tuners to oops
around.

Cheers,
Hermann





_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
