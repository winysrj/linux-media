Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1JYqOU-0000j6-H8
	for linux-dvb@linuxtv.org; Mon, 10 Mar 2008 23:23:14 +0100
From: Nicolas Will <nico@youplala.net>
To: Filippo Argiolas <filippo.argiolas@gmail.com>
In-Reply-To: <1204487125.6799.16.camel@tux>
References: <1203434275.6870.25.camel@tux>
	<Pine.LNX.4.64.0802192208010.13027@pub6.ifh.de>
	<1203499665.7026.66.camel@tux>  <1204487125.6799.16.camel@tux>
Date: Mon, 10 Mar 2008 22:17:20 +0000
Message-Id: <1205187440.13685.25.camel@youkaida>
Mime-Version: 1.0
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [patch] support for key repeat with
	dib0700	ir	receiver
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


On Sun, 2008-03-02 at 20:45 +0100, Filippo Argiolas wrote:
> Il giorno mer, 20/02/2008 alle 10.29 +0100, Filippo Argiolas ha scritto:
> 
> > I don't know yet how this could be done and maybe it involves some work
> > rewriting the ir stuff. So I think in the meanwhile my patch could be
> > merged (if you think it's good) waiting for this work to be done.
> 
> Hi all,
> it's been a while since I've posted this patch. Looking at the whole
> thread the overall impression is that it works properly. No one
> complained about it causing any trouble. Many users tested it and
> reported it works good. I've been using it during this time and it seems
> fine to me. It also fixed the annoying bug that flooded syslog with
> unknown key messages.
> So what does it need to be merged? Is a post in this list the proper way
> to ask for inclusion? I'm not familiar to mercurial so I've created the
> patch as I would do with a svn with "hg diff", it something wrong with
> it? Is there a better way to produce a patch for submission?
> I've attached a new patch where I've removed the keymaps I've used for
> testing since these are not complete and I doubt anyone could find them
> useful.
> Please let me know what you think about it, thanks!
> Best regards,
> 

Filippo,

I have just read that:

> The procedure is simple: after having it worked and tested, for its
> inclusion, you'll need to send it to the DVB ML (also, to V4L ML, if
hybrid). 
> The better is to c/c me on the e-mail you submit it, for me to be
> aware of. After some days, if nobody complains, and if it looks ok,
I'll commit.
> 
> Cheers,
> Mauro


Maybe you will want to do it.

Nico


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
