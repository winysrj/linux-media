Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp21.services.sfr.fr ([93.17.128.3]:10685 "EHLO
	smtp21.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab1HMJPi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Aug 2011 05:15:38 -0400
Received: from filter.sfr.fr (localhost [127.0.0.1])
	by msfrf2113.sfr.fr (SMTP Server) with ESMTP id 28ED4700242D
	for <linux-media@vger.kernel.org>; Sat, 13 Aug 2011 11:08:27 +0200 (CEST)
Received: from smtp-in.softsystem.co.uk (220.94.30.93.rev.sfr.net [93.30.94.220])
	by msfrf2113.sfr.fr (SMTP Server) with SMTP id D5D7A7002399
	for <linux-media@vger.kernel.org>; Sat, 13 Aug 2011 11:08:26 +0200 (CEST)
Received: FROM [192.168.1.62] (gagarin [192.168.1.62])
	BY smtp-in.softsystem.co.uk [93.30.94.220] (SoftMail 1.0.6, www.softsystem.co.uk) WITH ESMTP
	FOR <linux-media@vger.kernel.org>; Sat, 13 Aug 2011 11:08:25 +0200
Subject: Re: [mythtv-users] Anyone tested the DVB-T2 dual tuner TBS6280?
From: Lawrence Rust <lvr@softsystem.co.uk>
To: Discussion about MythTV <mythtv-users@mythtv.org>
Cc: linux-media@vger.kernel.org
In-Reply-To: <CAC3jWv+c1HOqmo0B18Z3vWOwjr=RoPrN7sfR3bqzz4Tw7=fPAQ@mail.gmail.com>
References: <CAC3jWv+c1HOqmo0B18Z3vWOwjr=RoPrN7sfR3bqzz4Tw7=fPAQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Aug 2011 11:08:24 +0200
Message-ID: <1313226504.2840.22.camel@gagarin>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2011-08-09 at 12:35 +0200, Harald Gustafsson wrote:
> Hi,
> 
> I searched for a dual tuner PCI-e DVB-T2 card with Linux support and
> found this TBS6280 card:
> http://tbsdvb.blog.com/2011/07/22/tbs-6280-freeview-hd-twin-tuner-card/
> http://www.buydvb.net/tbs6280-pcie-dvbt2t-dual-tuner-card_p38.html
> http://www.tbsdtv.com/english/Download.html
> 
> Previously I have only found the blackgold product that state they
> will have Linux support but have not seen any drivers yet.
> 
> But when searching the mythtv lists and the linux dvb list I could not
> find anyone using it. Do anyone have any info about this card, does it
> work well with terrestrial DVB-T2 reception, is linux support working,
> does it work with mythtv, etc.

I haven't used the 6280 but I do have a 6981 (dual dvb-S2).

The driver is shipped as a mixture of source and pre-compiled object
files for their custom frontends.  You re-build all the v4l drivers 'out
of tree' using a v4l-media environment (see www.linuxtv.org/repo/) by
running 'sudo make install'.

The stock v4l sources supplied are old (from around 2.6.35) and don't
contain many current fixes.  This isn't a problem per-se unless you
intend to use the card with another v4l card.  In this case your brand
new, bug fixed drivers are replaced by TBS's version which may or, as in
my case, may not work.

I repeatedly mailed TBS support at support@tbsdtv.com to ask how I could
only install the 6981 driver but never got an answer.  In desperation I
setup a git tree of 2.6.35 and merged it with the TBS drivers in order
to separate their changes.  Finally after many hours I have a set of
patches that I can apply to 2.6.39 that produce a working driver.

Be warned that if you run a 2.6.38 or later kernel then the IR RC won't
work because of significant changes to the RC architecture that TBS
don't like (see http://www.tbsdtv.com/forum/viewtopic.php?f=22&t=929 and
http://www.tbsdtv.com/forum/viewtopic.php?f=22&t=110&start=90#p2693 )

Not for the faint hearted.

-- 
Lawrence


