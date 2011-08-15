Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp23.services.sfr.fr ([93.17.128.21]:28284 "EHLO
	smtp23.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab1HOJZo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2011 05:25:44 -0400
Received: from filter.sfr.fr (localhost [127.0.0.1])
	by msfrf2311.sfr.fr (SMTP Server) with ESMTP id E5D48700B04B
	for <linux-media@vger.kernel.org>; Mon, 15 Aug 2011 11:24:51 +0200 (CEST)
Received: from smtp-in.softsystem.co.uk (133.98.30.93.rev.sfr.net [93.30.98.133])
	by msfrf2311.sfr.fr (SMTP Server) with SMTP id 9A8D7700B041
	for <linux-media@vger.kernel.org>; Mon, 15 Aug 2011 11:24:51 +0200 (CEST)
Received: FROM [192.168.1.62] (gagarin [192.168.1.62])
	BY smtp-in.softsystem.co.uk [93.30.98.133] (SoftMail 1.0.6, www.softsystem.co.uk) WITH ESMTP
	FOR <linux-media@vger.kernel.org>; Mon, 15 Aug 2011 11:24:50 +0200
Subject: Re: [mythtv-users] Anyone tested the DVB-T2 dual tuner TBS6280?
From: Lawrence Rust <lvr@softsystem.co.uk>
To: Discussion about MythTV <mythtv-users@mythtv.org>
Cc: linux-media@vger.kernel.org
In-Reply-To: <CAC3jWvLszU4gTSVW0mXUFrhnHCpPWRUqErytF9jXs39sbCJd3Q@mail.gmail.com>
References: <CAC3jWv+c1HOqmo0B18Z3vWOwjr=RoPrN7sfR3bqzz4Tw7=fPAQ@mail.gmail.com>
	 <1313226504.2840.22.camel@gagarin>
	 <CAC3jWvLszU4gTSVW0mXUFrhnHCpPWRUqErytF9jXs39sbCJd3Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Aug 2011 11:24:49 +0200
Message-ID: <1313400289.1648.22.camel@gagarin>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2011-08-14 at 17:50 +0200, Harald Gustafsson wrote:
> Thanks for sharing your experience.
> 
[snip]
> > Be warned that if you run a 2.6.38 or later kernel then the IR RC won't
> > work because of significant changes to the RC architecture that TBS
> > don't like (see http://www.tbsdtv.com/forum/viewtopic.php?f=22&t=929 and
> > http://www.tbsdtv.com/forum/viewtopic.php?f=22&t=110&start=90#p2693 )
> 
> In the links you refer to the driver author (at least he seems to be
> the author) states that he has not upgraded to the latest IR code due
> to compatibility issues between the CX23885 and IR.

The TBS cards use the same cx23885 device that the Hauppauge HVR 1250 &
1850 use, both of which support RC input.  The problem, as I understand
it, is that in some modes the cx23885 can produce an interrupt storm.

Given that the current v4l RC architecture is unlikely to change
significantly in the near future then instead of bleating, perhaps TBS
should contribute a fix.  However, given that to date all of TBS's code
has been kept private then that's unlikely.  So the TBS Linux drivers
are likely to become increasingly incompatible with current Linux
kernels.

I have a need to use my 6981 card so I'm developing my own fix for the
RC problem.  I'll post this to linuxmedia when I'm happy it's sound.

Incidentally, the latest TBS 6981 driver OOPS with linux 2.6.39 even
though their release note says "Ensure compatibility with latest
ArchLinux (with kernel 2.6.39.2-1)".  This is due to a change in an i2c
driver structure in 2.6.39 and is a direct consequence of TBS shipping
object modules built with old kernel headers.

Be warned, the h/w is sound but the software & support suck.

-- 
Lawrence


